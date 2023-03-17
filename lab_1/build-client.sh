#!/usr/bin/env bash

PARENT_BUILD_FOLDER=$1

if [ -z $1 ];
then
    PARENT_BUILD_FOLDER=$(pwd)
fi

pre_install_check() {
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

    if [ -f dist/client-app.zip ];
    then
        rm dist/client-app.zip
    fi
}

run_npm_install() {
    echo "Installing node packages..."

    npm install
}

run_build() {
    echo "Running build..."

    export ENV_CONFIGURATION=production

    npm run build --configuration
}

compile_zip() {
    echo "Creating zip file..."

    zip -r dist/client-app.zip dist
}

pre_install_check
run_npm_install
run_build
compile_zip
