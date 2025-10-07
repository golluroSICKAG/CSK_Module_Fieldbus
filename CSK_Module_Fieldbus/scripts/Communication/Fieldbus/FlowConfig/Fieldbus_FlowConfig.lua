--*****************************************************************
-- Here you will find all the required content to provide specific
-- features of this module via the 'CSK FlowConfig'.
--*****************************************************************

require('Communication.Fieldbus.FlowConfig.Fieldbus_OnNewControlBitsIn')
require('Communication.Fieldbus.FlowConfig.Fieldbus_OnNewData')
require('Communication.Fieldbus.FlowConfig.Fieldbus_Transmit')
require('Communication.Fieldbus.FlowConfig.Fieldbus_WriteControlBitsIn')

--- Function to react if FlowConfig was updated
local function handleOnClearOldFlow()
  if _G.availableAPIs.default and _G.availableAPIs.specific then
    if fieldbus_Model.parameters.flowConfigPriority then
      CSK_Fieldbus.clearFlowConfigRelevantConfiguration()
    end
  end
end
Script.register('CSK_FlowConfig.OnClearOldFlow', handleOnClearOldFlow)