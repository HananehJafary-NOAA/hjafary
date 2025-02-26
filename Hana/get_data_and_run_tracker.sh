#!/bin/bash
#PBS -N download_gefs_data
#PBS -j oe
#PBS -A ENSTRACK-DEV
#PBS -q dev_transfer
#PBS -S /bin/bash
#PBS -l select=1:ncpus=1:mem=40GB
#PBS -l walltime=00:30:00
#PBS -l debug=true

module load intel
module load wgrib2

export edate=2005091900

# Setup environment variables
export yy=`echo $edate | cut -c1-4`
export mm=`echo $edate | cut -c5-6`
export dd=`echo $edate | cut -c7-8`
export cyc=`echo $edate | cut -c9-10`
export PDY=${yy}${mm}${dd}

#DOWNLOAD DATA STEP
#--------------------------------------------------------------------------------------------------------------------------------------
echo "DOWNLOAD STARTING"
export GEFStape=/NCEPDEV/emc-ensemble/5year/emc.ens/WCOSS2/EP6/${PDY}${cyc}
export WORKdir=/lfs/h2/emc/hur/noscrub/andrew.hazelton/EP6
export wgrib2x=/apps/ops/prod/libs/intel/19.1.3.304/wgrib2/2.0.8/bin/wgrib2
cd $WORKdir
\rm tempa
\rm tempb

export incr=3
export fcstlen=240
export fcsthrs=$(seq -f%03g -s' ' 3 $incr $fcstlen)
export memlist="00 01 02 03 04 05 06 07 08 09 10"


for mem in $memlist; do
  for fhr in $fcsthrs; do
      echo gefs.${PDY}/${cyc}/mem0${mem}/products/atmos/grib2/0p25/gefs.t${cyc}z.pgrb2.0p25.f${fhr} >> tempa
      echo gefs.${PDY}/${cyc}/mem0${mem}/products/atmos/grib2/0p25/gefs.t${cyc}z.pgrb2b.0p25.f${fhr} >> tempb
  done
done

htar -xvf $GEFStape/gefs_atmos.tar -L tempa
htar -xvf $GEFStape/gefs_atmos.tar -L tempb

mkdir -p $WORKdir/gefs.${PDY}
cd $WORKdir/gefs.${PDY}
cp -r ${WORKdir}/gefs.${PDY}/00/mem0*/atmos/grib2/0p25/ .
echo "DOWNLOAD COMPLETE"
#---------------------------------------------------------------------------------------------------------------------------------------

#RENAME GEFS STEP
#---------------------------------------------------------------------------------------------------------------------------------------
echo "RENAMING STARTING"
export WORKdir=/lfs/h2/emc/hur/noscrub/andrew.hazelton/EP6/gefs.${PDY}/${cyc}/
cd $WORKdir

for i in {000..010}; do
  # Define the current folder name
  folder="mem${i}"

  product_folder="${folder}/products/atmos/grib2/0p25"
  if [ -d "$product_folder" ]; then
    if [ "$i" -eq "000" ]; then
      prefix="gep00"
    else
      prefix="gep$(printf "%02d" "$(echo "$i" | sed 's/^0*//')")"
    fi

    for file in "$product_folder"/*; do
      filename=$(basename "$file")
      new_filename=$(echo "$filename" | sed "s/^gefs/$prefix/")
      if [ "$filename" != "$new_filename" ]; then
        mv "$PWD/$product_folder/$filename" "$WORKdir/$new_filename"
      fi
    done
  else
    echo "Folder $folder does not exist."
  fi
done

echo "RENAMING COMPLETE"
#---------------------------------------------------------------------------------------------------------------------------------------

#FORECAST HOUR 00 STEP
#---------------------------------------------------------------------------------------------------------------------------------------
echo "HOUR00 STARTING"
export memlist="00 01 02 03 04 05 06 07 08 09 10"
export WORKdir=/lfs/h2/emc/hur/noscrub/andrew.hazelton/EP6/gefs.${PDY}/${cyc}/
cd $WORKdir

export wgrib2x=/apps/ops/prod/libs/intel/19.1.3.304/wgrib2/2.0.8/bin/wgrib2
for mem in $memlist; do
  $wgrib2x gep${mem}.t${cyc}z.pgrb2b.0p25.f003 -set_ftime anl -grib gep${mem}.t${cyc}z.pgrb2b.0p25.f000
done

for mem in $memlist; do
          $wgrib2x gep${mem}.t${cyc}z.pgrb2.0p25.f003 -set_ftime anl -grib gep${mem}.t${cyc}z.pgrb2.0p25.f000
  done
echo "HOUR00 COMPLETE"
#---------------------------------------------------------------------------------------------------------------------------------------

#MOVE THE DATA TO THE RIGHT DIRECTORIES FOR THE TRACKER
#---------------------------------------------------------------------------------------------------------------------------------------
echo "MOVE STARTING"
\cd /lfs/h2/emc/hur/noscrub/andrew.hazelton/EP6/
\mkdir -p /lfs/h2/emc/hur/noscrub/andrew.hazelton/EP6/gefs.${PDY}/pgrb2ap5/
\mkdir -p /lfs/h2/emc/hur/noscrub/andrew.hazelton/EP6/gefs.${PDY}/pgrb2bp5/
\mv /lfs/h2/emc/hur/noscrub/andrew.hazelton/EP6/gefs.${PDY}/00/gep*.t00z.pgrb2.0p25.f* gefs.${PDY}/pgrb2ap5/
\mv /lfs/h2/emc/hur/noscrub/andrew.hazelton/EP6/gefs.${PDY}/00/gep*.t00z.pgrb2b.0p25.f* gefs.${PDY}/pgrb2bp5/
echo "MOVE COMPLETE"
#---------------------------------------------------------------------------------------------------------------------------------------

#RUN THE TRACKER
#---------------------------------------------------------------------------------------------------------------------------------------
echo "TRACKER SUBMISSION STARTING"
\cd /lfs/h2/emc/hur/noscrub/andrew.hazelton/ens_tracker.v1.4.5/jobs/
sed "s/DATETEMP/${PDY}/g" JGEFS_TC_TRACK_TEMP > JGEFS_TC_TRACK

\cd /lfs/h2/emc/hur/noscrub/andrew.hazelton/ens_tracker.v1.4.5/ecf/
qsub jgefs_tc_track.ecf
echo "TRACKER SUBMISSION COMPLETE"
#---------------------------------------------------------------------------------------------------------------------------------------
