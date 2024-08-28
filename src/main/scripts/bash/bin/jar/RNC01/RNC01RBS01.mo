CREATE 
( 
 parent "ManagedElement=1,Equipment=1"
  identity 1
  moType HwUnit 
  exception none 
  nrOfAttributes 1 
)
CREATE 
( 
 parent "ManagedElement=1,Equipment=1"
  identity 1
  moType AuxPlugInUnit 
  exception none 
  nrOfAttributes 1 
  auType Integer 1
  productName String ""
  productNumber String KRC161444/1
  productRevision String P1A
  productionDate String 20140313
  serialNumber String C827673131
)
CREATE 
( 
 parent "ManagedElement=1,Equipment=1,AuxPlugInUnit=1"
  identity 1
  moType RetuDeviceGroup 
  exception none 
)
CREATE 
( 
 parent "ManagedElement=1,Equipment=1,AuxPlugInUnit=1,RetuDeviceGroup=1,RetDeviceSet=1"
  identity 1
  moType RetDevice 
  exception none 
  nrOfAttributes 1 
"aretDeviceData" Struct 
nrOfElements 13 
		antennaModelNumber String "" 
		antennaSerialNumber String "" 
		antennaOperatingBand Integer 0 
		beamwidthForBands Array Integer 0 
		gainForBands Array Integer 0 
 	maxSupportedElectricalTilt Integer 0 
		installationDate String "" 
		installersId String "" 
		baseStationId String "" 
		sectorId String "" 
		antennaBearing Integer 1013
		installedMechTilt Integer 0 
		minSupportedElectricalTilt Integer 0
)
CREATE 
( 
 parent "ManagedElement=1,NodeBFunction=1"
  identity 1
  moType Sector 
  exception none 
  nrOfAttributes 3 
    "longitude" Integer -457860
    "latitude" Integer 5065465
    "height" String 89599
    "beamDirection" String 198
		retDevicesRef Array Ref 1
 	"ManagedElement=1,Equipment=1,AuxPlugInUnit=1,RetuDeviceGroup=1,RetDeviceSet=1,RetDevice=1" 
		sectorAntennasRef Array Ref 1
 	"ManagedElement=1,Equipment=1,SectorAntenna=1" 
)
CREATE 
( 
 parent "ManagedElement=1,NodeBFunction=1,Sector=1"
  identity 1
  moType Carrier 
  exception none 
  nrOfAttributes 0 
)
CREATE 
( 
 parent "ManagedElement=1,NodeBFunction=1,Sector=1"
  identity 2
  moType Carrier 
  exception none 
  nrOfAttributes 0 
)
CREATE 
( 
 parent "ManagedElement=1,NodeBFunction=1,Sector=1"
  identity 3
  moType Carrier 
  exception none 
  nrOfAttributes 0 
)
CREATE 
( 
 parent "ManagedElement=1,NodeBFunction=1"
  identity 1
  moType RbsLocalCell 
  exception none 
  nrOfAttributes 3 
		 localCellId Integer 1
"carrierRef" Ref "ManagedElement=1"
 	 maxDlPowerCapability Integer 400 
) 
SET 
( 
 mo "ManagedElement=1,NodeBFunction=1,RbsLocalCell=1"
  exception none 
  nrOfAttributes 1 
"carrierRef" Ref "ManagedElement=1,NodeBFunction=1,Sector=1,Carrier=1"
)
CREATE 
( 
 parent "ManagedElement=1,NodeBFunction=1"
  identity 2
  moType RbsLocalCell 
  exception none 
  nrOfAttributes 3 
		 localCellId Integer 2
"carrierRef" Ref "ManagedElement=1"
 	 maxDlPowerCapability Integer 400 
) 
SET 
( 
 mo "ManagedElement=1,NodeBFunction=1,RbsLocalCell=2"
  exception none 
  nrOfAttributes 1 
"carrierRef" Ref "ManagedElement=1,NodeBFunction=1,Sector=1,Carrier=2"
)
CREATE 
( 
 parent "ManagedElement=1,NodeBFunction=1"
  identity 3
  moType RbsLocalCell 
  exception none 
  nrOfAttributes 3 
		 localCellId Integer 3
"carrierRef" Ref "ManagedElement=1"
 	 maxDlPowerCapability Integer 400 
) 
SET 
( 
 mo "ManagedElement=1,NodeBFunction=1,RbsLocalCell=3"
  exception none 
  nrOfAttributes 1 
"carrierRef" Ref "ManagedElement=1,NodeBFunction=1,Sector=1,Carrier=3"
)
