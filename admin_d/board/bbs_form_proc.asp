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

	imgpath = "/bbsimg"
	filepath = "/bbsfile"

	brand_code	= FncBrandDBCode(CD)

	BIDX		= InjRequest("BIDX")
	bbs_code	= InjRequest("BBSCODE")
	top_fg		= InjRequest("top_fg")
	sdate		= InjRequest("sdate")
	edate		= InjRequest("edate")
	edate_fg	= InjRequest("edate_fg")
	title		= InjRequest("title")
	contents	= InjRequest("contents")
	subtitle	= InjRequest("subtitle")
	url_link	= InjRequest("url_link")
	etcdate_fg	= InjRequest("etcdate_fg")
	etcdate		= InjRequest("etcdate")
	open_fg		= InjRequest("open_fg")
	imgname		= InjRequest("imgname")
	filename	= InjRequest("filename")

	If FncIsBlank(top_fg) Then top_fg = "N"

	If FncIsBlank(brand_code) Then 
		Response.Write "E^1"
		Response.End 
	End If

	If FncIsBlank(bbs_code) Then 
		Response.Write "E^2"
		Response.End 
	End If

	If FncIsBlank(brand_code) Or FncIsBlank(bbs_code) Then 
		Response.Write "E^잘못된 접근방식 입니다"
		Response.End 
	End If

	If FncIsBlank(BIDX) Then
		Sql = "	Insert Into bt_board_list(brand_code, bbs_code, top_fg, sdate, edate, edate_fg, title, contents, subtitle,  " & _
			"		url_link, etcdate_fg, etcdate, imgpath, imgname, filepath, filename, open_fg, hit,   " & _
			"		reg_name, reg_user_idx, reg_date, reg_ip	) " & _
			"	Values('"& brand_code &"','"& bbs_code &"','"& top_fg &"','"& sdate &"','"& edate &"','"& edate_fg &"','"& title &"','"& contents &"','"& subtitle &"', " & _
			"		'"& url_link &"','"& etcdate_fg &"','"& etcdate &"','"& imgpath &"','"& imgname &"','"& filepath &"','"& filename &"','"& open_fg &"', 0, " & _
			"		'"& SITE_ADM_NM &"','"& SITE_ADM_CD &"',GetDate(),'"& REG_IP &"')	"
		conn.Execute(Sql)
		Response.Write "Y^등록 되었습니다"
		Response.End 
	Else
		Sql = "	Update bt_board_list Set top_fg='"& top_fg &"', sdate='"& sdate &"', edate='"& edate &"', edate_fg='"& edate_fg &"', title='"& title &"', contents='"& contents &"', subtitle='"& subtitle &"', url_link='"& url_link &"', etcdate_fg='"& etcdate_fg &"', etcdate='"& etcdate &"', imgname='"& imgname &"', filename='"& filename &"', open_fg='"& open_fg &"', mod_user_idx='"& SITE_ADM_CD &"', mod_date=GetDate(), mod_ip='"& REG_IP &"' Where BIDX = " & BIDX
		conn.Execute(Sql)
		Response.Write "Y^수정 되었습니다"
		Response.End
	End If
%>
