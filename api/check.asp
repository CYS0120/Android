<!--#include virtual="/api/include/utf8.asp"-->
<%
    domain = GetReqStr("doamin","")
    retPage = GetReqStr("page","")
    access_token = GetReqStr("at", "")
    access_token_secret = GetReqStr("ats","")
    refresh_token = GetReqStr("rt","")

    If access_token <> "" Or access_token_secret <> "" Or refresh_token <> "" Then
        Set api = New ApiCall

        api.SetMethod = "POST"
        api.RequestContentType = "application/json"
        api.Authorization = "Bearer " & access_token
        api.SetData = "{""scope"":""ADMIN""}"
        api.SetUrl = PAYCO_AUTH_URL & "/api/member/me"

        result = api.Run

        Set oJson = JSON.Parse(result)

        If JSON.hasKey(oJson.header, "isSuccessful") And oJson.header.isSuccessful Then
            Response.Write "Autorazed!!!!!!!!"
        Else
            Response.Redirect "/"
        End If
    Else
        Response.Redirect "/"
    End If
%>