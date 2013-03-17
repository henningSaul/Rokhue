Function newRESTClient(baseurl As String) As Object
    client = CreateObject("roAssociativeArray")
    client.baseurl = baseurl
    client.Get = restClientGet
    return client
End Function

Function restClientGet(url As String) As Object
    roUrlTransfer = CreateObject("roUrlTransfer")
    roUrlTransfer.SetUrl(m.baseurl + url)
    response = roUrlTransfer.GetToString() 
    ' available in upcoming 3.1 release
    ' http://forums.roku.com/viewtopic.php?f=28&t=36409&p=373443&hilit=JSON#p373443
    return ParseJSON(response)
End Function