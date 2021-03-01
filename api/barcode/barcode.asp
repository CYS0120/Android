<%
Sub Barcode(bc_string, bc_height, bc_width, bc_text)
	If bc_height < 1 Then bc_height=30
	If bc_width < 1 Then bc_width=1
	Dim bc(90)
	bc(1) = "1 1221"
	bc(2) = "1 1221"
	bc(48) = "11 221"
	bc(49) = "21 112"
	bc(50) = "12 112"
	bc(51) = "22 111"
	bc(52) = "11 212"
	bc(53) = "21 211"
	bc(54) = "12 211"
	bc(55) = "11 122"
	bc(56) = "21 121"
	bc(57) = "12 121"
	bc(65) = "211 12"
	bc(66) = "121 12"
	bc(67) = "221 11"
	bc(68) = "112 12"
	bc(69) = "212 11"
	bc(70) = "122 11"
	bc(71) = "111 22"
	bc(72) = "211 21"
	bc(73) = "121 21"
	bc(74) = "112 21"
	bc(75) = "2111 2"
	bc(76) = "1211 2"
	bc(77) = "2211 1"
	bc(78) = "1121 2"
	bc(79) = "2121 1"
	bc(80) = "1221 1"
	bc(81) = "1112 2"
	bc(82) = "2112 1"
	bc(83) = "1212 1"
	bc(84) = "1122 1"
	bc(85) = "2 1112"
	bc(86) = "1 2112"
	bc(87) = "2 2111"
	bc(88) = "1 1212"
	bc(89) = "2 1211"
	bc(90) = "1 2211"
	bc(32) = "1 2121"
	bc(35) = ""
	bc(36) = "1 1 1 11"
	bc(37) = "11 1 1 1"
	bc(43) = "1 11 1 1"
	bc(45) = "1 1122"
	bc(47) = "1 1 11 1"
	bc(46) = "2 1121"
	bc(64) = ""
	bc(65) = "1 1221"
	bc_string = UCase(bc_string)
	new_string = Chr(1) & bc_string & Chr(2)
	Response.Write("<table border=0 cellpadding=0 cellspacing=0>")
	Response.Write("<tr>")
	intCols = 0
	For n = 1 To Len(new_string)
	c = Asc(Mid(new_string, n, 1))
		If c > 90 Then c = 0
		bc_pattern = bc(c)
		For i = 1 To Len(bc_pattern)
			Select Case Mid(bc_pattern, i, 1)
				Case " "
					' you may need to change the src path below to where your images are located
					Response.Write("<td><img height=" & bc_height & " src=/api/barcode/img/1x1white.gif width=" & bc_width & "></td>")
					intCols = intCols + 1
				Case "1"
					Response.Write("<td><img height=" & bc_height & " src=/api/barcode/img/1x1white.gif width=" & bc_width & "></td>")
					Response.Write("<td><img height=" & bc_height & " src=/api/barcode/img/1x1black.gif width=" & bc_width & "></td>")
					intCols = intCols + 2
				Case "2"
					Response.Write("<td><img height=" & bc_height & " src=/api/barcode/img/1x1white.gif width=" & bc_width & "></td>")
					Response.Write("<td><img height=" & bc_height & " src=/api/barcode/img/1x1black.gif width=" & (bc_width * 2) & "></td>")
					intCols = intCols + 2
			End Select
		Next
	Next
	Response.Write("<td><img height=" & bc_height & " src=/api/barcode/img/1x1white.gif width=" & bc_width & "></td>")
	intCols = intCols + 1
	Response.Write("</tr>")

	If bc_text Then
		Response.Write("<tr>")
		Response.Write("<td align=""center"" colspan=""" & intCols & """>" & bc_string & "</td>")
		Response.Write("</tr>")
	End If

	Response.Write("</table>" & vbCrLf)
End Sub

%>