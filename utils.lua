Ready = false
AnimsRaw = {}
AnimsDict = {}
AnimsName = {}

RegisterNetEvent("AnimTester:Anims")
AddEventHandler('AnimTester:Anims', function(data)
    for k,v in pairs(data) do
        AnimsRaw[k] = Utils.Stringsplit(data[k])
    end 

    local temp = {}
    for k,v in pairs(AnimsRaw) do
        local currAnimDict = v[1]
        local currAnimName = v[2]

        if AnimsDict[#AnimsDict] ~= currAnimDict then
            table.insert(AnimsDict, currAnimDict)
        end
        table.insert(temp, currAnimName)
        if AnimsRaw[k+1] ~= nil then 
            if AnimsDict[#AnimsDict] ~= AnimsRaw[k+1][1] then
                AnimsName[AnimsDict[#AnimsDict]] = temp
                temp = {}
            end
        end
    end 
   Ready = true
end)








Utils = {}

function Utils.Round(num, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function Utils.Stringsplit(inputstr, sep)
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

function Utils.ShowNotification(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    return DrawNotification(false, true)
end

function Utils.ShowHelpNotification(text)
    SetTextComponentFormat('STRING')
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function Utils.ShowAdvancedNotification(title, msg, icon, iconName)
	RequestStreamedTextureDict("NativeUI", true)
	while not HasStreamedTextureDictLoaded("NativeUI") do Wait(0) end
	SetNotificationTextEntry('STRING')
    AddTextComponentString(msg)
	local a = SetNotificationMessage("NativeUI", "icon", false, 0, "AnimTester", title)
	DrawNotification(true, true)
    return a
end

function Utils.GetTextEntry(titre, txt)
    if titre == nil then
        titre = ""
    end
    
    AddTextEntry('THOM', titre)
    DisplayOnscreenKeyboard(1, "THOM", "", txt, "", "", "", 100)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
		return result
    end

end