hodor()
{
    HODOR_PATH=$(${SHELL} ~/Development/hodor/hodor.sh $@)
    if [ -n "$HODOR_PATH" ] 
    then
        cd $HODOR_PATH
    fi
}