<!--#include virtual="/api/include/utf8.asp"-->
<%
    email = GetReqStr("email","")
    agreeE = GetReqStr("agreeE","")
    agreeM = GetReqStr("agreeM","")

    Set api = New ApiCall

    api.SetMethod = "POST"
    api.RequestContentType = "application/json"
    api.Authorization = "Bearer " & Session("access_token")
    api.SetData = "{""scope"":""ADMIN""}"
    api.SetUrl = PAYCO_AUTH_URL & "/api/member/me"

    result = api.Run

    Set api = Nothing

    Set info = JSON.Parse(result)
    member = Null

    If JSON.hasKey(info, "header") Then
        If JSON.hasKey(info.header, "resultCode") Then
            If info.header.resultCode = 0 Then
                Set member = info.data.member

                member.isAllowedEmailPromotion = IIF(agreeE = "Y", True, False)
                member.isAllowedSmsPromotion = IIF(agreeM = "Y", True, False)
				if email <> "" then 
	                member.email = email
				end if 

            End If
        End If
    End If

    If Not IsNull(member) Then
        Set api = New ApiCall

        api.SetMethod = "POST"
        api.RequestContentType = "application/json"
        api.Authorization = "Bearer " & Session("access_token")
        api.SetData = "{""member"":"& JSON.stringify(member) &"}"
        api.SetUrl = PAYCO_AUTH_URL & "/api/member/update"

        result = api.Run

        Set api = Nothing

        Set resJ = JSON.Parse(result)

        If JSON.hasKey(resJ, "header") Then
            If JSON.hasKey(resJ.header, "resultCode") Then
                If resJ.header.resultCode = 0 Then
                    Response.Write "{""result"":0,""message"":""수정되었습니다.""}"
                Else
                    Response.Write "{""result"":1,""message"":"""& JSON.stringify(resJ) &"""}"
                End If
            End If
        End If
    End if
%>