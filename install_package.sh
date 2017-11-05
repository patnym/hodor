#!bin/bash

HODOR_RC_PATH="$HOME/.hodor"
BASHRC_SOURCE="source $HODOR_RC_PATH/exec.sh"

#DIR
if [ ! -d $HODOR_RC_PATH ]   
then
    mkdir $HODOR_RC_PATH
    echo "~/.hodor folder created, copying files.."
else
    echo "Hodor already seems to be installed, aborting.."
    exit
fi

#Move files
cp ./exec.sh $HODOR_RC_PATH/
cp ./hodor.sh $HODOR_RC_PATH/

echo "Files copied, setting up .bashrc.."

if [ -f "$HOME/.bashrc" ]
then
    output=$(cat $HOME/.bashrc | grep -e "$BASHRC_SOURCE")
    if [ -z "$output" ]
    then
        echo $BASHRC_SOURCE >> "$HOME/.bashrc"        
        echo "Added hodor to .bashrc.."
    else
        echo "Hodor already setup in bashrc. Not adding!"
    fi
else
    echo "Couldn't locate .bashrc, hodor package installer only supports bash atm. Exiting!'"
    rm -rf $HODOR_RC_PATH
    exit
fi

echo "Finished installing!"