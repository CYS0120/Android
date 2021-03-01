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

	BBS_COCE	= InjRequest("BBS_COCE")
	BIDX	= InjRequest("BIDX")
	TOP_FG	= InjRequest("TOP_FG")
	HIS_FG	= InjRequest("HIS_FG")
	HYEAR	= InjRequest("HYEAR")
	HMONTH	= InjRequest("HMONTH")
	TITLE	= InjRequest("TITLE")
	OPEN_FG	= InjRequest("OPEN_FG")
	HISIMG	= InjRequest("HISIMG")

	If FncIsBlank(TITLE) Then 
		Response.Write "E^제목을 입력해 주세요"
		Response.End 
	End If

	If FncIsBlank(BIDX) Then
		Sql = "	Insert Into bt_board_history(TOP_FG, HIS_FG, HYEAR, HMONTH, TITLE, HISIMG, OPEN_FG, REG_NAME, REG_USER_IDX, REG_DATE, REG_IP ) " & _
			"	Values('"& TOP_FG &"','"& HIS_FG &"','"& HYEAR &"','"& HMONTH &"','"& TITLE &"','"& HISIMG &"','"& OPEN_FG &"','"& SITE_ADM_NM &"','"& SITE_ADM_CD &"', GetDate(), '"& REG_IP &"')	"
		conn.Execute(Sql)
		Response.Write "Y^등록 되었습니다"
		Response.End
	Else
		Sql = "	Update bt_board_history Set TOP_FG='"& TOP_FG &"', HIS_FG='"& HIS_FG &"', HYEAR='"& HYEAR &"', HMONTH='"& HMONTH &"', TITLE='"& TITLE &"', HISIMG='"& HISIMG &"', OPEN_FG='"& OPEN_FG &"' Where BIDX = " & BIDX
		conn.Execute(Sql)
		Response.Write "Y^수정 되었습니다"
		Response.End
	End If
%>
