-- Types: info (default), error, warning
function cPrint(string, type)
    if type == "error" then
        print(("^0[^1Error^0] %s"):format(string))
    elseif type == "info" or not type then
        print(("^0[^2Info^0] %s"):format(string))
    elseif type == "warning" then
        print(("^0[^3Warning^0] %s"):format(string))
    end
end

local spacing = "            "
function testPrint(stringPass, stringFail, passed)
    if passed then
        print(("%s^0[^2✔^0] ^2%s"):format(spacing, stringPass))
    else
        print(("%s^0[^1✖^0] ^1%s"):format(spacing, stringFail))
    end
end

function createTableIfNotExist()
    cPrint("Checking if table exists...", "info")
    MySQL.query([[
    create table if not exists antitroll_time
    (
        identifier    varchar(255)   not null,
        time_left     int default 0 not null,
        constraint `PRIMARY`
            primary key (identifier)
    );]], {}, function(result)
        if result and result.warningStatus == 0 then
            cPrint("Table does not exist but was created!", "warning")
        else
            cPrint("Table exists!", "info")
        end
    end)
end

function getCommandString()
    if type(Config.AdminCommand) ~= "string" then
        cPrint("Config.AdminCommand is not a string, using default value 'troll'", "warning")
        return "troll"
    else
        return string.lower(Config.AdminCommand)
    end
end

function getCommandRang()
    if type(Config.Rang) ~= "string" then
        cPrint("Config.Rang is not a string, using default value 'admin'", "warning")
        return "admin"
    else
        return Config.Rang
    end
end

-- MYSQL STUFF
function insert(identifier, time)
    MySQL.query.await('INSERT IGNORE INTO antitroll_time (identifier, time_left) VALUES (?, ?)', { identifier, time })
end

function update(identifier, time)
    MySQL.query.await('update antitroll_time set time_left = ? where identifier = ?', { time, identifier })
end

function doesUserExist(identifier)
    local result = MySQL.query.await('select * from antitroll_time where identifier = ?', { identifier })
    if result[1] then
        return true
    else
        return false
    end
end

function isNewPlayer(identifier)
    local result = MySQL.query.await('select * from antitroll_time where identifier = ?', { identifier })
    if result[1] then
        return false
    else
        return true
    end
end

function getTimeLeft(identifier)
    local result = MySQL.query.await('select * from antitroll_time where identifier = ?', { identifier })

    if result[1] then
        return result[1].time_left
    else
        return 0
    end
end

function updateOrInsert(identifier, time)
    if doesUserExist(identifier) then
        update(identifier, time)
    else
        insert(identifier, time)
    end
end
