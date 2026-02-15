local isOpen = false
local QBCore = exports['qb-core']:GetCoreObject()



RegisterCommand('mdt', function()
    isOpen = not isOpen
    SendNUIMessage({ action = 'setVisible', data = isOpen })
    SetNuiFocus(isOpen, isOpen)
end, false)

RegisterKeyMapping('mdt', 'Ouvrir le MDT', 'keyboard', 'F5')

RegisterNUICallback('hideUI', function(_, cb)
    isOpen = false
    SendNUIMessage({ action = 'setVisible', data = false })
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    if cb then cb({}) end
end)

-- Dev helper remains available
RegisterCommand('svelte:show', function()
    isOpen = true
    SendNUIMessage({ action = 'setVisible', data = true })
    SetNuiFocus(true, true)
end)

RegisterNUICallback("mdt:getDashboard", function(_, cb)
    local src = source
    -- TODO: fetch server data via callback/event
    local data = {
        counters = { incidents = 0, open = 0, investigation = 0 },
        recents = {}
    }

    SendNUIMessage({ action = "mdt:setDashboard", data = data })
    cb({ ok = true })
end)

RegisterNUICallback("searchVehicles", function(data, cb)
    local query = (data and data.query) or ""

    QBCore.Functions.TriggerCallback("tg-mdt:server:searchVehicles", function(result)
        cb(result or {})
    end, query)
end)

RegisterNUICallback("searchProfiles", function(data, cb)
    local query = (data and data.query) or ""
    query = tostring(query)

    QBCore.Functions.TriggerCallback("tg-mdt:server:searchProfiles", function(result)
        cb(result or {})
    end, query)
end)