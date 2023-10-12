local machineStart = false
local machineTimer = 0
local machinePosX = 0.0
local machinePosY = 0.0
local machinePosZ = 0.0
local objectBomb = nil
local robberyOngoing = false
local CashPile = nil
local bankBank = ""
local bankX = 0.0
local bankY = 0.0
local bankZ = 0.0
local laptop = nil
local processo = false
local andamento = false
local andamentojoalheria = false
local segundos = 0
local atualRoubo = nil

RegisterNetEvent("q_roubos:start")
AddEventHandler("q_roubos:start",function()
	local ped = PlayerPedId()
	if not machineStart then
		if not IsPedInAnyVehicle(ped) then
			for k,v in pairs(config.locs) do
				if config.roubos[v.roubo] then
					if #(GetEntityCoords(ped) - vector3(v.x,v.y,v.z)) <= 0.6 and not machineStart and config.roubos[v.roubo].item == "c4" and v.roubo ~= "joalheria" then
						if vRPSend.checkitens(v.roubo) then
							if vRPSend.startMachine(v.id,v.roubo,v.x,v.y,v.z) then
								machinePosX = v.x
								machinePosY = v.y
								machinePosZ = v.z
								atualRoubo = v.roubo
								SetEntityHeading(ped,v.h)
								TriggerEvent("cancelando",true)
								SetEntityCoords(ped,v.x,v.y,v.z-1)
								playAnim(false,"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer",true)
								startthreadmachinestart(v.roubo,config.roubos[v.roubo].item,true)
								machineTimer = parseInt(config.roubos[v.roubo].time+7)
								machineStart = true
								segundos = parseInt(config.roubos[v.roubo].time)
								time()
								repeat
									if segundos > 0 then	
										drawTxt("FALTAM ~b~"..segundos.."~w~ SEGUNDOS PARA FINALIZAR ~r~Z~w~ CANCELAR",4,0.29,0.93,0.50,255,255,255,180)
									end
									Citizen.Wait(5)
								until segundos == 0
								notify('sucesso','Bomba armada!',5000)
								DeletarObjeto()
								stopAnim(false)
								TriggerEvent("cancelando",false)
								local mHash = GetHashKey("prop_c4_final_green")
								RequestModel(mHash)
								while not HasModelLoaded(mHash) do
									RequestModel(mHash)
									Citizen.Wait(10)
								end
								local coords = GetOffsetFromEntityInWorldCoords(ped,0.0,0.23,0.0)
								objectBomb = CreateObjectNoOffset(mHash,coords.x,coords.y,coords.z-0.23,true,false,false)
								SetEntityAsMissionEntity(objectBomb,true,true)
								FreezeEntityPosition(objectBomb,true)
								SetEntityHeading(objectBomb,v.h)
								SetModelAsNoLongerNeeded(mHash)
							end
						end
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		local wait = 1000
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) and not andamento then
			for k,v in pairs(config.locs) do 
				if config.roubos[v.roubo] then
					if #(GetEntityCoords(ped) - vector3(v.x,v.y,v.z)) <= 1 and config.roubos[v.roubo].item ~= 'c4' and v.roubo ~= "joalheria" then
						wait = 5
						drawTxt("PRESSIONE  ~g~G~w~  PARA INICIAR O ROUBO",4,0.5,0.93,0.50,255,255,255,180)
						if IsControlJustPressed(0,47) and vRPSend.checkitens(v.roubo) then
							if vRPSend.startMachine(v.id,v.roubo,v.x,v.y,v.z) then 
								machineTimer = parseInt(config.roubos[v.roubo].time)
								machineStart = true
								startthreadmachinestart(v.roubo,config.roubos[v.roubo].item)
								if v.roubo == "registradora" then
									playAnim(false,"oddjobs@shop_robbery@rob_till","loop",true)
								else
									animacaoroubo(true,v.roubo)
								end
								andamento = true
								machinePosX = v.x
								machinePosY = v.y
								machinePosZ = v.z
								atualRoubo = v.roubo
								SetEntityHeading(ped,v.h)
								TriggerEvent("cancelando",true)
								FreezeEntityPosition(ped,true)
								SetEntityCoords(ped,v.x,v.y,v.z-1)
								segundos = parseInt(config.roubos[v.roubo].time)
								time()
								repeat
									if segundos > 0 then	
										drawTxt("FALTAM ~b~"..segundos.."~w~ SEGUNDOS PARA FINALIZAR ~r~Z~w~ CANCELAR",4,0.29,0.93,0.50,255,255,255,180)
									end
									Citizen.Wait(5)
								until segundos == 0
								animacaoroubo(false,v.roubo)
								andamento = false
							end
						end
					end	
				end
			end
		end
		Citizen.Wait(wait)
	end
end)

function roubandojoias()
	Citizen.CreateThread(function()
		while true do
			local wait = 1000
			local ped = PlayerPedId()
			if andamentojoalheria then
				if not IsPedInAnyVehicle(ped) then
					for k,v in pairs(config.locs) do
						if config.roubos[v.roubo] then
							if #(vector3(v.x,v.y,v.z) - GetEntityCoords(ped)) <= 1 and v.roubo == "joalheria" then
								wait = 5
								drawTxt("~g~E~w~  PARA PEGAR AS JOIAS",4,0.5,0.93,0.50,255,255,255,180)
								if IsControlJustPressed(0,38) then
									if vRPSend.startJoalheria(v.id,v.roubo,v.x,v.y,v.z) then
										machineTimer = parseInt(config.roubos[v.roubo].time)
										machineStart = true
										startthreadmachinestart(v.roubo,config.roubos[v.roubo].item,true)
										playAnim(false,"oddjobs@shop_robbery@rob_till","loop",true)
										andamento = true
										machinePosX = v.x
										machinePosY = v.y
										machinePosZ = v.z
										atualRoubo = v.roubo
										SetEntityHeading(ped,v.h)
										TriggerEvent("cancelando",true)
										FreezeEntityPosition(ped,true)
										SetEntityCoords(ped,v.x,v.y,v.z-1)
										segundos = parseInt(config.roubos[v.roubo].time)
										time()
										repeat
											if segundos > 0 then	
												drawTxt("FALTAM ~b~"..segundos.."~w~ SEGUNDOS PARA FINALIZAR",4,0.29,0.93,0.50,255,255,255,180)
											end
											Citizen.Wait(5)
										until segundos == 0
										animacaoroubo(false,v.roubo)
										andamento = false
									end
								end
							end	
						end
					end
				end
			else
				break	
			end
			Citizen.Wait(wait)
		end
	end)
end

Citizen.CreateThread(function()
	while true do
		local wait = 1000
		local ped = PlayerPedId()
		if #(vector3(-631.44,-230.28,38.06) - GetEntityCoords(ped)) <= 1.1 and not andamento then
			wait = 5
			drawTxt("~b~E~w~  PARA HACKEAR",4,0.5,0.93,0.50,255,255,255,180)
			if IsControlJustPressed(0,38) and not IsPedInAnyVehicle(ped) then
				if vRPSend.checkitens("joalheria") then
					if vRPSend.startMachine(nil,"joalheria",-631.44,-230.28,38.06) then 
						HackAnimStart(-631.44,-230.28,38.06,215.44)
						TriggerEvent("mhacking:show")
						TriggerEvent("mhacking:start",3,60, function (success,time) 
							mycallback("joalheria",success,time) 
						end)
					end
				end
			end
		end
		Citizen.Wait(wait)
	end
end)

function vRPReceiver.joalheriaAtivador(status)
	if status then
		andamentojoalheria = true
		roubandojoias()
	else
		andamentojoalheria = false
	end
end

function time()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1000)
			if segundos > 0 then 
				segundos = segundos - 1
			else
				break
			end
		end
	end)
end
--CANCELANDO
Citizen.CreateThread(function()
	while true do
		wait = 1000
		if segundos > 0 then 
			wait = 10
			if IsControlJustPressed(0,20) then
				animacaoroubo(false,atualRoubo)
				andamento = false
				segundos = 0
				machineStart = false
				machineTimer = 0
				atualRoubo = nil
			end
		end
		Citizen.Wait(wait)
	end
end)

function animacaoroubo(play,roubo)
	local ped = PlayerPedId()
	if play then
		playAnim(false,"anim@heists@ornate_bank@grab_cash_heels","grab",true)
		SetPedComponentVariation(ped, 5, 0, 0, 0)
		mochila = CreateObject(GetHashKey("prop_cs_heist_bag_01"),GetEntityCoords(ped)+20, true, true)
		SetEntityAsMissionEntity(mochila, true, true)
		AttachEntityToEntity(mochila,ped,GetPedBoneIndex(ped,57005), -0.10, 0.05, -0.48, 300.0, 200.0, 300.0, true, true, false, true, 1, true)
	else
		if roubo ~= "registradora" then
			setMochila()
		end
		TriggerEvent("cancelando",false)
		FreezeEntityPosition(ped,false)
		DeleteEntity(mochila)
		ClearPedTasks(ped)
		DeletarObjeto()
		stopAnim(false)
	end
end

function setMochila()
	local ped = PlayerPedId()
	if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then
		local mochila = config.mochila['masculina']
		SetPedComponentVariation(ped,5,mochila[1],mochila[2],0)
	else
		local mochila = config.mochila['feminina']
		SetPedComponentVariation(ped,5,mochila[1],mochila[2],0)
	end
end

function startthreadmachinestart(nome,item,roubo)
	Citizen.CreateThread(function()
		while true do
			if machineStart and machineTimer > 0 then
				machineTimer = machineTimer - 1
				if machineTimer <= 0 then
					machineStart = false
					if item == 'c4' then
						DeleteEntity(objectBomb)
						AddExplosion(machinePosX,machinePosY,machinePosZ,2,100.0,true,false,true)
						vRPSend.stopMachine(nome,machinePosX,machinePosY,machinePosZ)
					else
						if roubo == true then
							vRPSend.stopJoalheria()
						end
					end
					break
				else
					if roubo ~= true then
						vRPSend.payment(nome)
						atualRoubo = nil
					end				
				end
			else
				break
			end
			Citizen.Wait(1000)
		end
	end)
end

Citizen.CreateThread(function()
	ResetDoors()
    while true do
		wait = 1000
		if not robberyOngoing then
			for bank,values in pairs(config.BankHeists) do
				local StartPosition = values["Start_Robbing"]
				if #(GetEntityCoords(PlayerPedId()) - vector3(StartPosition["x"],StartPosition["y"],StartPosition["z"])) <= 0.9 then
					wait = 5
					drawTxt("PRESSIONE  ~b~E~w~  PARA HACKEAR",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) then
						if vRPSend.CheckPolice(bank) then
							if vRPSend.checkitens(bank) then
								HackAnimStart(StartPosition["x"],StartPosition["y"],StartPosition["z"],StartPosition["h"])
								TriggerEvent("mhacking:show")
								TriggerEvent("mhacking:start",3,60, function (success,time) 
									mycallback(bank,success,time) 
								end)
								bankBank = bank
								bankX = StartPosition["x"]
								bankY = StartPosition["y"]
								bankZ = StartPosition["z"]
								atualRoubo = bank
							end
						end
					end
				end
			end
		end       
		Citizen.Wait(wait)                                                                     
	end
end)

function resetM()
	Citizen.CreateThread(function()
		while true do
			local kswait = 1000
			if robberyOngoing then
				local ped = PlayerPedId()
				local x,y,z = table.unpack(GetEntityCoords(ped))
				local distance = Vdist(x,y,z,bankX,bankY,bankZ)
				if distance >= 30 then
					kswait = 5
					robberyOngoing = false
					vRPSend.ResetMoney(bankBank)
					DeleteEntity(CashPile)
				end
			else
				break
			end 
			Citizen.Wait(kswait)
		end
	end)
end

function mycallback(bank,success,time)
    if success then
        TriggerEvent("mhacking:hide")
		if bank ~= "joalheria" then
       		vRPSend.StartBankRobbery(bank)
		else
			vRPSend.startJoalheriaC(bank)
        end
		HackAnimStop()
        TriggerEvent('cancelando',false)
	else
        TriggerEvent("mhacking:hide")
        HackAnimStop()
		TriggerEvent('cancelando',false)
	end
end

function HackAnimStart(x,y,z,h)
    local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local card_hash = GetHashKey("prop_cs_credit_card")
	local lap_hash = GetHashKey("prop_laptop_lester")
	local bagHash1 = GetHashKey('prop_cs_heist_bag_01')
	loadModel(bagHash1)
	loadModel(lap_hash)
	lapentity = CreateObject(lap_hash, coords+20, false, false)
	bagProp1 = CreateObject(bagHash1, coords+20, true, false)
	SetEntityAsMissionEntity(bagProp1, true, true)
	local boneIndexf3 = GetPedBoneIndex(ped, 0x49D9)
	local bagIndex3 = GetPedBoneIndex(ped, 57005)
	Wait(500)
	SetPedComponentVariation(ped, 5, 0, 0, 0)
	AttachEntityToEntity(bagProp1, ped, bagIndex3, -0.10, 0.05, -0.48, 300.0, 200.0, 300.0, true, true, false, true, 1, true)
	RequestAnimDict('anim@heists@ornate_bank@hack')
	while not HasAnimDictLoaded('anim@heists@ornate_bank@hack') do
		Wait(10)
	end
	playAnim(false,'anim@heists@ornate_bank@hack','hack_enter',false)
	Wait(3000)
	FreezeEntityPosition(cardentity,1)
	Wait(4500)
	DetachEntity(bagProp1,1,1)
	PlaceObjectOnGroundProperly(bagProp1)
	SetEntityRotation(bagProp1, 0, 0, 230, 1)
	FreezeEntityPosition(bagProp1, true)
	SetEntityAsMissionEntity(bagProp1, true, true)
	playAnim(false,'anim@heists@ornate_bank@hack','hack_loop',true)
	Wait(700)
	AttachEntityToEntity(lapentity, ped, boneIndexf3, 0.20, 0.00, 0.05, 0.0, 180.0, 120.0, 1, 1, 1, 1, 1, 1)
	Wait(500)
	DetachEntity(lapentity,1,1)
	FreezeEntityPosition(lapentity,1)
end

function HackAnimStop()
	local ped = PlayerPedId()
	DeleteEntity(lapentity)
	DeleteEntity(bagProp1)
	ClearPedTasks(ped)
	setMochila()   
end

RegisterNetEvent("q_roubos:startRobbery")
AddEventHandler("q_roubos:startRobbery",function(bankId,robberyOngoing)
    StartRobbery(bankId,robberyOngoing)
	resetM()
end)

RegisterNetEvent("q_roubos:deleteEntity")
AddEventHandler("q_roubos:deleteEntity",function(robberyOngoing)
    DeleteEntity(CashPile)
	processo = false
end)

RegisterNetEvent("q_roubos:endRobbery")
AddEventHandler("q_roubos:endRobbery",function(bankId,robberyOngoing)
	processo = false
end)

function StartRobbery(bankId,robberyOngoing)
	processo = true
	local CashPosition = config.BankHeists[bankId]["Cash_Pile"]
	loadModel("bkr_prop_bkr_cashpile_04")
	loadAnimDict("anim@heists@ornate_bank@grab_cash_heels")
	CashPile = CreateObject(GetHashKey("bkr_prop_bkr_cashpile_04"),CashPosition["x"],CashPosition["y"],CashPosition["z"],false)
	PlaceObjectOnGroundProperly(CashPile)
	SetEntityRotation(CashPile,0,0,CashPosition["h"],2)
	FreezeEntityPosition(CashPile, true)
	SetEntityAsMissionEntity(CashPile,true,true)
	Citizen.CreateThread(function()
		while robberyOngoing and processo == true do
			wait = 1000
			local Cash = config.BankHeists[bankId]["Money"]
			local ped = PlayerPedId()
			local distanceCheck = Vdist(CashPosition["x"],CashPosition["y"],CashPosition["z"],GetEntityCoords(ped))
			if distanceCheck <= 1.5 then
				wait = 5
				drawTxt("PRESSIONE  ~g~E~w~  PARA PEGAR O DINHEIRO",4,0.5,0.93,0.50,255,255,255,180)
				if IsControlJustPressed(0,38) then
					GrabCash(bankId)
				end
			end
			 Citizen.Wait(wait)
		end
	end)
end

function GrabCash(bankId)
    animacaoroubo(true,bankId)
    Citizen.Wait(7500) 
    animacaoroubo(false,bankId)
    vRPSend.CheckPayment(bankId)
end

function loadAnimDict(dict)
    Citizen.CreateThread(function()
        while (not HasAnimDictLoaded(dict)) do
            RequestAnimDict(dict)
            Citizen.Wait(10)
        end
    end)
end

function loadModel(model)
    Citizen.CreateThread(function()
        while not HasModelLoaded(model) do
            RequestModel(model)
        Citizen.Wait(10)
        end
    end)
end

RegisterNetEvent("q_roubos:openDoor")
AddEventHandler("q_roubos:openDoor", function(bankId)
    ResetDoor(bankId)
    local Bank = config.BankHeists[bankId]
    local door = GetClosestObjectOfType(Bank['Bank_Vault']['x'],Bank['Bank_Vault']['y'],Bank['Bank_Vault']['z'],3.0,Bank['Bank_Vault']['model'])
    local rotation = GetEntityRotation(door)["z"]
    local dif = Bank['Bank_Vault']['model']
	Citizen.CreateThread(function()
        FreezeEntityPosition(door, false)
        if dif == -1185205679 or dif == -2050208642 then
            while rotation <= Bank["Bank_Vault"]["hEnd"] do
                Citizen.Wait(10)
                rotation = rotation + 0.25
                SetEntityRotation(door,0.0,0.0,rotation)
            end
        else
            while rotation >= Bank["Bank_Vault"]["hEnd"] do
                Citizen.Wait(10)
                rotation = rotation - 0.25
                SetEntityRotation(door,0.0,0.0,rotation)
            end
        end
		FreezeEntityPosition(door,true)
    end)
end)

function vRPReceiver.dropItem(item,amount,x,y,z)
	dropItens(item,amount,x,y,z)
end

function ResetDoor(bankId)
    local Bank = config.BankHeists[bankId]
    local door = GetClosestObjectOfType(Bank['Bank_Vault']['x'],Bank['Bank_Vault']['y'],Bank['Bank_Vault']['z'],3.0,Bank['Bank_Vault']['model'])
    SetEntityRotation(door, 0.0, 0.0, Bank["Bank_Vault"]["hStart"], 0.0)
end

function ResetDoors()
    for bank, values in pairs(config.BankHeists) do
        local door = GetClosestObjectOfType(values['Bank_Vault']['x'],values['Bank_Vault']['y'],values['Bank_Vault']['z'],3.0,values['Bank_Vault']['model'])
        SetEntityRotation(door,0.0,0.0,values["Bank_Vault"]["hStart"],0.0)
        FreezeEntityPosition(door,true)
    end
end

function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y-0.1)
end

function vRPReceiver.getPosition()
	local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(),true))
	return tD(x),tD(y),tD(z)
end

function tD(n)
    n = math.ceil(n * 100) / 100
    return n
end
