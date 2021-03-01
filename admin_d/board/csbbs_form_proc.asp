<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "E"
	REG_IP	= GetIPADDR()

	CD = InjRequest("CD")
	q_idx = InjRequest("q_idx")
	a_body = InjRequest("a_body")
	MODE = InjRequest("MODE")

	CUR_PAGE_SUBCODE = CD	'현재 선택된 서브메뉴에 대한 권한을 체크하기 위해서 설정
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	If FncIsBlank(CD) Or FncIsBlank(q_idx) Or FncIsBlank(MODE) Then 
		Response.Write "E^잘못된 접근방식입니다."
		Response.End
	End If

	If MODE = "USE" Then
		open_fg = InjRequest("open_fg")
		Sql = "Update bt_member_q Set open_fg='"& open_fg &"' Where q_idx=" & q_idx
		conn.Execute(Sql)
		Response.Write "Y^적용되었습니다."
		Response.End
	ElseIf MODE = "IN" Then 
		Sql = "Update bt_member_q Set q_status='답변완료', a_date=GetDate(), a_user_idx='"& SITE_ADM_CD &"', a_body='"& a_body &"', a_regip='"& REG_IP &"' Where q_idx=" & q_idx
		conn.Execute(Sql)
		Response.Write "Y^적용되었습니다."
		Response.End
	ElseIf MODE = "UP" Then 
		Sql = "Update bt_member_q Set a_body='"& a_body &"' Where q_idx=" & q_idx
		conn.Execute(Sql)
		Response.Write "Y^적용되었습니다."
		Response.End
	ElseIf MODE = "DEL" Then 
		Sql = "Update bt_member_q Set q_status='답변대기', a_date=null, a_user_idx=null, a_body=null, a_regip=null Where q_idx=" & q_idx
		conn.Execute(Sql)
		Response.Write "Y^적용되었습니다."
		Response.End
	Else
		Response.Write "E^잘못된 접근방식입니다."
		Response.End
	End If 
%>
