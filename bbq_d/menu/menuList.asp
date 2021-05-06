<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<meta name="Keywords" content="전체메뉴, BBQ치킨">
<meta name="Description" content="전체메뉴">
<title>전체메뉴 | BBQ치킨</title>
<script>
jQuery(document).ready(function(e) {
	
	$(window).on('scroll',function(e){
		if ($(window).scrollTop() > 0) {
			$(".wrapper").addClass("scrolled");
		} else {
			$(".wrapper").removeClass("scrolled");
		}
	});

});
</script>
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
	' Dim category_idx : category_idx = GetReqNum("cidx",117)
	' Dim category_name : category_name = GetReqStr("cname","페이코인 이벤트")
	Dim category_idx : category_idx = GetReqNum("cidx","")
	Dim category_name : category_name = GetReqStr("cname","")

	Dim aCmd, aRs
%>
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
		<article class="content">
			<section class="section">

				<div class="section-header">
					<h3><%=category_name%></h3>
				</div>

				<div class="section-body">
					<!-- 메뉴 탭 -->
					<ul class="menu-tab">
						<% if false then %>
						<li <%If category_idx = 0 Then Response.Write "class='on'"%> ><a href="/menu/menuList.asp">모든 비비큐치킨</a></li>
						<% end if %>
<%
	Set aCmd = Server.CreateObject("ADODB.Command")

	With aCmd
		.ActiveConnection = dbconn
		.CommandType = adCmdStoredProc
		.CommandText = "bp_main_category_select"

		Set aRs = .Execute
	End With

	Set aCmd = Nothing

	If Not (aRs.BOF Or aRs.EOF) Then
		aRs.MoveFirst

		Do Until aRs.EOF
			if cstr(aRs("category_use_yn")) = "Y" then
				if category_idx = "" then
					category_idx = cstr(aRs("category_idx"))
					category_name = cstr(aRs("category_name"))
				end if
%>
						<li <%If cstr(category_idx) = cstr(aRs("category_idx")) Then Response.Write "class='on'"%>><a href="/menu/menuList.asp?cidx=<%=aRs("category_idx")%>&cname=<%=server.UrlEncode(aRs("category_name"))%>"><%=aRs("category_name")%></a></li>
<%
			end if
			aRs.MoveNext
		Loop
	End If

	Set aRs = Nothing
%>
						<li <%If cstr(category_idx) = cstr("99999") Then Response.Write "class='on'"%>><a href="/menu/menuList.asp?cidx=99999&cname=<%=server.UrlEncode("사이드메뉴")%>">사이드메뉴</a></li>
					</ul>
					<!-- //메뉴 탭 -->

					<div class="menu-list">
<%
						if category_idx = "103" then 

							Set aCmd = Server.CreateObject("ADODB.Command")

							With aCmd
								.ActiveConnection = dbconn
								.NamedParameters = True
								.CommandType = adCmdStoredProc
								.CommandText = "UP_MENU_LIST_GUBUN"

								.Parameters.Append .CreateParameter("@GUBUN", adInteger, adParamInput, , category_idx)

								Set aRs = .Execute
							End With

							Set aCmd = Nothing

						elseif category_idx = "99999" then 

							Set aCmd = Server.CreateObject("ADODB.Command")

							With aCmd
								.ActiveConnection = dbconn
								.NamedParameters = True
								.CommandType = adCmdStoredProc
								.CommandText = "bp_sidemenu_select"

								Set aRs = .Execute
							End With

							Set aCmd = Nothing

						else

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

						end if 

	Set aCmd = Nothing

	If Not (aRs.BOF Or aRs.EOF) Then
		aRs.MoveFirst

		Do Until aRs.EOF
%>
						<div class="box">
							<div class="img">
								<a href="./menuView.asp?midx=<%=aRs("menu_idx")%>&cidx=<%=category_idx%>&cname=<%=server.UrlEncode(category_name)%>"><img src="<%=SERVER_IMGPATH%><%=aRs("thumb_file_path")&aRs("thumb_file_name")%>" alt="" width="330px" height="330px"></a>
								<ul class="over">
									<!-- <li class="cart"><a href="javascript: mobile_cart_window_open()"> 장바구니</a></li> -->
									<li class="dir"><a href="javascript: mobile_order_window_open();"> 온라인주문</a></li>
								</ul>
							</div>
							<div class="info">
								<p class="name"><%=aRs("menu_name")%></p>
								<p class="sum"><%=aRs("menu_title")%></p>
								<p class="pay"><%=FormatNumber(aRs("menu_price"),0)%>원</p>
							</div>
						</div>
<%
			aRs.MoveNext
		Loop
	End If

	Set aRs = Nothing
%>					
						
					</div>
				</div>

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
