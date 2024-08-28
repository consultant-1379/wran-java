SET 
( 
 mo "ManagedElement=1,RncFunction=1"
  exception none 
  nrOfAttributes 1 
		rncId Integer 1 
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1" 
    identity 1
    moType LocationArea 
    exception none 
    nrOfAttributes 1 
      lac Integer 1
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1" 
    identity 1
    moType Ura 
    exception none 
    nrOfAttributes 1 
      uraIdentity Integer 1
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1,LocationArea=1" 
    identity 1
    moType RoutingArea 
    exception none 
    nrOfAttributes 1 
      rac Integer 1
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1,LocationArea=1" 
    identity 1
    moType ServiceArea 
    exception none 
    nrOfAttributes 1 
      sac Integer 1
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1,LocationArea=1" 
    identity 2
    moType ServiceArea 
    exception none 
    nrOfAttributes 1 
      sac Integer 2
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1,LocationArea=1" 
    identity 3
    moType ServiceArea 
    exception none 
    nrOfAttributes 1 
      sac Integer 3
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1,LocationArea=1" 
    identity 4
    moType ServiceArea 
    exception none 
    nrOfAttributes 1 
      sac Integer 4
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1,LocationArea=1" 
    identity 5
    moType ServiceArea 
    exception none 
    nrOfAttributes 1 
      sac Integer 5
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1,LocationArea=1" 
    identity 6
    moType ServiceArea 
    exception none 
    nrOfAttributes 1 
      sac Integer 6
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1,LocationArea=1" 
    identity 7
    moType ServiceArea 
    exception none 
    nrOfAttributes 1 
      sac Integer 7
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1,LocationArea=1" 
    identity 8
    moType ServiceArea 
    exception none 
    nrOfAttributes 1 
      sac Integer 8
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1,LocationArea=1" 
    identity 9
    moType ServiceArea 
    exception none 
    nrOfAttributes 1 
      sac Integer 9
)
//######################
//RNCID=1, numOfUtranCells=9
//######################
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1" 
    identity RNC01-1-1
    moType UtranCell 
    exception none 
    nrOfAttributes 8 
      iubLinkRef Ref ManagedElement=1,RncFunction=1,IubLink=1
      cId Integer 1
      userLabel String RNC01-1-1
      locationAreaRef Ref ManagedElement=1,RncFunction=1,LocationArea=1
      routingAreaRef Ref ManagedElement=1,RncFunction=1,LocationArea=1,RoutingArea=1
      serviceAreaRef Ref ManagedElement=1,RncFunction=1,LocationArea=1,ServiceArea=1
      uraRef Array Ref "ManagedElement=1,RncFunction=1,Ura=1" 
      tCell Integer 0
      uarfcnDl Integer 10563
      uarfcnUl Integer 12
      primaryScramblingCode Integer 1
      primaryCpichPower Integer 300
      qQualMin Integer -24
      qRxLevMin Integer -115
      maxTxPowerUl Integer 30
      maximumTransmissionPower Integer 30
      localCellId Integer 1
      usedFreqThresh2dRscp Integer -100
      usedFreqThresh2dEcno Integer -12
      sRatSearch Integer 4
      operationalState Integer 1
      administrativeState Integer 1
      accessClassNBarred Array Integer 16
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
      accessClassesBarredCs Array Integer 16
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
      accessClassesBarredPs Array Integer 16
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1" 
  identity 1 
	 moType Fach 
    exception none 
	   nrOfAttributes 10 
		FachId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		maxFach1Power Integer 18 
		maxFach2Power Integer 15 
		operationalState Integer 1 
		pOffset1Fach Integer 0 
		pOffset3Fach Integer 0 
		sccpchOffset Integer 0 
		userLabel String "Fach-1-1" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1" 
  identity 1 
	 moType Rach 
    exception none 
	   nrOfAttributes 19 
		RachId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		aichPower Integer -6 
		aichTransmissionTiming Integer 4
		operationalState Integer 1 
		constantValueCprach Integer -27 
		maxPreambleCycle Integer 4 
		pmFaultyTransportBlocks Integer 0  
		pmNoRecRandomAccSuccess Integer 0   
		pmTransportBlocks Integer 0  
		powerOffsetP0 Integer 3  
		pmFaultyTransportBlocks Integer 0  
		powerOffsetPpm Integer -4  
		preambleRetransMax Integer 5  
		preambleSignatures Integer 65535  
		scramblingCodeWordNo Integer 0  
		spreadingFactor Integer 64  
		subChannelNo Integer 4095  
		userLabel String "Rach-1-1" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1" 
  identity 1 
	 moType Pch 
    exception none 
	   nrOfAttributes 8 
		PchId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		operationalState Integer 1 
		pchPower Integer -4 
		pichPower Integer -7 
		sccpchOffset Integer 20 
		userLabel String "Pch-1-1" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1" 
  identity 1 
	 moType Hsdsch 
    exception none 
	   nrOfAttributes 20 
		HsdschId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		codeThresholdPdu656 Integer 6 
		cqiFeedbackCycle Integer 8 
		operationalState Integer 1 
		deltaAck1 Integer 4 
		deltaAck2 Integer 8 
		deltaCqi1 Integer 4 
		deltaCqi2 Integer 8 
		deltaNack1 Integer 4 
		deltaNack2 Integer 8 
		hsMeasurementPowerOffset Integer 0 
		initialAckNackRepetitionFactor Integer 1  
		initialCqiRepetitionFactor Integer 1   
		numHsPdschCodes Integer 5  
		numHsScchCodes Integer 1  
		pmHsDowntimeAuto Integer 0  
		pmHsDowntimeMan Integer 0  
		userLabel String "Hsdsch-1-1" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1,Hsdsch=1" 
  identity 1 
	 moType Eul 
    exception none 
	   nrOfAttributes 1 
		userLabel String "Eul-1-1" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1" 
  identity 1 
	 moType MbmsCch 
    exception none 
	   nrOfAttributes 1 
		nonPlMbmsSaRef Array Ref 1  
		"ManagedElement=1,RncFunction=1,Mbms=1,MbmsServiceArea=1" 
) 
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1" 
    identity RNC01-1-2
    moType UtranCell 
    exception none 
    nrOfAttributes 8 
      iubLinkRef Ref ManagedElement=1,RncFunction=1,IubLink=1
      cId Integer 2
      userLabel String RNC01-1-2
      locationAreaRef Ref ManagedElement=1,RncFunction=1,LocationArea=1
      routingAreaRef Ref ManagedElement=1,RncFunction=1,LocationArea=1,RoutingArea=1
      serviceAreaRef Ref ManagedElement=1,RncFunction=1,LocationArea=1,ServiceArea=2
      uraRef Array Ref "ManagedElement=1,RncFunction=1,Ura=1" 
      tCell Integer 0
      uarfcnDl Integer 10563
      uarfcnUl Integer 12
      primaryScramblingCode Integer 2
      primaryCpichPower Integer 300
      qQualMin Integer -24
      qRxLevMin Integer -115
      maxTxPowerUl Integer 30
      maximumTransmissionPower Integer 30
      localCellId Integer 2
      usedFreqThresh2dRscp Integer -100
      usedFreqThresh2dEcno Integer -12
      sRatSearch Integer 4
      operationalState Integer 1
      administrativeState Integer 1
      accessClassNBarred Array Integer 16
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
      accessClassesBarredCs Array Integer 16
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
      accessClassesBarredPs Array Integer 16
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2" 
  identity 1 
	 moType Fach 
    exception none 
	   nrOfAttributes 10 
		FachId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		maxFach1Power Integer 18 
		maxFach2Power Integer 15 
		operationalState Integer 1 
		pOffset1Fach Integer 0 
		pOffset3Fach Integer 0 
		sccpchOffset Integer 0 
		userLabel String "Fach-1-2" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2" 
  identity 1 
	 moType Rach 
    exception none 
	   nrOfAttributes 19 
		RachId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		aichPower Integer -6 
		aichTransmissionTiming Integer 4
		operationalState Integer 1 
		constantValueCprach Integer -27 
		maxPreambleCycle Integer 4 
		pmFaultyTransportBlocks Integer 0  
		pmNoRecRandomAccSuccess Integer 0   
		pmTransportBlocks Integer 0  
		powerOffsetP0 Integer 3  
		pmFaultyTransportBlocks Integer 0  
		powerOffsetPpm Integer -4  
		preambleRetransMax Integer 5  
		preambleSignatures Integer 65535  
		scramblingCodeWordNo Integer 0  
		spreadingFactor Integer 64  
		subChannelNo Integer 4095  
		userLabel String "Rach-1-2" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2" 
  identity 1 
	 moType Pch 
    exception none 
	   nrOfAttributes 8 
		PchId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		operationalState Integer 1 
		pchPower Integer -4 
		pichPower Integer -7 
		sccpchOffset Integer 20 
		userLabel String "Pch-1-2" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2" 
  identity 1 
	 moType Hsdsch 
    exception none 
	   nrOfAttributes 20 
		HsdschId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		codeThresholdPdu656 Integer 6 
		cqiFeedbackCycle Integer 8 
		operationalState Integer 1 
		deltaAck1 Integer 4 
		deltaAck2 Integer 8 
		deltaCqi1 Integer 4 
		deltaCqi2 Integer 8 
		deltaNack1 Integer 4 
		deltaNack2 Integer 8 
		hsMeasurementPowerOffset Integer 0 
		initialAckNackRepetitionFactor Integer 1  
		initialCqiRepetitionFactor Integer 1   
		numHsPdschCodes Integer 5  
		numHsScchCodes Integer 1  
		pmHsDowntimeAuto Integer 0  
		pmHsDowntimeMan Integer 0  
		userLabel String "Hsdsch-1-2" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2,Hsdsch=1" 
  identity 1 
	 moType Eul 
    exception none 
	   nrOfAttributes 1 
		userLabel String "Eul-1-2" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2" 
  identity 1 
	 moType MbmsCch 
    exception none 
	   nrOfAttributes 1 
		nonPlMbmsSaRef Array Ref 1  
		"ManagedElement=1,RncFunction=1,Mbms=1,MbmsServiceArea=1" 
) 
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1" 
    identity RNC01-1-3
    moType UtranCell 
    exception none 
    nrOfAttributes 8 
      iubLinkRef Ref ManagedElement=1,RncFunction=1,IubLink=1
      cId Integer 3
      userLabel String RNC01-1-3
      locationAreaRef Ref ManagedElement=1,RncFunction=1,LocationArea=1
      routingAreaRef Ref ManagedElement=1,RncFunction=1,LocationArea=1,RoutingArea=1
      serviceAreaRef Ref ManagedElement=1,RncFunction=1,LocationArea=1,ServiceArea=3
      uraRef Array Ref "ManagedElement=1,RncFunction=1,Ura=1" 
      tCell Integer 0
      uarfcnDl Integer 10563
      uarfcnUl Integer 12
      primaryScramblingCode Integer 3
      primaryCpichPower Integer 300
      qQualMin Integer -24
      qRxLevMin Integer -115
      maxTxPowerUl Integer 30
      maximumTransmissionPower Integer 30
      localCellId Integer 3
      usedFreqThresh2dRscp Integer -100
      usedFreqThresh2dEcno Integer -12
      sRatSearch Integer 4
      operationalState Integer 1
      administrativeState Integer 1
      accessClassNBarred Array Integer 16
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
      accessClassesBarredCs Array Integer 16
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
      accessClassesBarredPs Array Integer 16
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3" 
  identity 1 
	 moType Fach 
    exception none 
	   nrOfAttributes 10 
		FachId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		maxFach1Power Integer 18 
		maxFach2Power Integer 15 
		operationalState Integer 1 
		pOffset1Fach Integer 0 
		pOffset3Fach Integer 0 
		sccpchOffset Integer 0 
		userLabel String "Fach-1-3" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3" 
  identity 1 
	 moType Rach 
    exception none 
	   nrOfAttributes 19 
		RachId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		aichPower Integer -6 
		aichTransmissionTiming Integer 4
		operationalState Integer 1 
		constantValueCprach Integer -27 
		maxPreambleCycle Integer 4 
		pmFaultyTransportBlocks Integer 0  
		pmNoRecRandomAccSuccess Integer 0   
		pmTransportBlocks Integer 0  
		powerOffsetP0 Integer 3  
		pmFaultyTransportBlocks Integer 0  
		powerOffsetPpm Integer -4  
		preambleRetransMax Integer 5  
		preambleSignatures Integer 65535  
		scramblingCodeWordNo Integer 0  
		spreadingFactor Integer 64  
		subChannelNo Integer 4095  
		userLabel String "Rach-1-3" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3" 
  identity 1 
	 moType Pch 
    exception none 
	   nrOfAttributes 8 
		PchId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		operationalState Integer 1 
		pchPower Integer -4 
		pichPower Integer -7 
		sccpchOffset Integer 20 
		userLabel String "Pch-1-3" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3" 
  identity 1 
	 moType Hsdsch 
    exception none 
	   nrOfAttributes 20 
		HsdschId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		codeThresholdPdu656 Integer 6 
		cqiFeedbackCycle Integer 8 
		operationalState Integer 1 
		deltaAck1 Integer 4 
		deltaAck2 Integer 8 
		deltaCqi1 Integer 4 
		deltaCqi2 Integer 8 
		deltaNack1 Integer 4 
		deltaNack2 Integer 8 
		hsMeasurementPowerOffset Integer 0 
		initialAckNackRepetitionFactor Integer 1  
		initialCqiRepetitionFactor Integer 1   
		numHsPdschCodes Integer 5  
		numHsScchCodes Integer 1  
		pmHsDowntimeAuto Integer 0  
		pmHsDowntimeMan Integer 0  
		userLabel String "Hsdsch-1-3" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3,Hsdsch=1" 
  identity 1 
	 moType Eul 
    exception none 
	   nrOfAttributes 1 
		userLabel String "Eul-1-3" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3" 
  identity 1 
	 moType MbmsCch 
    exception none 
	   nrOfAttributes 1 
		nonPlMbmsSaRef Array Ref 1  
		"ManagedElement=1,RncFunction=1,Mbms=1,MbmsServiceArea=1" 
) 
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1" 
    identity RNC01-2-1
    moType UtranCell 
    exception none 
    nrOfAttributes 8 
      iubLinkRef Ref ManagedElement=1,RncFunction=1,IubLink=2
      cId Integer 4
      userLabel String RNC01-2-1
      locationAreaRef Ref ManagedElement=1,RncFunction=1,LocationArea=1
      routingAreaRef Ref ManagedElement=1,RncFunction=1,LocationArea=1,RoutingArea=1
      serviceAreaRef Ref ManagedElement=1,RncFunction=1,LocationArea=1,ServiceArea=4
      uraRef Array Ref "ManagedElement=1,RncFunction=1,Ura=1" 
      tCell Integer 0
      uarfcnDl Integer 10563
      uarfcnUl Integer 12
      primaryScramblingCode Integer 4
      primaryCpichPower Integer 300
      qQualMin Integer -24
      qRxLevMin Integer -115
      maxTxPowerUl Integer 30
      maximumTransmissionPower Integer 30
      localCellId Integer 4
      usedFreqThresh2dRscp Integer -100
      usedFreqThresh2dEcno Integer -12
      sRatSearch Integer 4
      operationalState Integer 1
      administrativeState Integer 1
      accessClassNBarred Array Integer 16
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
      accessClassesBarredCs Array Integer 16
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
      accessClassesBarredPs Array Integer 16
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1" 
  identity 1 
	 moType Fach 
    exception none 
	   nrOfAttributes 10 
		FachId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		maxFach1Power Integer 18 
		maxFach2Power Integer 15 
		operationalState Integer 1 
		pOffset1Fach Integer 0 
		pOffset3Fach Integer 0 
		sccpchOffset Integer 0 
		userLabel String "Fach-2-1" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1" 
  identity 1 
	 moType Rach 
    exception none 
	   nrOfAttributes 19 
		RachId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		aichPower Integer -6 
		aichTransmissionTiming Integer 4
		operationalState Integer 1 
		constantValueCprach Integer -27 
		maxPreambleCycle Integer 4 
		pmFaultyTransportBlocks Integer 0  
		pmNoRecRandomAccSuccess Integer 0   
		pmTransportBlocks Integer 0  
		powerOffsetP0 Integer 3  
		pmFaultyTransportBlocks Integer 0  
		powerOffsetPpm Integer -4  
		preambleRetransMax Integer 5  
		preambleSignatures Integer 65535  
		scramblingCodeWordNo Integer 0  
		spreadingFactor Integer 64  
		subChannelNo Integer 4095  
		userLabel String "Rach-2-1" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1" 
  identity 1 
	 moType Pch 
    exception none 
	   nrOfAttributes 8 
		PchId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		operationalState Integer 1 
		pchPower Integer -4 
		pichPower Integer -7 
		sccpchOffset Integer 20 
		userLabel String "Pch-2-1" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1" 
  identity 1 
	 moType Hsdsch 
    exception none 
	   nrOfAttributes 20 
		HsdschId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		codeThresholdPdu656 Integer 6 
		cqiFeedbackCycle Integer 8 
		operationalState Integer 1 
		deltaAck1 Integer 4 
		deltaAck2 Integer 8 
		deltaCqi1 Integer 4 
		deltaCqi2 Integer 8 
		deltaNack1 Integer 4 
		deltaNack2 Integer 8 
		hsMeasurementPowerOffset Integer 0 
		initialAckNackRepetitionFactor Integer 1  
		initialCqiRepetitionFactor Integer 1   
		numHsPdschCodes Integer 5  
		numHsScchCodes Integer 1  
		pmHsDowntimeAuto Integer 0  
		pmHsDowntimeMan Integer 0  
		userLabel String "Hsdsch-2-1" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1,Hsdsch=1" 
  identity 1 
	 moType Eul 
    exception none 
	   nrOfAttributes 1 
		userLabel String "Eul-2-1" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1" 
  identity 1 
	 moType MbmsCch 
    exception none 
	   nrOfAttributes 1 
		nonPlMbmsSaRef Array Ref 1  
		"ManagedElement=1,RncFunction=1,Mbms=1,MbmsServiceArea=2" 
) 
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1" 
    identity RNC01-2-2
    moType UtranCell 
    exception none 
    nrOfAttributes 8 
      iubLinkRef Ref ManagedElement=1,RncFunction=1,IubLink=2
      cId Integer 5
      userLabel String RNC01-2-2
      locationAreaRef Ref ManagedElement=1,RncFunction=1,LocationArea=1
      routingAreaRef Ref ManagedElement=1,RncFunction=1,LocationArea=1,RoutingArea=1
      serviceAreaRef Ref ManagedElement=1,RncFunction=1,LocationArea=1,ServiceArea=5
      uraRef Array Ref "ManagedElement=1,RncFunction=1,Ura=1" 
      tCell Integer 0
      uarfcnDl Integer 10563
      uarfcnUl Integer 12
      primaryScramblingCode Integer 5
      primaryCpichPower Integer 300
      qQualMin Integer -24
      qRxLevMin Integer -115
      maxTxPowerUl Integer 30
      maximumTransmissionPower Integer 30
      localCellId Integer 5
      usedFreqThresh2dRscp Integer -100
      usedFreqThresh2dEcno Integer -12
      sRatSearch Integer 4
      operationalState Integer 1
      administrativeState Integer 1
      accessClassNBarred Array Integer 16
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
      accessClassesBarredCs Array Integer 16
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
      accessClassesBarredPs Array Integer 16
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2" 
  identity 1 
	 moType Fach 
    exception none 
	   nrOfAttributes 10 
		FachId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		maxFach1Power Integer 18 
		maxFach2Power Integer 15 
		operationalState Integer 1 
		pOffset1Fach Integer 0 
		pOffset3Fach Integer 0 
		sccpchOffset Integer 0 
		userLabel String "Fach-2-2" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2" 
  identity 1 
	 moType Rach 
    exception none 
	   nrOfAttributes 19 
		RachId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		aichPower Integer -6 
		aichTransmissionTiming Integer 4
		operationalState Integer 1 
		constantValueCprach Integer -27 
		maxPreambleCycle Integer 4 
		pmFaultyTransportBlocks Integer 0  
		pmNoRecRandomAccSuccess Integer 0   
		pmTransportBlocks Integer 0  
		powerOffsetP0 Integer 3  
		pmFaultyTransportBlocks Integer 0  
		powerOffsetPpm Integer -4  
		preambleRetransMax Integer 5  
		preambleSignatures Integer 65535  
		scramblingCodeWordNo Integer 0  
		spreadingFactor Integer 64  
		subChannelNo Integer 4095  
		userLabel String "Rach-2-2" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2" 
  identity 1 
	 moType Pch 
    exception none 
	   nrOfAttributes 8 
		PchId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		operationalState Integer 1 
		pchPower Integer -4 
		pichPower Integer -7 
		sccpchOffset Integer 20 
		userLabel String "Pch-2-2" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2" 
  identity 1 
	 moType Hsdsch 
    exception none 
	   nrOfAttributes 20 
		HsdschId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		codeThresholdPdu656 Integer 6 
		cqiFeedbackCycle Integer 8 
		operationalState Integer 1 
		deltaAck1 Integer 4 
		deltaAck2 Integer 8 
		deltaCqi1 Integer 4 
		deltaCqi2 Integer 8 
		deltaNack1 Integer 4 
		deltaNack2 Integer 8 
		hsMeasurementPowerOffset Integer 0 
		initialAckNackRepetitionFactor Integer 1  
		initialCqiRepetitionFactor Integer 1   
		numHsPdschCodes Integer 5  
		numHsScchCodes Integer 1  
		pmHsDowntimeAuto Integer 0  
		pmHsDowntimeMan Integer 0  
		userLabel String "Hsdsch-2-2" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2,Hsdsch=1" 
  identity 1 
	 moType Eul 
    exception none 
	   nrOfAttributes 1 
		userLabel String "Eul-2-2" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2" 
  identity 1 
	 moType MbmsCch 
    exception none 
	   nrOfAttributes 1 
		nonPlMbmsSaRef Array Ref 1  
		"ManagedElement=1,RncFunction=1,Mbms=1,MbmsServiceArea=2" 
) 
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1" 
    identity RNC01-2-3
    moType UtranCell 
    exception none 
    nrOfAttributes 8 
      iubLinkRef Ref ManagedElement=1,RncFunction=1,IubLink=2
      cId Integer 6
      userLabel String RNC01-2-3
      locationAreaRef Ref ManagedElement=1,RncFunction=1,LocationArea=1
      routingAreaRef Ref ManagedElement=1,RncFunction=1,LocationArea=1,RoutingArea=1
      serviceAreaRef Ref ManagedElement=1,RncFunction=1,LocationArea=1,ServiceArea=6
      uraRef Array Ref "ManagedElement=1,RncFunction=1,Ura=1" 
      tCell Integer 0
      uarfcnDl Integer 10563
      uarfcnUl Integer 12
      primaryScramblingCode Integer 6
      primaryCpichPower Integer 300
      qQualMin Integer -24
      qRxLevMin Integer -115
      maxTxPowerUl Integer 30
      maximumTransmissionPower Integer 30
      localCellId Integer 6
      usedFreqThresh2dRscp Integer -100
      usedFreqThresh2dEcno Integer -12
      sRatSearch Integer 4
      operationalState Integer 1
      administrativeState Integer 1
      accessClassNBarred Array Integer 16
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
      accessClassesBarredCs Array Integer 16
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
      accessClassesBarredPs Array Integer 16
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3" 
  identity 1 
	 moType Fach 
    exception none 
	   nrOfAttributes 10 
		FachId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		maxFach1Power Integer 18 
		maxFach2Power Integer 15 
		operationalState Integer 1 
		pOffset1Fach Integer 0 
		pOffset3Fach Integer 0 
		sccpchOffset Integer 0 
		userLabel String "Fach-2-3" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3" 
  identity 1 
	 moType Rach 
    exception none 
	   nrOfAttributes 19 
		RachId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		aichPower Integer -6 
		aichTransmissionTiming Integer 4
		operationalState Integer 1 
		constantValueCprach Integer -27 
		maxPreambleCycle Integer 4 
		pmFaultyTransportBlocks Integer 0  
		pmNoRecRandomAccSuccess Integer 0   
		pmTransportBlocks Integer 0  
		powerOffsetP0 Integer 3  
		pmFaultyTransportBlocks Integer 0  
		powerOffsetPpm Integer -4  
		preambleRetransMax Integer 5  
		preambleSignatures Integer 65535  
		scramblingCodeWordNo Integer 0  
		spreadingFactor Integer 64  
		subChannelNo Integer 4095  
		userLabel String "Rach-2-3" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3" 
  identity 1 
	 moType Pch 
    exception none 
	   nrOfAttributes 8 
		PchId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		operationalState Integer 1 
		pchPower Integer -4 
		pichPower Integer -7 
		sccpchOffset Integer 20 
		userLabel String "Pch-2-3" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3" 
  identity 1 
	 moType Hsdsch 
    exception none 
	   nrOfAttributes 20 
		HsdschId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		codeThresholdPdu656 Integer 6 
		cqiFeedbackCycle Integer 8 
		operationalState Integer 1 
		deltaAck1 Integer 4 
		deltaAck2 Integer 8 
		deltaCqi1 Integer 4 
		deltaCqi2 Integer 8 
		deltaNack1 Integer 4 
		deltaNack2 Integer 8 
		hsMeasurementPowerOffset Integer 0 
		initialAckNackRepetitionFactor Integer 1  
		initialCqiRepetitionFactor Integer 1   
		numHsPdschCodes Integer 5  
		numHsScchCodes Integer 1  
		pmHsDowntimeAuto Integer 0  
		pmHsDowntimeMan Integer 0  
		userLabel String "Hsdsch-2-3" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3,Hsdsch=1" 
  identity 1 
	 moType Eul 
    exception none 
	   nrOfAttributes 1 
		userLabel String "Eul-2-3" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3" 
  identity 1 
	 moType MbmsCch 
    exception none 
	   nrOfAttributes 1 
		nonPlMbmsSaRef Array Ref 1  
		"ManagedElement=1,RncFunction=1,Mbms=1,MbmsServiceArea=2" 
) 
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1" 
    identity RNC01-3-1
    moType UtranCell 
    exception none 
    nrOfAttributes 8 
      iubLinkRef Ref ManagedElement=1,RncFunction=1,IubLink=3
      cId Integer 7
      userLabel String RNC01-3-1
      locationAreaRef Ref ManagedElement=1,RncFunction=1,LocationArea=1
      routingAreaRef Ref ManagedElement=1,RncFunction=1,LocationArea=1,RoutingArea=1
      serviceAreaRef Ref ManagedElement=1,RncFunction=1,LocationArea=1,ServiceArea=7
      uraRef Array Ref "ManagedElement=1,RncFunction=1,Ura=1" 
      tCell Integer 0
      uarfcnDl Integer 10563
      uarfcnUl Integer 12
      primaryScramblingCode Integer 7
      primaryCpichPower Integer 300
      qQualMin Integer -24
      qRxLevMin Integer -115
      maxTxPowerUl Integer 30
      maximumTransmissionPower Integer 30
      localCellId Integer 7
      usedFreqThresh2dRscp Integer -100
      usedFreqThresh2dEcno Integer -12
      sRatSearch Integer 4
      operationalState Integer 1
      administrativeState Integer 1
      accessClassNBarred Array Integer 16
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
      accessClassesBarredCs Array Integer 16
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
      accessClassesBarredPs Array Integer 16
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1" 
  identity 1 
	 moType Fach 
    exception none 
	   nrOfAttributes 10 
		FachId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		maxFach1Power Integer 18 
		maxFach2Power Integer 15 
		operationalState Integer 1 
		pOffset1Fach Integer 0 
		pOffset3Fach Integer 0 
		sccpchOffset Integer 0 
		userLabel String "Fach-3-1" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1" 
  identity 1 
	 moType Rach 
    exception none 
	   nrOfAttributes 19 
		RachId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		aichPower Integer -6 
		aichTransmissionTiming Integer 4
		operationalState Integer 1 
		constantValueCprach Integer -27 
		maxPreambleCycle Integer 4 
		pmFaultyTransportBlocks Integer 0  
		pmNoRecRandomAccSuccess Integer 0   
		pmTransportBlocks Integer 0  
		powerOffsetP0 Integer 3  
		pmFaultyTransportBlocks Integer 0  
		powerOffsetPpm Integer -4  
		preambleRetransMax Integer 5  
		preambleSignatures Integer 65535  
		scramblingCodeWordNo Integer 0  
		spreadingFactor Integer 64  
		subChannelNo Integer 4095  
		userLabel String "Rach-3-1" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1" 
  identity 1 
	 moType Pch 
    exception none 
	   nrOfAttributes 8 
		PchId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		operationalState Integer 1 
		pchPower Integer -4 
		pichPower Integer -7 
		sccpchOffset Integer 20 
		userLabel String "Pch-3-1" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1" 
  identity 1 
	 moType Hsdsch 
    exception none 
	   nrOfAttributes 20 
		HsdschId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		codeThresholdPdu656 Integer 6 
		cqiFeedbackCycle Integer 8 
		operationalState Integer 1 
		deltaAck1 Integer 4 
		deltaAck2 Integer 8 
		deltaCqi1 Integer 4 
		deltaCqi2 Integer 8 
		deltaNack1 Integer 4 
		deltaNack2 Integer 8 
		hsMeasurementPowerOffset Integer 0 
		initialAckNackRepetitionFactor Integer 1  
		initialCqiRepetitionFactor Integer 1   
		numHsPdschCodes Integer 5  
		numHsScchCodes Integer 1  
		pmHsDowntimeAuto Integer 0  
		pmHsDowntimeMan Integer 0  
		userLabel String "Hsdsch-3-1" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1,Hsdsch=1" 
  identity 1 
	 moType Eul 
    exception none 
	   nrOfAttributes 1 
		userLabel String "Eul-3-1" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1" 
  identity 1 
	 moType MbmsCch 
    exception none 
	   nrOfAttributes 1 
		nonPlMbmsSaRef Array Ref 1  
		"ManagedElement=1,RncFunction=1,Mbms=1,MbmsServiceArea=3" 
) 
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1" 
    identity RNC01-3-2
    moType UtranCell 
    exception none 
    nrOfAttributes 8 
      iubLinkRef Ref ManagedElement=1,RncFunction=1,IubLink=3
      cId Integer 8
      userLabel String RNC01-3-2
      locationAreaRef Ref ManagedElement=1,RncFunction=1,LocationArea=1
      routingAreaRef Ref ManagedElement=1,RncFunction=1,LocationArea=1,RoutingArea=1
      serviceAreaRef Ref ManagedElement=1,RncFunction=1,LocationArea=1,ServiceArea=8
      uraRef Array Ref "ManagedElement=1,RncFunction=1,Ura=1" 
      tCell Integer 0
      uarfcnDl Integer 10563
      uarfcnUl Integer 12
      primaryScramblingCode Integer 8
      primaryCpichPower Integer 300
      qQualMin Integer -24
      qRxLevMin Integer -115
      maxTxPowerUl Integer 30
      maximumTransmissionPower Integer 30
      localCellId Integer 8
      usedFreqThresh2dRscp Integer -100
      usedFreqThresh2dEcno Integer -12
      sRatSearch Integer 4
      operationalState Integer 1
      administrativeState Integer 1
      accessClassNBarred Array Integer 16
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
      accessClassesBarredCs Array Integer 16
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
      accessClassesBarredPs Array Integer 16
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2" 
  identity 1 
	 moType Fach 
    exception none 
	   nrOfAttributes 10 
		FachId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		maxFach1Power Integer 18 
		maxFach2Power Integer 15 
		operationalState Integer 1 
		pOffset1Fach Integer 0 
		pOffset3Fach Integer 0 
		sccpchOffset Integer 0 
		userLabel String "Fach-3-2" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2" 
  identity 1 
	 moType Rach 
    exception none 
	   nrOfAttributes 19 
		RachId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		aichPower Integer -6 
		aichTransmissionTiming Integer 4
		operationalState Integer 1 
		constantValueCprach Integer -27 
		maxPreambleCycle Integer 4 
		pmFaultyTransportBlocks Integer 0  
		pmNoRecRandomAccSuccess Integer 0   
		pmTransportBlocks Integer 0  
		powerOffsetP0 Integer 3  
		pmFaultyTransportBlocks Integer 0  
		powerOffsetPpm Integer -4  
		preambleRetransMax Integer 5  
		preambleSignatures Integer 65535  
		scramblingCodeWordNo Integer 0  
		spreadingFactor Integer 64  
		subChannelNo Integer 4095  
		userLabel String "Rach-3-2" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2" 
  identity 1 
	 moType Pch 
    exception none 
	   nrOfAttributes 8 
		PchId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		operationalState Integer 1 
		pchPower Integer -4 
		pichPower Integer -7 
		sccpchOffset Integer 20 
		userLabel String "Pch-3-2" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2" 
  identity 1 
	 moType Hsdsch 
    exception none 
	   nrOfAttributes 20 
		HsdschId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		codeThresholdPdu656 Integer 6 
		cqiFeedbackCycle Integer 8 
		operationalState Integer 1 
		deltaAck1 Integer 4 
		deltaAck2 Integer 8 
		deltaCqi1 Integer 4 
		deltaCqi2 Integer 8 
		deltaNack1 Integer 4 
		deltaNack2 Integer 8 
		hsMeasurementPowerOffset Integer 0 
		initialAckNackRepetitionFactor Integer 1  
		initialCqiRepetitionFactor Integer 1   
		numHsPdschCodes Integer 5  
		numHsScchCodes Integer 1  
		pmHsDowntimeAuto Integer 0  
		pmHsDowntimeMan Integer 0  
		userLabel String "Hsdsch-3-2" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2,Hsdsch=1" 
  identity 1 
	 moType Eul 
    exception none 
	   nrOfAttributes 1 
		userLabel String "Eul-3-2" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2" 
  identity 1 
	 moType MbmsCch 
    exception none 
	   nrOfAttributes 1 
		nonPlMbmsSaRef Array Ref 1  
		"ManagedElement=1,RncFunction=1,Mbms=1,MbmsServiceArea=3" 
) 
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1" 
    identity RNC01-3-3
    moType UtranCell 
    exception none 
    nrOfAttributes 8 
      iubLinkRef Ref ManagedElement=1,RncFunction=1,IubLink=3
      cId Integer 9
      userLabel String RNC01-3-3
      locationAreaRef Ref ManagedElement=1,RncFunction=1,LocationArea=1
      routingAreaRef Ref ManagedElement=1,RncFunction=1,LocationArea=1,RoutingArea=1
      serviceAreaRef Ref ManagedElement=1,RncFunction=1,LocationArea=1,ServiceArea=9
      uraRef Array Ref "ManagedElement=1,RncFunction=1,Ura=1" 
      tCell Integer 0
      uarfcnDl Integer 10563
      uarfcnUl Integer 12
      primaryScramblingCode Integer 9
      primaryCpichPower Integer 300
      qQualMin Integer -24
      qRxLevMin Integer -115
      maxTxPowerUl Integer 30
      maximumTransmissionPower Integer 30
      localCellId Integer 9
      usedFreqThresh2dRscp Integer -100
      usedFreqThresh2dEcno Integer -12
      sRatSearch Integer 4
      operationalState Integer 1
      administrativeState Integer 1
      accessClassNBarred Array Integer 16
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
      accessClassesBarredCs Array Integer 16
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
      accessClassesBarredPs Array Integer 16
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
        0 
        1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-3" 
  identity 1 
	 moType Fach 
    exception none 
	   nrOfAttributes 10 
		FachId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		maxFach1Power Integer 18 
		maxFach2Power Integer 15 
		operationalState Integer 1 
		pOffset1Fach Integer 0 
		pOffset3Fach Integer 0 
		sccpchOffset Integer 0 
		userLabel String "Fach-3-3" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-3" 
  identity 1 
	 moType Rach 
    exception none 
	   nrOfAttributes 19 
		RachId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		aichPower Integer -6 
		aichTransmissionTiming Integer 4
		operationalState Integer 1 
		constantValueCprach Integer -27 
		maxPreambleCycle Integer 4 
		pmFaultyTransportBlocks Integer 0  
		pmNoRecRandomAccSuccess Integer 0   
		pmTransportBlocks Integer 0  
		powerOffsetP0 Integer 3  
		pmFaultyTransportBlocks Integer 0  
		powerOffsetPpm Integer -4  
		preambleRetransMax Integer 5  
		preambleSignatures Integer 65535  
		scramblingCodeWordNo Integer 0  
		spreadingFactor Integer 64  
		subChannelNo Integer 4095  
		userLabel String "Rach-3-3" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-3" 
  identity 1 
	 moType Pch 
    exception none 
	   nrOfAttributes 8 
		PchId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		operationalState Integer 1 
		pchPower Integer -4 
		pichPower Integer -7 
		sccpchOffset Integer 20 
		userLabel String "Pch-3-3" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-3" 
  identity 1 
	 moType Hsdsch 
    exception none 
	   nrOfAttributes 20 
		HsdschId String 1 
		administrativeState Integer 1 
		availabilityStatus Integer 0 
		codeThresholdPdu656 Integer 6 
		cqiFeedbackCycle Integer 8 
		operationalState Integer 1 
		deltaAck1 Integer 4 
		deltaAck2 Integer 8 
		deltaCqi1 Integer 4 
		deltaCqi2 Integer 8 
		deltaNack1 Integer 4 
		deltaNack2 Integer 8 
		hsMeasurementPowerOffset Integer 0 
		initialAckNackRepetitionFactor Integer 1  
		initialCqiRepetitionFactor Integer 1   
		numHsPdschCodes Integer 5  
		numHsScchCodes Integer 1  
		pmHsDowntimeAuto Integer 0  
		pmHsDowntimeMan Integer 0  
		userLabel String "Hsdsch-3-3" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-3,Hsdsch=1" 
  identity 1 
	 moType Eul 
    exception none 
	   nrOfAttributes 1 
		userLabel String "Eul-3-3" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-3" 
  identity 1 
	 moType MbmsCch 
    exception none 
	   nrOfAttributes 1 
		nonPlMbmsSaRef Array Ref 1  
		"ManagedElement=1,RncFunction=1,Mbms=1,MbmsServiceArea=3" 
) 
//######################
//RNCID=1
//######################
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1 " 
    identity 6
    moType UtranNetwork 
    exception none 
    nrOfAttributes 3 
      UtranNetworkId String 1 
      aliasPlmnIdentities Array Struct 0 
      plmnIdentity Struct 
        nrOfElements 3 
          mcc Integer 46
          mnc Integer 6
          mncLength Integer 2
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1 " 
    identity 2
    moType IurLink 
    exception none 
    nrOfAttributes 2 
      rncId Integer 2
		  userPlaneTransportOption Struct
		      nrOfElements 2 
				atm Integer 0
 			ipv4 Integer 1 
      utranNetworkRef Ref "ManagedElement=1,RncFunction=1,UtranNetwork=6" 
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1 " 
    identity 3
    moType IurLink 
    exception none 
    nrOfAttributes 2 
      rncId Integer 3
		  userPlaneTransportOption Struct
		      nrOfElements 2 
				atm Integer 0
 			ipv4 Integer 1 
      utranNetworkRef Ref "ManagedElement=1,RncFunction=1,UtranNetwork=6" 
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1 " 
    identity 4
    moType IurLink 
    exception none 
    nrOfAttributes 2 
      rncId Integer 4
		  userPlaneTransportOption Struct
		      nrOfElements 2 
				atm Integer 0
 			ipv4 Integer 1 
      utranNetworkRef Ref "ManagedElement=1,RncFunction=1,UtranNetwork=6" 
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1 " 
    identity 5
    moType IurLink 
    exception none 
    nrOfAttributes 2 
      rncId Integer 5
		  userPlaneTransportOption Struct
		      nrOfElements 2 
				atm Integer 0
 			ipv4 Integer 1 
      utranNetworkRef Ref "ManagedElement=1,RncFunction=1,UtranNetwork=6" 
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1 " 
    identity 6
    moType IurLink 
    exception none 
    nrOfAttributes 2 
      rncId Integer 6
		  userPlaneTransportOption Struct
		      nrOfElements 2 
				atm Integer 0
 			ipv4 Integer 1 
      utranNetworkRef Ref "ManagedElement=1,RncFunction=1,UtranNetwork=6" 
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1 " 
    identity 7
    moType IurLink 
    exception none 
    nrOfAttributes 2 
      rncId Integer 7
		  userPlaneTransportOption Struct
		      nrOfElements 2 
				atm Integer 0
 			ipv4 Integer 1 
      utranNetworkRef Ref "ManagedElement=1,RncFunction=1,UtranNetwork=6" 
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1 " 
    identity 8
    moType IurLink 
    exception none 
    nrOfAttributes 2 
      rncId Integer 8
		  userPlaneTransportOption Struct
		      nrOfElements 2 
				atm Integer 0
 			ipv4 Integer 1 
      utranNetworkRef Ref "ManagedElement=1,RncFunction=1,UtranNetwork=6" 
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1 " 
    identity 9
    moType IurLink 
    exception none 
    nrOfAttributes 2 
      rncId Integer 9
		  userPlaneTransportOption Struct
		      nrOfElements 2 
				atm Integer 0
 			ipv4 Integer 1 
      utranNetworkRef Ref "ManagedElement=1,RncFunction=1,UtranNetwork=6" 
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1 " 
    identity 10
    moType IurLink 
    exception none 
    nrOfAttributes 2 
      rncId Integer 10
		  userPlaneTransportOption Struct
		      nrOfElements 2 
				atm Integer 0
 			ipv4 Integer 1 
      utranNetworkRef Ref "ManagedElement=1,RncFunction=1,UtranNetwork=6" 
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1 " 
    identity 11
    moType IurLink 
    exception none 
    nrOfAttributes 2 
      rncId Integer 11
		  userPlaneTransportOption Struct
		      nrOfElements 2 
				atm Integer 0
 			ipv4 Integer 1 
      utranNetworkRef Ref "ManagedElement=1,RncFunction=1,UtranNetwork=6" 
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1,IurLink=2" 
    identity 10
    moType ExternalUtranCell
    exception none 
    nrOfAttributes 8 
      lac Integer 2
      rac Integer  2
      userLabel String RNC02-1-1
      cId Integer 10
      uarfcnDl Integer 10564
      uarfcnUl Integer 12
      primaryScramblingCode Integer 1
      qQualMin Integer -24
      maxTxPowerUl Integer 30
      qRxLevMin Integer -115
      primaryCpichPower Integer 300
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1,IurLink=2" 
    identity 12
    moType ExternalUtranCell
    exception none 
    nrOfAttributes 8 
      lac Integer 2
      rac Integer  2
      userLabel String RNC02-1-3
      cId Integer 12
      uarfcnDl Integer 10564
      uarfcnUl Integer 12
      primaryScramblingCode Integer 3
      qQualMin Integer -24
      maxTxPowerUl Integer 30
      qRxLevMin Integer -115
      primaryCpichPower Integer 300
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1,IurLink=3" 
    identity 25
    moType ExternalUtranCell
    exception none 
    nrOfAttributes 8 
      lac Integer 3
      rac Integer  3
      userLabel String RNC03-1-1
      cId Integer 25
      uarfcnDl Integer 10565
      uarfcnUl Integer 12
      primaryScramblingCode Integer 1
      qQualMin Integer -24
      maxTxPowerUl Integer 30
      qRxLevMin Integer -115
      primaryCpichPower Integer 300
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1,IurLink=4" 
    identity 40
    moType ExternalUtranCell
    exception none 
    nrOfAttributes 8 
      lac Integer 4
      rac Integer  4
      userLabel String RNC04-1-1
      cId Integer 40
      uarfcnDl Integer 10566
      uarfcnUl Integer 12
      primaryScramblingCode Integer 1
      qQualMin Integer -24
      maxTxPowerUl Integer 30
      qRxLevMin Integer -115
      primaryCpichPower Integer 300
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1,IurLink=5" 
    identity 55
    moType ExternalUtranCell
    exception none 
    nrOfAttributes 8 
      lac Integer 5
      rac Integer  5
      userLabel String RNC05-1-1
      cId Integer 55
      uarfcnDl Integer 10567
      uarfcnUl Integer 12
      primaryScramblingCode Integer 1
      qQualMin Integer -24
      maxTxPowerUl Integer 30
      qRxLevMin Integer -115
      primaryCpichPower Integer 300
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1,IurLink=6" 
    identity 70
    moType ExternalUtranCell
    exception none 
    nrOfAttributes 8 
      lac Integer 6
      rac Integer  6
      userLabel String RNC06-1-1
      cId Integer 70
      uarfcnDl Integer 10568
      uarfcnUl Integer 12
      primaryScramblingCode Integer 1
      qQualMin Integer -24
      maxTxPowerUl Integer 30
      qRxLevMin Integer -115
      primaryCpichPower Integer 300
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1,IurLink=6" 
    identity 73
    moType ExternalUtranCell
    exception none 
    nrOfAttributes 8 
      lac Integer 6
      rac Integer  6
      userLabel String RNC06-2-1
      cId Integer 73
      uarfcnDl Integer 10568
      uarfcnUl Integer 12
      primaryScramblingCode Integer 4
      qQualMin Integer -24
      maxTxPowerUl Integer 30
      qRxLevMin Integer -115
      primaryCpichPower Integer 300
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1,IurLink=7" 
    identity 220
    moType ExternalUtranCell
    exception none 
    nrOfAttributes 8 
      lac Integer 13
      rac Integer  13
      userLabel String RNC07-1-1
      cId Integer 220
      uarfcnDl Integer 10569
      uarfcnUl Integer 12
      primaryScramblingCode Integer 1
      qQualMin Integer -24
      maxTxPowerUl Integer 30
      qRxLevMin Integer -115
      primaryCpichPower Integer 300
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1,IurLink=7" 
    identity 223
    moType ExternalUtranCell
    exception none 
    nrOfAttributes 8 
      lac Integer 13
      rac Integer  13
      userLabel String RNC07-2-1
      cId Integer 223
      uarfcnDl Integer 10569
      uarfcnUl Integer 12
      primaryScramblingCode Integer 4
      qQualMin Integer -24
      maxTxPowerUl Integer 30
      qRxLevMin Integer -115
      primaryCpichPower Integer 300
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1,IurLink=8" 
    identity 370
    moType ExternalUtranCell
    exception none 
    nrOfAttributes 8 
      lac Integer 20
      rac Integer  20
      userLabel String RNC08-1-1
      cId Integer 370
      uarfcnDl Integer 10570
      uarfcnUl Integer 12
      primaryScramblingCode Integer 1
      qQualMin Integer -24
      maxTxPowerUl Integer 30
      qRxLevMin Integer -115
      primaryCpichPower Integer 300
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1,IurLink=8" 
    identity 373
    moType ExternalUtranCell
    exception none 
    nrOfAttributes 8 
      lac Integer 20
      rac Integer  20
      userLabel String RNC08-2-1
      cId Integer 373
      uarfcnDl Integer 10570
      uarfcnUl Integer 12
      primaryScramblingCode Integer 4
      qQualMin Integer -24
      maxTxPowerUl Integer 30
      qRxLevMin Integer -115
      primaryCpichPower Integer 300
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1,IurLink=9" 
    identity 522
    moType ExternalUtranCell
    exception none 
    nrOfAttributes 8 
      lac Integer 27
      rac Integer  27
      userLabel String RNC09-1-3
      cId Integer 522
      uarfcnDl Integer 10571
      uarfcnUl Integer 12
      primaryScramblingCode Integer 3
      qQualMin Integer -24
      maxTxPowerUl Integer 30
      qRxLevMin Integer -115
      primaryCpichPower Integer 300
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1,IurLink=10" 
    identity 672
    moType ExternalUtranCell
    exception none 
    nrOfAttributes 8 
      lac Integer 34
      rac Integer  34
      userLabel String RNC10-1-3
      cId Integer 672
      uarfcnDl Integer 10572
      uarfcnUl Integer 12
      primaryScramblingCode Integer 3
      qQualMin Integer -24
      maxTxPowerUl Integer 30
      qRxLevMin Integer -115
      primaryCpichPower Integer 300
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1,IurLink=10" 
    identity 703
    moType ExternalUtranCell
    exception none 
    nrOfAttributes 8 
      lac Integer 35
      rac Integer  35
      userLabel String RNC10-12-1
      cId Integer 703
      uarfcnDl Integer 10572
      uarfcnUl Integer 12
      primaryScramblingCode Integer 34
      qQualMin Integer -24
      maxTxPowerUl Integer 30
      qRxLevMin Integer -115
      primaryCpichPower Integer 300
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1,IurLink=10" 
    identity 719
    moType ExternalUtranCell
    exception none 
    nrOfAttributes 8 
      lac Integer 35
      rac Integer  35
      userLabel String RNC10-17-2
      cId Integer 719
      uarfcnDl Integer 10572
      uarfcnUl Integer 12
      primaryScramblingCode Integer 50
      qQualMin Integer -24
      maxTxPowerUl Integer 30
      qRxLevMin Integer -115
      primaryCpichPower Integer 300
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1,IurLink=10" 
    identity 736
    moType ExternalUtranCell
    exception none 
    nrOfAttributes 8 
      lac Integer 36
      rac Integer  36
      userLabel String RNC10-23-1
      cId Integer 736
      uarfcnDl Integer 10572
      uarfcnUl Integer 12
      primaryScramblingCode Integer 67
      qQualMin Integer -24
      maxTxPowerUl Integer 30
      qRxLevMin Integer -115
      primaryCpichPower Integer 300
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1,IurLink=10" 
    identity 753
    moType ExternalUtranCell
    exception none 
    nrOfAttributes 8 
      lac Integer 37
      rac Integer  37
      userLabel String RNC10-28-3
      cId Integer 753
      uarfcnDl Integer 10572
      uarfcnUl Integer 12
      primaryScramblingCode Integer 84
      qQualMin Integer -24
      maxTxPowerUl Integer 30
      qRxLevMin Integer -115
      primaryCpichPower Integer 300
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1,IurLink=11" 
    identity 822
    moType ExternalUtranCell
    exception none 
    nrOfAttributes 8 
      lac Integer 41
      rac Integer  41
      userLabel String RNC11-3-1
      cId Integer 822
      uarfcnDl Integer 10573
      uarfcnUl Integer 12
      primaryScramblingCode Integer 3
      qQualMin Integer -24
      maxTxPowerUl Integer 30
      qRxLevMin Integer -115
      primaryCpichPower Integer 300
)
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1,IurLink=11" 
    identity 824
    moType ExternalUtranCell
    exception none 
    nrOfAttributes 8 
      lac Integer 41
      rac Integer  41
      userLabel String RNC11-4-2
      cId Integer 824
      uarfcnDl Integer 10573
      uarfcnUl Integer 12
      primaryScramblingCode Integer 5
      qQualMin Integer -24
      maxTxPowerUl Integer 30
      qRxLevMin Integer -115
      primaryCpichPower Integer 300
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1" 
	 identity 1 
  moType Anr 
		exception none 
		  nrOfAttributes 1 
		  AnrId String 1 
 ) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,Anr=1" 
	 identity 1 
  moType AnrIafUtran 
		exception none 
		  nrOfAttributes 2 
		  AnrIafUtranId String "1" 
 		  anrEnabled Integer 1 
) 
SET 
( 
 mo "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1"
  exception none 
  nrOfAttributes 1 
"anrIafUtranCellConfig" Struct 
		nrOfElements 2 
		"anrEnabled" Integer 1
		"relationAddEnabled" Integer 1

)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1"
	 identity 1 
  moType AnrBlackList 
		exception none 
		  nrOfAttributes 2 
		  AnrBlackListId String 1 
  	  anrBlackTargetCells Array Ref 4
	"ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1" 
	"ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2" 
	"ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3" 
	"ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1" 
) 
SET 
( 
 mo "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2"
  exception none 
  nrOfAttributes 1 
"anrIafUtranCellConfig" Struct 
		nrOfElements 2 
		"anrEnabled" Integer 1
		"relationAddEnabled" Integer 1

)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2"
	 identity 1 
  moType AnrBlackList 
		exception none 
		  nrOfAttributes 2 
		  AnrBlackListId String 1 
  	  anrBlackTargetCells Array Ref 15
	"ManagedElement=1,RncFunction=1,IurLink=2,ExternalUtranCell=10" 
	"ManagedElement=1,RncFunction=1,IurLink=3,ExternalUtranCell=25" 
	"ManagedElement=1,RncFunction=1,IurLink=4,ExternalUtranCell=40" 
	"ManagedElement=1,RncFunction=1,IurLink=7,ExternalUtranCell=220" 
	"ManagedElement=1,RncFunction=1,IurLink=6,ExternalUtranCell=70" 
	"ManagedElement=1,RncFunction=1,IurLink=5,ExternalUtranCell=55" 
	"ManagedElement=1,RncFunction=1,IurLink=8,ExternalUtranCell=370" 
	"ManagedElement=1,RncFunction=1,IurLink=10,ExternalUtranCell=736" 
	"ManagedElement=1,RncFunction=1,IurLink=11,ExternalUtranCell=824" 
	"ManagedElement=1,RncFunction=1,IurLink=10,ExternalUtranCell=719" 
	"ManagedElement=1,RncFunction=1,IurLink=10,ExternalUtranCell=703" 
	"ManagedElement=1,RncFunction=1,IurLink=10,ExternalUtranCell=736" 
	"ManagedElement=1,RncFunction=1,IurLink=10,ExternalUtranCell=703" 
	"ManagedElement=1,RncFunction=1,IurLink=10,ExternalUtranCell=719" 
	"ManagedElement=1,RncFunction=1,IurLink=10,ExternalUtranCell=736" 
) 
SET 
( 
 mo "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3"
  exception none 
  nrOfAttributes 1 
"anrIafUtranCellConfig" Struct 
		nrOfElements 2 
		"anrEnabled" Integer 1
		"relationAddEnabled" Integer 1

)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3"
	 identity 1 
  moType AnrBlackList 
		exception none 
		  nrOfAttributes 2 
		  AnrBlackListId String 1 
  	  anrBlackTargetCells Array Ref 2
	"ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1" 
	"ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2" 
) 
SET 
( 
 mo "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1"
  exception none 
  nrOfAttributes 1 
"anrIafUtranCellConfig" Struct 
		nrOfElements 2 
		"anrEnabled" Integer 1
		"relationAddEnabled" Integer 1

)
SET 
( 
 mo "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2"
  exception none 
  nrOfAttributes 1 
"anrIafUtranCellConfig" Struct 
		nrOfElements 2 
		"anrEnabled" Integer 1
		"relationAddEnabled" Integer 1

)
SET 
( 
 mo "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3"
  exception none 
  nrOfAttributes 1 
"anrIafUtranCellConfig" Struct 
		nrOfElements 2 
		"anrEnabled" Integer 1
		"relationAddEnabled" Integer 1

)
SET 
( 
 mo "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1"
  exception none 
  nrOfAttributes 1 
"anrIafUtranCellConfig" Struct 
		nrOfElements 2 
		"anrEnabled" Integer 1
		"relationAddEnabled" Integer 1

)
SET 
( 
 mo "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2"
  exception none 
  nrOfAttributes 1 
"anrIafUtranCellConfig" Struct 
		nrOfElements 2 
		"anrEnabled" Integer 1
		"relationAddEnabled" Integer 1

)
SET 
( 
 mo "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-3"
  exception none 
  nrOfAttributes 1 
"anrIafUtranCellConfig" Struct 
		nrOfElements 2 
		"anrEnabled" Integer 1
		"relationAddEnabled" Integer 1

)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1" 
	 identity 1
  moType CoverageRelation 
		exception none 
		  nrOfAttributes 1 
		  utranCellRef Ref "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1" 
	 identity 2
  moType CoverageRelation 
		exception none 
		  nrOfAttributes 1 
		  utranCellRef Ref "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1" 
	 identity 3
  moType CoverageRelation 
		exception none 
		  nrOfAttributes 1 
		  utranCellRef Ref "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2" 
	 identity 1
  moType CoverageRelation 
		exception none 
		  nrOfAttributes 1 
		  utranCellRef Ref "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2" 
	 identity 2
  moType CoverageRelation 
		exception none 
		  nrOfAttributes 1 
		  utranCellRef Ref "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2" 
	 identity 3
  moType CoverageRelation 
		exception none 
		  nrOfAttributes 1 
		  utranCellRef Ref "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3" 
	 identity 1
  moType CoverageRelation 
		exception none 
		  nrOfAttributes 1 
		  utranCellRef Ref "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3" 
	 identity 2
  moType CoverageRelation 
		exception none 
		  nrOfAttributes 1 
		  utranCellRef Ref "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3" 
	 identity 3
  moType CoverageRelation 
		exception none 
		  nrOfAttributes 1 
		  utranCellRef Ref "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1" 
	 identity 1
  moType CoverageRelation 
		exception none 
		  nrOfAttributes 1 
		  utranCellRef Ref "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1" 
	 identity 2
  moType CoverageRelation 
		exception none 
		  nrOfAttributes 1 
		  utranCellRef Ref "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1" 
	 identity 3
  moType CoverageRelation 
		exception none 
		  nrOfAttributes 1 
		  utranCellRef Ref "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2" 
	 identity 1
  moType CoverageRelation 
		exception none 
		  nrOfAttributes 1 
		  utranCellRef Ref "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2" 
	 identity 2
  moType CoverageRelation 
		exception none 
		  nrOfAttributes 1 
		  utranCellRef Ref "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2" 
	 identity 3
  moType CoverageRelation 
		exception none 
		  nrOfAttributes 1 
		  utranCellRef Ref "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3" 
	 identity 1
  moType CoverageRelation 
		exception none 
		  nrOfAttributes 1 
		  utranCellRef Ref "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3" 
	 identity 2
  moType CoverageRelation 
		exception none 
		  nrOfAttributes 1 
		  utranCellRef Ref "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3" 
	 identity 3
  moType CoverageRelation 
		exception none 
		  nrOfAttributes 1 
		  utranCellRef Ref "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1" 
	 identity 1
  moType CoverageRelation 
		exception none 
		  nrOfAttributes 1 
		  utranCellRef Ref "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1" 
	 identity 2
  moType CoverageRelation 
		exception none 
		  nrOfAttributes 1 
		  utranCellRef Ref "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1" 
	 identity 3
  moType CoverageRelation 
		exception none 
		  nrOfAttributes 1 
		  utranCellRef Ref "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2" 
	 identity 1
  moType CoverageRelation 
		exception none 
		  nrOfAttributes 1 
		  utranCellRef Ref "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2" 
	 identity 2
  moType CoverageRelation 
		exception none 
		  nrOfAttributes 1 
		  utranCellRef Ref "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2" 
	 identity 3
  moType CoverageRelation 
		exception none 
		  nrOfAttributes 1 
		  utranCellRef Ref "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-3" 
	 identity 1
  moType CoverageRelation 
		exception none 
		  nrOfAttributes 1 
		  utranCellRef Ref "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-3" 
	 identity 2
  moType CoverageRelation 
		exception none 
		  nrOfAttributes 1 
		  utranCellRef Ref "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-3" 
	 identity 3
  moType CoverageRelation 
		exception none 
		  nrOfAttributes 1 
		  utranCellRef Ref "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3" 
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1" 
	 identity 4
  moType ExternalGsmNetwork 
  exception none 
	 nrOfAttributes 1 
		mnc Integer 4
		mcc Integer 46
		mncLength Integer 2
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4"
  identity 921
  moType ExternalGsmCell 
  exception none 
  nrOfAttributes 12 
		ExternalGsmCellId String "ExternalGsmCell-921" 
		bandIndicator Integer 2
		bcc Integer 0
		bcchFrequency Integer 1
		cellIdentity Integer 921
		lac Integer 64
		ncc Integer 3
	    userLabel String "ExternalGsmCell-921" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4"
  identity 550
  moType ExternalGsmCell 
  exception none 
  nrOfAttributes 12 
		ExternalGsmCellId String "ExternalGsmCell-550" 
		bandIndicator Integer 2
		bcc Integer 0
		bcchFrequency Integer 1
		cellIdentity Integer 550
		lac Integer 84
		ncc Integer 3
	    userLabel String "ExternalGsmCell-550" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4"
  identity 957
  moType ExternalGsmCell 
  exception none 
  nrOfAttributes 12 
		ExternalGsmCellId String "ExternalGsmCell-957" 
		bandIndicator Integer 2
		bcc Integer 0
		bcchFrequency Integer 1
		cellIdentity Integer 957
		lac Integer 136
		ncc Integer 3
	    userLabel String "ExternalGsmCell-957" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4"
  identity 720
  moType ExternalGsmCell 
  exception none 
  nrOfAttributes 12 
		ExternalGsmCellId String "ExternalGsmCell-720" 
		bandIndicator Integer 2
		bcc Integer 0
		bcchFrequency Integer 1
		cellIdentity Integer 720
		lac Integer 170
		ncc Integer 3
	    userLabel String "ExternalGsmCell-720" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4"
  identity 21
  moType ExternalGsmCell 
  exception none 
  nrOfAttributes 12 
		ExternalGsmCellId String "ExternalGsmCell-21" 
		bandIndicator Integer 2
		bcc Integer 0
		bcchFrequency Integer 1
		cellIdentity Integer 21
		lac Integer 42
		ncc Integer 3
	    userLabel String "ExternalGsmCell-21" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4"
  identity 798
  moType ExternalGsmCell 
  exception none 
  nrOfAttributes 12 
		ExternalGsmCellId String "ExternalGsmCell-798" 
		bandIndicator Integer 2
		bcc Integer 0
		bcchFrequency Integer 1
		cellIdentity Integer 798
		lac Integer 72
		ncc Integer 3
	    userLabel String "ExternalGsmCell-798" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4"
  identity 796
  moType ExternalGsmCell 
  exception none 
  nrOfAttributes 12 
		ExternalGsmCellId String "ExternalGsmCell-796" 
		bandIndicator Integer 2
		bcc Integer 0
		bcchFrequency Integer 1
		cellIdentity Integer 796
		lac Integer 68
		ncc Integer 3
	    userLabel String "ExternalGsmCell-796" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4"
  identity 815
  moType ExternalGsmCell 
  exception none 
  nrOfAttributes 12 
		ExternalGsmCellId String "ExternalGsmCell-815" 
		bandIndicator Integer 2
		bcc Integer 0
		bcchFrequency Integer 1
		cellIdentity Integer 815
		lac Integer 106
		ncc Integer 3
	    userLabel String "ExternalGsmCell-815" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4"
  identity 180
  moType ExternalGsmCell 
  exception none 
  nrOfAttributes 12 
		ExternalGsmCellId String "ExternalGsmCell-180" 
		bandIndicator Integer 2
		bcc Integer 0
		bcchFrequency Integer 1
		cellIdentity Integer 180
		lac Integer 106
		ncc Integer 3
	    userLabel String "ExternalGsmCell-180" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4"
  identity 200
  moType ExternalGsmCell 
  exception none 
  nrOfAttributes 12 
		ExternalGsmCellId String "ExternalGsmCell-200" 
		bandIndicator Integer 2
		bcc Integer 0
		bcchFrequency Integer 1
		cellIdentity Integer 200
		lac Integer 146
		ncc Integer 3
	    userLabel String "ExternalGsmCell-200" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4"
  identity 480
  moType ExternalGsmCell 
  exception none 
  nrOfAttributes 12 
		ExternalGsmCellId String "ExternalGsmCell-480" 
		bandIndicator Integer 2
		bcc Integer 0
		bcchFrequency Integer 1
		cellIdentity Integer 480
		lac Integer 198
		ncc Integer 3
	    userLabel String "ExternalGsmCell-480" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4"
  identity 864
  moType ExternalGsmCell 
  exception none 
  nrOfAttributes 12 
		ExternalGsmCellId String "ExternalGsmCell-864" 
		bandIndicator Integer 2
		bcc Integer 0
		bcchFrequency Integer 1
		cellIdentity Integer 864
		lac Integer 204
		ncc Integer 3
	    userLabel String "ExternalGsmCell-864" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4"
  identity 72
  moType ExternalGsmCell 
  exception none 
  nrOfAttributes 12 
		ExternalGsmCellId String "ExternalGsmCell-72" 
		bandIndicator Integer 2
		bcc Integer 0
		bcchFrequency Integer 1
		cellIdentity Integer 72
		lac Integer 144
		ncc Integer 3
	    userLabel String "ExternalGsmCell-72" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4"
  identity 730
  moType ExternalGsmCell 
  exception none 
  nrOfAttributes 12 
		ExternalGsmCellId String "ExternalGsmCell-730" 
		bandIndicator Integer 2
		bcc Integer 0
		bcchFrequency Integer 1
		cellIdentity Integer 730
		lac Integer 190
		ncc Integer 3
	    userLabel String "ExternalGsmCell-730" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4"
  identity 952
  moType ExternalGsmCell 
  exception none 
  nrOfAttributes 12 
		ExternalGsmCellId String "ExternalGsmCell-952" 
		bandIndicator Integer 2
		bcc Integer 0
		bcchFrequency Integer 1
		cellIdentity Integer 952
		lac Integer 126
		ncc Integer 3
	    userLabel String "ExternalGsmCell-952" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4"
  identity 224
  moType ExternalGsmCell 
  exception none 
  nrOfAttributes 12 
		ExternalGsmCellId String "ExternalGsmCell-224" 
		bandIndicator Integer 2
		bcc Integer 0
		bcchFrequency Integer 1
		cellIdentity Integer 224
		lac Integer 194
		ncc Integer 3
	    userLabel String "ExternalGsmCell-224" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4"
  identity 658
  moType ExternalGsmCell 
  exception none 
  nrOfAttributes 12 
		ExternalGsmCellId String "ExternalGsmCell-658" 
		bandIndicator Integer 2
		bcc Integer 0
		bcchFrequency Integer 1
		cellIdentity Integer 658
		lac Integer 46
		ncc Integer 3
	    userLabel String "ExternalGsmCell-658" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4"
  identity 44
  moType ExternalGsmCell 
  exception none 
  nrOfAttributes 12 
		ExternalGsmCellId String "ExternalGsmCell-44" 
		bandIndicator Integer 2
		bcc Integer 0
		bcchFrequency Integer 1
		cellIdentity Integer 44
		lac Integer 88
		ncc Integer 3
	    userLabel String "ExternalGsmCell-44" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4"
  identity 889
  moType ExternalGsmCell 
  exception none 
  nrOfAttributes 12 
		ExternalGsmCellId String "ExternalGsmCell-889" 
		bandIndicator Integer 2
		bcc Integer 0
		bcchFrequency Integer 1
		cellIdentity Integer 889
		lac Integer 254
		ncc Integer 3
	    userLabel String "ExternalGsmCell-889" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4"
  identity 841
  moType ExternalGsmCell 
  exception none 
  nrOfAttributes 12 
		ExternalGsmCellId String "ExternalGsmCell-841" 
		bandIndicator Integer 2
		bcc Integer 0
		bcchFrequency Integer 1
		cellIdentity Integer 841
		lac Integer 158
		ncc Integer 3
	    userLabel String "ExternalGsmCell-841" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4"
  identity 865
  moType ExternalGsmCell 
  exception none 
  nrOfAttributes 12 
		ExternalGsmCellId String "ExternalGsmCell-865" 
		bandIndicator Integer 2
		bcc Integer 0
		bcchFrequency Integer 1
		cellIdentity Integer 865
		lac Integer 206
		ncc Integer 3
	    userLabel String "ExternalGsmCell-865" 
) 
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4"
  identity 393
  moType ExternalGsmCell 
  exception none 
  nrOfAttributes 12 
		ExternalGsmCellId String "ExternalGsmCell-393" 
		bandIndicator Integer 2
		bcc Integer 0
		bcchFrequency Integer 1
		cellIdentity Integer 393
		lac Integer 24
		ncc Integer 3
	    userLabel String "ExternalGsmCell-393" 
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1"
	 identity 1
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=921
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1"
	 identity 2
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=550
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1"
	 identity 3
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=957
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1"
	 identity 4
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=720
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1"
	 identity 5
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=21
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1"
	 identity 6
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=798
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1"
	 identity 7
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=796
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1"
	 identity 8
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=815
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1"
	 identity 9
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=180
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1"
	 identity 10
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=200
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1"
	 identity 11
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=480
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1"
	 identity 12
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=864
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1"
	 identity 13
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=72
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1"
	 identity 14
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=730
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1"
	 identity 15
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=952
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1"
	 identity 16
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=224
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1"
	 identity 17
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=658
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1"
	 identity 18
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=44
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2"
	 identity 1
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=889
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2"
	 identity 2
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=841
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2"
	 identity 3
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=865
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2"
	 identity 4
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=393
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2"
	 identity 5
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=921
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2"
	 identity 6
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=550
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2"
	 identity 7
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=957
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2"
	 identity 8
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=720
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2"
	 identity 9
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=21
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2"
	 identity 10
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=798
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2"
	 identity 11
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=796
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2"
	 identity 12
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=815
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2"
	 identity 13
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=180
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2"
	 identity 14
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=200
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2"
	 identity 15
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=480
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2"
	 identity 16
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=864
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2"
	 identity 17
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=72
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2"
	 identity 18
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=730
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3"
	 identity 1
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=952
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3"
	 identity 2
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=224
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3"
	 identity 3
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=658
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3"
	 identity 4
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=44
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3"
	 identity 5
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=889
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3"
	 identity 6
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=841
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3"
	 identity 7
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=865
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3"
	 identity 8
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=393
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3"
	 identity 9
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=921
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3"
	 identity 10
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=550
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3"
	 identity 11
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=957
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3"
	 identity 12
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=720
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3"
	 identity 13
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=21
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3"
	 identity 14
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=798
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3"
	 identity 15
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=796
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3"
	 identity 16
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=815
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3"
	 identity 17
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=180
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3"
	 identity 18
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=200
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1"
	 identity 1
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=480
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1"
	 identity 2
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=864
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1"
	 identity 3
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=72
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1"
	 identity 4
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=730
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1"
	 identity 5
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=952
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1"
	 identity 6
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=224
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1"
	 identity 7
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=658
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1"
	 identity 8
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=44
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1"
	 identity 9
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=889
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1"
	 identity 10
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=841
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1"
	 identity 11
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=865
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1"
	 identity 12
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=393
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1"
	 identity 13
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=921
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1"
	 identity 14
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=550
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1"
	 identity 15
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=957
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1"
	 identity 16
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=720
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1"
	 identity 17
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=21
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1"
	 identity 18
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=798
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2"
	 identity 1
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=796
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2"
	 identity 2
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=815
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2"
	 identity 3
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=180
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2"
	 identity 4
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=200
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2"
	 identity 5
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=480
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2"
	 identity 6
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=864
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2"
	 identity 7
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=72
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2"
	 identity 8
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=730
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2"
	 identity 9
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=952
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2"
	 identity 10
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=224
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2"
	 identity 11
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=658
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2"
	 identity 12
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=44
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2"
	 identity 13
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=889
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2"
	 identity 14
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=841
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2"
	 identity 15
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=865
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2"
	 identity 16
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=393
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2"
	 identity 17
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=921
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2"
	 identity 18
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=550
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3"
	 identity 1
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=957
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3"
	 identity 2
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=720
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3"
	 identity 3
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=21
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3"
	 identity 4
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=798
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3"
	 identity 5
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=796
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3"
	 identity 6
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=815
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3"
	 identity 7
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=180
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3"
	 identity 8
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=200
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3"
	 identity 9
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=480
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3"
	 identity 10
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=864
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3"
	 identity 11
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=72
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3"
	 identity 12
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=730
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3"
	 identity 13
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=952
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3"
	 identity 14
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=224
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3"
	 identity 15
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=658
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3"
	 identity 16
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=44
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3"
	 identity 17
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=889
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3"
	 identity 18
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=841
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1"
	 identity 1
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=865
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1"
	 identity 2
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=393
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1"
	 identity 3
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=921
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1"
	 identity 4
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=550
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1"
	 identity 5
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=957
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1"
	 identity 6
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=720
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1"
	 identity 7
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=21
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1"
	 identity 8
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=798
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1"
	 identity 9
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=796
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1"
	 identity 10
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=815
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1"
	 identity 11
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=180
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1"
	 identity 12
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=200
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1"
	 identity 13
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=480
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1"
	 identity 14
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=864
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1"
	 identity 15
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=72
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1"
	 identity 16
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=730
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1"
	 identity 17
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=952
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1"
	 identity 18
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=224
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2"
	 identity 1
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=658
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2"
	 identity 2
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=44
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2"
	 identity 3
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=889
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2"
	 identity 4
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=841
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2"
	 identity 5
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=865
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2"
	 identity 6
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=393
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2"
	 identity 7
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=921
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2"
	 identity 8
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=550
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2"
	 identity 9
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=957
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2"
	 identity 10
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=720
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2"
	 identity 11
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=21
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2"
	 identity 12
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=798
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2"
	 identity 13
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=796
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2"
	 identity 14
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=815
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2"
	 identity 15
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=180
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2"
	 identity 16
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=200
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2"
	 identity 17
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=480
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2"
	 identity 18
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=864
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-3"
	 identity 1
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=72
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-3"
	 identity 2
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=730
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-3"
	 identity 3
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=952
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-3"
	 identity 4
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=224
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-3"
	 identity 5
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=658
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-3"
	 identity 6
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=44
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-3"
	 identity 7
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=889
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-3"
	 identity 8
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=841
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-3"
	 identity 9
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=865
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-3"
	 identity 10
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=393
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-3"
	 identity 11
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=921
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-3"
	 identity 12
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=550
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-3"
	 identity 13
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=957
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-3"
	 identity 14
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=720
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-3"
	 identity 15
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=21
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-3"
	 identity 16
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=798
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-3"
	 identity 17
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=796
) 
CREATE 
( 
	parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-3"
	 identity 18
  moType GsmRelation 
  exception none 
	 nrOfAttributes 1 
 	externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=815
) 
//######################
//RNCID=1, (WithinNetwork)numOfIurLinks=0, (WithinNetwork)numOfExtUC=0
//######################
CREATE 
( 
  parent "ManagedElement=1,RncFunction=1" 
    identity 7
    moType UtranNetwork 
    exception none 
    nrOfAttributes 3 
      UtranNetworkId String 1 
      aliasPlmnIdentities Array Struct 0 
      plmnIdentity Struct 
        nrOfElements 3 
          mcc Integer 46
          mnc Integer 7
          mncLength Integer 2
)
//**********************************
// RNC01-1-1 numOfInraUCRelations=2
//**********************************
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1"
  identity 1
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2
    nodeRelationType Integer 0
    frequencyRelationType Integer 0 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1"
  identity 2
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3
    nodeRelationType Integer 0
    frequencyRelationType Integer 0 
)
//**********************************
// RNC01-1-2 numOfInraUCRelations=2
//**********************************
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2"
  identity 1
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3
    nodeRelationType Integer 0
    frequencyRelationType Integer 0 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2"
  identity 2
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1
    nodeRelationType Integer 0
    frequencyRelationType Integer 0 
)
//**********************************
// RNC01-1-3 numOfInraUCRelations=2
//**********************************
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3"
  identity 1
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2
    nodeRelationType Integer 0
    frequencyRelationType Integer 0 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3"
  identity 2
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1
    nodeRelationType Integer 0
    frequencyRelationType Integer 0 
)
//**********************************
// RNC01-2-1 numOfInraUCRelations=2
//**********************************
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1"
  identity 1
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3
    nodeRelationType Integer 0
    frequencyRelationType Integer 0 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1"
  identity 2
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2
    nodeRelationType Integer 0
    frequencyRelationType Integer 0 
)
//**********************************
// RNC01-2-2 numOfInraUCRelations=2
//**********************************
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2"
  identity 1
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3
    nodeRelationType Integer 0
    frequencyRelationType Integer 0 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2"
  identity 2
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1
    nodeRelationType Integer 0
    frequencyRelationType Integer 0 
)
//**********************************
// RNC01-2-3 numOfInraUCRelations=2
//**********************************
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3"
  identity 1
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1
    nodeRelationType Integer 0
    frequencyRelationType Integer 0 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3"
  identity 2
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2
    nodeRelationType Integer 0
    frequencyRelationType Integer 0 
)
//**********************************
// RNC01-3-1 numOfInraUCRelations=2
//**********************************
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1"
  identity 1
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2
    nodeRelationType Integer 0
    frequencyRelationType Integer 0 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1"
  identity 2
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-3
    nodeRelationType Integer 0
    frequencyRelationType Integer 0 
)
//**********************************
// RNC01-3-2 numOfInraUCRelations=2
//**********************************
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2"
  identity 1
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-3
    nodeRelationType Integer 0
    frequencyRelationType Integer 0 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2"
  identity 2
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1
    nodeRelationType Integer 0
    frequencyRelationType Integer 0 
)
//**********************************
// RNC01-3-3 numOfInraUCRelations=2
//**********************************
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-3"
  identity 1
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2
    nodeRelationType Integer 0
    frequencyRelationType Integer 0 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-3"
  identity 2
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1
    nodeRelationType Integer 0
    frequencyRelationType Integer 0 
)
//**********************************
// RNC01-1-1 has 8
//**********************************
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1"
  identity 32
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,IurLink=2,ExternalUtranCell=10
    nodeRelationType Integer 1
    frequencyRelationType Integer 1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1"
  identity 33
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,IurLink=7,ExternalUtranCell=223
    nodeRelationType Integer 1
    frequencyRelationType Integer 1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1"
  identity 34
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,IurLink=3,ExternalUtranCell=25
    nodeRelationType Integer 1
    frequencyRelationType Integer 1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1"
  identity 35
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,IurLink=4,ExternalUtranCell=40
    nodeRelationType Integer 1
    frequencyRelationType Integer 1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1"
  identity 36
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,IurLink=7,ExternalUtranCell=220
    nodeRelationType Integer 1
    frequencyRelationType Integer 1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1"
  identity 37
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,IurLink=6,ExternalUtranCell=70
    nodeRelationType Integer 1
    frequencyRelationType Integer 1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1"
  identity 38
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,IurLink=5,ExternalUtranCell=55
    nodeRelationType Integer 1
    frequencyRelationType Integer 1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1"
  identity 39
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,IurLink=8,ExternalUtranCell=370
    nodeRelationType Integer 1
    frequencyRelationType Integer 1 
)
//**********************************
// RNC01-1-2 has 8
//**********************************
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2"
  identity 32
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,IurLink=10,ExternalUtranCell=753
    nodeRelationType Integer 1
    frequencyRelationType Integer 1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2"
  identity 33
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,IurLink=7,ExternalUtranCell=223
    nodeRelationType Integer 1
    frequencyRelationType Integer 1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2"
  identity 34
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,IurLink=6,ExternalUtranCell=73
    nodeRelationType Integer 1
    frequencyRelationType Integer 1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2"
  identity 35
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,IurLink=9,ExternalUtranCell=522
    nodeRelationType Integer 1
    frequencyRelationType Integer 1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2"
  identity 36
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,IurLink=11,ExternalUtranCell=822
    nodeRelationType Integer 1
    frequencyRelationType Integer 1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2"
  identity 37
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,IurLink=8,ExternalUtranCell=373
    nodeRelationType Integer 1
    frequencyRelationType Integer 1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2"
  identity 38
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,IurLink=10,ExternalUtranCell=672
    nodeRelationType Integer 1
    frequencyRelationType Integer 1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2"
  identity 39
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,IurLink=2,ExternalUtranCell=12
    nodeRelationType Integer 1
    frequencyRelationType Integer 1 
)
//**********************************
// RNC01-1-3 has 6
//**********************************
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3"
  identity 32
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,IurLink=10,ExternalUtranCell=736
    nodeRelationType Integer 1
    frequencyRelationType Integer 1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3"
  identity 33
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,IurLink=10,ExternalUtranCell=753
    nodeRelationType Integer 1
    frequencyRelationType Integer 1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3"
  identity 34
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,IurLink=11,ExternalUtranCell=824
    nodeRelationType Integer 1
    frequencyRelationType Integer 1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3"
  identity 35
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,IurLink=11,ExternalUtranCell=822
    nodeRelationType Integer 1
    frequencyRelationType Integer 1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3"
  identity 36
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,IurLink=10,ExternalUtranCell=719
    nodeRelationType Integer 1
    frequencyRelationType Integer 1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3"
  identity 37
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,IurLink=10,ExternalUtranCell=703
    nodeRelationType Integer 1
    frequencyRelationType Integer 1 
)
//**********************************
// RNC01-2-1 has 4
//**********************************
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1"
  identity 32
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,IurLink=10,ExternalUtranCell=736
    nodeRelationType Integer 1
    frequencyRelationType Integer 1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1"
  identity 33
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,IurLink=10,ExternalUtranCell=753
    nodeRelationType Integer 1
    frequencyRelationType Integer 1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1"
  identity 34
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,IurLink=10,ExternalUtranCell=703
    nodeRelationType Integer 1
    frequencyRelationType Integer 1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1"
  identity 35
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,IurLink=10,ExternalUtranCell=719
    nodeRelationType Integer 1
    frequencyRelationType Integer 1 
)
//**********************************
// RNC01-2-2 has 4
//**********************************
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2"
  identity 32
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,IurLink=10,ExternalUtranCell=753
    nodeRelationType Integer 1
    frequencyRelationType Integer 1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2"
  identity 33
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,IurLink=10,ExternalUtranCell=736
    nodeRelationType Integer 1
    frequencyRelationType Integer 1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2"
  identity 34
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,IurLink=10,ExternalUtranCell=719
    nodeRelationType Integer 1
    frequencyRelationType Integer 1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2"
  identity 35
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,IurLink=10,ExternalUtranCell=703
    nodeRelationType Integer 1
    frequencyRelationType Integer 1 
)
//**********************************
// RNC01-2-3 has 4
//**********************************
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3"
  identity 32
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,IurLink=10,ExternalUtranCell=736
    nodeRelationType Integer 1
    frequencyRelationType Integer 1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3"
  identity 33
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,IurLink=10,ExternalUtranCell=753
    nodeRelationType Integer 1
    frequencyRelationType Integer 1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3"
  identity 34
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,IurLink=10,ExternalUtranCell=719
    nodeRelationType Integer 1
    frequencyRelationType Integer 1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3"
  identity 35
  moType UtranRelation 
  exception none 
  nrOfAttributes 1 
    utranCellRef Ref ManagedElement=1,RncFunction=1,IurLink=10,ExternalUtranCell=703
    nodeRelationType Integer 1
    frequencyRelationType Integer 1 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1"
  identity 1
  moType EutraNetwork 
  exception none 
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,EutraNetwork=1"
  identity 1
  moType EutranFrequency 
  exception none 
  nrOfAttributes 1 
    earfcnDl Integer 1
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,EutraNetwork=1"
  identity 2
  moType EutranFrequency 
  exception none 
  nrOfAttributes 1 
    earfcnDl Integer 2
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,EutraNetwork=1"
  identity 3
  moType EutranFrequency 
  exception none 
  nrOfAttributes 1 
    earfcnDl Integer 3
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,EutraNetwork=1"
  identity 4
  moType EutranFrequency 
  exception none 
  nrOfAttributes 1 
    earfcnDl Integer 4
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,EutraNetwork=1"
  identity 5
  moType EutranFrequency 
  exception none 
  nrOfAttributes 1 
    earfcnDl Integer 5
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,EutraNetwork=1"
  identity 6
  moType EutranFrequency 
  exception none 
  nrOfAttributes 1 
    earfcnDl Integer 6
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,EutraNetwork=1"
  identity 7
  moType EutranFrequency 
  exception none 
  nrOfAttributes 1 
    earfcnDl Integer 7
)
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,EutraNetwork=1"
  identity 8
  moType EutranFrequency 
  exception none 
  nrOfAttributes 1 
    earfcnDl Integer 8
)
//**********************************
// RNC01-1-1 numOfExtEutranFreqRelations=1
//**********************************
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-1"
  identity 1
  moType EutranFreqRelation 
  exception none 
  nrOfAttributes 1 
    eutranFrequencyRef Ref ManagedElement=1,RncFunction=1,EutraNetwork=1,EutranFrequency=1
    EutranFreqRelationId String 1
    userLabel String "Ref to EutranFrequency=1 (ManagedElement=1,RncFunction=1,EutraNetwork=1,EutranFrequency=1)" 
)
//**********************************
// RNC01-1-2 numOfExtEutranFreqRelations=1
//**********************************
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-2"
  identity 1
  moType EutranFreqRelation 
  exception none 
  nrOfAttributes 1 
    eutranFrequencyRef Ref ManagedElement=1,RncFunction=1,EutraNetwork=1,EutranFrequency=1
    EutranFreqRelationId String 1
    userLabel String "Ref to EutranFrequency=1 (ManagedElement=1,RncFunction=1,EutraNetwork=1,EutranFrequency=1)" 
)
//**********************************
// RNC01-1-3 numOfExtEutranFreqRelations=1
//**********************************
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-1-3"
  identity 1
  moType EutranFreqRelation 
  exception none 
  nrOfAttributes 1 
    eutranFrequencyRef Ref ManagedElement=1,RncFunction=1,EutraNetwork=1,EutranFrequency=1
    EutranFreqRelationId String 1
    userLabel String "Ref to EutranFrequency=1 (ManagedElement=1,RncFunction=1,EutraNetwork=1,EutranFrequency=1)" 
)
//**********************************
// RNC01-2-1 numOfExtEutranFreqRelations=1
//**********************************
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-1"
  identity 1
  moType EutranFreqRelation 
  exception none 
  nrOfAttributes 1 
    eutranFrequencyRef Ref ManagedElement=1,RncFunction=1,EutraNetwork=1,EutranFrequency=1
    EutranFreqRelationId String 1
    userLabel String "Ref to EutranFrequency=1 (ManagedElement=1,RncFunction=1,EutraNetwork=1,EutranFrequency=1)" 
)
//**********************************
// RNC01-2-2 numOfExtEutranFreqRelations=1
//**********************************
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-2"
  identity 1
  moType EutranFreqRelation 
  exception none 
  nrOfAttributes 1 
    eutranFrequencyRef Ref ManagedElement=1,RncFunction=1,EutraNetwork=1,EutranFrequency=1
    EutranFreqRelationId String 1
    userLabel String "Ref to EutranFrequency=1 (ManagedElement=1,RncFunction=1,EutraNetwork=1,EutranFrequency=1)" 
)
//**********************************
// RNC01-2-3 numOfExtEutranFreqRelations=1
//**********************************
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-2-3"
  identity 1
  moType EutranFreqRelation 
  exception none 
  nrOfAttributes 1 
    eutranFrequencyRef Ref ManagedElement=1,RncFunction=1,EutraNetwork=1,EutranFrequency=1
    EutranFreqRelationId String 1
    userLabel String "Ref to EutranFrequency=1 (ManagedElement=1,RncFunction=1,EutraNetwork=1,EutranFrequency=1)" 
)
//**********************************
// RNC01-3-1 numOfExtEutranFreqRelations=1
//**********************************
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-1"
  identity 1
  moType EutranFreqRelation 
  exception none 
  nrOfAttributes 1 
    eutranFrequencyRef Ref ManagedElement=1,RncFunction=1,EutraNetwork=1,EutranFrequency=1
    EutranFreqRelationId String 1
    userLabel String "Ref to EutranFrequency=1 (ManagedElement=1,RncFunction=1,EutraNetwork=1,EutranFrequency=1)" 
)
//**********************************
// RNC01-3-2 numOfExtEutranFreqRelations=1
//**********************************
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-2"
  identity 1
  moType EutranFreqRelation 
  exception none 
  nrOfAttributes 1 
    eutranFrequencyRef Ref ManagedElement=1,RncFunction=1,EutraNetwork=1,EutranFrequency=1
    EutranFreqRelationId String 1
    userLabel String "Ref to EutranFrequency=1 (ManagedElement=1,RncFunction=1,EutraNetwork=1,EutranFrequency=1)" 
)
//**********************************
// RNC01-3-3 numOfExtEutranFreqRelations=1
//**********************************
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,UtranCell=RNC01-3-3"
  identity 1
  moType EutranFreqRelation 
  exception none 
  nrOfAttributes 1 
    eutranFrequencyRef Ref ManagedElement=1,RncFunction=1,EutraNetwork=1,EutranFrequency=1
    EutranFreqRelationId String 1
    userLabel String "Ref to EutranFrequency=1 (ManagedElement=1,RncFunction=1,EutraNetwork=1,EutranFrequency=1)" 
)
