<!--#include virtual="/api/include/utf8.asp"-->
<%
	If GetReferer = GetCurrentHost Then 
	Else 
		Response.Write "{""result"":1,""message"":""잘못된 접근방식 입니다.""}"
		Response.End 
	End If

	member_idx = Session("userIdx")
    member_idno = Session("userIdNo")
    reason = GetReqStr("sSecssionType","")
    desc = GetReqStr("sSecssionMsg","")

    If member_idx = "" Or member_idno = "" Or reason = "" Or (reason = "기타" And desc = "") Then
        Response.Write "{""result"":1,""message"":""정보가 부족합니다.""}"
        Response.End
    End If

    Set api = New ApiCall

    api.SetMethod = "POST"
    api.RequestContentType = "application/json"
    api.Authorization = "Bearer " & Session("access_token")
    api.SetUrl = PAYCO_AUTH_URL & "/api/member/withdraw"

    result = api.Run

    Set api = Nothing

    Set wJ = JSON.parse(result)

    mResult = ""
    mMessage = ""

    If JSON.hasKey(wJ, "header") Then
        If JSON.haskey(wJ.header, "resultCode") Then
            If wJ.header.resultCode = 0 Then
                mResult = "0"
                mMessage = "처리되었습니다."

                Set cmd = Server.CreateObject("ADODB.Command")
                With cmd
                    .ActiveConnection = dbconn
                    .NamedParameters = True
                    .CommandType = adCmdStoredProc
                    .CommandText = "bp_member_withdraw"

                    .Parameters.Append .CreateParameter("@member_idx", adInteger, adParamInput,,member_idx)
                    .Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, member_idno)
                    .Parameters.Append .CreateParameter("@withdraw_reason", adVarChar, adParamInput, 50, reason)
                    .Parameters.Append .CreateParameter("@withdraw_description", adVarChar, adParamInput, 1000, desc)

                    .Execute
                End With
                Set cmd = Nothing

                ' 자동로그인 삭제.
                Response.Cookies("access_token") = ""
                Response.Cookies("access_token_secret") = ""
                Response.Cookies("refresh_token") = ""
                Response.Cookies("refresh_token_save") = ""
                Response.Cookies("token_type") = ""
                Response.Cookies("expires_in") = ""
                Response.Cookies("auto_login_yn") = ""
                Response.Cookies("bbq_app_type") = ""

                Response.Cookies("access_token").Expires = date() - 1
                Response.Cookies("access_token_secret").Expires = date() - 1
                Response.Cookies("refresh_token").Expires = date() - 1
                Response.Cookies("refresh_token_save").Expires = date() - 1
                Response.Cookies("token_type").Expires = date() - 1
                Response.Cookies("expires_in").Expires = date() - 1
                Response.Cookies("auto_login_yn").Expires = date() - 1
                Response.Cookies("bbq_app_type").Expires = date() - 1

                Session.Abandon()
            Else
                mResult = "2"
                mMessage = "처리되지 않았습니다."
            End If 
        Else
            mResult = "3"
            mMessage = "처리되지 않았습니다."
        End if
    Else
        mResult = "4"
        mMessage = "처리되지 않았습니다."
    End If

    Response.Write "{""result"":" & mResult & ",""message"":""" & mMessage & """}"
%>