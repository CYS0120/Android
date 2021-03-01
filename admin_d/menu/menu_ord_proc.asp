<!-- #include virtual="/inc/config.asp" -->
<%
	MENU_IDX = InjRequest("MENU_IDX")
	FVAL	 = InjRequest("FVAL")
	If FncIsBlank(MENU_IDX) Or FncIsBlank(FVAL) Then 
		Response.Write "E^잘못된 접근방식 입니다"
		Response.End 
	End If
	Sql = "	Update bt_menu Set sort="& FVAL &" Where menu_idx = " & MENU_IDX
	conn.Execute(Sql)
	Response.Write "Y^OK"

%>
