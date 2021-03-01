<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "E"
	CUR_PAGE_SUBCODE = ""
	CD = InjRequest("CD")
	If Not FncIsBlank(CD) Then CUR_PAGE_SUBCODE = CD	'현재 선택된 서브메뉴에 대한 권한을 체크하기 위해서 설정
	BBSCODE = InjRequest("BBSCODE")

	SM	= InjRequest("SM")
	SW	= InjRequest("SW")
	LNUM	= InjRequest("LNUM")
	If FncIsBlank(LNUM) Then LNUM = 10
	Detail = "&CD="& CD & "&LNUM="& LNUM & "&SM="& SM & "&SW="& SW
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- #include virtual="/inc/head.asp" -->
<script>
function ChangeOrder(MIDX, FVAL){
	$.ajax({
		async: false,
		type: "POST",
		url: "global_menu_ord_proc.asp",
		data: {"MIDX":MIDX,"FVAL":FVAL},
		dataType : "text",
		success: function(data) {
			if (data.split("^")[0] == "Y") {
//				document.location.reload();
			}else{
				alert(data.split("^")[1]);
			}
		},
		error: function(data, status, err) {
			alert(err + '서버와의 통신이 실패했습니다.');
		}
	});
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
							<div class="board_search">
								<select name="SM" id="SM">
									<option value="T">메뉴명</option> 
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

	SqlFrom		= " From bt_global_menu "
	SqlWhere	= " WHERE 1=1 "
	If Not FncIsBlank(SW) Then 
		If SM = "T" Then
			SqlWhere = SqlWhere & " And MENU_NAME like '%" & SW & "%'"
		End If 
	End If
	SqlOrder = " Order By MENU_ORD Desc, MIDX Desc "

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
									<th>카테고리</th>
									<th width="44%">메뉴명</th>
									<th>올린날짜</th>
									<th>노출</th>
                                    <th>순위관리</th>
									<th>관리</th>
								</tr>
<%
	If total_num > 0 Then


		Sql = "SELECT Top "&num_per_page&" MIDX, MCAT, MENU_NAME, MENU_ORD, OPEN_FG, REG_DATE " & SqlFrom & SqlWhere
		Sql = Sql & " And MIDX Not In "
		Sql = Sql & "(SELECT TOP " & ((page - 1) * num_per_page) & " MIDX "& SqlFrom & SqlWhere
		Sql = Sql & SqlOrder & ")"
		Sql = Sql & SqlOrder
		Set Rlist = conn.Execute(Sql)
		If Not Rlist.Eof Then 
			num	= total_num - first
			Do While Not Rlist.Eof
				MIDX	= Rlist("MIDX")
				MCAT	= Rlist("MCAT")
				MENU_NAME	= Rlist("MENU_NAME")
				OPEN_FG	= Rlist("OPEN_FG")
				MENU_ORD	= Rlist("MENU_ORD")
				REG_DATE	= Left(Rlist("REG_DATE"),10)
%>
								<tr class="thum_padding">
									<td><span><%=num%></span></td>
									<td><span><%=MCAT%></span></td>
									<td><span><%=MENU_NAME%></span></td>
									<td><span><%If OPEN_FG="Y" Then%>노출<%Else%>숨김<%End If%></span></td>
									<td><span><%=REG_DATE%></span></td>
									<td>
										<input type="text" value="<%=MENU_ORD%>" style="width:50px" onkeyup="onlyNum(this);" onChange="ChangeOrder('<%=MIDX%>',this.value)">
									</td>
									<td><input type="button" value="수정" class="btn_white" onClick="document.location.href='global_menu_form.asp?MIDX=<%=MIDX%>&CD=<%=CD%>&BBSCODE=<%=BBSCODE%>'"></td>
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
							<button class="btn_red125" onClick="document.location.href='global_menu_form.asp?CD=<%=CD%>&BBSCODE=<%=BBSCODE%>'">등록</button>
						</div>
					</div>
				</div>
            </div>
        </div>
<!-- #include virtual="/inc/footer.asp" -->
    </div>
</body>
</html>