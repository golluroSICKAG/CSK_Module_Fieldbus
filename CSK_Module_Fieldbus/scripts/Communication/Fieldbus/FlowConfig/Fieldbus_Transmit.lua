-- Block namespace
local BLOCK_NAMESPACE = 'Fieldbus_FC.Transmit'
local nameOfModule = 'CSK_Fieldbus'

--*************************************************************
--*************************************************************

-- Required to keep track of already allocated resource
local instanceTable = {}

local function transmit(handle, source)

  local dataName = Container.get(handle, 'DataName')
  local success = CSK_Fieldbus.selectDataTransmit(dataName)
  if success then
    CSK_Fieldbus.setRegisteredEventTransmit(source)
    CSK_Fieldbus.addDataToTransmitViaUI()
  else
    CSK_Fieldbus.setDataNameTransmit(dataName)
    CSK_Fieldbus.setRegisteredEventTransmit(source)
    CSK_Fieldbus.addDataToTransmitViaUI()
  end

end
Script.serveFunction(BLOCK_NAMESPACE .. '.transmit', transmit)

--*************************************************************
--*************************************************************

local function create(dataName)

  -- Check if same instance is already configured
  if nil ~= instanceTable[dataName] then
    _G.logger:warning(nameOfModule .. ": Instance already in use, please choose another one")
    return nil
  else
    -- Otherwise create handle and store the restriced resource
    local handle = Container.create()
    instanceTable[dataName] = dataName
    Container.add(handle, 'DataName', dataName)
    --Container.add(handle, 'ConvertData', convertData)
    --Container.add(handle, 'BigEndian', bigEndian)
    --Container.add(handle, 'DataType', dataType)
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