-- Types: info (default), error, warning
local function cPrint(string, type)
    if type == "error" then
        print(("^0[^1Error^0] %s"):format(string))
    elseif type == "info" or not type then
        print(("^0[^2Info^0] %s"):format(string))
    elseif type == "warning" then
        print(("^0[^3Warning^0] %s"):format(string))
    end
end

print([[^1
     _   _  _ _____ ___   _____ ___  ___  _    _    
    /_\ | \| |_   _|_ _| |_   _| _ \/ _ \| |  | |   
   / _ \| .` | | |  | |    | | |   / (_) | |__| |__ 
  /_/ \_\_|\_| |_| |___|   |_| |_|_\\___/|____|____|
          ^8by ZerX (github.com/ZerXGIT)^0
          ]])


CreateThread(function()
    cPrint("Checking if table exists...", "info")
    local result = MySQL.query.await([[create table if not exists antitroll_time
    (
        identifier    varchar(46)   not null,
        hasProtection bit default 0 not null,
        time_left     int default 0 not null,
        constraint `PRIMARY`
            primary key (identifier)
    );]])

    if result.warningStatus == 0 then
        cPrint("Table does not exist but was created!", "warning")
    else
        cPrint("Table exists! :)", "info")
    end
end)

local function getCommandString()
    if type(Config.AdminCommand) ~= "string" then
        cPrint("Config.AdminCommand is not a string, using default value 'troll'", "warning")
        return "troll"
    else
        return string.lower(Config.AdminCommand)
    end 
end

local function getCommandRang()
    if type(Config.Rang) ~= "string" then
        cPrint("Config.Rang is not a string, using default value 'admin'", "warning")
        return "admin"
    else
        return Config.Rang
    end 
end

local function insert(identifier, time)
    MySQL.query.await('insert into antitroll_time (identifier, time_left) values (?, ?)', {identifier, time})
end

local function update(identifier, time)
    MySQL.query.await('update antitroll_time set time_left = ? where identifier = ?', {time, identifier})
end

local function doesUserExist(identifier)
    local result = MySQL.query.await('select * from antitroll_time where identifier = ?', {identifier})
    if result[1] then
        return true
    else
        return false
    end
end

local function getTimeLeft(identifier)
    local result = MySQL.query.await('select * from antitroll_time where identifier = ?', {identifier})

    if result[1] then
        return result[1].time_left
    else
        return 0
    end
end

local function updateOrInsert(identifier, time)
    if doesUserExist(identifier) then
        update(identifier, time)
    else
        insert(identifier, time)
    end
end

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

RegisterNetEvent("knxr-antitroll:updateTime", function(time)
    local _source = source
    local target = ESX.GetPlayerFromId(_source)
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
        print("return")
        target.triggerEvent("knxr-antitroll:toggle", true, time)
        return
    end
    updateOrInsert(identifier, time)
end)