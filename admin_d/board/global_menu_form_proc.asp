<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "E"
	PROCESS_PAGE = "Y"

	REG_IP	= GetIPADDR()

	CD = InjRequest("CD")
	CUR_PAGE_SUBCODE = CD	'현재 선택된 서브메뉴에 대한 권한을 체크하기 위해서 설정
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%

	brand_code	= FncBrandDBCode(CD)

	MIDX		= InjRequest("MIDX")
	MCAT		= InjRequest("MCAT")
	MENU_NAME	= InjRequest("MENU_NAME")
	MENU_SNAME	= InjRequest("MENU_SNAME")
	MENU_EXPLAN	= InjRequest("MENU_EXPLAN")
	THUMBIMG	= InjRequest("THUMBIMG")
	IMGNAME1	= InjRequest("IMGNAME1")
	IMGNAME2	= InjRequest("IMGNAME2")
	IMGNAME3	= InjRequest("IMGNAME3")
	OPEN_FG		= InjRequest("OPEN_FG")

	If FncIsBlank(MCAT) Or FncIsBlank(MENU_NAME) Or FncIsBlank(THUMBIMG) Or FncIsBlank(IMGNAME1) Or FncIsBlank(OPEN_FG) Then 
		Response.Write "E^잘못된 접근방식 입니다"
		Response.End 
	End If

	If FncIsBlank(MIDX) Then
		Sql = "	Insert Into bt_global_menu(MCAT, MENU_NAME, MENU_SNAME, MENU_EXPLAN, THUMBIMG, IMGNAME1, IMGNAME2, IMGNAME3, OPEN_FG, REG_USER_IDX, REG_DATE, REG_IP) " & _
			"	Values('"& MCAT &"','"& MENU_NAME &"','"& MENU_SNAME &"','"& MENU_EXPLAN &"','"& THUMBIMG &"','"& IMGNAME1 &"','"& IMGNAME2 &"','"& IMGNAME3 &"','"& OPEN_FG &"', " & _
			"		'"& SITE_ADM_CD &"',GetDate(),'"& REG_IP &"')	"
		conn.Execute(Sql)
		Response.Write "Y^등록 되었습니다"
		Response.End 
	Else
		Sql = "	Update bt_global_menu Set MCAT='"& MCAT &"', MENU_NAME='"& MENU_NAME &"', MENU_SNAME='"& MENU_SNAME &"', MENU_EXPLAN='"& MENU_EXPLAN &"', THUMBIMG='"& THUMBIMG &"', IMGNAME1='"& IMGNAME1 &"', IMGNAME2='"& IMGNAME2 &"', IMGNAME3='"& IMGNAME3 &"', OPEN_FG='"& OPEN_FG &"' Where MIDX = " & MIDX
		conn.Execute(Sql)
		Response.Write "Y^수정 되었습니다"
		Response.End
	End If
%>
