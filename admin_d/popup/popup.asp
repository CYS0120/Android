<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "F"
	CUR_PAGE_SUBCODE = ""
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	SM	= InjRequest("SM")
	SW	= InjRequest("SW")
	LNUM	= InjRequest("LNUM")
	If FncIsBlank(LNUM) Then LNUM = 10
	Detail = "&LNUM="& LNUM & "&SM="& SM & "&SW="& SW
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<!-- #include virtual="/inc/head.asp" -->
</head>
<body>
    <div class="wrap">
<!-- #include virtual="/inc/header.asp" -->
<!-- #include virtual="/inc/header_nav.asp" -->
		<div class="board_top">
			<div class="route"> 
				<span><p>관리자</p> > <p>팝업관리</p> > <p>팝업목록</p></span>
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
				<table>
					<tr>
						<th>
							<div class="board_select">
								<div class="board_search">
									<select name="SM" id="SM">
										<option value="T"<%If SM="T" Then%> selected<%End If%>>제목</option> 
									</select>
									<input type="text" name="SW" value="<%=SW%>">
									<input type="submit" value="검색" class="btn_white">
								</div>
							</div>
						</th>
					</tr>
				</table>
				</form>
<%
	num_per_page	= LNUM	'페이지당 보여질 갯수
	page_per_block	= 10	'이동블럭

	page = InjRequest("page")
	If page = "" Then page = 1

	SqlFrom	= " From bt_popup "
	If SITE_ADM_LV = "S" Then 
		SqlWhere	= " WHERE 1=1 "
	Else
		SqlWhere	= " WHERE brand_code IN ('00'"
		ArrMENU = Split(ADMIN_CHECKMENU1,",")
		For Cnt = 0 To Ubound(ArrMENU)
			SqlWhere	= SqlWhere & ",'" & FncBrandDBCode(ArrMENU(Cnt)) & "'"
		Next
		SqlWhere	= SqlWhere & ")"
	End If 

	If Not FncIsBlank(SW) Then 
		If SM = "T" Then
			SqlWhere = SqlWhere & " And popup_title like '%" & SW & "%'"
		End If 
	End If
	SqlOrder = " Order By popup_idx Desc "

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
                            <select name="LNUM" id="LNUM" onChange="document.location.href='?SM=<%=SM%>&SW=<%=SW%>&LNUM='+this.value">
                                <option value="10"<%If LNUM="10" Then%> selected<%End If%>>10</option>
                                <option value="20"<%If LNUM="20" Then%> selected<%End If%>>20</option>
                                <option value="50"<%If LNUM="50" Then%> selected<%End If%>>50</option>
                                <option value="100"<%If LNUM="100" Then%> selected<%End If%>>100</option>
                            </select>
						</div>
					</div>
					<div class="list_content">
						<table style="width:100%;">
							<colgroup>
								<col width="4%">
								<col width="15%">
								<col width="55%">
								<col width="16%">
								<col width="10%">
							</colgroup>
							<thead>
								<tr style="height:51px">
									<th>NO</th>
									<th>적용브랜드</th>
									<th>제목</th>
									<th>오픈기간</th>
									<th>관리</th>
								</tr>
							</thead>
							<tbody>
<%
	If total_num > 0 Then 
		Sql = "SELECT Top "&num_per_page&" popup_idx, brand_code, open_sdate, open_edate, popup_title " & vbCrLf
		Sql = Sql & SqlFrom & SqlWhere & vbCrLf
		Sql = Sql & " And popup_idx Not In " & vbCrLf
		Sql = Sql & "(SELECT TOP " & ((page - 1) * num_per_page) & " popup_idx "& SqlFrom & SqlWhere & vbCrLf
		Sql = Sql & SqlOrder & ")" & vbCrLf
		Sql = Sql & SqlOrder
		Set Rlist = conn.Execute(Sql)
		If Not Rlist.Eof Then 
			num	= total_num - first
			Do While Not Rlist.Eof
				popup_idx	= Rlist("popup_idx")
				brand_code	= Rlist("brand_code")
				open_sdate	= Rlist("open_sdate")
				open_edate	= Rlist("open_edate")
				popup_title	= Rlist("popup_title")
				If brand_code = "ALL" Then 
					BRAND_TXT	= "전체"
				Else 
					BCD			= FncMenuCode(brand_code)
					BRAND_TXT	= FncBrandName(BCD)
				End If 

%>
								<tr>
									<td><span><%=num%></span></td>
									<td><span><%=BRAND_TXT%></span></td>
									<td><span><%=popup_title%></span></td>
									<td><span><%=open_sdate%> ~ <%=open_edate%></span></td>
									<td><input type="button" class="btn_white" value="수정" onClick="document.location.href='popup_form.asp?PIDX=<%=popup_idx%>'"></td>
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
							</tbody>
						</table>
					</div>
					<div class="list_foot">
<!-- #include virtual="/inc/paging.asp" -->
						<div style="display:inline-block;float:right;">
							<button type="button" class="btn_red125" onClick="document.location.href='popup_form.asp'">등록</button>
						</div>
					</div>
				</div>
            </div>  
        </div>
<!-- #include virtual="/inc/footer.asp" -->
    </div>
</body>
</html>