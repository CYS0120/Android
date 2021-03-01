<!-- #include virtual="/inc/config.asp" -->
<!-- #include virtual="/inc/functions_code.asp" -->
<%
	CUR_PAGE_CODE = "E"
	CUR_PAGE_SUBCODE = ""
'	CD = "A"
	CD = InjRequest("CD")
	If Not FncIsBlank(CD) Then CUR_PAGE_SUBCODE = CD	'현재 선택된 서브메뉴에 대한 권한을 체크하기 위해서 설정
'	BBSCODE = "A05"
	BBSCODE = CD & InjRequest("CD")

	SM	= InjRequest("SM")
	SW	= InjRequest("SW")
	LNUM	= InjRequest("LNUM")
	If FncIsBlank(LNUM) Then LNUM = 10
	Detail = "&CD="& CD & "&LNUM="& LNUM & "&SM="& SM & "&SW="& SW

	'브랜드 코드 변수 생성
	ValBRAND_CODENAME = ""
	SUPER_ADMIN_CHECKMENU = ""	'슈퍼관리자 권한 코드
	Sql = "Select brand_mcode, brand_code, brand_pcode, brand_gcode, brand_name, brand_dir, brand_url From bt_brand Where use_yn='Y' order by brand_order"
	Set Mlist = conn.Execute(Sql)
	If Not Mlist.Eof Then
		Do While Not Mlist.Eof
			MENU_BRANDmcode	= Mlist("brand_mcode")
			MENU_BRANDcode	= Mlist("brand_code")
			MENU_BRANDpcode	= Mlist("brand_pcode")
			MENU_BRANDgcode	= Mlist("brand_gcode")
			MENU_BRANDname	= Mlist("brand_name")
			MENU_BRANDdir	= Mlist("brand_dir")
			MENU_BRANDurl	= Mlist("brand_url")

			ValBRAND_CODENAME = ValBRAND_CODENAME & MENU_BRANDmcode & "^" & MENU_BRANDcode & "^" & MENU_BRANDpcode & "^" & MENU_BRANDgcode & "^" & MENU_BRANDname & "^" & MENU_BRANDdir & "^" & MENU_BRANDurl & "|"
			SUPER_ADMIN_CHECKMENU = SUPER_ADMIN_CHECKMENU & MENU_BRANDmcode & ","
			Mlist.MoveNext
		Loop 
	End If

%>
<!DOCTYPE html>
<html lang="ko">

<head>
	<!-- #include virtual="/inc/head.asp" -->
	<script>

	</script>
</head>

<body>
	<div class="content csbbs_content">
		<div class="section section_board">
			<form id="searchfrm" name="searchfrm" method="get">
				<input type="hidden" name="LNUM" value="<%=LNUM%>">
				<input type="hidden" name="CD" value="<%=CD%>">
				<table>

					<tr>
						<th>
							<div class="board_search">
								<select name="SM" id="SM">
									<option value="T">제목</option>
								</select>
								<input type="text" name="SW" value="<%=SW%>">
								<input type="submit" value="검색" class="btn_white">
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

	SqlFrom		= " From bt_member_q "
	SqlWhere	= " WHERE brand_code = '"& FncBrandDBCode(CD) &"' "
	If Not FncIsBlank(SW) Then 
		If SM = "T" Then
			SqlWhere = SqlWhere & " And title like '%" & SW & "%'"
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
						<span>Total:<p style="display:inline"><%=total_num%>건</p></span>
					</div>
					<div class="list_num">
						<select name="LNUM" id="LNUM"
							onChange="document.location.href='?CD=<%=CD%>&BBSCODE=<%=BBSCODE%>&SM=<%=SM%>&SW=<%=SW%>&LNUM='+this.value">
							<option value="10" <%If LNUM="10" Then%> selected<%End If%>>10</option>
							<option value="20" <%If LNUM="20" Then%> selected<%End If%>>20</option>
							<option value="50" <%If LNUM="50" Then%> selected<%End If%>>50</option>
							<option value="100" <%If LNUM="100" Then%> selected<%End If%>>100</option>
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
'				member_name	= Rlist("member_name")
				member_name	= left(Rlist("member_name"), 1) & "**"
				open_fg	= Rlist("open_fg")
%>
						<tr class="thum_padding">
							<td><span><%=num%></span></td>
							<td style="text-align:left; padding-left:10px;"><span><%=title%></span></td>
							<td><span><%=member_name%></span></td>
							<td><span><%=regdate%></span></td>
							<td><span><%=q_status%></span></td>
							<td><input type="button" value="보기" class="btn_white"
									onClick="document.location.href='csbbs_form.asp?q_idx=<%=q_idx%>&CD=<%=CD%>&BBSCODE=<%=BBSCODE%>'">
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
				</div>
			</div>
		</div>
	</div>

</body>

</html>