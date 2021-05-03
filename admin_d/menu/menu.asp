<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "D"
	CUR_PAGE_SUBCODE = ""
	CD = InjRequest("CD")
	If Not FncIsBlank(CD) Then CUR_PAGE_SUBCODE = CD	'현재 선택된 서브메뉴에 대한 권한을 체크하기 위해서 설정
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	SM	= InjRequest("SM")
	SW	= InjRequest("SW")
	USE	= InjRequest("USE")
	MTP	= InjRequest("MTP")
	GUBUN = InjRequest("GUBUN")
	ORD	= InjRequest("ORD")
	LNUM	= InjRequest("LNUM")
	If FncIsBlank(LNUM) Then LNUM = 10
	Detail = "&CD="& CD & "&ORD="& ORD & "&MTP="& MTP& "&GUBUN="& GUBUN & "&USE="& USE & "&LNUM="& LNUM & "&SM="& SM & "&SW="& Server.UrlEncode(SW)
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- #include virtual="/inc/head.asp" -->
<script type="text/javascript">
function CopyMenu(){
	var SIDX = $('#SIDX').val();
	if (SIDX == ""){alert("복사할 메뉴를 선택해주세요."); return;}

	document.location.href="menu_form.asp?CD=<%=CD%>&SIDX="+SIDX;
}
function ChangeOrder(MENU_IDX, FVAL){
	$.ajax({
		async: false,
		type: "POST",
		url: "menu_ord_proc.asp",
		data: {"MENU_IDX":MENU_IDX,"FVAL":FVAL},
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
				<span><p>관리자</p> > <p>메뉴관리</p> > <p><%=FncBrandName(CD)%></p></span>
			</div>
		</div>
	</div>
	<!--//GNB-->
</div>
<!--//NAV-->
        <div class="content">
			<div class="section section_menu">
				<form id="searchfrm" name="searchfrm" method="get">
				<input type="hidden" name="CD" value="<%=CD%>">
				<input type="hidden" name="LNUM" value="<%=LNUM%>">
				<table>
					<tr>
						<th>
							<div class="board_select">
								<div class="board_search">
								<%If CD="A" Then%>
									<select name="MTP" id="MTP" onChange="document.location.href='?CD=<%=CD%>&SM=<%=SM%>&SW=<%=Server.UrlEncode(SW)%>&ORD=<%=ORD%>&LNUM=<%=LNUM%>&USE=<%=USE%>&MTP='+this.value">
										<option value="">메뉴형태</option>
										<option value="B"<%If MTP="B" Then%> selected<%End If%>>일반메뉴</option>
										<option value="S"<%If MTP="S" Then%> selected<%End If%>>사이드메뉴</option>
									</select>
								<%End If%>
									<select name="GUBUN" id="GUBUN" onChange="document.location.href='?CD=<%=CD%>&SM=<%=SM%>&SW=<%=Server.UrlEncode(SW)%>&ORD=<%=ORD%>&LNUM=<%=LNUM%>&MTP=<%=MTP%>&GUBUN='+this.value">
										<option value="">구분</option>
<%
	SELCODE_A = ""	'구분선택
	Sql = "	Select code_idx, code_name From bt_code_item I LEFT JOIN bt_code_detail D ON I.item_idx = D.item_idx "
'	If CD = "B" Then 
'		Sql = Sql & " Where brand_code IN ('"& FncBrandDBCode("BA") &"','"& FncBrandDBCode("BB") &"','"& FncBrandDBCode("BC") &"') And code_gb='M' And code_kind = 'A' Order by code_ord "
'	Else 
		Sql = Sql & " Where brand_code = '"& FncBrandDBCode(CD) &"' And code_gb='M' And code_kind = 'A' Order by code_ord "
'	End If 
	Set Clist = conn.Execute(Sql)
	If Not Clist.eof Then 
		Do While Not Clist.Eof
			code_idx = RTRIM(Clist("code_idx"))
			code_name = Clist("code_name")
			SELCODE_A = SELCODE_A & code_idx & "^" & code_name & "|"
%>
										<option value="<%=code_idx%>"<%If GUBUN=code_idx Then%> selected<%End If%>><%=code_name%></option>
<%
			Clist.MoveNext
		Loop 
	End If

%>
									</select>

									<select name="USE" id="USE" onChange="document.location.href='?CD=<%=CD%>&SM=<%=SM%>&SW=<%=Server.UrlEncode(SW)%>&ORD=<%=ORD%>&LNUM=<%=LNUM%>&MTP=<%=MTP%>&GUBUN=<%=GUBUN%>&USE='+this.value">
										<option value="">사용여부</option>
										<option value="Y"<%If USE="Y" Then%> selected<%End If%>>사용</option>
										<option value="N"<%If USE="N" Then%> selected<%End If%>>중지</option>
										<option value="H"<%If USE="H" Then%> selected<%End If%>>숨기기</option>
									</select>
									<select name="SM" id="SM">
										<option value="N"<%If SM="N" Then%> selected<%End If%>>메뉴명</option> 
										<option value="P"<%If SM="P" Then%> selected<%End If%>>가격</option>
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

	SqlFrom	= " From bt_menu m "
'	If CD = "B" Then '닭익는 마을은 세가지 모두
'		SqlWhere	= " WHERE brand_code IN ('"& FncBrandDBCode("BA") &"','"& FncBrandDBCode("BB") &"','"& FncBrandDBCode("BC") &"') And del_yn = 'N' "
'	Else
		SqlWhere	= " WHERE brand_code='"& FncBrandDBCode(CD) &"' And del_yn = 'N' "
'	End If 
	If Not FncIsBlank(USE) Then SqlWhere = SqlWhere & " And m.use_yn = '" & USE & "'"
	If Not FncIsBlank(MTP) Then SqlWhere = SqlWhere & " And menu_type = '" & MTP & "'"
	
	If Not FncIsBlank(SW) Then 
		If SM = "N" Then
			SqlWhere = SqlWhere & " And menu_name like '%" & SW & "%'"
		ElseIf SM = "P" Then 
			SqlWhere = SqlWhere & " And menu_price = '" & SW & "'"
		End If 
	End If
	If Not FncIsBlank(GUBUN) Then SqlWhere = SqlWhere & " and CHARINDEX('" & GUBUN & "', gubun_sel) > 0 "

	If Not FncIsBlank(ORD) Then 
		If ORD = "MU" Then
			SqlOrder = " Order By kind_sel Desc, sort "
		ElseIf ORD = "MD" Then
			SqlOrder = " Order By kind_sel, sort "
		End If  
	Else
		SqlOrder = " Order By sort "
	End If 

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
                            <select name="LNUM" id="LNUM" onChange="document.location.href='?CD=<%=CD%>&SM=<%=SM%>&SW=<%=Server.UrlEncode(SW)%>&ORD=<%=ORD%>&USE=<%=USE%>&MTP=<%=MTP%>&LNUM='+this.value">
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
                                <col width="3%">
                                <col width="2%">
                                <col width="3%">
                                <%If CD="A" Then%><col width="10%"><%End If%>
                                <col width="10%">
                                <col width="11%">
                                <col width="">
								<col width="11%">
								<col width="8%">
								<col width="8%">
								<col width="9%">
                            </colgroup>
                                <tr>
                                    <th>NO</th>
                                    <th>선택</th>
                                    <th>고유번호</th>
                                    <%If CD="A" Then%><th>메뉴형태</th><%End If%>
									<th>
										<a href="?CD=<%=CD%>&SM=<%=SM%>&SW=<%=Server.UrlEncode(SW)%>&LNUM=<%=LNUM%>&USE=<%=USE%>&MTP=<%=MTP%>&ORD=MU"><img src="/img/up_arrow.png" alt="" class="img_arrow"></a>
										분류
										<a href="?CD=<%=CD%>&SM=<%=SM%>&SW=<%=Server.UrlEncode(SW)%>&LNUM=<%=LNUM%>&USE=<%=USE%>&MTP=<%=MTP%>&ORD=MD"><img src="/img/down_arrow.png" alt="" class="img_arrow"></a>
									</th>
                                    <th>구분</th>
                                    <th>메뉴명</th>
                                    <th>가격</th>
                                    <th>사용여부</th>
                                    <th>순위관리</th>
                                    <th>관리</th>
                                </tr>
								<input type="hidden" id="SIDX" name="SIDX">
<%
	If total_num > 0 Then 
		Sql = "SELECT Top "&num_per_page&" menu_idx, menu_type, menu_name, menu_price, gubun_sel, sort, m.use_yn, code_name as kind_name " & vbCrLf
		Sql = Sql & SqlFrom & " left Join bt_code_detail D ON M.kind_sel = D.code_idx" & SqlWhere & vbCrLf
		Sql = Sql & " And menu_idx Not In " & vbCrLf
		Sql = Sql & "(SELECT TOP " & ((page - 1) * num_per_page) & " menu_idx "& SqlFrom & SqlWhere & vbCrLf
		Sql = Sql & SqlOrder & ")" & vbCrLf
		Sql = Sql & SqlOrder
		
		Set Rlist = conn.Execute(Sql)
		If Not Rlist.Eof Then 
			num	= total_num - first
			Do While Not Rlist.Eof
				menu_idx	= Rlist("menu_idx")
				menu_type	= Rlist("menu_type")
				menu_name	= Rlist("menu_name")
				menu_price	= Rlist("menu_price")
				gubun_sel	= Rlist("gubun_sel")
				sort		= Rlist("sort")
				use_yn		= Rlist("use_yn")
				kind_name	= Rlist("kind_name")

				gubun_txt = ""
				If Not FncIsBlank(gubun_sel) Then 
					ArrSELCODE_A = Split(SELCODE_A,"|")
					For Cnt = 0 To Ubound(ArrSELCODE_A)
						SetCODE = ArrSELCODE_A(Cnt)
						If Not FncIsBlank(SetCODE) Then 
							ArrSetCODE = Split(SetCODE,"^")
							code_idx = ArrSetCODE(0)
							code_name = ArrSetCODE(1)
							If FncInStr(gubun_sel,code_idx) Then
								If Not FncIsBlank(gubun_txt) Then gubun_txt = gubun_txt & ", " 
								gubun_txt = gubun_txt & code_name
							End If
						End If 
					Next
				End If 
				If menu_type = "B" Then 
					menu_type_TXT = "일반메뉴"
				Else
					menu_type_TXT = "사이드메뉴"
				End If 
				If use_yn = "Y" Then 
					use_yn_txt = "사용"
				elseIf use_yn = "H" Then 
					use_yn_txt = "숨기기"
				elseIf use_yn = "N" Then 
					use_yn_txt = "중지"
				Else
					use_yn_txt = ""
				End If 
%>
								<tr>
                                    <td><span><%=num%></span></td>
                                    <td><input type="radio" name="SELIDX" value="<%=menu_idx%>" onClick="$('#SIDX').val(this.value)"></td>
                                    <td><span><%=menu_idx%></span></td>
                                    <%If CD="A" Then%><td><span><%=menu_type_TXT%></span></td><%End If%>
                                    <td><span><%=kind_name%></span></td>
                                    <td><span><%=gubun_txt%></span></td>
                                    <td><span><%=menu_name%></span></td>
                                    <td><span><%=FormatNumber(menu_price,0)%></span></td>
                                    <td><span><%=use_yn_txt%></span></td>
									<td>
										<input type="text" value="<%=sort%>" style="width:50px" onkeyup="onlyNum(this);" onChange="ChangeOrder('<%=menu_idx%>',this.value)">
									</td>
                                    <td><input type="button" value="수정" class="btn_white" onClick="document.location.href='menu_form.asp?MIDX=<%=menu_idx%>&PAGE=<%=PAGE%><%=Detail%>'"></td>
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
                            <button type="button" class="btn_white125" onClick="CopyMenu()">메뉴복사</button>
                            <button type="button" class="btn_white125" onClick="document.location.href='menu_form.asp?CD=<%=CD%>'">등록</button>
                        </div>
                    </div>
                </div>
              </div>  
        </div>
<!-- #include virtual="/inc/footer.asp" -->
    </div>
</body>
</html>