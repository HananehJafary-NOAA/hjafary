# .bashrc

#if [ "$PS1" ]; then
#	echo "here in .bashrc"
#	PS1="[\H \w]\$ "
if [ "$mycluster" ]; then
	echo $mycluster
	mycluster="I'm in"
fi

TERM=xterm

export PATH=./:$PATH:/usr/bin:/usr/sbin:/etc:$HOME/bin

# prevent escaping of command line vars

shopt -s progcomp

#aliases
alias ptmp='cd /lfs/h2/emc/ptmp/hananeh.jafary'
alias stmp='cd /lfs/h2/emc/stmp/hananeh.jafary'
alias cdnoscrubv='cd /lfs/h2/emc/vpppg/noscrub/hananeh.jafary'
alias cdnoscrube='cd /lfs/h2/emc/ens/noscrub/hananeh.jafary'
alias cdsavee='cd /lfs/h2/emc/ens/save/hananeh.jafary'
alias ens='cd /lfs/h1/ops/prod/packages/ens_tracker.v1.3.5'
alias gen='cd /lfs/h1/ops/prod/packages/gentracks.v3.5.5'
alias package='cd /lfs/h1/ops/prod/packages'  # ENS and GEN pack
alias com='cd /lfs/h1/ops/prod/com'           # Model outputs
alias optl='cd /lfs/h1/ops/prod/output'       # Output log files
export HISTTIMEFORMAT="%d/%m/%y %T "
alias his='history'
alias hisgrep='history | grep'
alias lst='ls -lhrt --color=auto'
alias la='ls -AC'
alias ll='ls -l'
alias ls='ls -CF'
alias lsa='ls -al'
alias grso='git remote show origin'

# ---------------------------------------Jobs---------------------------------#

#scancel to kill the job
alias sq='squeue -u $USER -o "%.10i %.10P %.50j %.15u %.10T %.10M %.10L %.4D %R"'
alias sqq='date ; squeue -o "%.10i %.10P %.50j %.15u %.10T %.10M %.10L %.4D %R" -u '
alias sjob='scontrol show job'
alias qq='qstat -u $USER'
alias qqw='qstat -tu $USER -w'
#skill to kill the job

# --------------------------------------Modules------------------------------------ #

module load intel/19.1.3.304
module load libjpeg/9c
module load prod_envir/2.0.6
module load prod_util/2.0.13
module load grib_util/1.2.2

module load wgrib2/2.0.8
module load python/3.8.6

module load proj/7.1.0
module load geos/3.8.1
module load imagemagick/7.0.8-7

module load g2/3.4.5
module load zlib/1.2.11
module load libpng/1.6.37
module load bacio/2.4.1
module load w3emc/2.9.1
module load w3nco/2.4.1
module load jasper/2.0.25

module load netcdf/4.7.4
module load hdf5/1.10.6

module use /apps/test/lmodules/core/
module load GrADS/2.2.2

module use /apps/ops/test/nco/modulefiles
module load core/rocoto/1.3.5

cat /etc/cluster_name
