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
Function newBridge(ip as String, client as String) As Object
    ' debug API http://10.0.1.102/debug/clip.html
    bridge = CreateObject("roAssociativeArray")
    bridge.ip = ip
    bridge.port = 80
    bridge.protocol = "http"
    bridge.devicetype = client
    ' use device id as username
    deviceInfo = CreateObject("roDeviceInfo")
    deviceId = deviceInfo.GetDeviceUniqueId()    
    bridge.username = deviceId
    ' http://developers.meethue.com/1_lightsapi.html
    bridge.GetLights = bridgeGetLights
    bridge.GetLightDetails = bridgeGetLightDetails
    bridge.SetLightState = bridgeSetLightState
    ' http://developers.meethue.com/2_groupsapi.html
    bridge.GetGroups = bridgeGetGroups
    bridge.GetGroupDetails = bridgeGetGroupDetails
    bridge.SetGroupState = bridgeSetGroupState    
    ' http://developers.meethue.com/4_configurationapi.html
    bridge.IsAuthorized = bridgeIsAuthorized
    bridge.RequestAuthorization = bridgeRequestAuthorization
    bridge.restClient = newRestClient(bridge.ip, bridge.port, bridge.protocol, "/api/" + deviceId)
    return bridge
End Function

Function bridgeGetLights() As Object
    lights = CreateObject("roList")
    response = m.restClient.Get("/lights")
    for each id in response
        light = newLight(m, id, response[id].name)
        ' get details and check if light is reachable
        light.RefreshState()
        if(light.IsReachable())
            lights.AddHead(light)       
        end if      
    end for
    return lights
End Function

Function bridgeGetLightDetails(id As String) As Object
    return m.restClient.Get("/lights/" + id)
End Function

Function bridgeSetLightState(id As String, state As Object)
    ' fire and forget...
    m.restClient.Put("/lights/" + id + "/state", state)
End Function

Function bridgeGetGroups() As Object
    groups = CreateObject("roList")
    ' special group for all lights
    groups.addHead(newGroup(m, "0", "All Lights"))
    ' get user defined groups    
    response = m.restClient.Get("/groups")
    for each id in response
       group = newGroup(m, id, response[id].name)  
       group.RefreshState()    
       groups.AddHead(group)
    end for
    return groups
End Function

Function bridgeGetGroupDetails(id As String) As Object
    return m.restClient.Get("/groups/" + id)
End Function

Function bridgeSetGroupState(id As String, state As Object)
    ' fire and forget...
    m.restClient.Put("/groups/" + id + "/action", state)
End Function

Function bridgeIsAuthorized() As Boolean
    response = m.restClient.Get("/lights")
    if (hasError(response))
        print "Device/username " + m.username + " is not authorized" 
        return false
    else
        return true
    end if
End Function

Function hasError(response As Object) As Boolean
    if(response = invalid)
        return true
    end if
    if(type(response) = "roArray")
        return (response[0].error <> invalid)
    end if
    return false
End Function

Function bridgeRequestAuthorization()
    print "Requesting bridge authorization for device/username " + m.username
    restClient = newRestClient(m.ip, m.port, m.protocol, "/api")
    userInfo = {devicetype: m.devicetype, username: m.username}
    restClient.Post("", userInfo)     
End Function
