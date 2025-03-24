--*****************************************************************
-- Here you will find all the required content to provide specific
-- features of this module via the 'CSK FlowConfig'.
--*****************************************************************

require('Communication.Fieldbus.FlowConfig.Fieldbus_OnNewData')
require('Communication.Fieldbus.FlowConfig.Fieldbus_Transmit')

-- Reference to the fieldbus_Instances handle
local fieldbus_Instances

--- Function to react if FlowConfig was updated
local function handleOnClearOldFlow()
  if _G.availableAPIs.default and _G.availableAPIs.specific then
    for i = 1, #fieldbus_Instances do
      if fieldbus_Instances[i].parameters.flowConfigPriority then
        CSK_Fieldbus.clearFlowConfigRelevantConfiguration()
        break
      end
    end
  end
end
Script.register('CSK_FlowConfig.OnClearOldFlow', handleOnClearOldFlow)

--- Function to get access to the fieldbus_Instances
---@param handle handle Handle of fieldbus_Instances object
local function setFieldbus_Instances_Handle(handle)
  fieldbus_Instances = handle
end

return setFieldbus_Instances_Handle