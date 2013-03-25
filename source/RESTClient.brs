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
Function newRESTClient(baseurl As String) As Object
    client = CreateObject("roAssociativeArray")
    client.baseurl = baseurl
    client.Get = restClientGet
    client.Put = restClientPut
    return client
End Function

Function restClientGet(url As String) As Dynamic
    roUrlTransfer = CreateObject("roUrlTransfer")
    roUrlTransfer.SetUrl(m.baseurl + url)
    response = roUrlTransfer.GetToString()
    ' available in current 3.1 release? need to get box of beta list
    ' http://forums.roku.com/viewtopic.php?f=28&t=36409&p=373443&hilit=JSON#p373443
    return ParseJSON(response)
End Function

' TODO: HTTP PUT? http://forums.roku.com/viewtopic.php?f=34&t=34740
Function restClientPut(url As String, associativeArray As Object) As Object
    print associativeArray
    response = ""
    return ParseJSON(response)    
End Function