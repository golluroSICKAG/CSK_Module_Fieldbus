---@diagnostic disable: undefined-global, redundant-parameter, missing-parameter

-- Load all relevant APIs for this module
--**************************************************************************

local availableAPIs = {}

--- Function to load all default APIs
local function loadAPIs()
  CSK_Fieldbus = require 'API.CSK_Fieldbus'

  Log = require 'API.Log'
  Log.Handler = require 'API.Log.Handler'
  Log.SharedLogger = require 'API.Log.SharedLogger'

  Container = require 'API.Container'
  Engine = require 'API.Engine'
  File = require 'API.File'
  Object = require 'API.Object'
  Parameters = require 'API.Parameters'
  Timer = require 'API.Timer'

  -- Check if related CSK modules are available to be used
  local appList = Engine.listApps()
  for i = 1, #appList do
    if appList[i] == 'CSK_Module_PersistentData' then
      CSK_PersistentData = require 'API.CSK_PersistentData'
    elseif appList[i] == 'CSK_Module_UserManagement' then
      CSK_UserManagement = require 'API.CSK_UserManagement'
    elseif appList[i] == 'CSK_Module_FlowConfig' then
      CSK_FlowConfig = require 'API.CSK_FlowConfig'
    end
  end
end

-- Function to load specific APIs
local function loadSpecificAPIs()
  -- If you want to check for specific APIs/functions supported on the device the module is running, place relevant APIs here
  FieldBus = require 'API.FieldBus'
  FieldBus.Config = require 'API.FieldBus.Config'
  FieldBus.Config.EtherNetIP = require 'API.FieldBus.Config.EtherNetIP'
  FieldBus.Config.ProfinetIO = require 'API.FieldBus.Config.ProfinetIO'
  FieldBus.StorageRequest = require 'API.FieldBus.StorageRequest'
end

-- Function to check for SIM2000ST devices
local function checkIsSIM2000ST()
  local deviceName = Engine.getTypeCode()
  local isSIM2000ST = string.find(deviceName, 'SIM2000-3')
  if isSIM2000ST then
    return false
  else
    return true
  end
end

availableAPIs.default = xpcall(loadAPIs, debug.traceback) -- TRUE if all default APIs were loaded correctly
availableAPIs.specific = xpcall(loadSpecificAPIs, debug.traceback) -- TRUE if all specific APIs were loaded correctly
availableAPIs.isSIM2000ST = checkIsSIM2000ST() -- TRUE if device is e.g. of type SIM2000STE / SIM2000STC

return availableAPIs
--**************************************************************************