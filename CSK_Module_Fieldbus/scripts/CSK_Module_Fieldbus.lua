--MIT License
--
--Copyright (c) 2023 SICK AG
--
--Permission is hereby granted, free of charge, to any person obtaining a copy
--of this software and associated documentation files (the "Software"), to deal
--in the Software without restriction, including without limitation the rights
--to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--copies of the Software, and to permit persons to whom the Software is
--furnished to do so, subject to the following conditions:
--
--The above copyright notice and this permission notice shall be included in all
--copies or substantial portions of the Software.
--
--THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
--SOFTWARE.

---@diagnostic disable: undefined-global, redundant-parameter, missing-parameter

--**************************************************************************
--**********************Start Global Scope *********************************
--**************************************************************************

-- If app property "LuaLoadAllEngineAPI" is FALSE, use this to load and check for required APIs
-- This can improve performance of garbage collection
_G.availableAPIs = require('Communication/Fieldbus/helper/checkAPIs') -- can be used to adjust function scope of the module related on available APIs of the device
-----------------------------------------------------------
-- Logger
_G.logger = Log.SharedLogger.create('ModuleLogger')
_G.logHandle = Log.Handler.create()
_G.logHandle:attachToSharedLogger('ModuleLogger')
_G.logHandle:setConsoleSinkEnabled(false) --> Set to TRUE if CSK_Logger module is not used
_G.logHandle:setLevel("ALL")
_G.logHandle:applyConfig()
-----------------------------------------------------------

-- Loading script regarding Fieldbus_Model
-- Check this script regarding Fieldbus_Model parameters and functions
_G.fieldbus_Model = require('Communication/Fieldbus/Fieldbus_Model') --AR - sometimes this is local scope ie MultiTCPIPServer?

local fieldbus_Instances = {} -- Handle all instances

-- Load script to communicate with the fieldbus_Model UI
-- Check / edit this script to see/edit functions which communicate with the UI
local fieldbusController = require('Communication/Fieldbus/Fieldbus_Controller')

if _G.availableAPIs.default and _G.availableAPIs.specific then
  local setInstanceHandle = require('Communication/Fieldbus/FlowConfig/Fieldbus_FlowConfig')
  table.insert(fieldbus_Instances, fieldbus_Model.create(1)) --AR -- Create at least 1 instance
  fieldbusController.setFieldbus_Instances_Handle(fieldbus_Instances) -- share handle of instances
  setInstanceHandle(fieldbus_Instances)
else
  _G.logger:warning("CSK_Fieldbus: Relevant CROWN(s) not available on device. Module is not supported...")
end

--**************************************************************************
--**********************End Global Scope ***********************************
--**************************************************************************
--**********************Start Function Scope *******************************
--**************************************************************************

--- Function to react on startup event of the app
local function main()

  ----------------------------------------------------------------------------------------
  -- INFO: Please check if module will eventually load inital configuration triggered via
  --       event CSK_PersistentData.OnInitialDataLoaded
  --       (see internal variable _G.fieldbus_Model.parameterLoadOnReboot)
  --       If so, the app will trigger the "OnDataLoadedOnReboot" event if ready after loading parameters
  --
  -- Can be used e.g. like this
  ----------------------------------------------------------------------------------------

  -- _G.fieldbus_Model.doSomething() -- if you want to start a function
  -- ...
  fieldbusController.setFieldbus_Model_Handle(Fieldbus_Model)

  CSK_Fieldbus.pageCalled() -- Update UI

end
Script.register("Engine.OnStarted", main)

--OR

-- Call function after persistent data was loaded
--Script.register("CSK_Fieldbus.OnDataLoadedOnReboot", main)

--**************************************************************************
--**********************End Function Scope *********************************
--**************************************************************************
