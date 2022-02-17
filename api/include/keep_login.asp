<%

if not CheckLogin() and (Request.Cookies("refresh_token") <> "" or Request.Cookies("refresh_token_save") <> "") then
    refresh_token = Request.Cookies("refresh_token")
    if len(refresh_token) = 0 then
        refresh_token = Request.Cookies("refresh_token_save")
    end if
    expires_in = Request.Cookies("expires_in")
    auto_login_yn = Request.Cookies("auto_login_yn")

    multi_domail_login_url = "/api/loginToken.asp?refresh_token="& refresh_token &"&auto_login_yn="& auto_login_yn &"&domain="& domain &"&rtnUrl="& GetReturnUrl
    
	'자동로그인 확인을 위한 로그
	Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& Session("userIdx") &"','['+convert(varchar(19), getdate() , 120)+'] IP " & Request.ServerVariables("LOCAL_ADDR") & " / RedirectUrl " & C_STR(multi_domail_login_url) & " / HOST " & Request.ServerVariables("HTTP_HOST") & " / HTTP_URL " & Request.ServerVariables("HTTP_URL") & " / REFERER " & Request.ServerVariables("HTTP_REFERER") & " / " & Request.ServerVariables("HTTP_USER_AGENT") & " / " & Request.Cookies("refresh_token") & "','0','keep_login-returnUrl')"
	dbconn.Execute(Sql)

    Response.Redirect multi_domail_login_url
end if
%>
