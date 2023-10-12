function playAnim(stat,anim,dir,stats)
    if config.framework == 'creativev5' then
        vRP._playAnim(stat,{anim,dir},stats)
    else
        vRP._playAnim(stat,{{anim,dir}},stats)
    end
end

function DeletarObjeto()
    if config.framework == 'creativev5' then
        vRP.removeObjects()
    else
        vRP.DeletarObjeto()
    end
end

function stopAnim(status)
    vRP._stopAnim(status)
end

function notify(tipo,text,time)
    if config.framework == 'creativev5' then
        if tipo == "sucesso" then tipo = "verde"
        elseif tipo == "negado" then tipo = "vermelho"
        elseif tipo == "aviso" then tipo = "azul"
        end
    end
    TriggerEvent("Notify",tipo,text,time)
end

function dropItens(item,amount,x,y,z)
    TriggerServerEvent("inventory:Drops",item,nil,amount,x,y,z)
end