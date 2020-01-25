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

# get repo name basename -s .git `git config --get remote.origin.url`

# now build the veriables for replacing
RELEASE_TYPE=''
echo "************ select the release type ************"
echo "  1)HotFix"
echo "  2)BugFix"
echo "  3)Feature"
echo "  4)Patch" 
read n
case $n in
  1) RELEASE_TYPE='HotFix';;
  2) RELEASE_TYPE='BugFix';;
  3) RELEASE_TYPE='Feature';;
  4) RELEASE_TYPE='Patch';;
  *) echo "invalid option";;
esac

# current date
CURRENT_DATE="$(date +'%d-%m-%Y')"

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
RELEASE_COMMITS=$(<$MYDIR/log.log)
echo "$RELEASE_COMMITS" 

# to print out stuffs
cat release-templase.tmd | sed s/\<relese_date\>/$CURRENT_DATE/ | sed s/\<release_type\>/$RELEASE_TYPE/ | sed s/\<relese_tag\>/$NEW_TAG/ | sed s/\<release_log\>/$RELEASE_COMMITS/


#TODO:  remove this
eval "git tag -d $NEW_TAG"