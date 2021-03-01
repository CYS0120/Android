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
'	if Request.Cookies("bbq_app_type") <> "" and trim(Session("userId")) = "" and Request.Cookies("refresh_token") <> "" then 
	if trim(Session("userId")) = "" and Request.Cookies("refresh_token") <> "" then 
'		access_token = Request.Cookies("access_token")
'		access_token_secret = Request.Cookies("access_token_secret")
'		refresh_token = Request.Cookies("refresh_token")
'		token_type = Request.Cookies("token_type")
'		expires_in = Request.Cookies("expires_in")
'		auto_login_yn = Request.Cookies("auto_login_yn")
'
'		multi_domail_login_url = "/api/loginToken.asp?main_yn=Y&access_token="& access_token &"&access_token_secret="& access_token_secret &"&refresh_token="& refresh_token &"&token_type="& token_type &"&expires_in="& expires_in &"&auto_login_yn="& auto_login_yn &"&domain="& domain &"&rtnUrl="& rtnUrl
'
'		Response.Redirect multi_domail_login_url
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
<%
' 안드로이드 앱 버전 업데이트 팝업 2020-08-10
If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Then
	If instr(Request.ServerVariables("HTTP_USER_AGENT"), "BBQ202001") > 0 Then
	else
%>
<!-- 200605 Layer popup start -->
<script language="JavaScript">
<!--
function setCookie2( name, value, expiredays ) {
    var todayDate = new Date();
        todayDate.setDate( todayDate.getDate() + expiredays );
        document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"
    }

function closeWin() {
    if ( document.notice_form.chkbox.checked ){
        setCookie2( "maindiv", "done" , 1 );
    }
    document.all['divpop'].style.visibility = "hidden";
}
//--> 
</script>

<!-- 200605 Layer popup end -->
<!-- 200605 POPUP start -->
<div id="divpop" style="position:absolute; max-width:650px; width:90%; margin:100px 5% ; z-index:9999;visibility:hidden;">
	<div><a href="https://play.google.com/store/apps/details?id=com.bbq.chicken202001" target="_blank"><img src="popup/popup_200603.jpg"alt="" /></a></div>
	<div style="background:#000; padding:10px;">
		<form name="notice_form">
			<input type="checkbox" name="chkbox" value="checkbox"> <font color="#ffffff">오늘 하루 이 창을 열지 않음 </font>
			<a href="javascript: closeWin();" style="position:absolute; right:5px;"> <font color="#ffffff">[닫기]</font></a>
	   </form>
	</div>
</div> 

<script language="Javascript">
if('<%=request("pc_move")%>' != "Y") {
	cookiedata = document.cookie;   
	if ( cookiedata.indexOf("maindiv=done") < 0 ){     
		document.all['divpop'].style.visibility = "visible";
	} else {
		document.all['divpop'].style.visibility = "hidden";
	}
}
</script>
<!-- 200605 POPUP end -->
<%
	End If
End If
%>
<body onload="lpOpen('.lp_eventpopup');" >

<div class="wrapper main footer_main">

	<!--#include virtual="/includes/header.asp"-->

	<!-- Container -->
	<div class="container">
		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
				
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
					<div class="section-body inner">
						<!-- mainVisual -->
						<link href="/common/css/half-slider.css" rel="stylesheet">

						<div class="flexslider">
							<ul class="slides spot_li">

							<%
								Set bCmd = Server.CreateObject("ADODB.Command")
								With bCmd
									.ActiveConnection = dbconn
									.NamedParameters = True
									.CommandType = adCmdStoredProc
									.CommandText = "bp_main_banner_select_m"
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
										<li><a href="<%=bRs("link_url")%>" style="background:url('<%=SERVER_IMGPATH%>/main/<%=MAIN_IMG%>') no-repeat center top; background-size:cover"></a></li>

							<% bRs.MoveNext
									Loop
								End If 
								bRs.close
								Set bRs = Nothing
							%>
<!-- 
								<%
									YY = Year(Now)
									MM = Right("0"& Month(Now), 2)
									DD = Right("0"& Day(Now), 2)
									HH = Right("0"& Hour(Now), 2)
									II = Right("0"& Minute(Now), 2)
									SS = Right("0"& Second(Now), 2)

									now_date_time = YY & MM & DD & HH & II& SS
								%>
								<li><a href="/menu/menuList.asp?anc=106" style="background:url('/images/main/201008.png') no-repeat center top; background-size:cover"></a></li>
								<li><a href="/menu/menuList.asp?anc=106" style="background:url('/images/main/mainVisual_20200709.gif') no-repeat center top; background-size:cover">&nbsp;</a></li>
								<% if now_date_time >= 20201002105000 And now_date_time <= 20201008235959 then %>
									<li><a href="/event/eventView.asp?eidx=1283&event=OPEN&gotoPage=" style="background:url('/images/main/main_banner_20200929.png') no-repeat center top; background-size:cover"></a></li>
								<% End If %>

								<% if now_date_time >= 20200921000000 And now_date_time <= 20200921235959 then %>
									<li><a href="/brand/eventList.asp" style="background:url('/images/main/main_banner_20200921.jpg') no-repeat center top; background-size:cover"></a></li>
								<% End If %>
 -->
		
								<!--<li>
									<% if Session("userIdNo") <> "" then %><a href="/menu/menuList.asp?anc=103" style="background:url('/images/main/mainVisual_20200709.gif') no-repeat center top; background-size:cover"></a>
									<% else %><a href="javascript: void(0)" onclick="openJoin('mobile');"  style="background:url('/images/main/mainVisual_20200709.gif') no-repeat center top; background-size:cover">&nbsp;</a><% end if %>
								</li> -->
								<!-- 
								<li>
									<% if Session("userIdNo") <> "" then %><a href="/brand/eventView.asp?eidx=1169&event=OPEN" style="background:url('/images/main/mainVisual_20200709.gif') no-repeat center top; background-size:cover"></a>
									<% else %><a href="javascript: void(0)" onclick="openJoin('mobile');"  style="background:url('/images/main/mainVisual_200713_1.jpg') no-repeat center top; background-size:cover">&nbsp;</a><% end if %>
								</li>
								<li style="background-image:url('/images/main/bbq_m_main_0507.jpg');"><% if Session("userIdNo") <> "" then %><a href="/menu/menuList.asp?anc=103" target="_self" style="display:block; width:100%; height:100%;">&nbsp;</a><% else %><a href="javascript: void(0)" onclick="openJoin('mobile');" target="_self" style="display:block; width:100%; height:100%;">&nbsp;</a><% end if %></li>
								<li class="" style="background-image:url('/images/main/bbq_main_2020417_02.jpg');"></li> -->
							</ul>
						</div>

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


						<%
							Set bCmd = Server.CreateObject("ADODB.Command")
							With bCmd
								.ActiveConnection = dbconn
								.NamedParameters = True
								.CommandType = adCmdStoredProc
								.CommandText = "bt_main_hit_m_select"
								.Parameters.Append .CreateParameter("@BRAND_CODE", adVarchar, adParamInput, 10, SITE_BRAND_CODE)
								.Parameters.Append .CreateParameter("@top", adVarchar, adParamInput, 10, "10")
								Set bRs = .Execute
							End With
							Set bCmd = Nothing
						%>	

						<div class="main_con">
							<!-- 실시간 인기 -->
							<ul class="main_con_popular">
								<li><img src="/images/main/main_popular_img01.png"> <span>실시간 인기</span></li>
								<li>
									<ul id="main_con_popular_roll" class="main_con_popular_roll">

										<%
											i=1
											If Not (bRs.BOF Or bRs.EOF) Then
												Do While Not bRs.eof 
													hit_title	= bRs("hit_title")
													hit_url	= bRs("hit_url")

													if trim(hit_url) <> "" then 
														hit_title = "<a href='"& hit_url &"'>"& i &". "& hit_title &"</a>"
													end if 
										%>
														<li><%=hit_title%></li>
										<%
													i=i+1
													bRs.MoveNext
												Loop
											End If 
											bRs.close
											Set bRs = Nothing
										%>
									</ul>
								</li>
							</ul>
							<!-- // 실시간 인기 -->


							<ul class="main_con_wrap">
								<li>
									<!-- 전체메뉴 -->
									<script src="/common/js/jquery.touchSwipe.1.6.min.js"></script>
									<script src="/common/js/prrple.slider.js"></script>
									<script src="/common/js/scripts.js"></script>

									<%
										s = 0
										Set bCmd = Server.CreateObject("ADODB.Command")
										With bCmd
											.ActiveConnection = dbconn
											.NamedParameters = True
											.CommandType = adCmdStoredProc
											.CommandText = "bp_main_banner_select_sub_m"
											.Parameters.Append .CreateParameter("@BRAND_CODE", adVarchar, adParamInput, 10, SITE_BRAND_CODE)
											.Parameters.Append .CreateParameter("@MODE", adChar, adParamInput, 1, "W")
											Set bRs = .Execute
										End With
										Set bCmd = Nothing
										If Not (bRs.BOF Or bRs.EOF) Then
											Do While Not bRs.EOF
												MAIN_IMG	= bRs("MAIN_IMG")
												MAIN_TEXT	= bRs("MAIN_TEXT")
												' 모바일쪽은 background-size:cover 이게더 있음
									%>
												<style type="text/css">
													.slide_bg_plus<%=s%> {background:url('<%=SERVER_IMGPATH%>/main/<%=MAIN_IMG%>') no-repeat; background-size:cover}
												</style>
									<% 
											bRs.MoveNext
											s = s + 1
											Loop
										End If 
										bRs.close
										Set bRs = Nothing
									%>

									<div id="sliderh3">
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
															.CommandText = "bp_main_banner_select_sub_m"
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
																' ★★★ 모바일쪽은 background-size:cover 이게더 있음 ★★★
													%>
																<div class="slide slide_bg_plus<%=s%>" onclick="location.href='<%=bRs("link_url")%>' " ><h3><%=MAIN_TEXT%></h3></div>
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
									<!-- // 전체메뉴 -->

									<div class="main_popular" onclick="location.href='/menu/menuList.asp?anc=99999'">
										<h3>사이드메뉴</h3>
										<!--<a href="" class="btn_sidemenu">메뉴보기</a>-->
									</div>
									
								</li>

								<li>
									<ul class="main_order2">
										<li class="clearfix" ><a href="/order/delivery.asp?order_type=D"><span><img src="/images/main/icon_m_order.png"></span> <h3>배달주문</h3></a></li>
										<li> <a href="/order/delivery.asp?order_type=P"><span><img src="/images/main/icon_m_out.png"></span> <h3>포장주문</h3></a></li>
										<li> <a href="/coupon_use.asp"><span><img src="/images/main/icon_m_coupon.png"></span> <h3>쿠폰주문</h3></a></li>
										<!-- <li onclick="javascript:lpOpen('.lp_eCoupon');"><span><img src="/images/main/icon_m_coupon.png"></span> <h3>쿠폰주문</h3></li> -->

										<% If Session("userIdNo") <> "" Then %>
											<li> <a href='/mypage/orderList.asp'><span><img src="/images/main/icon_m_recent.png"></span> <h3>최근주문</h3></a></li>
										<% else %>
											<li><a href="#" onclick="openLogin('mobile');"><span><img src="/images/main/icon_m_recent.png"></span> <h3>최근주문</h3></a></li>
										<% end if %>

										<% if cdate(date) >= cdate("2020-08-03") then %>
											<li><a href="https://service.smartbag.kr:18060/81000/brand_giftshop/BRA200721108465763" target="_blank"><span><img src="/images/main/icon_m_gift.png"></span> <h3>선물하기</h3></a></li>
										<% else %>
											<li> <a href="#" onclick="alert('서비스 준비 중입니다.');worknet.popup.popLogin({});"><span><img src="/images/main/icon_m_gift.png"></span> <h3>선물하기</h3></a></li>
										<% end if %>
									</ul>
									<%If Session("userIdNo") <> "" Then '마케팅 수신동의20210118%>
									<div class="marketing" onclick="location.href='/mypage/set.asp';">마케팅 수신동의</div>
									<%else%>
									<div class="marketing" onclick="openLogin('mobile');">마케팅 수신동의</div>
									<%End if%>
								</li>
							</ul>
						</div>


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




<!-- 실시간 인기 롤링 -->
<script>
	function tick(){
		$('#main_con_popular_roll li:first').slideUp( function () { $(this).appendTo($('#main_con_popular_roll')).slideDown(); });
	}
	setInterval(function(){ tick () }, 4000);
</script>
<!-- // 실시간 인기 롤링 -->