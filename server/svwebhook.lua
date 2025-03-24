local webhookURLs = {
    police = 'https://discord.com/api/webhooks/1353591374951223367/u8IHhdK2IV31JJCRO69m9eYKzgpqHCS6tZuQ3DCqBXVCbrAP-B7UeN4uOG6gtiomU0b3',
    ambulance = 'https://discord.com/api/webhooks/1267318323876597803/vxfA3mKG9Qt49quMlhFxOv6Ddl1oVKqdyUMo2zOuXX0DvRB_n-VhGuqxiH2eodQNfTop',
    firefighter = 'URL_DEL_WEBHOOK_FIREFIGHTER',
    redcircle = 'https://discord.com/api/webhooks/1269030898117116094/E20ksskhMbg0B7V9mdHJ8R6MpAu9PA4iWKLSPsLuyOKBjEGdneNAj-LtbdNxOwvW-J3c',
    -- Añadir más URLs de webhooks según sea necesario
}

RegisterNetEvent('svwebhook:sendWebhook')
AddEventHandler('svwebhook:sendWebhook', function(job, message)
    local url = webhookURLs[job]
    if url then
        -- Obtener la hora actual
        local currentTime = os.date("%Y-%m-%d %H:%M:%S")
        
        -- Incluir la hora en el mensaje
        local fullMessage = string.format("Hora de entrada a servicio: %s | %s", currentTime, message)
        
        local embed = {
            {
                ["title"] = "NewDay BossMenu",
                ["description"] = fullMessage,
                ["color"] = 16711680, -- Color en formato decimal (rojo)
                ["footer"] = {
                    ["text"] = "Enviado por Sistema"
                }
            }
        }
        PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({embeds = embed}), { ['Content-Type'] = 'application/json' })
    else
        print("No se encontró la URL del webhook para el trabajo: " .. job)
    end
end)