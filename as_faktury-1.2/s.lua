ESX = exports['es_extended']:getSharedObject()

local allowedJob = 'uwucafe'   -- no dzialac dzila
local allowedJob = 'burgershot' -- dodaj wiecej jesli trzeba  


RegisterCommand('faktura', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local job = xPlayer.getJob().name
    if job ~= allowedJob then
        xPlayer.showNotification('Bro ju dont hef premisjon do waktury.') -- bledy specjalnie jak cos XD
        return
    end

    local amount = tonumber(args[1])
    if not amount or amount <= 0 then
        xPlayer.showNotification('Podaj poprawna kwote.')
        return
    end

    local employeeSociety = 'society_uwu'  
    local employeePercent = 0.2   -- ile % dostaje pracownik

    local societyMoney = math.floor(amount * (1 - employeePercent))
    local employeeMoney = amount - societyMoney

    sendWebhookMessage(xPlayer.getName(), xPlayer.identifier, amount)

    TriggerClientEvent('as_faktura:stworz', source, amount, Config.InvoiceZones, xPlayer.identifier, employeeMoney, employeeSociety)
end, false)

RegisterServerEvent('as_faktura:zaplac')
AddEventHandler('as_faktura:zaplac', function(amount, employeeMoney, employeeSociety)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    if xPlayer.getInventoryItem('money').count >= amount then
        xPlayer.removeInventoryItem('money', amount)
        xPlayer.showNotification('Zaplaciles fakture w wysokosci ' .. amount .. '$')

        xPlayer.addInventoryItem('cash', employeeMoney)
        xPlayer.showNotification('Otrzymales ' .. employeeMoney .. '$ na swoje konto.')

        TriggerEvent('esx_addonaccount:getSharedAccount', employeeSociety, function(account)
            if account then
                account.addMoney(societyMoney)
                xPlayer.showNotification('Przekazałeś ' .. societyMoney .. '$ do ' .. employeeSociety)
            else
                xPlayer.showNotification('Nie udalo sie przekazac pieniedzy  do society ' .. employeeSociety)
            end
        end)

        TriggerClientEvent('as_faktura:odrzucone', -1, amount, employeeMoney, employeeSociety)
    else
        xPlayer.showNotification('Nie masz wystarczajacej ilosci pieniedzy')
    end
end)

function sendWebhookMessage(playerName, playerLicense, amount)
    local webhookURL = Config.WebhookURL
    if webhookURL == '' then return end

    local embed = {
        {
            ["title"] = "AS_FAKTURA",
            ["description"] = string.format("Gracz o nazwie %s i licencji %s utworzyl fakture o cenie %d", playerName, playerLicense, amount),
            ["color"] = 16711680, -- czerwony kolor
        }
    }

    PerformHttpRequest(webhookURL, function(err, text, headers) end, 'POST', json.encode({username = "AS_Faktura", embeds = embed}), { ['Content-Type'] = 'application/json' })
end
