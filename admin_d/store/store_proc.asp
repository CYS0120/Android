<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "C"
	PROCESS_PAGE = "Y"

	CD = InjRequest("CD")
	If Not FncIsBlank(CD) Then CUR_PAGE_SUBCODE = CD	'현재 선택된 서브메뉴에 대한 권한을 체크하기 위해서 설정
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	BRANCH_ID	= InjRequest("BRANCH_ID")
	CH			= InjRequest("CH")
	FVAL		= InjRequest("VAL")
	If FncIsBlank(CD) Or FncIsBlank(CH) Or FncIsBlank(BRANCH_ID) Or FncIsBlank(FVAL) Then 
		Response.Write "E^잘못된 접근방식입니다"
		Response.End
	End If 

	If CH = "M" Then 
		Sql = "	Update bt_branch Set membership_yn_code='"& FVAL &"' Where branch_id = '" & branch_id & "'"
		conn.Execute(Sql)
	ElseIf CH = "C" Then 
		Sql = "	Update bt_branch Set coupon_yn='"& FVAL &"' Where branch_id = '" & branch_id & "'"
		conn.Execute(Sql)
	End If 

	Response.Write "Y^적용 되었습니다"
	Response.End
%>
