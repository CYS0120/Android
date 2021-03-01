<!--#include virtual="/api/include/utf8.asp"-->
<%
    info = GetReqStr("info", "")

    callbackUrl = GetCurrentHost

    Select Case info
        Case "pwd": apiUrl = "/api/member/change-password/issue-ticket"
        Case "mobile": apiUrl = "/api/member/change-cellphone-number/issue-ticket"
    End Select

    If info = "" Or apiUrl = "" Then
        Response.Write "{""header"":{""resultCode"":-1}}"
        Response.End
    End If

    Set api = New ApiCall

    api.SetMethod = "POST"
    api.RequestContentType = "application/json"
    api.Authorization = "Bearer " & Session("access_token")
    api.SetData = "{""callbackUrl"":"""&callbackUrl&"/api/changeInfo.asp?info="&info&""",""popupYn"":""N""}"
    api.SetUrl = PAYCO_AUTH_URL & apiUrl

    result = api.Run

    Set api = Nothing

    Response.Write result
%>