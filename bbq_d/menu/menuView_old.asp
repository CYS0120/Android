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

	Dim bCmd, bMenuRs

	Set bCmd = Server.CreateObject("ADODB.Command")
	With bCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_menu_List"
		.Parameters.Append .CreateParameter("@ListType", adVarChar, adParamInput, 5, "ONE")
		.Parameters.Append .CreateParameter("@menu_idx", adInteger, adParamInput, , menu_idx)
		.Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)
		.Parameters.Append .CreateParameter("@BRAND_CODE", adVarchar, adParamInput, 5, SITE_BRAND_CODE)
		Set bMenuRs = .Execute
	End With
	Set bCmd = Nothing			
	If bMenuRs.BOF Or bMenuRs.EOF Then
%>
	<script type="text/javascript">
		showAlertMsg({msg:"존재하지 않는 메뉴입니다.", ok: function(){
			history.back();
		}});
	</script>
<%
		Response.End
	End If 

	Dim vMenuIdx, vMenuTitle, vMenuName, vMenuNameE, vMenuPrice, vNutrient, vOrigin
	If Not (bMenuRs.BOF Or bMenuRs.EOF) Then

		vMenuIdx	= bMenuRs("menu_idx")
		vMenuTitle	= bMenuRs("menu_title")
		vMenuName	= bMenuRs("menu_name")	'	메뉴명_국문
		vMenuPrice	= bMenuRs("menu_price")
		menu_desc	= bMenuRs("menu_desc")	'	메뉴설명
		kind_sel	= bMenuRs("kind_sel")	'	분류선택
		origin	= bMenuRs("origin")	'	원산지
		calorie	= bMenuRs("calorie")	'	열량
		sugars	= bMenuRs("sugars")	'	당류g
		protein	= bMenuRs("protein")	'	단백질
		saturatedfat	= bMenuRs("saturatedfat")	'	포화지방
		natrium	= bMenuRs("natrium")	'	나트륨
		exp1_yn	= bMenuRs("exp1_yn")	'	1차설명 사용여부
		exp1_url	= bMenuRs("exp1_url")	'	YouTube Url
		exp2_yn	= bMenuRs("exp2_yn")	'	2차설명 사용여부 Y,N
		exp2_imgurl	= bMenuRs("exp2_imgurl")	'	배경이미지
		exp3_yn	= bMenuRs("exp3_yn")	'	3차설명 사용여부 Y,N
		exp3_imgurl	= bMenuRs("exp3_imgurl")	'	배경이미지
		exp4_yn	= bMenuRs("exp4_yn")	'	4차설명 사용여부 Y,N
		exp4_imgurl	= bMenuRs("exp4_imgurl")	'	배경이미지
		exp5_yn	= bMenuRs("exp5_yn")	'	5차설명 사용여부 Y,N
		exp5_imgurl	= bMenuRs("exp5_imgurl")	'	배경이미지
		MAIN_FILEPATH	= bMenuRs("MAIN_FILEPATH")	'
		MAIN_FILENAME	= bMenuRs("MAIN_FILENAME")	'
		THUMB_FILEPATH	= bMenuRs("THUMB_FILEPATH")	'
		THUMB_FILENAME	= bMenuRs("THUMB_FILENAME")	'
		MOBILE_FILEPATH	= bMenuRs("MOBILE_FILEPATH")	'
		MOBILE_FILENAME	= bMenuRs("MOBILE_FILENAME")	'
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
				,<!--<div class="menu-viewTop" style="background-image:url(<%=MAIN_FILEPATH%><%=MAIN_FILENAME%>);">-->
				<div class="menu-viewTop" style="margin-top:-16px;">
					<div class="inner">
						<div class="bg_img01"><img src="/images/main/img_etc01.png" alt=""></div>
						<div class="bg_img02"><img src="/images/main/img_etc02.png" alt=""></div>
						<div class="bg_img03"><img src="/images/main/img_etc03.png" alt=""></div>
						<div class="bg_img04"><img src="/images/main/img_etc04.png" alt=""></div>											
						<!--상품이미지 넣는곳-->
						<div class="menu_detail_img"><img src="/menu_images/pc/gold_olive_chicken_01.png" alt="자메이카 통다리 구이" class="jackInTheBox"></div>
						<!--//상품이미지 넣는곳-->
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
											<p><%=calorie%></p>
										</li>
										<li class="circle2">
											<span>
												<strong>당류</strong>
												<em>(g)</em>
											</span>
											<p><%=sugars%></p>
										</li>
										<li class="circle3">
											<span>
												<strong>단백질</strong>
												<em>(g)</em>
											</span>
											<p><%=protein%></p>
										</li>
										<li class="circle4">
											<span>
												<strong>포화지방</strong>
												<em>(g)</em>
											</span>
											<p><%=saturatedfat%></p>
										</li>
										<li class="circle5">
											<span>
												<strong>나트륨</strong>
												<em>(mg)</em>
											</span>
											<p><%=natrium%></p>
										</li>
									</ul>
								</dd>
							</dl>
							<ul class="alert">
								<li>원산지 닭고기 : <%=origin%></li>
								<li>100g 당 함량 기준으로 표기</li>
							</ul>
							<div class="caution">
								매장별로 가격이 상이 할 수 있습니다.<br/>
								매장방문 식사시 가격이 상이 할 수 있습니다.<br/>
								사진은 실제 상품과 다를 수 있습니다.
							</div>

                            <a href="#" class="allergy" onclick="javascript:lpOpen('.lp_allergy');">알레르기 정보</a>							
						</div>
						<!--동영상 삽입-->
<%		If exp1_yn = "Y" Then %>
						<div class="mov">
							<iframe style="padding-top:80px;" width="1196" height="635" src="https://www.youtube.com/embed/<%=exp1_url%>?rel=0&amp;controls=0&amp;showinfo=0&amp;autoplay=0&amp;volumn=0&amp;mute=1"  title="BBQ CF" allowfullscreen></iframe>
						</div>
<%		End If %>
						<!--//동영상 삽입-->
					</div>
				</div>

				<div class="menu-viewBot">
					<!--1번 사진 삽입-->
<%		If exp2_yn = "Y" Then %>
					<div class="box">
						<div class="box_content">
							<h2 class="tit"></h2>
							<p class="sub_tit"></p>
						</div>
						<div class="cenimg"><img src="/menu_images/explan/<%=exp2_imgurl%>" alt="" style="width:1920px;"></div>
					</div>
<%		End If %>
					<!--//1번 사진 삽입-->
					<!--2번 사진 삽입-->
<%		If exp3_yn = "Y" Then %>
					<div class="box">
						<div class="box_content">
							<h2 class="tit"></h2>
							<p class="sub_tit"></p>
						</div>
						<div class="cenimg"><img src="/menu_images/explan/<%=exp3_imgurl%>" alt="" style="width:1920px;"></div>
					</div>
<%		End If %>
					<!--//2번 사진 삽입-->
					<!--3번 사진 삽입-->
<%		If exp4_yn = "Y" Then %>
					<div class="box">
						<div class="box_content">
							<h2 class="tit"></h2>
							<p class="sub_tit"></p>
						</div>
						<div class="cenimg"><img src="/images/menu/menu_img2.jpg" alt="" style="width:1920px;"></div>
					</div>
<%		End If %>
					<!--//3번 사진 삽입-->
					<!--4번 사진 삽입-->
<%		If exp5_yn = "Y" Then %>
					<div class="box">
						<div class="box_content">
							<h2 class="tit"></h2>
							<p class="sub_tit"></p>
						</div>
						<div class="cenimg"><img src="/images/menu/menu_img1.jpg" alt="" style="width:1920px;"></div>
					</div>
<%		End If %>
					<!--//4번 사진 삽입-->
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
							<div class="addmenu mCustomScrollbar"></div>
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



            <!-- Layer Popup : Allergy Secssion -->
            <div id="lp_allergy" class="lp-wrapper lp_allergy">
                <!-- LP Wrap -->
                <div class="lp-wrap">
                    <div class="lp-con">
                        <!-- LP Header -->
                        <div class="lp-header">
                            <h2>알레르기 유발재료</h2>
                        </div>
                        <!--// LP Header -->
                        <!-- LP Container -->
                        <div class="lp-container">
                            <!-- LP Content -->
                            <div class="lp-content">

                                <div class="tit">
                                    <select name="" id="">
                                        <option value="">BBQ치킨</option>
                                    </select>
                                </div>

                                <div class="ovy">
                                    <table class="__tbl-list">
                                        <caption>알레르기 유발재료</caption>
                                        <thead>
                                            <tr>
                                                <th scope="col">분류</th>
                                                <th scope="col">메뉴명</th>
                                                <th scope="col">알레르기 유발재료</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td class="cate">다양하게 양념</td>
                                                <td class="menu_name">골뱅이치킨</td>
                                                <td class="menu_material">밀</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">다양하게 양념</td>
                                                <td class="menu_name">골뱅이치킨(매콤화끈한맛)</td>
                                                <td class="menu_material">밀</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">다양하게 양념</td>
                                                <td class="menu_name">극한왕갈비치킨</td>
                                                <td class="menu_material">대두, 밀, 조개류(굴), 아황산류</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">다양하게 양념</td>
                                                <td class="menu_name">레드써프라이드</td>
                                                <td class="menu_material">우유, 대두, 밀, 계란, 닭고기, 조개류(굴), 쇠고기, 돼지고기, 땅콩</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">다양하게 양념</td>
                                                <td class="menu_name">마라핫치킨(순살)</td>
                                                <td class="menu_material">우유, 대두, 밀, 조개류(굴), 쇠고기, 새우, 땅콩</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">다양하게 양념</td>
                                                <td class="menu_name">마라핫치킨(윙)</td>
                                                <td class="menu_material">우유, 대두, 밀, 조개류(굴), 쇠고기, 새우, 땅콩</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">다양하게 양념</td>
                                                <td class="menu_name">마라핫치킨(한마리)</td>
                                                <td class="menu_material">우유, 대두, 밀, 조개류(굴), 쇠고기, 새우, 땅콩</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">구워먹는 비비큐</td>
                                                <td class="menu_name">매달구</td>
                                                <td class="menu_material">우유, 대두, 밀, 닭고기, 토마토, 쇠고기, 돼지고기, 땅콩</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">순수하게 후라이드</td>
                                                <td class="menu_name">바삭칸치킨</td>
                                                <td class="menu_material">대두, 밀, 계란, 새우</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">다양하게 양념</td>
                                                <td class="menu_name">빠리치킨(윙)</td>
                                                <td class="menu_material">우유, 대두, 밀</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">버라이어티한 비비큐</td>
                                                <td class="menu_name">빠리치킨(한마리)</td>
                                                <td class="menu_material">우유, 대두, 밀</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">다양하게 양념</td>
                                                <td class="menu_name">소이갈릭스</td>
                                                <td class="menu_material">대두, 밀, 쇠고기</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">다양하게 양념</td>
                                                <td class="menu_name">소이갈릭스(윙)</td>
                                                <td class="menu_material">대두, 밀, 쇠고기</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">순수하게 후라이드</td>
                                                <td class="menu_name">순살바삭칸</td>
                                                <td class="menu_material">대두, 밀, 계란, 새우</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">순수하게 후라이드</td>
                                                <td class="menu_name">순살치즐링</td>
                                                <td class="menu_material">우유, 대두, 밀, 계란, 조개류(굴), 쇠고기, 새우, 땅콩</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">순수하게 후라이드</td>
                                                <td class="menu_name">순살크래커</td>
                                                <td class="menu_material">우유, 대두, 밀, 닭고기, 조개류(굴)</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">구워먹는 비비큐</td>
                                                <td class="menu_name">스모크치킨</td>
                                                <td class="menu_material">대두, 밀, 계란, 닭고기</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">다양하게 양념 </td>
                                                <td class="menu_name">시크릿양념치킨</td>
                                                <td class="menu_material">대두, 밀, 닭고기, 토마토, 땅콩, 아황산류</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">다양하게 양념</td>
                                                <td class="menu_name">써프라이드</td>
                                                <td class="menu_material">우유, 대두, 밀, 계랸, 닭고기, 조개류(굴)</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">구워먹는 비비큐</td>
                                                <td class="menu_name">자메이카통다리구이</td>
                                                <td class="menu_material">대두, 밀, 닭고기, 토마토, 쇠고기</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">다양하게 양념</td>
                                                <td class="menu_name">치즐링</td>
                                                <td class="menu_material">우유, 대두, 밀, 계란, 조개류(굴), 쇠고기, 새우, 땅콩</td>
                                            </tr>
											                                            <tr>
                                                <td class="cate">다양하게 양념</td>
                                                <td class="menu_name">치킨강정</td>
                                                <td class="menu_material">대두, 밀, 계란, 닭고기, 토마토, 새우, 땅콩, 아황산류</td>
                                            </tr>
											                                            <tr>
                                                <td class="cate">다양하게 양념</td>
                                                <td class="menu_name">크림치즈볼</td>
                                                <td class="menu_material">밀, 대두, 우유</td>
                                            </tr>
											                                            <tr>
                                                <td class="cate">다양하게 양념</td>
                                                <td class="menu_name">허니갈릭스</td>
                                                <td class="menu_material">대두, 밀, 쇠고기</td>
                                            </tr>
											                                            <tr>
                                                <td class="cate">다양하게 양념</td>
                                                <td class="menu_name">허니갈릭스(윙)</td>
                                                <td class="menu_material">대두, 밀, 쇠고기</td>
                                            </tr>
											                                            <tr>
                                                <td class="cate">다양하게 양념</td>
                                                <td class="menu_name">허니버터갈릭치킨</td>
                                                <td class="menu_material">우유, 대두, 밀, 쇠고기</td>
                                            </tr>
											                                            <tr>
                                                <td class="cate">순수하게 후라이드</td>
                                                <td class="menu_name">황금올리브닭다리</td>
                                                <td class="menu_material">우유, 대두, 밀, 조개류(굴), 쇠고기, 새우, 땅콩</td>
                                            </tr>
											                                            <tr>
                                                <td class="cate">순수하게 후라이드</td>
                                                <td class="menu_name">황금올리브닭다리(양념)</td>
                                                <td class="menu_material">대두, 밀, 닭고기, 토마토, 땅콩, 아황산류</td>
                                            </tr>
											                                            <tr>
                                                <td class="cate">순수하게 후라이드</td>
                                                <td class="menu_name">황금올리브속안심</td>
                                                <td class="menu_material">우유, 대두, 밀, 쇠고기, 새우, 땅콩</td>
                                            </tr>
											                                            <tr>
                                                <td class="cate">순수하게 후라이드</td>
                                                <td class="menu_name">황금올리브치킨</td>
                                                <td class="menu_material">우유, 대두, 밀, 조개류(굴), 쇠고기, 새우, 땅콩</td>
                                            </tr>
											                                            <tr>
                                                <td class="cate">순수하게 후라이드</td>
                                                <td class="menu_name">황금올리브핫윙</td>
                                                <td class="menu_material">우유, 대두, 밀, 계란, 새우, 땅콩</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <!--// LP Content -->
                        </div>
                        <!--// LP Container -->
                        <button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>
                    </div>
                </div>
                <!--// LP Wrap -->
            </div>
            <!--// Layer Popup -->
			
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
