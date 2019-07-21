_menuPool = NativeUI.CreatePool()
_menuPool:RefreshIndex()
 mainMenu = NativeUI.CreateMenu("AnimTester", "~b~AnimTester", 5, 50,"NativeUI","bg",nil,255,255,255,255)
_menuPool:Add(mainMenu)
 AnimDictMenu = NativeUI.CreateMenu("AnimTester", ":)", 5, 50,"NativeUI","bg",nil,255,255,255,199)
_menuPool:Add(AnimDictMenu)
 searchMenu = NativeUI.CreateMenu("AnimTester", "~b~Résultats de la recherche", 5, 50,"NativeUI","bg",nil,255,255,255,199)
_menuPool:Add(searchMenu)

local DictSelected = "abigail_mcs_1_concat-0"
local libNotif, animNotif, durNotif, term

function DrawMainMenu()
    
     mainMenu = NativeUI.CreateMenu("AnimTester", "~b~"..#AnimsRaw-1 .." animations  ~w~|~b~  "..#AnimsDict-1 .." librairies", 5, 50,"NativeUI","bg",nil,255,255,255,255)
    _menuPool:Add(mainMenu)
    MenuSettings()
    

    local AnimsDictList = NativeUI.CreateListItem("Librairie", AnimsDict, 1, #AnimsDict-1 .." librairies")
    mainMenu:AddItem(AnimsDictList)
    
        
    local AnimMenu = NativeUI.CreateItem("Animations", "Liste d'animations pour la librairie sélectionnée.")
    AnimMenu:RightLabel(" →→")
    mainMenu:AddItem(AnimMenu)
    
    
    mainMenu:AddItem(NativeUI.CreateItem("", ""))
    
        
    local Recherche = NativeUI.CreateColouredItem("Recherche", "Recherche dans les librairies.", Colours.Blue , Colours.BlueLight )
    Recherche:RightLabel(" →→")
    mainMenu:AddItem(Recherche)
        
    mainMenu.OnListChange = function(_, list, newindex)
        if list == AnimsDictList then
            DictSelected = AnimsDict[newindex]
            _menuPool:RefreshIndex()
        end
    end

    mainMenu.OnItemSelect = function(_,item,index)
        if item == Recherche then
            RechercheMenu()
        end
        if item == AnimMenu then
            AddMenuName()
        end
    end
    _menuPool:RefreshIndex()
end

function AddMenuName()

    AnimDictMenu:Clear()
    if AnimsName[DictSelected] == nil then
        Utils.ShowAdvancedNotification("Librairie ~o~"..DictSelected.. "~s~ vide ?")
        return
    else
        AnimDictMenu = NativeUI.CreateMenu("AnimTester", "~b~"..DictSelected, 5, 50,"NativeUI","bg",nil,255,255,255,199)
        _menuPool:Add(AnimDictMenu)
        MenuSettings()
    
        for k,v in pairs(AnimsName[DictSelected]) do
            local Item = NativeUI.CreateItem(v, "")
            AnimDictMenu:AddItem(Item)
        end 
    end
    
    
    AnimDictMenu.OnItemSelect = function(_, _, index)
        
        local lib = DictSelected
        local anim = AnimsName[DictSelected][index]
        
        if not (libNotif == nil and animNotif == nil and durNotif == nil) then
            RemoveNotification(libNotif)
            RemoveNotification(animNotif)
            RemoveNotification(durNotif)
        end
        
        RequestAnimDict(lib)
		while not HasAnimDictLoaded(lib) do Wait(0) end
        
        libNotif = Utils.ShowAdvancedNotification("~g~Librairie", "~h~"..lib)
        
        animNotif = Utils.ShowAdvancedNotification("~y~Animation", "~h~"..anim)
        
        local duree = GetAnimDuration(lib, anim)
        durNotif = Utils.ShowAdvancedNotification("~r~Durée (en sec.) ", "~h~"..Utils.Round(duree, 3))
        
        TaskPlayAnim(GetPlayerPed(-1), lib, anim ,8.0, -8.0, duree, 0, 0, false, false, false)
    end
    
    AnimDictMenu.OnMenuClosed = function(menu)
        mainMenu:Visible(true)
    end,
    
    _menuPool:CloseAllMenus()
    AnimDictMenu:Visible(true)
end

function RechercheMenu()
    searchMenu:Clear()
    term = Utils.GetTextEntry("Recherche librairies", term)
    if #term < 2 or term == nil then
        Utils.ShowAdvancedNotification("~r~2 caractères minimum", "")
        return
    end
    local count = 0
    local results = {}
    for k,v in pairs(AnimsDict) do
        local a, b = string.find(string.lower(v), string.lower(term))
        if a ~= nil and b ~= nil then
            count = count + 1 
            table.insert(results, v)
        end
    end 
    
     searchMenu = NativeUI.CreateMenu("AnimTester", "~b~"..count.." Résultats pour '"..term.."'", 5, 50,"NativeUI","bg",nil,255,255,255,199)
    _menuPool:Add(searchMenu)
    MenuSettings()
    
    
    for k,v in pairs(results) do
        local Item = NativeUI.CreateItem(v, "")
        searchMenu:AddItem(Item)
    end 
          
    searchMenu.OnItemSelect = function(menu, item, index)
        DictSelected = results[index]
        AddMenuName()
    end
        
    _menuPool:CloseAllMenus()
    searchMenu:Visible(true)
end

function MenuSettings()
    _menuPool:MouseControlsEnabled(false)
    _menuPool:MouseEdgeEnabled(false)
    _menuPool:ControlDisablingEnabled(false)
    _menuPool:WidthOffset(200)
    --_menuPool:TotalItemsPerPage(15)
end

Citizen.CreateThread(function()
  local loadnotif = Utils.ShowAdvancedNotification("~b~Chargement en cours ...", "") 
  while not Ready do Wait(0) end
    
    RemoveNotification(loadnotif)
    Utils.ShowAdvancedNotification("~g~Chargement terminé !", "")
    DrawMainMenu()
    
    while true do Wait(0)

        _menuPool:ProcessMenus()
        
        if IsControlJustPressed(1, Config.OpenMenu) then --166=F5
            if mainMenu:Visible() then 
                _menuPool:CloseAllMenus()
            else
                _menuPool:CloseAllMenus()
                mainMenu:Visible(true)
            end
        end
    end
end)

--DrawMainMenu()