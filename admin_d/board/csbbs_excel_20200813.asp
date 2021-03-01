<!-- #include virtual="/inc/config.asp" -->
<%
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
	QTP	= InjRequest("QTP")
	AST	= InjRequest("AST")
	SM	= InjRequest("SM")
	SW	= InjRequest("SW")

	SqlFrom		= " From bt_member_q "
	SqlWhere	= " WHERE brand_code = '"& FncBrandDBCode(CD) &"' And open_fg='Y' And regdate >= '"& SDATE &"' And regdate < '"& CDate(EDATE)+1 &"'"
	If Not FncIsBlank(QTP) Then	SqlWhere = SqlWhere & " And q_type = '" & QTP & "'"
	If Not FncIsBlank(AST) Then	SqlWhere = SqlWhere & " And q_status = '" & AST & "'"
	If Not FncIsBlank(SW) Then 
		If SM = "T" Then
			SqlWhere = SqlWhere & " And title like '%" & SW & "%'"
		ElseIf SM = "N" Then
			SqlWhere = SqlWhere & " And member_name like '%" & SW & "%'"
		ElseIf SM = "P" Then
			SqlWhere = SqlWhere & " And member_hp like '%" & SW & "%'"
		ElseIf SM = "I" Then
			SqlWhere = SqlWhere & " And member_id like '%" & SW & "%'"
		ElseIf SM = "B" Then
			SqlWhere = SqlWhere & " And branch_name like '%" & SW & "%'"
		End If 
	End If
	SqlOrder = " Order By q_idx Desc "
%>
<meta charset="utf-8">
	<table border="1">
		<tr>
			<td>문서번호</td>
			<td>매장명</td>
			<td>문의유형</td>
			<td>답변상태</td>
			<td>제목</td>
			<td>문의내용</td>
			<td>첨부파일1</td>
			<td>첨부파일2</td>
			<td>첨부파일3</td>
			<td>등록일시</td>
			<td>회원페이코아이디</td>
			<td>회원아이디</td>
			<td>회원명</td>
			<td>회원연락처</td>
			<td>답변일시</td>
			<td>답변자일련번호</td>
			<td>답변내용</td>
		</tr>
<%
	Sql = "SELECT * " & SqlFrom & SqlWhere & SqlOrder
	Set Rlist = conn.Execute(Sql)
	If Not Rlist.Eof Then 
		Do While Not Rlist.Eof
			q_idx	= Rlist("q_idx")
			branch_name	= Rlist("branch_name")
			q_type	= Rlist("q_type")
			q_status	= Rlist("q_status")
			title	= Rlist("title")
			body	= Rlist("body")
			filename	= Rlist("filename")
			filename2	= Rlist("filename2")
			filename3	= Rlist("filename3")
			regdate	= Rlist("regdate")
			member_idno	= Rlist("member_idno")
			member_id	= Rlist("member_id")
			member_name	= Rlist("member_name")
			member_hp	= Rlist("member_hp")
			a_date	= Rlist("a_date")
			a_user_idx	= Rlist("a_user_idx")
			a_body	= Rlist("a_body")
%>
		<tr>
			<td><%=q_idx%></td>
			<td><%=branch_name%></td>
			<td><%=q_type%></td>
			<td><%=q_status%></td>
			<td><%=title%></td>
			<td style="mso-number-format:'\@'"><%=body%></td>
			<td style="mso-number-format:'\@';width:400px;height:400px" >
<%	If Not FncIsBlank(filename) Then%><img src="<%=FILE_SERVERURL%>/uploads/bbq_d/inquiry/<%=filename%>" width="400" height="400"><%End If%> 
			</td>
			<td style="mso-number-format:'\@';width:400px;height:400px" >
<%	If Not FncIsBlank(filename2) Then%><img src="<%=FILE_SERVERURL%>/uploads/bbq_d/inquiry/<%=filename2%>" width="400" height="400"><%End If%> 
			</td>
			<td style="mso-number-format:'\@';width:400px;height:400px" >
<%	If Not FncIsBlank(filename3) Then%><img src="<%=FILE_SERVERURL%>/uploads/bbq_d/inquiry/<%=filename3%>" width="400" height="400"><%End If%> 
			</td>
			<td style="mso-number-format:'\@'"><%=regdate%></td>
			<td style="mso-number-format:'\@'"><%=member_idno%></td>
			<td style="mso-number-format:'\@'"><%=member_id%></td>
			<td><%=member_name%></td>
			<td style="mso-number-format:'\@'"><%=member_hp%></td>
			<td style="mso-number-format:'\@'"><%=a_date%></td>
			<td><%=a_user_idx%></td>
			<td style="mso-number-format:'\@'"><%=a_body%></td>
		</tr>
<%
			Rlist.MoveNext
		Loop
	End If
	Rlist.Close
	Set Rlist = Nothing 
%>
	</table>
<%
'' 엑셀로 저장
	Dim FileName : FileName = "" & Date() & "_Qna_Data"
	Response.ContentType = "application/x-msexcel"
	Response.CacheControl = "public"
	Response.AddHeader "Content-Disposition", "attachment;filename=" & FileName & ".xls"
%>