#!/bin/bash

DEV_PATH="/Users/rymo/Sites/rymo.io/blog/src/_dev"
REPO1_PATH="https://github.com/MozMorris/tomorrow-pygments/trunk/css/tomorrow.css"
REPO2_PATH="https://github.com/MozMorris/tomorrow-pygments/trunk/css/tomorrow_night.css"
TEST1=$(svn ls $REPO1_PATH)
TEST2=$(svn ls $REPO2_PATH)

if [[ $TEST1 = "tomorrow.css" ]]; then
    cd $DEV_PATH
    mkdir -p css
    cd css
    svn export $REPO1_PATH --force
fi

if [[ $TEST2 = "tomorrow_night.css" ]]; then
    cd $DEV_PATH
    mkdir -p css
    cd css
    svn export $REPO2_PATH --force
fi