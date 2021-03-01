<!--#include virtual="/api/include/utf8.asp"-->
<!doctype html>
<html lang="ko">

<head>
	<!--#include virtual="/includes/top.asp"-->
	<link rel="stylesheet" href="/common/css/main.css">
	<link rel="stylesheet" href="/common/css/animate.css">
	<link rel="stylesheet" href="/common/css/mscrollbar.css">
	<script src="/common/js/libs/jquery.bxslider.js"></script>
	<script src="/common/js/libs/mscrollbar.js"></script>
	<script>
		jQuery(document).ready(function (e) {

			// scroll header
			$(window).on('scroll', function (e) {
				if ($(window).scrollTop() > 0) {
					$(".wrapper").addClass("scrolled");
				} else {
					$(".wrapper").removeClass("scrolled");
				}
			});

			// section_visual
			$('.main-bxslider').bxSlider({
				mode: 'horizontal',
				auto: true,
				slideMargin: 0,
				infiniteLoop: true,
				speed: 800,
				//touchEnabled : (navigator.maxTouchPoints > 0),
				controls: false
			});

			// tab click
			$(".tab-layer li").on('click', function (e) {
				tab_sliderWrap();
			});
			tab_sliderWrap();

			// animate
			$(window).on('scroll', function (e) {
				if ($(window).scrollTop() >= 388) {
					$(".bbq-menu .ico-cap").addClass("swing animated");
					$(".bbq-enjoy .ico-cover").addClass("swing animated");
					$(".bbq-enjoy .list li").addClass("fadeInUp animated");
				};
				if ($(window).scrollTop() >= 4000) {
					$(".bestQuality-list li").addClass("fadeInUp animated");
				};
			});

			// num
			$(".num-wrap .minus").on('click', function (e) {
				var num = $(this).next().val();
				console.log(num);
				if (num > 1) {
					$(this).next().val(num * 1 - 1);
					return false;
				};
			});
			$(".num-wrap .add").on('click', function (e) {
				var num = $(this).prev().val();
				console.log(num);
				$(this).prev().val(num * 1 + 1);
				return false;
			});

			// scrollbar
			$(".mCustomScrollbar").mCustomScrollbar({
				horizontalScroll: false,
				theme: "light",
				mouseWheelPixels: 300,
				advanced: {
					updateOnContentResize: true
				}
			});

			//팝업창 (멤버십)
			window.onload = function () {
				// lpOpen("#lp_member");
			}
		});

		// tab-slider(bbq menu)
		function tab_sliderWrap() {
			var tab_slider = $('.tab-content:visible .tab-slider').bxSlider({
				mode: 'fade', // horizontal, vertical, fade
				auto: false,
				slideMargin: 0,
				infiniteLoop: false,
				speed: 800,
				controls: true,
				touchEnabled: false,
				onSliderLoad: function (currentIndex) {
					$('.tab-content:visible .tab-slider > li').find('.img-wrap img').removeClass('jackInTheBox animated');
					$('.tab-content:visible .tab-slider > li').find('.etc01').removeClass('fadeInLeft animated');
					$('.tab-content:visible .tab-slider > li').find('.etc02').removeClass('fadeInRight animated');
					$('.tab-content:visible .tab-slider > li').find('.etc03').removeClass('fadeInLeft animated');
					$('.tab-content:visible .tab-slider > li').find('.etc04').removeClass('fadeInRight animated');
					$('.tab-content:visible .tab-slider > li').eq(currentIndex).find('.img-wrap img').addClass('jackInTheBox animated delay-06s');
					$('.tab-content:visible .tab-slider > li').eq(currentIndex).find('.etc01').addClass('fadeInLeft animated delay-09s');
					$('.tab-content:visible .tab-slider > li').eq(currentIndex).find('.etc02').addClass('fadeInRight animated delay-12s');
					$('.tab-content:visible .tab-slider > li').eq(currentIndex).find('.etc03').addClass('fadeInLeft animated delay-15s');
					$('.tab-content:visible .tab-slider > li').eq(currentIndex).find('.etc04').addClass('fadeInRight animated delay-18s');
				},
				onSlideBefore: function ($slideElement, oldIndex, newIndex) {
					console.log(newIndex);
					$('.tab-content:visible .tab-slider > li').find('.img-wrap img').removeClass('jackInTheBox animated');
					$('.tab-content:visible .tab-slider > li').find('.etc01').removeClass('fadeInLeft animated');
					$('.tab-content:visible .tab-slider > li').find('.etc02').removeClass('fadeInRight animated');
					$('.tab-content:visible .tab-slider > li').find('.etc03').removeClass('fadeInLeft animated');
					$('.tab-content:visible .tab-slider > li').find('.etc04').removeClass('fadeInRight animated');
					$('.tab-content:visible .tab-slider > li').eq(newIndex).find('.img-wrap img').addClass('jackInTheBox animated delay-06s');
					$('.tab-content:visible .tab-slider > li').eq(newIndex).find('.etc01').addClass('fadeInLeft animated delay-09s');
					$('.tab-content:visible .tab-slider > li').eq(newIndex).find('.etc02').addClass('fadeInRight animated delay-12s');
					$('.tab-content:visible .tab-slider > li').eq(newIndex).find('.etc03').addClass('fadeInLeft animated delay-15s');
					$('.tab-content:visible .tab-slider > li').eq(newIndex).find('.etc04').addClass('fadeInRight animated delay-18s');
				},
			});
		};
	</script>
	<script type="text/javascript">
		var cartPage = "";
		function addMenuNGo(data, go) {
			addCartMenu(data);
			if (go) {
				location.href = "/order/cart.asp";
			} else {
				lpOpen("#lp_cart");
				// if(window.confirm("선택한 메뉴가 장바구니에 담겼습니다.\n장바구니로 이동하시겠습니까?")) {
				// 	location.href = "/order/cart.asp";
				// }
			}
		}

		function addMenuNGoWithCntType(data, otype) {
			addCartMenu(data);

			var dataA = data.split("$$");

			var key = dataA[0] + "_" + dataA[1] + "_" + dataA[2];

			var cnt = $(".section_menu .tab-content.on li[aria-hidden=false] input[type=text]").val();
			cnt = isNaN(cnt) ? 1 : Number(cnt);

			if (cnt > 1) {
				changeMenuQty(key, cnt - 1);
			}


			location.href = "/order/orderType.asp?order_type=" + otype;
		}

		function addMenuNGoWithCnt(data, go) {
			addCartMenu(data);

			var dataA = data.split("$$");

			var key = dataA[0] + "_" + dataA[1] + "_" + dataA[2];

			var cnt = $(".section_menu .tab-content.on li[aria-hidden=false] input[type=text]").val();
			cnt = isNaN(cnt) ? 1 : Number(cnt);

			if (cnt > 1) {
				changeMenuQty(key, cnt - 1);
			}

			if (go) {
				location.href = "/order/cart.asp";
			} else {
				lpOpen("#lp_cart");
				// if(window.confirm("선택한 메뉴가 장바구니에 담겼습니다.\n장바구니로 이동하시겠습니까?")) {
				// 	location.href = "/order/cart.asp";
				// }
			}
		}
	</script>
</head>

<body onload="openWin();">
	<div class="wrapper">
		<!-- Header -->
		<!--#include virtual="/includes/header.asp"-->
		<!--// Header -->
		<hr>

		<!-- Container -->
		<div class="container main">

			<!-- Content -->
			<article class="content">
				<h1 class="blind">BBQ</h1>

				<!-- Main Visual -->
				<section class="section section_visual" data-688="top:0px;" data-1373="top:-688px;">
					<h2 class="blind">BBQ Visual</h2>
					<div class="section-body">
						<ul class="main-bxslider">

<%	If Date >= "2019-05-23" Then %>
<!--
							<li class="item">
								<div class="inner" style="width:auto;">
									    <img src="/images/event/New_menu_190716_pc_main2.jpg" width="1920px" height="688px" />
								</div>
							</li>
-->
							<li class="item">
								<div class="inner" style="width:auto;">
									    <img src="/images/event/190611_summer band event_main.jpg" width="1920px" height="688px" />
								</div>
							</li>
							<li class="item">
								<div class="inner" style="width:auto;">
									<a href="https://www.bbq.co.kr/event/eventView.asp?eidx=1019&event=OPEN&gotoPage=" style="height:688px;display:inline-block">
										<img src="/images/event/20190522_BBQ_warm_cold_event.jpg" width="1920px" height="688px" />
									</a>
								</div>
							</li>  
<%	End If %>
						<!--	<li class="item">
								<div class="inner" style="width:auto;">
									<a href="https://www.bbq.co.kr/event/eventView.asp?eidx=1015&event=OPEN&gotoPage=" style="height:688px;display:inline-block">
										<img src="https://www.bbq.co.kr/images/event/BBQ_city_forestival2019_main.jpg" width="1920px"
											height="688px" />
									</a>
								</div>

							</li>  -->
							
							<!--<li class="item">
								<div class="inner" style="width:auto;">
									<a href="http://bbq.fuzewire.com/event/eventView.asp?eidx=52&event=OPEN&gotoPage="
										style="width:1920px;height:688px;display:inline-block">
										<img src="https://www.bbq.co.kr/images/event/event_main.jpg"
											style="padding-top:105px;width:1920px;height:688px;">
									</a>
								</div>
							</li>-->
				<!--			<li class="item">
								<div class="inner" style="width:auto;">
									<video src="/video/bbqtest_chicken_main.mp4" autoplay loop
										style="padding-top:105px;width:1920px;">
										<p>Your user agent does not support the HTML5 Video element.</p>
									</video>
								</div>
							</li>   -->

							<%
	Set bCmd = Server.CreateObject("ADODB.Command")
	With bCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_main_banner_select"
		.Parameters.Append .CreateParameter("@BRAND_CODE", adVarchar, adParamInput, 10, SITE_BRAND_CODE)
		.Parameters.Append .CreateParameter("@MODE", adChar, adParamInput, 1, "W")
		Set bRs = .Execute
	End With
	Set bCmd = Nothing
	If Not (bRs.BOF Or bRs.EOF) Then
		Do While Not bRs.EOF
			MAIN_IMG	= bRs("MAIN_IMG")
			MAIN_TEXT	= bRs("MAIN_TEXT")
%>
							<li class="item"
								style="background:url('<%=SERVER_IMGPATH%>/main/<%=MAIN_IMG%>') no-repeat center bottom;">
								<div class="inner">
									<div class="info-box">
										<%=MAIN_TEXT%>
									</div>
								</div>
							</li>
							<%			bRs.MoveNext
		Loop
	End If 
	bRs.close
	Set bRs = Nothing
%>
							<!--	<li class="item">
								<div class="inner" style="width:auto;">
									<video src="/video/bbqtest_chicken_main.mp4" autoplay loop style="padding-top:105px;width:1920px;">
										<p>Your user agent does not support the HTML5 Video element.</p>
									</video>
								</div>
							</li>-->
							<!--<li class="item">
							<div class="inner">
								<iframe width="100%" height="700" src="https://www.youtube.com/embed/WCyUo_4kvLw?rel=0&amp;controls=0&amp;showinfo=0&amp;autoplay=0&amp;volumn=0&amp;mute=1" allowfullscreen></iframe>
							</div>
						</li>-->
						</ul>
					</div>
				</section>
				<!--// Main Visual -->

				<!-- Main Info -->
				<section class="section section_info" data-0="top:688px;" data-688="top:0px;" data-1473="top:-785px;">
					<h2 class="blind">BBQ Info</h2>
					<div class="section-body">
						<div class="inner">
							<div class="bbq-menu">
								<%
	Set bCmd = Server.CreateObject("ADODB.Command")
	With bCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_menu_select_main"

		If CheckLogin() Then
			.Parameters.Append .CreateParameter("@member_idx", adInteger, adParamInput,, Session("userIdx"))
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
								<p class="txt01"><%=main_title1%></p>
								<p class="tit"><%=bRs("menu_name")%></p>
								<p class="txt02"><%=main_title2%></p>
								<i class="ico ico-cap delay-09s"></i>
								<div class="info-box">
									<img src="<%=SERVER_IMGPATH%><%=bRs("main_file_path")&bRs("main_file_name")%>"
										onerror="this.src='/images/main/img_menu.jpg';" alt="<%=bRs("menu_name")%>">
									<div class="btn-wrap">
										<button type="button"
											onclick="javascript:location.href='/menu/menuView.asp?midx=<%=bRs("menu_idx")%>&cidx=<%=bRs("category_idx")%>&cname=<%=bRs("category_name")%>';"
											class="btn btn-md btn-grayLine"><span>자세히보기</span></button>
										<button type="button"
											onclick="javascript:addMenuNGo('M$$<%=bRs("menu_idx")%>$$<%=bRs("menu_option_idx")%>$$<%=bRs("menu_price")%>$$<%=bRs("menu_name")%>$$<%=SERVER_IMGPATH%><%=bRs("main_file_path")&bRs("main_file_name")%>', true);"
											class="btn btn-md btn-red-main btn-line"><span>바로 주문하기</span></button>
									</div>
								</div>
								<%
	End If
%>
							</div>
							<div class="bbq-enjoy">
								<%
	If CheckLogin() Then
		restPoint = 0
		couponCount = 0
		cardCount = 0
		Set pointBalance = PointGetPointBalance("SAVE", 30)

		If pointBalance.mMessage = "SUCCESS" Then
			restPoint = pointBalance.mTotalPoint
		Else
%>
								<script type="text/javascript">
									alert("<%=pointBalance.mMessage%>");
								</script>
								<%		
		End If

		Set couponHoldList = CouponGetHoldList("NONE", "N", 100, 1)

		If couponHoldList.mMessage = "SUCCESS" Then
			couponCount = couponHoldList.mTotalCount
		Else
%>
								<script type="text/javascript">
									alert("<%=couponHoldList.mMessage%>");
								</script>
								<%
		End If

		Set cardOwnList = CardOwnerList("USE")

		If cardOwnList.mCode = 0 Then
			cardCount = UBound(cardOwnList.mCardDetail)+1
		Else
%>
								<script type="text/javascript">
									alert("<%=cardOwnList.mMessage%>");
								</script>
								<%
		End If
%>
								<i class="ico ico-cover delay-12s"></i>
								<p class="tit">알짜배기 생활의 달인,<br><strong>당신에게 알려드리는 꿀팁</strong></p>
								<ul class="list">
									<li class="item01">
										<a href="/mypage/mileage.asp">
											<p>포인트</p>
											<i class="ico ico-point"></i>
											<span><em><%=FormatNumber(restPoint,0)%></em>P</span>
										</a>
									</li>
									<li class="item02 delay-03s">
										<a href="/mypage/couponList.asp">
											<p>쿠폰</p>
											<i class="ico ico-coupon"></i>
											<span><em><%=FormatNumber(couponCount,0)%></em>장</span>
										</a>
									</li>
									<li class="item03 delay-06s">
										<a href="/mypage/cardList.asp">
											<p>카드</p>
											<i class="ico ico-card"></i>
											<span><em><%=FormatNumber(cardCount,0)%></em>장</span>
										</a>
									</li>
								</ul>
								<div class="btn-wrap">
									<button type="button" onclick="location.href='/mypage/membership.asp';"
										class="btn btn-md btn-grayLine-main w-100p">
										<span><i class="ddack">딹</i> 멤버십 혜택 자세히 보기</span>
									</button>
								</div>
								<%
	Else
%>
								<i class="ico ico-cover delay-12s"></i>
								<p class="tit">알짜배기 생활의 달인,<br><strong>당신에게 알려드리는 꿀팁</strong></p>
								<ul class="list">
									<li class="item01">
										<a href="javascript:openLogin();">
											<p>맛있는 치킨 먹고<br>포인트를<br>적립하세요</p>
											<i class="ico ico-point"></i>
										</a>
									</li>
									<li class="item02 delay-03s">
										<a href="javascript:openLogin();">
											<p>고객님만을 위한<br>쿠폰을<br>확인하시려면?</p>
											<i class="ico ico-coupon"></i>
										</a>
									</li>
									<li class="item03 delay-06s">
										<a href="javascript:openLogin();">
											<p>BBQ카드 만들고<br>언제 어디서나<br>혜택을 누리세요</p>
											<i class="ico ico-card"></i>
										</a>
									</li>
								</ul>
								<div class="btn-wrap">
									<button type="button" onclick="openJoin();"
										class="btn btn-md btn-grayLine-main w-100p">
										<span><i class="ddack">딹</i> 멤버십 가입하기</span>
									</button>
								</div>
								<%
	End If
%>
							</div>
						</div>
					</div>
					<div class="ck1"><img src="/images/main/ck1.png" alt="ck1"></div>
					<div class="ck2"><img src="/images/main/ck2.png" alt="ck2"></div>
				</section>
				<!--// Main Info -->

				<!-- Main Menu -->
				<section class="section section_menu" data-0="top:1696px;" data-688="top:785px;" data-1473="top:0px;"
					data-2384="top:0px;" data-3335="top:-911px;">
					<div class="section-header">
						<h2>BBQ Menu</h2>
					</div>
					<div class="section-body">
						<div class="tab-wrap tab-layer">
							<ul class="tab">
								<%
	cateCount = 0
	Set bCmd = Server.CreateObject("ADODB.Command")
	With bCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_main_category_select"

		Set bRs = .Execute
	End With
	Set bCmd = Nothing

	Dim categoryArray()
	i = 0
	If Not (bRs.BOF Or bRs.EOF) Then
		cateCount = bRs.RecordCount
		' Response.Write cateCount
		ReDim categoryArray(cateCount-1,1)

		' Response.Write UBound(categoryArray,1)
		bRs.MoveFirst
		Do Until bRs.EOF
			categoryArray(i,0) = bRs("category_idx")
			categoryArray(i,1) = bRs("category_name")
%>
								<li<%If i = 0 Then%> class="on" <%End If%>><a
										href="javascript:;"><span><%=bRs("category_name")%></span></a></li>
									<%
			i = i + 1
			bRs.MoveNext
		Loop
	End If
	Set bRs = Nothing
%>
							</ul>
						</div>
						<div class="tab-container tab-container-layer">
							<%
	For i = 0 To cateCount-1
%>
							<!-- tab-content 올리브 오리지널 -->
							<div class="tab-content<%If i = 0 Then%> on<%End If%>">
								<div class="tab-slider-wrap">
									<ul class="tab-slider">
										<%
		Set bCmd = Server.CreateObject("ADODB.Command")
		With bCmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_category_menu_list"

			.Parameters.Append .CreateParameter("@category_idx", adInteger, adParamInput, , categoryArray(i,0))

			Set bRs = .Execute
		End With
		Set bCmd = Nothing

		If Not (bRs.BOF Or bRs.EOF) Then
			bRs.MoveFirst
			Do Until bRs.EOF
				calorie	= bRs("calorie")	'	열량
				sugars	= bRs("sugars")	'	당류g
				protein	= bRs("protein")	'	단백질
				saturatedfat	= bRs("saturatedfat")	'	포화지방
				natrium	= bRs("natrium")	'	나트륨

%>
										<li class="item">
											<div class="inner">
												<div class="etc01"><img src="/images/main/img_etc01.png" alt=""></div>
												<div class="etc02"><img src="/images/main/img_etc02.png" alt=""></div>
												<div class="etc03"><img src="/images/main/img_etc03.png" alt=""></div>
												<div class="etc04"><img src="/images/main/img_etc04.png" alt=""></div>
												<div class="img-wrap on"><img
														src="<%=SERVER_IMGPATH%><%=bRs("main_file_path")&bRs("main_file_name")%>"
														width="488px" height="479px"
														onerror="this.src='/images/main/img_menuList.png';"
														alt="자메이카 통다리 구이"></div>
												<div class="info-wrap">
													<p class="tit"><%=bRs("menu_name")%></p>
													<p class="txt"><%=bRs("menu_title")%></p>
													<p class="origin"><%=bRs("origin")%></p>
													<ul class="list">
														<li>
															<p>열량<br><span>(kcal)</span></p>
															<em><%=calorie%></em>
														</li>
														<li>
															<p>당류<br><span>(g)</span></p>
															<em><%=sugars%></em>
														</li>
														<li>
															<p>단백질<br><span>(g)</span></p>
															<em><%=protein%></em>
														</li>
														<li>
															<p>포화지방<br><span>(g)</span></p>
															<em><%=saturatedfat%></em>
														</li>
														<li>
															<p>나트륨<br><span>(mg)</span></p>
															<em><%=natrium%></em>
														</li>
													</ul>
													<div class="price-wrap">
														<p class="price"><em><%=FormatNumber(bRs("menu_price"),0)%></em>
															원</p>
														<div class="num-wrap">
															<button type="button" class="minus"></button>
															<input type="text" value="1" title="수량입력" class="num"
																readonly="readonly">
															<button type="button" class="add"></button>
														</div>
													</div>
													<div class="btn-wrap">

														<button type="button"
															onclick="javascript:location.href='/menu/menuView.asp?midx=<%=bRs("menu_idx")%>&cidx=<%=categoryArray(i,0)%>&cname=<%=categoryArray(i,1)%>';"
															class="btn btn-lg btn-whilte btn-noLine"><span><img
																	src="/images/main/img_plus.png"
																	alt="추가"></span></button>
														<button type="button"
															onclick="javascript:addMenuNGoWithCntType('M$$<%=bRs("menu_idx")%>$$<%=bRs("menu_option_idx")%>$$<%=bRs("menu_price")%>$$<%=bRs("menu_name")%>$$<%=SERVER_IMGPATH%><%=bRs("main_file_path")&bRs("main_file_name")%>', 'P');"
															class="btn btn-lg btn-yellow btn-noLine"><span>포장주문</span></button>
														<button type="button"
															onclick="javascript:addMenuNGoWithCntType('M$$<%=bRs("menu_idx")%>$$<%=bRs("menu_option_idx")%>$$<%=bRs("menu_price")%>$$<%=bRs("menu_name")%>$$<%=SERVER_IMGPATH%><%=bRs("main_file_path")&bRs("main_file_name")%>', 'D');"
															class="btn btn-lg btn-red btn-noLine"><span>배달주문</span></button>
													</div>
												</div>
											</div>
										</li>
										<%
				bRs.MoveNext
			Loop
		End If
		Set bRs = Nothing
%>
									</ul>
								</div>
							</div>
							<%
	Next
%>
							<!--// tab-content -->
						</div>
					</div>
				</section>
				<!--// Main Menu -->

				<!-- Main CF -->
				<section class="section section_cf" data-688="top:1862px;" data-1473="top:911px;" data-2384="top:0px;"
					data-3335="top:-951px;">
					<h2 class="blind">BBQ CF</h2>
					<div class="section-body">
						<div class="inner">
							<div class="cf_txt">
								<div class="img"><img src="/images/main/mid_chicken.png" alt="치킨"></div>
								<p class="txt01">맛있는데 건강에도 좋은 치킨이 있다고?</p>
								<p class="txt02">BBQ는 최고의 맛있는 치킨, 건강에 좋은 치킨을 만들겠다는 일념으로<br>일반 식용유보다 7배 더 비싼 100% 엑스트라 버진
									올리브유를 원료로
									한<br>특허받은 BBQ 전용 후라잉유를 사용하고 있습니다.</p>
							</div>
							<div class="video-wrap">
								<div class="video-box">
										<iframe width="796" height="446" src="https://www.youtube.com/embed/cZKTAqZsZks" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
									<!-- <iframe width="1280" height="458" src="https://www.youtube.com/embed/V21jcKjgPBI"
										frameborder="0"
										allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
										allowfullscreen></iframe> -->
									<!--	<iframe width="796" height="446"
										src="https://www.youtube.com/embed/Dc5dKxHSSDU?rel=0&amp;controls=0&amp;showinfo=0&amp;autoplay=0&amp;volumn=0&amp;mute=1"
										allowfullscreen></iframe>-->
								</div>
								<div class="video-info">
									<p class="tit">BBQ CF</p>
									<p class="txt">TV로 방송된 BBQ의 재미있는 CF를 감상해보세요.</p>
								</div>
							</div>
						</div>
					</div>
					<div class="ck3"><img src="/images/main/ck3.png" alt="ck3"></div>
					<div class="ck4"><img src="/images/main/ck4.png" alt="ck4"></div>
				</section>
				<!--// Main CF -->

				<!-- Main Store -->
				<section class="section section_store" data-1473="top:1803px;" data-2384="top:951px;"
					data-3335="top:0px;" data-4187="top:-852px;">
					<div class="section-header">
						<h2>BBQ STORE</h2>
					</div>
					<div class="section-body">
						<div class="inner">
							<!-- <div id="map" class="map-wrap"><img src="/images/main/bg_map.jpg" alt="지도샘플"></div> -->
							<div id="map" class="map-wrap">
							</div>
							<script>
								var map;
								var markers = [];
								var image = [];


								function loadTabList(branch_id, lat, lng) {
									// console.log(branch_id);
									var pos = { lat: lat, lng: lng };
									var map = new google.maps.Map(document.getElementById('map'), {
										zoom: 15,
										center: pos,
										gestureHandling: 'greedy'
									});

									image = {
										url: '/images/shop/ico_marker.png',
										size: new google.maps.Size(35, 40),
										scaledSize: new google.maps.Size(35, 40)
									};
									var marker = new google.maps.Marker({
										position: new google.maps.LatLng(lat, lng),
										map: map,
										draggable: false,
										//animation: google.maps.Animation.DROP,
										icon: image,
										// label: {text: ""+Number(i+1), color: "white"},
									});
									markers.push(marker);
									marker.addListener('click', function () {
										map.panTo(this.position);
										// viewBranch(branch_id);
										// clearMarkers(map, (this.no + 1));
									});
									// setMarkers(map, pos);
									// if(branch_id) viewBranch(branch_id);
								}

								function textSearch() {
									var pos = {
										lat: $('#lat').val(),
										lng: $('#lng').val()
									};
									setMarkers(map, pos);
								}

								function setMarkers(map, pos) {
									var slideHtml1 = "";
									var slideHtml2 = "";
									var slideHtml3 = "";
									var slideHtml4 = "";
									var imgSrc = "";
									var dong = "";
									var slideLocation = "";

									image = {
										url: '/images/shop/ico_marker.png',
										size: new google.maps.Size(35, 40),
										scaledSize: new google.maps.Size(35, 40)
									};

									image2 = {
										url: '/shop/ico_marker.png',
										size: new google.maps.Size(35, 40),
										scaledSize: new google.maps.Size(35, 40)
									};

									$.ajax({
										url: '/api/ajax/shopListAllJs.asp',
										type: 'POST',
										data: { "lat": pos.lat, "lng": pos.lng, "search_text": $('#search_text').val() },
										success: function (json) {
											// console.log(json);
											// console.log(json.length);
											$("#store_count").text(json.length);
											for (var i = 0; i < json.length; i++) {
												var marker = new google.maps.Marker({
													position: new google.maps.LatLng(json[i].wgs84_y, json[i].wgs84_x),
													map: map,
													draggable: false,
													//animation: google.maps.Animation.DROP,
													icon: image,
													no: i,
													// label: {text: ""+Number(i+1), color: "white"},
												});
												markers.push(marker);
												var br_id = json[i].branch_id;
												marker.addListener('click', function () {
													// lpOpen2(".lp-popShop");
													// viewBranch(br_id);

													map.panTo(this.position);

													// clearMarkers(map, (this.no + 1));
												});

												imgSrc = "/images/shop/ico_marker.png";

												slideHtml1 += "<li>\n";
												slideHtml1 += "\t<a onclick=\"loadTabList(" + json[i].branch_id + "," + json[i].wgs84_y + "," + json[i].wgs84_x + ");\">\n";
												slideHtml1 += "\t\t<p class=\"tit\">" + json[i].branch_name;
												if (json[i].yogiyo_yn == "Y")
													slideHtml1 += "<img src='/images/shop/yogiyo_icon.png' class='yogiyo'>";
												if (json[i].membership_yn_code == "50")
													slideHtml1 += "<img src='/images/shop/mem_icon2.png' class='memicon'>";
												slideHtml1 += "</p>\n";
												slideHtml1 += "\t\t<p class=\"txt\">" + json[i].branch_address + "</p>\n";
												slideHtml1 += "\t\t<p class=\"tel\">" + json[i].branch_tel + "</p>\n";
												slideHtml1 += "\t</a>\n";
												slideHtml1 += "</li>\n";

												// //Express
												// if(json[i].branch_type.toUpperCase().indexOf("CAFE") != -1 || json[i].branch_type.toUpperCase().indexOf("REGULAR") != -1) {
												// 	slideHtml2 += "<li>\n";
												// 	slideHtml2 += "\t<a onclick=\"loadTabList("+json[i].branch_id+","+json[i].wgs84_y+","+json[i].wgs84_x+");\">\n";
												// 	slideHtml2 += "\t\t<p class=\"tit\">"+json[i].branch_name+"</p>\n";
												// 	slideHtml2 += "\t\t<p class=\"txt\">"+json[i].branch_address+"</p>\n";
												// 	slideHtml2 += "\t\t<p class=\"tel\">"+json[i].branch_tel+"</p>\n";
												// 	slideHtml2 += "\t</a>\n";
												// 	slideHtml2 += "</li>\n";
												// }
												// //프리미엄
												// if(json[i].branch_type.indexOf("프리미엄") != -1) {
												// 	slideHtml3 += "<li>\n";
												// 	slideHtml3 += "\t<a onclick=\"loadTabList("+json[i].branch_id+","+json[i].wgs84_y+","+json[i].wgs84_x+");\">\n";
												// 	slideHtml3 += "\t\t<p class=\"tit\">"+json[i].branch_name+"</p>\n";
												// 	slideHtml3 += "\t\t<p class=\"txt\">"+json[i].branch_address+"</p>\n";
												// 	slideHtml3 += "\t\t<p class=\"tel\">"+json[i].branch_tel+"</p>\n";
												// 	slideHtml3 += "\t</a>\n";
												// 	slideHtml3 += "</li>\n";
												// }
												// //주차장
												// if(json[i].branch_type.charAt(0) == '1') {
												// 	slideHtml4 += "<li>\n";
												// 	slideHtml4 += "\t<a onclick=\"loadTabList("+json[i].branch_id+","+json[i].wgs84_y+","+json[i].wgs84_x+");\">\n";
												// 	slideHtml4 += "\t\t<p class=\"tit\">"+json[i].branch_name+"</p>\n";
												// 	slideHtml4 += "\t\t<p class=\"txt\">"+json[i].branch_address+"</p>\n";
												// 	slideHtml4 += "\t\t<p class=\"tel\">"+json[i].branch_tel+"</p>\n";
												// 	slideHtml4 += "\t</a>\n";
												// 	slideHtml4 += "</li>\n";
												// }

											}
											if (slideHtml1 == "") slideHtml1 = "<li><a href=\"javascript:;\"><p class=\"txt\">해당 매장이 없습니다.</p></a></li>";
											// if(slideHtml2 == "") slideHtml2 = "<li><a href=\"javascript:;\"><p class=\"txt\">해당 매장이 없습니다.</p></a></li>";
											// if(slideHtml3 == "") slideHtml3 = "<li><a href=\"javascript:;\"><p class=\"txt\">해당 매장이 없습니다.</p></a></li>";
											// if(slideHtml4 == "") slideHtml4 = "<li><a href=\"javascript:;\"><p class=\"txt\">해당 매장이 없습니다.</p></a></li>";
											$('#shopArea1').html(slideHtml1);
											// $('#shopArea2').html(slideHtml2);
											// $('#shopArea3').html(slideHtml3);
											// $('#shopArea4').html(slideHtml4);
										},
										error: function (xhr) { }
									});
								}


								function initMap() {

									var uluru = { lat: 37.491872, lng: 127.115922 };


									// Try HTML5 geolocation.
									if (navigator.geolocation) {
										navigator.geolocation.getCurrentPosition(function (position) {
											var pos = {
												lat: position.coords.latitude,
												lng: position.coords.longitude
											};

											map = new google.maps.Map(document.getElementById('map'), {
												zoom: 15,
												center: pos,
												gestureHandling: 'greedy'
											});

											setMarkers(map, pos);
											$('#lat').val(pos.lat);
											$('#lng').val(pos.lng);
											// loadTabList(pos);

										}, function () {
											map = new google.maps.Map(document.getElementById('map'), {
												zoom: 15,
												center: uluru,
												gestureHandling: 'greedy'
											});

											setMarkers(map, uluru);
											$('#lat').val(uluru.lat);
											$('#lng').val(uluru.lng);
										});
									} else {
										// Browser doesn't support Geolocation
										map = new google.maps.Map(document.getElementById('map'), {
											zoom: 15,
											center: uluru,
											gestureHandling: 'greedy'
										});

										setMarkers(map, uluru);
										$('#lat').val(uluru.lat);
										$('#lng').val(uluru.lng);
										console.log('default');
									}
								}

								$(function () {
									$("#search_text").keypress(function (e) {
										if (e.keyCode == 13) {
											e.preventDefault();
											textSearch();
										}
									});
								});
							</script>
							<script async defer
								src="https://maps.googleapis.com/maps/api/js?key=<%=GOOGLE_MAP_API_KEY%>&callback=initMap&region=kr"></script>
							<div class="map-search">
								<div class="search-box">
									<input type="hidden" name="lat" id="lat" value="">
									<input type="hidden" name="lng" id="lng" value="">
									<input type="text" title="검색입력창" name="search_text" id="search_text"
										placeholder="매장명을 입력하세요">
									<button type="button" class="btn-search"
										onclick="textSearch();"><span></span></button>
									<p class="total-txt">주변 <em class="num" id="store_count">50</em>개의 매장이 있습니다.</p>
								</div>
								<!-- <div class="tab-wrap tab-layer">
								<ul class="tab">
									<li class="on"><a href="#"><span>전체</span></a></li>
									<li><a href="#"><span>익스프레스</span></a></li>
									<li><a href="#"><span>프리미엄</span></a></li>
									<li><a href="#"><span>주차장</span></a></li>
								</ul>
							</div> -->
								<div class="tab-container tab-container-layer mCustomScrollbar">
									<div class="tab-content on">
										<ul class="map-list" id="shopArea1"></ul>
									</div>
									<!-- <div class="tab-content">
									<ul class="map-list" id="shopArea2"></ul>
								</div>
								<div class="tab-content">
									<ul class="map-list" id="shopArea3"></ul>
								</div>
								<div class="tab-content">
									<ul class="map-list" id="shopArea4"></ul>
								</div> -->
								</div>
							</div>
						</div>
					</div>
				</section>
				<!--// Main Store -->

				<!-- Main Best Quality -->
				<section class="section section_bestQuality" data-2384="top:1768px;" data-3335="top:852px;"
					data-4187="top:0px;" data-4631="top:-200px;">
					<div class="inner">
						<div class="section-header">
							<h2><strong>B</strong>est of the <strong>B</strong>est <strong>Q</strong>uality</h2>
						</div>
						<div class="section-body">
							<p class="txt">더 풍부한 행복을 만들기 위해 고객의 입맛과 마음을 연구합니다.<br>당신의 행복을 키우는 BBQ</p>
							<ul class="bestQuality-list">
								<li class="item01">
									<a href="/brand/bbq.asp">
										<i class="ico ico-story01"></i>
										<span>BBQ STORY</span>
									</a>
								</li>
								<li class="item02 delay-03s">
									<a href="/brand/oliveList.asp">
										<i class="ico ico-story02"></i>
										<span>황금올리브이야기</span>
									</a>
								</li>
								<li class="item03 delay-06s">
									<a href="/brand/videoList.asp">
										<i class="ico ico-story03"></i>
										<span>영상 콘텐츠</span>
									</a>
								</li>
							</ul>
						</div>
					</div>
				</section>
				<!--// Main Best Quality -->

			</article>
			<!--// Content -->

			<!-- QuickMenu -->
			<!--#include virtual="/includes/quickmenu.asp"-->
			<!-- QuickMenu -->

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
				<button type="button" class="today" onClick="PopupNoDispaly()"><span>하루동안 보지않기</span> <i
						class="axi axi-close"></i></button>
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
	<script src="/common/js/libs/skrollr.min.js"></script>
	<!--[if lt IE 9]>
<script src="/common/js/libs/skrollr.ie.min.js"></script>
<![endif]-->
	<script>
		var s = skrollr.init({
			edgeStrategy: 'set',
			easing: {
				WTF: Math.random,
				inverted: function (p) {
					return 1 - p;
				}
			}
		});
	</script>
</body>

</html>