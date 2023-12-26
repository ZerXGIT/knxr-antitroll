tests = {}

function tests.checkForOxmysql()
    if exports.oxmysql then
        return true
    else
        return false
    end
end

function tests.checkForConfig()
    if Config then
        return true
    else
        return false
    end
end

function tests.checkForFramework()
    if GetFrameworkObject() then
        return true
    else
        return false
    end
end
