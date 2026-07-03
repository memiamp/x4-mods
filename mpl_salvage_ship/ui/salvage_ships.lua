local ffi = require("ffi")
local C = ffi.C
local Lib = require("extensions.sn_mod_support_apis.lua_interface").Library

local blackboardKey = "$salvageShip"
local cargo = {}
local contextFrameLayer = 2
local equipment = {}
local fontSizeRow = 8
local fontSizeSubRow = 8
local inventory = {}
local isDebug = true
local mapMenu
local mplSalvageShips = {}
local playerId = 0
local ship = {}
local shipId = 0
local shipMacro = ""
local stationId = 0

local salvageTypeColourMapping = {
  [1] = Helper.color.green,
  [2] = Helper.color.red,
  [3] = Helper.color.grey
}

local salvageTypeNameMapping = {
  [1] = ReadText(20104, 55),
  [2] = ReadText(20104, 56),
  [3] = ReadText(20104, 57)
}

local salvageTypeTooltipMapping = {
  [1] = ReadText(20104, 59),
  [2] = ReadText(20104, 60),
  [3] = ReadText(20104, 61)
}

---
--- The callback when salvage ships is started.
---
function mplSalvageShips.callback(_, _)
  playerId = ConvertStringTo64Bit(tostring(C.GetPlayerID()))
  mplSalvageShips.debugText("Callback was invoked for player " .. playerId)

  mplSalvageShips.loadData()
  mplSalvageShips.drawWindow()
end

---
--- Outputs the contents of a table to the debug output
--- @param table table The table to be output
---
function mplSalvageShips.debugTable(table)
  if (isDebug) then
    Lib.Print_Table(table)
  end
end

---
--- Outputs the specified parameters to the debug output
--- @param text string The data to output 
---
function mplSalvageShips.debugText(text)
  if (isDebug) then
    DebugError("mplss.lua: " .. text)
  end
end

---
--- Adds a cargo item to a salvage table
--- @param frame  table    The table to add the item to
--- @param name   string   The name of the cargo item
--- @param data   integer  The number of cargo items
---
function mplSalvageShips.drawCargoItem(target, name, data)
  local row = target:addRow(true)
  row[1]:createText(name, { fontsize = fontSizeRow })
  row[2]:createText(ConvertIntegerString(data, true, 0, true), { halign = "right", fontsize = fontSizeRow })
end

---
--- Draws the cargo table
--- @param frame      table  The frame to draw the content within
--- @param yPosition  int    The Y position at which to draw the table
---
function mplSalvageShips.drawCargoTable(frame, yPosition)
  local cargoTable = frame:addTable(2,
  {
    backgroundColor = Helper.color.transparent,
    backgroundID = "solid",
    borderEnabled = true,
    maxVisibleHeight = Helper.scaleY(200),
    reserveScrollBar = true,
    tabOrder = 2,
    x = Helper.borderSize,
    y = yPosition + Helper.borderSize
  })
  
  cargoTable:setColWidthPercent(2, 15)
 
  local sortedCargo = mplSalvageShips.sortTable(cargo, function(k)
    return GetWareData(k, "name")
  end)
  
  for key, value in sortedCargo do
    mplSalvageShips.drawCargoItem(cargoTable, key, value)
  end
  
  return cargoTable
end

---
--- Draws an equipment item
--- @param frame  table   The table to add the item to
--- @param name   string  The name of the equipment item
--- @param data   table   The table of materials for the equipment item
---
function mplSalvageShips.drawEquipmentItem(target, name, data)
  local row = target:addRow(true)
  row[1]:setColSpan(2):createText(name, { fontsize = fontSizeRow })
  row[3]:createText(string.format(ReadText(20104, 58), data.quantity), { fontsize = fontSizeRow, halign = "right" })
  row[4]:setColSpan(2):createText(salvageTypeNameMapping[data.type], { color = salvageTypeColourMapping[data.type], fontsize = fontSizeRow, halign = "right", mouseOverText = salvageTypeTooltipMapping[data.type] })
  
  if (data.type == 3) then
    row = target:addRow(nil)
    row[1]:createText("-", { fontsize = fontSizeSubRow })
    row[2]:setColSpan(3):createText(ReadText(20104, 62), { fontsize = fontSizeSubRow })
    row[5]:createText(ConvertMoneyString(data.credits, false, true, nil, true), { halign = "right", fontsize = fontSizeSubRow })
  else
    local sortedMaterials = mplSalvageShips.sortTable(data.materials, function(k)
      return GetWareData(k, "name")
    end)
    
    for key, value in sortedMaterials do
      row = target:addRow(nil)
      row[1]:createText("-", { fontsize = fontSizeSubRow })
      row[2]:setColSpan(3):createText(key, { fontsize = fontSizeSubRow })
      row[5]:createText(ConvertIntegerString(value, true, 0, true), { halign = "right", fontsize = fontSizeSubRow })
    end
  end
end

---
--- Draws the equipment table
--- @param frame      table  The frame to draw the content within
--- @param yPosition  int    The Y position at which to draw the table
---
function mplSalvageShips.drawEquipmentTable(frame, yPosition)
  local equipmentTable = frame:addTable(5,
  {
    backgroundColor = Helper.color.transparent,
    backgroundID = "solid",
    borderEnabled = true,
    maxVisibleHeight = Helper.scaleY(300),
    reserveScrollBar = true,
    tabOrder = 2,
    x = Helper.borderSize,
    y = yPosition + Helper.borderSize
  })
  
  equipmentTable:setColWidthPercent(1, 3)
  equipmentTable:setColWidthPercent(3, 10)
  equipmentTable:setColWidthPercent(4, 15)
  equipmentTable:setColWidthPercent(5, 15)
 
  -- Ship salvage data
  mplSalvageShips.drawEquipmentItem(equipmentTable, GetMacroData(shipMacro, "name"), ship)

  -- Equipment salvage data
  local sortedEquipment = mplSalvageShips.sortTable(equipment, function(k)
    return GetWareData(k, "name")
  end)
 
  for key, value in sortedEquipment do
    mplSalvageShips.drawEquipmentItem(equipmentTable, key, value)
  end
  
  return equipmentTable
end

---
--- Draws the inventory table
--- @param frame      table  The frame to draw the content within
--- @param yPosition  int    The Y position at which to draw the table
---
function mplSalvageShips.drawInventoryTable(frame, yPosition)
  local inventoryTable = frame:addTable(2,
  {
    backgroundColor = Helper.color.transparent,
    backgroundID = "solid",
    borderEnabled = true,
    maxVisibleHeight = Helper.scaleY(200),
    reserveScrollBar = true,
    tabOrder = 2,
    x = Helper.borderSize,
    y = yPosition + Helper.borderSize
  })
  
  inventoryTable:setColWidthPercent(2, 15)
 
  local sortedInventory = mplSalvageShips.sortTable(inventory, function(k)
    return GetWareData(k, "name")
  end)
  
  for key, value in sortedInventory do
    mplSalvageShips.drawCargoItem(inventoryTable, key, value)
  end
  
  return inventoryTable
end

---
--- Draws a subheader on the specified target
--- @param frame      table    The target frame to place the sub-header on
--- @param text       string   The text to be drawn
--- @param yPosition  integer  The y position to offset the header by
---
function mplSalvageShips.drawSubHeader(frame, text, yPosition)
  local subHeaderTable = frame:addTable(1, { reserveScrollBar = false, tabOrder = 1, y = yPosition + Helper.borderSize })
  
  local row = subHeaderTable:addEmptyRow(height, Helper.standardTextHeight / 2)
  
  row = subHeaderTable:addRow(nil)
  row[1]:createText(text, Helper.subHeaderTextProperties)

  return subHeaderTable
end

---
--- Draws the window used to display the salvage data
---
function mplSalvageShips.drawWindow()
  Helper.removeAllWidgetScripts(mapMenu, contextFrameLayer)

  mapMenu.contextFrame = Helper.createFrameHandle(mapMenu,
  {
    closeOnUnhandledClick = true,
    layer = contextFrameLayer,
    standardButtons = { close = true },
    startAnimation = nil,
    width = Helper.scaleX(400),
    x = (Helper.viewWidth - Helper.scaleX(400)) / 2,
    y = Helper.scaleY(200)
  })
  mapMenu.contextFrame:setBackground("solid", { color = Color["frame_background_black"] })

  mplSalvageShips.drawWindowContent(mapMenu.contextFrame)

  mapMenu.contextFrame.properties.height = math.min(Helper.viewHeight - mapMenu.contextFrame.properties.y, mapMenu.contextFrame:getUsedHeight() + Helper.borderSize)
  mapMenu.contextFrame.properties.y = (Helper.viewHeight - mapMenu.contextFrame.properties.height) / 2
  mapMenu.contextFrame:display()
end

---
--- Draws the contents of the salvage data window
--- @param frame table The frame to draw the content within
---
function mplSalvageShips.drawWindowContent(frame)
  local mainTable = frame:addTable(3, { reserveScrollBar = false, tabOrder = 1 })
  mainTable:setColWidthPercent(1, 1)
  mainTable:setColWidthPercent(3, 1)
  
  -- Window header
  local row = mainTable:addRow(nil)
  row[2]:createText(string.format(ReadText(20104, 51), mplSalvageShips.getCurrentShipName()), Helper.titleTextProperties)
  
  local yPosition = mainTable.properties.y + mainTable:getVisibleHeight()
  
  -- Equipment salvage
  local nextTable = mplSalvageShips.drawSubHeader(frame, ReadText(20104, 52), mainTable.properties.y + mainTable:getVisibleHeight())
  yPosition = nextTable.properties.y + nextTable:getVisibleHeight()
  
  nextTable = mplSalvageShips.drawEquipmentTable(frame, yPosition)
  yPosition = nextTable.properties.y + nextTable:getVisibleHeight()
  
  -- Cargo salvage
  if next(cargo) then
    nextTable = mplSalvageShips.drawSubHeader(frame, ReadText(20104, 53), yPosition)
    yPosition = nextTable.properties.y + nextTable:getVisibleHeight()
    
    nextTable = mplSalvageShips.drawCargoTable(frame, yPosition)
    yPosition = nextTable.properties.y + nextTable:getVisibleHeight()
  end
  
   -- Inventory salvage
  if next(inventory) then
    nextTable = mplSalvageShips.drawSubHeader(frame, ReadText(20104, 54), yPosition)
    yPosition = nextTable.properties.y + nextTable:getVisibleHeight()
    
    nextTable = mplSalvageShips.drawInventoryTable(frame, yPosition)
    yPosition = nextTable.properties.y + nextTable:getVisibleHeight()
  end
  
  mplSalvageShips.drawWindowContentButtons(frame, yPosition)
end

---
--- Draws the button content
--- @param frame      table  The frame to draw the content within
--- @param yPosition  int    The Y position of the bottom of the header table
---
function mplSalvageShips.drawWindowContentButtons(frame, yPosition)
  local buttonTableTopMargin = 40
  local buttonTable = frame:addTable(5, { tabOrder = 3, x = Helper.borderSize, y = yPosition + buttonTableTopMargin, reserveScrollBar = false })
  buttonTable:setColWidth(1, 2)
  buttonTable:setColWidthPercent(3, 25)
  buttonTable:setColWidthPercent(4, 25)
  buttonTable:setColWidth(5, 2)

  row = buttonTable:addRow(nil)
  row[2]:setColSpan(3):createText(ReadText(20104, 12), { color = Helper.color.red, halign = "center", wordwrap = true })
  
  row = buttonTable:addRow(true, { bgColor = Helper.color.transparent })
  row[3]:createButton({ }):setText(ReadText(1001, 2821), { halign = "center" })
  row[3].handlers.onClick = mplSalvageShips.onConfirm
  
  row[4]:createButton({ }):setText(ReadText(1001, 64), { halign = "center" })
  row[4].handlers.onClick = mplSalvageShips.onClose

  -- adjust frame position
  local usedHeight = buttonTable.properties.y + buttonTable:getVisibleHeight()
  if frame.properties.y + usedHeight > Helper.viewHeight then
    frame.properties.y = Helper.viewHeight - usedHeight - Helper.frameBorder
  end
end

---
--- Gets the formatted name of the current ship
---
function mplSalvageShips.getCurrentShipName()
  local name, idcode = GetComponentData(shipId, "name", "idcode")
  return string.format(ReadText(20104,11), name, idcode)
end

---
--- Loads the data for the window
---
function mplSalvageShips.loadData()
  mplSalvageShips.debugText("Loading blackboard for player " .. playerId)
  
  local rawTable = GetNPCBlackboard(playerId, blackboardKey) or {}
  local salvageData = rawTable.data
  
  shipId = ConvertStringToLuaID(tostring(salvageData.source))
  stationId = ConvertStringToLuaID(tostring(salvageData.target))
  
  cargo = salvageData.cargo
  equipment = salvageData.equipment
  inventory = salvageData.inventory
  ship = salvageData.ship
  shipMacro = GetComponentData(shipId, "macro")

  -- Remove existing blackboard
  SetNPCBlackboard(playerId, blackboardKey, nil)
end

---
--- Closes the window
---
function mplSalvageShips.onClose()
  Helper.clearFrame(mapMenu, contextFrameLayer)
end

---
--- Confirms that the salvage operation should be performed
---
function mplSalvageShips.onConfirm()
  AddUITriggeredEvent("mplss_trigger", "perform_salvage")

  mplSalvageShips.onClose()
end

---
--- Register the callback event for starting the process.
---
function mplSalvageShips.register()
  mplSalvageShips.debugText("Register was called")

  mapMenu = Helper.getMenu("MapMenu")
  RegisterEvent("mplss.start", mplSalvageShips.callback)
end

---
--- Sorts a table by it
---
function mplSalvageShips.sortTable(source, keyResolver)
  local keys = {}
  
  for key in pairs(source) do
    local resolvedKey = keyResolver(key)
    table.insert(keys, { key = key, resolved = resolvedKey or key})
  end
  
  -- Sort by the resolved key value
  table.sort(keys, function(a, b)
    return a.resolved < b.resolved
  end)
  
  local i = 0
  return function()
    i = i + 1
    local entry = keys[i]
    if (entry) then
      return entry.resolved, source[entry.key]
    end
  end
end

-- Register this script
mplSalvageShips.register()
