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
Function newGroup(bridge As Object, id As String, name As String) As Object
    group = CreateObject("roAssociativeArray")
    group.bridge = bridge
    group.id = id
    group.name = name
    ' lazy fetching of details/state
    group.details = invalid
    group.lights = invalid
    group.IsOn = groupIsOn 
    group.SetOn = groupSetOn   
    group.RefreshState = groupRefreshState 
    group.GetLights = groupGetLights
    group.AsContent = groupAsContent
    return group
End Function

Function groupRefreshState()
    m.details = m.bridge.GetGroupDetails(m.id)
End Function

Function groupIsOn() As Boolean
    return m.details.action.Lookup("on")
End Function

Function groupSetOn(o As Boolean)
    m.bridge.SetGroupState(m.id, {on : o})
End Function

Function groupGetLights() As Object
    if(m.lights <> invalid)
        return m.lights
    end if
    m.lights = CreateObject("roList")  
    for each id in m.details.lights
        m.lights.addHead(newLight(m.bridge, id, "Light " + id))  
    end for
    return m.lights
End Function

Function groupAsContent() 
    content = CreateObject("roAssociativeArray")
    content.group = m
    content.ShortDescriptionLine1 = m.name
    content.ShortDescriptionLine2 = ""
    ' TODO: set image/poster url
    content.RefreshState = groupContentRefreshState
    content.IsOn = groupContentIsOn
    content.ToggleOnOff = groupContentToggleOnOff
    content.LowerBrightness = groupContentLowerBrightness
    return content
End Function

Function groupContentRefreshState()
    m.group.RefreshState()
    if(m.group.IsOn() = true) 
        m.ShortDescriptionLine2 = "State: On"  
    else 
        m.ShortDescriptionLine2 = "State: Off"      
    end if
End Function

Function groupContentIsOn() As Boolean
    return m.group.IsOn()
End Function

Function groupContentToggleOnOff()
    m.group.setOn(not m.group.IsOn())
End Function

Function groupContentLowerBrightness(count As Integer)
    for each light in m.group.GetLights()
        light.RefreshState()
        bri = light.GetBrightness()
        if(bri > 0)
            bri = bri - count
            if(bri < 0)
                bri = 0
            end if  
            light.SetBrightness(bri)        
        end if   
    end for
End Function