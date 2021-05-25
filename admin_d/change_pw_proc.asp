<!-- #include virtual="/inc/config.asp" -->
<%
user_idx 	= InjRequest("user_idx")
user_id		= InjRequest("user_id")
user_pass	= InjRequest("user_pass")
user_pass_2	= InjRequest("user_pass_2")
REG_IP = GetIPADDR()

If FncIsBlank(user_id) Or FncIsBlank(user_pass) Then 
	Response.Write "E^비밀번호를 입력해 주세요"
	Response.End
Else
	sql = "EXEC UP_ADMIN_PASSWORD_CHANGE 'CHANGE', '" & user_idx & "', '" & user_id & "', '" & user_pass & "', '" & user_pass_2 & "', '" & REG_IP & "'"
	' response.write "E^" & sql
	' response.end
	Set Linfo = conn.Execute(sql)
	response.write Linfo("ALERT_CD")

	split_out = LEFT(Linfo("ALERT_CD"), 1)
	if split_out = "Y" then
		user_idx = Linfo("user_idx")
		user_id = Linfo("user_id")
		user_name = Linfo("user_name")
		user_level = Linfo("user_level")

		Call SET_COOKIES("SITE_ADM_CD",user_idx)
		Call SET_COOKIES("SITE_ADM_ID",user_id)
		Call SET_COOKIES("SITE_ADM_NM",user_name)
		Call SET_COOKIES("SITE_ADM_LV",user_level)
	end if

	Linfo.close
End If 
%>
