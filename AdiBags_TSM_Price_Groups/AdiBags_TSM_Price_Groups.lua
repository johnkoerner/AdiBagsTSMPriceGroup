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

local setNames = {}

function setFilter:Filter(slotData)
    local itemID = GetItemInfoInstant(slotData.link)
    local price = TSM_API.GetCustomPriceValue(self.db.profile.priceSource,"i:" .. itemID)
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
      values = {
        dbRegionMarketAvg = 'DBRegionMarketAvg',
        dbMarket = 'DBMarket',
        dbMinBuyout = 'DBMinBuyout',
        dbHistorical = 'DBHistorical',
        dbRegionHistorical = 'DBRegionHistorical',
        dbRegionSaleAvg = 'DBRegionSaleAvg'
      }
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
