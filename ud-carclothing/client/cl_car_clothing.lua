
RegisterNetEvent('ud-carclothing:EnterVehicleColor', function(data)
    exports['ud_ui']:openApplication('textbox', {
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
            TriggerEvent('DoLongHudText', "No vehicle found nearby.")
            return
        end

        loadAnimDict(animDict1)
        TaskPlayAnim(ped, animDict1, animation1, 1.0, 4.0, -1, 49, 0, false, false, false)

        while true do
            local finished = exports["ud_taskbar"]:taskBar(10000, "Getting Spray Ready...", false)
            if finished == 100 then
                break
            end
            Citizen.Wait(0)
        end

        ClearPedTasks(ped)
        loadAnimDict(animDict2)
        TaskPlayAnim(ped, animDict2, animation2, 1.0, 4.0, -1, 49, 0, false, false, false)

        while true do
            local finished = exports["ud_taskbar"]:taskBar(10000, "Changing Color...", false)
            if finished == 100 then
                break
            end
            Citizen.Wait(0)
        end

        ClearPedTasks(ped)

        SetVehicleColours(vehicle, color.primary, color.secondary)

        TriggerEvent('DoLongHudText', "Vehicle color set to "..colorName..".", 1)
        local plate = GetVehicleNumberPlateText(vehicle)
        TriggerServerEvent('saveCarColor', plate, tostring(colorName))
    else
        TriggerEvent('DoLongHudText', "Color "..colorName.." not found.")
    end
end)

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

AddEventHandler("ud_inventory:itemUsed", function (item, info)
    if item ~= "vehiclepaint" then return end
    TriggerEvent('ud-carclothing:EnterVehicleColor')
end)

--[[RegisterCommand('changecolor', function()
    TriggerEvent('ud-carclothing:EnterVehicleColor')
end)--]]