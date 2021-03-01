<!-- #include virtual="/inc/config.asp" -->
<%
	BBSCODE	= InjRequest("BBSCODE")
	BIDX	= InjRequest("BIDX")

	If FncIsBlank(BBSCODE) Or FncIsBlank(BIDX) Then
		Response.Write "E^변경할 항목을 입력해 주세요"
		Response.End 
	End If

	Sql = "Update bt_board_list Set top_fg='N' Where bbs_code='"& BBSCODE &"' And top_fg='Y'"
	conn.Execute(Sql)

	Sql = "Update bt_board_list Set top_fg='Y' Where BIDX="& BIDX
	conn.Execute(Sql)

	Response.Write "Y^변경되었습니다."
	Response.End 

%>
