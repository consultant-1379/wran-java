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


createScanners() {
    
    CMD_FILE=/tmp/create_scanners.cmd
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
.genreffilecpp wcdma Fileset.GPEH gpeh default
.genreffilecpp wcdma Fileset.STATS stats default
.genreffilecpp wcdma Fileset.CTR ctr default
.genreffilecpp wcdma Fileset.UETR uetr default
.selectnetype RNC
createscanner2:id=1,measurement_name="PREDEF.10000.UETR",file="Fileset.UETR";
createscanner2:id=2,measurement_name="PREDEF.10001.UETR",file="Fileset.UETR";
createscanner2:id=3,measurement_name="PREDEF.10002.UETR",file="Fileset.UETR";
createscanner2:id=4,measurement_name="PREDEF.10003.UETR",file="Fileset.UETR";
createscanner2:id=5,measurement_name="PREDEF.10004.UETR",file="Fileset.UETR";
createscanner2:id=6,measurement_name="PREDEF.10005.UETR",file="Fileset.UETR";
createscanner2:id=7,measurement_name="PREDEF.10006.UETR",file="Fileset.UETR";
createscanner2:id=8,measurement_name="PREDEF.10007.UETR",file="Fileset.UETR";
createscanner2:id=9,measurement_name="PREDEF.10008.UETR",file="Fileset.UETR";
createscanner2:id=10,measurement_name="PREDEF.10009.UETR",file="Fileset.UETR";
createscanner2:id=11,measurement_name="PREDEF.10010.UETR",file="Fileset.UETR";
createscanner2:id=12,measurement_name="PREDEF.10011.UETR",file="Fileset.UETR";
createscanner2:id=13,measurement_name="PREDEF.10012.UETR",file="Fileset.UETR";
createscanner2:id=14,measurement_name="PREDEF.10013.UETR",file="Fileset.UETR";
createscanner2:id=15,measurement_name="PREDEF.10014.UETR",file="Fileset.UETR";
createscanner2:id=16,measurement_name="PREDEF.10015.UETR",file="Fileset.UETR";
createscanner2:id=17,measurement_name="PREDEF.20000.CTR",file="Fileset.CTR";
createscanner2:id=18,measurement_name="PREDEF.20001.CTR",file="Fileset.CTR";
createscanner2:id=19,measurement_name="PREDEF.30000.GPEH",file="Fileset.GPEH";
createscanner2:id=20,measurement_name="PREDEF.30001.GPEH",file="Fileset.GPEH";
createscanner2:id=21,measurement_name="PREDEF.30002.GPEH",file="Fileset.GPEH";
createscanner2:id=22,measurement_name="PREDEF.30003.GPEH",file="Fileset.GPEH";
createscanner2:id=23,measurement_name="PREDEF.30004.GPEH",file="Fileset.GPEH";
createscanner2:id=24,measurement_name="PREDEF.30005.GPEH",file="Fileset.GPEH";
createscanner2:id=25,measurement_name="PREDEF.30006.GPEH",file="Fileset.GPEH";
createscanner2:id=26,measurement_name="PREDEF.30007.GPEH",file="Fileset.GPEH";
createscanner2:id=27,measurement_name="PREDEF.30008.GPEH",file="Fileset.GPEH";
createscanner2:id=28,measurement_name="PREDEF.30009.GPEH",file="Fileset.GPEH";
createscanner2:id=29,measurement_name="PREDEF.30010.GPEH",file="Fileset.GPEH";
createscanner2:id=30,measurement_name="PREDEF.30011.GPEH",file="Fileset.GPEH";
createscanner2:id=31,measurement_name="PREDEF.30012.GPEH",file="Fileset.GPEH";
createscanner2:id=32,measurement_name="PREDEF.30013.GPEH",file="Fileset.GPEH";
createscanner2:id=33,measurement_name="PREDEF.30014.GPEH",file="Fileset.GPEH";
createscanner2:id=34,measurement_name="PREDEF.30015.GPEH",file="Fileset.GPEH";
createscanner2:id=35,measurement_name="PREDEF.30016.GPEH",file="Fileset.GPEH";
createscanner2:id=36,measurement_name="PREDEF.30017.GPEH",file="Fileset.GPEH";
createscanner2:id=37,measurement_name="PREDEF.30018.GPEH",file="Fileset.GPEH";
createscanner2:id=38,measurement_name="PREDEF.30019.GPEH",file="Fileset.GPEH";
createscanner2:id=39,measurement_name="PREDEF.30020.GPEH",file="Fileset.GPEH";
createscanner2:id=40,measurement_name="PREDEF.30021.GPEH",file="Fileset.GPEH";
createscanner2:id=41,measurement_name="PREDEF.30022.GPEH",file="Fileset.GPEH";
createscanner2:id=42,measurement_name="PREDEF.30023.GPEH",file="Fileset.GPEH";
createscanner2:id=43,measurement_name="PREDEF.PRIMARY.STATS",state="ACTIVE",file="Fileset.STATS";
createscanner2:id=44,measurement_name="PREDEF.SECONDARY.STATS",state="ACTIVE",file="Fileset.STATS";
pmdata:enable;
pmfstime:time=24;
modifyscanner:noofprocs = 1;
pmstats:files=1;
pmmode:reffile;

.selectnetype RBS
createscanner2:id=100,measurement_name="PREDEF.PRIMARY.STATS",state="ACTIVE",file="Fileset.STATS";
createscanner2:id=110,measurement_name="PREDEF.RBS.GPEH",file="Fileset.GPEH";
pmdata:enable;
pmfstime:time=24;
pmstats:files=1;
pmmode:reffile;

.selectnetype RXI
createscanner2:id=200,measurement_name="PREDEF.PRIMARY.STATS",state="ACTIVE",file="Fileset.STATS";
createscanner2:id=210,measurement_name="PREDEF.RBS.GPEH",file="Fileset.GPEH";
pmdata:enable;
pmfstime:time=24;
pmstats:files=1;
pmmode:reffile;
EOF
	elif [ "${SIM_TYPE}" = "LTE" ] ; then
		cat >> ${CMD_FILE} <<EOF
.open ${SIM_NAME}
.select network
.genreffilecpp lte Fileset.GPEH gpeh default
.genreffilecpp lte Fileset.STATS stats default
.genreffilecpp lte Fileset.CTR ctr default
.genreffilecpp lte Fileset.UETR uetr default
.selectnetype ERBS
createscanner2:id=1,measurement_name="PREDEF.10000.CELLTRACE",file="Fileset.CTR";
createscanner2:id=2,measurement_name="PREDEF.10001.CELLTRACE",file="Fileset.CTR";
createscanner2:id=3,measurement_name="PREDEF.10002.CELLTRACE",file="Fileset.CTR";
createscanner2:id=4,measurement_name="PREDEF.10003.CELLTRACE",file="Fileset.CTR";
createscanner2:id=5,measurement_name="PREDEF.10004.CELLTRACE",file="Fileset.CTR";
createscanner2:id=6,measurement_name="PREDEF.10005.CELLTRACE",file="Fileset.CTR";
createscanner2:id=100,measurement_name="PREDEF.STATS",state="ACTIVE",file="Fileset.STATS";
pmdata:enable;
pmfstime:time=24;
pmstats:files=1;
pmmode:reffile;
EOF
	fi
    done

    log "INFO: Creating scanners"
    /netsim/inst/netsim_pipe < ${CMD_FILE} 
}

deleteScanners() {
    CMD_FILE=/tmp/delete_scanners.cmd
    if [ -r ${CMD_FILE} ] ; then
	rm ${CMD_FILE}
    fi

    for SIM in $LIST ; do	
	SIM_TYPE=`getSimType ${SIM}`
	SIM_NAME=`ls /netsim/netsimdir | grep ${SIM} | grep -v zip`
	
	#log "INFO: Reading scanners in ${SIM}"

	NE_TYPE_LIST=""
	if [ "${SIM_TYPE}" = "WRAN" ] ; then
	    NE_TYPE_LIST="RNC RBS RXI"		
	elif [ "${SIM_TYPE}" = "LTE" ] ; then
	    NE_TYPE_LIST="ERBS"
	fi

	echo ".open ${SIM_NAME}" >> ${CMD_FILE}

	for NE_TYPE in ${NE_TYPE_LIST} ; do
	    /netsim/inst/netsim_pipe <<EOF > /tmp/scannerlist.txt
.open ${SIM_NAME}
.selectnetype ${NE_TYPE}
showscanners2;
EOF
	    echo ".selectnetype ${NE_TYPE}" >> ${CMD_FILE}
	    # New a sort -u cause now we're get an output per NE
            cat /tmp/scannerlist.txt | awk '{ if ( $2 ~ /^PREDEF/ ) {print $1} }' | sort -un \
                | awk '{ printf "deletescanner2:id=%d;\n", $1; }' \
                >> ${CMD_FILE}
	done
    done    

    log "INFO: Deleting scanners"
    /netsim/inst/netsim_pipe < ${CMD_FILE} 
}
LIST=`ls -ltr /netsim/netsimdir/ |egrep 'LTE|ERBS|WRAN|RNC|RBS|RXI' | tr -s " " | cut -d " " -f 9 | grep -iv "zip"`
	deleteScanners
	createScanners
  
echo "Scanners available"    



