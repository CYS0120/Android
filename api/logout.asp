<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
    Session.CodePage = "65001"
    Response.CharSet = "UTF-8"
    Response.AddHeader "Pragma", "no-cache"
    Response.CacheControl = "no-cache"
    ' Response.CharSet = "euc-kr"

	session.lcid	= 1042	'날짜형식 한국 형식으로 

    ' // TODO : 디버그를 위해 만들어 놓은 코드
%>
<!--#include virtual="/api/include/g2.asp"-->
<!--#include virtual="/api/include/cv.asp"-->
<!--#include virtual="/includes/cv.asp"-->
<!--#include virtual="/api/include/json2.asp"-->
<!--#include virtual="/api/include/db_open.asp"-->
<!--#include virtual="/api/include/func.asp"-->
<!--#include virtual="/api/call_api.asp"-->
<!--#include virtual="/api/include/classes.asp"-->
<!--#include virtual="/api/membership.asp"-->
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
</head>
<body>
<%
    Set api = New ApiCall

    Dim sendData : sendData = "client_id=" & PAYCO_CLIENT_ID & "&token=" & Session("access_token")
	dim logoutStatus

	if Session("access_token") <> "" Then 
		url = PAYCO_AUTH_URL & "/oauth2/revoke"

		api.SetMethod = "POST"
		api.RequestContentType = "application/x-www-form-urlencoded"
		api.Authorization = "Basic " & PAYCO_CLIENT_SECRET
		' api.ResponseContentType = "application/json"
		' api.SetData = "client_id=" & payco_client_id & "&token=" & Session("access_token")
		api.SetData = sendData
		api.SetUrl = url

		result = api.Run

		' Response.Write "<!-- Request Url : " & PAYCO_AUTH_URL & "/oauth2/revoke" & "<br>"
		' Response.Write "Request Method : POST" & "<br>"
		' Response.Write "Request ContentType : application/x-www-form-urlencoded" & "<br>"
		' Response.Write "Request Authorization : Basic " & PAYCO_CLIENT_SECRET & "<br>"
		' Response.Write "Request Data : " & sendData & "<br>  -->"

		' Response.Write "Result > " & result

		PLog url, sendData, result
		

		if G2_SITE_MODE = "production" then 
			Set oJson = JSON.Parse(result)
			If JSON.hasKey(oJson, "logoutStatus") Then
				logoutStatus = oJson.logoutStatus
			end if 
			domain = Session("domain")
		else
			domain = "main"
			logoutStatus = "LOGOUT_SUCCESS"
		end if 
		
	end if 
	

    Session.Abandon()

'    If oJson.logoutStatus = "LOGOUT_SUCCESS" Then
    If logoutStatus = "LOGOUT_SUCCESS" or Session("access_token") = "" Then
        Select Case domain
            Case "mobile": returnUrl = DEV_BBQ_MOBILE_URL
            Case "main": returnUrl = DEV_BBQ_MAIN_URL
        End Select

		' 자동로그인 삭제.
		Response.Cookies("access_token") = ""
		Response.Cookies("access_token_secret") = ""
		Response.Cookies("refresh_token") = ""
		Response.Cookies("refresh_token_save") = ""
		Response.Cookies("token_type") = ""
		Response.Cookies("expires_in") = ""
		Response.Cookies("auto_login_yn") = ""
		Response.Cookies("bbq_app_type") = ""
		response.cookies("ui") = ""

		Response.Cookies("access_token").Expires = date() - 1
		Response.Cookies("access_token_secret").Expires = date() - 1
		Response.Cookies("refresh_token").Expires = date() - 1
		Response.Cookies("refresh_token_save").Expires = date() - 1
		Response.Cookies("token_type").Expires = date() - 1
		Response.Cookies("expires_in").Expires = date() - 1
		Response.Cookies("auto_login_yn").Expires = date() - 1
		Response.Cookies("bbq_app_type").Expires = date() - 1
		response.cookies("ui").Expires = date() - 1

		Session.Abandon()

		' 순수 도메인
		g2_bbq_d_url_str = g2_domain_filter(g2_bbq_d_url)
		now_bbq_url_str = g2_domain_filter(request.servervariables("HTTP_HOST"))

		multi_domail_login_url = "/api/logoutToken.asp"

		if g2_bbq_d_url_str = now_bbq_url_str then ' PC 버전에서 로그인했다면
			multi_domail_login_url = g2_bbq_m_url & multi_domail_login_url ' 모바일 로그인
		else
			multi_domail_login_url = g2_bbq_d_url & multi_domail_login_url ' PC 로그인
		end if 
%>
		<iframe src="<%=multi_domail_login_url%>" style="display:none"></iframe>

		<script type="text/javascript">
			sessionStorage.removeItem("ss_user_phone");
			showAlertMsg({msg:"로그아웃 되었습니다.", ok: function(){
				location.href = "/";
			}});
		</script>
<%
    Else
%>
		<script type="text/javascript">
			showAlertMsg({msg:"로그아웃에 실패했습니다.",ok: function(){
				location.href = "/";
			}});
		</script>
<%
    End If
%>
</body>
</html>
