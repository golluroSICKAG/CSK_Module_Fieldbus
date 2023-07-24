---@diagnostic disable: undefined-global, redundant-parameter, missing-parameter

--***************************************************************
-- Inside of this script, you will find the necessary functions,
-- variables and events to communicate with the Fieldbus_Model
--***************************************************************

--**************************************************************************
--************************ Start Global Scope ******************************
--**************************************************************************
local nameOfModule = 'CSK_Fieldbus'

-- Timer to update UI via events after page was loaded
local tmrFieldbus = Timer.create()
tmrFieldbus:setExpirationTime(300)
tmrFieldbus:setPeriodic(false)

-- Reference to global handle
local fieldbus_Model

-- ************************ UI Events Start ********************************

--Script.serveEvent('CSK_Fieldbus.OnNewStatusFieldbusActive', 'Fieldbus_OnNewStatusFieldbusActive')
Script.serveEvent('CSK_Fieldbus.OnNewStatusFieldbusStatus', 'Fieldbus_OnNewStatusFieldbusStatus')

Script.serveEvent('CSK_Fieldbus.OnNewStatusActiveProtocol', 'Fieldbus_OnNewStatusActiveProtocol')

Script.serveEvent('CSK_Fieldbus.OnNewStatusProtocol', 'Fieldbus_OnNewStatusProtocol')
Script.serveEvent('CSK_Fieldbus.OnNewStatusFieldbusFeatureActive', 'Fieldbus_OnNewStatusFieldbusFeatureActive')

Script.serveEvent('CSK_Fieldbus.OnNewStatusFieldbusInfo', 'Fieldbus_OnNewStatusFieldbusInfo')

Script.serveEvent('CSK_Fieldbus.OnNewStatusCreateMode', 'Fieldbus_OnNewStatusCreateMode')
Script.serveEvent('CSK_Fieldbus.OnNewStatusTransmissionMode', 'Fieldbus_OnNewStatusTransmissionMode')


Script.serveEvent('CSK_Fieldbus.OnNewStatusControlBitsIn', 'Fieldbus_OnNewStatusControlBitsIn')
Script.serveEvent('CSK_Fieldbus.OnNewStatusControlBitsOut', 'Fieldbus_OnNewStatusControlBitsOut')

Script.serveEvent('CSK_Fieldbus.OnNewStatusDataToTransmit', 'Fieldbus_OnNewStatusDataToTransmit')

Script.serveEvent('CSK_Fieldbus.OnNewStatusControlBitsInToWrite', 'Fieldbus_OnNewStatusControlBitsInToWrite')
Script.serveEvent('CSK_Fieldbus.OnNewStatusBitMask', 'Fieldbus_OnNewStatusBitMask')

Script.serveEvent('CSK_Fieldbus.OnNewStatusEtherNetIPAddressingMode', 'Fieldbus_OnNewStatusEtherNetIPAddressingMode')
Script.serveEvent('CSK_Fieldbus.OnNewStatusEtherNetIPIPAddress', 'Fieldbus_OnNewStatusEtherNetIPIPAddress')
Script.serveEvent('CSK_Fieldbus.OnNewStatusEtherNetIPSubnetMask', 'Fieldbus_OnNewStatusEtherNetIPSubnetMask')
Script.serveEvent('CSK_Fieldbus.OnNewStatusEtherNetIPGateway', 'Fieldbus_OnNewStatusEtherNetIPGateway')
Script.serveEvent('CSK_Fieldbus.OnNewStatusEtherNetIPNameServer', 'Fieldbus_OnNewStatusEtherNetIPNameServer')
Script.serveEvent('CSK_Fieldbus.OnNewStatusEtherNetIPNameServer2', 'Fieldbus_OnNewStatusEtherNetIPNameServer2')
Script.serveEvent('CSK_Fieldbus.OnNewStatusEtherNetIPDomainName', 'Fieldbus_OnNewStatusEtherNetIPDomainName')
Script.serveEvent('CSK_Fieldbus.OnNewStatusEtherNetIPMACAddress', 'Fieldbus_OnNewStatusEtherNetIPMACAddress')

Script.serveEvent('CSK_Fieldbus.OnNewStatusProfinetIODeviceName', 'Fieldbus_OnNewStatusProfinetIODeviceName')
Script.serveEvent('CSK_Fieldbus.OnNewStatusProfinetIOIPAddress', 'Fieldbus_OnNewStatusProfinetIOIPAddress')
Script.serveEvent('CSK_Fieldbus.OnNewStatusProfinetIOSubnetMask', 'Fieldbus_OnNewStatusProfinetIOSubnetMask')
Script.serveEvent('CSK_Fieldbus.OnNewStatusProfinetIOGateway', 'Fieldbus_OnNewStatusProfinetIOGateway')
Script.serveEvent('CSK_Fieldbus.OnNewStatusProfinetIORemanent', 'Fieldbus_OnNewStatusProfinetIORemanent')
Script.serveEvent('CSK_Fieldbus.OnNewStatusProfinetIOMACAddress', 'Fieldbus_OnNewStatusProfinetIOMACAddress')

Script.serveEvent('CSK_Fieldbus.OnNewStatusDAPIMDescriptor', 'Fieldbus_OnNewStatusDAPIMDescriptor')
Script.serveEvent('CSK_Fieldbus.OnNewStatusDAPIMHardwareRev', 'Fieldbus_OnNewStatusDAPIMHardwareRev')
Script.serveEvent('CSK_Fieldbus.OnNewStatusDAPIMInstallationDate', 'Fieldbus_OnNewStatusDAPIMInstallationDate')
Script.serveEvent('CSK_Fieldbus.OnNewStatusDAPIMSoftwareRev', 'Fieldbus_OnNewStatusDAPIMSoftwareRev')
Script.serveEvent('CSK_Fieldbus.OnNewStatusDAPIMTagFunction', 'Fieldbus_OnNewStatusDAPIMTagFunction')
Script.serveEvent('CSK_Fieldbus.OnNewStatusDAPIMTagLocation', 'Fieldbus_OnNewStatusDAPIMTagLocation')

Script.serveEvent("CSK_Fieldbus.OnNewStatusLoadParameterOnReboot", "Fieldbus_OnNewStatusLoadParameterOnReboot")
Script.serveEvent("CSK_Fieldbus.OnPersistentDataModuleAvailable", "Fieldbus_OnPersistentDataModuleAvailable")
Script.serveEvent("CSK_Fieldbus.OnNewParameterName", "Fieldbus_OnNewParameterName")
Script.serveEvent("CSK_Fieldbus.OnDataLoadedOnReboot", "Fieldbus_OnDataLoadedOnReboot")

Script.serveEvent('CSK_Fieldbus.OnUserLevelOperatorActive', 'Fieldbus_OnUserLevelOperatorActive')
Script.serveEvent('CSK_Fieldbus.OnUserLevelMaintenanceActive', 'Fieldbus_OnUserLevelMaintenanceActive')
Script.serveEvent('CSK_Fieldbus.OnUserLevelServiceActive', 'Fieldbus_OnUserLevelServiceActive')
Script.serveEvent('CSK_Fieldbus.OnUserLevelAdminActive', 'Fieldbus_OnUserLevelAdminActive')

-- ************************ UI Events End **********************************
--**************************************************************************
--********************** End Global Scope **********************************
--**************************************************************************
--**********************Start Function Scope *******************************
--**************************************************************************

-- Functions to forward logged in user roles via CSK_UserManagement module (if available)
-- ***********************************************
--- Function to react on status change of Operator user level
---@param status boolean Status if Operator level is active
local function handleOnUserLevelOperatorActive(status)
  Script.notifyEvent("Fieldbus_OnUserLevelOperatorActive", status)
end

--- Function to react on status change of Maintenance user level
---@param status boolean Status if Maintenance level is active
local function handleOnUserLevelMaintenanceActive(status)
  Script.notifyEvent("Fieldbus_OnUserLevelMaintenanceActive", status)
end

--- Function to react on status change of Service user level
---@param status boolean Status if Service level is active
local function handleOnUserLevelServiceActive(status)
  Script.notifyEvent("Fieldbus_OnUserLevelServiceActive", status)
end

--- Function to react on status change of Admin user level
---@param status boolean Status if Admin level is active
local function handleOnUserLevelAdminActive(status)
  Script.notifyEvent("Fieldbus_OnUserLevelAdminActive", status)
end

--- Function to get access to the fieldbus_Model object
---@param handle handle Handle of fieldbus_Model object
local function setFieldbus_Model_Handle(handle)
  fieldbus_Model = handle
  if fieldbus_Model.userManagementModuleAvailable then
    -- Register on events of CSK_UserManagement module if available
    Script.register('CSK_UserManagement.OnUserLevelOperatorActive', handleOnUserLevelOperatorActive)
    Script.register('CSK_UserManagement.OnUserLevelMaintenanceActive', handleOnUserLevelMaintenanceActive)
    Script.register('CSK_UserManagement.OnUserLevelServiceActive', handleOnUserLevelServiceActive)
    Script.register('CSK_UserManagement.OnUserLevelAdminActive', handleOnUserLevelAdminActive)
  end
  Script.releaseObject(handle)
end

--- Function to update user levels
local function updateUserLevel()
  if fieldbus_Model.userManagementModuleAvailable then
    -- Trigger CSK_UserManagement module to provide events regarding user role
    CSK_UserManagement.pageCalled()
  else
    -- If CSK_UserManagement is not active, show everything
    Script.notifyEvent("Fieldbus_OnUserLevelAdminActive", true)
    Script.notifyEvent("Fieldbus_OnUserLevelMaintenanceActive", true)
    Script.notifyEvent("Fieldbus_OnUserLevelServiceActive", true)
    Script.notifyEvent("Fieldbus_OnUserLevelOperatorActive", true)
  end
end

--- Function to send all relevant values to UI on resume
local function handleOnExpiredTmrFieldbus()

  updateUserLevel()

  Script.notifyEvent("Fieldbus_OnNewStatusActiveProtocol", fieldbus_Model.fbMode)
  Script.notifyEvent("Fieldbus_OnNewStatusFieldbusStatus", fieldbus_Model.currentStatus)
  Script.notifyEvent("Fieldbus_OnNewStatusFieldbusInfo", fieldbus_Model.info)
  Script.notifyEvent("Fieldbus_OnNewStatusProtocol", fieldbus_Model.parameters.protocol)

  if fieldbus_Model.fbMode == 'DISABLED' then
    Script.notifyEvent("Fieldbus_OnNewStatusFieldbusFeatureActive", false)
  else
    Script.notifyEvent("Fieldbus_OnNewStatusFieldbusFeatureActive", true)

    Script.notifyEvent("Fieldbus_OnNewStatusCreateMode", fieldbus_Model.parameters.createMode)
    Script.notifyEvent("Fieldbus_OnNewStatusTransmissionMode", fieldbus_Model.parameters.transmissionMode)

    Script.notifyEvent("Fieldbus_OnNewStatusControlBitsIn", fieldbus_Model.controlBitsIn)
    Script.notifyEvent("Fieldbus_OnNewStatusControlBitsOut", fieldbus_Model.controlBitsOut)

    Script.notifyEvent("Fieldbus_OnNewStatusDataToTransmit", fieldbus_Model.dataToTransmit)

    Script.notifyEvent("Fieldbus_OnNewStatusControlBitsInToWrite", fieldbus_Model.controlBitsToWrite)
    Script.notifyEvent("Fieldbus_OnNewStatusBitMask", fieldbus_Model.bitMask)

    if fieldbus_Model.fbMode == 'EtherNetIP' then
      Script.notifyEvent("Fieldbus_OnNewStatusEtherNetIPAddressingMode", fieldbus_Model.parameters.etherNetIP.addressingMode)
      Script.notifyEvent("Fieldbus_OnNewStatusEtherNetIPIPAddress", fieldbus_Model.parameters.etherNetIP.ipAddress)
      Script.notifyEvent("Fieldbus_OnNewStatusEtherNetIPSubnetMask", fieldbus_Model.parameters.etherNetIP.netmask)
      Script.notifyEvent("Fieldbus_OnNewStatusEtherNetIPGateway", fieldbus_Model.parameters.etherNetIP.gateway)
      Script.notifyEvent("Fieldbus_OnNewStatusEtherNetIPNameServer", fieldbus_Model.parameters.etherNetIP.nameServer)
      Script.notifyEvent("Fieldbus_OnNewStatusEtherNetIPNameServer2", fieldbus_Model.parameters.etherNetIP.nameServer2)
      Script.notifyEvent("Fieldbus_OnNewStatusEtherNetIPDomainName", fieldbus_Model.parameters.etherNetIP.domainName)
      Script.notifyEvent("Fieldbus_OnNewStatusEtherNetIPMACAddress", fieldbus_Model.parameters.etherNetIP.macAddress)

    elseif fieldbus_Model.fbMode == 'ProfinetIO' then
      Script.notifyEvent("Fieldbus_OnNewStatusProfinetIODeviceName", fieldbus_Model.parameters.profinetIO.deviceName)
      Script.notifyEvent("Fieldbus_OnNewStatusProfinetIOIPAddress", fieldbus_Model.parameters.profinetIO.ipAddress)
      Script.notifyEvent("Fieldbus_OnNewStatusProfinetIOSubnetMask", fieldbus_Model.parameters.profinetIO.netmask)
      Script.notifyEvent("Fieldbus_OnNewStatusProfinetIOGateway", fieldbus_Model.parameters.profinetIO.gateway)
      Script.notifyEvent("Fieldbus_OnNewStatusProfinetIORemanent", fieldbus_Model.parameters.profinetIO.remanent)
      Script.notifyEvent("Fieldbus_OnNewStatusProfinetIOMACAddress", fieldbus_Model.parameters.profinetIO.macAddress)

      Script.notifyEvent("Fieldbus_OnNewStatusDAPIMDescriptor", fieldbus_Model.parameters.profinetIO.dapImDescriptor)
      Script.notifyEvent("Fieldbus_OnNewStatusDAPIMHardwareRev", fieldbus_Model.parameters.profinetIO.dapImHardwareRev)
      Script.notifyEvent("Fieldbus_OnNewStatusDAPIMInstallationDate", fieldbus_Model.parameters.profinetIO.dapImInstallDate)
      Script.notifyEvent("Fieldbus_OnNewStatusDAPIMSoftwareRev", fieldbus_Model.parameters.profinetIO.dapImSoftwareRevPrefix .. '.' .. tostring(fieldbus_Model.parameters.profinetIO.dapImSoftwareRevFuncEnhancement) .. '.' .. tostring(fieldbus_Model.parameters.profinetIO.dapImSoftwareRevBugFix) .. '.' .. tostring(fieldbus_Model.parameters.profinetIO.dapImSoftwareRevInternalChange))
      Script.notifyEvent("Fieldbus_OnNewStatusDAPIMTagFunction", fieldbus_Model.parameters.profinetIO.dapImTagFunction)
      Script.notifyEvent("Fieldbus_OnNewStatusDAPIMTagLocation", fieldbus_Model.parameters.profinetIO.dapImTagLocation)
    end
  end

  Script.notifyEvent("Fieldbus_OnNewStatusLoadParameterOnReboot", fieldbus_Model.parameterLoadOnReboot)
  Script.notifyEvent("Fieldbus_OnPersistentDataModuleAvailable", fieldbus_Model.persistentModuleAvailable)
  Script.notifyEvent("Fieldbus_OnNewParameterName", fieldbus_Model.parametersName)
end
Timer.register(tmrFieldbus, "OnExpired", handleOnExpiredTmrFieldbus)

-- ********************* UI Setting / Submit Functions Start ********************

local function pageCalled()
  updateUserLevel() -- try to hide user specific content asap
  tmrFieldbus:start()
  return ''
end
Script.serveFunction("CSK_Fieldbus.pageCalled", pageCalled)

local function setProtocol(protocol)
  _G.logger:info(nameOfModule .. ": Set protocol to: " .. tostring(protocol))
  fieldbus_Model.parameters.protocol = protocol
  handleOnExpiredTmrFieldbus()
end
Script.serveFunction('CSK_Fieldbus.setProtocol', setProtocol)

local function restartDevice()
  Parameters.savePermanent()
  CSK_Fieldbus.sendParameters()
  Engine.reboot('Change fieldbus protocol.')
end

local function submitProtocol()
  if fieldbus_Model.parameters.protocol == 'ProfinetIO' and Parameters.get('FBmode') ~= 1 then
      Parameters.set('FBmode', 1)
      restartDevice()
  elseif fieldbus_Model.parameters.protocol == 'EtherNetIP' and Parameters.get('FBmode') ~= 2 then
    Parameters.set('FBmode', 2)
    restartDevice()
  elseif fieldbus_Model.parameters.protocol == 'DISABLED' and Parameters.get('FBmode') ~= 0 then
    Parameters.set('FBmode', 0)
    restartDevice()
  else
    print("TODO")
  end
end
Script.serveFunction('CSK_Fieldbus.submitProtocol', submitProtocol)

local function setCreateMode(mode)
  fieldbus_Model.parameters.createMode = mode
  --TODO
end
Script.serveFunction('CSK_Fieldbus.setCreateMode', setCreateMode)

local function setTransmissionMode(mode)
  fieldbus_Model.parameters.transmissionMode = mode
  --TODO
end
Script.serveFunction('CSK_Fieldbus.setTransmissionMode', setTransmissionMode)

--[[
local function createFieldbusHandle()
  fieldbus_Model.create()
end
]]

local function openCommunication()
  _G.logger:info(nameOfModule .. ": Open communciation.")
  fieldbus_Model.openCommunication()
end
Script.serveFunction('CSK_Fieldbus.openCommunication', openCommunication)

local function closeCommunication()
  _G.logger:info(nameOfModule .. ": Close communication.")
  fieldbus_Model.closeCommunication()
end
Script.serveFunction('CSK_Fieldbus.closeCommunication', closeCommunication)

local function refreshControlBits()
  fieldbus_Model.readControlBitsIn()
  fieldbus_Model.readControlBitsOut()
end
Script.serveFunction('CSK_Fieldbus.refreshControlBits', refreshControlBits)

local function setDataToTransmit(data)
  _G.logger:info(nameOfModule .. ": Set data to transmit to: " .. tostring(data))
  fieldbus_Model.dataToTransmit = data
end
Script.serveFunction('CSK_Fieldbus.setDataToTransmit', setDataToTransmit)

local function transmitViaUI()
  fieldbus_Model.transmit(fieldbus_Model.dataToTransmit)
end
Script.serveFunction('CSK_Fieldbus.transmitViaUI', transmitViaUI)

local function setControlBits(controlBits)
  _G.logger:info(nameOfModule .. ": Set controlBits to: " .. tostring(controlBits))
  fieldbus_Model.controlBitsToWrite = controlBits
end
Script.serveFunction('CSK_Fieldbus.setControlBits', setControlBits)

local function setBitMask(bitMask)
  _G.logger:info(nameOfModule .. ": Set bitMask to: " .. tostring(bitMask))
  fieldbus_Model.bitMask = bitMask
end
Script.serveFunction('CSK_Fieldbus.setBitMask', setBitMask)

local function writeControlBitsInViaUI()
  fieldbus_Model.writeControlBitsIn(fieldbus_Model.controlBitsToWrite, fieldbus_Model.bitMask)
end
Script.serveFunction('CSK_Fieldbus.writeControlBitsInViaUI', writeControlBitsInViaUI)

-- EtherNet/IP relevant
local function setAddressingMode(mode)
  _G.logger:info(nameOfModule .. ": Preset Addressing mode to: " .. tostring(mode))
  fieldbus_Model.parameters.etherNetIP.addressingMode = mode
end
Script.serveFunction('CSK_Fieldbus.setAddressingMode', setAddressingMode)

local function setEtherNetIPIP(ip)
  _G.logger:info(nameOfModule .. ": Preset EtherNet/IP IP to: " .. tostring(ip))
  fieldbus_Model.parameters.etherNetIP.ipAddress = ip
end
Script.serveFunction('CSK_Fieldbus.setEtherNetIPIP', setEtherNetIPIP)

local function setEtherNetIPSubnetMask(netmask)
  _G.logger:info(nameOfModule .. ": Preset EtherNet/IP subnet mask: " .. tostring(netmask))
  fieldbus_Model.parameters.etherNetIP.netmask = netmask
end
Script.serveFunction('CSK_Fieldbus.setEtherNetIPSubnetMask', setEtherNetIPSubnetMask)

local function setEtherNetIPGateway(gateway)
  _G.logger:info(nameOfModule .. ": Preset EtherNet/IP gateway: " .. tostring(gateway))
  fieldbus_Model.parameters.etherNetIP.gateway = gateway
end
Script.serveFunction('CSK_Fieldbus.setEtherNetIPGateway', setEtherNetIPGateway)

local function setEtherNetIPNameServer(nameServer)
  _G.logger:info(nameOfModule .. ": Preset EtherNet/IP primary name server: " .. tostring(nameServer))
  fieldbus_Model.parameters.etherNetIP.nameServer = nameServer
end
Script.serveFunction('CSK_Fieldbus.setEtherNetIPNameServer', setEtherNetIPNameServer)

local function setEtherNetIPNameServer2(nameServer)
  _G.logger:info(nameOfModule .. ": Preset EtherNet/IP secondary name server: " .. tostring(nameServer))
  fieldbus_Model.parameters.etherNetIP.nameServer2 = nameServer
end
Script.serveFunction('CSK_Fieldbus.setEtherNetIPNameServer2', setEtherNetIPNameServer2)

local function setEtherNetIPDomainName(domainName)
  _G.logger:info(nameOfModule .. ": Preset EtherNet/IP domain name: " .. tostring(domainName))
  fieldbus_Model.parameters.etherNetIP.domainName = domainName
end
Script.serveFunction('CSK_Fieldbus.setEtherNetIPDomainName', setEtherNetIPDomainName)

local function getEtherNetIPConfig()
  _G.logger:info(nameOfModule .. ": Get EtherNet/IP configuration.")
  fieldbus_Model.getEtherNetIPConfig()
end
Script.serveFunction('CSK_Fieldbus.getEtherNetIPConfig', getEtherNetIPConfig)

local function setEtherNetIPConfig()
  _G.logger:info(nameOfModule .. ": Activate preset EtherNet/IP configuration.")
  fieldbus_Model.setEtherNetIPConfig()
end
Script.serveFunction('CSK_Fieldbus.setEtherNetIPConfig', setEtherNetIPConfig)

-- ProfinetIO

local function setProfinetIODeviceName(name)
  _G.logger:info(nameOfModule .. ": Preset device name to: " .. tostring(name))
  fieldbus_Model.parameters.profinetIO.deviceName = mode
end
Script.serveFunction('CSK_Fieldbus.setProfinetIODeviceName', setProfinetIODeviceName)

local function setProfinetIOIP(ip)
  _G.logger:info(nameOfModule .. ": Preset ProfinetIO IP to: " .. tostring(ip))
  fieldbus_Model.parameters.profinetIO.ipAddress = ip
end
Script.serveFunction('CSK_Fieldbus.setProfinetIOIP', setProfinetIOIP)

local function setProfinetIOSubnetMask(netmask)
  _G.logger:info(nameOfModule .. ": Preset ProfinetIO subnet mask: " .. tostring(netmask))
  fieldbus_Model.parameters.profinetIO.netmask = netmask
end
Script.serveFunction('CSK_Fieldbus.setProfinetIOSubnetMask', setProfinetIOSubnetMask)

local function setProfinetIOGateway(gateway)
  _G.logger:info(nameOfModule .. ": Preset ProfinetIO gateway: " .. tostring(gateway))
  fieldbus_Model.parameters.profinetIO.gateway = gateway
end
Script.serveFunction('CSK_Fieldbus.setProfinetIOGateway', setProfinetIOGateway)

local function getProfinetIOConfig()
  _G.logger:info(nameOfModule .. ": Get ProfinetIO configuration.")
  fieldbus_Model.getProfinetIOConfigInfo()
end
Script.serveFunction('CSK_Fieldbus.getProfinetIOConfig', getProfinetIOConfig)

local function applyProfinetIOConfig()
  _G.logger:info(nameOfModule .. ": Activate preset ProfinetIO configuration.")
  fieldbus_Model.applyProfinetIOConfig()
end
Script.serveFunction('CSK_Fieldbus.applyProfinetIOConfig', applyProfinetIOConfig)

local function storeProfinetIOConfig()
  _G.logger:info(nameOfModule .. ": Store ProfinetIO configuration.")
  fieldbus_Model.storeProfinetIOConfig()
end
Script.serveFunction('CSK_Fieldbus.storeProfinetIOConfig', storeProfinetIOConfig)

local function setDAPIMDescriptor(descriptor)
  _G.logger:info(nameOfModule .. ": Preset DAP IM descriptoer to: " .. tostring(descriptor))
  fieldbus_Model.parameters.profinetIO.dapImDescriptor = descriptor
end
Script.serveFunction('CSK_Fieldbus.setDAPIMDescriptor', setDAPIMDescriptor)

local function setDAPIMInstallationDate(date)
  _G.logger:info(nameOfModule .. ": Preset DAP IM installation date to: " .. tostring(date))
  fieldbus_Model.parameters.profinetIO.dapImInstallDate = date
end
Script.serveFunction('CSK_Fieldbus.setDAPIMInstallationDate', setDAPIMInstallationDate)

local function setDAPIMTagFunction(tag)
  _G.logger:info(nameOfModule .. ": Preset DAP IM function tag to: " .. tostring(tag))
  fieldbus_Model.parameters.profinetIO.tagFunction = tag
end
Script.serveFunction('CSK_Fieldbus.setDAPIMTagFunction', setDAPIMTagFunction)

local function setDAPIMTagLocation(location)
  _G.logger:info(nameOfModule .. ": Preset DAP IM location tag to: " .. tostring(location))
  fieldbus_Model.parameters.profinetIO.tagLocation = location
end
Script.serveFunction('CSK_Fieldbus.setDAPIMTagLocation', setDAPIMTagLocation)

local function getDAPIMConfig()
  _G.logger:info(nameOfModule .. ": Get ProfinetIO DAP I&M data.")
  fieldbus_Model.getDapImConfigInfo()
end
Script.serveFunction('CSK_Fieldbus.getDAPIMConfig', getDAPIMConfig)

local function setDAPIMConfig()
  _G.logger:info(nameOfModule .. ": Set ProfinetIO DAP I&M data.")
  fieldbus_Model.setDapImConfig()
end
Script.serveFunction('CSK_Fieldbus.setDAPIMConfig', setDAPIMConfig)

local function storeDAPIMData()
  _G.logger:info(nameOfModule .. ": Store DAP I&M data.")
  fieldbus_Model.storeDapImData()
end
Script.serveFunction('CSK_Fieldbus.storeDAPIMData', storeDAPIMData)

---------------------------------------


-- *****************************************************************
-- Following function can be adapted for CSK_PersistentData module usage
-- *****************************************************************

local function setParameterName(name)
  _G.logger:info(nameOfModule .. ": Set parameter name: " .. tostring(name))
  fieldbus_Model.parametersName = name
end
Script.serveFunction("CSK_Fieldbus.setParameterName", setParameterName)

local function sendParameters()
  if fieldbus_Model.persistentModuleAvailable then
    CSK_PersistentData.addParameter(fieldbus_Model.helperFuncs.convertTable2Container(fieldbus_Model.parameters), fieldbus_Model.parametersName)
    CSK_PersistentData.setModuleParameterName(nameOfModule, fieldbus_Model.parametersName, fieldbus_Model.parameterLoadOnReboot)
    _G.logger:info(nameOfModule .. ": Send Fieldbus parameters with name '" .. fieldbus_Model.parametersName .. "' to CSK_PersistentData module.")
    CSK_PersistentData.saveData()
  else
    _G.logger:warning(nameOfModule .. ": CSK_PersistentData module not available.")
  end
end
Script.serveFunction("CSK_Fieldbus.sendParameters", sendParameters)

local function loadParameters()
  if fieldbus_Model.persistentModuleAvailable then
    local data = CSK_PersistentData.getParameter(fieldbus_Model.parametersName)
    if data then
      _G.logger:info(nameOfModule .. ": Loaded parameters from CSK_PersistentData module.")
      fieldbus_Model.parameters = fieldbus_Model.helperFuncs.convertContainer2Table(data)
      -- If something needs to be configured/activated with new loaded data, place this here:
      -- TODO auto reboot?
      local fbMode = Parameters.get('FBmode')
      if fbMode == 0 and fieldbus_Model.fbMode ~= 'DISABLED' then
        _G.logger:warning(nameOfModule .. ": Current fieldbus protocol of device differs from parameter setup. Please restart device.")
      elseif fbMode == 1 and fieldbus_Model.fbMode ~= 'ProfinetIO' then
        _G.logger:warning(nameOfModule .. ": Current fieldbus protocol of device differs from parameter setup. Please restart device.")
      elseif fbMode == 2 and fieldbus_Model.fbMode ~= 'EtherNetIP' then
        _G.logger:warning(nameOfModule .. ": Current fieldbus protocol of device differs from parameter setup. Please restart device.")
      end

      fieldbus_Model.create()

      CSK_Fieldbus.pageCalled()
    else
      _G.logger:warning(nameOfModule .. ": Loading parameters from CSK_PersistentData module did not work.")
    end
  else
    _G.logger:warning(nameOfModule .. ": CSK_PersistentData module not available.")
  end
end
Script.serveFunction("CSK_Fieldbus.loadParameters", loadParameters)

local function setLoadOnReboot(status)
  fieldbus_Model.parameterLoadOnReboot = status
  _G.logger:info(nameOfModule .. ": Set new status to load setting on reboot: " .. tostring(status))
end
Script.serveFunction("CSK_Fieldbus.setLoadOnReboot", setLoadOnReboot)

--- Function to react on initial load of persistent parameters
local function handleOnInitialDataLoaded()

  if string.sub(CSK_PersistentData.getVersion(), 1, 1) == '1' then

    _G.logger:warning(nameOfModule .. ': CSK_PersistentData module is too old and will not work. Please update CSK_PersistentData module.')

    fieldbus_Model.persistentModuleAvailable = false
  else

    local parameterName, loadOnReboot = CSK_PersistentData.getModuleParameterName(nameOfModule)

    if parameterName then
      fieldbus_Model.parametersName = parameterName
      fieldbus_Model.parameterLoadOnReboot = loadOnReboot
    else
      fieldbus_Model.create()
    end

    if fieldbus_Model.parameterLoadOnReboot then
      loadParameters()
    end
    Script.notifyEvent('Fieldbus_OnDataLoadedOnReboot')
  end
end
Script.register("CSK_PersistentData.OnInitialDataLoaded", handleOnInitialDataLoaded)

-- *************************************************
-- END of functions for CSK_PersistentData module usage
-- *************************************************

return setFieldbus_Model_Handle

--**************************************************************************
--**********************End Function Scope *********************************
--**************************************************************************

