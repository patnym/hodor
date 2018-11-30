hodor()
{
    HODOR_PATH=$(${SHELL} "${HOME}"/.hodor/hodor.sh $@)
    if [ -n "${HODOR_PATH}" ] 
    then
    	echo "Hello"
        cd "${HODOR_PATH}"
    fi
}
