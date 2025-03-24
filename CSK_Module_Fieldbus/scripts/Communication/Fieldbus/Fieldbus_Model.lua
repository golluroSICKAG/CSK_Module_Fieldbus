---@diagnostic disable: undefined-global, redundant-parameter, missing-parameter
--*****************************************************************
-- Inside of this script, you will find the module definition
-- including its parameters and functions
--*****************************************************************

--**************************************************************************
--**********************Start Global Scope *********************************
--**************************************************************************
local nameOfModule = 'CSK_Fieldbus'

local fieldbus_Model = {}

-- Check if CSK_UserManagement module can be used if wanted
fieldbus_Model.userManagementModuleAvailable = CSK_UserManagement ~= nil or false

-- Check if CSK_PersistentData module can be used if wanted
fieldbus_Model.persistentModuleAvailable = CSK_PersistentData ~= nil or false

-- Default values for persistent data
-- If available, following values will be updated from data of CSK_PersistentData module (check CSK_PersistentData module for this)
fieldbus_Model.parametersName = 'CSK_Fieldbus_Parameter' -- name of parameter dataset to be used for this module
fieldbus_Model.parameterLoadOnReboot = false -- Status if parameter dataset should be loaded on app/device reboot

-- Load script to communicate with the Fieldbus_Model interface and give access
-- to the Fieldbus_Model object.
-- Check / edit this script to see/edit functions which communicate with the UI
local setFieldbus_ModelHandle = require('Communication/Fieldbus/Fieldbus_Controller')
setFieldbus_ModelHandle(fieldbus_Model)

--Loading helper functions if needed
fieldbus_Model.helperFuncs = require('Communication/Fieldbus/helper/funcs')

-- Create parameters / instances for this module
fieldbus_Model.isConnected = false
fieldbus_Model.reconnectionTimer = Timer.create()
fieldbus_Model.reconnectionTimer:setExpirationTime(5000)
fieldbus_Model.reconnectionTimer:setPeriodic(false)
fieldbus_Model.mode = 'RAW'

-- Optionally check if specific API was loaded via
if _G.availableAPIs.specific == true then
  if (fieldbus_Model.mode == 'RAW' ) then
      fieldbus_Model.fieldbus = FieldBus.create('EXPLICIT_OPEN')
      fieldbus_Model.fieldbus:setMode('RAW')
      fieldbus_Model.fieldbus:open()
  end
end

fieldbus_Model.key = '1234567890123456' -- key to encrypt passwords, should be adapted!

fieldbus_Model.messageLog = {} -- keep the latest 100 received messages

fieldbus_Model.styleForUI = 'None' -- Optional parameter to set UI style
fieldbus_Model.version = Engine.getCurrentAppVersion() -- Version of module

-- Parameters to be saved permanently if wanted
fieldbus_Model.parameters = {}
fieldbus_Model.parameters.flowConfigPriority = CSK_FlowConfig ~= nil or false -- Status if FlowConfig should have priority for FlowConfig relevant configurations

fieldbus_Model.parameters.connect = true -- Config if connection should be active
fieldbus_Model.parameters.fieldbusIP = '136.129.5.1' -- IP of the MQTT broker
fieldbus_Model.parameters.connectionTimeout = 5000 -- The timeout to wait initially until the client gets 


-- List of events to register to and forward content to PLC
fieldbus_Model.parameters.forwardEvents = {}

fieldbus_Model.parameters.useCredentials = true -- Enables/disables to use user credentials
fieldbus_Model.parameters.username = 'user' -- Username if using user credentials
if _G.availableAPIs.specific == true then
  fieldbus_Model.parameters.password = Cipher.AES.encrypt('password', fieldbus_Model.key) -- Password if using user credentials
end

--fieldbus_Model.parameters.paramA = 'paramA' -- Short docu of variable
--fieldbus_Model.parameters.paramB = 123 -- Short docu of variable
--...

--**************************************************************************
--********************** End Global Scope **********************************
--**************************************************************************
--**********************Start Function Scope *******************************
--**************************************************************************

--[[
-- Some internal code docu for local used function to do something
---@param content auto Some info text if function is not already served
local function doSomething(content)
  _G.logger:info(nameOfModule .. ": Do something")
  fieldbus_Model.counter = fieldbus_Model.counter + 1
end
fieldbus_Model.doSomething = doSomething
]]

--- Function to react on UI style change
local function handleOnStyleChanged(theme)
  fieldbus_Model.styleForUI = theme
  Script.notifyEvent("Fieldbus_OnNewStatusCSKStyle", fieldbus_Model.styleForUI)
end
Script.register('CSK_PersistentData.OnNewStatusCSKStyle', handleOnStyleChanged)


--- Function to create and notify internal Fieldbus log messages
local function sendLog()
  local tempLog2Send = ''
  for i=#fieldbus_Model.messageLog, 1, -1 do
    tempLog2Send = tempLog2Send .. fieldbus_Model.messageLog[i] .. '\n'
  end
  Script.notifyEvent('Fieldbus_OnNewLog', tempLog2Send)
end
fieldbus_Model.sendLog = sendLog

--- Function to add new message to internal Fieldbus log messages
---@param msg string Message
local function addMessageLog(msg)
  table.insert(fieldbus_Model.messageLog, 1, DateTime.getTime() .. ': ' .. msg)
  if #fieldbus_Model.messageLog == 100 then
    table.remove(fieldbus_Model.messageLog, 100)
  end
  sendLog()
end
fieldbus_Model.addMessageLog = addMessageLog

--@setEthIP_Out(bit:int, value:Bool)
local function setEthIP_Out(bit, value)
  if bit < 16 and bit >= 0 then
    local bitWrite = 0
    if value then
      bitWrite = 65535
    end
    local bitMask = 2 ^ bit
    FieldBus.writeControlBitsIn(fieldbus_Model.fieldbus, bitWrite, bitMask)
  else
    print("Warning: invalid bit chosen, doesn't exit")
  end

  local function toBits(num, bits)
    -- returns a table of bits, least significant first.
    local t={} -- will contain the bits
    bits = bits or 8
    local rest
    while num > 0 do
        rest = math.fmod(num,2)
        t[#t+1] = rest
        num = math.floor((num - rest) / 2)
    end
    for i = #t + 1, bits do -- fill empty bits with 0
        t[i] = 0
    end
    return t
  end

  local tempFieldBusBitsIn = FieldBus.readControlBitsIn(fieldbus_Model.fieldbus)
  local bitTable = toBits(tempFieldBusBitsIn, 16)
  for i = 1, #bitTable//2, 1 do
    bitTable[i], bitTable[#bitTable - i + 1] = bitTable[#bitTable - i + 1], bitTable[i]
  end
  local reversedBTable =  table.concat(bitTable) --[AR]
  Script.notifyEvent("GuiUpdateCtrlBitOutput", bitTable)
  _g_log('FINER', "setEthIP_Out: Bit ".. bit .. tostring(value) .."Value" .. DateTime.getDateTime(), '000')

end

--@newControlBitsOut(value:int)
local function newControlBitsOut(value)
  _g_log('FINER', "Control bits in from PLC: " .. value .. DateTime.getDateTime(), '000')
  for i = 0, 15 do
    if value >= 2 ^ (15 - i) then
      value = value - (2 ^ (15 - i))

      if not ethIP_InBits[16 - i] and #ethIP_In_FunUP >= (16 - i) then
        Script.notifyEvent(ethIP_In_FunUP[16 - i])
      end

      ethIP_InBits[16 - i] = true
    else
      if ethIP_InBits[16 - i] and #ethIP_In_FunDOWN >= (16 - i) then
        Script.notifyEvent(ethIP_In_FunDOWN[16 - i])
      end

      ethIP_InBits[16 - i] = false
    end
  end
  --local ctrlBitOutStr = string.format("%02X %02X", value&0x00FF, value>>8)
  --print ("Ctrl.Bits from PLC: " .. ctrlBitOutStr)
    local bitTable = FieldBusSettings.toBits(value, 16)
    local reversedBTable = table.concat(FieldBusSettings.reverse(bitTable))
  Script.notifyEvent("GuiUpdateCtrlBitInput", reversedBTable)
end
--This event is thrown when the control bits set by the PLC have changed.
if _G.availableAPIs.default and _G.availableAPIs.specific == true then
  FieldBus.register(fieldbus_Model.fieldbus, 'OnControlBitsOutChanged', newControlBitsOut)
end

--- 
---@param ctrlBits int Control bits set by the PLC have changed
local function handleOnControlBitsOutChanged(ctrlBits)
  -- TODO: Insert your event handling code here.
end
--This event is thrown when the control bits set by the PLC have changed.
if _G.availableAPIs.default and _G.availableAPIs.specific == true then
  FieldBus.register(fieldbus_Model.fieldbus, 'OnControlBitsOutChanged', handleOnControlBitsOutChanged)
end

--- 
---@param size int New size of the fieldbus input frame buffer.
local function handleOnInputSizeChanged(size)
  -- TODO: Insert your event handling code here.
end
--This event is thrown when the size of the FieldBus input frame buffer changes.
if _G.availableAPIs.default and _G.availableAPIs.specific == true then
  FieldBus.register(fieldbus_Model.fieldbus, 'OnInputSizeChanged', handleOnInputSizeChanged)
end

--- 
---@param data binary New data from the PLC
local function handleOnNewData(data)
  local message = {string.unpack(FieldBusSettings.inputFormat, data)}
  Script.notifyEvent('incomingData', message)
  local datahex = FieldBusSettings.hexDumpBinData(data)
  Script.notifyEvent('GuiUpdateDataInPut', datahex)
  print (data)
  print (datahex)
end
--This event is thrown when new data has been received from the PLC through the field bus.
if _G.availableAPIs.default and _G.availableAPIs.specific == true then
  FieldBus.register(fieldbus_Model.fieldbus, 'OnNewData', handleOnNewData)
end

--- 
---@param size int New size of the fieldbus output frame buffer.
local function handleOnOutputSizeChanged(size)
  -- TODO: Insert your event handling code here.
end
--This event is thrown when the control bits set by the PLC have changed.
if _G.availableAPIs.default and _G.availableAPIs.specific == true then
  FieldBus.register(fieldbus_Model.fieldbus, 'OnOutputSizeChanged', handleOnOutputSizeChanged)
end

--- 
---@param status FieldBus.Status New state of the fieldbus communication.
local function handleOnStatusChanged(status)
  _G.logger:info("FieldBus: OnStatusChanged event received, new status: " .. status)
  Script.notifyEvent("onStatusChange", status)
  if (status== "ONLINE") then
    _G.logger:info(nameOfModule .. ": Connected to PLC.")
    Script.notifyEvent('FieldBus_OnNewConnectionStatus', "Connected to PLC")
    addMessageLog('Connected to PLC.')
    fieldbus_Model.reconnectionTimer:stop()
    fieldbus_Model.isConnected = true
    Script.notifyEvent("FieldBus_OnNewStatusCurrentlyConnected", fieldbus_Model.isConnected)
  elseif (status== "OFFLINE") then
    fieldbus_Model.isConnected = false
  end
  setEthIP_Out(0, fieldbus_Model.isConnected)
end
--This event is thrown when the state of the FieldBus communication changes.
if _G.availableAPIs.default and _G.availableAPIs.specific == true then
  FieldBus.register(fieldbus_Model.fieldbus, "OnStatusChanged", handleOnStatusChanged)
end


--*************************************************************************
--********************** End Function Scope *******************************
--*************************************************************************

return fieldbus_Model
