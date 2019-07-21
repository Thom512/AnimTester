local result

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

AddEventHandler('onResourceStart', function(resourceName)
    if(GetCurrentResourceName() ~= resourceName) then
        return
    end
    local file = LoadResourceFile(GetCurrentResourceName(), Config.FichierAnim)
    
    result = stringsplit(file, "\n") 
    table.insert(result, "nil Thom512")
    print("^4AnimTester^0: "..#result-1 .. " animations")
    Wait(5000) --tps pour le client charge
    TriggerClientEvent('AnimTester:Anims', -1, result)
end)

AddEventHandler("playerConnecting", function()
    Wait(20000)
    TriggerClientEvent('AnimTester:Anims', -1, result)
end)