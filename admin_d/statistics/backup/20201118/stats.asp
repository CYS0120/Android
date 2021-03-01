<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "H"
	CUR_PAGE_SUBCODE = ""
	CD = InjRequest("CD")
	If Not FncIsBlank(CD) Then CUR_PAGE_SUBCODE = CD	'현재 선택된 서브메뉴에 대한 권한을 체크하기 위해서 설정
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%

	If FncIsBlank(CD) Then CD = Left(ADMIN_CHECKMENU1,1)	'초기 선택 메뉴값은 권한설정페이지에서 가져온 ADMIN_CHECKMENU1 값중 첫번째 값

	If SITE_ADM_LV = "S" Then
		Sql = "Select top 1 bbs From bt_code_menu Where menu_depth = 2 AND menu_code = 'H' And menu_code1='" & CD &"' order by menu_order"
	Else
		MENU_CODE2 = Replace(ADMIN_CHECKMENU2,",","','")
		Sql = "Select top 1 bbs From bt_code_menu Where menu_depth = 2 AND menu_code = 'H' And menu_code1='" & CD &"' And menu_code2 in ('"& MENU_CODE2 &"') order by menu_order"
	End If
	Set Rs = conn.Execute(Sql)
	If Not Rs.eof Then
		Response.Redirect Rs("bbs") & "?CD=" & CD
	Else
		Call subGoToMsg("권한이 없는 페이지 입니다","back")
	End If
%>