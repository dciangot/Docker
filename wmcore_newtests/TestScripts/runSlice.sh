#! /bin/bash

if [ -z "$1" -o -z "$2" ]; then
  echo "Not all necessary environment variables set: Two parameters for slice and number of slices"
  exit 1
fi

echo Running slice $1 of $2
set -x

# Make sure we the certs we use are readable by us and only us

/home/dmwm/ContainerScripts/fixCertificates.sh

# Start up services (Couch and MySQL)

source ./env_unittest.sh
$manage start-services

pushd /home/dmwm/wmcore_unittest/WMCore/

# Make sure we base our tests on the latest Jenkins-tested master

git fetch --tags
git pull
export LATEST_TAG=`git tag |grep JENKINS| sort | tail -1`

# Find the commit that represents the tip of the PR the latest tag
if [ -z "$ghprbPullId" ]; then
  export COMMIT=$LATEST_TAG
else
  git config remote.origin.url https://github.com/dmwm/WMCore.git
  git fetch origin pull/${ghprbPullId}/merge:PR_MERGE
  export COMMIT=`git rev-parse "PR_MERGE^{commit}"`
fi

# First try to merge this PR into the same tag used for the baseline
# If it doesn't merge, just test the tip of the branch
(git checkout $LATEST_TAG && git merge $COMMIT) ||  git checkout -f $COMMIT

# Run tests and watchdog to shut it down if needed
export USER=`whoami`
/home/dmwm/cms-bot/DMWM/TestWatchdog.py &
python setup.py test --buildBotMode=true --reallyDeleteMyDatabaseAfterEveryTest=true --testCertainPath=test/python --testTotalSlices=$2 --testCurrentSlice=$1

# Save the results

cp nosetests.xml /home/dmwm/artifacts/nosetests-$1.xml

popd
