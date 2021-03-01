<!--#include virtual="/api/include/utf8.asp"-->
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<meta name="Keywords" content="BBQ치킨">
<meta name="Description" content="BBQ치킨 메인">
<title>BBQ치킨</title>
</head>
<script type="text/javascript">
	function addCMenu(idx, otype) {
		addCartMenu($("#cate_"+idx+" li.swiper-slide-active").attr("value"));

		location.href = "/order/cart.asp?order_type="+otype;
		// var $f = $("<form action=\"/order/orderType.asp\" method=\"post\"><input type=\"hidden\" name=\"order_type\" value=\""+otype+"\"></form>");
		// $f.submit();
		// if(go) {
		// 	location.href = "/order/cart.asp";
		// } else {
		// 	lpOpen2("#lp_cart");
		// }
	}

	function addCartNGo(data, go) {
		addCartMenu(data);

		if(go) {
			location.href = "/order/cart.asp";
		} else {
			lpOpen2("#lp_cart");
			// showConfirmMsg({msg:"선택한 메뉴가 장바구니에 담겼습니다.\n장바구니로 이동하시겠습니까?", ok: function(){
			// 	location.href = "/order/cart.asp";
			// }});
		}
	}
jQuery(document).ready(function(e) {
	    
    //팝업창 (멤버십)
// window.onload =function () {
//     lpOpen("#lp_member");
// }

window.onload =function () {
    lpOpen('.lp_eventpopup');
}
});
</script>
<body onload="lpOpen('.lp_eventpopup');">
<div class="wrapper main">
	<!--#include virtual="/includes/header.asp"-->
	<hr>

	<!-- Container -->
	<div class="container">
		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
		<hr>
				
		<!-- Content -->
		<article class="content content-gray pad-b28">
<%
	Set bCmd = Server.CreateObject("ADODB.Command")
	With bCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_main_banner_select"
		.Parameters.Append .CreateParameter("@BRAND_CODE", adVarchar, adParamInput, 10, SITE_BRAND_CODE)
		.Parameters.Append .CreateParameter("@MODE", adChar, adParamInput, 1, "M")
		Set bRs = .Execute
	End With
	Set bCmd = Nothing
	If Not (bRs.BOF Or bRs.EOF) Then
		MAIN_IMG	= bRs("MAIN_IMG")
		MAIN_TEXT	= bRs("MAIN_TEXT")
	End If 
	bRs.close
	Set bRs = Nothing
%>			
			<!-- Main Info -->
			<div class="section-wrap">
				<section class="section section_info pad-t122" style="background:#fff"><!--background:url('<%=SERVER_IMGPATH%>/main/<%=MAIN_IMG%>') no-repeat center top;-->
					<div class="section-header blind">
						<h3>BBQ Info</h3>
					</div>						
					<div class="section-body inner">
						<p class="info_tit hide"><%=MAIN_TEXT%></p>
<%
	Set bCmd = Server.CreateObject("ADODB.Command")
	With bCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_menu_select_main"

		IF CheckLogin() Then
			.Parameters.Append .CreateParameter("@member_idx", adInteger, adParamInput, , Session("userIdx"))
		End If

		Set bRs = .Execute
	End With
	Set bCmd = Nothing

	If Not (bRs.BOF Or bRs.EOF) Then
		Randomize
		Select Case CInt(Rnd*1000) Mod 2
			Case 0:
			If CheckLogin() Then
				main_title1 = "고객님의 최다 주문메뉴는"
				main_title2 = "메뉴입니다."
			Else
				main_title1 = "이달의 입맛을 사로 잡을 메뉴는"
				main_title2 = "메뉴입니다."
			End If
			Case 1:
			If CheckLogin() Then
				main_title1 = "고객님의 최근 주문메뉴는"
				main_title2 = "메뉴입니다."
			Else
				main_title1 = "BBQ 고객이 추천한 짱짱 메뉴는"
				main_title2 = "메뉴입니다."
			End If
		End Select

		' Select Case bRs("selType")
		' 	Case "MEM_ODR":
		' 	main_title1 = "가장 최근에 주문한 메뉴는"
		' 	main_title2 = "메뉴입니다."
		' 	Case "NON_MEM":
		' 	main_title1 = "BBQ 대표메뉴"
		' 	main_title2 = "지금 바로 주문하세요"
		' 	Case "MEM_NOT":
		' 	main_title1 = Session("userName")&"님이 좋아할만한"
		' 	main_title2 = "이거 맛보는건 어떨까요?"
		' End Select
%>
						<!--<div class="img-box">
							<img src="<%=SERVER_IMGPATH%><%=bRs("mobile_file_path")&bRs("mobile_file_name")%>" onerror="this.src='/images/main/img_info01.png';" alt="<%=brs("menu_name")%>">
						</div>-->
						<div class="info-box mar-t20 ">
							<i class="ico ico-cap"></i>
							<p class="tit mar-t18"><%=main_title1%><br><strong><%=bRs("menu_name")%></strong><br><%=main_title2%></p>
							<div class="btn-wrap two-up mar-t40">
								<a href="/menu/menuView.asp?midx=<%=brs("menu_idx")%>" class="btn btn-lg btn-grayLine"><span>자세히보기</span></a>
								<a href="javascript:addCartNGo('M$$<%=bRs("menu_idx")%>$$<%=bRs("menu_option_idx")%>$$<%=bRs("menu_price")%>$$<%=bRs("menu_name")%>$$<%=SERVER_IMGPATH%><%=bRs("mobile_file_path")&bRs("mobile_file_name")%>', true);" class="btn btn-lg btn-red btn-blackLine"><span>바로 주문하기</span></a>
							</div>
<%
	End If
	Set bRs = Nothing
%>

<!--							<i class="ico ico-cap"></i>-->
							<i class="ico ico-cover mar-t30"></i>
							<p class="txt mar-t18"><span>알짜배기</span> 생활의 달인, <strong class="w_100">당신에게 알려드리는 꿀팁~~</strong></p>
							<ul class="list mar-t25">
							<%
								If CheckLogin() Then
							%>
								<li class="item01">
									<a href="/mypage/mileage.asp">
										<i class="ico ico-point"></i>
										<p>포인트</p>
										<span><em><%=FormatNumber(restPoint,0)%></em>P</span>
									</a>
								</li>
								<li class="item02">
									<a href="/mypage/couponList.asp">
										<i class="ico ico-coupon"></i>
										<p>쿠폰</p>
										<span><em><%=couponCount%></em>장</span>
									</a>
								</li>
								<li class="item03">
									<a href="/mypage/cardList.asp">
										<i class="ico ico-card"></i>
										<p>카드</p>
										<span><em><%=cardCount%></em>장</span>
									</a>
								</li>
							</ul>
							<div class="btn-wrap mar-t30">
								<a href="/mypage/membership.asp" class="btn btn-md btn-blackLine w-100p"><span class="ddack">딹</span> <span>멤버십 혜택 자세히 보기</span></a>
							</div>
							<%
								Else
							%>
								<li class="item01">
									<a href="javascript:openLogin();">
										<i class="ico ico-point"></i>
										<p>맛있는 치킨 먹고 포인트를 적립하세요</p>
									</a>
								</li>
								<li class="item02">
									<a href="javascript:openLogin();">
										<i class="ico ico-coupon"></i>
										<p>고객님만을 위한 쿠폰을 확인하시려면?</p>
									</a>
								</li>
								<li class="item03">
									<a href="javascript:openLogin();">
										<i class="ico ico-card"></i>
										<p>BBQ카드 만들고 언제 어디서나 혜택을 누리세요</p>
									</a>
								</li>
							</ul>
							<div class="btn-wrap mar-t30">
								<a href="javascript:openJoin();" class="btn btn-md btn-blackLine w-100p"><span class="ddack">딹</span> <span>멤버십 가입하기</span></a>
							</div>
							<%
								End If
							%>
						</div>
					</div>
					<!-- <div class="section-footer mar-t12">
						<p class="tit">세상에서 가장 건강하고 맛있는 치킨이 생각날 땐!</p>
						<a href="tel:15889282" class="mar-t15">1588-9282</a>
					</div> -->
				</section>
			</div>
			<!--// Main Info -->
			
			<!-- Main Menu -->
			<div class="section-wrap">
				<section class="section section_menu ">
					<!--Main Event-->
					<div class="section-header">
						<div class="event_swiper swiper-container">
							<ul class="swiper-wrapper">
<!--
								<li class="swiper-slide">
										<img src="/images/event/New_menu_190716_mob_main2.jpg" alt="">
								</li>
-->
<!--								<li class="swiper-slide">
										<img src="/images/event/New_menu_190716_mob_main.jpg" alt="">
								</li>  -->
								
								
								<li class="swiper-slide">
										<img src="/images/event/190930_mo.jpg" alt="">
								</li>
								
								
								<li class="swiper-slide">
										<img src="/images/event/190909_mo2.png" alt="">
								</li>
								
								
								<!--
								<li class="swiper-slide">
										<img src="/images/event/BBQ_app_190905.png" alt="">
								</li>
								-->
								
							
								<!--
								<li class="swiper-slide">
										<img src="/images/event/BBQ_app_190819.png" alt="">
								</li>
								-->
								<!--
								<li class="swiper-slide">
										<a href="https://m.bbq.co.kr/event/eventView.asp?eidx=1019&event=OPEN&gotoPage="><img src="/images/event/190611_summer band event_mobile.jpg" alt=""></a>
								</li>
								-->
								<!--
								<li class="swiper-slide">
										<img src="/images/event/20190522_bbq_mobile_banner.jpg" alt="">
								</li>
								-->
								<!--
								<li class="swiper-slide">
									<a href="https://www.bbq.co.kr/event/eventView.asp?eidx=1015&event=OPEN&gotoPage= "><img src="https://www.bbq.co.kr/images/event/BBQ_city_forestival2019_mobile_banner01.jpg" alt=""></a>
								</li>
								-->
							</ul>
						</div>
					</div>
					<!--//Main Event-->						
					<div class="section-body">
<%
	Set bCmd = Server.CreateObject("ADODB.Command")
	With bCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_main_category_select"

		Set bRs = .Execute
	End With
	Set bCmd = Nothing

	If Not (bRs.BOF Or bRs.EOF) Then
		bRs.MoveFirst
		Do Until bRs.EOF
			Set bCmd = Server.CreateObject("ADODB.Command")
			With bCmd
				.ActiveConnection = dbconn
				.NamedParameters = True
				.CommandType = adCmdStoredProc
				.CommandText = "bp_category_menu_list"

				.Parameters.Append .CreateParameter("@category_idx", adInteger, adParamInput,, bRs("category_idx"))

				Set cRs = .Execute
			End With
			Set bCmd = Nothing

			If Not (cRs.BOF Or cRs.EOF) Then
%>
						<div class="menu-box mar-t40">
							<p class="menu-tit"><%=bRs("category_name")%></p>
							<div class="swiper-container menu-sliderWrap">
								<ul class="swiper-wrapper menu-slider" id="cate_<%=bRs("category_idx")%>">
<%
				cRs.MoveFirst
				Do Until cRs.EOF
%>
									<li class="swiper-slide" value="M$$<%=cRs("menu_idx")%>$$<%=cRs("menu_option_idx")%>$$<%=cRs("menu_price")%>$$<%=cRs("menu_name")%>$$<%=SERVER_IMGPATH%><%=cRs("thumb_file_path")&cRs("thumb_file_name")%>">
										<p class="tit"><%=cRs("menu_name")%></p>
										<a href="/menu/menuView.asp?midx=<%=cRs("menu_idx")%>">
											<div class="img-box"><img src="<%=SERVER_IMGPATH%><%=cRs("thumb_file_path")&cRs("thumb_file_name")%>" width="750px" height="660px" onerror="this.src='/images/main/img_menu01.jpg';" alt="<%=cRs("menu_name")%>"></div>
											<div class="info-box">
												<p class="txt"><%=cRs("menu_title")%></p>
												<p class="price"><em><%=FormatNumber(cRs("menu_price"),0)%></em>원</p>
											</div>
										</a>
									</li>
<%
					cRs.MoveNext
				Loop
%>
								</ul>
								<div class="swiper-pagination"></div>
								<div class="btn-wrap two-up inner">
									<a href="javascript:addCMenu('<%=bRs("category_idx")%>', 'P');" class="btn btn-lg btn-yellow"><span><img src="/images/menu/ico_pick.png" alt=""> 포장주문</span></a>
									<a href="javascript:addCMenu('<%=bRs("category_idx")%>', 'D');" class="btn btn-lg btn-red "><span><img src="/images/menu/ico_delivery.png" alt=""> 배달주문</span></a>
								</div>
								
							</div>
						</div>

<%
			End If
			bRs.MoveNext
		Loop
	End If
	Set bRs = Nothing
%>
					</div>
				</section>
			</div>
			<!--// Main Menu -->

			<!-- Main Family Brand -->
			<div class="section-wrap mar-b0 hide">
				<section class="section section_family">
					<div class="section-body inner">
						<div class="box">
							<p class="tit">Best of the Best Quality</p>
							<p class="txt">더 풍부한 행복을 만들기 위해 고객의 입맛과 마음을 연구합니다.<br>당신의 행복을 키우는 BBQ</p>
							<ul class="bestQuality-list">
								<li class="item01">
									<a href="/brand/bbq.asp">
										<i class="ico ico-story01"></i>
										<span>BBQ STORY</span>
									</a>
								</li>
								<li class="item02">
									<a href="/brand/oliveList.asp">
										<span>황금올리브이야기</span>
										<i class="ico ico-story02"></i>
									</a>
								</li>
								<li class="item03">
									<a href="/brand/videoList.asp">
										<i class="ico ico-story03"></i>
										<span>영상 콘텐츠</span>
									</a>
								</li>
							</ul>
						</div>
					</div>
				</section>
			</div>
			<!-- Main Family Brand -->
			
		</article>
		<!--// Content -->

<%
	CookName	= "popup_20190523"
	If Date >= "2019-05-23" And Request.Cookies(CookName) <> "done" Then %>
		<!-- Layer Popup : 윈도우 로드시 보냉이벤트 레이어팝업 
		<div id="LP_eventpopup" class="lp-wrapper lp_eventpopup" style="display:none">
			
			
			<div class="lp-container" style="padding:0;">
				
				<div class="lp-content" style="padding:0;">
					
					<section class="section" style="text-align:center;">
						<div>
							<img src="/images/main/side_m(0).jpg" alt="">
							<div class="checks today" onClick="PopupNoDispaly()" style="float:left"> 
								<input type="checkbox" id="ex_chk"> 
								<label for="ex_chk">오늘 하루 이창 열지 않음</label> 
							</div>
						</div>
						<button type="button" class="btn btn_lp_close" style="position:relative; bottom:auto; right:auto;float:right; margin:28px 20px;"><span>닫기</span></button>
					</section>
					
				</div>
				
			</div>
			
			
		</div>
		-->
		
		<!-- Layer Popup : 레이어팝업2 -->
<!--		<div id="LP_eventpopup2" class="lp-wrapper lp_eventpopup2" style="display:block">
			
			
			<div class="lp-container" style="padding:0;">
		
				<div class="lp-content" style="padding:0;">
					<section class="section" style="text-align:center;">
						<div>
							<img src="/images/event/summerband1.jpg" alt="" style="max-width:100%;">
							<div class="checks today" onClick="PopupNoDispaly()" style="float:left"> 
								<input type="checkbox" id="ex_chk2"> 
								<label for="ex_chk2">오늘 하루 이창 열지 않음</label> 
							</div>
						</div>
						<button type="button" class="btn btn_lp_close"  style="position:relative; bottom:auto; right:auto;float:right; margin:28px 20px; "><span>닫기</span></button>  
					</section>
				</div>
			</div>
		
	</div> -->
		<!--// Layer Popup : 레이어팝업2 -->
		<script>
			$(document).ready(function () {
				$('.lp_eventpopup').show();
			});
			function setCookie(name, value, expiredays) {
				var todayDate = new Date();
				todayDate.setDate(todayDate.getDate() + expiredays);

				document.cookie = "<%=CookName%>=done; path=/; expires=" + todayDate.toGMTString() + ";"
			}
			function PopupNoDispaly() {
				setCookie("<%=CookName%>", "done", 1);
				$('#LP_eventpopup').hide();
			}
		</script>
<%	End If  %>

		<!-- Back to Top -->
		<a href="#Top" class="btn btn_scrollTop">페이지 상단으로 이동</a>
		<!--// Back to Top -->


	</div>
	<!--// Container -->
	<hr>


<%
	Dim bCmd, bPopRs

	Set bCmd = Server.CreateObject("ADODB.Command")
	With bCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_popup"
		.Parameters.Append .CreateParameter("@BRAND_CODE", adVarchar, adParamInput, 5, SITE_BRAND_CODE)
		.Parameters.Append .CreateParameter("@POPUP_KIND", adChar, adParamInput, 1, "L")
		Set bPopRs = .Execute
	End With
	Set bCmd = Nothing			
	If bPopRs.BOF Or bPopRs.EOF Then
	Else
		popup_idx	= bPopRs("popup_idx")
		brand_code	= bPopRs("brand_code")
		popup_width	= bPopRs("popup_width")
		popup_height	= bPopRs("popup_height")
		popup_close	= bPopRs("popup_close")
		popup_title	= bPopRs("popup_title")
		popup_img	= bPopRs("popup_img")

		popup_img = FILE_SERVERURL & "/uploads/popup/" & popup_img

		CookName	= "popup_" & popup_idx
		If Request.Cookies(CookName) = "done" Then 
		Else
%>
		<!--윈도우 로드시 팝업-->
		<aside class="popup">
			<div class="inner" id="pop1">
				<div class="area" style="width:<%=popup_width%>px;">
					<img src="<%=popup_img%>" alt="POPUP">
				</div>
				<%If popup_close = "1" Then%>
				<button type="button" class="today" onClick="PopupNoDispaly()"><span>하루동안 보지않기</span> <i class="axi axi-close"></i></button>
				<%End If%>
				<button type="button" class="close _close" onClick="$('.popup').hide();">[닫기]</button>
			</div>
			<div class="popupbg"></div>
		</aside>
		<!--//윈도우 로드시 팝업-->
		<script>
			$(document).ready(function () {
				$('.popup').show();
			});
			function PopupNoDispaly() {
				setCookie("popup_<%=popup_idx%>", "done", 1);
				$('.popup').hide();
			}
		</script>

		<%
		End If 
	End If

	Set bCmd = Server.CreateObject("ADODB.Command")
	With bCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_popup"
		.Parameters.Append .CreateParameter("@BRAND_CODE", adVarchar, adParamInput, 5, SITE_BRAND_CODE)
		.Parameters.Append .CreateParameter("@POPUP_KIND", adChar, adParamInput, 1, "N")
		Set bPopRs = .Execute
	End With
	Set bCmd = Nothing			
	If bPopRs.BOF Or bPopRs.EOF Then
	Else
		Do While Not bPopRs.EOF
			popup_idx	= bPopRs("popup_idx")
			popup_left	= bPopRs("popup_left")
			popup_top	= bPopRs("popup_top")
			popup_width	= bPopRs("popup_width")
			popup_height	= bPopRs("popup_height")

			CookName	= "popup_" & popup_idx
			If Request.Cookies(CookName) = "done" Then 
			Else
%>
	<script Language="JavaScript">	
		window.open('/api/popup.asp?PIDX=<%=popup_idx%>','popup_<%=popup_idx%>','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,status=no, left=<%=popup_left%>,top=<%=popup_top%>, width=<%=popup_width%>,height=<%=popup_height+25%>');
	</script>
<%
			End If 
			bPopRs.MoveNext
		Loop 
	End If 
%>
<script>
	function setCookie(name, value, expiredays) {
		var todayDate = new Date();
		todayDate.setDate(todayDate.getDate() + expiredays);
		document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"
	}
</script>

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
</div>
<script>
// menu
var swiper = new Swiper('.menu-sliderWrap', {
  pagination: {
	el: '.menu-sliderWrap .swiper-pagination',
	clickable: true,
  },
});
// store
var store_swiper = new Swiper('.store_list', {
	slidesPerView: 'auto',
	paginationClickable: true,
	spaceBetween: 0,
	freeMode: true,
	pagination: false,
});

var event_swiper = new Swiper('.event_swiper',{
	slidesPerView: 'auto',
	autoplay:{delay:3000,},
	paginationClickable: true,
	spaceBetween: 0,
	freeMode: true,
	pagination: false,
})
</script>



</body>
</html>
