---@diagnostic disable: undefined-global, redundant-parameter, missing-parameter
--*****************************************************************
-- Inside of this script, you will find the module definition
-- including its parameters and functions
--*****************************************************************

--**************************************************************************
--**********************Start Global Scope *********************************
--**************************************************************************
local nameOfModule = 'CSK_Fieldbus'

local fieldbus_Model = {}

-- Check if CSK_UserManagement module can be used if wanted
fieldbus_Model.userManagementModuleAvailable = CSK_UserManagement ~= nil or false

-- Check if CSK_PersistentData module can be used if wanted
fieldbus_Model.persistentModuleAvailable = CSK_PersistentData ~= nil or false

-- Default values for persistent data
-- If available, following values will be updated from data of CSK_PersistentData module (check CSK_PersistentData module for this)
fieldbus_Model.parametersName = 'CSK_Fieldbus_Parameter' -- name of parameter dataset to be used for this module
fieldbus_Model.parameterLoadOnReboot = false -- Status if parameter dataset should be loaded on app/device reboot

-- Load script to communicate with the Fieldbus_Model interface and give access
-- to the Fieldbus_Model object.
-- Check / edit this script to see/edit functions which communicate with the UI
local setFieldbus_ModelHandle = require('Communication/Fieldbus/Fieldbus_Controller')
setFieldbus_ModelHandle(fieldbus_Model)

--Loading helper functions if needed
fieldbus_Model.helperFuncs = require('Communication/Fieldbus/helper/funcs')

-- Check if specific API was loaded via
fieldbus_Model.moduleActive = _G.availableAPIs.specific

-- Check if needed CROWN is available on device
if FieldBus == nil then
  fieldbus_Model.moduleActive = false
  _G.logger:warning(nameOfModule .. ': CROWN is not available. Module is not supported...')
end

if _G.availableAPIs.setFBProtocol then
  local fbMode = FieldBus.Config.getProtocol()
  if fbMode == 'ETHERNETIP' then
    fieldbus_Model.fbMode = 'EtherNetIP'
  elseif fbMode == 'PROFINETIO' then
    fieldbus_Model.fbMode = 'ProfinetIO'
  else
    fieldbus_Model.fbMode = 'DISABLED'
  end
else
  local fbMode = Parameters.get('FBmode')
  if fbMode == 1 then
    fieldbus_Model.fbMode = 'ProfinetIO'
  elseif fbMode == 2 then
    fieldbus_Model.fbMode = 'EtherNetIP'
  else
    fieldbus_Model.fbMode = 'DISABLED'
  end
end

-- Create parameters / instances for this module
fieldbus_Model.styleForUI = 'None' -- Optional parameter to set UI style
fieldbus_Model.version = Engine.getCurrentAppVersion() -- Version of module

fieldbus_Model.handle = nil -- Fieldbus handle
fieldbus_Model.opened = false -- Status if fieldbus handle was opended.
fieldbus_Model.currentStatus = 'CLOSED' -- Current status of the fieldbus communication.
fieldbus_Model.info = 'No info available.' -- Information of the fieldbus component.

fieldbus_Model.controlBitsIn = 0 -- Current value of the control bits transmitted to the PLC.
fieldbus_Model.boolControlBitsIn = {false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false}  -- Status of ControlBitsIN as boolean table
fieldbus_Model.controlBitsOut = 0 -- Current value of the control bits received from the PLC.
fieldbus_Model.boolControlBitsOut = {false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false}  -- Status of ControlBitsOUT as boolean table
fieldbus_Model.controlBitsToWrite = 0 -- Preset control bits to write.
fieldbus_Model.boolControlBitsToWrite = {false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false}  -- Status of ControlBitsIN to write as boolean table
fieldbus_Model.bitMask = 65535 -- Preset bitMask to use for controlBits.
fieldbus_Model.boolBitMask = {true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true}  -- Status of mask of ControlBitsIN to write as boolean table

fieldbus_Model.dataUpdateFunctions = {} -- Functions to update transmit data
fieldbus_Model.transmissionDataList = '' -- List of data entries for transmission

fieldbus_Model.selectedDataTransmit = '' -- Number of selected data entry in UI table
fieldbus_Model.selectedDataReceive = '' -- Number of selected data entry in UI table
fieldbus_Model.tempDataTransmit = '' -- Data to temporarily set for selected transmit data

fieldbus_Model.dataToTransmit = {} -- Preset data to transmit (binary)
fieldbus_Model.readableDataToTransmit = {} -- Readbale preset data to transmit
fieldbus_Model.fullDataToTransmit = '' -- Full binary string including all data to transmit
fieldbus_Model.dataNameTransmit = 'DataName' -- Preconfigured name of data to setup for transmission
fieldbus_Model.registerEventTransmit = 'OtherModule.OnNewEvent' -- Preconfigured event to register to receive transmit data
fieldbus_Model.convertDataTransmit = true -- Preconfigured status if received data should be converted before transmission
fieldbus_Model.bigEndianTransmit = true -- Preconfigured status of endianness for data to transmit, little endian per default
fieldbus_Model.dataTypeTransmit = 'U_INT1' -- Preconfigured data type of data to setup for transmission
fieldbus_Model.totalDataSizeTransmit = 0 -- Sum of data size to transmit

fieldbus_Model.dataReceived = {} -- Holding received values per data entry
fieldbus_Model.dataNameReceive = 'DataName' -- Preconfigured name of data to setup for receiving
fieldbus_Model.convertDataReceive = true -- Preconfigured status if received data should be converted before transmission
fieldbus_Model.bigEndianReceive = true -- Preconfigured status of endianness for data to transmit, little endian per default
fieldbus_Model.dataTypeReceive = 'U_INT1' -- Preconfigured data type of data to setup for transmission
fieldbus_Model.totalDataSizeReceive = 0 -- Sum of data size to transmit

-- Parameters to be saved permanently if wanted
fieldbus_Model.parameters = {}
fieldbus_Model.parameters = fieldbus_Model.helperFuncs.defaultParameters.getParameters() -- Load default parameters

fieldbus_Model.parameters.protocol = fieldbus_Model.fbMode -- Type of fieldbus communication, e.g. 'DISABLED' (0) / 'ProfinetIO' (1) / 'EtherNetIP' (2) / 'ETHERCAT' (not available yet)


--- Function to create folder if it does not exists
---@param folder string Name of folder to create if it does not exists already
local function createFolder(folder)
  local folderExists = File.isdir(folder)
  if not folderExists then
    local suc = File.mkdir(folder)
    if not suc then
      _G.logger:warning(nameOfModule .. ': Not possible to create folder on device.')
    end
  end
end
-- Create default folders for the module
createFolder('/public/FieldBus')
createFolder('/public/FieldBus/EtherNetIP')
createFolder('/public/FieldBus/ProfinetIO')

--**************************************************************************
--********************** End Global Scope **********************************
--**************************************************************************
--**********************Start Function Scope *******************************
--**************************************************************************

--- Function to react on UI style change
local function handleOnStyleChanged(theme)
  fieldbus_Model.styleForUI = theme
  Script.notifyEvent("Fieldbus_OnNewStatusCSKStyle", fieldbus_Model.styleForUI)
end
Script.register('CSK_PersistentData.OnNewStatusCSKStyle', handleOnStyleChanged)

--- Function to get various information about the fieldbus, its componentes and internals.
local function getInfo()
  if fieldbus_Model.handle then
    fieldbus_Model.info = FieldBus.getInfo(fieldbus_Model.handle)
    Script.notifyEvent("Fieldbus_OnNewStatusFieldbusInfo", fieldbus_Model.helperFuncs.jsonLine2Table(fieldbus_Model.info))
  else
    fieldbus_Model.info ="Fieldbus handle not created yet."
    Script.notifyEvent("Fieldbus_OnNewStatusFieldbusInfo", fieldbus_Model.info)
  end
end
fieldbus_Model.getInfo = getInfo

--- Function to get status information about the fieldbus.
local function getStatus()
  if fieldbus_Model.handle then
    fieldbus_Model.currentStatus = FieldBus.getStatus(fieldbus_Model.handle)
    Script.notifyEvent("Fieldbus_OnNewStatusFieldbusStatus", fieldbus_Model.currentStatus)
  else
    fieldbus_Model.currentStatus ="Fieldbus handle not created yet."
    Script.notifyEvent("Fieldbus_OnNewStatusFieldbusStatus", fieldbus_Model.currentStatus)
  end
end
fieldbus_Model.getStatus = getStatus

-----------------------
-- EtherNet/IP relevant
-----------------------

local function getEtherNetIPConfig()

  fieldbus_Model.parameters.etherNetIP.addressingMode = FieldBus.Config.EtherNetIP.getAddressingMode()
  Script.notifyEvent("Fieldbus_OnNewStatusEtherNetIPAddressingMode", fieldbus_Model.parameters.etherNetIP.addressingMode)

  if fieldbus_Model.parameters.etherNetIP.addressingMode == 'DHCP' or fieldbus_Model.parameters.etherNetIP.addressingMode == 'BOOTP' then
    Script.notifyEvent("Fieldbus_OnNewStatusDHCPEnabled", true)
  else
    Script.notifyEvent("Fieldbus_OnNewStatusDHCPEnabled", false)
  end

  local ipAddress, netmask, gateway, nameServer, nameServer2, domainName = FieldBus.Config.EtherNetIP.getInterfaceConfig()

  fieldbus_Model.parameters.etherNetIP.ipAddress = ipAddress
  Script.notifyEvent("Fieldbus_OnNewStatusEtherNetIPIPAddress", fieldbus_Model.parameters.etherNetIP.ipAddress)
  fieldbus_Model.parameters.etherNetIP.netmask = netmask
  Script.notifyEvent("Fieldbus_OnNewStatusEtherNetIPGateway", fieldbus_Model.parameters.etherNetIP.gateway)
  fieldbus_Model.parameters.etherNetIP.gateway = gateway
  Script.notifyEvent("Fieldbus_OnNewStatusEtherNetIPSubnetMask", fieldbus_Model.parameters.etherNetIP.netmask)
  fieldbus_Model.parameters.etherNetIP.nameServer = nameServer
  Script.notifyEvent("Fieldbus_OnNewStatusEtherNetIPNameServer", fieldbus_Model.parameters.etherNetIP.nameServer)
  fieldbus_Model.parameters.etherNetIP.nameServer2 = nameServer2
  Script.notifyEvent("Fieldbus_OnNewStatusEtherNetIPNameServer2", fieldbus_Model.parameters.etherNetIP.nameServer2)
  fieldbus_Model.parameters.etherNetIP.domainName = domainName
  Script.notifyEvent("Fieldbus_OnNewStatusEtherNetIPDomainName", fieldbus_Model.parameters.etherNetIP.domainName)

  fieldbus_Model.parameters.etherNetIP.macAddress = FieldBus.Config.EtherNetIP.getMACAddress()
  if nil == fieldbus_Model.parameters.etherNetIP.macAddress then
    _G.logger:info("ENIP: FieldBus.Config.EtherNetIP.getMACAddress returned NIL!!!")
    fieldbus_Model.parameters.etherNetIP.macAddress = ''
  end
  Script.notifyEvent("Fieldbus_OnNewStatusEtherNetIPMACAddress", fieldbus_Model.parameters.etherNetIP.macAddress)
  getInfo()
  getStatus()
end
fieldbus_Model.getEtherNetIPConfig = getEtherNetIPConfig

local function callSetInterfaceConfig()
  FieldBus.Config.EtherNetIP.setInterfaceConfig(
    fieldbus_Model.parameters.etherNetIP.ipAddress,
    fieldbus_Model.parameters.etherNetIP.netmask,
    fieldbus_Model.parameters.etherNetIP.gateway,
    fieldbus_Model.parameters.etherNetIP.nameServer,
    fieldbus_Model.parameters.etherNetIP.nameServer2,
    fieldbus_Model.parameters.etherNetIP.domainName
    )

    getInfo()
    getStatus()
end

--- Function to validate preconfigured setup of EtherNet/IP
local function checkEtherNetIPConfig()
  if fieldbus_Model.parameters.etherNetIP.ipAddress ~= '0.0.0.0' and fieldbus_Model.parameters.etherNetIP.netmask ~= '0.0.0.0' then
    if fieldbus_Model.parameters.etherNetIP.gateway ~= '0.0.0.0' then
      local ipCheck = fieldbus_Model.helperFuncs.checkIPSetup(fieldbus_Model.parameters.etherNetIP.ipAddress, fieldbus_Model.parameters.etherNetIP.netmask, fieldbus_Model.parameters.etherNetIP.gateway)
      if not ipCheck then
        _G.logger:info("Make sure that EtherNet/IP setup is correct: IP=" .. tostring(fieldbus_Model.parameters.etherNetIP.ipAddress) .. ', Mask=' .. tostring(fieldbus_Model.parameters.etherNetIP.netmask) .. ', GW=' .. tostring(fieldbus_Model.parameters.etherNetIP.gateway))
      end
      callSetInterfaceConfig()
    else
      if _G.availableAPIs.isSIM800 then
        local newGW = fieldbus_Model.helperFuncs.getIPSameSubnet(fieldbus_Model.parameters.etherNetIP.ipAddress, fieldbus_Model.parameters.etherNetIP.netmask)
        if newGW ~= nil then
          fieldbus_Model.parameters.etherNetIP.gateway = newGW
          _G.logger:info("Gateway '0.0.0.0' is not allowed. Will set it to " .. tostring(fieldbus_Model.parameters.etherNetIP.gateway))
          callSetInterfaceConfig()
        else
          _G.logger:warning("Was not able to set EtherNet/IP configuration. Please check configuration.")
          fieldbus_Model.info = "Was not able to set EtherNet/IP configuration. Please check configuration."
        end
      else
        callSetInterfaceConfig()
      end
    end
  else
    _G.logger:warning("EtherNet/IP IP Address / Mask not valid = " .. tostring(fieldbus_Model.parameters.etherNetIP.ipAddress) .. " / " .. tostring(fieldbus_Model.parameters.etherNetIP.netmask))
    fieldbus_Model.info = "Cannot configure EtherNet/IP connection. IP Address / NetMask = " .. tostring(fieldbus_Model.parameters.etherNetIP.ipAddress) .. " / " .. tostring(fieldbus_Model.parameters.etherNetIP.netmask)
  end
end

-- Function to set EtherNet/IP config
local function setEtherNetIPConfig()
  local suc = FieldBus.Config.EtherNetIP.setAddressingMode(fieldbus_Model.parameters.etherNetIP.addressingMode)

  getInfo()
  getStatus()

  if fieldbus_Model.parameters.etherNetIP.addressingMode == 'STATIC' then
    checkEtherNetIPConfig()
  end

end
fieldbus_Model.setEtherNetIPConfig = setEtherNetIPConfig

-- Function to react on received EtherNet/IP addressing mode
---@param addressingMode FieldBus.Config.EtherNetIP.AddressingMode Addressing mode for the ip parameters.
local function handleOnAddressingModeChanged(addressingMode)
  _G.logger:fine("New EtherNet/IP AddressingMode = " .. tostring(addressingMode))
  getInfo()
  getStatus()
  getEtherNetIPConfig()
end

-- Function to react on received EtherNet/IP interface config.
---@param ipAddress string IP address.
---@param netmask string Subnetmask.
---@param gateway string Gateway IP address.
---@param nameServer? string Primary name server.
---@param nameServer2? string Secondary name server.
---@param domainName? string Default domain name.
local function handleOnEthernetIPInterfaceConfigChanged(ipAddress, netmask, gateway, nameServer, nameServer2, domainName)
  _G.logger:fine("ENIP: OnEthernetIPInterfaceConfigChanged event received! IP: " .. tostring(ipAddress) .. ', Mask: ' .. tostring(netmask) .. ', GW: ' .. tostring(gateway) .. ', Nameserver: ' .. tostring(nameServer) .. ', Nameserver2: ' .. tostring(nameServer2) .. ', Domain: ' .. tostring(domainName))
  getInfo()
  getStatus()
  getEtherNetIPConfig()
end

-- Function to react on FieldbusStoreRequest
---@param storageHandle FieldBus.StorageRequest Object containing the data to be saved or loaded
local function handleOnEtherNetIPFieldbusStorageRequest(storageHandle)

  local storageOperation = FieldBus.StorageRequest.getOperation(storageHandle)
  _G.logger:fine("ENIP: OnFieldbusStorageRequest event received, operation: " .. tostring(storageOperation))
  local dataToStore = FieldBus.StorageRequest.getData(storageHandle)
  local dataFromFile = nil
  local storageResult = false

  if storageOperation == "SAVE" then --FieldBus.StorageRequest.StorageOperation.Save
    -- store in a file
    local handle = File.open(fieldbus_Model.parameters.etherNetIP.storageRequestDataPath, 'wb')
    if handle then
      File.write(handle, dataToStore)
      File.close(handle)
      storageResult = true
    else
      _G.logger:severe(string.format("Failed to open file for saving of storage data!"))
    end
  end

  if storageOperation == "LOAD" then --FieldBus.StorageRequest.StorageOperation.Load
  -- load from a file
    local handle = File.open(fieldbus_Model.parameters.etherNetIP.storageRequestDataPath, 'rb')
    if handle then
      dataFromFile = File.read(handle)
      File.close(handle)
      storageResult = FieldBus.StorageRequest.setData(storageHandle, dataFromFile)
      if storageResult == false then
        _G.logger:severe(string.format("Setting data at storage request failed"))
      else
        _G.logger:info(string.format("Setting data at storage request succeeded"))
      end
    else
      _G.logger:info(string.format("Failed to open file to load storage data (file might not exists yet)."))
      storageResult = false
    end
  end
  FieldBus.StorageRequest.notifyResult(storageHandle, storageResult)
  CSK_Fieldbus.pageCalled()
end

-----------------------
-- ProfinetIO relevant
-----------------------

--- Function to apply ProfinetIO config
local function applyProfinetIOConfig()
  local suc = FieldBus.Config.ProfinetIO.applyConfig()
  _G.logger:fine("Success of ApplyConfig = " .. tostring(suc))
end
fieldbus_Model.applyProfinetIOConfig = applyProfinetIOConfig

--- Function to store ProfinetIO config
local function storeProfinetIOConfig()
  local suc = FieldBus.Config.ProfinetIO.storeConfig()
  _G.logger:fine('Store config = ' .. tostring(suc))
end
fieldbus_Model.storeProfinetIOConfig = storeProfinetIOConfig

--- Function to react on received ProfinetIO DeviceName.
---@param deviceName string Currently active name of the device
---@param remanent bool True if the network configuration tool sets the current name of the device permanently, that is, it will be reloaded after a restart of the device.
local function handleOnDeviceNameChanged(deviceName, remanent)
  _G.logger:fine("Received DeviceName info!")
  _G.logger:fine("Name = " .. tostring(deviceName))
  _G.logger:fine("Remanent = " .. tostring(remanent))

  fieldbus_Model.parameters.profinetIO.deviceName = deviceName
  fieldbus_Model.parameters.profinetIO.remanent = remanent

  FieldBus.Config.ProfinetIO.setDeviceName(fieldbus_Model.parameters.profinetIO.deviceName)
  applyProfinetIOConfig()

  if remanent == true then
    storeProfinetIOConfig()
  end

  CSK_Fieldbus.pageCalled()

end

-- Function to react on received ProfinetIO interface config.
---@param ipAddress string Currently active (applied) IP address
---@param subnetMask string Currently active (applied) subnet mask
---@param gateway string Currently active (applied) gateway address
---@param remanent bool True if the network configuration tool sets the current IP address settings permanently, that is, it will be reloaded after a restart of the device.
local function handleOnProfinetIOInterfaceConfigChanged(ipAddress, subnetMask, gateway, remanent)
  _G.logger:fine("New ProfinetIO interface config:")
  _G.logger:fine("IP Address / NetMask = " .. tostring(ipAddress) .. ' / ' .. tostring(subnetMask))
  _G.logger:fine("Gateway = " .. tostring(gateway))
  _G.logger:fine("Remanent = " .. tostring(remanent))

  fieldbus_Model.parameters.profinetIO.ipAddress = ipAddress
  fieldbus_Model.parameters.profinetIO.subnetMask = subnetMask
  fieldbus_Model.parameters.profinetIO.gateway = gateway
  fieldbus_Model.parameters.profinetIO.remanent = remanent

  FieldBus.Config.ProfinetIO.setInterfaceConfig(fieldbus_Model.parameters.profinetIO.ipAddress, fieldbus_Model.parameters.profinetIO.subnetMask, fieldbus_Model.parameters.profinetIO.gateway)

  applyProfinetIOConfig()

  if remanent == true then
    storeProfinetIOConfig()
  end
  CSK_Fieldbus.pageCalled()

end

--- Function to get DAP I&M Config info
local function getDapImConfigInfo()
  fieldbus_Model.parameters.profinetIO.dapImDescriptor = FieldBus.Config.ProfinetIO.getDapImDescriptor()
  fieldbus_Model.parameters.profinetIO.dapImHardwareRev = FieldBus.Config.ProfinetIO.getDapImHardwareRev()
  fieldbus_Model.parameters.profinetIO.dapImInstallDate  = FieldBus.Config.ProfinetIO.getDapImInstallDate()
  fieldbus_Model.parameters.profinetIO.dapImSoftwareRevPrefix, fieldbus_Model.parameters.profinetIO.dapImSoftwareRevFuncEnhancement, fieldbus_Model.parameters.profinetIO.dapImSoftwareRevBugFix, fieldbus_Model.parameters.profinetIO.dapImSoftwareRevInternalChange = FieldBus.Config.ProfinetIO.getDapImSoftwareRev()
  fieldbus_Model.parameters.profinetIO.tagFunction = FieldBus.Config.ProfinetIO.getDapImTagFunction()
  fieldbus_Model.parameters.profinetIO.tagLocation = FieldBus.Config.ProfinetIO.getDapImTagLocation()
end
fieldbus_Model.getDapImConfigInfo = getDapImConfigInfo

--- Function to set DAP I&M config
local function setDapImConfig()
  FieldBus.Config.ProfinetIO.setDapImDescriptor(fieldbus_Model.parameters.profinetIO.dapImDescriptor)
  FieldBus.Config.ProfinetIO.setDapImInstallDate(fieldbus_Model.parameters.profinetIO.dapImInstallDate)
  FieldBus.Config.ProfinetIO.setDapImTagFunction(fieldbus_Model.parameters.profinetIO.tagFunction)
  FieldBus.Config.ProfinetIO.setDapImTagLocation(fieldbus_Model.parameters.profinetIO.tagLocation)
end
fieldbus_Model.setDapImConfig = setDapImConfig

--- Function to store DAP I&M config
local function storeDapImData()
  local suc = FieldBus.Config.ProfinetIO.storeDapImData()
end
fieldbus_Model.storeDapImData = storeDapImData

--- Function to get DAP I&M config
local function getProfinetIOConfigInfo()
  fieldbus_Model.parameters.profinetIO.deviceName = FieldBus.Config.ProfinetIO.getDeviceName()
  fieldbus_Model.parameters.profinetIO.ipAddress, fieldbus_Model.parameters.profinetIO.subnetMask, fieldbus_Model.parameters.profinetIO.gateway, fieldbus_Model.parameters.profinetIO.remanent = FieldBus.Config.ProfinetIO.getInterfaceConfig()

  local macAddress = FieldBus.Config.ProfinetIO.getMACAddress('INTERFACE')
  if macAddress then
    fieldbus_Model.parameters.profinetIO.macAddress = macAddress
  else
    fieldbus_Model.parameters.profinetIO.macAddress = ''
  end
  getDapImConfigInfo()

  CSK_Fieldbus.pageCalled()

end
fieldbus_Model.getProfinetIOConfigInfo = getProfinetIOConfigInfo

--- Function to react on FieldbusStoreRequest
---@param storageHandle FieldBus.StorageRequest Object containing the data to be saved or loaded
local function handleOnProfinetIOFieldbusStorageRequest(storageHandle)
  local operation = FieldBus.StorageRequest.getOperation(storageHandle)
  _G.logger:fine('StorageRequest operation = ' .. tostring(operation))
  if operation == 'LOAD' then
    -- Check if file exists
    local dataFile = File.open(fieldbus_Model.parameters.profinetIO.storageRequestDataPath, 'rb')
    local setSuc = false

    if dataFile then
      local data = File.read(dataFile)
      File.close(dataFile)
      setSuc = FieldBus.StorageRequest.setData(storageHandle, data)
      _G.logger:fine("Setting data = " .. tostring(setSuc))
      getProfinetIOConfigInfo()
    else
      _G.logger:info("Not able to LOAD data.")
    end

    if setSuc then
      FieldBus.StorageRequest.notifyResult(storageHandle, true)
    else
      FieldBus.StorageRequest.notifyResult(storageHandle, false)
    end

  elseif operation == 'SAVE' then
    local data = FieldBus.StorageRequest.getData(storageHandle)
    local dataFile = File.open(fieldbus_Model.parameters.profinetIO.storageRequestDataPath, 'wb')

    local suc = File.write(dataFile, data)
    File.close(dataFile)
    _G.logger:fine("Result to write SR = " .. tostring(suc))

    if suc then
      FieldBus.StorageRequest.notifyResult(storageHandle, true)
    else
      FieldBus.StorageRequest.notifyResult(storageHandle, false)
    end
    CSK_Fieldbus.pageCalled()
  end
end

-----------------------
-- General functions --
-----------------------

-- Function to react on received data of PLC.
---@param data binary Received data.
local function handleOnNewData(data)
  local dataSize = #data
  _G.logger:fine("Received " .. tostring(dataSize) .. " Bytes = " .. tostring(data))
  Script.notifyEvent('Fieldbus_OnNewStatusLogMessage', "Received " .. tostring(dataSize) .. " Bytes")
  Script.notifyEvent("Fieldbus_OnNewStatusReceivedData", data)

  local startPos = 1
  for _, value in ipairs(fieldbus_Model.parameters.dataNamesReceive) do
    local dataSize = fieldbus_Model.helperFuncs.getTypeSize(fieldbus_Model.parameters.dataTypesReceive[value])
    if dataSize ~= nil then
      local dataPart = string.sub(data, startPos, startPos+dataSize-1)

      -- check if value needs to be unpacked first
      if fieldbus_Model.parameters.convertDataTypesReceive[value] and dataPart ~= nil then
        dataPart = fieldbus_Model.helperFuncs.convertFromBinary(dataPart, fieldbus_Model.parameters.dataTypesReceive[value], fieldbus_Model.parameters.bigEndiansReceive[value])
      end

      fieldbus_Model.dataReceived[value] = dataPart
      Script.notifyEvent('Fieldbus_OnNewData_' .. value, dataPart)
      startPos = startPos + dataSize
    else
      break
    end
  end
  Script.notifyEvent("Fieldbus_OnNewStatusDataReceivingList", fieldbus_Model.helperFuncs.createJsonListReceiveData(fieldbus_Model.parameters.dataNamesReceive, fieldbus_Model.parameters.dataTypesReceive, fieldbus_Model.parameters.convertDataTypesReceive, fieldbus_Model.parameters.bigEndiansReceive, fieldbus_Model.dataReceived, fieldbus_Model.selectedDataReceive))
end

--- Function to react on received ctrl bits of PLC.
---@param ctrlBits int ctrl bits out
local function handleOnControlBitsOutChanged(ctrlBits)
  _G.logger:fine("New CtrlBitsOut = " .. tostring(ctrlBits))
  fieldbus_Model.controlBitsOut = ctrlBits
  Script.notifyEvent("Fieldbus_OnNewStatusControlBitsOut", fieldbus_Model.controlBitsOut)
  fieldbus_Model.boolControlBitsOut = fieldbus_Model.helperFuncs.toBits(fieldbus_Model.controlBitsOut)
  Script.notifyEvent("Fieldbus_OnNewStatusControlBitsOutTable", fieldbus_Model.boolControlBitsOut)
end

local function deregisterFieldbusEvents()
  if fieldbus_Model.handle then
    FieldBus.deregister(fieldbus_Model.handle, 'OnNewData', handleOnNewData)
    FieldBus.deregister(fieldbus_Model.handle, 'OnControlBitsOutChanged', handleOnControlBitsOutChanged)
  end
  Script.deregister('FieldBus.Config.EtherNetIP.OnFieldbusStorageRequest', handleOnEtherNetIPFieldbusStorageRequest)
  Script.deregister('FieldBus.Config.EtherNetIP.OnAddressingModeChanged', handleOnAddressingModeChanged)
  Script.deregister('FieldBus.Config.EtherNetIP.OnInterfaceConfigChanged', handleOnEthernetIPInterfaceConfigChanged)
  Script.deregister('FieldBus.Config.ProfinetIO.OnFieldbusStorageRequest', handleOnProfinetIOFieldbusStorageRequest)
  Script.deregister('FieldBus.Config.ProfinetIO.OnDeviceNameChanged', handleOnDeviceNameChanged)
  Script.deregister('FieldBus.Config.ProfinetIO.OnInterfaceConfigChanged', handleOnProfinetIOInterfaceConfigChanged)
end

-- Function to react on new state of the fieldbus communication.
---@param status FieldBus.Status New state of the fieldbus communication.
local function handleOnStatusChanged(status)
  _G.logger:info("New status = " .. tostring(status))
  fieldbus_Model.currentStatus = status
  Script.notifyEvent("Fieldbus_OnNewStatusFieldbusStatus", fieldbus_Model.currentStatus)
  getInfo()

  if fieldbus_Model.currentStatus == 'CLOSED' then
    deregisterFieldbusEvents()
    Script.releaseObject(fieldbus_Model.handle)
    fieldbus_Model.handle = nil
    collectgarbage()
  end

  if status == 'OPENED' then
    fieldbus_Model.opened = true
  elseif status == 'ONLINE' then
    fieldbus_Model.opened = true
  elseif status == 'OFFLINE' or status == 'ERROR' or status == 'CLOSED' then
    fieldbus_Model.opened = false
  end
  Script.notifyEvent("Fieldbus_OnNewStatusFieldbusActive", fieldbus_Model.opened)
end

--- Function to create fieldbus communication handle
local function create()
  if fieldbus_Model.parameters.protocol ~= 'DISABLED' then
    if _G.availableAPIs.setFBProtocol then
      Script.notifyEvent("Fieldbus_OnNewStatusFieldbusInfo", 'Setting up fieldbus protocol. Please be patient...')
      if fieldbus_Model.parameters.protocol == 'ProfinetIO' then
        FieldBus.Config.setProtocol("PROFINETIO")
        fieldbus_Model.fbMode = 'ProfinetIO'
      elseif fieldbus_Model.parameters.protocol == 'EtherNetIP' then
        FieldBus.Config.setProtocol("ETHERNETIP")
        fieldbus_Model.fbMode = 'EtherNetIP'
      end
    end
    if not fieldbus_Model.handle then
      fieldbus_Model.handle = FieldBus.create(fieldbus_Model.parameters.createMode)
      if fieldbus_Model.handle then
        if fieldbus_Model.parameters.createMode == 'EXPLICIT_OPEN' then
          FieldBus.setMode(fieldbus_Model.handle, fieldbus_Model.parameters.transmissionMode)
        end
        _G.logger:fine("Successfully created Fieldbus handle.")
        getInfo()
        getStatus()

        deregisterFieldbusEvents()
        FieldBus.register(fieldbus_Model.handle, 'OnStatusChanged', handleOnStatusChanged)
        FieldBus.register(fieldbus_Model.handle, 'OnNewData', handleOnNewData)
        FieldBus.register(fieldbus_Model.handle, 'OnControlBitsOutChanged', handleOnControlBitsOutChanged)
        if fieldbus_Model.fbMode == 'EtherNetIP' then
          Script.register('FieldBus.Config.EtherNetIP.OnFieldbusStorageRequest', handleOnEtherNetIPFieldbusStorageRequest)
          Script.register('FieldBus.Config.EtherNetIP.OnAddressingModeChanged', handleOnAddressingModeChanged)
          Script.register('FieldBus.Config.EtherNetIP.OnInterfaceConfigChanged', handleOnEthernetIPInterfaceConfigChanged)

        elseif fieldbus_Model.fbMode == 'ProfinetIO' then
          Script.register('FieldBus.Config.ProfinetIO.OnFieldbusStorageRequest', handleOnProfinetIOFieldbusStorageRequest)
          Script.register('FieldBus.Config.ProfinetIO.OnDeviceNameChanged', handleOnDeviceNameChanged)
          Script.register('FieldBus.Config.ProfinetIO.OnInterfaceConfigChanged', handleOnProfinetIOInterfaceConfigChanged)

        end
      else
        _G.logger:warning("Not able to create Fieldbus handle.")
      end
    else
      _G.logger:fine("Handle already exists.")
    end
  end
end
fieldbus_Model.create = create

--- Function to set transmission mode
---@param mode string Mode to use
local function setTransmissionMode(mode)
  if fieldbus_Model.opened == false then
    if fieldbus_Model.parameters.createMode == 'EXPLICIT_OPEN' and fieldbus_Model.opened ~= true then
      fieldbus_Model.parameters.transmissionMode = mode
      if fieldbus_Model.handle then
        FieldBus.setMode(fieldbus_Model.handle, fieldbus_Model.parameters.transmissionMode)
      end
    else
      _G.logger:info("Transmission mode only selectable if create mode is 'EXPLICIT_OPEN'.")
    end
  else
    _G.logger:info("Cannot set mode of fieldbus, it is already open.")
  end
  Script.notifyEvent("Fieldbus_OnNewStatusTransmissionMode", fieldbus_Model.parameters.transmissionMode)
end
fieldbus_Model.setTransmissionMode = setTransmissionMode

--- Function to open fieldbus communication
local function openCommunication()
  local success = false
  create()
  fieldbus_Model.parameters.active = true
  if fieldbus_Model.handle then
    if fieldbus_Model.parameters.createMode == 'EXPLICIT_OPEN' then
      if _G.availableAPIs.setFBProtocol then
        Script.notifyEvent("Fieldbus_OnNewStatusFieldbusInfo", 'Setting up fieldbus protocol. Please be patient...')
      end
      fieldbus_Model.handle:open()
    end
    success = true
  else
    _G.logger:warning("Not able to open fieldbus communication.")
  end
  return success
end
fieldbus_Model.openCommunication = openCommunication

--- Function to close fieldbus communication
local function closeCommunication()
  if fieldbus_Model.handle then
    fieldbus_Model.handle:close()
    fieldbus_Model.parameters.active = false
  end
end
fieldbus_Model.closeCommunication = closeCommunication

--- Function to read controlBitsIn
local function readControlBitsIn()
  if fieldbus_Model.handle then
    fieldbus_Model.controlBitsIn = fieldbus_Model.handle:readControlBitsIn()
    Script.notifyEvent("Fieldbus_OnNewStatusControlBitsIn", fieldbus_Model.controlBitsIn)
    fieldbus_Model.boolControlBitsIn = fieldbus_Model.helperFuncs.toBits(fieldbus_Model.controlBitsIn)
    Script.notifyEvent("Fieldbus_OnNewStatusControlBitsInTable", fieldbus_Model.boolControlBitsIn)
  end
end
fieldbus_Model.readControlBitsIn = readControlBitsIn

--- Function to read controlBitsOut
local function readControlBitsOut()
  if fieldbus_Model.handle then
    fieldbus_Model.controlBitsOut = fieldbus_Model.handle:readControlBitsOut()
    Script.notifyEvent("Fieldbus_OnNewStatusControlBitsOut", fieldbus_Model.controlBitsOut)
    fieldbus_Model.boolControlBitsOut = fieldbus_Model.helperFuncs.toBits(fieldbus_Model.controlBitsOut)
    Script.notifyEvent("Fieldbus_OnNewStatusControlBitsOutTable", fieldbus_Model.boolControlBitsOut)
  end
end
fieldbus_Model.readControlBitsOut = readControlBitsOut

--- Function to transmit data
---@param data binary Data content to transmit
local function transmit(data)
  if fieldbus_Model.handle then
    local numberOfBytes = fieldbus_Model.handle:transmit(data)
    if numberOfBytes ~= 0 then
      _G.logger:fine("Send " .. tostring(numberOfBytes) .. " data Bytes.")
      Script.notifyEvent('Fieldbus_OnNewStatusLogMessage', "Send " .. tostring(numberOfBytes) .. " data Bytes.")
    else
      _G.logger:warning("Transmit error.")
      Script.notifyEvent('Fieldbus_OnNewStatusLogMessage', "Transmit error.")
    end
  else
    _G.logger:info("No connection available to transmit.")
    Script.notifyEvent('Fieldbus_OnNewStatusLogMessage', "No connection available to transmit.")
  end
end
fieldbus_Model.transmit = transmit

--- Function to write controlBitsIn
---@param controlBits int Bits to write
---@param bitMask int Mask to use for bits
local function writeControlBitsIn(controlBits, bitMask)
  if fieldbus_Model.handle then
    _G.logger:fine("Send controlBits")
    fieldbus_Model.handle:writeControlBitsIn(controlBits, bitMask)
  end
end
fieldbus_Model.writeControlBitsIn = writeControlBitsIn

--- Function to write data to table to transmit
---@param pos int Position of data to update
---@param data auto Data content to set
local function updateTransmitData(pos, data)
  --_G.logger:fine("Set data" .. tostring(pos) .. ' with data = ' .. tostring(data)) --DEBUG
  fieldbus_Model.dataToTransmit[pos] = data

  fieldbus_Model.fullDataToTransmit = ''
  for key, value in ipairs(fieldbus_Model.dataToTransmit) do
    fieldbus_Model.fullDataToTransmit = fieldbus_Model.fullDataToTransmit .. value
  end

  --DEBUG
  --[[
  local readableTransmitData = ''
  for key, value in ipairs(fieldbus_Model.readableDataToTransmit) do
    if readableTransmitData == '' then
      readableTransmitData = value
    else
      readableTransmitData = readableTransmitData .. ',' .. value
    end
  end
  _G.logger:fine("Send: " .. readableTransmitData)

  -- Additional debugging
  --_G.logger:fine(fieldbus_Model.fullDataToTransmit)
  --_G.logger:fine(#fieldbus_Model.fullDataToTransmit)
  --Script.notifyEvent('Fieldbus_OnNewStatusLogMessage', tostring(fieldbus_Model.fullDataToTransmit) .. ', Send data bytes = ' .. tostring(#fieldbus_Model.fullDataToTransmit))
  --Script.notifyEvent("Fieldbus_OnNewStatusDataToTransmit", fieldbus_Model.dataToTransmit)
  
  --print(fieldbus_Model.fullDataToTransmit)
  --print(#fieldbus_Model.fullDataToTransmit)
  ]]

  transmit(fieldbus_Model.fullDataToTransmit)

end
fieldbus_Model.updateTransmitData = updateTransmitData

--- Function to register to event of (other) module to receive data and to transmit/forward it
---@param eventName int Name of event to register
---@param dataPosition auto Position of data
---@param dataName string Identifier of data
local function registerToEvent(eventName, dataPosition, dataName)

  local emptyData = fieldbus_Model.helperFuncs.getEmptyBinaryContent(fieldbus_Model.parameters.dataTypesTransmit[dataName])
  if fieldbus_Model.dataToTransmit[dataPosition] then
    fieldbus_Model.dataToTransmit[dataPosition] = emptyData
  else
    table.insert(fieldbus_Model.dataToTransmit, emptyData)
  end

  if fieldbus_Model.readableDataToTransmit[dataPosition] then
    fieldbus_Model.readableDataToTransmit[dataPosition] = 'empty'
  else
    table.insert(fieldbus_Model.readableDataToTransmit, 'empty')
  end

  local function updateData(data)
    _G.logger:fine("Set data " .. tostring(dataPosition) .. ' with data = ' .. tostring(data))
    fieldbus_Model.readableDataToTransmit[dataPosition] = data

    if fieldbus_Model.parameters.convertDataTypesTransmit[dataName] then
      data = fieldbus_Model.helperFuncs.convertToBinary(data, fieldbus_Model.parameters.dataTypesTransmit[dataName], fieldbus_Model.parameters.bigEndiansTransmit[dataName])
    end
    updateTransmitData(dataPosition, data)
  end
  fieldbus_Model.dataUpdateFunctions[dataName] = updateData

  Script.register(eventName, fieldbus_Model.dataUpdateFunctions[dataName])
end
fieldbus_Model.registerToEvent = registerToEvent

--- Function to deregister from all events for data to transmit
local function deregisterAllEvents()
  for key, value in pairs(fieldbus_Model.parameters.dataNamesTransmit) do
    Script.deregister(fieldbus_Model.parameters.registeredEventsTransmit[value], fieldbus_Model.dataUpdateFunctions[value])
  end
  fieldbus_Model.dataToTransmit = {}
  fieldbus_Model.readableDataToTransmit = {}
end
fieldbus_Model.deregisterAllEvents = deregisterAllEvents

--- Function to register all events for data to transmit
local function registerAllEvents()
  for key, value in ipairs(fieldbus_Model.parameters.dataNamesTransmit) do
    registerToEvent(fieldbus_Model.parameters.registeredEventsTransmit[value], key, value)
  end
end
fieldbus_Model.registerAllEvents = registerAllEvents

--- Function to add empty value (but with correct byte size) for data to transmit
---@param dataType string Type of data
local function addEmptySpace(dataType)
  -- Insert empty spaces according to dataType...
  local emptyData = fieldbus_Model.helperFuncs.getEmptyBinaryContent(dataType)
  table.insert(fieldbus_Model.dataToTransmit, emptyData)
  table.insert(fieldbus_Model.readableDataToTransmit, 'empty')
end
fieldbus_Model.addEmptySpace = addEmptySpace

--- Function to add new data entry to transmit
---@param dataName string Name/identifier of data
---@param eventName string Name of event to register
---@param convert bool Status if incoming value needs to be converted to binary
---@param dataType string Type of data
---@param bigEndian bool Type of endianess
local function addDataTransmit(dataName, eventName, convert, dataType, bigEndian)
  table.insert(fieldbus_Model.parameters.dataNamesTransmit, dataName)
  addEmptySpace(dataType)

  fieldbus_Model.parameters.registeredEventsTransmit[dataName] = eventName
  fieldbus_Model.parameters.convertDataTypesTransmit[dataName] = convert
  fieldbus_Model.parameters.bigEndiansTransmit[dataName] = bigEndian

  if convert == true then
    fieldbus_Model.parameters.dataTypesTransmit[dataName] = dataType

  else
    fieldbus_Model.parameters.dataTypesTransmit[dataName] = 'RAW'
    --fieldbus_Model.parameters.bigEndiansTransmit[dataName] = '-'
  end

  registerToEvent(eventName, #fieldbus_Model.parameters.dataNamesTransmit, dataName)
end
fieldbus_Model.addDataTransmit = addDataTransmit

--- Function to serve events to notify for received values
---@param dataName string Name/identifier of data
local function serveReceiveEvent(dataName)
  if not Script.isServedAsEvent('CSK_Fieldbus.OnNewData_' .. dataName) then
    Script.serveEvent('CSK_Fieldbus.OnNewData_' .. dataName, 'Fieldbus_OnNewData_' .. dataName, 'auto:?')
  end
end
fieldbus_Model.serveReceiveEvent = serveReceiveEvent

--- Function to add new data entry to receive
---@param dataName string Name/identifier of data
---@param convert bool Status if incoming value needs to be converted to binary
---@param dataType string Type of data
---@param bigEndian bool Type of endianess
local function addDataReceive(dataName, convert, dataType, bigEndian)
  table.insert(fieldbus_Model.parameters.dataNamesReceive, dataName)

  fieldbus_Model.parameters.convertDataTypesReceive[dataName] = convert
  fieldbus_Model.parameters.bigEndiansReceive[dataName] = bigEndian

  if convert == true then
    fieldbus_Model.parameters.dataTypesReceive[dataName] = dataType
    
  else
    fieldbus_Model.parameters.dataTypesReceive[dataName] = 'RAW'
  end

  fieldbus_Model.dataReceived[dataName] = '-'

  serveReceiveEvent(dataName)

end
fieldbus_Model.addDataReceive = addDataReceive

--- Function to remove data entry to transmit
---@param dataNo int Number of data entry
local function removeDataTransmit(dataNo)
  local dataName = fieldbus_Model.parameters.dataNamesTransmit[dataNo]

  deregisterAllEvents()

  fieldbus_Model.parameters.dataTypesTransmit[dataName] = nil
  fieldbus_Model.parameters.registeredEventsTransmit[dataName] = nil
  fieldbus_Model.parameters.convertDataTypesTransmit[dataName] = nil
  fieldbus_Model.parameters.bigEndiansTransmit[dataName] = nil

  table.remove(fieldbus_Model.parameters.dataNamesTransmit, dataNo)
  registerAllEvents()
  collectgarbage()
end
fieldbus_Model.removeDataTransmit = removeDataTransmit

--- Function to remove data entry to receive
---@param dataNo int Number of data entry
local function removeDataReceive(dataNo)
  local dataName = fieldbus_Model.parameters.dataNamesReceive[dataNo]

  fieldbus_Model.parameters.dataTypesReceive[dataName] = nil
  fieldbus_Model.parameters.convertDataTypesReceive[dataName] = nil
  fieldbus_Model.parameters.bigEndiansReceive[dataName] = nil
  fieldbus_Model.dataReceived[dataName] = nil

  table.remove(fieldbus_Model.parameters.dataNamesReceive, dataNo)
end
fieldbus_Model.removeDataReceive = removeDataReceive

--- Function to move the position of the transmit data about one position higher
---@param dataNo int Position of data
local function dataTransmitPositionUp(dataNo)
  if dataNo ~= 1 then
    deregisterAllEvents()

    local tempDataName = fieldbus_Model.parameters.dataNamesTransmit[dataNo]
    table.insert(fieldbus_Model.parameters.dataNamesTransmit, dataNo-1, tempDataName)
    table.remove(fieldbus_Model.parameters.dataNamesTransmit, dataNo+1)
    collectgarbage()

    registerAllEvents()
    fieldbus_Model.selectedDataTransmit = tostring(dataNo-1)
  end
end
fieldbus_Model.dataTransmitPositionUp = dataTransmitPositionUp

--- Function to move the position of the data to receive about one position higher
---@param dataNo int Position of data
local function dataReceivePositionUp(dataNo)
  if dataNo ~= 1 then

    local tempDataName = fieldbus_Model.parameters.dataNamesReceive[dataNo]
    table.insert(fieldbus_Model.parameters.dataNamesReceive, dataNo-1, tempDataName)
    table.remove(fieldbus_Model.parameters.dataNamesReceive, dataNo+1)
    collectgarbage()

    fieldbus_Model.selectedDataReceive = tostring(dataNo-1)
  end
end
fieldbus_Model.dataReceivePositionUp = dataReceivePositionUp

--- Function to move the position of the data to transmit about one position lower
---@param dataNo int Position of data
local function dataTransmitPositionDown(dataNo)
  if dataNo ~= #fieldbus_Model.parameters.dataNamesTransmit then
    deregisterAllEvents()

    local tempDataName = fieldbus_Model.parameters.dataNamesTransmit[dataNo]
    table.remove(fieldbus_Model.parameters.dataNamesTransmit, dataNo)
    table.insert(fieldbus_Model.parameters.dataNamesTransmit, dataNo+1, tempDataName)
    collectgarbage()

    registerAllEvents()
    fieldbus_Model.selectedDataTransmit = tostring(dataNo+1)
  end
end
fieldbus_Model.dataTransmitPositionDown = dataTransmitPositionDown

--- Function to move the position of the data to receive about one position lower
---@param dataNo int Position of data
local function dataReceivePositionDown(dataNo)
  if dataNo ~= #fieldbus_Model.parameters.dataNamesReceive then

    local tempDataName = fieldbus_Model.parameters.dataNamesReceive[dataNo]
    table.remove(fieldbus_Model.parameters.dataNamesReceive, dataNo)
    table.insert(fieldbus_Model.parameters.dataNamesReceive, dataNo+1, tempDataName)
    collectgarbage()

    fieldbus_Model.selectedDataReceive = tostring(dataNo+1)
  end
end
fieldbus_Model.dataReceivePositionDown = dataReceivePositionDown

--- Function to reset all data to transmit
local function resetTransmitData()
  for key, value in ipairs(fieldbus_Model.parameters.dataNamesTransmit) do
    local emptyData = fieldbus_Model.helperFuncs.getEmptyBinaryContent(fieldbus_Model.parameters.dataTypesTransmit[value])
    fieldbus_Model.dataToTransmit[key] = emptyData
    fieldbus_Model.readableDataToTransmit[key] =  'empty'
  end

  if fieldbus_Model.currentStatus == 'ONLINE' then
    fieldbus_Model.fullDataToTransmit = ''
    for key, value in ipairs(fieldbus_Model.dataToTransmit) do
      fieldbus_Model.fullDataToTransmit = fieldbus_Model.fullDataToTransmit .. value
    end
    transmit(fieldbus_Model.fullDataToTransmit)
  end
end
fieldbus_Model.resetTransmitData = resetTransmitData

--*************************************************************************
--********************** End Function Scope *******************************
--*************************************************************************

return fieldbus_Model
