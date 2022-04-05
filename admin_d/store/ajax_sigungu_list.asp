<!-- #include virtual="/inc/config.asp" -->

<%
	' response.charset = "utf-8"
	' response.expiresabsolute = now() - 1
	' response.addheader "pragma", "no-cache"
	' response.addheader "cache-control", "private"
	' response.cachecontrol = "no-cache"
    ' Session.CodePage=65001

	Dim rsType
	Dim sido_name
	Dim query
	Dim out

    sido_name = Request("sido_name")

	query = ""
	query = query & "  SELECT DISTINCT sigungu_name                 				"
	query = query & "  FROM bt_address_dong WITH (NOLOCK)                 			"
	query = query & "  WHERE sido_name = '" & sido_name  & "' AND h_name <> ''      "
	query = query & "  ORDER BY sigungu_name                 						"
	' response.write query
	' response.end

    Set rsType = conn.Execute(query)

	out = "<option value=""""></option>"
   	While Not rsType.EOF
		out = out & "	<option value=""" & rsType("sigungu_name") & """>" & rsType("sigungu_name") & "</option>"

		rsType.movenext
    Wend

    Response.Write out

	rsType.Close
	Set rsType = Nothing

	conn.Close
	Set conn = Nothing
%>