<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "D"
	PROCESS_PAGE = "Y"

	CD	= InjRequest("CD")
	MIDX = InjRequest("MIDX")
	If FncIsBlank(CD) Or FncIsBlank(MIDX) Then 
		Response.Write "E^잘못된 접근방식입니다"
		Response.End
	End If
	CUR_PAGE_SUBCODE = CD	'현재 선택된 서브메뉴에 대한 권한을 체크하기 위해서 설정
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	Sql = "Delete From bt_menu_parent_file where menu_idx = "& MIDX
	conn.Execute(Sql)

	Sql = "Delete From bt_menu_parent Where menu_idx = " & MIDX
	conn.Execute(Sql)

	Response.Write "Y^삭제 되었습니다"
	Response.End
%>
