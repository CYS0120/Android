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
	Dim category_idx : category_idx = Request("cidx")
	Dim category_name : category_name = Request("cname")

	If IsEmpty(category_idx) Or IsNull(category_idx) Or Trim(category_idx) = "" Or Not IsNumeric(category_idx) Then category_idx = 0
	If IsEmpty(category_name) Or IsNull(category_name) Or Trim(category_name) = "" Then category_name = "전체메뉴"

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
					<h3>전체메뉴</h3>
				</div>

				<div class="section-body">
					<!-- 메뉴 탭 -->
					<ul class="menu-tab">
						<li <%If category_idx = 0 Then Response.Write "class='on'"%> ><a href="/menu/menuList.asp">모든 비비큐치킨</a></li>
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
%>
						<li <%If cstr(category_idx) = cstr(aRs("category_idx")) Then Response.Write "class='on'"%>><a href="/menu/menuList.asp?cidx=<%=aRs("category_idx")%>&cname=<%=aRs("category_name")%>"><%=aRs("category_name")%></a></li>
<%
			aRs.MoveNext
		Loop
	End If

	Set aRs = Nothing
%>
					</ul>
					<!-- //메뉴 탭 -->

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
							<div class="img">
								<a href="./menuView.asp?midx=<%=aRs("menu_idx")%>&cidx=<%=category_idx%>&cname=<%=category_name%>"><img src="<%=aRs("main_file_path")&aRs("main_file_name")%>" alt="" width="330px" height="330px"></a>
								<ul class="over">
									<li class="cart"><a href="javascript:addMenuNGo('M$$<%=aRs("menu_idx")%>$$<%=aRs("menu_option_idx")%>$$<%=aRs("menu_price")%>$$<%=aRs("menu_name")%>$$<%=aRs("main_file_path")&aRs("main_file_name")%>', false);"> 장바구니</a></li>
									<li class="dir"><a href="javascript:addMenuNGo('M$$<%=aRs("menu_idx")%>$$<%=aRs("menu_option_idx")%>$$<%=aRs("menu_price")%>$$<%=aRs("menu_name")%>$$<%=aRs("main_file_path")&aRs("main_file_name")%>', true);"> 바로주문</a></li>
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
