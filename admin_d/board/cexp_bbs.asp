<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "E"
	CUR_PAGE_SUBCODE = ""
	CD = InjRequest("CD")
	If Not FncIsBlank(CD) Then CUR_PAGE_SUBCODE = CD	'현재 선택된 서브메뉴에 대한 권한을 체크하기 위해서 설정
	BBSCODE = InjRequest("BBSCODE")
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	SM		= InjRequest("SM")
	SW		= InjRequest("SW")
	LNUM	= InjRequest("LNUM")
	If FncIsBlank(LNUM) Then LNUM = 10

	DetailN = "&CD="& CD &"&SM="& SM &"&SW="& SW
	Detail = "&LNUM="& LNUM & DetailN
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- #include virtual="/inc/head.asp" -->
<script>

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
				<input type="hidden" name="CD" value="<%=CD%>">
				<input type="hidden" name="LNUM" value="<%=LNUM%>">
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
				</table>
				</form>
<%
	Detail = Detail &"&BBSCODE="& BBSCODE

	num_per_page	= LNUM	'페이지당 보여질 갯수
	page_per_block	= 10	'이동블럭

	page = InjRequest("page")
	If page = "" Then page = 1

	SqlFrom		= " From bt_board_cexp_main M "
	SqlWhere	= " WHERE 1=1 "
	If Not FncIsBlank(SW) Then 
		If SM = "N" Then
			SqlWhere = SqlWhere & " And EXPPLACE like '%" & SW & "%'"
		End If 
	End If
	SqlOrder = " Order By CIDX Desc "

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
                            <select name="LNUM" id="LNUM" onChange="document.location.href='?CD=<%=CD%>&BBSCODE=<%=BBSCODE%>&SM=<%=SM%>&SW=<%=SW%>&LNUM='+this.value">
                                <option value="10"<%If LNUM="10" Then%> selected<%End If%>>10</option>
                                <option value="20"<%If LNUM="20" Then%> selected<%End If%>>20</option>
                                <option value="50"<%If LNUM="50" Then%> selected<%End If%>>50</option>
                                <option value="100"<%If LNUM="100" Then%> selected<%End If%>>100</option>
                            </select>
						</div>
					</div>
					<div class="list_content">
						<table style="width:100%;">
								<tr>
									<th>NO</th>
									<th>날짜</th>
									<th>장소</th>
									<th>신청인원</th>
									<th>마감일</th>
									<th>작성일</th>
									<th>상태</th>
									<th>관리</th>
								</tr>
<%
	If total_num > 0 Then 
		Sql = "SELECT Top "&num_per_page&" CIDX, USE_FG, EXPDATE, EXPPLACE, (Select count(*) From bt_board_cexp Where CIDX = M.CIDX) AS REALNUM, ENDDATE, MAXNUM, REG_DATE " & SqlFrom & SqlWhere
		Sql = Sql & " And CIDX Not In "
		Sql = Sql & "(SELECT TOP " & ((page - 1) * num_per_page) & " CIDX "& SqlFrom & SqlWhere
		Sql = Sql & SqlOrder & ")"
		Sql = Sql & SqlOrder
		Set Rlist = conn.Execute(Sql)
		If Not Rlist.Eof Then 
			num	= total_num - first
			Do While Not Rlist.Eof
				CIDX	= Rlist("CIDX")
				USE_FG	= Rlist("USE_FG")
				EXPDATE	= Rlist("EXPDATE")
				EXPPLACE	= Rlist("EXPPLACE")
				ENDDATE	= Rlist("ENDDATE")
				REALNUM	= Rlist("REALNUM")
				MAXNUM	= Rlist("MAXNUM")
				REG_DATE	= Left(Rlist("REG_DATE"),10)
				If USE_FG = "Y" Then 
					USE_FG_TXT = "진행중"
				ElseIf USE_FG = "N" Then 
					USE_FG_TXT = "진행종료"
				Else
					USE_FG_TXT = ""
				End If 
%>
								<tr>
									<td><span><%=num%></span></td>
									<td><span><%=EXPDATE%></span></td>
									<td><span><%=EXPPLACE%></span></td>
									<td><span><%=REALNUM%>/<%=MAXNUM%></span></td>
									<td><span><%=ENDDATE%></span></td>
									<td><span><%=REG_DATE%></span></td>
									<td><span><%=USE_FG_TXT%></span></td>
									<td>
										<input type="button" value="수정" class="btn_white" onClick="document.location.href='cexp_bbs_form.asp?CIDX=<%=CIDX%>&CD=<%=CD%>&BBSCODE=<%=BBSCODE%>'">
										<input type="button" value="신청자" class="btn_white" onClick="document.location.href='cexp_bbs_man.asp?CIDX=<%=CIDX%>&CD=<%=CD%>&BBSCODE=<%=BBSCODE%>'">
									</td>
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
						<div style="display:inline-block;float:right;">
							<button class="btn_red" style="width:200px" onClick="document.location.href='cexp_bbs_form.asp?CD=<%=CD%>&BBSCODE=<%=BBSCODE%>'">창업설명회 일정 등록</button>
						</div>
					</div>
				</div>
            </div>
        </div>
<!-- #include virtual="/inc/footer.asp" -->
    </div>
</body>
</html>