---@diagnostic disable: undefined-global, redundant-parameter, missing-parameter

-- Load all relevant APIs for this module
--**************************************************************************

local availableAPIs = {}

local function loadAPIs()
  CSK_Fieldbus = require 'API.CSK_Fieldbus'

  Container = require 'API.Container'
  Engine = require 'API.Engine'
  File = require 'API.File'
  Log = require 'API.Log'
  Log.Handler = require 'API.Log.Handler'
  Log.SharedLogger = require 'API.Log.SharedLogger'
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

local function loadSpecificAPIs()
  -- If you want to check for specific APIs/functions supported on the device the module is running, place relevant APIs here
  -- e.g.:
  FieldBus = require 'API.FieldBus'
  FieldBus.Config = require 'API.FieldBus.Config'
  FieldBus.Config.EtherNetIP = require 'API.FieldBus.Config.EtherNetIP'
  FieldBus.Config.ProfinetIO = require 'API.FieldBus.Config.ProfinetIO'
  FieldBus.StorageRequest = require 'API.FieldBus.StorageRequest'
end

availableAPIs.default = xpcall(loadAPIs, debug.traceback) -- TRUE if all default APIs were loaded correctly
availableAPIs.specific = xpcall(loadSpecificAPIs, debug.traceback) -- TRUE if all specific APIs were loaded correctly

return availableAPIs
--**************************************************************************