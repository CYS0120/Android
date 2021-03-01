<!-- #include virtual="/inc/config.asp" -->
<%
user_id		= InjRequest("user_id")
user_pass	= InjRequest("user_pass")
txtCaptcha	= InjRequest("txtCaptcha")
REG_IP = GetIPADDR()

If FncIsBlank(user_id) Or FncIsBlank(user_pass) Then 
	Response.Write "E^아이디와 비밀번호를 모두 입력해 주세요"
	Response.End
End If 

If FncIsBlank(txtCaptcha) Then 
	Response.Write "E^보안코드를 입력해 주세요"
	Response.End
End If 

If txtCaptcha <> session("ASPCAPTCHA") Then
	Response.Write "E^보안코드가 일치하지 않습니다."
	Response.End
End if

Sql	= "Select user_idx, user_name, user_level, use_yn, menuA1 From bt_admin_user Where user_id='"& user_id &"' And user_pass = HASHBYTES('SHA2_256', '"& user_pass &"')"
Set Linfo = conn.Execute(Sql)
If Linfo.eof Then 
	Response.Write "E^아이디가 없거나 비밀번호가 일치하지 않습니다"
	Response.End
End If 

user_idx	= Linfo("user_idx")
user_name	= Linfo("user_name")
user_level	= Linfo("user_level")
menuA1		= Linfo("menuA1")
use_yn		= Linfo("use_yn")
Linfo.close

If use_yn = "Y" Then
	If user_level <> "S" Then
		If FncIsBlank(menuA1) Then 
			Response.Write "E^이용 설정된 페이지가 없습니다. 관리자에 문의해 주세요"
			Response.End
		End If 
	End If

	Sql = "Insert Into bt_admin_log(USER_IDX, USER_ID, LOGIN_IP, LOGIN_DATE) Values("& user_idx &",'"& user_id &"','"& REG_IP &"',Getdate())"
	conn.Execute(Sql)

	Call SET_COOKIES("SITE_ADM_CD",user_idx)
	Call SET_COOKIES("SITE_ADM_ID",user_id)
	Call SET_COOKIES("SITE_ADM_NM",user_name)
	Call SET_COOKIES("SITE_ADM_LV",user_level)

	Response.Write "Y^OK"
	Response.End
Else
	Response.Write "E^이용권한이 없는 아이디 입니다"
	Response.End
End If 
%>
