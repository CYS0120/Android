<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "G"
	CUR_PAGE_SUBCODE = ""
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	SW		= InjRequest("SW")
	Detail = "&SW="& SW
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- #include virtual="/inc/head.asp" -->
<script>
function Coupon_Detail_pop(CPNID, PIN){
	$.ajax({
		async: true,
		type: "POST",
		url: "coupon_detail_partner_div.asp",
		data: {"CPNID":CPNID,"PIN":PIN},
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
            <div class="sitemap_wrap" style="height:650px">
                <!--content-->
                <div class="coupon_popup_area" id="coupon_detail_div">
                </div>
                <!--//content-->
            </div>
        </div>
        <div class="mask2"></div>
        <div class="window2">
            <div class="sitemap_wrap">
                <!--content-->
				<form name="coupon_info" id="coupon_info" method="post">
                <div class="coupon_popup_area" id="coupon_add_div" style="height:280px;">
                </div>
				</form>
                <!--//content-->
            </div>
        </div>
        <!--//popup-->
        <div class="content">
            <div class="section section_couponlist">
				<form id="searchfrm" name="searchfrm" method="get">
				<div class="section_couponlist_sel">
					<table>
						<tbody>
							<tr>
								<th>
									<ul>
										<li><label><input type="radio" name="boardlist" onClick="document.location.href='coupon_pin.asp'">멤버십 쿠폰</label></li>
										<li><label><input type="radio" name="boardlist" onClick="document.location.href='coupon_prm.asp'">프로모션 쿠폰</label></li>
										<li><label><input type="radio" name="boardlist" onClick="document.location.href='coupon_ebay_pin.asp'">이베이 쿠폰</label></li>
										<li><label><input type="radio" name="boardlist" onClick="document.location.href='coupon_partner.asp'">거래처 쿠폰</label></li>
										<li><label><input type="radio" name="boardlist" onClick="document.location.href='coupon_search.asp'" checked>쿠폰조회</label></li>
									</ul>
								</th>
							</tr>
							<tr>
								<th style="line-height:40px;">
									<ul>
										<div class="coupon_search_pin">
											<ul>
												<li><input type="radio" name="pin_number" id="T_CPN_MST"><label fot="T_CPN_MST">T_CPN_MST(핀 테이블)</label></li>
												<li><input type="radio" name="pin_number" id="T_CPN"><label for="T_CPN">T_CPN(쿠폰 테이블)</label></li>
											</ul>
										</div>
										<div class="couponlist_search">
											<div >
												<span>쿠폰코드:</span>
												<input type="text" name="SW" value="<%=SW%>">
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
				<div class="list">
					<div class="list_content">
						<table style="width:100%;">
							<tr>
								<th>쿠폰코드</th>
								<th>쿠폰명</th>
								<th>핀번호</th>
								<th>사용여부</th>
								<th>사용일시</th>
								<th>회원 ID</th>
								<th>매장코드</th>
								<th>매장</th>
							</tr>
<%
	If Not FncIsBlank(SW) Then 
		PIN = Replace(SW,"-","")
		PIN = Replace(PIN," ","")

		Sql = "	SELECT "
		Sql = Sql & "	T2.CPNID, T2.CPNNAME, T1.PIN, T1.CPNTYPE, T1.USESDATE, T1.USEEDATE, DBO.FN_COUPON_STATUS(T1.PIN) AS STATUS, T1.PUBDATE, T1.USEDATE, T1.OWNERID	"
'		Sql = Sql & "	, ISNULL(T4.NAME, '&nbsp;') AS "dbo.ecl_decrypt(USERNAME)", T4.HP1 as "dbo.ecl_decrypt(HP1)", T4.HP2 as "dbo.ecl_decrypt(HP2)", T4.HP3 as "dbo.ecl_decrypt(HP3)"	"
		Sql = Sql & "	, T1.U_CD_BRAND, T1.U_CD_PARTNER, T3.BRANCH_NAME	"
		Sql = Sql & "FROM "& BBQHOME_DB &".DBO.T_CPN_MST T1 WITH(NOLOCK)	"
		Sql = Sql & "INNER JOIN "& BBQHOME_DB &".DBO.T_CPN T2 WITH(NOLOCK) ON T2.CPNID = T1.CPNID	"
		Sql = Sql & "LEFT JOIN BT_BRANCH T3 WITH(NOLOCK) ON T3.BRAND_CODE = T1.U_CD_BRAND AND T3.BRANCH_ID = T1.U_CD_PARTNER	"
		Sql = Sql & "LEFT JOIN BT_MEMBER T4 WITH(NOLOCK) ON T4.MEMBER_ID = T1.OWNERID	"
		Sql = Sql & "WHERE T1.PIN = '"& PIN &"'	"
		Sql = Sql & "ORDER BY PUBDATE DESC	"
		Set Rlist = conn.Execute(Sql)
		If Not Rlist.Eof Then 
			num	= total_num - first
			Do While Not Rlist.Eof
				CPNID		= Rlist("CPNID")
				CPNNAME		= Rlist("CPNNAME")
				PIN			= Rlist("PIN")
				CPNTYPE		= Rlist("CPNTYPE")
				USESDATE	= Rlist("USESDATE")
				USEEDATE	= Rlist("USEEDATE")
				STATUS		= Rlist("STATUS")
				PUBDATE		= Rlist("PUBDATE")
				USEDATE		= Rlist("USEDATE")
				OWNERID		= Rlist("OWNERID")
				U_CD_BRAND	= Rlist("U_CD_BRAND")
				U_CD_PARTNER	= Rlist("U_CD_PARTNER")
				BRANCH_NAME	= Rlist("BRANCH_NAME")

				IF STATUS="1" THEN
					STATUS_TXT="미사용"
				ELSEIF STATUS="7" THEN
					STATUS_TXT="기한만료"
				ELSEIF STATUS="8" THEN
					STATUS_TXT="사용불가"
				ELSEIF STATUS="0" THEN
					STATUS_TXT="인증대기"
				ELSEIF STATUS="9" THEN
					STATUS_TXT="정상사용"
				ELSE
					STATUS_TXT=""
				END If
%>
							<tr>
								<td><span><%=CPNID%></span></td>
								<td><span><%=CPNNAME%></span></td>
								<td><span><a href="javascript:;" onClick="Coupon_Detail_pop('<%=CPNID%>','<%=PIN%>');"><%=PIN%></a></span></td>
								<td><span><%=STATUS_TXT%></span></td>
								<td><span><%=USEDATE%></span></td>
								<td><span><%=OWNERID%></span></td>
								<td><span><%=U_CD_PARTNER%></span></td>
								<td><span><%=BRANCH_NAME%></span></td>
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
				</div>
			</div>
		</div>
<iframe src="" name="ifrExcel" id="ifrExcel" width=700 height=300 style="display:none"></iframe>
<!-- #include virtual="/inc/footer.asp" -->
    </div>
</body>
</html>