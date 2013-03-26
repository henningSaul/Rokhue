' Copyright 2013 Henning Saul
'
' This file is part of Rokhue.

' Rokhue is free software: you can redistribute it and/or modify
' it under the terms of the GNU General Public License as published by
' the Free Software Foundation, either version 3 of the License, or
' (at your option) any later version.

' Rokhue is distributed in the hope that it will be useful,
' but WITHOUT ANY WARRANTY; without even the implied warranty of
' MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
' GNU General Public License for more details.

' You should have received a copy of the GNU General Public License
' along with Rokhue.  If not, see <http://www.gnu.org/licenses/>.
'

' TODO: bridge authorization
' TODO: separate categories for lights and groups
' TODO: HTTP Put to set state, and associativeArray to JSON
' TODO: theme + artwork
' TODO: dimming lights and groups

Sub Main()
    initTheme()
    bridge = getBridge("Rokhue")
    ' check if bridge could be found
    if(bridge = invalid) 
        showNoBridgeScreen()
    else if (checkAuthorisation(bridge))  
        showHomeScreen(bridge)
    end if
End Sub

Function showHomeScreen(bridge As Object) As Integer
    port = CreateObject("roMessagePort")
    screen = CreateObject("roPosterScreen")
    screen.SetMessagePort(port)
    screen.SetListNames(["Lights"])
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
                contentList[msg.GetIndex()].ToggleOnOff()
                contentList[msg.GetIndex()].RefreshState()
                screen.SetContentList(contentList)                
            else if msg.isScreenClosed() then
                return -1
            end if
        end if
    end while
End Function

Function getBridge(client As String) As Object
    ' user broker server discover process 
    discoveryService = newRestClient("http://www.meethue.com/api")
    bridgeInfo = discoveryService.Get("/nupnp")
    if(bridgeInfo = invalid)
        return invalid
    end if 
    ' currently only supporting a single bridge...
    ip = bridgeInfo[0].internalipaddress
    print "Using bridge at " + ip
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

Function showNoBridgeScreen() 
    port = CreateObject("roMessagePort")
    screen = CreateObject("roParagraphScreen")
    screen.SetMessagePort(port)
    screen.SetTitle("Error")
    screen.AddHeaderText("Failed to discover hue bridge")
    screen.AddParagraph("This channel requires a Philips hue lighting system and a working internet connection.")
    screen.AddParagraph("Please make sure that your hue bridge is turned on and your internet connection is working.")
    screen.AddParagraph("The following URL should return your bridge's internal IP address:")
    screen.AddParagraph("http://www.meethue.com/api/nupnp")
    screen.AddButton(1, "Exit")
    screen.Show()
    while true
        msg = wait(0, screen.GetMessagePort())
        if type(msg) = "roParagraphScreenEvent"
            if msg.isScreenClosed()
                exit while                
            else if msg.isButtonPressed()
                exit while
            endif
        endif
    end while
End Function

Function checkAuthorisation(bridge As Object) As Boolean
    if(bridge.IsAuthorized())
        return true
    end if
    port = CreateObject("roMessagePort")
    screen = CreateObject("roParagraphScreen")
    screen.SetMessagePort(port)
    screen.SetTitle("Info")
    screen.AddHeaderText("Bridge authorization required")
    screen.AddParagraph("This channel needs to be authorized to control your hue lighting system.")
    screen.AddParagraph("Please press the link button on your hue bridge and click retry.")
    screen.AddButton(1, "Retry")
    screen.AddButton(2, "Exit")
    screen.Show() 
    while (not bridge.isAuthorized())
        bridge.RequestAuthorization()  
        msg = wait(0, screen.GetMessagePort())
        if type(msg) = "roParagraphScreenEvent"
            if msg.isScreenClosed()
                exit while                
            else if msg.isButtonPressed()
                if(msg.GetIndex() = 2)
                    exit while
                end if
            endif
        endif      
    end while
    return bridge.IsAuthorized()
End Function

