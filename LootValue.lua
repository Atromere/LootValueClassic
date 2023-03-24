local isEnabled = true
local lastLootTime = 0
local currentLoot = {}
local totalMoneyLooted = 0
local highestValueItem = nil
local highestValue = 0
local displayLootValueScheduled = false

local function GetAuctionBuyoutForItemID(itemID)
    local itemName, _, itemRarity, _, _, _, _, _, _, _, itemSellPrice = GetItemInfo(itemID)
    if itemName and AucAdvanced then
        local aucValue = AucAdvanced.API.GetMarketValue(itemID)
        if aucValue then
            return aucValue
        else
            print("No auction data found for item:", itemName)
        end
    else
        print("No item info found for itemID:", itemID)
    end
    return itemSellPrice
end
local function getMessageByRange(totalValue)
  local goldValue = totalValue / 10000
  if goldValue >= 2000 then
      return "Unbelievable! You're swimming in gold like a goblin in a treasure room!"
  elseif goldValue >= 1500 then
      return "You've hit the jackpot! Time to show off those shiny new items!"
  elseif goldValue >= 1000 then
      return "Epic mount, here we come! Giddy up!"
  elseif goldValue >= 750 then
      return "Sweet loot! You're on a roll! Better than a gnome on a sugar rush."
  elseif goldValue >= 500 then
      return "Nice haul! Treat yourself to something special, like a new bag for all this loot!"
  elseif goldValue >= 250 then
      return "You could buy some decent gear with that! Outfit yourself like a true hero."
  elseif goldValue >= 100 then
      return "A respectable pile of gold. Time to visit the auction house and splurge!"
  elseif goldValue >= 50 then
      return "Not too shabby, might get you a nice rare item or a fancy new hat!"
  elseif goldValue >= 25 then
      return "Meh, just another day in Azeroth. Maybe you can buy a new pair of boots?"
  elseif goldValue >= 10 then
      return "It's not much, but every copper counts, right? Keep saving for that epic mount!"
  elseif goldValue >= 5 then
      return "Keep grinding, maybe you'll find something better. Like a two-headed ogre's lucky coin!"
  else
      return "Well, it's better than nothing... I guess. At least you can buy a snack with it!"
  end
end

local function GetItemValue(itemID)
    local _, _, itemRarity, _, _, _, _, _, _, _, itemSellPrice = GetItemInfo(itemID)
    if itemRarity >= 1 then
      local itemName = GetItemInfo(itemID)
      if itemName and AucAdvanced then
        local aucValue = AucAdvanced.API.GetMarketValue(itemID)
        if aucValue then
            totalValue = totalValue + aucValue
        else
            print("No auction data found for item:", itemName)
        end
      else
          print("No item info found for itemID:", itemID)
      end
    end

    return itemSellPrice
end

local function displayLootValue()

    local totalValue = totalMoneyLooted
    for _, itemID in ipairs(currentLoot) do
        local itemValue = GetAuctionBuyoutForItemID(itemID)
        if itemValue then
            totalValue = totalValue + itemValue
            if itemValue > highestValue then
                highestValue = itemValue
                highestValueItem = itemID
            end
        end
    end

    if totalValue > 0 then
        local message = getMessageByRange(totalValue)
        print("Total value of looted items: " .. GetCoinTextureString(totalValue) .. " - " .. message)
        if highestValueItem then
            local highestValueItemLink = select(2, GetItemInfo(highestValueItem))
            print("Highest value item: " .. highestValueItemLink .. " - " .. GetCoinTextureString(highestValue))
        end
    end

    currentLoot = {}
    totalMoneyLooted = 0
    highestValueItem = nil
    highestValue = 0
end

local lootFrame = CreateFrame("Frame")
lootFrame:RegisterEvent("LOOT_READY")
lootFrame:SetScript("OnEvent", function()
    if not isEnabled then return end
    for i = 1, GetNumLootItems() do
        local lootSlotType = GetLootSlotType(i)
        if lootSlotType == LOOT_SLOT_TYPE_ITEM then
            local itemLink = GetLootSlotLink(i)
            if itemLink then
                local itemID = tonumber(string.match(itemLink, "item:(%d+)"))
                if itemID then
                    table.insert(currentLoot, itemID)
                end
            end
        elseif lootSlotType == LOOT_SLOT_TYPE_COIN then
            local _, _, _, money = GetLootSlotInfo(i)
            totalMoneyLooted = totalMoneyLooted + money
        end
    end
    displayLootValue()
end)
