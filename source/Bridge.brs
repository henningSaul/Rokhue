Function newBridge(ip as String, client as String) As Object
    bridge = CreateObject("roAssociativeArray")
    bridge.ip = ip
    bridge.client = client
    bridge.GetLights = bridgeGetLights
    bridge.GetGroups = bridgeGetGroups
    return bridge
End Function

Function bridgeGetLights() As Object
    lights = CreateObject("roList")
    ' TODO: GET to /api/newdeveloper/lights and /api/newdeveloper/light/X
    light = newLight(m, "1")
    lights.AddTail(light)
    light = newLight(m, "2")
    lights.AddTail(light)
    light = newLight(m, "3")
    lights.AddTail(light)
    return lights
End Function

Function bridgeGetGroups() As Object
    groups = CreateObject("roList")
    ' TODO: GET to /api/newdeveloper/groups and /api/newdeveloper/group/X
    group = newGroup(m, "1")
    groups.AddTail(group)
    return groups
End Function
