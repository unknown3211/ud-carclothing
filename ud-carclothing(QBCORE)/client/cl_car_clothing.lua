local QBCore = exports['qb-core']:GetCoreObject()

RegisterCommand('carclothing', function()
    TriggerEvent('ud-carclothing:EnterVehicleColor')
end)

RegisterNetEvent('ud-carclothing:EnterVehicleColor', function(data)
    exports['np-ui']:openApplication('textbox', {
        callbackUrl = 'ud-carclothing:ChangeCarColors',
        key = 1,
        items = {
          {
            icon = "car",
            label = "Vehicle Color",
            name = "udvehiclecolor",
          },
        },
        show = true,
    })
end)

local animDict1 = 'switch@franklin@lamar_tagging_wall'
local animation1 = 'lamar_tagging_wall_loop_lamar'
local animDict2 = 'switch@franklin@lamar_tagging_wall'
local animation2 = 'lamar_tagging_exit_loop_lamar'

RegisterUICallback('ud-carclothing:ChangeCarColors', function(data, cb)
    cb({ data = {}, meta = { ok = true, message = '' } })
    local colorName = data.values.udvehiclecolor:lower()
    local color = Config.ColorMap[colorName]

    if color then
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local vehicle = GetClosestVehicle(pos.x, pos.y, pos.z, 5.0, 0, 71)

        if vehicle == 0 then
            TriggerEvent('QBCore:Notify', "No vehicle found nearby.", 'error')
            return
        end

        loadAnimDict(animDict1)
        TaskPlayAnim(ped, animDict1, animation1, 1.0, 4.0, -1, 49, 0, false, false, false)

        QBCore.Functions.Progressbar("getspray", "Getting Spray Ready...", 7000, false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = false,
        })
        Citizen.Wait(7000)

        ClearPedTasks(ped)
        loadAnimDict(animDict2)
        TaskPlayAnim(ped, animDict2, animation2, 1.0, 4.0, -1, 49, 0, false, false, false)

        QBCore.Functions.Progressbar("changecolor", "Changing Color...", 7000, false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = false,
        })
        Citizen.Wait(7000)

        ClearPedTasks(ped)

        SetVehicleColours(vehicle, color.primary, color.secondary)

        TriggerEvent('QBCore:Notify', "Vehicle color set to "..colorName..".", 'success')
        local plate = GetVehicleNumberPlateText(vehicle)
        TriggerServerEvent('saveCarColor', plate, tostring(colorName))
    else
        TriggerEvent('QBCore:Notify', "Color "..colorName.." not found.", 'error')
    end
end)

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end
