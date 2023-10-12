local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
vRPReceiver = {}
Tunnel.bindInterface("Q_roubos",vRPReceiver)
vRPSend = Tunnel.getInterface("Q_roubos")
config = {}