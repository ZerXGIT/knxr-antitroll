print([[^1
     _   _  _ _____ ___   _____ ___  ___  _    _    
    /_\ | \| |_   _|_ _| |_   _| _ \/ _ \| |  | |   
   / _ \| .` | | |  | |    | | |   / (_) | |__| |__ 
  /_/ \_\_|\_| |_| |___|   |_| |_|_\\___/|____|____|
          ^8by ZerX (github.com/ZerXGIT)^0
^0---------------------[^2Tests^0]---------------------]])


-- old esx Support
if not ESX then
    ESX = nil
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
end

testPrint("Oxmysql is installed.", "Oxmysql is not installed!", tests.checkForOxmysql())
testPrint("ESX is installed.", "ESX is not installed!", tests.checkForESX())
testPrint("Config found.", "Config not found!", tests.checkForConfig())
print([[^0---------------------[^2Tests^0]---------------------]])

if tests.checkForOxmysql() and tests.checkForESX() and tests.checkForConfig() then
    cPrint("All tests passed!", "info")
else
    cPrint("^1One or more tests failed!^0", "error")
    return
end

createTableIfNotExist()

ESX.RegisterCommand(getCommandString(), getCommandRang(), function(xPlayer, args, showError)
    local id = args.id
    local target = id

    if not target then 
        cPrint("Player not found!", "error")
        return
    end

    target.triggerEvent("knxr-antitroll:toggle")
    cPrint("Troll protection enabled for " .. target.name .. " for " .. Config.HowLong .. " min!", "info")
end, true, {help = "Toggle Troll Protection", arguments = {{name = "id", help = "Player ID", type = "player"}}})


RegisterCommand(getCommandString(), function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, "mod") then
        local id = args.id
        local target = id
    
        if not target then 
            cPrint("Player not found!", "error")
            return
        end
    
        target.triggerEvent("knxr-antitroll:toggle")
        cPrint("Troll protection enabled for " .. target.name .. " for " .. Config.HowLong .. " min!", "info")    else
        cPrint("You don't have permission to use this command!", "error")
    end
end, true)


RegisterNetEvent("knxr-antitroll:updateTime", function(time)
    local target = ESX.GetPlayerFromId(source)
    local identifier = target.getIdentifier()

    updateOrInsert(identifier, time)
end)

RegisterNetEvent("knxr-antitroll:onjoin", function(isNew)
    local target = ESX.GetPlayerFromId(source)
    local identifier = target.getIdentifier()

    if isNew then
        target.triggerEvent("knxr-antitroll:toggle", true)
        return
    end

    local time = getTimeLeft(identifier)

    if time > 0 then
        target.triggerEvent("knxr-antitroll:toggle", true, time)
        return
    end
    
    updateOrInsert(identifier, time)
end)