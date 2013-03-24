Sub Main()
    initTheme()
    showPosterScreen()
End Sub

Function showPosterScreen() As Integer
    port = CreateObject("roMessagePort")
    screen = CreateObject("roPosterScreen")
    screen.SetMessagePort(port)
    screen.SetListNames(["Lights"])
    bridge = getBridge("newdeveloper")
    'bridge = getBridge("Rokhue")
    ' TODO: test if authorized
    ' get lights and groups from Bridge    
    lights = bridge.GetLights()
    groups = bridge.GetGroups()
    lightsAndGroups = CreateObject("roList")
    for each light in lights
        lightsAndGroups.AddTail(light)
    end for
    for each group in groups
        lightsAndGroups.AddTail(group)
    end for
    contentList = getAsContentList(lightsAndGroups)
    ' get state of first light, others are loaded lazy
    if(contentList.Count() > 0) 
        contentList[0].RefreshState()
    end if
    screen.SetContentList(contentList)
    ' TODO: preselect lights/first light not working
    screen.setFocusedList(0)
    screen.setFocusedListItem(0)
    screen.Show()  
    while true
        msg = wait(0, screen.GetMessagePort())
        ' TODO: how to detect fast forward/rewind?   
        if type(msg) = "roPosterScreenEvent" then
            if msg.isListItemFocused() then 
                contentList[msg.GetIndex()].RefreshState()
                screen.SetContentList(contentList)
            else if msg.isListItemSelected() then
                ' TODO: toggle state                               
                print "Selected" ;msg.GetIndex()
            else if msg.isScreenClosed() then
                return -1
            end if
        end if
    end while

End Function

Function getBridge(client As String) As Object 
    ' TODO: auto discover using http://www.meethue.com/api/nupnp
    ip = "10.0.1.102"
    client = client
    return newBridge(ip, client)
End Function

Function getAsContentList(lights As Object) As Object
    contentList = CreateObject("roList")
    for each light in lights
        contentList.AddTail(light.AsContent())
    end for
    return contentList
End Function
