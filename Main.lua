local Scripts = {
    {
        PlacesIds = {2753915549, 4442272183, 7449423635}, -- All Blox Fruits maps
        Path = "SkullGuitar.lua"
    }
}

local fetcher, urls = {}, {}

-- Change this to YOUR GitHub username and repo name
urls.Owner = "https://raw.githubusercontent.com/aryan777byte/"
urls.Repository = "{Owner}SkullGuitarAuto/main/"
urls.Games = "{Repository}Games/"

-- Replaces {Repository} etc. with actual URLs
local function formatUrl(url)
    for key, value in pairs(urls) do
        url = url:gsub("{" .. key .. "}", value)
    end
    return url
end

-- HTTP fetch function
function fetcher.get(url)
    local success, result = pcall(function()
        return game:HttpGet(formatUrl(url))
    end)
    if success then
        return result
    else
        error("Failed to load URL: " .. url)
    end
end

-- Load and run code from URL
function fetcher.load(url)
    local raw = fetcher.get(url)
    local func, err = loadstring(raw)
    if not func then
        error("Loadstring failed: " .. err)
    end
    return func()
end

-- Check if you're in the right place
local function IsPlace(Data)
    return Data.PlacesIds and table.find(Data.PlacesIds, game.PlaceId)
end

-- Run the matching script
for _, Data in pairs(Scripts) do
    if IsPlace(Data) then
        return fetcher.load("{Games}" .. Data.Path)
    end
end
