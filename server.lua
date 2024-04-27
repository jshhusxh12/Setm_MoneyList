local resource = GetCurrentResourceName()
local WaitTime = 7200000

local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", resource)

local rewards = {
    --[[
        EXAMPLE : ["펌션"] = {"아이템 코드", 수량},
        ["plr.master"] = {"credit_master", 100} -- plr.master 를 가진 플레이어에게 credit_master 아이템을 100개 지급함.
    ]]
}

function giveItemUser()
    local users = vRP.getUsers({})
    for k, v in pairs(users) do
        local user_id = vRP.getUserId({k})
        if user_id ~= nil then
            for permission, reward in pairs(rewards) do
                if vRP.hasPermission({user_id, permission}) then
                    vRP.giveInventoryItem({user_id, reward[1], reward[2], true})
                    vRPclient.notify(v, {'~g~2시간이 지나서 후원 크레딧을 받았어요!~w~'})
                    break -- 하나의 보상을 받으면 다음 사용자로 넘어감
                end
            end
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Wait(WaitTime)
        giveItemUser()
    end
end)