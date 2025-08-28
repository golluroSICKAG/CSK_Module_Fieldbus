-- Block namespace
local BLOCK_NAMESPACE = "Fieldbus_FC.OnNewData"
local nameOfModule = 'CSK_Fieldbus'

--*************************************************************
--*************************************************************

-- Required to keep track of already allocated resource
local instanceTable = {}

local function register(handle, _ , callback)

  Container.remove(handle, "CB_Function")
  Container.add(handle, "CB_Function", callback)

  local function localCallback()
    local mode = Container.get(handle, 'Mode')
    local cbFunction = Container.get(handle,"CB_Function")

    if cbFunction ~= nil then

      -- Check mode
      if mode == 'FULL' then
        Script.callFunction(callback, 'CSK_Fieldbus.OnNewStatusReceivedData')
      elseif mode == 'SELECTION' then
        local name = Container.get(handle, 'DataName')
        Script.callFunction(callback, 'CSK_Fieldbus.OnNewData_' .. tostring(name))
      end

    else
      _G.logger:warning(nameOfModule .. ": " .. BLOCK_NAMESPACE .. ".CB_Function missing!")
    end
  end
  Script.register('CSK_FlowConfig.OnNewFlowConfig', localCallback)

  return true
end
Script.serveFunction(BLOCK_NAMESPACE ..".register", register)

--*************************************************************
--*************************************************************

local function create(mode, dataName)
  local fullInstanceName = tostring(mode)

  if dataName then
    fullInstanceName = fullInstanceName .. tostring(dataName)
  else
    dataName = ''
  end

  -- Check if same instance is already configured
  if nil ~= instanceTable[fullInstanceName] then
    _G.logger:warning(nameOfModule .. ": Expression already in use, please choose another one")
    return nil
  else
    -- Otherwise create handle and store the restriced resource
    local handle = Container.create()
    instanceTable[fullInstanceName] = fullInstanceName
    Container.add(handle, 'Mode', mode)
    Container.add(handle, 'DataName', dataName)
    Container.add(handle, "CB_Function", "")
    return(handle)
  end
end
Script.serveFunction(BLOCK_NAMESPACE .. ".create", create)

--- Function to reset instances if FlowConfig was cleared
local function handleOnClearOldFlow()
  Script.releaseObject(instanceTable)
  instanceTable = {}
end
Script.register('CSK_FlowConfig.OnClearOldFlow', handleOnClearOldFlow)





