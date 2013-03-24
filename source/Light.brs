Function newLight(bridge As Object, id As String, name As String) As Object
    light = CreateObject("roAssociativeArray")
    light.bridge = bridge
    light.id = id
    light.name = name
    ' lazy fetching of details/state
    light.details = invalid
    light.RefreshState = lightRefreshState
    light.IsOn = lightIsOn
    light.IsReachable = lightIsReachable
    light.GetBrightness = lightGetBrightness
    light.AsContent = lightAsContent
    return light
End Function

Function lightRefreshState()
    m.details = m.bridge.GetLightDetails(m.id)
End Function

Function lightIsOn() As Boolean
    return m.details.state.Lookup("on")
End Function

' TODO: currently always returns true, see http://developers.meethue.com/1_lightsapi.html
Function lightIsReachable() As Boolean
    return m.details.state.Lookup("reachable")
End Function

Function lightGetBrightness() As Integer
    return m.details.state.Lookup("bri")
End Function

Function lightAsContent() As Object
    content = CreateObject("roAssociativeArray")
    content.light = m
    content.ShortDescriptionLine1 = m.name
    content.ShortDescriptionLine2 = ""
    ' TODO: set image/poster url
    content.RefreshState = lightContentRefreshState
    return content
End Function

Function lightContentRefreshState()
    m.light.RefreshState()
    if(m.light.IsOn() = true) 
        m.ShortDescriptionLine2 = "State: On, Brightness " + Stri(m.light.GetBrightness())    
    else 
        m.ShortDescriptionLine2 = "State: Off"      
    end if
End Function
