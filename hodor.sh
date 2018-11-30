#!/bin/sh
#Title: hodor
#Author: Patrik Nyman
#Description: Shell based path shortcuts
VERSION="0.1.0"
TITLE="hodor"
DESCRIPTION="Create simple shell shortcuts to help navigation.
If only typing hodor it will navigate to the specified temp path, set temp path by calling hodor -s
If you call hodor <alias> it will navigate to the path set by that alias."
USAGE="Usage: hodor [alias] [-s [alias]] [-lh]"

EXP_H="-h           Prints this message"
EXP_L="-l           List all saved shortcuts"
EXP_S="-s [alias]   If alias is specified save current PWD to alias, otherwise store in temp. Will override an alias if it already exists."

HODOR_RC_PATH="${HOME}/.hodor"
HODOR_ALI_FILE="hodor_alias.cfg"
HODOR_TMP_FILE="hodor_now.tmp"

print_help()
{
echo "$TITLE - v$VERSION
$DESCRIPTION
$USAGE
$EXP_H
$EXP_L
$EXP_S" 1>&2
}

#Creates and inits the dir
init() 
{
    #DIR
    if [ ! -d "${HODOR_RC_PATH}" ]   
    then
        mkdir "${HODOR_RC_PATH}"
    fi

    #FILES
    if [ ! -f "${HODOR_RC_PATH}/${HODOR_ALI_FILE}" ]
    then
        touch "${HODOR_RC_PATH}/${HODOR_ALI_FILE}"
    fi

    if [ ! -f "${HODOR_RC_PATH}/${HODOR_TMP_FILE}" ]
    then
        touch "${HODOR_RC_PATH}/${HODOR_TMP_FILE}"
    fi
}

# Save path
save_alias()
{
    if [ -z $1 ]
    then
        #return_echo "Saving temp path $PWD"
        save_n_override_alias $HODOR_TMP_FILE temp $PWD
    else
        echo "Saving alias $1" 1>&2
        save_n_override_alias $HODOR_ALI_FILE $1 $PWD
    fi
}

#Opens file and writes the new alias to file, will override an existing alias
save_n_override_alias()
{   
    found="$(cat "${HODOR_RC_PATH}/$1" | grep -e "$2=")"
    if [ -z "$found" ]
    then
        echo "$2=$3" >> "${HODOR_RC_PATH}/$1"
    else
        sed -i "/${2}=/c\\${2}=${3}" "${HODOR_RC_PATH}/$1"
    fi
}

list_aliases()
{
    echo $(cat "${HODOR_RC_PATH}/${HODOR_TMP_FILE}") 1>&2
    while IFS='' read -r line || [[ -n "$line" ]]; do
        echo "$line" 1>&2
    done < "${HODOR_RC_PATH}/${HODOR_ALI_FILE}"
}

# Load path
load_path() 
{
    hodor_p="$(cat "${HODOR_RC_PATH}/$1" | grep -Po "(?<=$2=).*")"
    echo $hodor_p
}

# Return
return_path() 
{
    echo $1
}

return_echo()
{
    echo $1 1>&2
}

#Create any files or dirs that might be missing
init

if [ $# == 0 ]
then
    #Emtpy arguement list, try to get the temp path and cd
    output=$(load_path "${HODOR_TMP_FILE}" temp)
    if [ -z "$output" ]
    then    
        echo "No nameless path exists, type hodor -s without arguements to store a temp path" 1>&2
        exit
    else
        return_path $output
        exit
    fi
fi

# Parse save command
while getopts ":vhls:" opt; do
    case ${opt} in
        s )
            save_alias $OPTARG
            exit
            ;;
        l )
            list_aliases
            exit
            ;;
        h )
            print_help
            exit
            ;;
        \? )
            echo "Invalid option args: $OPTARG" 1>&2
            exit
            ;;
        v )
            echo $VERSION 1>&2
            exit
            ;;
        : )
            save_alias
            exit
            ;;
    esac
done
shift "$((OPTIND-1))"

# Last thing we do is consider the subcommand an alias
subcommand=$1
output=$(load_path "${HODOR_ALI_FILE}" $subcommand)
if [ -z "$output" ]
then    
    echo "Alias: $subcommand doesnt exist" 1>&2
else
    return_path $output
fi
