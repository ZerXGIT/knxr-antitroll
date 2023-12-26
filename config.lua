Config = {}

Config.AdminCommand = "troll" -- The Name of the Admin Command
Config.Rang = "admin"         -- The Rang needed for the Admin Command

Config.HowLong = 60           -- How Long the Player should have antitroll on
Config.TimeToSave = 5         -- How often the time should be saved in the Database

-- SETTING FOR PLAYERS WITH ANTITROLL ON
Config.DisableVDM = true            -- Disables damage from cars while the player still has Troll Protection. (Players still get demage off the ground)
Config.DriveBy = false              -- Activates / Deactivates Drivebys
Config.DisableShooting = false      -- Disables Shooting
Config.DisablePunching = true       -- Disables hitting for players still in troll protect mode
Config.DisablePunchingDamage = true -- Disables the Damage other would get with Fists when they get Punshed

Config.Framework = "QBCore"         -- The Framework you are using (ESX, QBCore)

FrameworkObject = nil

function GetFrameworkObject()
    if Config.Framework == "ESX" then
        FrameworkObject = exports["es_extended"]:getSharedObject()
        -- Old ESX Support
        if not FrameworkObject then
            TriggerEvent('esx:getSharedObject', function(obj) FrameworkObject = obj end)
        end

        return exports["es_extended"]:getSharedObject()
    elseif Config.Framework == "QBCore" then
        FrameworkObject = exports['qb-core']:GetCoreObject()
        return exports['qb-core']:GetCoreObject()
    end
end

-- Server Functions
function GetPlayerIdentifier(id)
    if Config.Framework == "ESX" then
        return FrameworkObject.GetPlayerFromId(id).identifier
    elseif Config.Framework == "QBCore" then
        return FrameworkObject.Functions.GetIdentifier(id, 'license')
    end
end
