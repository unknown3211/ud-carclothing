
RegisterServerEvent('saveCarColor')
AddEventHandler('saveCarColor', function(plate, color)
    print("Plate: " .. tostring(plate))
    print("Color: " .. tostring(color))
    local src = source
    local user = exports["ud_base"]:getModule("Player"):GetUser(source)
    exports.oxmysql:execute('INSERT INTO car_colors (plate, color) VALUES (@plate, @color) ON DUPLICATE KEY UPDATE color = @color',{
        ['@plate']   = plate,
        ['@color']  = color,
    })
end)
