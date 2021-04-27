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

			<!-- Main Menu -->
			<div class="section-wrap">
				<section class="section section_menu ">
				
					<div class="section-body">
					<br><br><br><br>
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
									<li class="swiper-slide" value="M$$<%=cRs("menu_idx")%>$$<%=cRs("menu_option_idx")%>$$<%=cRs("menu_price")%>$$<%=cRs("menu_name")%>$$<%=SERVER_IMGPATH%><%=cRs("thumb_file_path")&cRs("thumb_file_name")%>$$$$<%=cRs("KIND_SEL")%>">
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


		<!-- Back to Top -->
		<a href="#Top" class="btn btn_scrollTop">페이지 상단으로 이동</a>
		<!--// Back to Top -->


	</div>
	<!--// Container -->
	<hr>

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
