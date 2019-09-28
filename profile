# /etc/profile

# System wide environment and startup programs, for login setup
# Functions and aliases go in /etc/bashrc

# It's NOT a good idea to change this file unless you know what you
# are doing. It's much better to create a custom.sh shell script in
# /etc/profile.d/ to make custom changes to your environment, as this
# will prevent the need for merging in future updates.

pathmunge () {
    case ":${PATH}:" in
        *:"$1":*)
            ;;
        *)
            if [ "$2" = "after" ] ; then
                PATH=$PATH:$1
            else
                PATH=$1:$PATH
            fi
    esac
}


if [ -x /usr/bin/id ]; then
    if [ -z "$EUID" ]; then
        # ksh workaround
        EUID=`/usr/bin/id -u`
        UID=`/usr/bin/id -ru`
    fi
    USER="`/usr/bin/id -un`"
    LOGNAME=$USER
    MAIL="/var/spool/mail/$USER"
fi

# Path manipulation
if [ "$EUID" = "0" ]; then
    pathmunge /usr/sbin
    pathmunge /usr/local/sbin
else
    pathmunge /usr/local/sbin after
    pathmunge /usr/sbin after
fi

HOSTNAME=`/usr/bin/hostname 2>/dev/null`
HISTSIZE=1000
if [ "$HISTCONTROL" = "ignorespace" ] ; then
    export HISTCONTROL=ignoreboth
else
    export HISTCONTROL=ignoredups
fi

export PATH USER LOGNAME MAIL HOSTNAME HISTSIZE HISTCONTROL

# By default, we want umask to get set. This sets it for login shell
# Current threshold for system reserved uid/gids is 200
# You could check uidgid reservation validity in
# /usr/share/doc/setup-*/uidgid file
if [ $UID -gt 199 ] && [ "`/usr/bin/id -gn`" = "`/usr/bin/id -un`" ]; then
    umask 002
else
    umask 022
fi

for i in /etc/profile.d/*.sh ; do
    if [ -r "$i" ]; then
        if [ "${-#*i}" != "$-" ]; then 
            . "$i"
        else
            . "$i" >/dev/null
        fi
    fi
done

unset i
unset -f pathmunge




#################setting for language English#############
export LANG=en_US.UTF-8



#####Setting for Intel Compiler#####
source /opt/intel/icc/composer_xe_2013.3.163/bin/iccvars.sh intel64
source /opt/intel/icc/composer_xe_2013.3.163/bin/ifortvars.sh intel64
source /opt/intel/icc/composer_xe_2013.3.163/bin/intel64/idbvars.sh intel64
source /opt/intel/icc/composer_xe_2013.3.163/mkl/bin/intel64/mklvars_intel64.sh intel64
#####Setting for mpich2#####
#export PATH=/opt/software/mpich2-gnu/bin:$PATH
#export PATH=/opt/software/mpich2-gnu/sbin:$PATH
#export LD_LIBRARY_PATH=/opt/software/mpich2-gnu/lib:$LD_LIBRARY_PATH
export PATH=/opt/software/mpich2-intel/bin:$PATH
export PATH=/opt/software/mpich2-intel/sbin:$PATH
export LD_LIBRARY_PATH=/opt/software/mpich2-intel/lib:$LD_LIBRARY_PATH
#####Setting for torque#####
export PATH=/opt/software/torque-4.2.8/bin:$PATH
export PATH=/opt/software/torque-4.2.8/sbin:$PATH
export LD_LIBRARY_PATH=/opt/software/torque-4.2.8/lib:$LD_LIBRARY_PATH
export PATH=/opt/software/maui-3.3.1/bin:$PATH
export PATH=/opt/software/maui-3.3.1/sbin:$PATH
export LD_LIBRARY_PATH=/opt/software/maui-3.3.1/lib:$LD_LIBRARY_PATH
#####Setting for scilib#####
export PATH=/opt/software/scilab-5.3.3/bin:$PATH
#####Setting for xcrysden#####
export PATH=/opt/software/xcrysden-1.5.53:$PATH
export LD_LIBRARY_PATH=/opt/software/maui-3.3.1/lib:$LD_LIBRARY_PATH
#####Setting for code_aster#####
export PATH=/opt/software/aster/bin:$PATH
#####setting for opensees#####
export PATH=/opt/software/opensees/OpenSees:$PATH
#####setting for salome#####
export PATH=/opt/software/SALOME-8.3.0-CO7:$PATH

#############abaqus#############
export LD_LIBRARY_PATH=/opt/amdgpu-pro/lib64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/opt/intel/ism/lib/intel64:$LD_LIBRARY_PATH
alias abaqus='XLIB_SKIP_ARGB_VISUALS=1 /opt/simulia/Commands/abaqus cae -mesa'


################ansys####################
export PATH=/opt/ansys_inc/v180/ansys/bin:$PATH
export LD_LIBRARY_PATH=/opt/ansys_inc/v180/ansys/lib/linx64:$LD_LIBRARY_PATH
export PATH=/opt/ansys_inc/v180/fluent/bin:$PATH
export LD_LIBRARY_PATH=/opt/ansys_inc/v180/fluent/lib:$LD_LIBRARY_PATH
export PATH=/opt/ansys_inc/v180/Framework/bin/Linux64:$PATH



######################matlab#############
export PATH=/opt/MATLAB/R2017a/bin:$PATH


#OpenFOAM##########
export LD_LIBRARY_PATH=/opt/OpenFOAM-5.0/platforms/linux64GccDPInt32Opt/lib:$LD_LIBRARY_PATH
#openmpi
export LD_LIBRARY_PATH=/opt/OpenFOAM-5.0/platforms/linux64GccDPInt32Opt/lib/openmpi-system:$LD_LIBRARY_PATH

