<!--#include virtual="/api/include/utf8.asp"-->
<% Call DBOpen %>
<!doctype html>
<html lang="ko">
<head>
<% Dim FB_script : FB_script = "fbq('track', 'ViewContent');" %>
<% Dim kakao_script : kakao_script = " kakaoPixel('1188504223027052596').viewContent({ id: '"& menu_idx &"' }); " %>
<!--#include virtual="/includes/top.asp"-->
<meta name="Keywords" content="메뉴소개, BBQ치킨">
<meta name="Description" content="메뉴소개">
<title>메뉴소개 | BBQ치킨</title>
<script>
var cartPage = "menu";

$(function(){
	getView();
});
</script>
</head>
<%
	Dim menu_idx : menu_idx = Request("midx")
	Dim opt_idx : opt_idx = Request("oidx")

	If IsEmpty(menu_idx) Or IsNull(menu_idx) Or Trim(menu_idx) = "" Or Not IsNumeric(menu_idx) Then menu_idx = 0
	If IsEmpty(opt_idx) Or IsNull(opt_idx) Or Trim(opt_idx) = "" Or Not IsNumeric(opt_idx) Then opt_idx = 0

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

	Dim vMenuIdx, vMenuTitle, vMenuType, vMenuName, vMenuNameE, vMenuPrice, vNutrient, vOrigin
	vMenuIdx	= bMenuRs("menu_idx")
	vMenuTitle	= bMenuRs("menu_title")
	vMenuType = bMenuRs("menu_type")
	vMenuName	= bMenuRs("menu_name")	'	메뉴명_국문
	vMenuPrice	= bMenuRs("menu_price")
	menu_desc	= bMenuRs("menu_desc")	'	메뉴설명
	kind_sel	= bMenuRs("kind_sel")	'	분류선택
	vOrigin		= bMenuRs("origin")	'	원산지
	vcalorie	= bMenuRs("calorie")	'	열량
	vsugars	= bMenuRs("sugars")	'	당류g
	vprotein	= bMenuRs("protein")	'	단백질
	vsaturatedfat	= bMenuRs("saturatedfat")	'	포화지방
	vnatrium	= bMenuRs("natrium")	'	나트륨
	allergy	= bMenuRs("allergy")	'	알레르기정보
	vexp1_yn	= bMenuRs("exp1_yn")	'	1차설명 사용여부
	vexp1_url	= bMenuRs("exp1_url")	'	YouTube Url
	vexp2_yn	= bMenuRs("exp2_yn")	'	2차설명 사용여부 Y,N
	vexp2_imgurl	= bMenuRs("exp2_imgurl")	'	배경이미지
	vexp3_yn	= bMenuRs("exp3_yn")	'	3차설명 사용여부 Y,N
	vexp3_imgurl	= bMenuRs("exp3_imgurl")	'	배경이미지
	vexp4_yn	= bMenuRs("exp4_yn")	'	4차설명 사용여부 Y,N
	vexp4_imgurl	= bMenuRs("exp4_imgurl")	'	배경이미지
	vexp5_yn	= bMenuRs("exp5_yn")	'	5차설명 사용여부 Y,N
	vexp5_imgurl	= bMenuRs("exp5_imgurl")	'	배경이미지
	MAIN_FILEPATH	= bMenuRs("MAIN_FILEPATH")	'
	MAIN_FILENAME	= bMenuRs("MAIN_FILENAME")	'
	vMainFilePath	= bMenuRs("THUMB_FILEPATH")	'
	vMainFileName	= bMenuRs("THUMB_FILENAME")	'
	vMainFilePath	= bMenuRs("MOBILE_FILEPATH")	'
	vMainFileName	= bMenuRs("MOBILE_FILENAME")	'

	add_price	= bMenuRs("add_price")
	vMenu_type	= bMenuRs("menu_type")	'
	vKind_sel	= bMenuRs("kind_sel")	'

	dim vMenuType_plus
	if vMenuType = "B" then ' B : 일반메뉴(M으로 변경해야됨) / S : 사이드메뉴
		vMenuType_plus = "M"
	else
		vMenuType_plus = vMenuType
	end if 

	Dim menuKey : menuKey = vMenuType_plus &"_"& vMenuIdx &"_"& opt_idx
	Dim menuItem : menuItem = vMenuType_plus &"$$"& vMenuIdx &"$$"& opt_idx &"$$"& vMenuPrice &"$$"& vMenuName &"$$"& SERVER_IMGPATH&vMainFilePath&vMainFileName
	Dim ta_img_url : ta_img_url = SERVER_IMGPATH & vMainFilePath & vMainFileName
%>
<script type="text/javascript">var current_menu_key = "<%=menuKey%>";</script>
<body>
<div class="wrapper">
	<%
		PageTitle = vMenuName
		PageTitle = "메뉴"
	%>
	<!--#include virtual="/includes/header.asp"-->

	<!-- Container -->
	<div class="container">

		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
			
		<!-- Content -->
		<article class="content inbox1000_2">

			<!-- 메뉴 보기 -->
			<div class="menu-viewTop">
				<!-- <div><img src="<%=SERVER_IMGPATH%><%=MAIN_FILEPATH%><%=MAIN_FILENAME%>" alt="<%=vMenuName%>" ></div> -->
				<div><img src="<%=SERVER_IMGPATH%><%=vMainFilePath%><%=vMainFileName%>" alt="<%=vMenuName%>" ></div>

				<div class="info inbox1000">
					<div class="info_con1">
						<h3><%=vMenuName%></h3>
						<div class="item_num">
							<span class="form-pm">
								<button class="minus" onclick="control_menu_qty(-1);" type="button">-</button>
								<input id="new_qty_<%=menuKey%>" type="text" value="1" readonly />
								<button class="plus" onclick="control_menu_qty(1);" type="button">+</button>
							</span>
						</div>
					</div>
					<div class="info_point"><%=vMenuTitle%></div>
					<div class="info_origin">
						<h3>[ 원산지 ]</h3>
						<p><%=vOrigin%></p>
					</div>
					<%If add_price > 0 Then '2020-08-25 추가%>
					<div class="info_origin">
						<p style="color:red">제주도 및 도서지역은 <%=FormatNumber(add_price, 0)%>원이 추가됩니다</p>
					</div>
					<%End if%>

					<ul class="pay_total">
						<li>가격</li>
						<li><span id="pay_amount_new"><%=FormatNumber(vMenuPrice, 0)%>원</span></li>
					</ul>

					<!-- 추천메뉴:functions.js -->
					<div id="recom_div" class="recom"></div>
					<!-- 추천메뉴 -->

					<div class="menuList_btn clearfix" style="position:unset;margin-top:20px">
						<button type="button" class="btn btn_list_cart btn_newImg" style="height:40px;font-size:15px;" onClick="goCart();">장바구니 담기</button>
						<button type="button" id="btn_order" class="btn btn_list_order btn_newImg" style="height:40px;font-size:15px;"onClick="goOrder();">주문하기</button>
					</div>
					<div id="asdf"></div>

				</div>
			</div>

			<div id="payment_info_div">
				<input type="hidden" name="menuKey" id="menuKey" value="<%=menuKey%>">
				<input type="hidden" name="menuItem" id="menuItem" value="<%=menuItem%>">
				<input type="hidden" name="vMenuPrice" id="vMenuPrice" value="<%=vMenuPrice%>">

				<div id="payment_info_side_div">
				</div>
			</div>

			<!-- 메뉴 상세정보
			<ul class="menuInfo_wrap">
				<li>
					<h3>영양 및 중량 정보 보기</h3>
					<ul class="nutrition">
						<li><span>열량<br>(kcal)</span><p><%=vcalorie%></p></li>
						<li><span>당류<br>(g)</span><p><%=vsugars%></p></li>
						<li><span>단백질<br>(g)</span><p><%=vprotein%></p></li>
						<li><span>포화지방<br>(g)</span><p><%=vsaturatedfat%></p></li>
						<li><span>나트륨<br>(mg)</span><p><%=vnatrium%></p></li>
					</ul>
					<p>100g 당 함량 기준으로 표기</p>
				</li>

				<li>
					<h3>알레르기 정보</h3>
					<p><%=allergy%></p>
				</li>

			</ul> -->


			<div class="accordion inbox1000">
				<div class="item">
					<div class="heading">영양 및 중량 정보 보기</div>
					<div class="content">
						<ul class="nutrition">
							<li><span>열량<br>(kcal)</span><p><%=vcalorie%></p></li>
							<li><span>당류<br>(g)</span><p><%=vsugars%></p></li>
							<li><span>단백질<br>(g)</span><p><%=vprotein%></p></li>
							<li><span>포화지방<br>(g)</span><p><%=vsaturatedfat%></p></li>
							<li><span>나트륨<br>(mg)</span><p><%=vnatrium%></p></li>
						</ul>
						<p class="nutrition_bottom">< 100g 당 함량 기준으로 표기 ></p>
					</div>
				</div>
				<div class="item">
					<div class="heading">알레르기 정보</div>
					<p class="content allergy"><%=allergy%></p>
				</div>
			</div>

<!-- <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>  -->

<script>
	$('.accordion .item .heading').click(function() {
			
		var a = $(this).closest('.item');
		var b = $(a).hasClass('open');
		var c = $(a).closest('.accordion').find('.open');
			
		if(b != true) {
			$(c).find('.content').slideUp(200);
			$(c).removeClass('open');
		}

		$(a).toggleClass('open');
		$(a).find('.content').slideToggle(200);

	});
</script>

<script type="text/javascript">
//  var _gaq = _gaq || [];
//  _gaq.push(['_setAccount', 'UA-36251023-1']);
//  _gaq.push(['_setDomainName', 'jqueryscript.net']);
//  _gaq.push(['_trackPageview']);
//
//  (function() {
//    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
//    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
//    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
//  })();
		getMenuRecom();
</script>











			<!-- // 메뉴 상세정보 -->

		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

	<!--#include virtual="/api/ta/product.asp"-->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->

<% Call DBClose %>