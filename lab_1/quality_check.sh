#!/usr/bin/env bash

PARENT_BUILD_FOLDER=$1

if [ -z $1 ];
then
    PARENT_BUILD_FOLDER=$(pwd)
fi

pre_i_check() {
    if [ ! -d $PARENT_BUILD_FOLDER ];
    then
        echo "Project does not exists."
        exit
    else     
        cd $PARENT_BUILD_FOLDER

        if [ ! -f package.json ];
        then
            echo "No package.json found in project."
            exit
        fi
    fi
}



pre_i_check
npm test -- --watch-false
npm run lint
npm audit
