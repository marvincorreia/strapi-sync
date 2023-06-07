#!/bin/bash
BRANCH="main" #change this if necessary
git checkout $BRANCH
git add .
DATE=$(date '+%Y-%m-%d %H:%M:%S')
git commit -m "Updates on $DATE"
git pull origin $BRANCH
git push origin $BRANCH