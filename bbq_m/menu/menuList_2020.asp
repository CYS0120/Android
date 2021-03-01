<!--#include virtual="/api/include/utf8.asp"-->

<% Call DBOpen %>
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<meta name="Keywords" content="메뉴소개, BBQ치킨">
<meta name="Description" content="메뉴소개">
<title>메뉴소개 | BBQ치킨</title>

<script type="text/javascript">
	var cartPage = "";
	function addMenuNGo(data, go) {
		addCartMenu(data);

		if(go) {
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

<%
	category_idx = GetReqStr("cidx",0)

	' If IsEmpty(category_idx) Or IsNull(category_idx) Or Trim(category_idx) = "" Or Not IsNumeric(category_idx) Then category_idx = 0

	PageTitle = "메뉴목록"

	Dim aCmd, aRs

	Set aCmd = Server.CreateObject("ADODB.Command")
	With aCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_category_select_one"

		.Parameters.Append .CreateParameter("@brand_code", adVarChar, adParamInput, 10, "01")
		.Parameters.Append .CreateParameter("@category_idx", adInteger, adParamInput, , category_idx)

		Set aRs = .Execute
	End With
	Set aCmd = Nothing

	If Not (aRs.BOF Or aRs.EOF) Then
		PageTitle = aRs("category_name")
	End If
	Set aRs = Nothing
%>

<body>

<div class="wrapper">

	<!--#include virtual="/includes/header.asp"-->

	<!-- Container -->
	<div class="container">
		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
		<hr>
			
		<!-- Content -->
		<article class="content">

			<!-- 메뉴 리스트 -->
			<div class="menu-list">

				<%
					Set aCmd = Server.CreateObject("ADODB.Command")

					With aCmd
						.ActiveConnection = dbconn
						.NamedParameters = True
						.CommandType = adCmdStoredProc
						.CommandText = "bp_category_menu_list"

						.Parameters.Append .CreateParameter("@category_idx", adInteger, adParamInput, , category_idx)

						Set aRs = .Execute
					End With

					Set aCmd = Nothing

					If Not (aRs.BOF Or aRs.EOF) Then
						aRs.MoveFirst

						Do Until aRs.EOF
				%>

				<div class="box">
					<h4><%=aRs("menu_name")%></h4>
					<div class="img">
						<a href="/menu/menuView.asp?midx=<%=aRs("menu_idx")%>"><img src="<%=SERVER_IMGPATH%><%=aRs("thumb_file_path")&aRs("thumb_file_name")%>" width="750px" height="750px"  alt=""></a>
						<span class="info">
							<em class="sum"><%=aRs("menu_title")%></em>
							<strong class="pay"><%=FormatNumber(aRs("menu_price"),0)%>원</strong>
						</span>
					</div>
					<ul class="btnWrap">
						<li class="cart"><a href="javascript:addMenuNGo('M$$<%=aRs("menu_idx")%>$$<%=aRs("menu_option_idx")%>$$<%=aRs("menu_price")%>$$<%=aRs("menu_name")%>$$<%=SERVER_IMGPATH%><%=aRs("thumb_file_path")&aRs("thumb_file_name")%>', false);" class="btn btn-lg btn-grayLine"><img src="/images/menu/ico_menuCart.png" alt=""> 장바구니</a></li>
						<li class="dir"><a href="javascript:addMenuNGo('M$$<%=aRs("menu_idx")%>$$<%=aRs("menu_option_idx")%>$$<%=aRs("menu_price")%>$$<%=aRs("menu_name")%>$$<%=SERVER_IMGPATH%><%=aRs("thumb_file_path")&aRs("thumb_file_name")%>', true);" class="btn btn-lg btn-red"><img src="/images/menu/ico_menuDir.png" alt=""> 바로주문</a></li>
					</ul>
				</div>

				<%
							aRs.MoveNext
						Loop
					End If

					Set aRs = Nothing
				%>

			</div>
			<!-- //메뉴 리스트 -->

		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
