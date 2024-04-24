#!/bin/bash
#---- GFS TRACK file on TAPE ----------------------
#/NCEPPROD/hpssprod/runhistory/2year/rh2023/202310/20231023/com_ens_tracker_v1.3_gfs.20231023.tar

export outdir=/scratch2/NCEPDEV/stmp/Jiayi.Peng

yymm=202309
#export daylist="01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31"
export daylist="30"
export cyclist="00"
#######################################################
for nday in $daylist; do
for ncyc in $cyclist; do
  mkdir -p ${outdir}/gfs_track.${yymm}${nday}
  cd ${outdir}/gfs_track.${yymm}${nday}
  #htar -xv -f /NCEPPROD/hpssprod/runhistory/rh2023/${yymm}/${yymm}${nday}/com_gfs_v16.3_gfs.${yymm}${nday}_${ncyc}.gfs_pgrb2.tar
  htar -xv -f /NCEPPROD/hpssprod/runhistory/2year/rh2023/${yymm}/${yymm}${nday}/com_ens_tracker_v1.3_gfs.${yymm}${nday}.tar
done
done
