---@diagnostic disable: redundant-parameter, undefined-global

--***************************************************************
-- Inside of this script, you will find the relevant parameters
-- for this module and its default values
--***************************************************************

local functions = {}

local function getParameters()

  local fieldbusParameters = {}

  fieldbusParameters.flowConfigPriority = CSK_FlowConfig ~= nil or false -- Status if FlowConfig should have priority for FlowConfig relevant configurations
  fieldbusParameters.protocol = 'DISABLED' -- Type of fieldbus communication, e.g. 'DISABLED' (0) / 'ProfinetIO' (1) / 'EtherNetIP' (2) / 'ETHERCAT' (not available yet)
  fieldbusParameters.createMode = 'EXPLICIT_OPEN' -- or 'EXPLICIT_OPEN', AUTOMATIC_OPEN
  fieldbusParameters.transmissionMode = 'RAW' -- or 'RAW', CONFIRMED_MESSAGING
  fieldbusParameters.active = false -- Status if fieldbus connection should be established
  fieldbusParameters.forceIPSetup = false -- Status if IP config of PersistentData should be forced. Set to false to only rely on saved parameters of StorageRequest

  fieldbusParameters.dataNamesTransmit = {} -- List of names/identifiers of data entries to transmit
  fieldbusParameters.registeredEventsTransmit = {} -- List of names of event to receive data to transmit
  fieldbusParameters.convertDataTypesTransmit = {} -- Status if received data needs to be converted to binary or is already binary
  fieldbusParameters.dataTypesTransmit = {} -- Data types of values to transmit
  fieldbusParameters.bigEndiansTransmit = {} -- Little endian per default

  fieldbusParameters.registeredEventControlBitsIn = '' -- Event to set ControlBitsIn

  fieldbusParameters.dataNamesReceive = {} -- List of names/identifiers of data entries to transmit
  fieldbusParameters.convertDataTypesReceive = {} -- Status if received data needs to be converted to binary or is already binary
  fieldbusParameters.dataTypesReceive = {} -- Data types of values to transmit
  fieldbusParameters.bigEndiansReceive = {} -- Little endian per default

  fieldbusParameters.etherNetIP = {}
  fieldbusParameters.etherNetIP.storageRequestDataPath = '/public/FieldBus/EtherNetIP/StorageData.dat' -- Path to store fieldbus storage data.
  fieldbusParameters.etherNetIP.addressingMode = 'STATIC' -- or 'DHCP' / 'BOOTP'
  fieldbusParameters.etherNetIP.ipAddress = '192.168.0.1' -- IP address
  fieldbusParameters.etherNetIP.ipAddress2 = '192.168.0.1' -- IP address
  fieldbusParameters.etherNetIP.netmask = '255.255.255.0' --  Subnet mask
  fieldbusParameters.etherNetIP.netmask2 = '255.255.255.0' --  Backup subnet mask --TODO never used?
  fieldbusParameters.etherNetIP.gateway = '0.0.0.0' -- Gateway address
  fieldbusParameters.etherNetIP.gateway2 = '0.0.0.0' -- Backup Gateway address --TODO never used?
  fieldbusParameters.etherNetIP.nameServer = '0.0.0.0' -- Primary name server
  fieldbusParameters.etherNetIP.nameServer2 = '0.0.0.0' -- Secondary name server
  fieldbusParameters.etherNetIP.domainName = '' -- Domain name
  fieldbusParameters.etherNetIP.macAddress = '' -- MAC address of fieldbus implementation.

  fieldbusParameters.profinetIO = {}
  fieldbusParameters.profinetIO.storageRequestDataPath = '/public/FieldBus/ProfinetIO/StorageData.dat' -- Path to store fieldbus storage data.
  fieldbusParameters.profinetIO.deviceName = '' -- Device name
  fieldbusParameters.profinetIO.remanent = false -- Status if the network configuration tool sets the current name of the device permanently (true), that is, it will be reloaded after a restart of the device.
  fieldbusParameters.profinetIO.ipAddress = '0.0.0.0' -- IP address
  fieldbusParameters.profinetIO.netmask = '255.255.255.0' --  Subnet mask
  fieldbusParameters.profinetIO.gateway = '0.0.0.0' -- Gateway address
  fieldbusParameters.profinetIO.macAddress = '' -- MAC address of fieldbus implementation.

  fieldbusParameters.profinetIO.dapImDescriptor = 'Descriptor' -- The descriptor (a.k.a. 'comment') as used for the DAP’s (device access point) I&M3 data.
  fieldbusParameters.profinetIO.dapImHardwareRev = 0 --  Hardware revision as used for the DAP (device access point) used in the I&M0 data.
  fieldbusParameters.profinetIO.dapImInstallDate = 'YYYY-MM-DD' -- Installation date as used for the DAP’s (device access point) I&M2 data.

  -- Software revision for the DAP (device access point) used in the I&M0 data.
  fieldbusParameters.profinetIO.dapImSoftwareRevPrefix = 'Prefix' -- Prefix character of the software revision of this I&M0 data.
  fieldbusParameters.profinetIO.dapImSoftwareRevFuncEnhancement = 0 -- Functional enhancement identifier of the software revision of this I&M0 data.
  fieldbusParameters.profinetIO.dapImSoftwareRevBugFix = 0 -- Bug fix identifier of the software revision of this I&M0 data.
  fieldbusParameters.profinetIO.dapImSoftwareRevInternalChange = 0 -- Internal change identifier of the software revision of this I&M0 data.

  fieldbusParameters.profinetIO.dapImTagFunction = 'PlantDesignation' -- Function tag (a.k.a. 'plant designation') as used for the DAP’s (device access point) I&M1 data.
  fieldbusParameters.profinetIO.dapImTagLocation = 'LocationIdentifier' -- Location tag (a.k.a. 'location identifier') as used for the DAP’s (device access point) I&M1 data.

  return fieldbusParameters
end
functions.getParameters = getParameters

return functions