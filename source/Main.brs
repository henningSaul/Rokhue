Sub Main()
    initTheme()
    showPosterScreen()
End Sub

Function showPosterScreen() As Integer
    port = CreateObject("roMessagePort")
    screen = CreateObject("roPosterScreen")
    screen.SetMessagePort(port)
    screen.Show()  
    screen.SetListNames(["Lights"])
    bridge = getBridge("Rokhue")
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
    screen.SetContentList(contentList)
    ' TODO: preselect lights/first light
    screen.setFocusedList(0)
    screen.setFocusedListItem(0)
    while true
        msg = wait(0, screen.GetMessagePort())
        print type(msg)
'        print msg.isPaused()
'        print msg.isRemoteKeyPressed()
'        print msg.GetData()
'        print msg.GetMessage()
        if type(msg) = "roPosterScreenEvent" then  
            ' TODO: detect fast forward/rewind?          
            if msg.isListItemSelected() then                               
                print "Selected" ;msg.GetIndex()
            else if msg.isScreenClosed() then
                return -1
            end if
        end if
    end while

End Function

Function getBridge(client as String) As Object 
    ' TODO: auto discover using http://www.meethue.com/api/nupnp
    ip = "10.0.1.102"
    client = client
    return newBridge(ip, client)
End Function

Function getAsContentList(lights as Object) as Object
    contentList = CreateObject("roList")
    for each light in lights
        contentList.AddTail(light.AsContent())
    end for
    return contentList
End Function
