<!-- #include virtual="/inc/config.asp" -->

<%
	' response.charset = "utf-8"
	' response.expiresabsolute = now() - 1
	' response.addheader "pragma", "no-cache"
	' response.addheader "cache-control", "private"
	' response.cachecontrol = "no-cache"
    ' Session.CodePage=65001

	Dim rsType
	Dim sido_name, sigungu_name
	Dim query
	Dim out

    sido_name = Request("sido_name")
    sigungu_name = Request("sigungu_name")

	query = ""
	query = query & "  SELECT h_code, b_code, h_name+'('+b_name+')' as dong_name      										"
	query = query & "  FROM bt_address_dong WITH (NOLOCK)                 													"
	query = query & "  WHERE sido_name = '" & sido_name  & "' AND sigungu_name = '" & sigungu_name & "' AND h_name <> '' 	"
	query = query & "  ORDER BY h_code, b_code                 																"
	' response.write query
	' response.end

    Set rsType = conn.Execute(query)

	out = "<option value=""""></option>"
   	While Not rsType.EOF
		out = out & "	<option value=""" & rsType("h_code") & "|" & rsType("b_code") & """>" & rsType("dong_name") & "</option>"

		rsType.movenext
    Wend

    Response.Write out

	rsType.Close
	Set rsType = Nothing

	conn.Close
	Set conn = Nothing
%>