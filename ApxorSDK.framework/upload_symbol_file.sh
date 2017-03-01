#!/bin/bash

appid="13f4202f-e96e-4649-be34-ee21704aecd6"
apxorServer="http://server.apxor.com"

##If Debug config then skip it
if [ "$CONFIGURATION" == "Debug" ]; then
    echo "[Apxor] Skipping upload dSYM in debug build"
    exit 0;
fi

##If simulator build then skip it
if [ "$EFFECTIVE_PLATFORM_NAME" == "-iphonesimulator" ]; then
    echo "[Apxor] Skipping upload dSYM for simulator build"
    exit 0;
fi

##The path for the dSYM
DSYM_PATH=${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}

DSYM_ZIP_PATH=${DWARF_DSYM_FILE_NAME}.zip

##Check whether dir exists
if [ -d "$DSYM_PATH" ]; then
    
    ##Zip the file 
    pushd "$DWARF_DSYM_FOLDER_PATH"

     ##Remove file If exists
     if [ -f $DSYM_ZIP_PATH ]; then
         rm $DSYM_ZIP_PATH
     fi
 
     zip -q -r $DSYM_ZIP_PATH $DWARF_DSYM_FILE_NAME
    
    popd

    DSYM_ZIP_PATH=${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}.zip

    uuids=(`symbols -uuid $DSYM_PATH/Contents/Resources/DWARF/$TARGET_NAME | awk '{ print $1 };'`)
                                                   
    temp=`echo ${uuids[*]}`

    first=1
    data="["
    for uuid in `echo $temp`; do
      if [ $first -eq 1 ]; then
        data=$data\"$uuid\"
        first=0
      else
        data=$data','\"$uuid\"
      fi
    done
    data=$data"]"
    echo $data

    curl --silent -F "uuids=$data" -F "file_data=@$DSYM_ZIP_PATH" "$apxorServer/v1/api/apps/"$appid"/symbol-files"

    rm $DSYM_ZIP_PATH

##If dir doesn't exist then exit 
else
    echo "[Apxor] Couldn't find $DSYM_PATH directory"
    exit 0;
fi
