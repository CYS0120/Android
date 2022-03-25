<%
'utf8.asp에서 include

if not CheckLogin() and (Request.Cookies("refresh_token") <> "" or Request.Cookies("refresh_token_save") <> "") then
    refresh_token = Request.Cookies("refresh_token")
    if len(refresh_token) = 0 then
        refresh_token = Request.Cookies("refresh_token_save")
    end if
    expires_in = Request.Cookies("expires_in")
    auto_login_yn = Request.Cookies("auto_login_yn")

    multi_domail_login_url = "/api/loginToken.asp?refresh_token="& refresh_token &"&auto_login_yn="& auto_login_yn &"&domain="& domain &"&rtnUrl="& GetReturnUrl

	'자동로그인 확인을 위한 로그
	Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& Session("userIdx") &"','['+convert(varchar(19), getdate() , 120)+'] IP " & Request.ServerVariables("LOCAL_ADDR") & " / SessionUserIdNo " & Session("userIdNo") & " / RedirectUrl " & C_STR(multi_domail_login_url) & " / HOST " & Request.ServerVariables("HTTP_HOST") & " / HTTP_URL " & Request.ServerVariables("HTTP_URL") & " / REFERER " & Request.ServerVariables("HTTP_REFERER") & " / TOKEN " & C_STR(refresh_token) & " / TOKEN_SAVE " & C_STR(Request.Cookies("refresh_token_save")) & "','0','keep_login-returnUrl')"
	dbconn.Execute(Sql)

    '(임시 체크) 10초 이전에 동일한 token 있으면 redirect 하지 않는다. 
    if refresh_token <> "" Then 
        Sql = "select seq from bt_order_g2_log  (nolock)  where cast(payco_log as varchar(2000)) like '%"& refresh_token &"%' and cast(substring(cast(payco_log as varchar(2000)), charindex('[', cast(payco_log as varchar(2000)))+1, 19) as datetime) between dateadd(second, -20, getdate()) and dateadd(second, -10, getdate()) and log_point = 'keep_login-returnUrl'"
        set login_rs = dbconn.execute(Sql)
        
        If (login_rs.BOF Or login_rs.EOF) Then
            Response.Redirect multi_domail_login_url
        Else 
            Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& Session("userIdx") &"','['+convert(varchar(19), getdate() , 120)+'] IP " & Request.ServerVariables("LOCAL_ADDR") & " / SessionUserIdNo " & Session("userIdNo") & " / RedirectUrl " & C_STR(multi_domail_login_url) & " / HOST " & Request.ServerVariables("HTTP_HOST") & " / HTTP_URL " & Request.ServerVariables("HTTP_URL") & " / REFERER " & Request.ServerVariables("HTTP_REFERER") & " / TOKEN " & C_STR(refresh_token) & " / TOKEN_SAVE " & C_STR(Request.Cookies("refresh_token_save")) & "','0','keep_login-err')"
            dbconn.Execute(Sql)
            Response.Cookies("refresh_token") = "" 
            Response.Cookies("refresh_token_save") = ""
            Response.Write "다시 시도하시기 바랍니다."
            Response.end
        End if
        set login_rs = nothing 
    End If 
    '//(임시 체크) 끝 

    '위의 (임시 체크) 제거할 때 아래 주석 풀어야 함!!
    'Response.Redirect multi_domail_login_url
end if
%>
