
<%
	dim out

	sql1 = " EXEC BP_SMILE_PROJECT_FINAL '서울' "
	sql2 = " EXEC BP_SMILE_PROJECT_FINAL '경기인천' "
	sql3 = " EXEC BP_SMILE_PROJECT_FINAL '충청' "
	sql4 = " EXEC BP_SMILE_PROJECT_FINAL '영남' "
	sql5 = " EXEC BP_SMILE_PROJECT_FINAL '호남' "
	sql6 = " EXEC BP_SMILE_PROJECT_FINAL '강원' "

'    response.write sql & "<BR>"
'    response.end

	dbconn.CommandTimeout = 600 '100의 단위는 초 입니다.
    set rs1 = dbconn.execute(sql1)
    set rs2 = dbconn.execute(sql2)
    set rs3 = dbconn.execute(sql3)
    set rs4 = dbconn.execute(sql4)
    set rs5 = dbconn.execute(sql5)
    set rs6 = dbconn.execute(sql6)

out = ""
out = out & "<style>"
out = out & "	table {border: 0; text-align: center; margin-bottom: 50px;}"
out = out & "	table .region_title {border: 0; text-align: left; font-size: 20px; font-weight: bold; padding-bottom:10px;}"
out = out & "	table .tdh {font-size: 15px; font-weight: bold; background-color:#feeb38;}"
out = out & "	table td {border: 1px solid #696969; text-align: center; font-size: 13px;}"
out = out & "</style>"


out = out & "<table>"
out = out & "	<tr>"
out = out & "		<td class='region_title' colspan=6>서울</td>"
out = out & "	</tr>"
out = out & "	<tr>"
out = out & "		<td class='tdh' rowspan=2 style='width:50px;'>NO</td>"
out = out & "		<td class='tdh' colspan=2 style='width:200px;'>우선지역</td>"
out = out & "		<td class='tdh' rowspan=2 style='width:150px;'>수험번호</td>"
out = out & "		<td class='tdh' rowspan=2 style='width:100px;'>이름</td>"
out = out & "		<td class='tdh' rowspan=2 style='width:150px;'>전화번호</td>"
out = out & "	</tr>"
out = out & "	<tr>"
out = out & "		<td class='tdh' style='width:100px;'>시,도</td>"
out = out & "		<td class='tdh' style='width:100px;'>군,구</td>"
out = out & "	</tr>"

	If not rs1.eof Then
		do until rs1.eof

out = out & "	<tr>"
out = out & "		<td style='width:50px;'>" & rs1("NO") & "</td>"
out = out & "		<td style='width:100px;'>" & rs1("SIDO") & "</td>"
out = out & "		<td style='width:100px;'>" & rs1("GUNGU") & "</td>"
out = out & "		<td style='width:150px;'>" & rs1("SERIAL_NO") & "</td>"
out = out & "		<td style='width:100px;'>" & rs1("NAME") & "</td>"
out = out & "		<td style='width:150px;'>" & rs1("HP") & "</td>"
out = out & "	</tr>"

			rs1.movenext
		Loop
	End If

out = out & "</table>"

out = out & "<table>"
out = out & "	<tr>"
out = out & "		<td class='region_title' colspan=6>경기인천</td>"
out = out & "	</tr>"
out = out & "	<tr>"
out = out & "		<td class='tdh' rowspan=2 style='width:50px;'>NO</td>"
out = out & "		<td class='tdh' colspan=2 style='width:200px;'>우선지역</td>"
out = out & "		<td class='tdh' rowspan=2 style='width:150px;'>수험번호</td>"
out = out & "		<td class='tdh' rowspan=2 style='width:100px;'>이름</td>"
out = out & "		<td class='tdh' rowspan=2 style='width:150px;'>전화번호</td>"
out = out & "	</tr>"
out = out & "	<tr>"
out = out & "		<td class='tdh' style='width:100px;'>시,도</td>"
out = out & "		<td class='tdh' style='width:100px;'>군,구</td>"
out = out & "	</tr>"

	If not rs2.eof Then
		do until rs2.eof

out = out & "	<tr>"
out = out & "		<td style='width:50px;'>" & rs2("NO") & "</td>"
out = out & "		<td style='width:100px;'>" & rs2("SIDO") & "</td>"
out = out & "		<td style='width:100px;'>" & rs2("GUNGU") & "</td>"
out = out & "		<td style='width:150px;'>" & rs2("SERIAL_NO") & "</td>"
out = out & "		<td style='width:100px;'>" & rs2("NAME") & "</td>"
out = out & "		<td style='width:150px;'>" & rs2("HP") & "</td>"
out = out & "	</tr>"

			rs2.movenext
		Loop
	End If

out = out & "</table>"

out = out & "<table>"
out = out & "	<tr>"
out = out & "		<td class='region_title' colspan=6>충청</td>"
out = out & "	</tr>"
out = out & "	<tr>"
out = out & "		<td class='tdh' rowspan=2 style='width:50px;'>NO</td>"
out = out & "		<td class='tdh' colspan=2 style='width:200px;'>우선지역</td>"
out = out & "		<td class='tdh' rowspan=2 style='width:150px;'>수험번호</td>"
out = out & "		<td class='tdh' rowspan=2 style='width:100px;'>이름</td>"
out = out & "		<td class='tdh' rowspan=2 style='width:150px;'>전화번호</td>"
out = out & "	</tr>"
out = out & "	<tr>"
out = out & "		<td class='tdh' style='width:100px;'>시,도</td>"
out = out & "		<td class='tdh' style='width:100px;'>군,구</td>"
out = out & "	</tr>"

	If not rs3.eof Then
		do until rs3.eof

out = out & "	<tr>"
out = out & "		<td style='width:50px;'>" & rs3("NO") & "</td>"
out = out & "		<td style='width:100px;'>" & rs3("SIDO") & "</td>"
out = out & "		<td style='width:100px;'>" & rs3("GUNGU") & "</td>"
out = out & "		<td style='width:150px;'>" & rs3("SERIAL_NO") & "</td>"
out = out & "		<td style='width:100px;'>" & rs3("NAME") & "</td>"
out = out & "		<td style='width:150px;'>" & rs3("HP") & "</td>"
out = out & "	</tr>"

			rs3.movenext
		Loop
	End If

out = out & "</table>"

out = out & "<table>"
out = out & "	<tr>"
out = out & "		<td class='region_title' colspan=6>영남</td>"
out = out & "	</tr>"
out = out & "	<tr>"
out = out & "		<td class='tdh' rowspan=2 style='width:50px;'>NO</td>"
out = out & "		<td class='tdh' colspan=2 style='width:200px;'>우선지역</td>"
out = out & "		<td class='tdh' rowspan=2 style='width:150px;'>수험번호</td>"
out = out & "		<td class='tdh' rowspan=2 style='width:100px;'>이름</td>"
out = out & "		<td class='tdh' rowspan=2 style='width:150px;'>전화번호</td>"
out = out & "	</tr>"
out = out & "	<tr>"
out = out & "		<td class='tdh' style='width:100px;'>시,도</td>"
out = out & "		<td class='tdh' style='width:100px;'>군,구</td>"
out = out & "	</tr>"

	If not rs4.eof Then
		do until rs4.eof

out = out & "	<tr>"
out = out & "		<td style='width:50px;'>" & rs4("NO") & "</td>"
out = out & "		<td style='width:100px;'>" & rs4("SIDO") & "</td>"
out = out & "		<td style='width:100px;'>" & rs4("GUNGU") & "</td>"
out = out & "		<td style='width:150px;'>" & rs4("SERIAL_NO") & "</td>"
out = out & "		<td style='width:100px;'>" & rs4("NAME") & "</td>"
out = out & "		<td style='width:150px;'>" & rs4("HP") & "</td>"
out = out & "	</tr>"

			rs4.movenext
		Loop
	End If

out = out & "</table>"

out = out & "<table>"
out = out & "	<tr>"
out = out & "		<td class='region_title' colspan=6>호남</td>"
out = out & "	</tr>"
out = out & "	<tr>"
out = out & "		<td class='tdh' rowspan=2 style='width:50px;'>NO</td>"
out = out & "		<td class='tdh' colspan=2 style='width:200px;'>우선지역</td>"
out = out & "		<td class='tdh' rowspan=2 style='width:150px;'>수험번호</td>"
out = out & "		<td class='tdh' rowspan=2 style='width:100px;'>이름</td>"
out = out & "		<td class='tdh' rowspan=2 style='width:150px;'>전화번호</td>"
out = out & "	</tr>"
out = out & "	<tr>"
out = out & "		<td class='tdh' style='width:100px;'>시,도</td>"
out = out & "		<td class='tdh' style='width:100px;'>군,구</td>"
out = out & "	</tr>"

	If not rs5.eof Then
		do until rs5.eof

out = out & "	<tr>"
out = out & "		<td style='width:50px;'>" & rs5("NO") & "</td>"
out = out & "		<td style='width:100px;'>" & rs5("SIDO") & "</td>"
out = out & "		<td style='width:100px;'>" & rs5("GUNGU") & "</td>"
out = out & "		<td style='width:150px;'>" & rs5("SERIAL_NO") & "</td>"
out = out & "		<td style='width:100px;'>" & rs5("NAME") & "</td>"
out = out & "		<td style='width:150px;'>" & rs5("HP") & "</td>"
out = out & "	</tr>"

			rs5.movenext
		Loop
	End If

out = out & "</table>"

out = out & "<table>"
out = out & "	<tr>"
out = out & "		<td class='region_title' colspan=6>강원</td>"
out = out & "	</tr>"
out = out & "	<tr>"
out = out & "		<td class='tdh' rowspan=2 style='width:50px;'>NO</td>"
out = out & "		<td class='tdh' colspan=2 style='width:200px;'>우선지역</td>"
out = out & "		<td class='tdh' rowspan=2 style='width:150px;'>수험번호</td>"
out = out & "		<td class='tdh' rowspan=2 style='width:100px;'>이름</td>"
out = out & "		<td class='tdh' rowspan=2 style='width:150px;'>전화번호</td>"
out = out & "	</tr>"
out = out & "	<tr>"
out = out & "		<td class='tdh' style='width:100px;'>시,도</td>"
out = out & "		<td class='tdh' style='width:100px;'>군,구</td>"
out = out & "	</tr>"

	If not rs6.eof Then
		do until rs6.eof

out = out & "	<tr>"
out = out & "		<td style='width:50px;'>" & rs6("NO") & "</td>"
out = out & "		<td style='width:100px;'>" & rs6("SIDO") & "</td>"
out = out & "		<td style='width:100px;'>" & rs6("GUNGU") & "</td>"
out = out & "		<td style='width:150px;'>" & rs6("SERIAL_NO") & "</td>"
out = out & "		<td style='width:100px;'>" & rs6("NAME") & "</td>"
out = out & "		<td style='width:150px;'>" & rs6("HP") & "</td>"
out = out & "	</tr>"

			rs6.movenext
		Loop
	End If

out = out & "</table>"

response.write out

	rs1.close
	rs2.close
	rs3.close
	rs4.close
	rs5.close
	rs6.close
	dbconn.close

	set rs1 = nothing
	set rs2 = nothing
	set rs3 = nothing
	set rs4 = nothing
	set rs5 = nothing
	set rs6 = nothing
	set dbconn = nothing
%>
