---@diagnostic disable: undefined-global, redundant-parameter, missing-parameter
--*****************************************************************
-- Inside of this script, you will find helper functions
--*****************************************************************

--**************************************************************************
--**********************Start Global Scope *********************************
--**************************************************************************

local funcs = {}
-- Providing standard JSON functions
funcs.json = require('Communication/Fieldbus/helper/Json')

--**************************************************************************
--********************** End Global Scope **********************************
--**************************************************************************
--**********************Start Function Scope *******************************
--**************************************************************************

--- Function to create a list with numbers
---@param size int Size of the list
---@return string list List of numbers
local function createStringListBySize(size)
  local list = "["
  if size >= 1 then
    list = list .. '"' .. tostring(1) .. '"'
  end
  if size >= 2 then
    for i=2, size do
      list = list .. ', ' .. '"' .. tostring(i) .. '"'
    end
  end
  list = list .. "]"
  return list
end
funcs.createStringListBySize = createStringListBySize

--- Function to convert a table into a Container object
---@param content auto[] Lua Table to convert to Container
---@return Container cont Created Container
local function convertTable2Container(content)
  local cont = Container.create()
  for key, value in pairs(content) do
    if type(value) == 'table' then
      cont:add(key, convertTable2Container(value), nil)
    else
      cont:add(key, value, nil)
    end
  end
  return cont
end
funcs.convertTable2Container = convertTable2Container

--- Function to convert a Container into a table
---@param cont Container Container to convert to Lua table
---@return auto[] data Created Lua table
local function convertContainer2Table(cont)
  local data = {}
  local containerList = Container.list(cont)
  local containerCheck = false
  if tonumber(containerList[1]) then
    containerCheck = true
  end
  for i=1, #containerList do

    local subContainer

    if containerCheck then
      subContainer = Container.get(cont, tostring(i) .. '.00')
    else
      subContainer = Container.get(cont, containerList[i])
    end
    if type(subContainer) == 'userdata' then
      if Object.getType(subContainer) == "Container" then

        if containerCheck then
          table.insert(data, convertContainer2Table(subContainer))
        else
          data[containerList[i]] = convertContainer2Table(subContainer)
        end

      else
        if containerCheck then
          table.insert(data, subContainer)
        else
          data[containerList[i]] = subContainer
        end
      end
    else
      if containerCheck then
        table.insert(data, subContainer)
      else
        data[containerList[i]] = subContainer
      end
    end
  end
  return data
end
funcs.convertContainer2Table = convertContainer2Table

--- Function to get content list out of table
---@param data string[] Table with data entries
---@return string sortedTable Sorted entries as string, internally seperated by ','
local function createContentList(data)
  local sortedTable = {}
  for key, _ in pairs(data) do
    table.insert(sortedTable, key)
  end
  table.sort(sortedTable)
  return table.concat(sortedTable, ',')
end
funcs.createContentList = createContentList

--- Function to get content list as JSON string
---@param data string[] Table with data entries
---@return string sortedTable Sorted entries as JSON string
local function createJsonList(data)
  local sortedTable = {}
  for key, _ in pairs(data) do
    table.insert(sortedTable, key)
  end
  table.sort(sortedTable)
  return funcs.json.encode(sortedTable)
end
funcs.createJsonList = createJsonList

--- Function to create a list from table
---@param content string[] Table with data entries
---@return string list String list
local function createStringListBySimpleTable(content)
  local list = "["
  if #content >= 1 then
    list = list .. '"' .. content[1] .. '"'
  end
  if #content >= 2 then
    for i=2, #content do
      list = list .. ', ' .. '"' .. content[i] .. '"'
    end
  end
  list = list .. "]"
  return list
end
funcs.createStringListBySimpleTable = createStringListBySimpleTable

local function convertFromBinary(value, format, bigEndian)
  local result
  local endianness = '<' -- little endian per default
  if bigEndian == true then
    endianness = '>'
  end

  if format == 'DOUBLE' then
    result = string.unpack(endianness .. 'd', value)
  elseif format == 'FLOAT' then
    result = string.unpack(endianness .. 'f', value)
  elseif format == 'S_BYTE' then
    result = string.unpack(endianness .. 'b', value)
  elseif format == 'S_INT1' then
    result = string.unpack(endianness .. 'i1', value)
  elseif format == 'S_INT2' then
    result = string.unpack(endianness .. 'i2', value)
  elseif format == 'S_INT4' then
    result = string.unpack(endianness .. 'i4', value)
  elseif format == 'S_INT8' then
    result = string.unpack(endianness .. 'i8', value)
  elseif format == 'S_LONG' then
    result = string.unpack(endianness .. 'l', value)
  elseif format == 'S_SHORT' then
    result = string.unpack(endianness .. 'h', value)
  elseif format == 'U_BYTE' then
    result = string.unpack(endianness .. 'B', value)
  elseif format == 'U_INT1' then
    result = string.unpack(endianness .. 'I1', value)
  elseif format == 'U_INT2' then
    result = string.unpack(endianness .. 'I2', value)
  elseif format == 'U_INT4' then
    result = string.unpack(endianness .. 'I4', value)
  elseif format == 'U_INT8' then
    result = string.unpack(endianness .. 'I8', value)
  elseif format == 'U_LONG' then
    result = string.unpack(endianness .. 'L', value)
  elseif format == 'U_SHORT' then
    result = string.unpack(endianness .. 'H', value)
  end
  return result
end
funcs.convertFromBinary = convertFromBinary

local function convertToBinary(value, format, bigEndian)
  local result
  local endianness = '<' -- little endian per default
  if bigEndian == true then
    endianness = '>'
  end

  if format == 'DOUBLE' then
    result = string.pack(endianness .. 'd', value)
  elseif format == 'FLOAT' then
    result = string.pack(endianness .. 'f', value)
  elseif format == 'S_BYTE' then
    result = string.pack(endianness .. 'b', value)
  elseif format == 'S_INT1' then
    result = string.pack(endianness .. 'i1', value)
  elseif format == 'S_INT2' then
    result = string.pack(endianness .. 'i2', value)
  elseif format == 'S_INT4' then
    result = string.pack(endianness .. 'i4', value)
  elseif format == 'S_INT8' then
    result = string.pack(endianness .. 'i8', value)
  elseif format == 'S_LONG' then
    result = string.pack(endianness .. 'l', value)
  elseif format == 'S_SHORT' then
    result = string.pack(endianness .. 'h', value)
  elseif format == 'U_BYTE' then
    result = string.pack(endianness .. 'B', value)
  elseif format == 'U_INT1' then
    result = string.pack(endianness .. 'I1', value)
  elseif format == 'U_INT2' then
    result = string.pack(endianness .. 'I2', value)
  elseif format == 'U_INT4' then
    result = string.pack(endianness .. 'I4', value)
  elseif format == 'U_INT8' then
    result = string.pack(endianness .. 'I8', value)
  elseif format == 'U_LONG' then
    result = string.pack(endianness .. 'L', value)
  elseif format == 'U_SHORT' then
    result = string.pack(endianness .. 'H', value)
  end
  return result
end
funcs.convertToBinary = convertToBinary

local function getEmptyBinaryContent(format)
  local result

  if format == 'DOUBLE' then
    result = string.pack('d', 0)
  elseif format == 'FLOAT' then
    result = string.pack('f', 0)
  elseif format == 'S_BYTE' then
    result = string.pack('b', 0)
  elseif format == 'S_INT1' then
    result = string.pack('i1', 0)
  elseif format == 'S_INT2' then
    result = string.pack('i2', 0)
  elseif format == 'S_INT4' then
    result = string.pack('i4', 0)
  elseif format == 'S_INT8' then
    result = string.pack('i8', 0)
  elseif format == 'S_LONG' then
    result = string.pack('l', 0)
  elseif format == 'S_SHORT' then
    result = string.pack('h', 0)
  elseif format == 'U_BYTE' then
    result = string.pack('B', 0)
  elseif format == 'U_INT1' then
    result = string.pack('I1', 0)
  elseif format == 'U_INT2' then
    result = string.pack('I2', 0)
  elseif format == 'U_INT4' then
    result = string.pack('I4', 0)
  elseif format == 'U_INT8' then
    result = string.pack('I8', 0)
  elseif format == 'U_LONG' then
    result = string.pack('L', 0)
  elseif format == 'U_SHORT' then
    result = string.pack('H', 0)
  end

  return result
end
funcs.getEmptyBinaryContent = getEmptyBinaryContent

--- Function to create a json string out of data transmission entries
---@param dataName string[] Table with names of data entries
---@param registerEvent string[] Table with names of registered events of data entries
---@param dataType string[] Table with data types of data entries
---@param convertData string[] Table with info if data needs to be converted
---@param bigEndian string[] Table with info about endianness of data entries
---@param values string[] Table with values to transmit
---@param selectedParam string Currently selected parameter
---@return string jsonstring JSON string
local function createJsonListTransmissionData(dataName, registerEvent, dataType, convertData, bigEndian, values, selectedParam)

  local list = {}
  if dataName == nil then
    list = {{DTC_IDTransmit = '-', DTC_NameTransmit = '-', DTC_EventTransmit = '-', DTC_DataTypeTransmit = '-', DTC_ConvertTransmit = '-', DTC_BigEndianTransmit = '-', DTC_ValueTransmit = '-'},}
  else

    for key, value in ipairs(dataName) do
      local isSelected = false
      if tostring(key) == selectedParam then
        isSelected = true
      end
      table.insert(list, {DTC_IDTransmit = tostring(key), DTC_NameTransmit = value, DTC_EventTransmit = registerEvent[value], DTC_DataTypeTransmit = dataType[value], DTC_ConvertTransmit = convertData[value], DTC_BigEndianTransmit = bigEndian[value], DTC_ValueTransmit = tostring(values[key]), selected = isSelected})
    end

    if #list == 0 then
      list = {{DTC_IDTransmit = '-', DTC_NameTransmit = '-', DTC_EventTransmit = '-', DTC_DataTypeTransmit = '-', DTC_ConvertTransmit = '-', DTC_BigEndianTransmit = '-', DTC_ValueTransmit = '-'},}
    end
  end

  local jsonstring = funcs.json.encode(list)
  return jsonstring
end
funcs.createJsonListTransmissionData = createJsonListTransmissionData

--- Function to create a json string out of data receive entries
---@param dataName string[] Table with names of data entries
---@param dataType string[] Table with data types of data entries
---@param convertData string[] Table with info if data needs to be converted
---@param bigEndian string[] Table with info about endianness of data entries
---@param values string[] Table with received values
---@param selectedParam string Currently selected parameter
---@return string jsonstring JSON string
local function createJsonListReceiveData(dataName, dataType, convertData, bigEndian, values, selectedParam)

  local list = {}
  if dataName == nil then
    list = {{DTC_IDReceive = '-', DTC_NameReceive = '-', DTC_DataTypeReceive = '-', DTC_ConvertReceive = '-', DTC_BigEndianReceive = '-', DTC_ValueReceive = '-'},}
  else

    for key, value in ipairs(dataName) do
      local isSelected = false
      if tostring(key) == selectedParam then
        isSelected = true
      end
      table.insert(list, {DTC_IDReceive = tostring(key), DTC_NameReceive = value,  DTC_DataTypeReceive = dataType[value], DTC_ConvertReceive = convertData[value], DTC_BigEndianReceive = bigEndian[value], DTC_ValueReceive = tostring(values[value]), selected = isSelected})
    end

    if #list == 0 then
      list = {{DTC_IDReceive = '-', DTC_NameReceive = '-', DTC_DataTypeReceive = '-', DTC_ConvertReceive = '-', DTC_BigEndianReceive = '-', DTC_ValueReceive = '-'},}
    end
  end

  local jsonstring = funcs.json.encode(list)
  return jsonstring
end
funcs.createJsonListReceiveData = createJsonListReceiveData

--TODO docu
local function toBits(num)
  local res = ''
  local allValues = {false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false}
  for i = 16, 1, -1 do
    local temp = math.fmod(num, 2)
    if temp == 1 then
      allValues[(16+1)-i] = true
    end
    num = math.floor((num - temp)/2)
  end
  if num == 0 then return allValues else return nil end
end
funcs.toBits = toBits

--TODO docu
local function toNumber(values)
  local result = 0
  for key, value in ipairs(values) do
    if value == true then
      result = result + 2^(key -1)
    end
  end
  return result
end
funcs.toNumber = toNumber

local function getDataSize(data)
  local size = 0
  for key, value in pairs(data) do
    if value == 'DOUBLE' then
      size = size + 8
    elseif value == 'FLOAT' then
      size = size + 4
    elseif value == 'S_BYTE' then
      size = size + 1
    elseif value == 'S_INT1' then
      size = size + 1
    elseif value == 'S_INT2' then
      size = size + 2
    elseif value == 'S_INT4' then
      size = size + 4
    elseif value == 'S_INT8' then
      size = size + 8
    elseif value == 'S_LONG' then
      size = size + 4
    elseif value == 'S_SHORT' then
      size = size + 2
    elseif value == 'U_BYTE' then
      size = size + 1
    elseif value == 'U_INT1' then
      size = size + 1
    elseif value == 'U_INT2' then
      size = size + 2
    elseif value == 'U_INT4' then
      size = size + 4
    elseif value == 'U_INT8' then
      size = size + 8
    elseif value == 'U_LONG' then
      size = size + 4
    elseif value == 'U_SHORT' then
      size = size + 2
    end
  end
  return size
end
funcs.getDataSize = getDataSize

local function getTypeSize(dataType)
  if dataType == 'DOUBLE' then
    return 8
  elseif dataType == 'FLOAT' then
    return 4
  elseif dataType == 'S_BYTE' then
    return 1
  elseif dataType == 'S_INT1' then
    return 1
  elseif dataType == 'S_INT2' then
    return 2
  elseif dataType == 'S_INT4' then
    return 4
  elseif dataType == 'S_INT8' then
    return 8
  elseif dataType == 'S_LONG' then
    return 4
  elseif dataType == 'S_SHORT' then
    return 2
  elseif dataType == 'U_BYTE' then
    return 1
  elseif dataType == 'U_INT1' then
    return 1
  elseif dataType == 'U_INT2' then
    return 2
  elseif dataType == 'U_INT4' then
    return 4
  elseif dataType == 'U_INT8' then
    return 8
  elseif dataType == 'U_LONG' then
    return 4
  elseif dataType == 'U_SHORT' then
    return 2
  else
    return nil
  end
end
funcs.getTypeSize = getTypeSize

return funcs

--**************************************************************************
--**********************End Function Scope *********************************
--**************************************************************************