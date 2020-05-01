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
  print('yo')
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

      if (price > 100000000) then
        return '10k+'
      end 

      if (price > 50000000) then
        return '5k+'
      end 

      if (price > 10000000) then
        return '1k+'
      end 

      if (price > 5000000) then
        return '500+'
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
    }
  }, addon:GetOptionHandler(self, false, function() return self:Update() end)
end
