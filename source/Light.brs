Function newLight(bridge as Object, id as String) As Object
    light = CreateObject("roAssociativeArray")
    light.bridge = bridge
    light.id = id
    light.AsContent = lightAsContent
    return light
End Function

Function lightAsContent() 
    content = CreateObject("roAssociativeArray")
    content.Title = "Light " + m.id
    content.ShortDescriptionLine1 = "Light " + m.id
    content.ShortDescriptionLine2 = "TODO"
    ' TODO: set image/poster url
    return content
End Function