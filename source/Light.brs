Function newLight(bridge As Object, id As String, name As String) As Object
    light = CreateObject("roAssociativeArray")
    light.bridge = bridge
    light.id = id
    light.name = name
    light.AsContent = lightAsContent
    return light
End Function

Function lightAsContent() 
    content = CreateObject("roAssociativeArray")
    content.Title = m.name
    content.ShortDescriptionLine1 = m.name
    content.ShortDescriptionLine2 = "TODO"
    ' TODO: set image/poster url
    return content
End Function