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
Function newLight(bridge As Object, id As String, name As String) As Object
    light = CreateObject("roAssociativeArray")
    light.bridge = bridge
    light.id = id
    light.name = name
    ' lazy fetching of details/state
    light.details = invalid
    light.RefreshState = lightRefreshState
    light.IsOn = lightIsOn
    light.SetOn = lightSetOn
    light.IsReachable = lightIsReachable
    light.GetBrightness = lightGetBrightness
    light.SetBrightness = lightSetBrightness
    light.AsContent = lightAsContent
    return light
End Function

Function lightRefreshState()
    m.details = m.bridge.GetLightDetails(m.id)
End Function

Function lightIsOn() As Boolean
    return m.details.state.Lookup("on")
End Function

Function lightSetOn(o As Boolean)
    m.bridge.SetLightState(m.id, {on : o})
End Function

' currently always returns true, see http://developers.meethue.com/1_lightsapi.html
Function lightIsReachable() As Boolean
    return m.details.state.Lookup("reachable")
End Function

Function lightGetBrightness() As Integer
    return m.details.state.Lookup("bri")
End Function

Function lightSetBrightness(bri As Integer)
    m.bridge.SetLightState(m.id, {bri : bri})
End Function

Function lightAsContent() As Object
    content = CreateObject("roAssociativeArray")
    content.light = m
    content.ShortDescriptionLine1 = m.name
    content.ShortDescriptionLine2 = ""  
    content.SDPosterUrl = "pkg:/images/off.jpg"
    content.HDPosterUrl = "pkg:/images/off.jpg"
    if(not m.details = invalid)
        if(m.IsOn())
            content.SDPosterUrl = "pkg:/images/on.jpg"
            content.HDPosterUrl = "pkg:/images/on.jpg"        
        end if
    end if
    content.RefreshState = lightContentRefreshState
    content.IsOn = lightContentIsOn
    content.ToggleOnOff = lightContentToggleOnOff
    content.LowerBrightness = lightContentLowerBrightness
    return content
End Function

Function lightContentRefreshState()
    m.light.RefreshState()
    if(m.light.IsOn() = true) 
        m.SDPosterUrl = "pkg:/images/on.jpg"
        m.HDPosterUrl = "pkg:/images/on.jpg"
        m.ShortDescriptionLine2 = "State: On, Brightness " + Stri(m.light.GetBrightness())    
    else
        m.SDPosterUrl = "pkg:/images/off.jpg"
        m.HDPosterUrl = "pkg:/images/off.jpg" 
        m.ShortDescriptionLine2 = "State: Off"     
    end if
End Function

Function lightContentIsOn() As Boolean
    return m.light.IsOn()
End Function

Function lightContentToggleOnOff()
    m.light.SetOn(not m.light.IsOn())
End Function

Function lightContentLowerBrightness(count As Integer)
    bri = m.light.GetBrightness()
    bri = bri - count
    if(bri < 0)
        bri = 255 - count
    end if
    m.light.SetBrightness(bri)
End Function

