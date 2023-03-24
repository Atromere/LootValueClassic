local LootValueFrame = CreateFrame("Frame")
local currentLoot = {}
local totalValue = 0
LootValueFrame:RegisterEvent("LOOT_READY")

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


local function GetAuctionBuyoutForItemID(itemID)
    local itemName = GetItemInfo(itemID)
    if itemName then
        return GetAuctionBuyoutForItem(itemName)
    end
    return nil
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

local displayLootValueScheduled = false

local function displayLootValue()
    if displayLootValueScheduled then
        displayLootValueScheduled = false

        for _, itemID in ipairs(currentLoot) do
            local itemValue = GetItemValue(itemID)
            if itemValue then
                totalValue = totalValue + itemValue
            end
        end

        if totalValue > 0 then
            local message = getMessageByRange(totalValue)
            print("Total value of looted items: " .. GetCoinTextureString(totalValue) .. " - " .. message)
        end

        currentLoot = {}
        totalValue = 0
    end
end

LootValueFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "LOOT_READY" then
        local numLootItems = GetNumLootItems()

        for i = 1, numLootItems do
            local lootSlotLink = GetLootSlotLink(i)
            if lootSlotLink then
                local _, _, itemID = string.find(lootSlotLink, "item:(%d+):")
                itemID = tonumber(itemID)
                if itemID then
                    table.insert(currentLoot, itemID)
                end
            end
        end
        
        if not displayLootValueScheduled then
            displayLootValueScheduled = true
            C_Timer.After(5, displayLootValue)
        end
    end
end)

print("Loot Value loaded.  We're gonna be as rich as Bobby soon!")