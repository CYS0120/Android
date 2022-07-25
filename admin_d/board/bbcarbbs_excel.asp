<!-- #include virtual="/inc/config.asp" -->
<%
'' 엑셀로 저장
	Dim FileName : FileName = "" & Date() & "_BBCar_Data"
	Response.ContentType = "application/x-msexcel"
	Response.CacheControl = "public"
	Response.AddHeader "Content-Disposition", "attachment;filename=" & FileName & ".xls"
%><%
	CUR_PAGE_CODE = "E"
	CUR_PAGE_SUBCODE = ""
	CD = InjRequest("CD")
	If Not FncIsBlank(CD) Then CUR_PAGE_SUBCODE = CD	'현재 선택된 서브메뉴에 대한 권한을 체크하기 위해서 설정
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	server.scripttimeout = 10000

	BBSCODE = InjRequest("BBSCODE")
	SDATE	= InjRequest("SDATE")
	EDATE	= InjRequest("EDATE")
	YR	= InjRequest("YR")
	MTH	= InjRequest("MTH")
	CTY	= InjRequest("CTY")

	num_per_page	= InjRequest("LNUM")
	page 			= InjRequest("page")
	If page = "" Then page = 1

%>
<meta charset="utf-8">
	<table border="1">
		<tr>
			<td>번호</td>
			<td>회원페이코아이디</td>
			<td>회원아이디</td>
			<td>회원명</td>
			<td>회원연락처</td>
			<td>회원이메일</td>
			<td>단체명</td>
			<td>방문신청년월</td>
			<td>방문신청일자</td>
			<td>방문신청도시</td>
			<td>방문신청주소</td>
			<td>제목</td>
			<td>신청사연</td>
			<td>첨부파일1</td>
			<td>첨부파일2</td>
			<td>첨부파일3</td>
			<td>등록일시</td>
		</tr>
<%

	Sql = ""
	Sql = Sql & "	UP_LIST_MEMBER_BBCAR "
	Sql = Sql & "	    @TP = 'EXCEL' "
	Sql = Sql & "	    , @DATE_S = '" & SDATE & "' "
	Sql = Sql & "	    , @DATE_E = '" & CDate(EDATE)+1 & "' "
	Sql = Sql & "	    , @YR = '" & YR & "' "
	Sql = Sql & "	    , @MTH = '" & MTH & "' "
	Sql = Sql & "	    , @CITY = '" & CTY & "' "
	Sql = Sql & "	    , @PAGE_SIZE = " & num_per_page & " "
	Sql = Sql & "	    , @PAGE = " & page & " "

	' response.write Sql
	' response.end

	Set Rlist = conn.Execute(Sql)
	If Not Rlist.Eof Then 
		Do While Not Rlist.Eof
			idx	= Rlist("idx")
			member_idno	= Rlist("member_idno")
			member_id	= Rlist("member_id")
			member_name	= Rlist("member_name")
			member_hp	= Rlist("member_hp")
			member_email	= Rlist("member_email")
			org_name	= Rlist("org_name")
			visit_ym	= Rlist("visit_ym")
			visit_date	= Rlist("visit_date")
			visit_city	= Rlist("visit_city")
			visit_address	= Rlist("visit_address")
			title	= Rlist("title")
			body	= Rlist("body")
			regdate	= Rlist("regdate")
			if IMG = "NO" then
				file_1	= ""
				file_2	= ""
				file_3	= ""
			Else
				file_1	= Rlist("file_1")
				file_2	= Rlist("file_2")
				file_3	= Rlist("file_3")
			end if
%>
		<tr>
			<td><%=idx%></td>
			<td style="mso-number-format:'\@'"><%=member_idno%></td>
			<td style="mso-number-format:'\@'"><%=member_id%></td>
			<td><%=member_name%></td>
			<td style="mso-number-format:'\@'"><%=member_hp%></td>
			<td style="mso-number-format:'\@'"><%=member_email%></td>
			<td style="mso-number-format:'\@'"><%=org_name%></td>
			<td><%=visit_ym%></td>
			<td><%=visit_date%></td>
			<td><%=visit_city%></td>
			<td><%=visit_address%></td>
			<td><%=title%></td>
			<td style="mso-number-format:'\@'"><%=body%></td>
			<td style="mso-number-format:'\@';" >
<%	If Not FncIsBlank(file_1) Then%><img src="<%=FILE_SERVERURL%>/uploads/bbq_d/inquiry/<%=file_1%>" width="400" height="400"><%End If%> 
			</td>
			<td style="mso-number-format:'\@';" >
<%	If Not FncIsBlank(file_2) Then%><img src="<%=FILE_SERVERURL%>/uploads/bbq_d/inquiry/<%=file_2%>" width="400" height="400"><%End If%> 
			</td>
			<td style="mso-number-format:'\@';" >
<%	If Not FncIsBlank(file_3) Then%><img src="<%=FILE_SERVERURL%>/uploads/bbq_d/inquiry/<%=file_3%>" width="400" height="400"><%End If%> 
			</td>
			<td style="mso-number-format:'\@'"><%=regdate%></td>
		</tr>
<%
			Rlist.MoveNext
		Loop
	End If
	Rlist.Close
	Set Rlist = Nothing 
	conn.Close
	set conn = Nothing
%>
	</table>
