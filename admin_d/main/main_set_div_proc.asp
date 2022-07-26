<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "A"
	PROCESS_PAGE = "Y"
	CUR_PAGE_SUBCODE = ""
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	brand_code	= InjRequest("brand_code")
	main_kind	= InjRequest("main_kind")
	proc_type		= Request("proc_type")

	Sql = "EXEC UP_BT_MAIN_IMG '" & proc_type & "', '" & brand_code & "', '" & main_kind & "', '', '', '', '', '', '', '', '', '" & SITE_ADM_ID & "' "
	' response.write "Y^"&Sql
	' response.end
	conn.Execute Sql

	If left(proc_type,3) = "DEL" Then
		Response.Write "Y^삭제되었습니다."
	ElseIf left(proc_type,3) = "INS" Then
		Response.Write "Y^추가되었습니다."
	End If
%>