local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local havebike = false
local colors = Config.MarkerColor
local scale = Config.MarkerScale
local inMenu = false
local cobroxMinuto = 0
local bicicleta = nil
local rentalTimer = Config.RentalTimer*60*1000


Citizen.CreateThread(function()

	if not Config.EnableBlips then return end
	
	for _, info in pairs(Config.Zones) do --Config.BlipZones
		info.blip = AddBlipForCoord(info.x, info.y, info.z)
		SetBlipSprite(info.blip, info.id)
		SetBlipDisplay(info.blip, 4)
		SetBlipScale(info.blip, 0.8)
		SetBlipColour(info.blip, info.colour)
		SetBlipAsShortRange(info.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(info.title)
		EndTextCommandSetBlipName(info.blip)
	end
end)



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k,v in pairs(Config.Zones) do --sin v Config.MarkerZones
		   DrawMarker(Config.TypeMarker, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, scale.x, scale.y, scale.z, colors.r, colors.g, colors.b, 100, 0, 0, 0, 0)	
		end
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
	
        for k,v in pairs(Config.Zones) do --Config.MarkerZones
        	local ped = PlayerPedId()
            local pedcoords = GetEntityCoords(ped, false)
			local distance = Vdist(pedcoords.x, pedcoords.y, pedcoords.z, v.x, v.y, v.z)
            if distance <= 1.40 then
				if not havebike then

					helptext(_U('press_e'))
					
					if IsControlJustPressed(0, Keys['E']) and IsPedOnFoot(ped) then
						OpenBikesMenu()
					elseif IsControlJustPressed(0, Keys['E']) and not IsPedOnFoot(ped) then
						ESX.ShowNotification('Kamu tidak boleh berada di atas sepeda!')
					end 
				else

					helptext(_U('storebike'))

					if IsControlJustPressed(0, Keys['E']) and IsPedOnAnyBike(ped) then
						havebike = false
						TriggerEvent('esx:deleteVehicle')
					
						if Config.EnableEffects then
							ESX.ShowNotification(_U('bikemessage'))
						else
							TriggerEvent("chatMessage", _U('bikes'), {255,255,0}, _U('bikemessage'))
						end
						--cobrar()
					elseif IsControlJustPressed(0, Keys['E']) and not IsPedOnAnyBike(ped) then
						if Config.EnableEffects then
							ESX.ShowNotification(_U('notabike'))
						else
							TriggerEvent("chatMessage", _U('bikes'), {255,255,0}, _U('notabike'))
						end
					end 		
				end
			elseif distance < 1.45 and inMenu then
				inMenu = false
				ESX.UI.Menu.CloseAll()
            end
        end
    end
end)



function OpenBikesMenu()

	inMenu = true
	local elements = {}

	table.insert(elements, {label = _U('bike'), value = 'bike'}) 
	table.insert(elements, {label = _U('bike2'), value = 'bike2'}) 
	table.insert(elements, {label = _U('bike3'), value = 'bike3'}) 
	table.insert(elements, {label = _U('bike4'), value = 'bike4'})
	
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'client',
    {
		title    = _U('biketitle'),
		align    = 'center',
		elements = elements,
    },
	
	
	function(data, menu)

	if data.current.value == 'bike' then
		TriggerServerEvent("esx_bike:lowmoney", Config.PriceTriBike, 'tribike2') 
	end
	
	if data.current.value == 'bike2' then
		TriggerServerEvent("esx_bike:lowmoney", Config.PriceScorcher, 'scorcher') 
	end
	
	if data.current.value == 'bike3' then
		TriggerServerEvent("esx_bike:lowmoney", Config.PriceCruiser, 'cruiser') 
	end
	
	if data.current.value == 'bike4' then
		TriggerServerEvent("esx_bike:lowmoney", Config.PriceBmx, 'bmx') 
	end

	ESX.UI.Menu.CloseAll()
	--havebike = true	
	inMenu = false

    end,
	function(data, menu)
		menu.close()
		end
	)
end

RegisterNetEvent('esx_bike:spawnBike')
AddEventHandler('esx_bike:spawnBike', function(bike)
	ESX.UI.Menu.CloseAll()
	inMenu = false
	havebike = true	
	spawn_effect(bike)
end)

RegisterNetEvent('esx_bike:blockBike')
AddEventHandler('esx_bike:blockBike', function()
	havebike = false
	SetVehicleMaxSpeed(bicicleta, 0.1)
	SetVehicleNumberPlateText(bicicleta, 'BLOQUEAD')
	local plate = GetVehicleNumberPlateText(bicicleta)
	print(plate)
end)

RegisterNetEvent('esx_bike:unblockBike')
AddEventHandler('esx_bike:unblockBike', function()
	havebike = true
	local ped = GetPlayerPed(-1)
	local bike = GetVehiclePedIsIn(ped)
	local maxSpeed = GetVehicleHandlingFloat(bike,"CHandlingData","fInitialDriveMaxFlatVel")	
	SetVehicleNumberPlateText(bike, 'RENTADO')
	local plate = GetVehicleNumberPlateText(bike)
	print(plate)
	local bikeProps = ESX.Game.GetVehicleProperties(bike)
	local model = GetDisplayNameFromVehicleModel(bikeProps.model)
	if model == 'FAGGION' then
		cobroxMinuto = Config.CobroScooter
	else
		cobroxMinuto = Config.CobroBike
	end
	SetVehicleMaxSpeed(bike, maxSpeed)
end)

function helptext(text)
	SetTextComponentFormat('STRING')
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function spawn_effect(somecar) 
	local ped = GetPlayerPed(-1)
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	ESX.Game.SpawnVehicle(somecar, GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, 0.0), GetEntityHeading(ped), function(vehicle) --90 ,GetEntityHeading(ped)
		SetVehicleNumberPlateText(vehicle, 'RENTADO')
		TaskWarpPedIntoVehicle(ped,  vehicle, -1)
		bicicleta = vehicle
		if somecar == 'faggio' then
			cobroxMinuto = Config.CobroScooter
			exports["LegacyFuel"]:SetFuel(vehicle, 100.0)
		else
			cobroxMinuto = Config.CobroBike
		end
	end)
	DoScreenFadeIn(3000) 
end

-- Block UI
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		if inMenu then
			local playerPed = PlayerPedId()

			--DisableControlAction(0, 1, true) -- LookLeftRight
			--DisableControlAction(0, 2, true) -- LookUpDown
			DisablePlayerFiring(playerPed, true) -- Disable weapon firing
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
			DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if IsPedOnAnyBike(GetPlayerPed(-1)) then
			local ped = GetPlayerPed(-1)
			local bike = GetVehiclePedIsIn(ped)
			if not havebike and GetVehicleNumberPlateText(bike) == 'BLOQUEAD' then
				helptext('Tekan ~INPUT_CONTEXT~ untuk menyewa kendaraan ini.')
				if IsControlJustPressed(0, Keys['E']) and IsPedOnAnyBike(ped) then
					local bikeProps = ESX.Game.GetVehicleProperties(bike)
					local name = GetDisplayNameFromVehicleModel(bikeProps.model)
					--print(name)
					if name == 'TRIBIKE2' then
						TriggerServerEvent("esx_bike:unblock", Config.PriceTriBike) 
					elseif name == 'SCORCHER' then
						TriggerServerEvent("esx_bike:unblock", Config.PriceScorcher) 
					elseif name == 'CRUISER' then
						TriggerServerEvent("esx_bike:unblock", Config.PriceCruiser) 
					elseif name == 'BMX' then
						TriggerServerEvent("esx_bike:unblock", Config.PriceBmx) 
					end
				end
			end
		end
	end
end)