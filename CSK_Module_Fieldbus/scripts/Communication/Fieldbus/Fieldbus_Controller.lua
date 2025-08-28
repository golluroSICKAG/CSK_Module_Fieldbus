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
-- Only to prevent WARNING messages, but these are only examples/placeholders for dynamically created events/functions
----------------------------------------------------------------
Script.serveEvent('CSK_Fieldbus.OnNewData_NAME', 'Fieldbus_OnNewData_NAME')
----------------------------------------------------------------

-- Real events
--------------------------------------------------

Script.serveEvent('CSK_Fieldbus.OnNewStatusModuleVersion', 'Fieldbus_OnNewStatusModuleVersion')
Script.serveEvent('CSK_Fieldbus.OnNewStatusCSKStyle', 'Fieldbus_OnNewStatusCSKStyle')
Script.serveEvent('CSK_Fieldbus.OnNewStatusModuleIsActive', 'Fieldbus_OnNewStatusModuleIsActive')

Script.serveEvent('CSK_Fieldbus.OnNewStatusLogMessage', 'Fieldbus_OnNewStatusLogMessage')
Script.serveEvent('CSK_Fieldbus.OnNewStatusRestartInfo', 'Fieldbus_OnNewStatusRestartInfo')

Script.serveEvent('CSK_Fieldbus.OnNewStatusReceivedData', 'Fieldbus_OnNewStatusReceivedData')

Script.serveEvent('CSK_Fieldbus.OnNewStatusFieldbusActive', 'Fieldbus_OnNewStatusFieldbusActive')
Script.serveEvent('CSK_Fieldbus.OnNewStatusFieldbusStatus', 'Fieldbus_OnNewStatusFieldbusStatus')

Script.serveEvent('CSK_Fieldbus.OnNewStatusActiveProtocol', 'Fieldbus_OnNewStatusActiveProtocol')

Script.serveEvent('CSK_Fieldbus.OnNewStatusProtocol', 'Fieldbus_OnNewStatusProtocol')
Script.serveEvent('CSK_Fieldbus.OnNewStatusFieldbusFeatureActive', 'Fieldbus_OnNewStatusFieldbusFeatureActive')

Script.serveEvent('CSK_Fieldbus.OnNewStatusFieldbusInfo', 'Fieldbus_OnNewStatusFieldbusInfo')

Script.serveEvent('CSK_Fieldbus.OnNewStatusCreateMode', 'Fieldbus_OnNewStatusCreateMode')
Script.serveEvent('CSK_Fieldbus.OnNewStatusExplicitModeActive', 'Fieldbus_OnNewStatusExplicitModeActive')

Script.serveEvent('CSK_Fieldbus.OnNewStatusTransmissionMode', 'Fieldbus_OnNewStatusTransmissionMode')

Script.serveEvent('CSK_Fieldbus.OnNewStatusControlBitsIn', 'Fieldbus_OnNewStatusControlBitsIn')
Script.serveEvent('CSK_Fieldbus.OnNewStatusControlBitsOut', 'Fieldbus_OnNewStatusControlBitsOut')
Script.serveEvent('CSK_Fieldbus.OnNewStatusControlBitsOutTable', 'Fieldbus_OnNewStatusControlBitsOutTable')

Script.serveEvent('CSK_Fieldbus.OnNewStatusControlBitsInToWrite', 'Fieldbus_OnNewStatusControlBitsInToWrite')
Script.serveEvent('CSK_Fieldbus.OnNewStatusControlBitsInTable', 'Fieldbus_OnNewStatusControlBitsInTable')
Script.serveEvent('CSK_Fieldbus.OnNewStatusBitMask', 'Fieldbus_OnNewStatusBitMask')
Script.serveEvent('CSK_Fieldbus.OnNewStatusControlBitsInBitMaskTable', 'Fieldbus_OnNewStatusControlBitsInBitMaskTable')

Script.serveEvent('CSK_Fieldbus.OnNewStatusDataTransmissionList', 'Fieldbus_OnNewStatusDataTransmissionList')
Script.serveEvent('CSK_Fieldbus.OnNewStatusRegisteredEventTransmit', 'Fieldbus_OnNewStatusRegisteredEventTransmit')
Script.serveEvent('CSK_Fieldbus.OnNewStatusDataNameTransmit', 'Fieldbus_OnNewStatusDataNameTransmit')
Script.serveEvent('CSK_Fieldbus.OnNewStatusConvertDataTransmit', 'Fieldbus_OnNewStatusConvertDataTransmit')
Script.serveEvent('CSK_Fieldbus.OnNewStatusBigEndianTransmit', 'Fieldbus_OnNewStatusBigEndianTransmit')
Script.serveEvent('CSK_Fieldbus.OnNewStatusDataTypeTransmit', 'Fieldbus_OnNewStatusDataTypeTransmit')
Script.serveEvent('CSK_Fieldbus.OnNewStatusTempDataTransmit', 'Fieldbus_OnNewStatusTempDataTransmit')
Script.serveEvent('CSK_Fieldbus.OnNewStatusDataToTransmit', 'Fieldbus_OnNewStatusDataToTransmit')

Script.serveEvent('CSK_Fieldbus.OnNewStatusDataReceivingList', 'Fieldbus_OnNewStatusDataReceivingList')
Script.serveEvent('CSK_Fieldbus.OnNewStatusDataNameReceive', 'Fieldbus_OnNewStatusDataNameReceive')
Script.serveEvent('CSK_Fieldbus.OnNewStatusConvertDataReceive', 'Fieldbus_OnNewStatusConvertDataReceive')
Script.serveEvent('CSK_Fieldbus.OnNewStatusBigEndianReceive', 'Fieldbus_OnNewStatusBigEndianReceive')
Script.serveEvent('CSK_Fieldbus.OnNewStatusDataTypeReceive', 'Fieldbus_OnNewStatusDataTypeReceive')

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

Script.serveEvent('CSK_Fieldbus.OnNewStatusFlowConfigPriority', 'Fieldbus_OnNewStatusFlowConfigPriority')
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

  Script.notifyEvent("Fieldbus_OnNewStatusModuleVersion", 'v' .. fieldbus_Model.version)
  Script.notifyEvent("Fieldbus_OnNewStatusCSKStyle", fieldbus_Model.styleForUI)
  Script.notifyEvent("Fieldbus_OnNewStatusModuleIsActive", _G.availableAPIs.default and _G.availableAPIs.specific)

  fieldbus_Model.boolControlBitsToWrite = fieldbus_Model.boolControlBitsOut

  Script.notifyEvent("Fieldbus_OnNewStatusActiveProtocol", fieldbus_Model.fbMode)

  Script.notifyEvent("Fieldbus_OnNewStatusFieldbusStatus", fieldbus_Model.currentStatus)
  Script.notifyEvent("Fieldbus_OnNewStatusFieldbusActive", fieldbus_Model.opened)
  Script.notifyEvent("Fieldbus_OnNewStatusRestartInfo", '')

  Script.notifyEvent("Fieldbus_OnNewStatusFieldbusInfo", fieldbus_Model.helperFuncs.jsonLine2Table(fieldbus_Model.info))
  Script.notifyEvent("Fieldbus_OnNewStatusProtocol", fieldbus_Model.parameters.protocol)

  Script.notifyEvent("Fieldbus_OnNewStatusDataTransmissionList", fieldbus_Model.helperFuncs.createJsonListTransmissionData(fieldbus_Model.parameters.dataNamesTransmit, fieldbus_Model.parameters.registeredEventsTransmit, fieldbus_Model.parameters.dataTypesTransmit, fieldbus_Model.parameters.convertDataTypesTransmit, fieldbus_Model.parameters.bigEndiansTransmit, fieldbus_Model.readableDataToTransmit, fieldbus_Model.selectedDataTransmit))
  Script.notifyEvent("Fieldbus_OnNewStatusDataNameTransmit", fieldbus_Model.dataNameTransmit)
  Script.notifyEvent("Fieldbus_OnNewStatusRegisteredEventTransmit", fieldbus_Model.registerEventTransmit)
  Script.notifyEvent("Fieldbus_OnNewStatusConvertDataTransmit", fieldbus_Model.convertDataTransmit)
  Script.notifyEvent("Fieldbus_OnNewStatusBigEndianTransmit", fieldbus_Model.bigEndianTransmit)
  Script.notifyEvent("Fieldbus_OnNewStatusDataTypeTransmit", fieldbus_Model.dataTypeTransmit)
  Script.notifyEvent("Fieldbus_OnNewStatusTempDataTransmit", tostring(fieldbus_Model.tempDataTransmit))

  Script.notifyEvent("Fieldbus_OnNewStatusDataReceivingList", fieldbus_Model.helperFuncs.createJsonListReceiveData(fieldbus_Model.parameters.dataNamesReceive, fieldbus_Model.parameters.dataTypesReceive, fieldbus_Model.parameters.convertDataTypesReceive, fieldbus_Model.parameters.bigEndiansReceive, fieldbus_Model.dataReceived, fieldbus_Model.selectedDataReceive))
  Script.notifyEvent("Fieldbus_OnNewStatusDataNameReceive", fieldbus_Model.dataNameReceive)
  Script.notifyEvent("Fieldbus_OnNewStatusConvertDataReceive", fieldbus_Model.convertDataReceive)
  Script.notifyEvent("Fieldbus_OnNewStatusBigEndianReceive", fieldbus_Model.bigEndianReceive)
  Script.notifyEvent("Fieldbus_OnNewStatusDataTypeReceive", fieldbus_Model.dataTypeReceive)

  Script.notifyEvent("Fieldbus_OnNewStatusControlBitsIn", fieldbus_Model.controlBitsIn)
  Script.notifyEvent("Fieldbus_OnNewStatusControlBitsOut", fieldbus_Model.controlBitsOut)

  Script.notifyEvent("Fieldbus_OnNewStatusControlBitsOutTable", fieldbus_Model.boolControlBitsOut)
  Script.notifyEvent("Fieldbus_OnNewStatusControlBitsInTable", fieldbus_Model.boolControlBitsIn)
  Script.notifyEvent("Fieldbus_OnNewStatusControlBitsInBitMaskTable", fieldbus_Model.boolBitMask)

  Script.notifyEvent("Fieldbus_OnNewStatusControlBitsInToWrite", fieldbus_Model.controlBitsToWrite)
  Script.notifyEvent("Fieldbus_OnNewStatusBitMask", fieldbus_Model.bitMask)

  if fieldbus_Model.fbMode == 'DISABLED' then
    Script.notifyEvent("Fieldbus_OnNewStatusFieldbusFeatureActive", false)
  else
    Script.notifyEvent("Fieldbus_OnNewStatusFieldbusFeatureActive", true)

    Script.notifyEvent("Fieldbus_OnNewStatusCreateMode", fieldbus_Model.parameters.createMode)

    Script.notifyEvent("Fieldbus_OnNewStatusTransmissionMode", fieldbus_Model.parameters.transmissionMode)

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

  Script.notifyEvent("Fieldbus_OnNewStatusFlowConfigPriority", fieldbus_Model.parameters.flowConfigPriority)
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
  _G.logger:fine(nameOfModule .. ": Set protocol to: " .. tostring(protocol))
  fieldbus_Model.parameters.protocol = protocol
  handleOnExpiredTmrFieldbus()

  if (fieldbus_Model.parameters.protocol == 'ProfinetIO' and Parameters.get('FBmode') ~= 1) or (fieldbus_Model.parameters.protocol == 'EtherNetIP' and Parameters.get('FBmode') ~= 2) or (fieldbus_Model.parameters.protocol == 'DISABLED' and Parameters.get('FBmode') ~= 0) then
    Script.notifyEvent("Fieldbus_OnNewStatusRestartInfo", 'Device restart needed to activate new protocol!')
  else
    Script.notifyEvent("Fieldbus_OnNewStatusRestartInfo", '')
  end
end
Script.serveFunction('CSK_Fieldbus.setProtocol', setProtocol)

local function restartDevice()
  Parameters.savePermanent()
  if CSK_PersistentData then
    CSK_Fieldbus.sendParameters()
  end

  fieldbus_Model.info = "Rebooting the device NOW! Reason: 'Change fieldbus protocol.'"
  Script.notifyEvent("Fieldbus_OnNewStatusFieldbusInfo", fieldbus_Model.info)
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
  end
end
Script.serveFunction('CSK_Fieldbus.submitProtocol', submitProtocol)

local function setCreateMode(mode)
  if fieldbus_Model.currentStatus == 'CLOSED' then
    fieldbus_Model.parameters.createMode = mode
    if mode == 'AUTOMATIC_OPEN' then
      fieldbus_Model.parameters.transmissionMode = 'CONFIRMED_MESSAGING'
      Script.notifyEvent("Fieldbus_OnNewStatusTransmissionMode", fieldbus_Model.parameters.transmissionMode)
    end
  else
    _G.logger:info("Connection needs to be closed to configure the create mode.")
    Script.notifyEvent("Fieldbus_OnNewStatusCreateMode", fieldbus_Model.parameters.createMode)
  end
end
Script.serveFunction('CSK_Fieldbus.setCreateMode', setCreateMode)

local function setTransmissionMode(mode)
  if fieldbus_Model.parameters.createMode == 'EXPLICIT_OPEN' then
    fieldbus_Model.setTransmissionMode(mode)
  else
    _G.logger:info("Transmission mode only configurable if 'create mode' is 'EXPLICIT_OPEN'.")
    Script.notifyEvent("Fieldbus_OnNewStatusTransmissionMode", fieldbus_Model.parameters.transmissionMode)

    fieldbus_Model.info = "Transmission mode only configurable if 'create mode' is 'EXPLICIT_OPEN'."
    Script.notifyEvent("Fieldbus_OnNewStatusFieldbusInfo", fieldbus_Model.info)
  end
end
Script.serveFunction('CSK_Fieldbus.setTransmissionMode', setTransmissionMode)

local function openCommunication()
  local success = false
  if fieldbus_Model.currentStatus == 'CLOSED' then
    _G.logger:info(nameOfModule .. ": Open communciation.")
    success = fieldbus_Model.openCommunication()
  else
    _G.logger:fine("Connection already active.")
  end
  return success
end
Script.serveFunction('CSK_Fieldbus.openCommunication', openCommunication)

local function closeCommunication()
  _G.logger:info(nameOfModule .. ": Close communication.")
  fieldbus_Model.closeCommunication()

  fieldbus_Model.info = 'No info available.'
  Script.notifyEvent("Fieldbus_OnNewStatusFieldbusInfo", fieldbus_Model.info)
end
Script.serveFunction('CSK_Fieldbus.closeCommunication', closeCommunication)

local function refreshControlBits()
  fieldbus_Model.readControlBitsIn()
  fieldbus_Model.readControlBitsOut()
end
Script.serveFunction('CSK_Fieldbus.refreshControlBits', refreshControlBits)

local function setDataToTransmit(data)
  _G.logger:fine(nameOfModule .. ": Set data to transmit to: " .. tostring(data))
  fieldbus_Model.dataToTransmit = data
end
Script.serveFunction('CSK_Fieldbus.setDataToTransmit', setDataToTransmit)

local function transmitViaUI()
  fieldbus_Model.transmit(fieldbus_Model.dataToTransmit)
end
Script.serveFunction('CSK_Fieldbus.transmitViaUI', transmitViaUI)

local function setControlBitsIn(controlBits)
  _G.logger:fine(nameOfModule .. ": Set controlBits to: " .. tostring(controlBits))
  fieldbus_Model.controlBitsToWrite = controlBits
  fieldbus_Model.boolControlBitsToWrite = fieldbus_Model.helperFuncs.toBits(fieldbus_Model.controlBitsToWrite)
  Script.notifyEvent("Fieldbus_OnNewStatusControlBitsInTable", fieldbus_Model.boolControlBitsToWrite)
end
Script.serveFunction('CSK_Fieldbus.setControlBitsIn', setControlBitsIn)

local function setSpecificControlBitIn(values)
  local value = false
  local pos = tonumber(values[2])
  if values[1] == 'true' then
    value = true
  end
  if pos then
    fieldbus_Model.boolControlBitsToWrite[pos+1] = value
    fieldbus_Model.controlBitsToWrite = fieldbus_Model.helperFuncs.toNumber(fieldbus_Model.boolControlBitsToWrite)
    Script.notifyEvent("Fieldbus_OnNewStatusControlBitsInToWrite", fieldbus_Model.controlBitsToWrite)
  end
end
Script.serveFunction('CSK_Fieldbus.setSpecificControlBitIn', setSpecificControlBitIn)

local function setBitMask(bitMask)
  _G.logger:fine(nameOfModule .. ": Set bitMask to: " .. tostring(bitMask))
  fieldbus_Model.bitMask = bitMask
  fieldbus_Model.boolBitMask = fieldbus_Model.helperFuncs.toBits(fieldbus_Model.bitMask)
  Script.notifyEvent("Fieldbus_OnNewStatusControlBitsInBitMaskTable", fieldbus_Model.boolBitMask)
end
Script.serveFunction('CSK_Fieldbus.setBitMask', setBitMask)

local function setSpecificBitMaskBit(values)
  local value = false
  local pos = tonumber(values[2])
  if values[1] == 'true' then
    value = true
  end
  if pos then
    fieldbus_Model.boolBitMask[pos+1] = value
    fieldbus_Model.bitMask = fieldbus_Model.helperFuncs.toNumber(fieldbus_Model.boolBitMask)
    Script.notifyEvent("Fieldbus_OnNewStatusBitMask", fieldbus_Model.bitMask)
  end
end
Script.serveFunction('CSK_Fieldbus.setSpecificBitMaskBit', setSpecificBitMaskBit)

local function writeControlBitsInViaUI()
  fieldbus_Model.writeControlBitsIn(fieldbus_Model.controlBitsToWrite, fieldbus_Model.bitMask)
end
Script.serveFunction('CSK_Fieldbus.writeControlBitsInViaUI', writeControlBitsInViaUI)

-- EtherNet/IP relevant
local function setAddressingMode(mode)
  if FieldBus.Config.EtherNetIP.setAddressingMode(mode) then
    _G.logger:fine(string.format("ENIP: Setting addressing mode to '%s' succeeded", mode))
  else
    _G.logger:severe(string.format("ENIP: Setting addressing mode to '%s' failed", mode))
  end
  fieldbus_Model.parameters.etherNetIP.addressingMode = mode
  Script.notifyEvent("Fieldbus_OnNewStatusEtherNetIPAddressingMode", fieldbus_Model.parameters.etherNetIP.addressingMode)
  fieldbus_Model.getInfo()
end
Script.serveFunction('CSK_Fieldbus.setAddressingMode', setAddressingMode)

local function setEtherNetIPIP(ip)
  if ip ~= "0.0.0.0" then
    -- Convert IPs and netmask to numbers
    local a, b, c, d = ip:match("(%d+)%.(%d+)%.(%d+)%.(%d+)")
    local ipNum = tonumber(a) * 256^3 + tonumber(b) * 256^2 + tonumber(c) * 256 + tonumber(d)
    a, b, c, d = fieldbus_Model.parameters.etherNetIP.netmask:match("(%d+)%.(%d+)%.(%d+)%.(%d+)")
    local nmNum = tonumber(a) * 256^3 + tonumber(b) * 256^2 + tonumber(c) * 256 + tonumber(d)
    a, b, c, d = fieldbus_Model.parameters.etherNetIP.gateway:match("(%d+)%.(%d+)%.(%d+)%.(%d+)")
    local gwNum = tonumber(a) * 256^3 + tonumber(b) * 256^2 + tonumber(c) * 256 + tonumber(d)

    -- Perform bitwise AND between IP address and netmask to get the network address
    local networkAddress = ipNum & nmNum
    local gwNetworkAddress = gwNum & nmNum

    -- Check if IP address and gateway are in the same network
    if networkAddress == gwNetworkAddress then
      _G.logger:fine(nameOfModule .. ": Preset EtherNet/IP IP to: " .. tostring(ip))
    else
      _G.logger:fine(nameOfModule .. ": Store old valid EtherNet/IP IP address since current preset IP address is out of range with Gw address.")
      fieldbus_Model.parameters.etherNetIP.ipAddress2 = fieldbus_Model.parameters.etherNetIP.ipAddress
    end
    fieldbus_Model.parameters.etherNetIP.ipAddress = ip
    Script.notifyEvent("Fieldbus_OnNewStatusEtherNetIPIPAddress", fieldbus_Model.parameters.etherNetIP.ipAddress)
  else
    _G.logger:warning(nameOfModule .. ": Can't set EtherNet/IP IP address to '0.0.0.0'")
    fieldbus_Model.info ="Can't set EtherNet/IP IP to '0.0.0.0'"
    Script.notifyEvent("Fieldbus_OnNewStatusFieldbusInfo", fieldbus_Model.info)
  end
  Script.notifyEvent("Fieldbus_OnNewStatusEtherNetIPIPAddress", fieldbus_Model.parameters.etherNetIP.ipAddress)
end
Script.serveFunction('CSK_Fieldbus.setEtherNetIPIP', setEtherNetIPIP)

local function setEtherNetIPSubnetMask(netmask)
  if netmask ~= "0.0.0.0" then
    -- Convert IPs and netmask to numbers
    local a, b, c, d = fieldbus_Model.parameters.etherNetIP.ipAddress:match("(%d+)%.(%d+)%.(%d+)%.(%d+)")
    local ipNum = tonumber(a) * 256^3 + tonumber(b) * 256^2 + tonumber(c) * 256 + tonumber(d)
    a, b, c, d = netmask:match("(%d+)%.(%d+)%.(%d+)%.(%d+)")
    local nmNum = tonumber(a) * 256^3 + tonumber(b) * 256^2 + tonumber(c) * 256 + tonumber(d)
    a, b, c, d = fieldbus_Model.parameters.etherNetIP.gateway:match("(%d+)%.(%d+)%.(%d+)%.(%d+)")
    local gwNum = tonumber(a) * 256^3 + tonumber(b) * 256^2 + tonumber(c) * 256 + tonumber(d)

    -- Perform bitwise AND between IP address and netmask to get the network address
    local networkAddress = ipNum & nmNum
    local gwNetworkAddress = gwNum & nmNum

    -- Check if IP address and gateway are in the same network
    if networkAddress == gwNetworkAddress then
      _G.logger:fine(nameOfModule .. ": Preset EtherNet/IP Netmask: " .. tostring(netmask))
    else
      _G.logger:fine(nameOfModule .. ": Store old valid EtherNet/IP Netmask since current preset IP address is out of range with Gw address.")
      fieldbus_Model.parameters.etherNetIP.netmask2 = fieldbus_Model.parameters.etherNetIP.netmask -- TODO, never used?
    end
    fieldbus_Model.parameters.etherNetIP.netmask = netmask
    Script.notifyEvent("Fieldbus_OnNewStatusEtherNetIPSubnetMask", fieldbus_Model.parameters.etherNetIP.netmask)
  else
    _G.logger:warning(nameOfModule .. ": Can't set EtherNet/IP Netmask to '0.0.0.0'")
    fieldbus_Model.info ="Can't set EtherNet/IP Netmask to '0.0.0.0'"
    Script.notifyEvent("Fieldbus_OnNewStatusFieldbusInfo", fieldbus_Model.info)
  end
  Script.notifyEvent("Fieldbus_OnNewStatusEtherNetIPSubnetMask", fieldbus_Model.parameters.etherNetIP.netmask)
end
Script.serveFunction('CSK_Fieldbus.setEtherNetIPSubnetMask', setEtherNetIPSubnetMask)

local function setEtherNetIPGateway(gateway)
    -- Convert IPs and netmask to numbers
    local a, b, c, d = fieldbus_Model.parameters.etherNetIP.ipAddress:match("(%d+)%.(%d+)%.(%d+)%.(%d+)")
    local ipNum = tonumber(a) * 256^3 + tonumber(b) * 256^2 + tonumber(c) * 256 + tonumber(d)
    a, b, c, d = fieldbus_Model.parameters.etherNetIP.netmask:match("(%d+)%.(%d+)%.(%d+)%.(%d+)")
    local nmNum = tonumber(a) * 256^3 + tonumber(b) * 256^2 + tonumber(c) * 256 + tonumber(d)
    a, b, c, d = gateway:match("(%d+)%.(%d+)%.(%d+)%.(%d+)")
    local gwNum = tonumber(a) * 256^3 + tonumber(b) * 256^2 + tonumber(c) * 256 + tonumber(d)

    -- Perform bitwise AND between IP address and netmask to get the network address
    local networkAddress = ipNum & nmNum
    local gwNetworkAddress = gwNum & nmNum

    -- Check if IP address and gateway are in the same network
    if networkAddress == gwNetworkAddress then
      _G.logger:fine(nameOfModule .. ": Preset EtherNet/IP GW address: " .. tostring(gateway))
    else
      _G.logger:fine(nameOfModule .. ": Store old valid EtherNet/IP GW address since current preset IP address is out of range with Gw address.")
      fieldbus_Model.parameters.etherNetIP.gateway2 = fieldbus_Model.parameters.etherNetIP.gateway -- TODO, never used?
    end
    fieldbus_Model.parameters.etherNetIP.gateway = gateway
    Script.notifyEvent("Fieldbus_OnNewStatusEtherNetIPGateway", fieldbus_Model.parameters.etherNetIP.gateway)
end
Script.serveFunction('CSK_Fieldbus.setEtherNetIPGateway', setEtherNetIPGateway)

local function setEtherNetIPNameServer(nameServer)
  _G.logger:fine(nameOfModule .. ": Preset EtherNet/IP Primary name server: " .. tostring(nameServer))
  fieldbus_Model.parameters.etherNetIP.nameServer = nameServer
  Script.notifyEvent("Fieldbus_OnNewStatusEtherNetIPNameServer", fieldbus_Model.parameters.etherNetIP.nameServer)
end
Script.serveFunction('CSK_Fieldbus.setEtherNetIPNameServer', setEtherNetIPNameServer)

local function setEtherNetIPNameServer2(nameServer)
  _G.logger:fine(nameOfModule .. ": Preset EtherNet/IP secondary name server: " .. tostring(nameServer))
  fieldbus_Model.parameters.etherNetIP.nameServer2 = nameServer
  Script.notifyEvent("Fieldbus_OnNewStatusEtherNetIPNameServer2", fieldbus_Model.parameters.etherNetIP.nameServer2)
end
Script.serveFunction('CSK_Fieldbus.setEtherNetIPNameServer2', setEtherNetIPNameServer2)

local function setEtherNetIPDomainName(domainName)
  _G.logger:fine(nameOfModule .. ": Preset EtherNet/IP domain name: " .. tostring(domainName))
  fieldbus_Model.parameters.etherNetIP.domainName = domainName
  Script.notifyEvent("Fieldbus_OnNewStatusEtherNetIPDomainName", fieldbus_Model.parameters.etherNetIP.domainName)
end
Script.serveFunction('CSK_Fieldbus.setEtherNetIPDomainName', setEtherNetIPDomainName)

local function getEtherNetIPConfig()
  _G.logger:fine(nameOfModule .. ": Get EtherNet/IP configuration.")
  fieldbus_Model.getEtherNetIPConfig()
end
Script.serveFunction('CSK_Fieldbus.getEtherNetIPConfig', getEtherNetIPConfig)

local function setEtherNetIPConfig()
  _G.logger:fine(nameOfModule .. ": Activate preset EtherNet/IP configuration.")
  fieldbus_Model.setEtherNetIPConfig()
end
Script.serveFunction('CSK_Fieldbus.setEtherNetIPConfig', setEtherNetIPConfig)

-- ProfinetIO

local function setProfinetIODeviceName(name)
  _G.logger:fine(nameOfModule .. ": Preset device name to: " .. tostring(name))
  fieldbus_Model.parameters.profinetIO.deviceName = name
end
Script.serveFunction('CSK_Fieldbus.setProfinetIODeviceName', setProfinetIODeviceName)

local function setProfinetIOIP(ip)
  _G.logger:fine(nameOfModule .. ": Preset ProfinetIO IP to: " .. tostring(ip))
  fieldbus_Model.parameters.profinetIO.ipAddress = ip
end
Script.serveFunction('CSK_Fieldbus.setProfinetIOIP', setProfinetIOIP)

local function setProfinetIOSubnetMask(netmask)
  _G.logger:fine(nameOfModule .. ": Preset ProfinetIO subnet mask: " .. tostring(netmask))
  fieldbus_Model.parameters.profinetIO.netmask = netmask
end
Script.serveFunction('CSK_Fieldbus.setProfinetIOSubnetMask', setProfinetIOSubnetMask)

local function setProfinetIOGateway(gateway)
  _G.logger:fine(nameOfModule .. ": Preset ProfinetIO gateway: " .. tostring(gateway))
  fieldbus_Model.parameters.profinetIO.gateway = gateway
end
Script.serveFunction('CSK_Fieldbus.setProfinetIOGateway', setProfinetIOGateway)

local function getProfinetIOConfig()
  _G.logger:fine(nameOfModule .. ": Get ProfinetIO configuration.")
  fieldbus_Model.getProfinetIOConfigInfo()
end
Script.serveFunction('CSK_Fieldbus.getProfinetIOConfig', getProfinetIOConfig)

local function applyProfinetIOConfig()
  _G.logger:fine(nameOfModule .. ": Activate preset ProfinetIO configuration.")
  fieldbus_Model.applyProfinetIOConfig()
end
Script.serveFunction('CSK_Fieldbus.applyProfinetIOConfig', applyProfinetIOConfig)

local function storeProfinetIOConfig()
  _G.logger:fine(nameOfModule .. ": Store ProfinetIO configuration.")
  fieldbus_Model.storeProfinetIOConfig()
end
Script.serveFunction('CSK_Fieldbus.storeProfinetIOConfig', storeProfinetIOConfig)

local function setDAPIMDescriptor(descriptor)
  _G.logger:fine(nameOfModule .. ": Preset DAP IM descriptoer to: " .. tostring(descriptor))
  fieldbus_Model.parameters.profinetIO.dapImDescriptor = descriptor
end
Script.serveFunction('CSK_Fieldbus.setDAPIMDescriptor', setDAPIMDescriptor)

local function setDAPIMInstallationDate(date)
  _G.logger:fine(nameOfModule .. ": Preset DAP IM installation date to: " .. tostring(date))
  fieldbus_Model.parameters.profinetIO.dapImInstallDate = date
end
Script.serveFunction('CSK_Fieldbus.setDAPIMInstallationDate', setDAPIMInstallationDate)

local function setDAPIMTagFunction(tag)
  _G.logger:fine(nameOfModule .. ": Preset DAP IM function tag to: " .. tostring(tag))
  fieldbus_Model.parameters.profinetIO.tagFunction = tag
end
Script.serveFunction('CSK_Fieldbus.setDAPIMTagFunction', setDAPIMTagFunction)

local function setDAPIMTagLocation(location)
  _G.logger:fine(nameOfModule .. ": Preset DAP IM location tag to: " .. tostring(location))
  fieldbus_Model.parameters.profinetIO.tagLocation = location
end
Script.serveFunction('CSK_Fieldbus.setDAPIMTagLocation', setDAPIMTagLocation)

local function getDAPIMConfig()
  _G.logger:fine(nameOfModule .. ": Get ProfinetIO DAP I&M data.")
  fieldbus_Model.getDapImConfigInfo()
end
Script.serveFunction('CSK_Fieldbus.getDAPIMConfig', getDAPIMConfig)

local function setDAPIMConfig()
  _G.logger:fine(nameOfModule .. ": Set ProfinetIO DAP I&M data.")
  fieldbus_Model.setDapImConfig()
end
Script.serveFunction('CSK_Fieldbus.setDAPIMConfig', setDAPIMConfig)

local function storeDAPIMData()
  _G.logger:fine(nameOfModule .. ": Store DAP I&M data.")
  fieldbus_Model.storeDapImData()
end
Script.serveFunction('CSK_Fieldbus.storeDAPIMData', storeDAPIMData)

local function setDataNameTransmit(name)
  _G.logger:fine(nameOfModule .. ": Preset DataName to transmit: " .. tostring(name))
  fieldbus_Model.dataNameTransmit = name
end
Script.serveFunction('CSK_Fieldbus.setDataNameTransmit', setDataNameTransmit)

local function setDataNameReceive(name)
  _G.logger:fine(nameOfModule .. ": Preset DataName to receive: " .. tostring(name))
  fieldbus_Model.dataNameReceive = name
end
Script.serveFunction('CSK_Fieldbus.setDataNameReceive', setDataNameReceive)

local function setRegisteredEventTransmit(eventName)
  _G.logger:fine(nameOfModule .. ": Preset event to register for transmit data to: " .. tostring(eventName))
  fieldbus_Model.registerEventTransmit = eventName
end
Script.serveFunction('CSK_Fieldbus.setRegisteredEventTransmit', setRegisteredEventTransmit)

local function setConvertDataTransmit(status)
  _G.logger:fine(nameOfModule .. ": Preset status to convert transmit data to: " .. tostring(status))
  fieldbus_Model.convertDataTransmit = status
end
Script.serveFunction('CSK_Fieldbus.setConvertDataTransmit', setConvertDataTransmit)

local function setConvertDataReceive(status)
  _G.logger:fine(nameOfModule .. ": Preset status to convert received data to: " .. tostring(status))
  fieldbus_Model.convertDataReceive = status
end
Script.serveFunction('CSK_Fieldbus.setConvertDataReceive', setConvertDataReceive)

local function setBigEndianTransmit(status)
  _G.logger:fine(nameOfModule .. ": Preset status of big endian of transmit data to: " .. tostring(status))
  fieldbus_Model.bigEndianTransmit = status
end
Script.serveFunction('CSK_Fieldbus.setBigEndianTransmit', setBigEndianTransmit)

local function setBigEndianReceive(status)
  _G.logger:fine(nameOfModule .. ": Preset status of big endian of received data to: " .. tostring(status))
  fieldbus_Model.bigEndianReceive = status
end
Script.serveFunction('CSK_Fieldbus.setBigEndianReceive', setBigEndianReceive)

local function setDataTypeTransmit(dataType)
  _G.logger:fine(nameOfModule .. ": Preset data type of transmit to: " .. tostring(dataType))
  fieldbus_Model.dataTypeTransmit = dataType
end
Script.serveFunction('CSK_Fieldbus.setDataTypeTransmit', setDataTypeTransmit)

local function setDataTypeReceive(dataType)
  _G.logger:fine(nameOfModule .. ": Preset type or received data to: " .. tostring(dataType))
  fieldbus_Model.dataTypeReceive = dataType
end
Script.serveFunction('CSK_Fieldbus.setDataTypeReceive', setDataTypeReceive)

local function editDataToTransfer(dataName)

  Script.deregister(fieldbus_Model.parameters.registeredEventsTransmit[dataName], fieldbus_Model.dataUpdateFunctions[dataName])

  fieldbus_Model.parameters.registeredEventsTransmit[dataName] = fieldbus_Model.registerEventTransmit
  fieldbus_Model.parameters.convertDataTypesTransmit[dataName] = fieldbus_Model.convertDataTransmit
  fieldbus_Model.parameters.bigEndiansTransmit[dataName] = fieldbus_Model.bigEndianTransmit
  fieldbus_Model.parameters.dataTypesTransmit[dataName] = fieldbus_Model.dataTypeTransmit

  fieldbus_Model.registerToEvent(fieldbus_Model.parameters.registeredEventsTransmit[dataName], tonumber(fieldbus_Model.selectedDataTransmit), dataName)

  fieldbus_Model.totalDataSizeTransmit = fieldbus_Model.helperFuncs.getDataSize(fieldbus_Model.parameters.dataTypesTransmit)
  Script.notifyEvent('Fieldbus_OnNewStatusLogMessage', "New transmit data size = " .. tostring(fieldbus_Model.totalDataSizeTransmit))
end

local function addDataToTransmitViaUI()
  if fieldbus_Model.selectedDataTransmit == '' then
    if not fieldbus_Model.parameters.registeredEventsTransmit[fieldbus_Model.dataNameTransmit] then
      _G.logger:fine(nameOfModule .. ": Add data to transmit.")
      fieldbus_Model.addDataTransmit(fieldbus_Model.dataNameTransmit, fieldbus_Model.registerEventTransmit, fieldbus_Model.convertDataTransmit, fieldbus_Model.dataTypeTransmit, fieldbus_Model.bigEndianTransmit)
    else
      _G.logger:warning(nameOfModule .. ": Transmit data with this name already exists.")
    end
  else
    local posName = fieldbus_Model.parameters.dataNamesTransmit[tonumber(fieldbus_Model.selectedDataTransmit)]
    if posName == fieldbus_Model.dataNameTransmit then
      _G.logger:fine(nameOfModule .. ": Edit data to transmit.")
      editDataToTransfer(posName)
    else
      _G.logger:info(nameOfModule .. ": Not possible to rename transmit data. Delete first and add new one...")
      fieldbus_Model.dataNameTransmit = fieldbus_Model.parameters.dataNamesTransmit[tonumber(fieldbus_Model.selectedDataTransmit)]
      Script.notifyEvent("Fieldbus_OnNewStatusDataNameTransmit", fieldbus_Model.dataNameTransmit)
    end
  end
  fieldbus_Model.totalDataSizeTransmit = fieldbus_Model.helperFuncs.getDataSize(fieldbus_Model.parameters.dataTypesTransmit)
  Script.notifyEvent('Fieldbus_OnNewStatusLogMessage', "New transmit data size = " .. tostring(fieldbus_Model.totalDataSizeTransmit))
  handleOnExpiredTmrFieldbus()
end
Script.serveFunction('CSK_Fieldbus.addDataToTransmitViaUI', addDataToTransmitViaUI)

local function deleteDataToTransmitViaUI()
  if fieldbus_Model.selectedDataTransmit ~= '' and tonumber(fieldbus_Model.selectedDataTransmit) then
    _G.logger:fine(nameOfModule .. ": Delete data entry no." .. fieldbus_Model.selectedDataTransmit)
    fieldbus_Model.removeDataTransmit(tonumber(fieldbus_Model.selectedDataTransmit))
    fieldbus_Model.selectedDataTransmit = ''
  end
  fieldbus_Model.totalDataSizeTransmit = fieldbus_Model.helperFuncs.getDataSize(fieldbus_Model.parameters.dataTypesTransmit)
  Script.notifyEvent('Fieldbus_OnNewStatusLogMessage', "New transmit data size = " .. tostring(fieldbus_Model.totalDataSizeTransmit))
  handleOnExpiredTmrFieldbus()
end
Script.serveFunction('CSK_Fieldbus.deleteDataToTransmitViaUI', deleteDataToTransmitViaUI)

local function dataTransmitPositionUp()
  if fieldbus_Model.selectedDataTransmit ~= '' and tonumber(fieldbus_Model.selectedDataTransmit) then
    fieldbus_Model.dataTransmitPositionUp(tonumber(fieldbus_Model.selectedDataTransmit))
  end
  handleOnExpiredTmrFieldbus()
end
Script.serveFunction('CSK_Fieldbus.dataTransmitPositionUp', dataTransmitPositionUp)

local function dataTransmitPositionDown()
  if fieldbus_Model.selectedDataTransmit ~= '' and tonumber(fieldbus_Model.selectedDataTransmit) then
    fieldbus_Model.dataTransmitPositionDown(tonumber(fieldbus_Model.selectedDataTransmit))
  end
  handleOnExpiredTmrFieldbus()
end
Script.serveFunction('CSK_Fieldbus.dataTransmitPositionDown', dataTransmitPositionDown)

--- Function to edit data to receive
---@param dataName string Name/identifier of data to update
local function editDataToReceive(dataName)

  fieldbus_Model.parameters.convertDataTypesReceive[dataName] = fieldbus_Model.convertDataReceive
  fieldbus_Model.parameters.bigEndiansReceive[dataName] = fieldbus_Model.bigEndianReceive
  fieldbus_Model.parameters.dataTypesReceive[dataName] = fieldbus_Model.dataTypeReceive

  fieldbus_Model.totalDataSizeReceive = fieldbus_Model.helperFuncs.getDataSize(fieldbus_Model.parameters.dataTypesReceive)
  Script.notifyEvent('Fieldbus_OnNewStatusLogMessage', "New data size to receive = " .. tostring(fieldbus_Model.totalDataSizeReceive))
end

local function addDataToReceiveViaUI()
  if fieldbus_Model.selectedDataReceive == '' then
    if not fieldbus_Model.parameters.convertDataTypesReceive[fieldbus_Model.dataNameReceive] then
      _G.logger:fine(nameOfModule .. ": Add data to receive.")
      fieldbus_Model.addDataReceive(fieldbus_Model.dataNameReceive, fieldbus_Model.convertDataReceive, fieldbus_Model.dataTypeReceive, fieldbus_Model.bigEndianReceive)
    else
      _G.logger:warning(nameOfModule .. ": Data with this name already exists.")
    end
  else
    local posName = fieldbus_Model.parameters.dataNamesReceive[tonumber(fieldbus_Model.selectedDataReceive)]
    if posName == fieldbus_Model.dataNameReceive then
      _G.logger:fine(nameOfModule .. ": Edit data to receive.")
      editDataToReceive(posName)
    else
      _G.logger:info(nameOfModule .. ": Not possible to rename data. Delete first and add new one...")
      fieldbus_Model.dataNameReceive = fieldbus_Model.parameters.dataNamesReceive[tonumber(fieldbus_Model.selectedDataReceive)]
      Script.notifyEvent("Fieldbus_OnNewStatusDataNameReceive", fieldbus_Model.dataNameReceive)
    end
  end
  fieldbus_Model.totalDataSizeReceive = fieldbus_Model.helperFuncs.getDataSize(fieldbus_Model.parameters.dataTypesReceive)
  Script.notifyEvent('Fieldbus_OnNewStatusLogMessage', "New data size to receive = " .. tostring(fieldbus_Model.totalDataSizeReceive))
  handleOnExpiredTmrFieldbus()
end
Script.serveFunction('CSK_Fieldbus.addDataToReceiveViaUI', addDataToReceiveViaUI)

local function deleteDataToReceiveViaUI()
  if fieldbus_Model.selectedDataReceive ~= '' and tonumber(fieldbus_Model.selectedDataReceive) then
    _G.logger:fine(nameOfModule .. ": Delete receive data entry no." .. fieldbus_Model.selectedDataReceive)
    fieldbus_Model.removeDataReceive(tonumber(fieldbus_Model.selectedDataReceive))
    fieldbus_Model.selectedDataReceive = ''
  end
  fieldbus_Model.totalDataSizeReceive = fieldbus_Model.helperFuncs.getDataSize(fieldbus_Model.parameters.dataTypesReceive)
  Script.notifyEvent('Fieldbus_OnNewStatusLogMessage', "New data size to receive = " .. tostring(fieldbus_Model.totalDataSizeReceive))
  handleOnExpiredTmrFieldbus()
end
Script.serveFunction('CSK_Fieldbus.deleteDataToReceiveViaUI', deleteDataToReceiveViaUI)

local function dataReceivePositionUp()
  if fieldbus_Model.selectedDataReceive ~= '' and tonumber(fieldbus_Model.selectedDataReceive) then
    fieldbus_Model.dataReceivePositionUp(tonumber(fieldbus_Model.selectedDataReceive))
  end
  handleOnExpiredTmrFieldbus()
end
Script.serveFunction('CSK_Fieldbus.dataReceivePositionUp', dataReceivePositionUp)

local function dataReceivePositionDown()
  if fieldbus_Model.selectedDataReceive ~= '' and tonumber(fieldbus_Model.selectedDataReceive) then
    fieldbus_Model.dataReceivePositionDown(tonumber(fieldbus_Model.selectedDataReceive))
  end
  handleOnExpiredTmrFieldbus()
end
Script.serveFunction('CSK_Fieldbus.dataReceivePositionDown', dataReceivePositionDown)

--- Function to check if selection in UIs DynamicTable can find related pattern
---@param selection string Full text of selection
---@param pattern string Pattern to search for
local function checkSelection(selection, pattern)
  if selection ~= "" then
    local _, pos = string.find(selection, pattern)
    if pos == nil then
    else
      pos = tonumber(pos)
      if pattern ~= '"selected":true' then
        local endPos = string.find(selection, '"', pos+1)
        local tempSelection = string.sub(selection, pos+1, endPos-1)
        if tempSelection ~= nil and tempSelection ~= '-' then
          return tempSelection
        end
      else
        return ''
      end
    end
  end
  return nil
end

local function selectDataTransmit(dataName)
  for key, value in pairs(fieldbus_Model.parameters.dataNamesTransmit) do
    if value == dataName then

      _G.logger:fine(nameOfModule .. ": Selected data no." .. tostring(key))
      fieldbus_Model.selectedDataTransmit = tostring(key)

      --local tempName = fieldbus_Model.parameters.dataNamesTransmit[tonumber(key)]

      fieldbus_Model.dataNameTransmit = value
      fieldbus_Model.registerEventTransmit = fieldbus_Model.parameters.registeredEventsTransmit[value]
      fieldbus_Model.convertDataTransmit = fieldbus_Model.parameters.convertDataTypesTransmit[value]
      fieldbus_Model.bigEndianTransmit = fieldbus_Model.parameters.bigEndiansTransmit[value]
      fieldbus_Model.dataTypeTransmit = fieldbus_Model.parameters.dataTypesTransmit[value]

      Script.notifyEvent("Fieldbus_OnNewStatusDataNameTransmit", fieldbus_Model.dataNameTransmit)
      Script.notifyEvent("Fieldbus_OnNewStatusRegisteredEventTransmit", fieldbus_Model.registerEventTransmit)
      Script.notifyEvent("Fieldbus_OnNewStatusConvertDataTransmit", fieldbus_Model.convertDataTransmit)
      Script.notifyEvent("Fieldbus_OnNewStatusBigEndianTransmit", fieldbus_Model.bigEndianTransmit)
      Script.notifyEvent("Fieldbus_OnNewStatusDataTypeTransmit", fieldbus_Model.dataTypeTransmit)
      return true
    end
  end
  fieldbus_Model.selectedDataTransmit = ''
  return false
end
Script.serveFunction('CSK_Fieldbus.selectDataTransmit', selectDataTransmit)

local function selectDataTransmitViaUI(selection)
  local tempSelection = checkSelection(selection, '"DTC_IDTransmit":"')
  if tempSelection then
    local isSelected = checkSelection(selection, '"selected":true')
    if isSelected then
      _G.logger:fine(nameOfModule .. ": Selected data no." .. tostring(tempSelection))
      fieldbus_Model.selectedDataTransmit = tempSelection

      local tempName = fieldbus_Model.parameters.dataNamesTransmit[tonumber(tempSelection)]

      fieldbus_Model.dataNameTransmit = tempName
      fieldbus_Model.registerEventTransmit = fieldbus_Model.parameters.registeredEventsTransmit[tempName]
      fieldbus_Model.convertDataTransmit = fieldbus_Model.parameters.convertDataTypesTransmit[tempName]
      fieldbus_Model.bigEndianTransmit = fieldbus_Model.parameters.bigEndiansTransmit[tempName]
      fieldbus_Model.dataTypeTransmit = fieldbus_Model.parameters.dataTypesTransmit[tempName]

      Script.notifyEvent("Fieldbus_OnNewStatusDataNameTransmit", fieldbus_Model.dataNameTransmit)
      Script.notifyEvent("Fieldbus_OnNewStatusRegisteredEventTransmit", fieldbus_Model.registerEventTransmit)
      Script.notifyEvent("Fieldbus_OnNewStatusConvertDataTransmit", fieldbus_Model.convertDataTransmit)
      Script.notifyEvent("Fieldbus_OnNewStatusBigEndianTransmit", fieldbus_Model.bigEndianTransmit)
      Script.notifyEvent("Fieldbus_OnNewStatusDataTypeTransmit", fieldbus_Model.dataTypeTransmit)
    else
      fieldbus_Model.selectedDataTransmit = ''
    end
    handleOnExpiredTmrFieldbus()
  end
end
Script.serveFunction('CSK_Fieldbus.selectDataTransmitViaUI', selectDataTransmitViaUI)

local function selectDataReceiveViaUI(selection)
  local tempSelection = checkSelection(selection, '"DTC_IDReceive":"')
  if tempSelection then
    local isSelected = checkSelection(selection, '"selected":true')
    if isSelected then
      _G.logger:fine(nameOfModule .. ": Selected receive data no." .. tostring(tempSelection))
      fieldbus_Model.selectedDataReceive = tempSelection

      local tempName = fieldbus_Model.parameters.dataNamesReceive[tonumber(tempSelection)]

      fieldbus_Model.dataNameReceive = tempName
      fieldbus_Model.convertDataReceive = fieldbus_Model.parameters.convertDataTypesReceive[tempName]
      fieldbus_Model.bigEndianReceive = fieldbus_Model.parameters.bigEndiansReceive[tempName]
      fieldbus_Model.dataTypeReceive = fieldbus_Model.parameters.dataTypesReceive[tempName]

      Script.notifyEvent("Fieldbus_OnNewStatusDataNameReceive", fieldbus_Model.dataNameReceive)
      Script.notifyEvent("Fieldbus_OnNewStatusConvertDataReceive", fieldbus_Model.convertDataReceive)
      Script.notifyEvent("Fieldbus_OnNewStatusBigEndianReceive", fieldbus_Model.bigEndianReceive)
      Script.notifyEvent("Fieldbus_OnNewStatusDataTypeReceive", fieldbus_Model.dataTypeReceive)
    else
      fieldbus_Model.selectedDataReceive = ''
    end
    handleOnExpiredTmrFieldbus()
  end
end
Script.serveFunction('CSK_Fieldbus.selectDataReceiveViaUI', selectDataReceiveViaUI)

local function setTempTransmitData(data)
  fieldbus_Model.tempDataTransmit = data
end
Script.serveFunction('CSK_Fieldbus.setTempTransmitData', setTempTransmitData)

local function triggerTempDataViaUI()
  if fieldbus_Model.selectedDataTransmit ~= '' then

    local value
    if fieldbus_Model.parameters.dataTypesTransmit[fieldbus_Model.dataNameTransmit] == 'CHAR' or fieldbus_Model.parameters.dataTypesTransmit[fieldbus_Model.dataNameTransmit] == 'STRING' then
      value = fieldbus_Model.tempDataTransmit
    else
      value = tonumber(fieldbus_Model.tempDataTransmit)
    end

    -- Temporarily activate conversion
    local tempConvertStatus = fieldbus_Model.parameters.convertDataTypesTransmit[fieldbus_Model.dataNameTransmit]
    fieldbus_Model.parameters.convertDataTypesTransmit[fieldbus_Model.dataNameTransmit] = true
    fieldbus_Model.dataUpdateFunctions[fieldbus_Model.dataNameTransmit](value)
    fieldbus_Model.parameters.convertDataTypesTransmit[fieldbus_Model.dataNameTransmit] = tempConvertStatus
  else
    _G.logger:fine(nameOfModule .. ": No data position selected.")
  end
  handleOnExpiredTmrFieldbus()
end
Script.serveFunction('CSK_Fieldbus.triggerTempDataViaUI', triggerTempDataViaUI)

local function resetTransmitData()
  fieldbus_Model.resetTransmitData()
  handleOnExpiredTmrFieldbus()
end
Script.serveFunction('CSK_Fieldbus.resetTransmitData', resetTransmitData)

local function getStatusModuleActive()
  return _G.availableAPIs.default and _G.availableAPIs.specific
end
Script.serveFunction('CSK_Fieldbus.getStatusModuleActive', getStatusModuleActive)

local function clearFlowConfigRelevantConfiguration()
  fieldbus_Model.deregisterAllEvents()
end
Script.serveFunction('CSK_Fieldbus.clearFlowConfigRelevantConfiguration', clearFlowConfigRelevantConfiguration)

local function getParameters()
  return fieldbus_Model.helperFuncs.json.encode(fieldbus_Model.parameters)
end
Script.serveFunction('CSK_Fieldbus.getParameters', getParameters)

-- *****************************************************************
-- Following function can be adapted for CSK_PersistentData module usage
-- *****************************************************************

local function setParameterName(name)
  _G.logger:fine(nameOfModule .. ": Set parameter name: " .. tostring(name))
  fieldbus_Model.parametersName = name
end
Script.serveFunction("CSK_Fieldbus.setParameterName", setParameterName)

local function sendParameters(noDataSave)
  if fieldbus_Model.persistentModuleAvailable then
    CSK_PersistentData.addParameter(fieldbus_Model.helperFuncs.convertTable2Container(fieldbus_Model.parameters), fieldbus_Model.parametersName)
    CSK_PersistentData.setModuleParameterName(nameOfModule, fieldbus_Model.parametersName, fieldbus_Model.parameterLoadOnReboot)
    _G.logger:fine(nameOfModule .. ": Send Fieldbus parameters with name '" .. fieldbus_Model.parametersName .. "' to CSK_PersistentData module.")
    if not noDataSave then
      CSK_PersistentData.saveData()
    end
  else
    _G.logger:warning(nameOfModule .. ": CSK_PersistentData module not available.")
  end
end
Script.serveFunction("CSK_Fieldbus.sendParameters", sendParameters)

--- Function to register on events provided e.g. by other modules (optionally react on timer started after loading of persistent parameters)
local function registerToEvents()
  for key, value in ipairs(fieldbus_Model.parameters.dataNamesTransmit) do
    fieldbus_Model.addEmptySpace(fieldbus_Model.parameters.dataTypesTransmit[value])
    fieldbus_Model.registerToEvent(fieldbus_Model.parameters.registeredEventsTransmit[value], key, value)
  end
end

local function loadParameters(wait)
  if fieldbus_Model.persistentModuleAvailable then
    local data = CSK_PersistentData.getParameter(fieldbus_Model.parametersName)
    if data then
      clearFlowConfigRelevantConfiguration()

      _G.logger:info(nameOfModule .. ": Loaded parameters from CSK_PersistentData module.")
      fieldbus_Model.parameters = fieldbus_Model.helperFuncs.convertContainer2Table(data)

      -- If something needs to be configured/activated with new loaded data, place this here
      local fbMode = Parameters.get('FBmode') -- TODO check with SIM2000STE
      if (fbMode == 0 and fieldbus_Model.fbMode ~= 'DISABLED') or (fbMode == 1 and fieldbus_Model.fbMode ~= 'ProfinetIO') or ( fbMode == 2 and fieldbus_Model.fbMode ~= 'EtherNetIP') then
        _G.logger:warning(nameOfModule .. ": Current fieldbus protocol of device differs from parameter setup. Please restart device.")
        return
      end

      registerToEvents()

      fieldbus_Model.dataReceived = {}
      for key, value in ipairs(fieldbus_Model.parameters.dataNamesReceive) do
        fieldbus_Model.dataReceived[value] = '-'
        fieldbus_Model.serveReceiveEvent(value)
      end

      if fieldbus_Model.parameters.active == true then
        fieldbus_Model.openCommunication()
      end

      CSK_Fieldbus.pageCalled()
      return true
    else
      _G.logger:warning(nameOfModule .. ": Loading parameters from CSK_PersistentData module did not work.")
      return false
    end
  else
    _G.logger:warning(nameOfModule .. ": CSK_PersistentData module not available.")
    return false
  end
end
Script.serveFunction("CSK_Fieldbus.loadParameters", loadParameters)

local function setLoadOnReboot(status)
  fieldbus_Model.parameterLoadOnReboot = status
  _G.logger:fine(nameOfModule .. ": Set new status to load setting on reboot: " .. tostring(status))
  Script.notifyEvent("Fieldbus_OnNewStatusLoadParameterOnReboot", status)
end
Script.serveFunction("CSK_Fieldbus.setLoadOnReboot", setLoadOnReboot)

local function setFlowConfigPriority(status)
  fieldbus_Model.parameters.flowConfigPriority = status
  _G.logger:fine(nameOfModule .. ": Set new status of FlowConfig priority: " .. tostring(status))
  Script.notifyEvent("Fieldbus_OnNewStatusFlowConfigPriority", fieldbus_Model.parameters.flowConfigPriority)
end
Script.serveFunction('CSK_Fieldbus.setFlowConfigPriority', setFlowConfigPriority)

--- Function to react on initial load of persistent parameters
local function handleOnInitialDataLoaded()

  if _G.availableAPIs.default and _G.availableAPIs.specific then
    _G.logger:fine(nameOfModule .. ': Try to initially load parameter from CSK_PersistentData module.')

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
end
Script.register("CSK_PersistentData.OnInitialDataLoaded", handleOnInitialDataLoaded)

local function resetModule()
  if _G.availableAPIs.default and _G.availableAPIs.specific then
    clearFlowConfigRelevantConfiguration()
    closeCommunication()
    pageCalled()
  end
end
Script.serveFunction('CSK_Fieldbus.resetModule', resetModule)
Script.register("CSK_PersistentData.OnResetAllModules", resetModule)

-- *************************************************
-- END of functions for CSK_PersistentData module usage
-- *************************************************

return setFieldbus_Model_Handle

--**************************************************************************
--**********************End Function Scope *********************************
--**************************************************************************

