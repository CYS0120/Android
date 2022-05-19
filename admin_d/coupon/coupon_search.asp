<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "G"
	CUR_PAGE_SUBCODE = ""
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	SM		= InjRequest("SM")
	If SM = "MST" Then
		SM_Table = "T_CPN_MST MST"
		SM_Table_Main = "MST"
		SM_Table2 = "T_CPN CPN"
	ElseIf SM = "CPN" Then
		SM_Table = "T_CPN CPN"
		SM_Table_Main = "CPN"
		SM_Table2 = "T_CPN_MST MST"
	Else
		SM_Table = "T_CPN_MST MST"
		SM_Table_Main = "MST"
		SM_Table2 = "T_CPN CPN"
	End If

	SW		= InjRequest("SW")
	Detail = "&SM="& SM &"&SW="& SW
%>
<!DOCTYPE html>
<html lang="ko">

<head>
<!-- #include virtual="/inc/head.asp" -->
<script>
function funcOrderView(ORDER_ID)
{
	popPin = window.open('/order/order_read_pop.asp?OID=' + ORDER_ID,'ORDER_VIEW','width=1300,height=800,resizable=no,fullscreen=no,status=no,menubar=no,scrollbars=yes,location=no,toolbar=no,directories=no'); 
	popPin.focus();
}
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
<%
	'SM		= InjRequest("SM")
	'SW		= InjRequest("SW")
	LNUM	= InjRequest("LNUM")
	If FncIsBlank(LNUM) Then LNUM = 10

	DetailN = "CD="& CD & "&SM="& SM & "&SW="& SW
	Detail = "&LNUM="& LNUM & "&"& DetailN
%>
</head>

<body>
	<div class="wrap">
		<!-- #include virtual="/inc/header.asp" -->
		<!-- #include virtual="/inc/header_nav.asp" -->
		<div class="board_top">
			<div class="route">
				<span>
					<p>관리자</p> > <p>쿠폰관리</p> > <p>E-쿠폰관리</p>
				</span>
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
										<li><label><input type="radio" name="boardlist"
													onClick="document.location.href='coupon_pin.asp'">멤버십 쿠폰</label>
										</li>
										<li><label><input type="radio" name="boardlist"
													onClick="document.location.href='coupon_prm.asp'">프로모션 쿠폰</label>
										</li>
										<li><label><input type="radio" name="boardlist" 
													onClick="document.location.href='coupon_money.asp'">금액권</label>
										</li>
										<li><label><input type="radio" name="boardlist"
													onClick="document.location.href='coupon_ebay_pin.asp'">이베이
												쿠폰</label></li>
										<li><label><input type="radio" name="boardlist"
													onClick="document.location.href='coupon_partner.asp'">거래처 쿠폰</label>
										</li>
										<li><label><input type="radio" name="boardlist"
													onClick="document.location.href='coupon_search.asp'"
													checked>쿠폰조회</label></li>
									</ul>
								</th>
							</tr>
							<tr>
								<th style="line-height:40px;">
									<ul>
										<div class="coupon_search_pin">
											<ul>
												<li><input type="radio" name="SM" checked id="T_CPN_MST"><label
														fot="T_CPN_MST">T_CPN_MST(핀 테이블)</label></li>
												<li><input type="radio" name="SM" id="T_CPN" onClick="document.location.href='coupon_search_t_cpn.asp'"><label
														for="T_CPN">T_CPN(쿠폰 테이블)</label></li>
											</ul>
										</div>
										<div class="couponlist_search">
											<div>
												<span>핀 번호:</span>
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
<%
	'Sql = "	Select I.code_kind, code_idx, code_name From BBQ_HOME_OLD.DBO."&SM_Table&" WITH(NOLOCK) LEFT JOIN BBQ_HOME_OLD.DBO."&SM_Table2&" WITH(NOLOCK) ON MST.CPNID = CPN.CPNID " & _
	'"	Where "&SM_Table&".CPNID Like '%"& SW &"%'  " & _
	'"	Order by MST.PINID DESC "

	num_per_page	= LNUM	'페이지당 보여질 갯수
	page_per_block	= 10	'이동블럭

	page = InjRequest("page")
	If page = "" Then page = 1

	'SqlFrom = "	From BBQ_HOME_OLD.DBO."&SM_Table&" WITH(NOLOCK) LEFT JOIN BBQ_HOME_OLD.DBO."&SM_Table2&" WITH(NOLOCK) ON MST.CPNID = CPN.CPNID "
	SqlFrom = "	From "& BBQHOME_DB &".DBO."&SM_Table&" WITH(NOLOCK) "
	SqlWhere = " WHERE MST.PIN = '"& SW &"' "
	
	SqlOrder	= "ORDER BY MST.PUBDATE DESC "

	Sql = "Select COUNT(MST.PINID) CNT " & SqlFrom & SqlWhere
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
							<span>Total:<p><%=total_num%>건<%'=Request.ServerVariables("HTTP_HOST")%></p></span>
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
						<tr>
							<th>핀 ID</th>
							<th>핀번호</th>
							<th>쿠폰 ID</th>
							<th>쿠폰종류</th>
							<th>소유자 / 사용자</th>
							<th>메뉴 ID</th>
							<th>옵션 ID</th>
							<!--<th>DISCOUNT</th>-->
							<th>발행일시</th>
							<th>시작일자</th>
							<th>종료일자</th>
							<th>상태<br>(미사용,사용,폐기)</th>
							<th>사용일시</th>
							<th>연락처</th>
							<th>쿠폰금액</th>
							<th>사용브랜드코드</th>
							<th>사용매장코드</th>
						</tr>
<%
	BARND_NAME = FncBrandName(CD)

	If total_num > 0 Then 
		Sql = "SELECT Top "&num_per_page&" MST.*, (select top 1 branch_name from bt_branch where branch_id = MST.U_CD_PARTNER) as branch_name " & SqlFrom & SqlWhere & vbCrLf
		Sql = Sql & " And MST.PINID Not In "
		Sql = Sql & "(SELECT TOP " & ((page - 1) * num_per_page) & " MST.PINID "& SqlFrom & SqlWhere & vbCrLf
		Sql = Sql & SqlOrder & ")" & vbCrLf
		Sql = Sql & SqlOrder
		Set Rlist = conn.Execute(Sql)
		If Not Rlist.Eof Then 
			num	= total_num - first

			Do While Not Rlist.Eof
				PINID			= Rlist("PINID")
				PIN				= Rlist("PIN")
				CPNID		= Rlist("CPNID")
				CPNTYPE	= Rlist("CPNTYPE")
				OWNERID	= Rlist("OWNERID")
				MENUID		= Rlist("MENUID")
				OPTIONID		= Rlist("OPTIONID")
				'DISCOUNT		= Rlist("MST.DISCOUNT")
				PUBDATE		= Rlist("PUBDATE")
				USESDATE		= Rlist("USESDATE")
				USEEDATE		= Rlist("USEEDATE")
				STATUS		= Rlist("STATUS")
				USEDATE		= Rlist("USEDATE")
				TELNO		= Rlist("TELNO")
				CPN_PRICE		= Rlist("CPN_PRICE")
				U_CD_BRAND		= Rlist("U_CD_BRAND")
				U_CD_PARTNER		= Rlist("U_CD_PARTNER")

				IF STATUS="1" THEN
					STATUS_TXT="사용안함"
				ELSEIF STATUS = "8" THEN
					STATUS_TXT="폐기"
				ELSE
					STATUS_TXT="정상사용"
				END If

				branch_name		= Rlist("branch_name")
%>
						<tr>
							<td><%=PINID%></td>
							<td><span><a href="javascript:;" onClick="Coupon_Detail_pop('<%=CPNID%>','<%=PIN%>');"><%=PIN%></a></span></td>
							<td><%=CPNID%></td>
							<td><%=CPNTYPE%></td>
							<td><%=OWNERID%></td>
							<td><%=MENUID%></td>
							<td><%=OPTIONID%></td>
							<!--<td></td>-->
							<td><%=PUBDATE%></td>
							<td><%=USESDATE%></td>
							<td><%=USEEDATE%></td>
							<td><%=STATUS_TXT%></td>
							<td><%=USEDATE%></td>
							<td><%=TELNO%></td>
							<td><%=CPN_PRICE%></td>
							<td><%=U_CD_BRAND%></td>
							<td><%=branch_name%><br><%=U_CD_PARTNER%></td>
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

		<!-- Layer Popup : Member Secssion -->
		<div id="LP_Coupon_search" class="lp-wrapper lp_coupon_search">
			<!-- LP Wrap -->
			<div class="lp-wrap">
				<div class="lp-con">
					<!-- LP Header -->
					
					<!--// LP Header -->
					<!-- LP Container -->
					<div class="lp-container">
						<!-- LP Content -->
						<div class="lp-content">
							<section class="section">
								<div class="section-body">
									<form name="coupon_info" id="coupon_info" method="post">
									<input type="hidden" name="CD_PARTNER" value="">
										<div>
											<table>
												<colgroup>
													<col width="30%">
													<col width="70%">
												</colgroup>
												<tr>
													<th>핀번호</th>
													<td>
														<input type="text" name="COUPONPIN" id="COUPONPIN">
														<input type="button" value="조회" class="btn_white" onclick="javascript:Coupon_Search();">
													</td>
												</tr>
												<tr>
													<th>쿠폰명칭</th>
													<td>
														<p id="coupon_name"></p>
													</td>
												</tr>
												<tr>
													<th>사용유무</th>
													<td>
														<p id="coupon_status"></p>
													</td>
												</tr>
												<tr>
													<th>메뉴정보</th>
													<td>
														<p id="coupon_menu"></p>
													</td>
												</tr>
												<tr>
													<th>매장정보</th>
													<td>
														<p id="coupon_store"></p>
													</td>
												</tr>
												<tr class="date_change">
													<th>기간연장</th>
													<td>
														종료일 : <input type="text" name="USEEDATE" disabled	> 
														<select name="ADD_DATE" style="width:50px;">
															<option value="">선택</option>
															<option value="3" >3일</option>
															<option value="7">7일</option>
															<option value="15">15일</option>
														</select>	
													</td>
												</tr>
											</table>
										</div>
										<div class="btn-wrap two-up  bg-white">
											<select name="search_choice" class="search_coupon">
												<option value="">선택</option>
												<option value="period" >기간연장</option>
												<option value="cDel">쿠폰폐기</option>
												<option value="cInit">쿠폰초기화</option>
											</select>
											<button type="button"
												class="btn btn-lg btn-black btn_confirm btn_red" onclick="javascript:Coupon_Action();"><span>확인</span></button>
											<button type="button" onclick="javascript:lpClose(this);"
												class="btn btn-lg btn-grayLine btn_cancel btn_white"><span>취소</span></button>
										</div>
									</form>
								</div>
							</section>
						</div>
						<!--// LP Content -->
					</div>
					<!--// LP Container -->
					<!--<button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>-->
				</div>
			</div>
			<!--// LP Wrap -->
		</div>
		<!--// Layer Popup -->
	</div>
	<iframe src="" name="ifrExcel" id="ifrExcel" width=700 height=300 style="display:none"></iframe>
	<!-- #include virtual="/inc/footer.asp" -->
	</div>
</body>
<script>
	// Layer Popup Open
	function lpOpen(el) {
		var $el = $(el);
		$el.addClass("on");
		$el.stop().fadeIn('fast');
		var win_h = $(window).height() - 80;
		var lp_h = $el.find(".lp-header").height() + $el.find(".lp-container").height();
		$('html').css('overflow', 'hidden');
		console.log(win_h, lp_h);
		if (lp_h > win_h) {
			$el.find(".lp-container").height(win_h - $el.find(".lp-header").height() - 80 + "px");
		} else {

		};
	}
	// Layer Popup Close
	function lpClose(el) {
		var $el = $(el).closest(".lp-wrapper");

		$el.stop().fadeOut('fast');
		$el.removeClass("on");
		$("body").css("overflow", "");
		$('html').css('overflow', '');
	}

	function setEmail(el, sTarget) {
		var $el = $(el);

		$(sTarget).val($el.val());
	}

	function Coupon_Search() {
		//alert($('#COUPONPIN').val());
		if ( $('#COUPONPIN').val() == "" ) {
			alert('조회하실 핀번호를 입력해주세요.');
			return;
		}
		
		$.ajax({
			async: false,
			type: "POST",
			url: "coupon_search_info_proc.asp",
			data: {"COUPONPIN":$('#COUPONPIN').val()},
			dataType : "html",
			success: function(data) {
				if (data.split("^")[0] == "Y") {
					$("#coupon_name").html(data.split("^")[1]);
					$("#coupon_status").html(data.split("^")[2]);
					$("#coupon_menu").html(data.split("^")[3]);
					$("input[name=USESDATE]").val(data.split("^")[4]);
					$("input[name=USEEDATE]").val(data.split("^")[5]);
					$("#coupon_store").html(data.split("^")[6]);
					$("input[name=CD_PARTNER]").val(data.split("^")[7]);
					//document.location.reload();
				}else{
					alert(data.split("^")[1]);
					// checkClick = 0;
				}
			},
			error: function(data, status, err) {
				checkClick = 0;
				alert(err + '서버와의 통신이 실패했습니다.');
			}
		});
	}

	function Coupon_Action() {
		if ( $('#PIN').val() == "" ) {
			alert('변경하실 핀번호를 입력해주세요.');
			return;
		}
	//alert($("select[name=search_choice] option:selected").val());
		if( $("select[name=search_choice] option:selected").val() == "" ) {
			alert('변경하실 상태를 선택해주세요.');
			return;
		}
		if($("select[name=search_choice] option:selected").val()=="period"){
			if($("select[name=ADD_DATE] option:selected").val()==""){
				alert('연장하실 기간을 선택해주세요.');
				return;
			}
		}
		//return;
		$.ajax({
			async: false,
			type: "POST",
			url: "coupon_search_info_change_proc.asp",
			data: {"COUPONPIN":$('#COUPONPIN').val(), "search_choice":$("select[name=search_choice] option:selected").val(), "ADD_DATE":$("select[name=ADD_DATE] option:selected").val()},
			dataType : "html",
			success: function(data) {
				if (data.split("^")[0] == "Y") {
					alert(data.split("^")[1]);
					//document.location.reload();
					Coupon_Search();
				}else{
					alert(data.split("^")[1]);
					// checkClick = 0;
				}
			},
			error: function(data, status, err) {
				checkClick = 0;
				alert(err + '서버와의 통신이 실패했습니다.');
			}
		});
	}

	jQuery(document).ready(function (e) {
		$(window).on('scroll', function (e) {
			// Gnb Scroll
			$(".header").css('left', -$(this).scrollLeft() + 'px');
			$(".main .section").css('left', -$(this).scrollLeft() + 'px');

			// Scroll Top
			if ($(this).scrollTop() > 0) {
				$('.btn_scrollTop').addClass('active');
			} else {
				$('.btn_scrollTop').removeClass('active');
			}
		});
		$(document).on('click', '.btn_scrollTop', function (e) {
			e.preventDefault();

			$('html').animate({
				scrollTop: 0
			}, 800);
		});


		// Layer Popup Event;
		$(document).on('click', '.btn_lp_open', function (e) {
			e.preventDefault();
			$(this).addClass("lp_focus");
			$('html').css('overflow', 'hidden');
		});
		$(document).on('click', '.btn_lp_close', function (e) {
			$(this).closest(".lp-wrapper").stop().fadeOut('fast');
			$(".lp_focus").focus();
			$(".lp_focus").removeClass(".lp_focus");
			$('html').css('overflow', '');
		});

		// Tab Layer Type
		$(".tab-layer li").on('click', function (e) {
			var tabIndex = $(this).index();
			var $tabContainer = $(this).closest(".tab-layer").next(".tab-container-layer");

			e.preventDefault();

			$(this).addClass("on").siblings("li").removeClass("on");
			$tabContainer.find(".tab-content").eq(tabIndex).addClass("on").siblings(".tab-content").removeClass("on");
		});

		$(window).on('scroll', function (e) {
			if ($(window).scrollTop() > 0) {
				$(".wrapper").addClass("scrolled");
			} else {
				$(".wrapper").removeClass("scrolled");
			}
		});

		$(".search_coupon").change(function(){  
			if ( $('#PIN').val() == "" || $("input[name=CD_PARTNER]").val() == "" ) {
				alert('변경하실 핀번호를 입력해주세요.');
				return;
			}
			if ($("input[name=CD_PARTNER]").val() == "20000")
			{
				$("select[name=search_choice]").find("option:eq(0)").prop("selected", true);
				alert('[스마트] 쿠폰은 기간연장, 쿠폰폐기, 쿠폰초기화가 불가합니다.'); 
				return;
			}
			//$("select[name=search_choice] option:selected").eq(1);  
			if($("select[name=search_choice] option:selected").val()=="period"){
				//var cd_partner_code = Number($("input[name=CD_PARTNER]").val());
				//if ( cd_partner_code >= 20000 && cd_partner_code < 30000 ) {
				 
				$('.date_change').show()
			}else {
				$('.date_change').hide()
			}
	    });  

	});
  //날짜선택
	$("#datepicker1, #datepicker2").datepicker({
        dateFormat: 'yy-mm-dd',
        prevText: '이전 달',
        nextText: '다음 달',
        monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
        monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
        dayNames: ['일', '월', '화', '수', '목', '금', '토'],
        dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
        dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
        showMonthAfterYear: true,
        yearSuffix: '년',
        showOtherMonths:true,
        changeMonth:true,
    });


</script>
<iframe name="ifrmExecute" width=700 height=300 style="display:none;"></iframe>

</html>