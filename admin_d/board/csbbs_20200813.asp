<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "E"
	CUR_PAGE_SUBCODE = ""
	CD = InjRequest("CD")
	If Not FncIsBlank(CD) Then CUR_PAGE_SUBCODE = CD	'현재 선택된 서브메뉴에 대한 권한을 체크하기 위해서 설정
	BBSCODE = InjRequest("BBSCODE")

	TDATE = Date
	YDATE = Date - 1

	sYY		= Year(Date)
	sMM		= Right("0"&month(Date),"2")
	TMSDATE = DateSerial(sYY,sMM,1)		'당월 1일
	TMEDATE = Date 
	PMSDATE = DateSerial(sYY,sMM-1,1)		'전월 1일
	PMEDATE = CDate(TMSDATE) - 1			'전월 마지막일

	SDATE	= InjRequest("SDATE")
	EDATE	= InjRequest("EDATE")
	QTP	= InjRequest("QTP")
	AST	= InjRequest("AST")
	SM	= InjRequest("SM")
	SW	= InjRequest("SW")
	LNUM	= InjRequest("LNUM")
	If FncIsBlank(SDATE) Then SDATE = TMSDATE 
	If FncIsBlank(EDATE) Then EDATE = Date
	If FncIsBlank(LNUM) Then LNUM = 10
	DetailN = "&QTP="& server.UrlEncode(QTP) & "&AST="& server.UrlEncode(AST) & "&SDATE="& SDATE & "&EDATE="& EDATE & "&SM="& SM & "&SW="& server.UrlEncode(SW)
	Detail = "&CD="& CD & DetailN & "&LNUM="& LNUM 

	'고객의 소리가 아닌 경우 이동
	If BBSCODE <> "A05" Then 
		Response.redirect "csbbs.asp?CD="& CD &"&BBSCODE="& BBSCODE
	End If

%>
<!-- #include virtual="/inc/admin_check.asp" -->
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- #include virtual="/inc/head.asp" -->
<script language="JavaScript">
function setDate(SD,ED,BGB){
	$('#BGB').val(BGB);
	$('#SDATE').val(SD);
	$('#EDATE').val(ED);
	$('#searchfrm').submit();
}
function ExcelDown(){
	document.location.href="csbbs_excel.asp?GO=EXCEL<%=Detail%>";
}
</script>
</head>
<body>
    <div class="wrap">
<!-- #include virtual="/inc/header.asp" -->
<!-- #include virtual="/inc/header_nav.asp" -->
		<div class="board_top">
			<div class="route"> 
				<span><p>관리자</p> > <p>게시판관리</p> > <p><%=FncBrandName(CD)%></p></span>
			</div>
		</div>
	</div>
	<!--//GNB-->
</div>
<!--//NAV-->
        <div class="content">
            <div class="section section_board">
				<form id="searchfrm" name="searchfrm" method="get">
				<input type="hidden" name="LNUM" value="<%=LNUM%>">
				<input type="hidden" name="CD" value="<%=CD%>">
				<table>
					<tr>
						<th>
							<div class="list_select">
								<ul>
<%
	Sql = "Select MENU_CODE2, MENU_NAME, BBS From bt_code_menu Where menu_code='E' And menu_depth=2 And menu_code1='"& CD &"' "
	If SITE_ADM_LV <> "S" Then
		Sql = Sql & " And menu_code2 IN ('"& Replace(ADMIN_CHECKMENU2,",","','") &"') "
	End If
	Sql = Sql & " Order by menu_order "
	Set Mlist = conn.Execute(Sql)
	If Not Mlist.eof Then 
		Do While Not Mlist.Eof
			BBSCD = Mlist("MENU_CODE2")
			BBSNM = Mlist("MENU_NAME")
			BBS = Mlist("BBS")
			If FncIsBlank(BBSCODE) Then BBSCODE = BBSCD
%>
									<li><label><input type="radio" name="BBSCODE" value="<%=BBSCD%>"<%If BBSCODE = BBSCD Then%> checked<%End If%> onClick="document.location.href='<%=BBS%>?CD=<%=CD%>&BBSCODE=<%=BBSCD%>'"><span><%=BBSNM%></span></label></li>
<%
			Mlist.MoveNext
		Loop
	End If 
%>
								</ul>
							</div>
						</th>
					</tr>
					<tr>
						<th>
							<ul>
								<li>
									<label>접수일:</label>
									<input type="text" id="SDATE" name="SDATE" value="<%=SDATE%>" readonly style="width:100px"> ~
									<input type="text" id="EDATE" name="EDATE" value="<%=EDATE%>" readonly style="width:100px">
								</li>
								<li>
									<input type="button" value="금일" class="btn_white<%If BGB="T" Then%> on<%End If%>" onClick="setDate('<%=TDATE%>','<%=TDATE%>','T')">
									<input type="button" value="전일" class="btn_white<%If BGB="P" Then%> on<%End If%>" onClick="setDate('<%=YDATE%>','<%=YDATE%>','P')">
									<input type="button" value="전월" class="btn_white<%If BGB="M" Then%> on<%End If%>" onClick="setDate('<%=PMSDATE%>','<%=PMEDATE%>','M')">
									<input type="button" value="당월" class="btn_white<%If BGB="N" Then%> on<%End If%>" onClick="setDate('<%=TMSDATE%>','<%=TMEDATE%>','N')">
								</li>
								<li>
									<label>문의유형:</label>
									<select name="QTP" id="QTP">
										<option value=""<%If QTP="" Then%> selected<%End If%>>전체</option>
										<option value="가맹문의"<%If QTP="가맹문의" Then%> selected<%End If%>>가맹문의</option>
										<option value="매장문의"<%If QTP="매장문의" Then%> selected<%End If%>>매장문의</option>
										<option value="메뉴문의"<%If QTP="메뉴문의" Then%> selected<%End If%>>메뉴문의</option>
										<option value="불친절매장신고"<%If QTP="불친절매장신고" Then%> selected<%End If%>>불친절매장신고</option>
										<option value="기타문의"<%If QTP="기타문의" Then%> selected<%End If%>>기타문의</option>
									</select>
								</li>
								<li>
									<label>답변여부:</label>
									<select name="AST" id="AST">
										<option value=""<%If AST="" Then%> selected<%End If%>>전체</option>
										<option value="답변대기"<%If AST="답변대기" Then%> selected<%End If%>>답변대기</option>
										<option value="답변완료"<%If AST="답변완료" Then%> selected<%End If%>>답변완료</option>
									</select>
								</li>
								<li>
									<select name="SM" id="SM">
										<option value="B"<%If SM="B" Then%> selected<%End If%>>매장명</option> 
										<option value="T"<%If SM="T" Then%> selected<%End If%>>제목</option> 
										<option value="N"<%If SM="N" Then%> selected<%End If%>>이름</option> 
										<option value="P"<%If SM="P" Then%> selected<%End If%>>연락처</option> 
										<option value="I"<%If SM="I" Then%> selected<%End If%>>아이디</option> 
									</select>
									<input type="text" name="SW" value="<%=SW%>">
									<input type="submit" value="검색" class="btn_white">
									<input type="button" value="EXCEL" class="btn_white" onClick="ExcelDown()">
								</li>
							</ul>
						</th>
					</tr>
				</table>
				</form>
<%
	Detail = Detail &"&BBSCODE="& BBSCODE

	num_per_page	= LNUM	'페이지당 보여질 갯수
	page_per_block	= 10	'이동블럭

	page = InjRequest("page")
	If page = "" Then page = 1

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

	Sql = "Select Count(*) " & SqlFrom & SqlWhere
	Set Trs = conn.Execute(Sql)
	total_num = Trs(0)
	Trs.close
	Set Trs = Nothing 

	If total_num = 0 Then
		first  = 1
	Else
		first  = num_per_page*(page-1)
	End If 

	total_page	= ceil(total_num / num_per_page)
	total_block	= ceil(total_page / page_per_block)
	block       = ceil(page / page_per_block)
	first_page  = (block-1) * page_per_block+1
	last_page   = block * page_per_block
%>
				<div class="list">
					<div class="list_top">
						<div class="list_total">
							<span>Total:<p><%=total_num%>건</p></span>
						</div>
						<div class="list_num">
                            <select name="LNUM" id="LNUM" onChange="document.location.href='?CD=<%=CD%>&BBSCODE=<%=BBSCODE%><%=DetailN%>&LNUM='+this.value">
                                <option value="10"<%If LNUM="10" Then%> selected<%End If%>>10</option>
                                <option value="20"<%If LNUM="20" Then%> selected<%End If%>>20</option>
                                <option value="50"<%If LNUM="50" Then%> selected<%End If%>>50</option>
                                <option value="100"<%If LNUM="100" Then%> selected<%End If%>>100</option>
                            </select>
						</div>
					</div>
					<div class="list_content list_thum_img">
						<table style="width:100%;">
							<!--colgroup>
								<col width="3%">
								<col width="5%">
								<col width="20%">
								<col width="44%">
								<col width="11%">
								<col width="8%">
								<col width="9%">
							</colgroup-->
								<tr>
									<th>NO</th>
									<th width="44%">제목</th>
									<th>작성자</th>
									<th>접수일</th>
									<th>진행상태</th>
									<th>노출</th>
									<th>관리</th>
								</tr>
<%
	ImgSiteUrl = FncGetSiteUrl(CD)

	If total_num > 0 Then 
		Sql = "SELECT Top "&num_per_page&" q_idx, q_type, q_status, title, regdate, member_name, open_fg " & SqlFrom & SqlWhere
		Sql = Sql & " And q_idx Not In "
		Sql = Sql & "(SELECT TOP " & ((page - 1) * num_per_page) & " q_idx "& SqlFrom & SqlWhere
		Sql = Sql & SqlOrder & ")"
		Sql = Sql & SqlOrder
		Set Rlist = conn.Execute(Sql)
		If Not Rlist.Eof Then 
			num	= total_num - first
			Do While Not Rlist.Eof
				q_idx	= Rlist("q_idx")
				q_type	= Rlist("q_type")
				q_status	= Rlist("q_status")
				title	= Rlist("title")
				regdate	= Left(Rlist("regdate"),10)
				member_name	= Rlist("member_name")
				open_fg	= Rlist("open_fg")
%>
								<tr class="thum_padding">
									<td><span><%=num%></span></td>
									<td><span><%=title%></span></td>
									<td><span><%=member_name%></span></td>
									<td><span><%=regdate%></span></td>
									<td><span><%=q_status%></span></td>
									<td><span><%If open_fg="Y" Then%>보이기<%Else%>숨기기<%End If%></span></td>
									<td><input type="button" value="수정" class="btn_white" onClick="document.location.href='csbbs_form.asp?q_idx=<%=q_idx%>&CD=<%=CD%>&BBSCODE=<%=BBSCODE%>'"></td>
								</tr>
<%
				num = num - 1
				Rlist.MoveNext
			Loop
		End If
		Rlist.Close
		Set Rlist = Nothing 
	End If 
%>
						</table>
					
					</div>
					<div class="list_foot">
<!-- #include virtual="/inc/paging.asp" -->
					</div>
				</div>
            </div>
        </div>
<!-- #include virtual="/inc/footer.asp" -->
    </div>
</body>
</html>