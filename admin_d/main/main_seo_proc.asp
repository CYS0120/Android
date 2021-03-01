<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "A"
	PROCESS_PAGE = "Y"
	CUR_PAGE_SUBCODE = ""
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	brand_code = InjRequest("brand_code")
	seo_use = InjRequest("seo_use")
	seo_title = InjRequest("seo_title")
	seo_desc = InjRequest("seo_desc")
	seo_keywords = InjRequest("seo_keywords")
	seo_classification = InjRequest("seo_classification")

	Sql = "Update bt_main_seo Set seo_use='"& seo_use &"', seo_title='"& seo_title &"', seo_desc='"& seo_desc &"', seo_keywords='"& seo_keywords &"', seo_classification='"& seo_classification &"' Where brand_code='"& brand_code &"'"
	conn.Execute Sql, Uplow
	If Uplow > 0 Then 
	Else 
		Sql = "	Insert Into bt_main_seo(brand_code, seo_use, seo_title, seo_desc, seo_keywords, seo_classification)	" & _
			"	values('"& brand_code &"','"& seo_use &"','"& seo_title &"','"& seo_desc &"','"& seo_keywords &"','"& seo_classification &"')"
		conn.Execute(Sql)
	End If
	Response.Write "Y^저장 되었습니다"
	Response.End
%>
