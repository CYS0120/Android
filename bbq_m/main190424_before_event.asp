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
window.onload =function () {
    lpOpen("#lp_member");
}
});
</script>
<body onload="openWin();">
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
				<section class="section section_info pad-t122" style="background:url('<%=SERVER_IMGPATH%>/main/<%=MAIN_IMG%>') no-repeat center top;">
					<div class="section-header blind">
						<h3>BBQ Info</h3>
					</div>						
					<div class="section-body inner">
						<p class="info_tit"><%=MAIN_TEXT%></p>
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
						<div class="info-box mar-t20">
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
				<section class="section section_menu pad-t50">
					<div class="section-header">
						<h3>BBQ MENU</h3>
					</div>						
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
			<div class="section-wrap mar-b0">
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

		<!-- Back to Top -->
		<a href="#Top" class="btn btn_scrollTop">페이지 상단으로 이동</a>
		<!--// Back to Top -->
	</div>
	<!--// Container -->
	<hr>

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
</script>
</body>
</html>
