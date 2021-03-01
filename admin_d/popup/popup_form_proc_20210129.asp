<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "F"
	PROCESS_PAGE = "Y"
	CUR_PAGE_SUBCODE = ""

	REG_IP	= GetIPADDR()
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	brand_code	= InjRequest("brand_code")
	PIDX		= InjRequest("PIDX")
	popup_kind	= InjRequest("popup_kind")
	open_sdate	= InjRequest("open_sdate")
	open_edate	= InjRequest("open_edate")
	popup_width	= InjRequest("popup_width")
	popup_height	= InjRequest("popup_height")
	reserve_yn	= InjRequest("reserve_yn")
	reserve_date	= InjRequest("reserve_date")
	popup_left	= InjRequest("popup_left")
	popup_top	= InjRequest("popup_top")
	popup_close	= InjRequest("popup_close")
	popup_title	= InjRequest("popup_title")
	popup_img	= InjRequest("popup_img")

	If reserve_yn = "N" Then reserve_date=""

	If FncIsBlank(PIDX) Then
		Sql = "	Insert Into bt_popup(brand_code, popup_kind, open_sdate, open_edate, popup_width, popup_height, " & _
			"		reserve_yn, reserve_date, popup_left, popup_top, popup_close, popup_title, popup_img,  " & _
			"		reg_user_idx, reg_date, reg_ip	) " & _
			"	Values('"& brand_code &"','"& popup_kind &"','"& open_sdate &"','"& open_edate &"','"& popup_width &"','"& popup_height &"', " & _
			"		'"& reserve_yn &"','"& reserve_date &"','"& popup_left &"','"& popup_top &"','"& popup_close &"','"& popup_title &"','"& popup_img &"', " & _
			"		'"& SITE_ADM_CD &"',GetDate(),'"& REG_IP &"')	"
		conn.Execute(Sql)
		Response.Write "Y^등록 되었습니다."
	Else
		Sql = "	Update bt_popup Set brand_code='"& brand_code &"', popup_kind='"& popup_kind &"', open_sdate='"& open_sdate &"', open_edate='"& open_edate &"', popup_width='"& popup_width &"', popup_height='"& popup_height &"', reserve_yn='"& reserve_yn &"', reserve_date='"& reserve_date &"', popup_left='"& popup_left &"', popup_top='"& popup_top &"', popup_close='"& popup_close &"', popup_title='"& popup_title &"', popup_img='"& popup_img &"', mod_user_idx='"& SITE_ADM_CD &"', mod_date=GetDate(), mod_ip='"& REG_IP &"' Where popup_idx = " & PIDX
		conn.Execute(Sql)
		Response.Write "Y^수정 되었습니다."
	End If
%>
