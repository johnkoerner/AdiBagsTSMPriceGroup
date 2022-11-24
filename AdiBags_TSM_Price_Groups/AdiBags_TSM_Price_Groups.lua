--[[

--]]

local _, ns = ...

local addon = LibStub('AceAddon-3.0'):GetAddon('AdiBags')
local L = setmetatable({}, {__index = addon.L})
do -- Localization
  L["TSMPrice"] = "TSM Price Groups"
  L["TSMGroupsDesc"] = "Group items by TSM Price Value."

  local locale = GetLocale()
  if locale == "frFR" then

  elseif locale == "deDE" then
    
  elseif locale == "esMX" then
    
  elseif locale == "ruRU" then
    
  elseif locale == "esES" then
    
  elseif locale == "zhTW" then
    
  elseif locale == "zhCN" then
    
  elseif locale == "koKR" then
    
  end
end

local setFilter = addon:RegisterFilter("TSMPrice", 95, 'ABEvent-1.0')
setFilter.uiName = L['TSMPrice']
setFilter.uiDesc = L['TSMGroupsDesc']

function setFilter:OnInitialize()
  self.db = addon.db:RegisterNamespace('TSMPrice', {
    profile = { priceSource = 'dbRegionMarketAvg' },
    char = {  },
  })
end

function setFilter:Update()
  self:SendMessage('AdiBags_FiltersChanged')
end

function setFilter:OnEnable()
  addon:UpdateFilters()
end

function setFilter:OnDisable()
  addon:UpdateFilters()
end

local function byExpires(price)
  if (price == nil) then
    return nil
  end

  if (price < 10) then
    return '<10'
  end

  if (price < 20) then
    return '<20'
  end

  if (price < 50) then
    return '<50'
  end

  if (price <75) then
    return '<75'
  end 

  if (price <100) then
    return '<100'
  end 

  return '100+'

end

local function bySaleRate(rate)
  if (rate == nil) then
    return 'n/a'
  end 
  if (rate == 1) then
    return '0.01'
  end

  if (rate == 2) then
    return '0.02'
  end 

  if (rate == 3) then
    return '0.03'
  end

  if (rate < 10) then
    return '0.04+'
  end

  if (rate < 25) then
    return '0.1+'
  end
  
  if (rate < 50) then
    return '0.25+'
  end

  return '0.5+'
end

local function byItemLevel(level) 
  if (level == nil) then
    return 'n/a'
  end 

  if (level < 70) then
    return '<70'
  end

  if (level <= 150) then
    return '<150'
  end 

  if (level <= 220) then
    return '<220'
  end

  if (level <= 380) then
    return '<380'
  end

  return '380+'

end

local function logItem(slotData) 

  print("GUID:" .. slotData.guid)
  print("itemId:" .. slotData.itemId)
  print("link:" .. slotData.link)
  print("name:" .. slotData.name)
  print("class:" .. slotData.class)

end



local lookup = {
  dbRegionMarketAvg = 'DBRegionMarketAvg',
  dbMarket = 'DBMarket',
  dbMinBuyout = 'DBMinBuyout',
  dbHistorical = 'DBHistorical',
  dbRegionHistorical = 'DBRegionHistorical',
  dbRegionSaleAvg = 'DBRegionSaleAvg',
  wseparator = '----------------------',
  xNumExpires = 'NumExpires',
  xItemLevel = 'ItemLevel',
  xDBregionsaleRate = 'DBRegionsaleRate'
}

local setNames = {}
function setFilter:Filter(slotData)
   -- logItem(slotData)
    local itemID, itemType, _, _, _, itemClassID  = GetItemInfoInstant(slotData.itemId)

    -- Extract some goddies from the link.  Source of find string: https://wowwiki-archive.fandom.com/wiki/ItemLink
    -- We do this so we can get the Id value that is needed to generate the pet string for TSM.  The itemID that comes
    -- back from AdiBags is the generic pet cage id. Parsing the link gives us the ID that TSM needs.
    local _, _, Color, Ltype, idFromLink, Enchant, Gem1, Gem2, Gem3, Gem4,
    Suffix, Unique, LinkLvl, Name = string.find(slotData.link,
    "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")

    local itemString = "i:" .. itemID

    -- We need to handle pets specially.  17 is the pet class id.
    if (itemClassID== 17) then
      itemString = "p:" .. idFromLink;
    end

    local priceSource = lookup[self.db.profile.priceSource]

    -- Need to multiple the sale rate by 100, otherwise it will return nil for anything less than 0.5 because the function we call expects to return us numbers in whole copper.
    if (priceSource == 'DBRegionsaleRate') then
      priceSource = 'DBRegionsaleRate*100'
    end

    local price = TSM_API.GetCustomPriceValue(priceSource,itemString)
    
    -- Non-gold numbers need custom processing
    if (priceSource == 'NumExpires') then
      return byExpires(price)
    end 

    if (priceSource == 'DBRegionsaleRate*100') then
      return bySaleRate(price)
    end

    if (priceSource == 'ItemLevel') then
      return byItemLevel(price)
    end 

    -- We are working with something in terms of gold at this point.
    local min = self.db.profile.minGroup
    if (min == nil) then 
      min = 'EFiveHundred'
    end 

    if (price ~= nil) then
      if (price > 1000000000) then
        return '100k+'
      end 

      if (price > 500000000) then
        return '50k+'
      end 
      if (price > 250000000) then
        return '25k+'
      end 

      if (min == 'ITwentyFiveThousand') then return nil end

      if (price > 100000000) then
        return '10k+'
      end 

      if (min == 'HTenThousand') then return nil end

      if (price > 50000000) then
        return '5k+'
      end 

      if (min == 'GFiveThousand') then return nil end 

      if (price > 10000000) then
        return '1k+'
      end 

      if (min == 'FOneThousand') then return nil end 

      if (price > 5000000) then
        return '500+'
      end

      if (min == 'EFiveHundred') then return nil end 

      if (price > 2500000) then
        return '250+'
      end

      if (min == 'DTwoFifty') then return nil end 

      if (price > 1000000) then
        return '100+'
      end

      if (min == 'COneHundred') then return nil end 

      if (price > 500000) then
        return '50+'
      end

      if (min == 'BFifity') then return nil end 

      if (price > 250000) then
        return '25+'
      end

    end 
end


function setFilter:GetOptions()
  return {
    priceSource = {
      name = L['TSM Price Source'],
      desc = L['Select the TSM Price String to use for bag filtering'],
      type = 'select',
      order = 10,
      values = lookup
    },
    minGroup = {
      name = L['Mininmum Group Price'],
      desc = L['The minimum value to put an item into a group'],
      type = 'select',
      order = 20,
      values = {
        ATwentyFive = '25g',
        BFifity = '50g',
        COneHundred = '100g',
        DTwoFifty = '250g',
        EFiveHundred = '500g',
        FOneThousand = '1000g',
        GFiveThousand = '5000g',
        HTenThousand = '10000g',
        ITwentyFiveThousand = '25000g'
      }
    }
  }, addon:GetOptionHandler(self, false, function() return self:Update() end)
end
