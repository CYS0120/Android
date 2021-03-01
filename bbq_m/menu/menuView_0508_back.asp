<!--#include virtual="/api/include/utf8.asp"-->
<% Call DBOpen %>
<!doctype html>
<html lang="ko">
<head>
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
'	MAIN_FILEPATH	= bMenuRs("MAIN_FILEPATH")	'
'	MAIN_FILENAME	= bMenuRs("MAIN_FILENAME")	'
	vMainFilePath	= bMenuRs("THUMB_FILEPATH")	'
	vMainFileName	= bMenuRs("THUMB_FILENAME")	'
'	vMainFilePath	= bMenuRs("MOBILE_FILEPATH")	'
'	vMainFileName	= bMenuRs("MOBILE_FILENAME")	'

	Dim menuKey : menuKey = "M_"&vMenuIdx&"_"&opt_idx
	Dim menuItem : menuItem = "M$$"&vMenuIdx&"$$"&opt_idx&"$$"&vMenuPrice&"$$"&vMenuName&"$$"&SERVER_IMGPATH&vMainFilePath&vMainFileName
%>
<script type="text/javascript">var current_menu_key = "<%=menuKey%>";</script>
<body>
<div class="wrapper">
<%
	PageTitle = vMenuName
%>
	<!--#include virtual="/includes/header.asp"-->
	<hr>

	<!-- Container -->
	<div class="container">

		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
			
		<!-- Content -->
		<article class="content">

			<!--#include virtual="/includes/step.asp"-->

			<!--#include virtual="/includes/address.asp"-->

			<!-- 메뉴 보기 -->
			<div class="menu-viewTop">
				<div><img src="<%=SERVER_IMGPATH%><%=vMainFilePath%><%=vMainFileName%>" alt="<%=vMenuName%>" ></div>
				<div class="info">
					<h3><%=vMenuName%></h3>
					<div class="info_point"><%=vMenuTitle%></div>
				</div>
			</div>

			<ul class="item_pay">
				<li>가격</li>
				<li><span><%=FormatNumber(vMenuPrice, 0)%></span> 원</li>
			</ul>

			<!-- 메뉴 상세정보 -->
			<ul class="menuInfo_wrap">
				<li>
					<h3>[ 영양정보 ]</h3>
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
					<h3>[ 원산지 ]</h3>
					<p><%=vOrigin%></p>
				</li>

				<li>
					<h3>[ 알레르기 정보 ]</h3>
					<p><%=allergy%></p>
				</li>

				<li class="menuInfo_ex">
					매장별로 가격이 상이 할 수 있습니다.<br>
					매장방문 식사시 가격이 상이 할 수 있습니다.<br>
					사진은 실제 상품과 다를 수 있습니다. 
				</li>
			</ul>
			<!-- // 메뉴 상세정보 -->

			<ul class="item_choice" style="display:none">
				<h3>필수선택</h3>
				<li><input name="" type="radio" id="choice1" value="" /> <label for="choice1">1단계 버닝</label> <span>+ <span>0</span>원</span></li>
				<li><input name="" type="radio" id="choice2" value="" /> <label for="choice2">2단계 블러디</label> <span>+ <span>0</span>원</span></li>
				<li><input name="" type="radio" id="choice3" value="" /> <label for="choice3">3단계 헬게이트</label> <span>+ <span>0</span>원</span></li>
			</ul>



<% if vMenuType <> "S" then  %>
			<ul class="item_choice">
				<h3>사이드 메뉴(옵션)</h3>

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

	Dim category_name : category_name = ""

	If Not (aRs.BOF Or aRs.EOF) Then
		aRs.MoveFirst
		Do Until aRs.EOF
			thumb_file_path = aRs("thumb_file_path")
			thumb_file_name = aRs("thumb_file_name")
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
							<li>
								<!-- <input type="checkbox" id="S_<%=aRs("menu_idx")%>_0" onclick="toggleCartSide('<%=menuKey%>', 'S$$<%=aRs("menu_idx")%>$$0$$<%=aRs("menu_price")%>$$<%=aRs("menu_name")%>$$');" class="side_class"/> -->
								<input type="checkbox" id="S_<%=aRs("menu_idx")%>_0" onclick="add_side_div('<%=aRs("menu_idx")%>');" class="side_class" value="S$$<%=aRs("menu_idx")%>$$0$$<%=aRs("menu_price")%>$$<%=aRs("menu_name")%>$$"/>
								<label for="S_<%=aRs("menu_idx")%>_0"><%=DeleteHTML(aRs("menu_name"))%></label> <span>+ <%=FormatNumber(aRs("menu_price"),0)%>원</span>
							</li>

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
			</ul>
<% end if %>

			<ul class="item_num">
				<li>수량</li>
				<li>
					<span class="form-pm">
						<button class="minus" onclick="control_menu_qty(-1);" type="button">-</button>
						<input id="new_qty_<%=menuKey%>" type="text" value="1" readonly />
						<button class="plus" onclick="control_menu_qty(1);" type="button">+</button>
					</span>
				</li>
			</ul>


			<div id="payment_info_div">
				<input type="hidden" name="menuKey" id="menuKey" value="<%=menuKey%>">
				<input type="hidden" name="menuItem" id="menuItem" value="<%=menuItem%>">
				<input type="hidden" name="vMenuPrice" id="vMenuPrice" value="<%=vMenuPrice%>">

				<div id="payment_info_side_div">
				</div>
			</div>


			<ul class="pay_total">
				<li>전체금액</li>
				<li><span id="pay_amount_new"><%=FormatNumber(vMenuPrice, 0)%>원</span></li>
			</ul>
			<!-- //메뉴 보기 -->

			<div class="menuOrder_btn">
				<button type="button" class="btn btn_cart" onClick="javascript:location.href='/order/cart.asp';"><span class="ico-only">장바구니</span><span class="count" id="cart_item_count"></span></button>
				<button type="button" class="btn btn-gray btn_middle" onClick="goCart();">장바구니 담기</button>
				<a href="javascript: goOrder()" class="btn btn-red btn_middle">바로 주문하기</a>
			</div>
			<div id="asdf"></div>

		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->

<% Call DBClose %>