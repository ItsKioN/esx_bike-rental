RegisterServerEvent("esx_bike:lowmoney")
AddEventHandler("esx_bike:lowmoney", function(money, bike)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= money then
		xPlayer.removeMoney(money)
		TriggerClientEvent('esx_bike:spawnBike', source, bike)
		xPlayer.showNotification(_U('bikes')..' '.._U('bike_pay', money))
	else
		xPlayer.showNotification('Kamu tidak punya cukup uang!')
	end
end)

RegisterServerEvent("esx_bike:unblock")
AddEventHandler("esx_bike:unblock", function(money)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= money then
		xPlayer.removeMoney(money)
		TriggerClientEvent('esx_bike:unblockBike', source)
		xPlayer.showNotification(_U('bikes')..' '.._U('bike_pay', money))
	else
		xPlayer.showNotification('Kamu tidak punya cukup uang!')
	end
end)

