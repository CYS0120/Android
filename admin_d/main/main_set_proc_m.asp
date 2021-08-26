<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "A"
	PROCESS_PAGE = "Y"
	CUR_PAGE_SUBCODE = ""
	CD			= InjRequest("CD")
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	brand_code	= FncBrandDBCode(CD)

	main_kind 	= InjRequest("main_kind")
	' Response.Write "Y^"&main_kind
	' response.end
	i = Cint(replace(main_kind, "W", ""))
		
	main_text	= InjRequest("WMAINTEXT"&i)
	main_img	= InjRequest("WMAINIMG"&i)
	link_url	= InjRequest("WLINKURL"&i)
	link_target	= InjRequest("WLINKTARGET"&i)
	BAN_ORD		= InjRequest("WBAN_ORD"&i)
	date_s		= replace(InjRequest("txtFromDate_"&i), "-", "")
	date_e		= replace(InjRequest("txtToDate_"&i), "-", "")
	date_yn		= InjRequest("date_yn_"&i)

	sql = ""
	sql = sql & "EXEC UP_BT_MAIN_IMG 'UPD_M', '"& brand_code &"', '"& main_kind &"', '"& main_text &"', '"& main_img &"', '"& link_url &"', '"& link_target &"', '"& BAN_ORD &"', '"& date_s &"', '"& date_e &"', '"& date_yn &"', '"& SITE_ADM_ID &"'" & vbCrLf

	' response.write "Y^"&sql
	' response.end
	conn.Execute sql
	Response.Write "Y^적용되었습니다."
%>