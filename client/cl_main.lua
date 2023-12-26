hasProtection = false
timeLeft = 0

-- STATIC VARIABLES
timeToSafe = Config.TimeToSave

RegisterNetEvent("knxr-antitroll:toggle", function(toggle, timeOverride)
    hasProtection = toggle or not hasProtection
    timeLeft = timeOverride or Config.HowLong

    if hasProtection then
        startAntiTroll()
        updateTimeToDatabase(timeLeft)
    else
        stopAntiTroll()
        updateTimeToDatabase(0)
    end
end)


if Config.Framework == "ESX" then
    RegisterNetEvent("esx:playerLoaded")
    AddEventHandler("esx:playerLoaded", function(xPlayer, isNew, skin)
        TriggerServerEvent("knxr-antitroll:onjoin", isNew)
    end)

    AddEventHandler("onResourceStart", function(resourceName)
        if resourceName == GetCurrentResourceName() then
            TriggerServerEvent("knxr-antitroll:onjoin", false)
        end
    end)
elseif Config.Framework == "QBCore" then
    RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
    AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
        TriggerServerEvent("knxr-antitroll:onjoin", false)
    end)
    RegisterNetEvent("QBCore:Client:OnPlayerUnload")
    AddEventHandler("QBCore:Client:OnPlayerUnload", function()
        stopAntiTroll()
    end)
end
