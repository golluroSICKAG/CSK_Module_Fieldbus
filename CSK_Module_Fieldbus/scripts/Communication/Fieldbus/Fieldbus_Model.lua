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

local fbMode = Parameters.get('FBmode')
if fbMode == 1 then
  fieldbus_Model.fbMode = 'ProfinetIO'
elseif fbMode == 2 then
  fieldbus_Model.fbMode = 'EtherNetIP'
else
  fieldbus_Model.fbMode = 'DISABLED'
end


fieldbus_Model.handle = nil -- Fieldbus handle
--fieldbus_Model.active = false -- Status if fieldbus connection should be used.
--fieldbus_Model.open = false -- Status if fieldbus handle was opended.
fieldbus_Model.currentStatus = 'CLOSED' -- Current status of the fieldbus communication.
fieldbus_Model.info = 'No info available.' -- Information of the fieldbus component.
fieldbus_Model.controlBitsIn = 0 -- Current value of the control bits transmitted to the PLC.
fieldbus_Model.controlBitsOut = 0 -- Current value of the control bits received from the PLC.
fieldbus_Model.dataToTransmit = '' -- Preset data to transmit.
fieldbus_Model.controlBitsToWrite = 0 -- Preset control bits to write.
fieldbus_Model.bitMask = 0 -- Preset bitMask to use for controlBits.

fieldbus_Model.port = 'P1' -- Fieldbus port, e.g. 'P2'

--[[
-- Create parameters / instances for this module
if fieldbus_Model.moduleActive then
  fieldbus_Model.handle = FieldBus.create()
end
]]

-- Parameters to be saved permanently if wanted
fieldbus_Model.parameters = {}
fieldbus_Model.parameters.protocol = 'DISABLED' -- Type of fieldbus communication, e.g. 'DISABLED' (0) / 'ProfinetIO' (1) / 'EtherNetIP' (2) / 'ETHERCAT' (not available yet)
fieldbus_Model.parameters.createMode = 'AUTOMATIC_OPEN' -- or 'EXPLICIT_OPEN'
fieldbus_Model.parameters.transmissionMode = 'CONFIRMED_MESSAGING' -- or 'RAW'

fieldbus_Model.parameters.etherNetIP = {}
fieldbus_Model.parameters.etherNetIP.storageRequestDataPath = '/public/FieldBus/EtherNetIP/StorageData.bin' -- Path to store fieldbus storage data.
fieldbus_Model.parameters.etherNetIP.addressingMode = 'STATIC' -- or 'DHCP' / 'BOOTP'
fieldbus_Model.parameters.etherNetIP.ipAddress = '0.0.0.0' -- IP address
fieldbus_Model.parameters.etherNetIP.netmask = '255.255.255.0' --  Subnet mask
fieldbus_Model.parameters.etherNetIP.gateway = '0.0.0.0' -- Gateway address
fieldbus_Model.parameters.etherNetIP.nameServer = '0.0.0.0' -- Primary name server
fieldbus_Model.parameters.etherNetIP.nameServer2 = '0.0.0.0' -- Secondary name server
fieldbus_Model.parameters.etherNetIP.domainName = '' -- Domain name
fieldbus_Model.parameters.etherNetIP.macAddress = '' -- MAC address of fieldbus implementation.

fieldbus_Model.parameters.profinetIO = {}
fieldbus_Model.parameters.profinetIO.storageRequestDataPath = '/public/FieldBus/ProfinetIO/StorageData.bin' -- Path to store fieldbus storage data.
fieldbus_Model.parameters.profinetIO.deviceName = '' -- Device name
fieldbus_Model.parameters.profinetIO.remanent = false -- Status if the network configuration tool sets the current name of the device permanently (true), that is, it will be reloaded after a restart of the device.
fieldbus_Model.parameters.profinetIO.ipAddress = '0.0.0.0' -- IP address
fieldbus_Model.parameters.profinetIO.netmask = '255.255.255.0' --  Subnet mask
fieldbus_Model.parameters.profinetIO.gateway = '0.0.0.0' -- Gateway address
fieldbus_Model.parameters.profinetIO.macAddress = '' -- MAC address of fieldbus implementation.

fieldbus_Model.parameters.profinetIO.dapImDescriptor = '' -- The descriptor (a.k.a. 'comment') as used for the DAP’s (device access point) I&M3 data.
fieldbus_Model.parameters.profinetIO.dapImHardwareRev = 0 --  Hardware revision as used for the DAP (device access point) used in the I&M0 data.
fieldbus_Model.parameters.profinetIO.dapImInstallDate = '' -- Installation date as used for the DAP’s (device access point) I&M2 data.

-- Software revision for the DAP (device access point) used in the I&M0 data.
fieldbus_Model.parameters.profinetIO.dapImSoftwareRevPrefix = '' -- Prefix character of the software revision of this I&M0 data.
fieldbus_Model.parameters.profinetIO.dapImSoftwareRevFuncEnhancement = 0 -- Functional enhancement identifier of the software revision of this I&M0 data.
fieldbus_Model.parameters.profinetIO.dapImSoftwareRevBugFix = 0 -- Bug fix identifier of the software revision of this I&M0 data.
fieldbus_Model.parameters.profinetIO.dapImSoftwareRevInternalChange = 0 -- Internal change identifier of the software revision of this I&M0 data.

fieldbus_Model.parameters.profinetIO.dapImTagFunction = '' -- Function tag (a.k.a. 'plant designation') as used for the DAP’s (device access point) I&M1 data.
fieldbus_Model.parameters.profinetIO.dapImTagLocation = '' -- Location tag (a.k.a. 'location identifier') as used for the DAP’s (device access point) I&M1 data.

local function createFolder(folder)
  local folderExists = File.isdir(folder)
  if not folderExists then
    local suc = File.mkdir(folder)
    if not suc then
      _G.logger:warning(nameOfModule .. ': Not possible to create folder on device.')
    end
  end
end

createFolder('/public/FieldBus')
createFolder('/public/FieldBus/EtherNetIP')
createFolder('/public/FieldBus/ProfinetIO')

--**************************************************************************
--********************** End Global Scope **********************************
--**************************************************************************
--**********************Start Function Scope *******************************
--**************************************************************************

-- Function to react on received data of PLC.
---@param data binary Received data.
local function handleOnNewData(data)
  print("Received data = " .. tostring(data))
end

-- Function to react on new state of the fieldbus communication.
---@param status FieldBus.Status New state of the fieldbus communication.
local function handleOnStatusChanged(status)
  print("New status = " .. tostring(status))
  fieldbus_Model.currentStatus = status
  Script.notifyEvent("Fieldbus_OnNewStatusFieldbusStatus", fieldbus_Model.currentStatus)
end

-- Function to react on received ctrl bits of PLC.
---@param ctrlBits int ctrl bits out
local function handleOnControlBitsOutChanged(ctrlBits)
  print("New CtrlBitsOut = " .. tostring(ctrlBits))
  fieldbus_Model.controlBitsOut = ctrlBits
  Script.notifyEvent("Fieldbus_OnNewStatusControlBitsOut", fieldbus_Model.controlBitsOut)
end

-----------------
-- EtherNet/IP --
-----------------

-- Function to react on received EtherNet/IP addressing mode.
---@param addressingMode FieldBus.Config.EtherNetIP.AddressingMode Addressing mode for the ip parameters.
local function handleOnAddressingModeChanged(addressingMode)
  print("New EtherNet/IP AdressingMode = " .. tostring(addressingMode))
end

-- Function to react on received EtherNet/IP interface config.
---@param ipAddress string IP address.
---@param netmask string Subnetmask.
---@param gateway string Gateway IP address.
---@param nameServer? string Primary name server.
---@param nameServer2? string Secondary name server.
---@param domainName? string Default domain name.
local function handleOnEthernetIPInterfaceConfigChanged(ipAddress, netmask, gateway, nameServer, nameServer2, domainName)
  print("New EtherNet/IP interface config:")
  print("IP Address / NetMask = " .. tostring(ipAddress) .. ' / ' .. tostring(netmask))
  print("Gateway = " .. tostring(gateway))
  print("Nameserver 1 / 2 = " .. tostring(nameServer) .. ' / ' .. tostring(nameServer2))
  print("DomainName = " .. tostring(domainName))
  --[[
    fieldbus_Model.parameters.etherNetIP.addressingMode
fieldbus_Model.parameters.etherNetIP.ipAddress
fieldbus_Model.parameters.etherNetIP.netmask
fieldbus_Model.parameters.etherNetIP.gateway
fieldbus_Model.parameters.etherNetIP.nameServer
fieldbus_Model.parameters.etherNetIP.nameServer2
fieldbus_Model.parameters.etherNetIP.domainName
fieldbus_Model.parameters.etherNetIP.macAddress
  ]]
end

-- Function to react on FieldbusStoreRequest
---@param storageHandle FieldBus.StorageRequest Object containing the data to be saved or loaded
local function handleOnEtherNetIPFieldbusStorageRequest(storageHandle)
  local operation = FieldBus.StorageRequest.getOperation(storageHandle)
  if operation == 'LOAD' then
    local dataFile = File.open(fieldbus_Model.parameters.etherNetIP.storageRequestDataPath, 'rb')
    local data = File.read(dataFile)
    File.close(dataFile)

    FieldBus.StorageRequest.setData(storageHandle, data)

  elseif operation == 'SAVE' then
    local data = FieldBus.StorageRequest.getData(storageHandle)
    local dataFile = File.open(fieldbus_Model.parameters.etherNetIP.storageRequestDataPath, 'wb')
    local suc = File.write(dataFile, data)

    if suc then
      FieldBus.StorageRequest.notifyResult(storageHandle, true)
    else
      FieldBus.StorageRequest.notifyResult(storageHandle, false)
    end
  end
end

----------------
-- ProfinetIO --
----------------

-- Function to react on received ProfinetIO DeviceName.
---@param deviceName string Currently active name of the device
---@param remanent bool True if the network configuration tool sets the current name of the device permanently, that is, it will be reloaded after a restart of the device.
local function handleOnDeviceNameChanged(deviceName, remanent)
  print("Received DeviceName info!")
  fieldbus_Model.parameters.profinetIO.deviceName = deviceName
  fieldbus_Model.parameters.profinetIO.remanent = remanent
end

-- Function to react on received ProfinetIO interface config.
---@param ipAddress string Currently active (applied) IP address
---@param subnetMask string Currently active (applied) subnet mask
---@param gateway string Currently active (applied) gateway address
---@param remanent bool True if the network configuration tool sets the current IP address settings permanently, that is, it will be reloaded after a restart of the device.
local function handleOnProfinetIOInterfaceConfigChanged(ipAddress, subnetMask, gateway, remanent)
  print("New ProfinetIO interface config:")
  print("IP Address / NetMask = " .. tostring(ipAddress) .. ' / ' .. tostring(subnetMask))
  print("Gateway = " .. tostring(gateway))
  print("Remanent = " .. tostring(remanent))
end

-- Function to react on FieldbusStoreRequest
---@param storageHandle FieldBus.StorageRequest Object containing the data to be saved or loaded
local function handleOnProfinetIOFieldbusStorageRequest(storageHandle)
  local operation = FieldBus.StorageRequest.getOperation(storageHandle)
  if operation == 'LOAD' then
    local dataFile = File.open(fieldbus_Model.parameters.profinetIO.storageRequestDataPath, 'rb')
    local data = File.read(dataFile)
    File.close(dataFile)

    FieldBus.StorageRequest.setData(storageHandle, data)

  elseif operation == 'SAVE' then
    local data = FieldBus.StorageRequest.getData(storageHandle)
    local dataFile = File.open(fieldbus_Model.parameters.profinetIO.storageRequestDataPath, 'wb')
    local suc = File.write(dataFile, data)

    if suc then
      FieldBus.StorageRequest.notifyResult(storageHandle, true)
    else
      FieldBus.StorageRequest.notifyResult(storageHandle, false)
    end
  end
end

------------------------------------------------------------

-- Function to get various information about the fieldbus, its componentes and internals.
local function getInfo()
  fieldbus_Model.info = FieldBus.getInfo(fieldbus_Model.handle)
  Script.notifyEvent("Fieldbus_OnNewStatusFieldbusInfo", fieldbus_Model.info)
  --TODO
end
fieldbus_Model.getInfo = getInfo

local function getStatus()
  fieldbus_Model.currentStatus = FieldBus.getStatus(fieldbus_Model.handle)
  Script.notifyEvent("Fieldbus_OnNewStatusFieldbusStatus", fieldbus_Model.currentStatus)
  -- TODO
end
fieldbus_Model.getStatus = getStatus

local function create()
  if fieldbus_Model.fbMode ~= 'DISABLED' then
    if not fieldbus_Model.handle then
      fieldbus_Model.handle = FieldBus.create(fieldbus_Model.parameters.createMode)
      if fieldbus_Model.handle then
        print("Successfully created Fieldbus handle.")
        getInfo()
        getStatus()
        --if fieldbus_Model.parameters.createMode == 'AUTOMATIC_OPEN' then
        FieldBus.register(fieldbus_Model.handle, 'OnStatusChanged', handleOnStatusChanged)
        FieldBus.register(fieldbus_Model.handle, 'OnNewData', handleOnNewData)
        FieldBus.register(fieldbus_Model.handle, 'OnControlBitsOutChanged', handleOnControlBitsOutChanged)
        --end
        if fieldbus_Model.fbMode == 'EtherNetIP' then
          --Script.register('FieldBus.Config.EtherNetIP.OnFieldbusStorageRequest', handleOnEtherNetIPFieldbusStorageRequest)
          Script.register('FieldBus.Config.EtherNetIP.OnFieldbusStorageRequest', handleOnEtherNetIPFieldbusStorageRequest)
          Script.register('FieldBus.Config.EtherNetIP.OnAddressingModeChanged', handleOnAddressingModeChanged)
          Script.register('FieldBus.Config.EtherNetIP.OnInterfaceConfigChanged', handleOnEthernetIPInterfaceConfigChanged)

        elseif fieldbus_Model.fbMode == 'ProfinetIO' then
          Script.register('FieldBus.Config.ProfinetIO.OnFieldbusStorageRequest', handleOnProfinetIOFieldbusStorageRequest)
          Script.register('FieldBus.Config.ProfinetIO.OnDeviceNameChanged', handleOnDeviceNameChanged)
          Script.register('FieldBus.Config.ProfinetIO.OnInterfaceConfigChanged', handleOnProfinetIOInterfaceConfigChanged)

        end
        --TODO
        --fieldbus_Model.open = true
      else
        print("Not able to create Fieldbus handle.")
      end
    else
      print("Handle already exists.")
    end
  end
end
fieldbus_Model.create = create
if not CSK_PersistentData then
  create()
end

local function setTransmissionMode(mode)
  if fieldbus_Model.parameters.createMode == 'EXPLICIT_OPEN' then
    fieldbus_Model.parameters.transmissionMode = mode
  end
end
fieldbus_Model.setTransmissionMode = setTransmissionMode

local function openCommunication()
  if fieldbus_Model.handle and fieldbus_Model.parameters.createMode == 'EXPLICIT_OPEN' then
    local suc = fieldbus_Model.handle:open()
  end
end
fieldbus_Model.openCommunication = openCommunication

local function closeCommunication()
    local suc = fieldbus_Model.handle:close()
end
fieldbus_Model.closeCommunication = closeCommunication

local function readControlBitsIn()
  if fieldbus_Model.handle then
    fieldbus_Model.controlBitsIn = fieldbus_Model.handle:readControlBitsIn()
    Script.notifyEvent("Fieldbus_OnNewStatusControlBitsIn", fieldbus_Model.controlBitsIn)
  end
end
fieldbus_Model.readControlBitsIn = readControlBitsIn

local function readControlBitsOut()
  if fieldbus_Model.handle then
    fieldbus_Model.controlBitsOut = fieldbus_Model.handle:readControlBitsOut()
    Script.notifyEvent("Fieldbus_OnNewStatusControlBitsOut", fieldbus_Model.controlBitsOut)
  end
end
fieldbus_Model.readControlBitsOut = readControlBitsOut

local function transmit(data)
  if fieldbus_Model.handle then
    local numberOfBytes = fieldbus_Model.handle:transmit(data)
    if numberOfBytes ~= 0 then
      print("Send data bytes = " .. tostring(numberOfBytes))
    else
      print("Transmit error.")
    end
  end
end
fieldbus_Model.transmit = transmit

local function writeControlBitsIn(controlBits, bitMask)
  if fieldbus_Model.handle then
    fieldbus_Model.handle:writeControlBitsIn(controlBits, bitMask)
  end
end
fieldbus_Model.writeControlBitsIn = writeControlBitsIn

--TODO only for SIM2000Eco...
--------------------------------------
--[[
local function getProtocolInfo()
  protocol = FieldBus.Config.getProtocol()
end
fieldbus_Model.getProtocolInfo = getProtocolInfo

local function setProtocolConfig()
  Fieldbus_Controller.Config.setProtocol()
end
fieldbus_Model.setProtocolConfig = setProtocolConfig
]]
--------------------------------------

-----------------------
-- EtherNet/IP relevant
-----------------------
local function getEtherNetIPConfig()
  local addressingMode = FieldBus.Config.EtherNetIP.getAddressingMode()
  local ipAddress, netmask, gateway, nameServer, nameServer2, domainName = FieldBus.Config.EtherNetIP.getInterfaceConfig()
  local macAddress = FieldBus.Config.EtherNetIP.getMACAddress()

  fieldbus_Model.parameters.etherNetIP.addressingMode = addressingMode
  fieldbus_Model.parameters.etherNetIP.ipAddress = ipAddress
  fieldbus_Model.parameters.etherNetIP.netmask = netmask
  fieldbus_Model.parameters.etherNetIP.gateway = gateway
  fieldbus_Model.parameters.etherNetIP.nameServer = nameServer
  fieldbus_Model.parameters.etherNetIP.nameServer2 = nameServer2
  fieldbus_Model.parameters.etherNetIP.domainName = domainName
  if macAddress then
    fieldbus_Model.parameters.etherNetIP.macAddress = macAddress
  end

  CSK_Fieldbus.pageCalled()

--  print("AddressingMode = " .. tostring(etherNetIPAddressingMode))
--  print("InterfaceConfig = " .. tostring(etherNetIPInterfaceConfig))
--  print("MAC Address = " .. tostring(etherNetIPMACAddress))

end
fieldbus_Model.getEtherNetIPConfig = getEtherNetIPConfig

local function setEtherNetIPConfig()

  local suc = FieldBus.Config.EtherNetIP.setAddressingMode(fieldbus_Model.parameters.etherNetIP.addressingMode)
  if suc then
    if fieldbus_Model.parameters.etherNetIP.addressingMode == 'STATIC' then
      suc = FieldBus.Config.EtherNetIP.setInterfaceConfig(fieldbus_Model.parameters.etherNetIP.ipAddress, fieldbus_Model.parameters.etherNetIP.netmask, fieldbus_Model.parameters.etherNetIP.gateway, fieldbus_Model.parameters.etherNetIP.nameServer, fieldbus_Model.parameters.etherNetIP.nameServer2, fieldbus_Model.parameters.etherNetIP.domainName)
    end
  end
  CSK_Fieldbus.pageCalled()
end
fieldbus_Model.setEtherNetIPConfig = setEtherNetIPConfig

-----------------------
-- ProfinetIO relevant
-----------------------

local function applyProfinetIOConfig()
  FieldBus.Config.ProfinetIO.setDeviceName()
  FieldBus.Config.ProfinetIO.setInterfaceConfig()
  local suc = FieldBus.Config.ProfinetIO.applyConfig()
  print("Success of ApplyConfig = " .. tostring(suc))
end
fieldbus_Model.applyProfinetIOConfig = applyProfinetIOConfig

local function getProfinetIOConfigInfo()
  fieldbus_Model.parameters.profinetIO.deviceName = FieldBus.Config.ProfinetIO.getDeviceName()
  fieldbus_Model.parameters.profinetIO.ipAddress, fieldbus_Model.parameters.profinetIO.subnetMask, fieldbus_Model.parameters.profinetIO.gateway, fieldbus_Model.parameters.profinetIO.remanent = FieldBus.Config.ProfinetIO.getInterfaceConfig()

  fieldbus_Model.parameters.profinetIO.macAddress = FieldBus.Config.ProfinetIO.getMACAddress(fieldbus_Model.port)

  CSK_Fieldbus.pageCalled()

end
fieldbus_Model.getProfinetIOConfigInfo = getProfinetIOConfigInfo

local function applyProfinetIOConfig()
  FieldBus.Config.ProfinetIO.setDeviceName()
  FieldBus.Config.ProfinetIO.setInterfaceConfig()
  local suc = FieldBus.Config.ProfinetIO.applyConfig()
  print("Success of ApplyConfig = " .. tostring(suc))
end
fieldbus_Model.applyProfinetIOConfig = applyProfinetIOConfig

local function storeProfinetIOConfig()
  local suc = FieldBus.Config.ProfinetIO.storeConfig()
end
fieldbus_Model.storeProfinetIOConfig = storeProfinetIOConfig

local function getDapImConfigInfo()
  fieldbus_Model.parameters.profinetIO.dapImDescriptor = FieldBus.Config.ProfinetIO.getDapImDescriptor()
  fieldbus_Model.parameters.profinetIO.dapImHardwareRev = FieldBus.Config.ProfinetIO.getDapImHardwareRev()
  fieldbus_Model.parameters.profinetIO.dapImInstallDate  = FieldBus.Config.ProfinetIO.getDapImInstallDate()
  fieldbus_Model.parameters.profinetIO.dapImSoftwareRevPrefix, fieldbus_Model.parameters.profinetIO.dapImSoftwareRevFuncEnhancement, fieldbus_Model.parameters.profinetIO.dapImSoftwareRevBugFix, fieldbus_Model.parameters.profinetIO.dapImSoftwareRevInternalChange = FieldBus.Config.ProfinetIO.getDapImSoftwareRev()
  fieldbus_Model.parameters.profinetIO.tagFunction = FieldBus.Config.ProfinetIO.getDapImTagFunction()
  fieldbus_Model.parameters.profinetIO.tagLocation = FieldBus.Config.ProfinetIO.getDapImTagLocation()
  CSK_Fieldbus.pageCalled()

end
fieldbus_Model.getDapImConfigInfo = getDapImConfigInfo

local function setDapImConfig()

  local success = FieldBus.Config.ProfinetIO.setDapImDescriptor(fieldbus_Model.parameters.profinetIO.dapImDescriptor)
  success = FieldBus.Config.ProfinetIO.setDapImInstallDate(fieldbus_Model.parameters.profinetIO.dapImInstallDate)
  success = FieldBus.Config.ProfinetIO.setDapImTagFunction(fieldbus_Model.parameters.profinetIO.tagFunction)
  success = FieldBus.Config.ProfinetIO.setDapImTagLocation(fieldbus_Model.parameters.profinetIO.tagLocation)
end
fieldbus_Model.setDapImConfig = setDapImConfig

local function storeDapImData()
  local suc = FieldBus.Config.ProfinetIO.storeDapImData()
end
fieldbus_Model.storeDapImData = storeDapImData

--*************************************************************************
--********************** End Function Scope *******************************
--*************************************************************************

return fieldbus_Model
