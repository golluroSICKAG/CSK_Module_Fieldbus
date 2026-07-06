---@diagnostic disable: undefined-global, redundant-parameter, missing-parameter
--*****************************************************************
-- Inside of this script, you will find helper functions
--*****************************************************************

--**************************************************************************
--**********************Start Global Scope *********************************
--**************************************************************************

local nameOfModule = 'CSK_Fieldbus'

local funcs = {}
-- Providing standard JSON functions
funcs.json = require('Communication/Fieldbus/helper/Json')
funcs.defaultParameters = require('Communication/Fieldbus/Fieldbus_Parameters')

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

--- Function to convert value out of binary string
---@param value binary Binary string
---@param format string Format the value is packed
---@param bigEndian bool Status if big endian is used. Otherwise little endian is active
---@return auto result Converted value
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
  elseif format == 'CHAR' then
    result = string.unpack(endianness .. 'c1', value)
  --elseif format == 'STRING' then
    --result = string.unpack(endianness .. 'c14xx', value)
    --result = string.unpack(endianness .. 's2', value)
  end
  return result
end
funcs.convertFromBinary = convertFromBinary

--- Function to convert value to binary string
---@param value auto Value to convert
---@param format string Format the value is packed
---@param bigEndian bool Status if big endian is used. Otherwise little endian is active
---@return binary result Converted value
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
  elseif format == 'CHAR' then
    if #value >= 2 then
      value = string.sub(value, 1, 1)
    end
    result = string.pack(endianness .. 'c1', value)
  --elseif format == 'STRING' then
  --  if #value >= 15 then
  --    value = string.sub(value, 1, 14)
  --  end
  --  result = string.pack(endianness .. 's2', value)
  end
  return result
end
funcs.convertToBinary = convertToBinary

--- Function to create binary string with size of related format and value '0'
---@param format string Format the value is packed
---@return binary result Empty value
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
  elseif format == 'CHAR' then
    result = string.pack('x', '')
  --elseif format == 'STRING' then
  --  result = string.pack('s2', '')
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
    list = {{DTC_IDTransmit = '-', DTC_NameTransmit = '-', DTC_EventTransmit = '-', DTC_ConvertTransmit = '-', DTC_DataTypeTransmit = '-', DTC_BigEndianTransmit = '-', DTC_ValueTransmit = '-'},}
  else

    for key, value in ipairs(dataName) do
      local isSelected = false
      if tostring(key) == selectedParam then
        isSelected = true
      end
      if convertData[value] == true then
        table.insert(list, {DTC_IDTransmit = tostring(key), DTC_NameTransmit = value, DTC_EventTransmit = registerEvent[value], DTC_ConvertTransmit = convertData[value], DTC_DataTypeTransmit = dataType[value], DTC_BigEndianTransmit = bigEndian[value], DTC_ValueTransmit = tostring(values[key]), selected = isSelected})
      else
        table.insert(list, {DTC_IDTransmit = tostring(key), DTC_NameTransmit = value, DTC_EventTransmit = registerEvent[value], DTC_ConvertTransmit = convertData[value], DTC_DataTypeTransmit = dataType[value], DTC_BigEndianTransmit = '-', DTC_ValueTransmit = tostring(values[key]), selected = isSelected})
      end
    end

    if #list == 0 then
      list = {{DTC_IDTransmit = '-', DTC_NameTransmit = '-', DTC_EventTransmit = '-', DTC_ConvertTransmit = '-', DTC_DataTypeTransmit = '-', DTC_BigEndianTransmit = '-', DTC_ValueTransmit = '-'},}
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
    list = {{DTC_IDReceive = '-', DTC_NameReceive = '-', DTC_ConvertReceive = '-', DTC_DataTypeReceive = '-', DTC_BigEndianReceive = '-', DTC_ValueReceive = '-'},}
  else

    for key, value in ipairs(dataName) do
      local isSelected = false
      if tostring(key) == selectedParam then
        isSelected = true
      end
      if convertData[value] == true then
        table.insert(list, {DTC_IDReceive = tostring(key), DTC_NameReceive = value, DTC_ConvertReceive = convertData[value],  DTC_DataTypeReceive = dataType[value], DTC_BigEndianReceive = bigEndian[value], DTC_ValueReceive = tostring(values[value]), selected = isSelected})
      else
        table.insert(list, {DTC_IDReceive = tostring(key), DTC_NameReceive = value, DTC_ConvertReceive = convertData[value],  DTC_DataTypeReceive = dataType[value], DTC_BigEndianReceive = '-', DTC_ValueReceive = tostring(values[value]), selected = isSelected})
      end
    end

    if #list == 0 then
      list = {{DTC_IDReceive = '-', DTC_NameReceive = '-', DTC_ConvertReceive = '-', DTC_DataTypeReceive = '-', DTC_BigEndianReceive = '-', DTC_ValueReceive = '-'},}
    end
  end

  local jsonstring = funcs.json.encode(list)
  return jsonstring
end
funcs.createJsonListReceiveData = createJsonListReceiveData

--- Function to convert number to related bit table
---@param num int Number to convert
---@return bool[]? allValues Table of boolean values per bit
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
  if num == 0 then
    return allValues
  else
    return nil
  end
end
funcs.toBits = toBits

--- Function to convert bit values to related number
---@param values bool[]? Bit structure to convert
---@return int result Number
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

--- Function to get info about the total data size
---@param data string[] Table with info about data types to use
---@return int size Sum of all bytes of data types
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
    elseif value == 'CHAR' then
      size = size + 1
    elseif value == 'RAW' then
      size = 0
      break
    --elseif value == 'STRING' then
    --  size = size + 16
    end
  end
  return size
end
funcs.getDataSize = getDataSize

--- Function to get info about the data size of a specific data type
---@param dataType string Data type to use
---@return int? result Amount of bytes of data type
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
  elseif dataType == 'CHAR' then
    return 1
  --elseif dataType == 'STRING' then
  --  return 16
  else
    return nil
  end
end
funcs.getTypeSize = getTypeSize

local function addTabs(str, tab)
  if tab > 0 then
    for _=1, tab do
      str = '\t' .. str
    end
  end
  return str
end
local function min(arr)
  if #arr == 0 then
    return nil
  end
  table.sort(arr)
  return arr[1]
end

local function jsonLine2Table(intiStr, startInd, tab, resStr)
  if not intiStr then return '' end
  if not startInd then startInd = 1 end
  if not tab then tab = 0 end
  if not resStr then resStr = '' end
  local compArray = {}
  local nextSqBrOp = string.find(intiStr, '%[', startInd)
  if nextSqBrOp then table.insert(compArray, nextSqBrOp) end
  local nextSqBrCl = string.find(intiStr, '%]', startInd)
  if nextSqBrCl then table.insert(compArray, nextSqBrCl) end
  local nextCuBrCl = string.find(intiStr, '}', startInd)
  if nextCuBrCl then table.insert(compArray, nextCuBrCl) end
  local nextCuBrOp = string.find(intiStr, '{', startInd)
  if nextCuBrOp then table.insert(compArray, nextCuBrOp) end
  local nextComma = string.find(intiStr, ',', startInd)
  if nextComma then table.insert(compArray, nextComma) end
  local minVal = min(compArray)
  if minVal then
    local currentSymbol = string.sub(intiStr, minVal, minVal)
    local content = ''
    if startInd < minVal then
      content = string.sub(intiStr, startInd, minVal-1)
    end
    if minVal == nextCuBrOp or minVal == nextSqBrOp then
      resStr = resStr .. addTabs(content .. currentSymbol .. '\n', tab)
      tab = tab + 1

    elseif minVal == nextCuBrCl or minVal == nextSqBrCl then
      resStr = resStr .. addTabs(content, tab) .. '\n' 
      tab = tab - 1
      resStr = resStr .. addTabs(currentSymbol, tab)
    elseif nextComma and minVal == nextComma then
      if content == '' then
        resStr = resStr.. currentSymbol .. '\n'
      else
        resStr = resStr .. addTabs(content .. currentSymbol .. '\n', tab)
      end
    end
    resStr = jsonLine2Table(intiStr, minVal+1, tab, resStr)
  end
  return resStr
end
funcs.jsonLine2Table = jsonLine2Table

--- Function to compare table content. Optionally will fill missing values within content table with values of defaultTable
---@param content auto Data to check
---@param defaultTable auto Reference data
---@return auto[] content Update of data
local function checkParameters(content, defaultTable)
  for key, value in pairs(defaultTable) do
    if type(value) == 'table' then
      if content[key] == nil then
        _G.logger:info(nameOfModule .. ": Created missing parameters table '" .. tostring(key) .. "'")
        content[key] = {}
      end
      content[key] = checkParameters(content[key], defaultTable[key])
    elseif content[key] == nil then
      _G.logger:info(nameOfModule .. ": Missing parameter '" .. tostring(key) .. "'. Adding default value '" .. tostring(defaultTable[key]) .. "'")
      content[key] = defaultTable[key]
    end
  end
  return content
end
funcs.checkParameters = checkParameters

--- Function to check if IP is valid
---@param ip string IP to check
---@return bool success Success
local function isValidIPv4(ip)
  if type(ip) ~= "string" then
    return false
  end

  -- Match 4 groups of 1–3 digits separated by dots
  local a, b, c, d = ip:match("^(%d+)%.(%d+)%.(%d+)%.(%d+)$")
  if not a then
    return false
  end

  -- Convert to numbers and validate range 0–255
  for _, octet in ipairs({a, b, c, d}) do
    local num = tonumber(octet)
    if not num or num < 0 or num > 255 then
        return false
    end
    -- Prevent leading zeros like "01"
    if tostring(num) ~= octet then
        return false
    end
  end

  return true
end
funcs.isValidIPv4 = isValidIPv4

--- Function to check if IPs match in same subnet
---@param ip1 string IP1 to check
---@param mask string Subnetmask to use
---@param ip2 string IP2 to check
---@return bool success Success
local function checkIPSetup(ip1, mask, ip2)
  local a, b, c, d = ip1:match("(%d+)%.(%d+)%.(%d+)%.(%d+)")
  local ipNum = tonumber(a) * 256^3 + tonumber(b) * 256^2 + tonumber(c) * 256 + tonumber(d)
  a, b, c, d = mask:match("(%d+)%.(%d+)%.(%d+)%.(%d+)")
  local nmNum = tonumber(a) * 256^3 + tonumber(b) * 256^2 + tonumber(c) * 256 + tonumber(d)
  a, b, c, d = ip2:match("(%d+)%.(%d+)%.(%d+)%.(%d+)")
  local gwNum = tonumber(a) * 256^3 + tonumber(b) * 256^2 + tonumber(c) * 256 + tonumber(d)

  -- Perform bitwise AND between IP address and Netmask to get the network address
  local networkAddress = ipNum & nmNum
  local gwNetworkAddress = gwNum & nmNum

  -- Check if IPs addresses are in the same network
  if networkAddress == gwNetworkAddress then
    return true
  else
    return false
  end
end
funcs.checkIPSetup = checkIPSetup

-- Parse dotted IP and validate octets
---@param ip string IP to check
---@return string[]? octets Seperated parts of IP
local function parse_ip(ip)
    local octets = {}
    for o in ip:gmatch("(%d+)") do
        o = tonumber(o)
        if not o or o < 0 or o > 255 then
            return nil
        end
        table.insert(octets, o)
    end
    if #octets ~= 4 then
        return nil
    end
    return octets
end

-- Convert dotted IP to 32-bit integer
---@param ip string IP to convert
---@return int? o IP as int
local function ip_to_int(ip)
    local o, err = parse_ip(ip)
    if not o then return nil, err end
    return (o[1] << 24) | (o[2] << 16) | (o[3] << 8) | o[4]
end

-- Convert 32-bit integer to dotted IP
---@param int int IP as int
---@return string IP as string
local function int_to_ip(int)
    return string.format("%d.%d.%d.%d", (int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
end

-- Check that subnet mask has contiguous 1-bits
---@param mask_int int Mask as int
---@return bool? Result if mask is valid
local function is_valid_mask(mask_int)
    if mask_int == 0 or mask_int == 0xFFFFFFFF then
        return false
    end

    -- Valid mask property:
    -- mask & (mask + 1) == 0 when inverted
    local inverted = (~mask_int) & 0xFFFFFFFF
    return (inverted & (inverted + 1)) == 0
end

-- Validate IP and subnet mask
---@param ip string IP to check
---@param mask string Mask to check
---@return int? Checked IP as integer
---@return int? Checked mask as integer
local function validate_ip_and_mask(ip, mask)
    local ip_i = ip_to_int(ip)
    if not ip_i then
        return nil
    end

    local mask_i = ip_to_int(mask)
    if not mask_i then
        return nil
    end

    if not is_valid_mask(mask_i) then
        return nil
    end

    return ip_i, mask_i
end

-- Get valid IP in same subnet
---@param ip string IP to check
---@param mask string Mask to check
---@return string? Valid IP in same subnet
local function get_ip_in_same_subnet(ip, mask)
    local ip_i, mask_i_or_err = validate_ip_and_mask(ip, mask)
    if not ip_i then
        return nil
    end
    local mask_i = mask_i_or_err

    local network   = ip_i & mask_i
    local broadcast = network | (~mask_i & 0xFFFFFFFF)

    local host_ip -- = network + 1
    if ip_i + 1 >= broadcast then
      host_ip = ip_i - 1
    else
      host_ip = ip_i + 1
    end

    return int_to_ip(host_ip)
end
funcs.getIPSameSubnet = get_ip_in_same_subnet

return funcs

--**************************************************************************
--**********************End Function Scope *********************************
--**************************************************************************