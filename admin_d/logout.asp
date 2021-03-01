<!-- #include virtual="/inc/config.asp" -->
<%
	Call SET_COOKIES("SITE_ADM_CD","")
	Call SET_COOKIES("SITE_ADM_ID","")
	Call SET_COOKIES("SITE_ADM_NM","")
	Call SET_COOKIES("SITE_ADM_LV","")

	Response.Cookies("SITE_ADM_CD").expires = date - 1
	Response.Cookies("SITE_ADM_ID").expires = date - 1
	Response.Cookies("SITE_ADM_NM").expires = date - 1
	Response.Cookies("SITE_ADM_LV").expires = date - 1

	Response.Redirect("./")
%>
