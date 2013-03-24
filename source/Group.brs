Function newGroup(bridge As Object, id As String, name As String) As Object
    group = CreateObject("roAssociativeArray")
    group.bridge = bridge
    group.id = id
    group.name = name
    ' lazy fetching of details/state
    group.details = invalid
    group.IsOn = groupIsOn    
    group.RefreshState = groupRefreshState 
    group.IsOn = groupIsOn
    group.ToggleOnOff = groupToggleOnOff  
    group.AsContent = groupAsContent
    return group
End Function

Function groupRefreshState()
    m.details = m.bridge.GetGroupDetails(m.id)
End Function

Function groupIsOn() As Boolean
    return m.details.action.Lookup("on")
End Function

Function groupToggleOnOff() As Integer
    m.bridge.SetGroupState(m.id, {on : not m.IsOn()})
End Function

Function groupAsContent() 
    content = CreateObject("roAssociativeArray")
    content.group = m
    content.ShortDescriptionLine1 = m.name
    content.ShortDescriptionLine2 = ""
    ' TODO: set image/poster url
    content.RefreshState = groupContentRefreshState
    content.ToggleOnOff = groupContentToggleOnOff
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

Function groupContentToggleOnOff()
    m.group.ToggleOnOff()
End Function