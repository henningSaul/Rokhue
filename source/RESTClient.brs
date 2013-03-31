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
Function newRESTClient(host As String, port As Integer, protocol As String, baseurl As String) As Object
    client = CreateObject("roAssociativeArray")
    client.host = host
    client.port = port
    client.protocol = protocol
    client.baseurl = baseurl
    client.GetUrl = restClientGetUrl
    client.Get = restClientGet
    client.Put = restClientPut
    client.Post = restClientPost
    return client
End Function

Function restClientGetUrl()
    url = m.protocol
    url = url + "://"
    url = url + m.host
    if(m.port <> 80)
        url = url + ":" + Stri(m.port)
    end if
    url = url + m.baseurl
    return url
End Function


Function restClientGet(url As String) As Dynamic
    roUrlTransfer = CreateObject("roUrlTransfer")
    roUrlTransfer.SetUrl(m.GetUrl() + url)
    print "Getting from " + roUrlTransfer.GetUrl()
    response = roUrlTransfer.GetToString()
    ' available since 3.1 b1027
    ' http://forums.roku.com/viewtopic.php?f=28&t=36409&p=373443&hilit=JSON#p373443
    return ParseJSON(response)
End Function

Function restClientPut(url As String, associativeArray As Object)
    roUrlTransfer = CreateObject("roUrlTransfer")
    roUrlTransfer.SetUrl(m.GetUrl() + url)
    json = rdSerialize(associativeArray, "JSON")
    print "Putting to " + roUrlTransfer.GetUrl() + ": " + json 
    ' TODO: workaround while waiting for HTTP PUT support, see http://forums.roku.com/viewtopic.php?f=34&t=34740
    addr = createObject("roSocketAddress") 
    addr.setAddress(m.host)
    addr.setPort(m.port) 
    socket = createObject("roStreamSocket")
    port = createObject( "roMessagePort" )
    socket.setMessagePort(port) 
    socket.notifyWritable(true)
    socket.setSendToAddress(addr)
    socket.connect()
    ev = wait(1000, port)
    line = "PUT " + m.baseurl + url + " HTTP/1.1" + CHR(13) + CHR(10)
    socket.sendStr(line)
    line = "Host: " + m.host + CHR(13) + CHR(10)
    socket.sendStr(line)
    line = "Content-Type: text/plain" + CHR(13) + CHR(10)
    socket.sendStr(line)    
    line = "Content-Length: " + Stri(Len(json)) + CHR(13) + CHR(10)
    socket.sendStr(line)
    line = "Connection: close" + CHR(13) + CHR(10)
    socket.sendStr(line)
    socket.sendStr("" + CHR(13) + CHR(10))
    socket.sendStr(json)
    socket.close()    
End Function

Function restClientPost(url As String, associativeArray As Object)
    roUrlTransfer = CreateObject("roUrlTransfer")
    roUrlTransfer.SetUrl(m.GetUrl() + url)
    json = rdSerialize(associativeArray, "JSON")
    print "Posting to " + roUrlTransfer.GetUrl() + ": " + json
    roUrlTransfer.PostFromString(json)
End Function
