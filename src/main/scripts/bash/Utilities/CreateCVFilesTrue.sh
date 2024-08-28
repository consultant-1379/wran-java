#!/bin/bash


getSimType()
{
    MY_SIM=$1

    TYPE="UNKNOWN"
    echo ${MY_SIM} | grep -v TD | grep RNC > /dev/null
    if [ $? -eq 0 ] ; then
        echo "WRAN"
        return
    fi

    echo ${MY_SIM} | grep LTE > /dev/null
    if [ $? -eq 0 ] ; then
        echo "LTE"
        return
    fi

    echo ${MY_SIM} | grep TD > /dev/null
    if [ $? -eq 0 ] ; then
        echo "TD"
        return
    fi

    echo "UNKNOWN"
    return
}


createCvFiles() {

	CMD_FILE=/tmp/createCvFilesSetToTrue.cmd
	if [ -r ${CMD_FILE} ] ; then
        rm ${CMD_FILE}
    fi

    for SIM in $LIST ; do
    # WRAN
        SIM_TYPE=`getSimType ${SIM}`
        echo $SIM_TYPE
        SIM_NAME=`ls /netsim/netsimdir | grep ${SIM} | grep -v zip`
        echo $SIM_NAME
        if [ "${SIM_TYPE}" = "WRAN" ] ; then
            cat >> ${CMD_FILE} <<EOF


.open ${SIM_NAME}
.select network
setswinstallvariables:createCVFiles=true; 

EOF
 fi
    done

    log "INFO: Setting createCVFiles attribute to true"
    /netsim/inst/netsim_pipe < ${CMD_FILE}
}

LIST=`ls -ltr /netsim/netsimdir/ |egrep 'LTE|ERBS|WRAN|RNC|RBS|RXI' | tr -s " " | cut -d " " -f 9 | grep -iv "zip"`

createCvFiles

