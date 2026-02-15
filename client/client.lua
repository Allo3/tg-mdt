local isOpen = false

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
