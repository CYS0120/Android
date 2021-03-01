<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<meta name="Keywords" content="전체메뉴, BBQ치킨">
<meta name="Description" content="전체메뉴">
<title>전체메뉴 | BBQ치킨</title>
<link rel="stylesheet" href="/common/css/main.css">
<link rel="stylesheet" href="/common/css/animate.css">
<link rel="stylesheet" href="/common/css/mscrollbar.css">
<script src="/common/js/libs/jquery.bxslider.js"></script>
<script src="/common/js/libs/mscrollbar.js"></script>
<script>
	var cartPage = "menu";
jQuery(document).ready(function(e) {
	
	$(window).on('scroll',function(e){
		if ($(window).scrollTop() > 0) {
			$(".wrapper").addClass("scrolled");
		} else {
			$(".wrapper").removeClass("scrolled");
		}
	});

	// scrollbar
	$(".mCustomScrollbar").mCustomScrollbar({
		horizontalScroll:false,
		theme:"light",
		mouseWheelPixels:300,
		advanced:{
			updateOnContentResize: true
		}
	});
/*
	$(document).on('click','.btn_menu_cart',function(){
		$('.cart-fix').addClass('on');
		$('.menu-cart').slideDown(500);
	});

	$(document).on('click','.menu-close',function(){
		$('.cart-fix').removeClass('on');
		$('.menu-cart').slideUp(500);
	});
*/
});
</script>
</head>
<%
	Dim category_idx : category_idx = GetReqNum("cidx",0)
	Dim category_name : category_name = GetReqStr("cname","전체메뉴")
	Dim menu_idx : menu_idx = GetReqNum("midx",0)
	Dim opt_idx : opt_idx = GetReqNum("oidx",0)

	If menu_idx = 0 Then
%>
	<script type="text/javascript">
		alert("메뉴가 없습니다.");
		location.href = "/main.asp";
	</script>
<%
		Response.End
	End If

	Dim aCmd, aRs

	Set aCmd = Server.CreateObject("ADODB.Command")

	With aCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_menu_select"

		.Parameters.Append .CreateParameter("@menu_idx", adInteger, adParamInput, , menu_idx)
		.Parameters.Append .CreateParameter("@mode", adVarChar, adParamInput, 10, "ONE")

		Set aRs = .Execute
	End With
	Set aCmd = Nothing

	Dim vMenuIdx, vMenuTitle, vMenuName, vMenuNameE, vMenuPrice, vNutrient, vOrigin
	If Not (aRs.BOF Or aRs.EOF) Then
		vMenuIdx = aRs("menu_idx")
		vMenuTitle = aRs("menu_title")
		vMenuName = aRs("menu_name")
		vMenuNameE = aRs("menu_name_e")
		vMenuPrice = aRs("menu_price")
		vNutrient = Split(aRs("nutrient"),"/")
		vOrigin = aRs("origin")
		vMainFilePath = aRs("main_file_path")
		vMainFileName = aRs("main_file_name")
	Else
%>
	<script type="text/javascript">
		alert("해당하는 메뉴가 없습니다.");
		history.back();
	</script>
<%
		Response.End
	End If

	Dim menuKey : menuKey = "M_"&vMenuIdx&"_"&opt_idx
	Dim menuItem : menuItem = "M$$"&vMenuIdx&"$$"&opt_idx&"$$"&vMenuPrice&"$$"&vMenuName&"$$"&vMainFilePath&vMainFileName
%>
<script type="text/javascript">var current_menu_key = "<%=menuKey%>";</script>
<body>	
<div class="wrapper">
	<!-- Header -->
	<!--#include virtual="/includes/header.asp"-->
	<!--// Header -->
	<hr>
	
	<!-- Container -->
	<div class="container">
		<!-- BreadCrumb -->
		<!--#include virtual="/includes/breadcrumb.asp"-->
		<!--// BreadCrumb -->
		
		<!-- Content -->
		<article class="content content-wide2">
			<section class="section">

				<!-- 메뉴 보기 -->
				<div class="menu-viewTop" style="background-image:url(/images/menu/menu_bbq1.jpg);">
					<div class="inner">
						<div class="info">
							<h3><%=vMenuName%></h3>
							<dl class="nut">
								<dt>영양정보</dt>
								<dd>
									<ul>
										<li class="circle1">
											<span>
												<strong>열량</strong>
												<em>(kcal)</em>
											</span>
											<p><%=vNutrient(0)%></p>
										</li>
										<li class="circle2">
											<span>
												<strong>당류</strong>
												<em>(g)</em>
											</span>
											<p><%=vNutrient(1)%></p>
										</li>
										<li class="circle3">
											<span>
												<strong>단백질</strong>
												<em>(g)</em>
											</span>
											<p><%=vNutrient(2)%></p>
										</li>
										<li class="circle4">
											<span>
												<strong>포화지방</strong>
												<em>(g)</em>
											</span>
											<p><%=vNutrient(3)%></p>
										</li>
										<li class="circle5">
											<span>
												<strong>나트륨</strong>
												<em>(mg)</em>
											</span>
											<p><%=vNutrient(4)%></p>
										</li>
									</ul>
								</dd>
							</dl>
							<ul class="alert">
								<li>원산지 닭고기 : 국내산</li>
								<li>100g 당 함량 기준으로 표기</li>
							</ul>
							<div class="caution">
								매장별로 가격이 상이 할 수 있습니다.<br/>
								매장방문 식사시 가격이 상이 할 수 있습니다.<br/>
								사진은 실제 상품과 다를 수 있습니다.
							</div>
						</div>

						<div class="mov">
							<iframe width="1196" height="635" src="https://www.youtube.com/embed/Rav1b8PncxQ?rel=0&amp;controls=0&amp;showinfo=0&amp;autoplay=0&amp;volumn=0&amp;mute=1"  title="BBQ CF" allowfullscreen></iframe>
						</div>
					</div>
				</div>

				<div class="menu-viewBot">

					<div class="box">
						<div class="tit">
							<p class="img"><img src="/images/menu/ico_menuViewTit1.gif" alt=""></p>
							<p class="txt">맛의 클래스가 다르다.</p>
							<p class="title">#저크소스</p>
						</div>
						<div class="cenimg"><img src="/images/menu/menu_img1.jpg" alt=""></div>
					</div>

					<div class="box">
						<div class="tit">
							<p class="img"><img src="/images/menu/ico_menuViewTit2.gif" alt=""></p>
							<p class="txt">자메이카 300년 전통, 우사인볼트도 반한</p>
							<p class="title">저크소스의 새롭고 진한 풍미</p>
						</div>
						<div class="cenimg"><img src="/images/menu/menu_img2.jpg" alt=""></div>
						<dl class="info_dl">
							<dt>영국 BBC가 선정한 죽기 전 꼭 먹어보아야 할 50가지 음식 중 하나</dt>
							<dd>
								300년 전통의 오리지널 저크소스를 듬뿍 발라 맛있게 구운 후,<br/>
								다시 한번 더 발라서 더욱 깊은 저크소스의 풍미를 즐길 수 있는 자메이카풍의 별미 요리
							</dd>
						</dl>
					</div>

					<div class="box">
						<div class="tit">
							<p class="img"><img src="/images/menu/ico_menuViewTit3.gif" alt=""></p>
							<p class="txt">큼직하면서도 쫄깃한, 그리고 건강하게 매콤한</p>
							<p class="title">자메이카 통다리구이</p>
						</div>
						<div class="cenimg"><img src="/images/menu/menu_img3.jpg" alt=""></div>
						<dl class="info_dl">
							<dt>경고</dt>
							<dd>
								항산화 능력이 뛰어난 고추, 올스파이스, 참깨, 생강 등이 다량 함유되어, 과다섭취 시 몰라보게 어려 보일 수도 있음
							</dd>
						</dl>
					</div>

					<div class="box">
						<div class="tit">
							<p class="img"><img src="/images/menu/ico_menuViewTit4.gif" alt=""></p>
							<p class="txt">Great taste, eat Fresh</p>
							<p class="title">엑스트라 버진 올리브유</p>
						</div>
						<div class="cenimg"><img src="/images/menu/menu_img4.jpg" alt=""></div>
						<dl class="info_dl">
							<dt>세상에서 가장 맛있고 건강한 치킨만을 제공하겠다는 BBQ의 건강한 고집!</dt>
							<dd>
								BBQ는 올리브오일 중에 최상급인 100% 엑스트라 버진 올리브오일을 원료로 사용하는 올리브오일만을 사용합니다.
							</dd>
						</dl>
					</div>

				</div>
				<!-- //메뉴 보기 -->

				<!-- 메뉴 담기 -->
				<div class="menu-cart">
					<div class="inner">
						<div class="left mCustomScrollbar">

							<div class="in-sec">

<%
	Set aCmd = Server.CreateObject("ADODB.Command")

	With aCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_sidemenu_select"

		Set aRs = .Execute
	End With

	Set aCmd = Nothing

	category_name = ""

	If Not (aRs.BOF Or aRs.EOF) Then
		aRs.MoveFirst
		Do Until aRs.EOF
			If aRs("category_name") <> category_name Then
				If category_name <> "" Then
%>

									</div>
								</div>
<%
				End If
%>
								<div class="wrap">
									<h3><%=aRs("category_name")%></h3>
									<div class="area">
<%
				category_name = aRs("category_name")
			End If
%>								

										<div class="box">
											<div class="img">
												<label class="ui-checkbox" id="S_<%=aRs("menu_idx")%>_0" onclick="javascript:toggleCartSide('<%=menuKey%>', 'S$$<%=aRs("menu_idx")%>$$0$$<%=aRs("menu_price")%>$$<%=aRs("menu_name")%>$$');">
													<input type="checkbox">
													<span></span>
												</label>
												<img src="http://placehold.it/88x88"/>
											</div>
											<div class="info">
												<p class="name"><%=aRs("menu_name")%></p>
												<p class="pay"><%=FormatNumber(aRs("menu_price"),0)%>원</p>
											</div>
										</div>


<%
			aRs.MoveNext
		Loop
%>
									</div>
								</div>
							
<%
	End If

	Set aRs = Nothing
%>								
							</div>			
						</div>
						<div class="right">
							<div class="addmenu mCustomScrollbar">
								<!-- <dl>
									<dt>자메이카 통다리 구이</dt>
									<dd>
										<span class="form-pm">
											<button type="button" class="minus">-</button>
											<input type="text" value="1">
											<button type="button" class="plus">+</button>
										</span>
										<div class="mon">19,500원</div>
									</dd>
								</dl>
								<dl>
									<dt>콜라 355ml</dt>
									<dd>
										<span class="form-pm">
											<button type="button" class="minus">-</button>
											<input type="text" value="1">
											<button type="button" class="plus">+</button>
										</span>
										<div class="mon">1,500원</div>
									</dd>
								</dl>
								<dl>
									<dt>콜라 355ml</dt>
									<dd>
										<span class="form-pm">
											<button type="button" class="minus">-</button>
											<input type="text" value="1">
											<button type="button" class="plus">+</button>
										</span>
										<div class="mon">1,500원</div>
									</dd>
								</dl>
								<dl>
									<dt>콜라 355ml</dt>
									<dd>
										<span class="form-pm">
											<button type="button" class="minus">-</button>
											<input type="text" value="1">
											<button type="button" class="plus">+</button>
										</span>
										<div class="mon">1,500원</div>
									</dd>
								</dl>
								<dl>
									<dt>콜라 355ml</dt>
									<dd>
										<span class="form-pm">
											<button type="button" class="minus">-</button>
											<input type="text" value="1">
											<button type="button" class="plus">+</button>
										</span>
										<div class="mon">1,500원</div>
									</dd>
								</dl>
								<dl>
									<dt>콜라 355ml</dt>
									<dd>
										<span class="form-pm">
											<button type="button" class="minus">-</button>
											<input type="text" value="1">
											<button type="button" class="plus">+</button>
										</span>
										<div class="mon">1,500원</div>
									</dd>
								</dl>
								<dl>
									<dt>콜라 355ml</dt>
									<dd>
										<span class="form-pm">
											<button type="button" class="minus">-</button>
											<input type="text" value="1">
											<button type="button" class="plus">+</button>
										</span>
										<div class="mon">1,500원</div>
									</dd>
								</dl> -->
							</div>
							<div class="calc">
								<div class="top">
									<dl>
										<dt>주문금액</dt>
										<dd id="item_amount">0원</dd>
									</dl>
									<dl>
										<dt>추가금액</dt>
										<dd id="side_amount">0원</dd>
									</dl>
								</div>
								<div class="bot">
									<dl>
										<dt>결제금액</dt>
										<dd id="pay_amount">0원</dd>
									</dl>
								</div>
							</div>
						</div>
					</div>
					<button type="button" class="menu-close" onclick="javascript:closeCart();">닫기</button>
				</div>
				<!-- //메뉴 담기 -->

				<!-- 장바구니 담기 -->
				<div class="cart-fix">
					<div class="inner ta-r">
						<button type="button" class="btn btn-lg btn-red btn_menu_cart" onClick="javascript:openCart();addCartMenu('<%=menuItem%>');">장바구니 담기</button>
					</div>
				</div>
				<!-- //장바구니 담기 -->

			</section>
		</article>
		<!--// Content -->
		
		<!-- QuickMenu -->
		<!--#include virtual="/includes/quickmenu.asp"-->
		<!-- QuickMenu -->

	</div>
	<!--// Container -->
	<hr>
	
	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
</div>
</body>
</html>
