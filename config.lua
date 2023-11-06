Config                            = {}
Config.Locale                     = 'es'

--- #### BASICS
Config.EnablePrice = true -- false = sepeda akan gratis
Config.EnableEffects = true
Config.EnableBlips = false


--- #### PRICES	
Config.PriceTriBike = 20000
Config.PriceScorcher = 20000
Config.PriceCruiser = 17000
Config.PriceBmx = 15000

Config.CobroBike = 5000
Config.CobroScooter = 15000
Config.RentalTimer = 60 -- In Minutes


--- #### MARKER EDITS
Config.TypeMarker = 38
Config.MarkerScale = {x = 1.000,y = 1.000,z = 1.000}
Config.MarkerColor = {r = 0,g = 255,b = 255}

Config.Zones = { 
    {title="Rental Sepeda", colour=2, id=494, x = -718.52, y = -1299.56, z = 5.12}, --Pelabuhan
    {title="Rental Sepeda", colour=2, id=494, x = -1026.56, y = -2737.04, z = 20.16}, -- Bandara
 }