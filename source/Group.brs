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