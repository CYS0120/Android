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

	'일반 형태가 아닌 게시판종류 해당 게시물로 이동
	If BBSCODE = "A05" Then 
		Response.redirect "csbbs.asp?CD="& CD &"&BBSCODE="& BBSCODE
	ElseIf BBSCODE = "A09" Then
		Response.redirect "bbcarbbs.asp?CD="& CD &"BBSCODE="& BBSCODE
	Else
	End If
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- #include virtual="/inc/head.asp" -->
<script>
function Change_TOP(BBSCODE){
	var BIDX = $('#SEL_BIDX').val();
	if (BIDX == ''){alert('적용할 항목을 선택해 주세요'); return;}
	$.ajax({
		async: true,
		type: "POST",
		url: "bbs_changetop.asp",
		data: {"BBSCODE":BBSCODE,"BIDX":BIDX},
		dataType: "text",
		success: function (data) {
			alert(data.split("^")[1]);
			if(data.split("^")[0] == 'Y'){

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
									<option value="T">제목</option> 
								</select>
								<input type="text" name="SW" value="<%=SW%>">
								<input type="submit" value="검색" class="btn_white">
							</div>
						</th>
					</tr>
				</table>
				</form>
<!-- #include file="bbs_config.asp" -->
<%
	Detail = Detail &"&BBSCODE="& BBSCODE

	num_per_page	= LNUM	'페이지당 보여질 갯수
	page_per_block	= 10	'이동블럭

	page = InjRequest("page")
	If page = "" Then page = 1

	SqlFrom		= " From bt_board_list "
	SqlWhere	= " WHERE bbs_code = '"& BBSCODE &"' "
	If Not FncIsBlank(SW) Then 
		If SM = "T" Then
			SqlWhere = SqlWhere & " And title like '%" & SW & "%'"
		End If 
	End If
	SqlOrder = " Order By BIDX Desc "

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
<%		If DISP_SEL_YN = "Y" Then	%>
									<th>선택</th>
<%		End If %>
<%		If DISP_THUM_YN = "Y" And BBSCODE <> "K01" Then	%>
									<th>썸네일 이미지</th>
<%		End If %>
<%		If DISP_TOP_YN = "Y" Then	%>
									<th>구분</th>
<%		End If %>
									<th width="44%"><%If BBSCODE = "K06" Then%>국가명<%Else%>제목<%End If%></th>
<%		If DISP_EVENT_YN = "Y" Then		%>
									<th>이벤트기간</th>
<%		End If %>
									<th>올린날짜</th>
<%		If DISP_HIT_YN = "Y" Then	%>
									<th>조회</th>
									<th>노출</th>
<%		Else %>
									<th>글쓴이</th>
<%		End If %>
									<th>관리</th>
								</tr>
<%
	ImgSiteUrl = FncGetUploadDir(CD)
	If total_num > 0 Then 
		If BBSCODE = "K06" Then
			Sql = "SELECT Top "&num_per_page&" BIDX, top_fg, sdate, edate, edate_fg, (Select GNAME From bt_board_global_code Where GCODE=bt_board_list.Title) AS title, imgpath, imgname, open_fg, hit, reg_name, reg_date " & SqlFrom & SqlWhere
		Else
			Sql = "SELECT Top "&num_per_page&" BIDX, top_fg, sdate, edate, edate_fg, title, imgpath, imgname, open_fg, hit, reg_name, reg_date " & SqlFrom & SqlWhere
		End If 
		Sql = Sql & " And BIDX Not In "
		Sql = Sql & "(SELECT TOP " & ((page - 1) * num_per_page) & " BIDX "& SqlFrom & SqlWhere
		Sql = Sql & SqlOrder & ")"
		Sql = Sql & SqlOrder
		Set Rlist = conn.Execute(Sql)
		If Not Rlist.Eof Then 
			num	= total_num - first
			Do While Not Rlist.Eof
				BIDX	= Rlist("BIDX")
				top_fg	= Rlist("top_fg")
				sdate	= Rlist("sdate")
				edate	= Rlist("edate")
				edate_fg	= Rlist("edate_fg")
				title	= Rlist("title")
				imgpath	= Rlist("imgpath")
				imgname	= Rlist("imgname")
				open_fg	= Rlist("open_fg")
				hit		= Rlist("hit")
				reg_name	= Rlist("reg_name")
				reg_date	= Left(Rlist("reg_date"),10)
				TOP_FGSEL = ""
				If top_fg = "Y" Then 
					SEL_BIDX = BIDX
					TOP_FGSEL = " checked"
				End If 
%>
								<tr class="thum_padding">
									<td><span><%=num%></span></td>
<%		If DISP_SEL_YN = "Y" Then	%>
									<td><input type="radio" name="TOP_FG" onClick="$('#SEL_BIDX').val('<%=BIDX%>')"<%=TOP_FGSEL%>></td>
<%		End If %>
<%		If DISP_THUM_YN = "Y" And BBSCODE <> "K01" Then	%>
									<td><img src="<%=FILE_SERVERURL%>/uploads/<%=ImgSiteUrl%>/bbsimg/<%=imgname%>" class="thum_size"></td>
<%		End If %>
<%		If DISP_TOP_YN = "Y" Then	%>
									<td><%If top_fg="Y" Then%>TOP<%End If%></td>
<%		End If %>
									<td><span><%=title%></span></td>
<%		If DISP_EVENT_YN = "Y" Then		%>
									<td><span><%=sdate%> ~ <%=edate%></span></td>
<%		End If %>
									<td><span><%=reg_date%></span></td>
<%		If DISP_HIT_YN = "Y" Then	%>
									<td><span><%=hit%></span></td>
									<td><span><%If open_fg="Y" Then%>보이기<%Else%>숨기기<%End If%></span></td>
<%		Else %>
									<td><span><%=reg_name%></span></td>
<%		End If %>
									<td><input type="button" value="수정" class="btn_white" onClick="document.location.href='bbs_form.asp?BIDX=<%=BIDX%>&CD=<%=CD%>&BBSCODE=<%=BBSCODE%>'"></td>
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
<%		If DISP_SEL_YN = "Y" Then	%>
						<div class="" style="display:inline-block;float:left;">
							<input type="hidden" id="SEL_BIDX" value="<%=SEL_BIDX%>">
							<span>-선택항목을 대표영상으로</span>
							<input type="button" value="수정" class="btn_white" onClick="Change_TOP('<%=BBSCODE%>')">
						</div>
<%		End If %>
<!-- #include virtual="/inc/paging.asp" -->
						<div style="display:inline-block;float:right;">
							<button class="btn_red125" onClick="document.location.href='bbs_form.asp?CD=<%=CD%>&BBSCODE=<%=BBSCODE%>'">등록</button>
						</div>
					</div>
				</div>
            </div>
        </div>
<!-- #include virtual="/inc/footer.asp" -->
    </div>
</body>
</html>