local machineGlobal = {}
local machineStart = {}
local robberyOngoing = false
local moneyHeist = {}
local contadorJoalheria = 0
local version = '2.0'

function vRPReceiver.startMachine(id,roubo,x,y,z)
	local source = source
	local user_id = getUserId(source)
	if user_id then
		if config.roubos[roubo] then
			local copAmount = getNumPolice()
			if parseInt(#copAmount) < parseInt(config.roubos[roubo].qtdPolice) then
				notify(source,"aviso","Policia insuficiente no momento.",5000)
				return false
			elseif parseInt(machineGlobal[roubo]) > 0 then
				notify(source,"aviso","Aguarde "..getTimers(parseInt(machineGlobal[roubo])),5000)
				return false
			elseif parseInt(machineGlobal[id]) > 0 then
				notify(source,"aviso","Aguarde "..getTimers(parseInt(machineGlobal[id])),5000)
				return false
			else
				if roubo == "registradora" then
					machineGlobal[id] = parseInt(config.roubos[roubo].cooldown)
				else
					machineGlobal[roubo] = parseInt(config.roubos[roubo].cooldown)
				end
				searchTimer(user_id,parseInt(config.roubos[roubo].procurado))
				callPolice(source,roubo,x,y,z)
				if config.roubos[roubo]['item'] then
					tryGetInventoryItem(user_id,config.roubos[roubo]['item'],1,true)
				end
				return true
			end
		end
	end
	return false
end

function vRPReceiver.checkitens(roubo)
	local source = source
	local user_id = getUserId(source)
	local item = config.roubos[roubo]['item'] or nil
	if user_id then
		if item then
			if getInventoryItemAmount(user_id,item) >= 1 then
				return true
			else
				notify(source,"negado","Precisa do item <b>"..item.."</b>",5000)
				return false	
			end
		else
			return true		
		end
	end
	return false
end

function vRPReceiver.startJoalheria(id,roubo,x,y,z)
	local source = source
	local user_id = getUserId(source)
	if user_id then
		if parseInt(machineGlobal[id]) > 0 then
			notify(source,"aviso","Aguarde "..getTimers(parseInt(machineGlobal[id])),5000)
			return false
		else
			machineGlobal[id] = parseInt(config.roubos[roubo].cooldown)
			return true
		end
	end
	return false
end

function vRPReceiver.startJoalheriaC()
	local source = source
	local user_id = getUserId(source)
	if user_id then
		notify(source,"sucesso","Sistema de Segurança Desligado.",5000)
		contadorJoalheria = 1800
		vRPSend.joalheriaAtivador(-1,true)
	end
end

function callPolice(source,roubo,x,y,z)
	local source = source
	local user_id = getUserId(source)
	local name = getName(user_id)
	local copAmount = getNumPolice()
	log(config.webhookroubo,"```Roubos\n[ID]: "..user_id.." "..name.." \nInicio um roubo a "..roubo..".\n local "..x..","..y..","..z.."```")		
	if roubo == "registradora" then
		local random = math.random(1,100)
		if random <= 10 then
			return
		end
	end
	PlayAudio(source,'alarm',0.7)
	for l,w in pairs(copAmount) do
		local player = getUserSource(parseInt(w))
		if player then
			async(function()
				notifyPolicia(player,roubo,x,y,z)
			end)
		end
	end
end

function vRPReceiver.stopMachine(roubo,x,y,z)
	local source = source
	if source then
		dropItens(source,roubo,x,y,z)
	end
end

function vRPReceiver.payment(roubo)
	local source = source
	local user_id = getUserId(source)
	if user_id then
		local policia = getNumPolice()
		local random = math.random(config.roubos[roubo].min,config.roubos[roubo].max)
		local valor = parseInt((random/config.roubos[roubo].time) + parseInt(#policia * 20))
		giveInventoryItem(user_id,config.item_recompensa,valor,true)
	end
end

Citizen.CreateThread(function()
	while true do
		for k,v in pairs(machineGlobal) do
			if parseInt(machineGlobal[k]) > 0 then
				machineGlobal[k] = parseInt(machineGlobal[k]) - 1
			end
			if v == 0 then
				machineGlobal[k] = nil
			end
		end
		if contadorJoalheria > 0 then
			contadorJoalheria = contadorJoalheria - 1
			if contadorJoalheria == 0 then
				vRPSend.joalheriaAtivador(-1,false)
			end
		end
		Citizen.Wait(1000)
	end
end)

function vRPReceiver.StartBankRobbery(bankId)
	local source = source
	local user_id = getUserId(source)
	if user_id then
		local name = getName(user_id)
		local x,y,z = vRPSend.getPosition(source)
		robberyOngoing = true
		TriggerClientEvent("q_roubos:openDoor",-1,bankId)
		TriggerClientEvent("q_roubos:startRobbery",-1,bankId,robberyOngoing)
		callPolice(source,bankId,x,y,z)
		log(config.webhookroubo,"```Roubos\n[ID]: "..user_id.." "..name.." \n Inicio o Roubo a "..bankId.."\nlocal "..x..","..y..","..z.."```")
	end
end

function vRPReceiver.EndBankRobbery(bankId)
    TriggerClientEvent("q_roubos:endRobbery",-1,bankId)
end

function vRPReceiver.ResetMoney(bankId)
	moneyHeist[bankId] = nil
end

function vRPReceiver.CheckPayment(bankId)
	local source = source
    local user_id = getUserId(source)
    if user_id then
        if parseInt(moneyHeist[bankId]) <= parseInt(config.roubos[bankId].Money) then
            local cashRecieved = math.random(5500,8000)
            moneyHeist[bankId] = parseInt(moneyHeist[bankId]) + cashRecieved
            giveInventoryItem(user_id,config.item_recompensa,cashRecieved,true)
        else
            TriggerClientEvent("q_roubos:deleteEntity",source)
			notify(source,"negado","O cofre está vazio.")
        end
    end
end

function vRPReceiver.CheckPolice(bankId)
    local source = source
    local user_id = getUserId(source)
    if user_id then
        local policia = getNumPolice()
        if #policia <= parseInt(config.roubos[bankId].qtdPolice) then
            notify(source,"aviso","Número insuficiente de policiais no momento.",8000)
            return false
        elseif parseInt(machineGlobal[bankId]) > 0 then
            notify(source,"aviso","Os cofres estão vazios, aguarde <b>"..getTimers(parseInt(machineGlobal[bankId])).." segundos</b> até que os civis efetuem depositos.",8000)
            return false
        end
    end
    return true
end

function vRPReceiver.stopJoalheria()
	local source = source
	local user_id = getUserId(source)
	if user_id then
		local table = config.roubos["joalheria"]
		local random = math.random(#table.itens)
		local random2 = math.random(table.min,table.max)
		giveInventoryItem(user_id,table.itens[random],random2,true)
	end
end

function log(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

function getTimers(seconds)
	local days = math.floor(seconds/86400)
	seconds = seconds - days * 86400
	local hours = math.floor(seconds/3600)
	seconds = seconds - hours * 3600
	local minutes = math.floor(seconds/60)
	seconds = seconds - minutes * 60

	if days > 0 then
		return string.format("%d Dias, %d Horas, %d Minutos é %d Segundos",days,hours,minutes,seconds)
	elseif hours > 0 then
		return string.format("%d Horas,%d Minutos é %d Segundos",hours,minutes,seconds)
	elseif minutes > 0 then
		return string.format("%d Minutos é %d Segundos",minutes,seconds)
	elseif seconds > 0 then
		return string.format("%d Segundos",seconds)
	end
end