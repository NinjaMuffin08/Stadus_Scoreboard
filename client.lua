local listOn = false
local faketimer = 0
local connectedPlayers = {}
local formattedPlayerList = {}
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(2000)
	ESX.TriggerServerCallback('scoreboard:getPlayers', function(playerTable)
		connectedPlayers = playerTable
		UpdatePlayerTable()
	end)
end)

RegisterNetEvent('scoreboard:updatePlayers')
AddEventHandler('scoreboard:updatePlayers', function(playerTable)
	connectedPlayers = playerTable

	UpdatePlayerTable()
end)

Citizen.CreateThread(function()
	if faketimer >= 3 then
		faketimer = 0
	end

	listOn = false
	while true do
		Citizen.Wait(10)

		if IsControlPressed(0, 178) then
			if not listOn then

				if faketimer >= 2 then
					ESX.TriggerServerCallback('scoreboard:getScoreboard', function(ems, police, taxi, mek, bil, maklare, spelare)

						SendNUIMessage({
							text = table.concat(formattedPlayerList),
							ems = ems,
							police = police,
							taxi = taxi,
							mek = mek,
							bil = bil,
							maklare = maklare,
							spelare = spelare
						})
					end)
					faketimer = 0
				else
					SendNUIMessage({ text = table.concat(formattedPlayerList)})
					faketimer = 0
				end

				listOn = true

				while listOn do
					Citizen.Wait(10)
					if IsControlPressed(0, 178) == false then
						listOn = false
						SendNUIMessage({
							meta = 'close'
						})
						break
					end
				end
			end
		end
	end
end)

function UpdatePlayerTable()
	formattedPlayerList = {}

	for k,v in pairs(connectedPlayers) do
		table.insert(formattedPlayerList, '<tr style=\"color: rgb(' .. 255 .. ', ' .. 255 .. ', ' .. 255 .. ')\"><td>' .. k .. '</td><td>' .. v.name .. '</td></tr>')
	end
end

Citizen.CreateThread(function() -- Thread for timer
	while true do 
		Citizen.Wait(5000)
		faketimer = faketimer + 1
	end
end)