local currentInvoices = {}

RegisterNetEvent('as_faktura:stworz')
AddEventHandler('as_faktura:stworz', function(amount, zones, employeeIdentifier, employeeMoney, employeeSociety)
    for _, zoneCoords in ipairs(zones) do
        local zoneName = 'faktura_' .. GetPlayerServerId(PlayerId()) .. '_' .. math.random(1000, 9999)
        exports.ox_target:addBoxZone({
            name = zoneName,
            coords = zoneCoords,
            size = vector3(1.5, 1.5, 2),
            rotation = 0,
            options = {
                {
                    name = 'faktura',
                    event = 'as_faktura:zaplac',
                    icon = 'fas fa-money-bill-wave',
                    label = 'Zapłać ' .. amount .. '$',
                    amount = amount,
                    employeeMoney = employeeMoney,
                    employeeSociety = employeeSociety
                }
            }
        })
        table.insert(currentInvoices, zoneName)
    end
end)

RegisterNetEvent('as_faktura:zaplac')
AddEventHandler('as_faktura:zaplac', function(data)
    if data.amount and data.employeeMoney and data.employeeSociety then
        TriggerServerEvent('as_faktura:zaplac', data.amount, data.employeeMoney, data.employeeSociety)
        for _, zone in ipairs(currentInvoices) do
            exports.ox_target:removeZone(zone)
        end
        currentInvoices = {}
    end
end)
