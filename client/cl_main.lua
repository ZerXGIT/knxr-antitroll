-- old esx Support
if not ESX then
    ESX = nil
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    while ESX == nil do
        Citizen.Wait(0)
    end
end

hasProtection = false
timeLeft = 0

-- STATIC VARIABLES
timeToSafe = Config.TimeToSave

RegisterNetEvent("knxr-antitroll:toggle", function(toggle, timeOverride)
    hasProtection = toggle or not hasProtection
    timeLeft = timeOverride or Config.HowLong

    if hasProtection then
        startAntiTroll()
    else
        stopAntiTroll()
        updateTimeToDatabase(0)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded',function(xPlayer, isNew, skin)
    TriggerServerEvent("knxr-antitroll:onjoin", isNew)
end)

AddEventHandler("onResourceStart", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        TriggerServerEvent("knxr-antitroll:onjoin", false)
    end
end)