-- Block namespace
local BLOCK_NAMESPACE = 'Fieldbus_FC.WriteControlBitsIn'
local nameOfModule = 'CSK_Fieldbus'

--*************************************************************
--*************************************************************

-- Required to keep track of already allocated resource
local instanceTable = {}

local function writeControlBitsIn(handle, source)
  CSK_Fieldbus.setEventToRegisterControlBitsIn(source)
end
Script.serveFunction(BLOCK_NAMESPACE .. '.writeControlBitsIn', writeControlBitsIn)

--*************************************************************
--*************************************************************

local function create()

  if nil ~= instanceTable['Solo'] then
    _G.logger:warning(nameOfModule .. ": Instance already in use, please choose another one")
    return nil
  else
    -- Otherwise create handle and store the restriced resource
    local handle = Container.create()
    instanceTable['Solo'] = 'Solo'

    return handle
  end
end
Script.serveFunction(BLOCK_NAMESPACE .. '.create', create)

--- Function to reset instances if FlowConfig was cleared
local function handleOnClearOldFlow()
  Script.releaseObject(instanceTable)
  instanceTable = {}
end
Script.register('CSK_FlowConfig.OnClearOldFlow', handleOnClearOldFlow)