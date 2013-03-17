Function newBridge(ip as String, client as String) As Object
    bridge = CreateObject("roAssociativeArray")
    bridge.ip = ip
    bridge.client = client
    bridge.GetLights = bridgeGetLights
    bridge.GetGroups = bridgeGetGroups
    bridge.restClient = newRestClient("http://"+ ip + "/api/" + client)
    return bridge
End Function

Function bridgeGetLights() As Object
    lights = CreateObject("roList")
    response = m.restClient.Get("/lights")
    for each id in response
        ' TODO: GET to /api/newdeveloper/lights and /api/newdeveloper/light/X
       light = newLight(m, id, response[id].name)      
       lights.AddHead(light)
    end for
    return lights
End Function

Function bridgeGetGroups() As Object
    groups = CreateObject("roList")
    ' TODO: GET to /api/newdeveloper/groups and /api/newdeveloper/group/X
    group = newGroup(m, "1")
    groups.AddTail(group)
    return groups
End Function
