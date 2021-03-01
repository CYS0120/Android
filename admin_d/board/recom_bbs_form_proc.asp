<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "E"
	REG_IP	= GetIPADDR()

	CD = InjRequest("CD")
	BIDX = InjRequest("BIDX")
	BSTATUS = InjRequest("BSTATUS")
	RBRAND_NAME = InjRequest("RBRAND_NAME")
	MODE = InjRequest("MODE")

	CUR_PAGE_SUBCODE = CD	'현재 선택된 서브메뉴에 대한 권한을 체크하기 위해서 설정
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	If FncIsBlank(CD) Or FncIsBlank(BSTATUS) Or FncIsBlank(BIDX) Or FncIsBlank(MODE) Then 
		Response.Write "E^잘못된 접근방식입니다."
		Response.End
	End If

	If MODE = "IN" Then 
		Sql = "Update bt_board_recom Set BSTATUS='"& BSTATUS &"', AREG_DATE=GetDate(), AREG_USER_IDX='"& SITE_ADM_CD &"', RBRAND_NAME='"& RBRAND_NAME &"', AREG_IP='"& REG_IP &"' Where BIDX=" & BIDX
		conn.Execute(Sql)
		Response.Write "Y^적용되었습니다."
		Response.End
	ElseIf MODE = "UP" Then 
		Sql = "Update bt_board_recom Set BSTATUS='"& BSTATUS &"', AREG_DATE=GetDate(), AREG_USER_IDX='"& SITE_ADM_CD &"', RBRAND_NAME='"& RBRAND_NAME &"', AREG_IP='"& REG_IP &"' Where BIDX=" & BIDX
		conn.Execute(Sql)
		Response.Write "Y^적용되었습니다."
		Response.End
	ElseIf MODE = "DEL" Then 
		Sql = "Delete From bt_board_recom Where BIDX=" & BIDX
		conn.Execute(Sql)
		Response.Write "Y^적용되었습니다."
		Response.End
	Else
		Response.Write "E^잘못된 접근방식입니다."
		Response.End
	End If 
%>
