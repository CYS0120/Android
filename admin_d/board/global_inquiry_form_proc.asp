<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "E"
	REG_IP	= GetIPADDR()

	IDX	 = InjRequest("IDX")
	ANSWER = InjRequest("ANSWER")
	MODE = InjRequest("MODE")

%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	If FncIsBlank(IDX) Or FncIsBlank(MODE) Then 
		Response.Write "E^잘못된 접근방식입니다."
		Response.End
	End If

	If MODE = "IN" Then 
		Sql = "Update bt_global_inquiry Set STATUS='Y', AREG_DATE=GetDate(), AUSER_IDX='"& SITE_ADM_CD &"', ANSWER='"& ANSWER &"', AREG_IP='"& REG_IP &"' Where IDX=" & IDX
		conn.Execute(Sql)
		Response.Write "Y^적용되었습니다."
		Response.End
	ElseIf MODE = "UP" Then 
		Sql = "Update bt_global_inquiry Set ANSWER='"& ANSWER &"' Where IDX=" & IDX
		conn.Execute(Sql)
		Response.Write "Y^적용되었습니다."
		Response.End
	ElseIf MODE = "DEL" Then 
		Sql = "Delete From bt_global_inquiry Where IDX=" & IDX
		conn.Execute(Sql)
		Response.Write "Y^삭제되었습니다."
		Response.End
	Else
		Response.Write "E^잘못된 접근방식입니다."
		Response.End
	End If 
%>
