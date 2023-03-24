LootValue = LootValue or {}
local getLootMessageAndSound = LootValue.getLootMessageAndSound
local LootValueFrame = CreateFrame("Frame")
local currentLoot = {}
local totalValue = 0
local totalMoney = 0
LootValueFrame:RegisterEvent("LOOT_READY")

local function GetItemValue(itemID)
    local itemName, _, itemRarity, _, _, _, _, _, itemBindType, _, itemSellPrice = GetItemInfo(itemID)
    if not itemName then
        return nil
    end

    local itemValue = itemSellPrice

    if itemRarity and itemBindType and itemSellPrice then
        if itemRarity >= 1 and itemBindType ~= 1 then
            if AucAdvanced then
                local aucValue = AucAdvanced.API.GetMarketValue(itemID)
                if aucValue then
                    totalValue = totalValue + aucValue
                    itemValue = aucValue
                else
                    print("No auction data found for item: ", itemName)
                end
            else
                print("Auctioneer not found for itemID: ", itemID)
            end
        end
    end

    return itemValue
end

local function GetTopTwoItems(items)
    if #items < 2 then
        return items
    end

    local uniqueItems = {}
    for _, itemID in ipairs(items) do
        if not uniqueItems[itemID] then
            uniqueItems[itemID] = true
        end
    end

    local uniqueItemIDs = {}
    for itemID, _ in pairs(uniqueItems) do
        table.insert(uniqueItemIDs, itemID)
    end

    local item1, item2 = uniqueItemIDs[1], uniqueItemIDs[2]
    local itemValue1, itemValue2 = GetItemValue(item1), GetItemValue(item2)

    if itemValue1 < itemValue2 then
        item1, item2, itemValue1, itemValue2 = item2, item1, itemValue2, itemValue1
    end

    for i = 3, #uniqueItemIDs do
        local currentItem = uniqueItemIDs[i]
        local currentItemValue = GetItemValue(currentItem)

        if currentItemValue > itemValue1 then
            item2, itemValue2 = item1, itemValue1
            item1, itemValue1 = currentItem, currentItemValue
        elseif currentItemValue > itemValue2 then
            item2, itemValue2 = currentItem, currentItemValue
        end
    end

    return {item1, item2}
end

local displayLootValueScheduled = false

local function displayLootValue()
    for _, itemID in ipairs(currentLoot) do
        local itemValue = GetItemValue(itemID)
        if itemValue then
            totalValue = totalValue + itemValue
        end
    end

    totalValue = totalValue + totalMoney

    if totalValue > 0 then
        local message, soundId = LootValue.getLootMessageAndSound(totalValue)
        if soundId ~= nil then
            PlaySound(soundId, "Master")
        end
        local topTwoItems = GetTopTwoItems(currentLoot)
        local topTwoItemsLinks = ""

        for _, itemID in ipairs(topTwoItems) do
            topTwoItemsLinks = topTwoItemsLinks .. " " .. select(2, GetItemInfo(itemID))
        end

        print("Total value of looted items and money: " .. GetCoinTextureString(totalValue) .. " - " .. message)
        print("Top two items:" .. topTwoItemsLinks)
    end

    currentLoot = {}
    totalValue = 0
    totalMoney = 0
end

local lootValueDisplayTimer

local function lootReadyEventHandler()
    local numLootItems = GetNumLootItems()
    for i = 1, numLootItems do
        local lootSlotType = GetLootSlotType(i)

        if lootSlotType == LOOT_SLOT_ITEM then
            local lootSlotLink = GetLootSlotLink(i)

            if lootSlotLink then
                local _, _, itemID = string.find(lootSlotLink, "item:(%d+):")
                itemID = tonumber(itemID)

                if itemID then
                    table.insert(currentLoot, itemID)
                    if lootValueDisplayTimer then
                        lootValueDisplayTimer:Cancel()
                    end
                else
                    print("Failed to extract item ID from link:", lootSlotLink)
                end
            end
        elseif lootSlotType == LOOT_SLOT_MONEY then
            local moneyLink = GetLootSlotLink(i)

            if moneyLink then
                local _, _, lootAmount = string.find(moneyLink, "copper:(%d+)")
                lootAmount = tonumber(lootAmount)

                if lootAmount then
                    totalMoney = totalMoney + lootAmount
                    if lootValueDisplayTimer then
                        lootValueDisplayTimer:Cancel()
                    end
                else
                    print("Failed to extract money amount from link:", moneyLink)
                end
            end
        end
    end

    -- Delay the display of loot value by 5 seconds
    lootValueDisplayTimer = C_Timer.NewTimer(5, function()
        displayLootValue()
    end)

end

LootValueFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "LOOT_READY" then
        lootReadyEventHandler()
    end
end)


print("Loot Value loaded. We're gonna be as rich as Bobby soon!")