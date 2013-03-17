Function newGroup(bridge as Object, id as String) As Object
    group = CreateObject("roAssociativeArray")
    group.bridge = bridge
    group.id = id
    group.AsContent = groupAsContent
    return group
End Function

Function groupAsContent() 
    content = CreateObject("roAssociativeArray")
    content.Title = "Group " + m.id
    content.ShortDescriptionLine1 = "Group " + m.id
    content.ShortDescriptionLine2 = "TODO"
    ' TODO: set image/poster url
    return content
End Function