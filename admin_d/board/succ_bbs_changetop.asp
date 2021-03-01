<!-- #include virtual="/inc/config.asp" -->
<%
	BIDX	= InjRequest("BIDX")
	TOP_FG	= InjRequest("TOP_FG")

	Sql = "Update bt_board_succ Set top_fg='N' Where BIDX IN ("& BIDX &")"
	conn.Execute(Sql)

	Sql = "Update bt_board_succ Set top_fg='Y' Where BIDX IN ("& TOP_FG &")"
	conn.Execute(Sql)

	Response.Write "Y^변경되었습니다."
	Response.End 

%>
