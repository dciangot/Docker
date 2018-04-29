export RELEASE=3.3.1803.patch2
export REPO=comp
export MYTESTAREA=/data/srv/TaskManager/$RELEASE
export SCRAM_ARCH=slc7_amd64_gcc630
export verbose=true
mkdir -p $MYTESTAREA
wget -O $MYTESTAREA/bootstrap.sh http://cmsrep.cern.ch/cmssw/repos/bootstrap.sh
sh $MYTESTAREA/bootstrap.sh -architecture $SCRAM_ARCH -path $MYTESTAREA -repository $REPO setup
$MYTESTAREA/common/cmspkg -a $SCRAM_ARCH upgrade
$MYTESTAREA/common/cmspkg -a $SCRAM_ARCH update
$MYTESTAREA/common/cmspkg -a $SCRAM_ARCH install cms+crabtaskworker+$RELEASE

