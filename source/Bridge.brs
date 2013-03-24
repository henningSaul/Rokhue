Function newBridge(ip as String, client as String) As Object
    ' debug API http://10.0.1.102/debug/clip.html
    bridge = CreateObject("roAssociativeArray")
    bridge.ip = ip
    bridge.client = client
    ' http://developers.meethue.com/1_lightsapi.html
    bridge.GetLights = bridgeGetLights
    bridge.GetLightDetails = bridgeGetLightDetails
    bridge.SetLightState = bridgeSetLightState
    ' http://developers.meethue.com/2_groupsapi.html
    bridge.GetGroups = bridgeGetGroups
    bridge.GetGroupDetails = bridgeGetGroupDetails
    bridge.SetGroupState = bridgeSetGroupState    
    bridge.restClient = newRestClient("http://"+ ip + "/api/" + client)
    return bridge
End Function

Function bridgeGetLights() As Object
    lights = CreateObject("roList")
    response = m.restClient.Get("/lights")
    for each id in response
       light = newLight(m, id, response[id].name)      
       lights.AddHead(light)
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
