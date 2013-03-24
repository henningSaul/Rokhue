Function newBridge(ip as String, client as String) As Object
    ' debug API http://10.0.1.102/debug/clip.html
    bridge = CreateObject("roAssociativeArray")
    bridge.ip = ip
    bridge.client = client
    bridge.GetLights = bridgeGetLights
    bridge.GetLightDetails = bridgeGetLightDetails
    bridge.GetGroups = bridgeGetGroups
   bridge.GetGroupDetails = bridgeGetGroupDetails
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

Function bridgeGetGroups() As Object
    groups = CreateObject("roList")
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
