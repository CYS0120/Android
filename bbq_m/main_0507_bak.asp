<!--#include virtual="/api/include/utf8.asp"-->
<%
	If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqiOS") > 0 then
		Response.Cookies("bbq_app_type") = "bbqiOS"
		Response.Cookies("bbq_app_type").Expires = DateAdd("yyyy", 1, now())
	elseif instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Then
		Response.Cookies("bbq_app_type") = "bbqAOS"
		Response.Cookies("bbq_app_type").Expires = DateAdd("yyyy", 1, now())
	end if 

	' 어플이면서 / 비회원이고 / refresh_token 이 있으면
	' 자동로그인 (logout 버튼을 눌렀을땐 쿠키값이 모두 사라짐)
	if Request.Cookies("bbq_app_type") <> "" and trim(Session("userId")) = "" and Request.Cookies("refresh_token") <> "" then 
		access_token = Request.Cookies("access_token")
		access_token_secret = Request.Cookies("access_token_secret")
		refresh_token = Request.Cookies("refresh_token")
		token_type = Request.Cookies("token_type")
		expires_in = Request.Cookies("expires_in")
		auto_login_yn = Request.Cookies("auto_login_yn")

		multi_domail_login_url = "/api/loginToken.asp?main_yn=Y&access_token="& access_token &"&access_token_secret="& access_token_secret &"&refresh_token="& refresh_token &"&token_type="& token_type &"&expires_in="& expires_in &"&auto_login_yn="& auto_login_yn &"&domain="& domain &"&rtnUrl="& rtnUrl

		Response.Redirect multi_domail_login_url
	end if 
%>

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

	<!-- Container -->
	<div class="container">
		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
		<hr>
				
		<!-- Content -->
		<article class="content">
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

				<section class="section section_info pad-t69" style="background:#fff"><!--background:url('<%=SERVER_IMGPATH%>/main/<%=MAIN_IMG%>') no-repeat center top;-->

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
						<!--
						<div class="img-box">
							<img src="<%=SERVER_IMGPATH%><%=bRs("mobile_file_path")&bRs("mobile_file_name")%>" onerror="this.src='/images/main/img_info01.png';" alt="<%=brs("menu_name")%>">
						</div>
						-->

						<% if Session("userIdNo") <> "" then %>
						<% else %>
							<button type="button" onclick="openLogin('mobile');" class="login_before"><span>로그인</span>을 통해 더 많은 혜택을 누리세요.</button>
						<% end if %>

						<!-- mainVisual -->
						<link href="/common/css/half-slider.css" rel="stylesheet">

						<!-- 메인 배너코딩 -->
						<div class="flexslider">
							<ul class="slides spot_li">
								<li class="flex-active-slide" style="background-image:url('/images/main/bbq_main_2020417_01.jpg');"><a href="/brand/eventView.asp?eidx=1169&event=OPEN" target="_self" style="display:block; width:100%; height:100%;">&nbsp;</a></li>
								<li class="" style="background-image:url('/images/main/bbq_m_main_2020421.jpg');"><a href="/brand/eventView.asp?eidx=1171&event=OPEN" target="_self" style="display:block; width:100%; height:100%;">&nbsp;</a></li>
								<!-- <li class="" style="background-image:url('/images/main/bbq_main_2020417_02.jpg');"></li> -->
							</ul>
						</div>
						<!-- // 메인 배너코딩 -->

						<script type="text/javascript" src="/common/js/jquery.flexslider.js"></script>
						<script type="text/javascript" src="/common/js/script.js"></script>
						<script type="text/javascript">
							$(window).load(function () {
								$('.flexslider').flexslider({
								animation: "slide"
							});
						});
						</script>			
						<!-- // mainVisual-->


						<div class="main_con">

							<ul class="main_con_wrap">
								<li>
									<div class="main_popular" onclick="location.href='/menu/menuList.asp?anc=103'"><h3>인기메뉴</h3></div>
									
									<!-- 전체메뉴 -->
									<script src="/common/js/jquery.touchSwipe.1.6.min.js"></script>
									<script src="/common/js/prrple.slider.js"></script>
									<script src="/common/js/scripts.js"></script>

									<div id="sliderh3">
										<div class="slider">
											<div class="slider_area">
												<div class="slides">
													<div class="slide slide_bg1" style="" onclick="location.href='/menu/menuList.asp?anc=102'"><h3>핫황금올리브</h3></div>
													<div class="slide slide_bg2" onclick="location.href='/menu/menuList.asp?anc=5'"><h3>순수하게 후라이드</h3></div>
													<div class="slide slide_bg3" onclick="location.href='/menu/menuList.asp?anc=7'"><h3>다양하게 양념</h3></div>
													<div class="slide slide_bg4" onclick="location.href='/menu/menuList.asp?anc=6'"><h3>섞어먹자 반반</h3></div>
													<div class="slide slide_bg5" onclick="location.href='/menu/menuList.asp?anc=8'"><h3>구워먹는 비비큐</h3></div>
													<div class="slide slide_bg6" onclick="location.href='/menu/menuList.asp?anc=99999'"><h3>사이드 메뉴</h3></div>
												</div>
											</div>
											<a class="slider_left"><img alt="" src="/images/main/icon_arrow_left.png"></a>
											<a class="slider_right"><img alt="" src="/images/main/icon_arrow_right.png"></a>
										</div>
									</div>	
									<!-- // 전체메뉴 -->
								</li>
								<li>
									<ul class="main_order2">
										<% if Session("userIdNo") <> "" then %>
										<li class="clearfix" onclick="location.href='/order/delivery.asp?order_type=D'"><span><img src="/images/main/icon_m_order.png"></span> <h3>배달주문</h3></li>
										<% else %>
										<li class="clearfix"  onclick="location.href='/order/selection.asp?order_type=D'"><span><img src="/images/main/icon_m_order.png"></span> <h3>배달주문</h3></li>
										<% end if %>
										<% if Session("userIdNo") <> "" then %>
										<li onclick="location.href='/order/delivery.asp?order_type=P'"><span><img src="/images/main/icon_m_out.png"></span> <h3>포장주문</h3></li>
										<% else %>
										<li onclick="location.href='/order/selection.asp?order_type=P'"><span><img src="/images/main/icon_m_out.png"></span> <h3>포장주문</h3></li>
										<% end if %>
										<li  href="javascript:void(0);" onclick="javascript:lpOpen('.lp_eCoupon');"><span><img src="/images/main/icon_m_coupon.png"></span> <h3>쿠폰주문</h3></li>
										<li onclick="location.href='/mypage/orderList.asp'"><span><img src="/images/main/icon_m_recent.png"></span> <h3>최근주문</h3></li>
									</ul>
								</li>
							</ul>
							<!-- 
							<ul class="main_order">
									<% if Session("userIdNo") <> "" then %>
										<li class="main_deliver" onclick="location.href='/order/delivery.asp?order_type=D'">
									<% else %>
										<li class="main_deliver" onclick="location.href='/order/selection.asp?order_type=D'">
									<% end if %>
									<img src="/images/main/icon_m_order.png">
									<span>배달 주문</span>
								</li>
								<li class="main_out">
										<% if Session("userIdNo") <> "" then %>
											<div onclick="location.href='/order/delivery.asp?order_type=P'">
										<% else %>
											<div onclick="location.href='/order/selection.asp?order_type=P'">
										<% end if %>
										<img src="/images/main/icon_m_out.png">
										<span>포장 주문</span>
									</div>
									<div href="javascript:void(0);" onclick="javascript:lpOpen('.lp_eCoupon');">
										<img src="/images/main/icon_m_coupon.png">
										<span>쿠폰 주문</span>
									</div>
									</ul>
								</li>
							</ul>
							<ul class="main_other">
								<li onclick="location.href='/menu/menuView.asp?midx=<%=brs("menu_idx")%>'">
									<ul>
										<li><img src="/images/main/icon_m_reco.png"></li>
										<li>추천메뉴 바로 주문하기<br><span>황금올리브TM</span></li>
									</ul>
								</li>
								<li onclick="location.href='/mypage/orderList.asp'">
									<ul>
										<li><img src="/images/main/icon_m_reorder.png"></li>
										<li>다시 주문 하기</li>
									</ul>
								</li>
								<%If CheckLogin() Then%>
								<% else %>
									<li onclick="location.href='javascript:openJoin();'">
										<ul>
											<li><img src="/images/main/icon_m_member.png"></li>
											<li>멤버쉽가입</li>
										</ul>
									</li>
								<%End If%>
							</ul>
							 -->
						</div>

										
						<!--
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
						-->
					</div>
				</section>
			</div>
			<!--// Main Info -->

						
		</article>
		<!--// Content -->

		<%
			CookName	= "popup_20190523"
			If Date >= "2019-05-23" And Request.Cookies(CookName) <> "done" Then %>

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

		<% End If  %>


	</div>
	<!--// Container -->


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
			<button type="button" class="today" onClick="PopupNoDispaly()">하루동안 보지않기 <i class="axi axi-close"></i></button>
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

	<!--#include virtual="/includes/app_push.asp"-->
	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->


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


