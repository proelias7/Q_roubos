function notifyPolicia(player,roubo,x,y,z)
    vRPclient.playSound(player,"Oneshot_Final","MP_MISSION_COUNTDOWN_SOUNDSET")
    if config.framework == 'quantic' or config.framework == 'vrpex' then
        TriggerClientEvent("NotifyPush",player,{ code = 40, title = "OCORRÊNCIA", x = x, y = y, z = z, badge = "O roubo a <b>"..roubo.."</b>, dirija-se até o local e intercepte os assaltantes." })
    elseif config.framework == 'creativev5' then
        TriggerClientEvent("NotifyPush",player,{ code = 40, title = "OCORRÊNCIA", x = x, y = y, z = z, time = "Recebido às "..os.date("%H:%M"), blipColor = 22 })
    end
end

function notify(source,tipo,text,time)
    if config.framework == 'creativev5' then
        if tipo == "sucesso" then tipo = "verde" end
        if tipo == "negado" then tipo = "vermelho" end
        if tipo == "aviso" then tipo = "azul" end
    end
    TriggerClientEvent("Notify",source,tipo,text,time)
end

function getNumPolice()
    if config.framework == 'quantic' then
        return vRP.getUsersByGroup(config.permPolice)
    elseif config.framework == 'vrpex' then
        return vRP.getUsersByPermission(config.permPolice)
    elseif config.framework == 'creativev5' then
        return vRP.numPermission(config.permPolice)
    end
end

function PlayAudio(source,sound,vol)
    TriggerClientEvent("vrp_sound:source",source,sound,vol)
end

function dropItens(source,roubo,x,y,z)
    if config.roubos[roubo] then
        local max = config.roubos[roubo].max
        local min = config.roubos[roubo].min
        for i = 1, 6 do
            if config.framework == 'quantic' then
                TriggerEvent("DropSystem:create",config.item_recompensa,parseInt(math.random(min,max)),x+math.random(1,6)/8,y+math.random(1,6)/8,z,3600,source)
            elseif config.framework == 'vrpex' then
                TriggerEvent("DropSystem:create",config.item_recompensa,parseInt(math.random(min,max)),x+math.random(1,6)/8,y+math.random(1,6)/8,z,3600,source)
            elseif config.framework == 'creativev5' then
                vRPSend.dropItem(source,config.item_recompensa,parseInt(math.random(min,max)),x+math.random(1,6)/8,y+math.random(1,6)/8,z-1)
            end  
        end
    end
end

function getUserSource(user_id)
    if config.framework == 'creativev5' then
        return vRP.userSource(parseInt(user_id))
    else
        return vRP.getUserSource(parseInt(user_id))
    end
end

function getName(user_id)
    if config.framework == 'creativev5' then
        local identity = vRP.userIdentity(user_id)
        return identity.name.." "..identity.name2
    else
        local identity = vRP.getUserIdentity(user_id)
        return identity.name.." "..(config.framework == 'creative' and identity.name2 or identity.firstname)
    end
end

function getUserId(source)
    return vRP.getUserId(source)
end

function giveInventoryItem(user_id,item,valor,status)
    vRP.giveInventoryItem(user_id,item,valor,status)
end

function tryGetInventoryItem(user_id,item,valor,status)
    vRP.tryGetInventoryItem(user_id,item,valor,status)
end

function getInventoryItemAmount(user_id,item)
    return vRP.getInventoryItemAmount(user_id,item)
end

function searchTimer(user_id,time)
    vRP.searchTimer(user_id,time)
end