<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "SUPER"
	PROCESS_PAGE = "Y"
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
user_idx	= InjRequest("user_idx")
user_id		= InjRequest("user_id")
user_pass	= InjRequest("user_pass")
user_name	= InjRequest("user_name")
user_empid	= InjRequest("user_empid")
user_level	= InjRequest("user_level")

REG_IP		= GetIPADDR()

If FncIsBlank(user_id) Or FncIsBlank(user_name) Or FncIsBlank(user_empid) Or FncIsBlank(user_level) Then 
	Response.Write "E^필수 정보를 모두 입력해 주세요"
	Response.End
End If 

'On Error Resume Next

If FncIsBlank(user_idx) Then
	If FncIsBlank(user_pass) Then 
		Response.Write "E^비밀번호를 입력해 주세요"
		Response.End
	End If 

	Sql = "Select user_idx From bt_admin_user Where user_id = '"& user_id &"'"
	Set IDrs = conn.Execute(Sql)
	If Not IDrs.Eof Then 
		Response.Write "E^이미 사용중인 아이디 입니다"
		Response.End
	End If
	IDrs.Close
	Set IDrs = Nothing 

	Sql = "	Insert bt_admin_user(user_id, user_pass, user_name, user_empid, user_level, use_yn, del_yn, reg_user_idx, reg_date, reg_ip) " & _
		"	Values('"& user_id &"',HASHBYTES('SHA2_256', '"& user_pass &"'),'"& user_name &"','"& user_empid &"','"& user_level &"', 'Y', 'N', "& SITE_ADM_CD &", GetDate(), '"& REG_IP &"')"
	conn.Execute(Sql)
	Response.Write "Y^등록 되었습니다"
Else
	Sql = "Select user_idx From bt_admin_user Where user_id = '"& user_id &"' And user_idx <> " & user_idx
	Set IDrs = conn.Execute(Sql)
	If Not IDrs.Eof Then 
		Response.Write "E^이미 사용중인 아이디 입니다"
		Response.End
	End If
	IDrs.Close
	Set IDrs = Nothing 

	PassSql = ""
	If Not FncIsBlank(user_pass) Then PassSql = " user_pass = HASHBYTES('SHA2_256', '"& user_pass &"'),"

	Sql = "	Update bt_admin_user Set "& PassSql &" user_id = '"& user_id &"', user_name = '"& user_name &"', user_empid = '"& user_empid &"', user_level = '"& user_level &"', mod_user_idx = '"& SITE_ADM_CD &"', mod_date = GetDate(), mod_ip = '"& REG_IP &"' Where user_idx = " & user_idx
	conn.Execute(Sql)
	Response.Write "Y^수정 되었습니다"
End If

'If Err.number <> 0 then
'	Response.Write "E^"& Err.Description
'End If
conn.Close
Set conn = Nothing 
%>