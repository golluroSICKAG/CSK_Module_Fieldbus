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

-- Script.serveEvent("CSK_Fieldbus.OnNewEvent", "Fieldbus_OnNewEvent")

Script.serveEvent('CSK_Fieldbus.OnNewStatusCSKStyle', 'Fieldbus_OnNewStatusCSKStyle')
Script.serveEvent("CSK_Fieldbus.OnNewStatusLoadParameterOnReboot", "Fieldbus_OnNewStatusLoadParameterOnReboot")
Script.serveEvent("CSK_Fieldbus.OnPersistentDataModuleAvailable", "Fieldbus_OnPersistentDataModuleAvailable")
Script.serveEvent("CSK_Fieldbus.OnNewParameterName", "Fieldbus_OnNewParameterName")
Script.serveEvent("CSK_Fieldbus.OnDataLoadedOnReboot", "Fieldbus_OnDataLoadedOnReboot")

Script.serveEvent('CSK_Fieldbus.OnUserLevelOperatorActive', 'Fieldbus_OnUserLevelOperatorActive')
Script.serveEvent('CSK_Fieldbus.OnUserLevelMaintenanceActive', 'Fieldbus_OnUserLevelMaintenanceActive')
Script.serveEvent('CSK_Fieldbus.OnUserLevelServiceActive', 'Fieldbus_OnUserLevelServiceActive')
Script.serveEvent('CSK_Fieldbus.OnUserLevelAdminActive', 'Fieldbus_OnUserLevelAdminActive')

-- ...

-- ************************ UI Events End **********************************

--[[
--- Some internal code docu for local used function
local function functionName()
  -- Do something

end
]]

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

  -- Script.notifyEvent("Fieldbus_OnNewEvent", false)

  Script.notifyEvent("Fieldbus_OnNewStatusLoadParameterOnReboot", fieldbus_Model.parameterLoadOnReboot)
  Script.notifyEvent("Fieldbus_OnPersistentDataModuleAvailable", fieldbus_Model.persistentModuleAvailable)
  Script.notifyEvent("Fieldbus_OnNewParameterName", fieldbus_Model.parametersName)
  -- ...
end
Timer.register(tmrFieldbus, "OnExpired", handleOnExpiredTmrFieldbus)

-- ********************* UI Setting / Submit Functions Start ********************

local function pageCalled()
  updateUserLevel() -- try to hide user specific content asap
  tmrFieldbus:start()
  return ''
end
Script.serveFunction("CSK_Fieldbus.pageCalled", pageCalled)

local function clearFlowConfigRelevantConfiguration()
  for i = 1, #fieldbus_Instances do
    Script.notifyEvent('Fieldbus_OnNewProcessingParameter', selectedInstance, 'clearAll')
    fieldbus_Instances[selectedInstance].parameters.clientBroadcasts.forwardEvents = {}
    fieldbus_Instances[selectedInstance].parameters.forwardEvents = {}
  end
end
Script.serveFunction('CSK_Fieldbus.clearFlowConfigRelevantConfiguration', clearFlowConfigRelevantConfiguration)

--[[
local function setSomething(value)
  _G.logger:info(nameOfModule .. ": Set new value = " .. value)
  fieldbus_Model.varA = value
end
Script.serveFunction("CSK_Fieldbus.setSomething", setSomething)
]]

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
      -- ...
      -- ...

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

