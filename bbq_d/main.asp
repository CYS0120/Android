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
			<article class="content clearfix">

				<!-- Main Visual -->
				

				<section class="section_visual" >
					<h2 class="blind">BBQ Visual</h2>
					<div class="section-body">
						
						<ul class="main-bxslider">
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
										txtFromDate	= Cdate(left(bRs("date_s"),4) & "-" & mid(bRs("date_s"),5,2) & "-" & right(bRs("date_s"),2))
										txtToDate	= Cdate(left(bRs("date_e"),4) & "-" & mid(bRs("date_e"),5,2) & "-" & right(bRs("date_e"),2))
                						If txtFromDate <= date() AND txtToDate >= date() Then
							%>

							<!-- <li class="item" style="background:url('<%=SERVER_IMGPATH%>/main/<%=MAIN_IMG%>') no-repeat center bottom; cursor:pointer" <% if bRs("link_url") <> "" then %> onclick="location.href='<%=bRs("link_url")%>' " <% end if %>> -->

							<li class="item" style="background:url('<%=SERVER_IMGPATH%>/main/<%=MAIN_IMG%>') no-repeat center bottom; cursor:pointer" 
							<% if bRs("link_url") <> "" then %> 
								<% if bRs("link_url") = "/menu/menuList.asp" then ' 5%적립이다 가정함. %>
									<% if Session("userIdNo") <> "" then %>
										onclick="location.href='<%=bRs("link_url")%>' " 
									<% else %>
										onclick="openJoin()" 
									<% end if %>
								<% else %>
								onclick="location.href='<%=bRs("link_url")%>' " 
								<% end if %>
							<% end if %>>

								<div class="inner">
									<div class="info-box">
										<%=MAIN_TEXT%>
									</div>
								</div>
							</li>
							<% 
										End If
										bRs.MoveNext
									Loop
								End If 
								bRs.close
								Set bRs = Nothing
							%>

							<!--	
							<li class="item">
								<div class="inner" style="width:auto;">
									<video src="/video/bbqtest_chicken_main.mp4" autoplay loop style="padding-top:105px;width:1920px;">
										<p>Your user agent does not support the HTML5 Video element.</p>
									</video>
								</div>
							</li>
							<li class="item">
								<div class="inner">
									<iframe width="100%" height="700" src="https://www.youtube.com/embed/WCyUo_4kvLw?rel=0&amp;controls=0&amp;showinfo=0&amp;autoplay=0&amp;volumn=0&amp;mute=1" allowfullscreen></iframe>
								</div>
							</li>
							-->
						</ul>
					</div>
				</section>
				<!--// Main Visual -->

				
				
				
				<!-- 온라인주문 -->
				<div class="online-order" >
					<div>온라인주문</div>
					<a href="javascript: mobile_cart_window_open()">주문하기</a>
				</div>
				<!--// 온라인주문 -->


				<!-- store-info -->
				<div class="store-info" >
					<h2>매장안내</h2>
					<div class="search-box clearfix">
						<input type="hidden" name="lat" id="lat" value="">
						<input type="hidden" name="lng" id="lng" value="">
						<input type="text" title="검색입력창" name="search_text" id="search_text" placeholder="매장명 또는 주소를 입력하세요">
						<button type="button" class="btn-search" onclick="textSearch();"></button>
					</div>
					<a href="/shop/shopList.asp" class="btn-storeAll">전체매장 보기</a>					
				</div>
				<!--// store-info -->

				<script type="text/javascript">
					function textSearch()
					{
						if (!$('#search_text').val()) {
							alert("매장명 또는 주소를 입력하세요");
							return false;
						}

						location.href = "/shop/shopList.asp?search_text="+ $('#search_text').val()
					}
				</script>


				
				<!-- 전체 메뉴 -->
				<script src="/common/js/prrple.slider.js"></script>
				<script src="/common/js/scripts.js"></script>

				<%
					s = 0
					Set bCmd = Server.CreateObject("ADODB.Command")
					With bCmd
						.ActiveConnection = dbconn
						.NamedParameters = True
						.CommandType = adCmdStoredProc
						.CommandText = "bp_main_banner_select_sub"
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
							<style type="text/css">
								.slide_bg_plus<%=s%> {background:url('<%=SERVER_IMGPATH%>/main/<%=MAIN_IMG%>') no-repeat;}
							</style>
				<% 
						bRs.MoveNext
						s = s + 1
						Loop
					End If 
					bRs.close
					Set bRs = Nothing
				%>

				<section class="section2">
					<div class="ad_allmenu">
						<div class="slider">
							<div class="slider_area">
								<div class="slides">

									<%
										s = 0
										Set bCmd = Server.CreateObject("ADODB.Command")
										With bCmd
											.ActiveConnection = dbconn
											.NamedParameters = True
											.CommandType = adCmdStoredProc
											.CommandText = "bp_main_banner_select_sub"
											.Parameters.Append .CreateParameter("@BRAND_CODE", adVarchar, adParamInput, 10, SITE_BRAND_CODE)
											.Parameters.Append .CreateParameter("@MODE", adChar, adParamInput, 1, "W")
											Set bRs = .Execute
										End With
										Set bCmd = Nothing
										If Not (bRs.BOF Or bRs.EOF) Then
											Do While Not bRs.EOF
												MAIN_IMG	= bRs("MAIN_IMG")
												MAIN_TEXT	= bRs("MAIN_TEXT")
												' 위쪽에 한번더 쿼리문이 있음. 
												' style 강제적용하면 안되고
												' style 정의하는부분이 이 안에있으면 오작동됨.
									%>
												<div class="slide slide_bg_plus<%=s%>" onclick="location.href='<%=bRs("link_url")%>' " ><h3><%=MAIN_TEXT%></h3> <span>메뉴보기</span></div>
									<% 
											bRs.MoveNext
											s = s + 1
											Loop
										End If 
										bRs.close
										Set bRs = Nothing
									%>

								</div>
							</div>
							<a class="slider_left"><img alt="" src="/images/main/icon_arrow_left.png"></a>
							<a class="slider_right"><img alt="" src="/images/main/icon_arrow_right.png"></a>
						</div>									
					</div>
					<!-- // 전체 메뉴 -->




					<!-- 사이드메뉴 -->
					<div class="ad_bestmenu">
						<a href="/menu/menuList.asp?cidx=99999&cname=사이드메뉴"><h3>사이드메뉴</h3> <span>메뉴보기</span></a>					
					</div>
					<!-- // 사이드메뉴 -->



					<!-- 공지사항 -->
					<div class="latest-news">
						<h2><a href="/brand/noticeList.asp">공지사항</a></h2>
						<ul>
							<%
								Set vCmd = Server.CreateObject("ADODB.Command")
								With vCmd
									.ActiveConnection = dbconn
									.NamedParameters = True
									.CommandType = adCmdStoredProc
									.CommandText = "bp_Board_NoticeList"
									.Parameters.Append .CreateParameter("@ListType", adVarChar, adParamInput, 5, "LIST")
									.Parameters.Append .CreateParameter("@pageSize", adInteger, adParamInput, , 3)
									.Parameters.Append .CreateParameter("@cPage", adInteger, adParamInput, , 1)
									.Parameters.Append .CreateParameter("@sKey", adVarChar, adParamInput, 20, "TITLE")
									.Parameters.Append .CreateParameter("@sWord", adVarChar, adParamInput, 50, searchStr)
									.Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)
									.Parameters.Append .CreateParameter("@BRAND_CODE", adVarchar, adParamInput, 5, SITE_BRAND_CODE)
									.Parameters.Append .CreateParameter("@BBS_CODE", adVarChar, adParamInput, 5, "A03")
									Set vRs = .Execute
								End With
								Set vCmd = Nothing

								If Not (vRs.BOF Or vRs.EOF) Then
									Do Until vRs.EOF
							%>
										<li><a href="/brand/noticeView.asp?nidx=<%=vRs("BIDX")%>&gotoPage=<%=gotoPage%>"><%=vRs("title")%></a><p><%=FormatDateTime(vRs("reg_date"),2)%></p></li>
							<%
										vRs.MoveNext
									Loop
								End If
								Set vRs = Nothing
							%>
						</ul>
						<a href="/brand/noticeList.asp" class="btn-more"><img alt="" src="/images/main/icon_more.png"></a>
					</div>
					<div class="clearfix"></div>
					<!-- // 공지사항 -->
				</section>

				

				<!-- 이벤트,  멤버쉽, 창업문의 -->
				<ul class="mBaneer3 clearfix">
					<li>
						<a href="/event/eventList.asp" class="animated-button victoria-four">
							이벤트 <span><img src="/images/main/ico_ban_event.png" alt="" /></span>
						</a>
					</li>
					<li>
						<a href="#" onclick="javascript:return false;" class="animated-button victoria-four">
							멤버쉽 <span><img src="/images/main/ico_ban_membership.png" alt="" /></span>
						</a>
					</li>
					<li>
						<a href="https://www.bbqchangup.co.kr:446/" class="animated-button victoria-four" target="_blank">
							창업문의 <span><img src="/images/main/ico_ban_coupon.png" alt="" /></span>
						</a>
					</li>
				</ul>
				<!-- // 이벤트,  멤버쉽, 창업문의 -->



				

				

				

				

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