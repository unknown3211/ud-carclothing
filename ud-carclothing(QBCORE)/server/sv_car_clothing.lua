local QBCore = exports['qb-core']:GetCoreObject()


RegisterServerEvent('saveCarColor')
AddEventHandler('saveCarColor', function(plate, color)
    print("Plate: " .. tostring(plate))
    print("Color: " .. tostring(color))
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    exports.oxmysql:execute('INSERT INTO car_colors (plate, color) VALUES (@plate, @color) ON DUPLICATE KEY UPDATE color = @color',{
        ['@plate']   = plate,
        ['@color']  = color,
    })
end)

QBCore.Functions.CreateUseableItem("vehiclepaint", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName(item.name) then
        TriggerClientEvent('ud-carclothing:EnterVehicleColor', src)
    end
end)