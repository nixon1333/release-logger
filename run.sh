#!/bin/bash 

###################################################################
#Script Name	: run.sh                                                                                      
#Description	: awesome release logger. A script for generate release log/change log
#                from git history.
#Args         :                                                                                           
#Author       : Nixon <nixon613@gmail.com>
###################################################################


# get current dir
MYDIR="$(dirname "$(which "$0")")"

# get the latest tag
LATEST_TAG_HASH="$(git rev-list --tags --max-count=1)"
# echo $LATEST_TAG

# basic diff command
DIFF_COMMAND="git log --format='%h (%ai) %s' "

# check if latest tag is there
if [ "${LATEST_TAG_HASH}" == "" ]; then
  # no tag found
  echo 'no tag found' 
else
  LATEST_TAG="$(git describe --tags $LATEST_TAG_HASH)"
  echo "Tag found! You current tag is $LATEST_TAG"
  DIFF_COMMAND="$DIFF_COMMAND $LATEST_TAG..."
fi

# now get the latest tag
read -p "Enter Your New Tag no: " NEW_TAG

# make the tag creation command
TAG_CREATE="git tag $NEW_TAG"

# create the tag
eval $TAG_CREATE

# now push the tag
# TAG_PUSH="git push origin $NEW_TAG"
# eval $TAG_PUSH

# now get the diff
DIFF_COMMAND="$DIFF_COMMAND$NEW_TAG > log.log"

# run the diff command
eval $DIFF_COMMAND

# show the log file in terminal
eval "cat $MYDIR/log.log"


# get repo name basename -s .git `git config --get remote.origin.url`