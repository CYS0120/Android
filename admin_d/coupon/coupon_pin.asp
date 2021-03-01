<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "G"
	CUR_PAGE_SUBCODE = ""
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	CPNID	= InjRequest("CPNID")
	OID		= InjRequest("OID")
	CTP		= InjRequest("CTP")
	USE		= InjRequest("USE")
	LNUM	= InjRequest("LNUM")
	If FncIsBlank(LNUM) Then LNUM = 10
	DetailN = "CPNID="& CPNID & "&CTP="& CTP & "&USE="& USE & "&OID="& OID
	Detail = "&LNUM="& LNUM & "&"& DetailN
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- #include virtual="/inc/head.asp" -->
<script>
function Coupon_Detail_pop(PINID){
	$.ajax({
		async: true,
		type: "POST",
		url: "coupon_detail_div.asp",
		data: {"PINID":PINID},
		cache: false,
		dataType: "html",
		success: function (data) {
			if ( data.replace(/^\s\s*/, '').replace(/\s\s*$/, '').length == 0 ) {
			}else{
				$("#coupon_detail_div").html(data);
				wrapWindowByMask();
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
				<span><p>관리자</p> > <p>쿠폰관리</p> > <p>E-쿠폰관리</p></span>
			</div>
		</div>
	</div>
	<!--//GNB-->
</div>
<!--//NAV-->
        <!--popup-->
        <div class="mask"></div>
        <div class="window">
            <div class="sitemap_wrap">
                <!--content-->
                <div class="coupon_popup_area">
					<div id="coupon_detail_div">

					</div>
                </div>
                <!--//content-->
            </div>
        </div>
        <!--//popup-->
        <div class="content">
            <div class="section section_couponlist">
				<form id="searchfrm" name="searchfrm" method="get">
				<input type="hidden" name="CPNID" value="<%=CPNID%>">
				<input type="hidden" name="LNUM" value="<%=LNUM%>">
				<div class="section_couponlist_sel">
					<table>
						<tbody>
							<tr>
								<th>
									<ul>
										<li><label><input type="radio" name="boardlist" onClick="document.location.href='coupon_pin.asp'" checked>멤버십 쿠폰</label></li>
										<li><label><input type="radio" name="boardlist" onClick="document.location.href='coupon_prm.asp'">프로모션 쿠폰</label></li>
										<li><label><input type="radio" name="boardlist" onClick="document.location.href='coupon_ebay_pin.asp'">이베이 쿠폰</label></li>
										<li><label><input type="radio" name="boardlist" onClick="document.location.href='coupon_partner.asp'">거래처 쿠폰</label></li>
										<li><label><input type="radio" name="boardlist" onClick="document.location.href='coupon_search.asp'">쿠폰조회</label></li>
									</ul>
								</th>
							</tr>
							<tr>
								<th>
									<ul>
										<li><input type="radio" name="boardlist2" onClick="document.location.href='coupon_pin.asp'" checked><label>사용현황</label></li>
										<li><input type="radio" name="boardlist2" onClick="document.location.href='coupon.asp'"><label>발급관리</label></li>
										<div class="couponlist_search">
											<div>
												<span>종류:</span>
												<select name="CTP" id="CTP">
													<option value=""<%If CTP="" Then%> selected<%End If%>>전체</option>
													<option value="M"<%If CTP="M" Then%> selected<%End If%>>회원가입</option>
													<option value="D"<%If CTP="D" Then%> selected<%End If%>>기념일</option>
												</select>
											</div>
											<div>
												<span>사용여부:</span>
												<select name="USE" id="USE">
													<option value=""<%If USE="" Then%> selected<%End If%>>전체</option>
													<option value="Y"<%If USE="Y" Then%> selected<%End If%>>정상사용</option>
													<option value="N"<%If USE="N" Then%> selected<%End If%>>미사용</option>
												</select>
												<input type="text" name="OID" value="<%=OID%>">
												<input type="submit" value="검색" class="btn_white">
											</div>
										</div>
									</ul>
								</th>
							</tr>
						</tbody>
					</table>
				</div>
				</form>
<%
	's_Common_PINList
	num_per_page	= LNUM	'페이지당 보여질 갯수
	page_per_block	= 10	'이동블럭

	page = InjRequest("page")
	If page = "" Then page = 1

	SqlFrom = "	FROM "& BBQHOME_DB &".DBO.T_CPN_MST MST WITH(NOLOCK) INNER JOIN "& BBQHOME_DB &".DBO.T_CPN CPN WITH (NOLOCK) ON MST.CPNID = CPN.CPNID "
	If FncIsBlank(CPNID) Then 
		SqlWhere = " WHERE MST.CPNTYPE <> 'PR' "
	Else
		SqlWhere = " WHERE MST.CPNID = '"& CPNID &"' "
	End If

	If Not FncIsBlank(CTP) Then	
		If CTP = "M" Then 
			SqlWhere = SqlWhere & " AND MST.CPNTYPE='MEM' "
		Else
			SqlWhere = SqlWhere & " AND MST.CPNTYPE='ANI' "
		End If 
	End If 	

	If Not FncIsBlank(USE) Then	
		If USE = "Y" Then 
			SqlWhere = SqlWhere & " AND MST.STATUS='9' "
		Else
			SqlWhere = SqlWhere & " AND MST.STATUS='1' "
		End If
	End If
	If Not FncIsBlank(OID) Then	SqlWhere = SqlWhere & " AND MST.OWNERID='"& OID &"' "


	SqlOrder	= "ORDER BY MST.STATUS DESC, MST.PINID ASC"

	Sql = "Select COUNT(MST.CPNID) CNT " & SqlFrom & SqlWhere
	Set Trs = conn.Execute(Sql)
	total_num = Trs("CNT")
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
							<span>Total:<p> <%=total_num%>건</p></span>
						</div>
						<div class="list_num">
							<select name="LNUM" id="LNUM" onChange="document.location.href='?<%=DetailN%>&LNUM='+this.value">
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
								<col width="28%">
								<col width="10%">
								<col width="10%">
								<col width="10%">
								<col width="10%">
							</colgroup>
							
							<tr>
								<th>NO</th>
								<th>아이디</th>
								<th>쿠폰명</th>
								<th>사용기간</th>
								<th>발행일</th>
								<th>사용여부</th>
								<th>사용일시</th>
							</tr>
<%
	If total_num > 0 Then 
		Sql = "SELECT Top "&num_per_page&" MST.*, CPN.CPNNAME " & SqlFrom & SqlWhere
		Sql = Sql & " And MST.PINID Not In "
		Sql = Sql & "(SELECT TOP " & ((page - 1) * num_per_page) & " MST.PINID "& SqlFrom & SqlWhere
		Sql = Sql & SqlOrder & ")"
		Sql = Sql & SqlOrder
		Set Rlist = conn.Execute(Sql)
		If Not Rlist.Eof Then 
			num	= total_num - first
			Do While Not Rlist.Eof
				PINID		= Rlist("PINID")
				OWNERID		= Rlist("OWNERID")
				CPNNAME		= Rlist("CPNNAME")
				USESDATE	= Rlist("USESDATE")
				USEEDATE	= Rlist("USEEDATE")
				PUBDATE		= Rlist("PUBDATE")
				STATUS		= Rlist("STATUS")
				USEDATE		= Rlist("USEDATE")

				IF STATUS="1" THEN
					STATUS_TXT="사용안함"
				ELSE
					STATUS_TXT="정상사용"
				END If
%>
							<tr>
								<td><span><%=num%></span></td>
								<td><span><a href="javascript:;" onClick="Coupon_Detail_pop('<%=PINID%>');"><%=OWNERID%></a></span></td>
								<td><span><%=CPNNAME%></span></td>
								<td><span><%=USESDATE%> ~ <%=USEEDATE%></span></td>
								<td><span><%=PUBDATE%></span></td>
								<td><span><%=STATUS_TXT%></span></td>
								<td><span><%=USEDATE%></span></td>
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