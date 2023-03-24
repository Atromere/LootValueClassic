LootValue = LootValue or {}


function getLootMessageAndSound(totalValue)
    local goldValue = totalValue / 10000
    local messages = {}
    local soundId

    if goldValue >= 2000 then
        soundId = 888 -- Sound ID for Legendary loot (Raid Warning)
        messages = {
            "Unbelievable! You're swimming in gold like a goblin in a treasure room!",
            "Wow, look at all that gold! You could buy a small kingdom with that!",
            "Incredible! Your pockets must be overflowing with all that gold!",
            "You struck it rich! Time to retire and sip on mana cocktails!"
        }
    elseif goldValue >= 1500 then
        soundId = 11466 -- Sound ID for Epic loot (Achievement Sound)
        messages = {
            "You've hit the jackpot! Time to show off those shiny new items!",
            "Huge win! It's raining gold!",
            "Amazing! You're like a walking treasure chest!",
            "You're on fire! Or is that just the glint of all that gold?"
        }
    elseif goldValue >= 1000 then
        soundId = 8459 -- Sound ID for Rare loot (Loot window coin sound)
        messages = {
            "Epic mount, here we come! Giddy up!",
            "Whoa, that's a lot of gold! Time to go shopping!",
            "Fantastic! You're one step closer to buying that epic mount!",
            "Keep it up, and you'll need a bigger vault for all this gold!"
        }
    elseif goldValue >= 750 then
        soundId = 31579 -- Sound ID for Uncommon loot (Bag closing)
        messages = {
            "Sweet loot! You're on a roll! Better than a gnome on a sugar rush.",
            "Great job! You're making some serious bank!",
            "Impressive! Keep up the good work!",
            "Not too shabby! You could throw a feast for the whole guild!"
        }
    elseif goldValue >= 500 then
        soundId = 439 -- Sound ID for Common loot (Vendor Greeting)
        messages = {
            "Nice haul! Treat yourself to something special, like a new bag for all this loot!",
            "Decent earnings! You're doing pretty well!",
            "Getting spicy!",
            "Not bad at all! Keep up the good work!",
            "You're no goblin tycoon, but you're getting there!"
        }
    elseif goldValue >= 250 then
        soundId = 1165 -- Sound ID for bag opening (Auction Window Open)
        messages = {
            "A little something to keep you going!",
            "Every coin counts!",
            "A humble treasure, but treasure nonetheless!",
            "Keep going, and you'll find bigger and better loot!",
            "It's not much, but it's honest gold!"
        }
    elseif goldValue >= 100 then
        soundId = 8460 -- Sound ID for bag opening (Auction Removed)
        messages = {
            "You won't be retiring on this, but it's something!",
            "A little pocket change!",
            "You're not exactly rolling in gold, but it's a start!",
            "A few coins to jingle in your pocket!",
            "A modest reward for your efforts!"
        }
    elseif goldValue >= 50 then
        soundId = 1174 -- Sound ID for bag opening (Money Frame Open)
        messages = {
            "A little something to keep you going!",
            "Every coin counts!",
            "A humble treasure, but treasure nonetheless!",
            "Keep going, and you'll find bigger and better loot!",
            "It's not much, but it's honest gold!"
        }
    elseif goldValue >= 25 then
        soundId = 1175 -- Sound ID for bag opening (Money Frame Close)
        messages = {
            "You won't be retiring on this, but it's something!",
            "A little pocket change!",
            "You're not exactly rolling in gold, but it's a start!",
            "A few coins to jingle in your pocket!",
            "A modest reward for your efforts!"
        }
    elseif goldValue >= 10 then
        soundId = 1155 -- Sound ID for bag opening (Coin Pick Up)
        messages = {
            "It's a small start, but every bit helps!",
            "You've got to start somewhere!",
            "A few more coins for your coffers!",
            "A modest beginning to your fortune!",
            "It's not a king's ransom, but it's something!"
        }
    elseif goldValue >= 5 then
        soundId = 1156 -- Sound ID for bag opening (Coin Drop)
        messages = {
            "A tiny treasure!",
            "It's not much, but every coin helps!",
            "A few coppers to line your pockets!",
            "A small reward for your efforts!",
            "Better than nothing!"
        }
    elseif goldValue >= 1 then
        soundId = 1202  -- Sound ID for bag opening (Bag Open)
        messages = {
            "Every copper counts!",
            "It's not much, but it's a start!",
            "You've got to start somewhere!",
            "A small addition to your fortune!",
            "It's not a lot, but it's something!"
        }
    else
        soundId = nil
        messages = {
            "Well, it's better than a poke in the eye!",
            "Gold? More like copper crumbs!",
            "You won't get rich with this, but every bit counts!",
            "Hey, it's something!",
            "Keep going, you'll get better loot next time!"
        }
    end

    local message = messages[math.random(#messages)]
    return message, soundId
end

LootValue.getLootMessageAndSound = getLootMessageAndSound