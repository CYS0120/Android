<!--#include virtual="/api/include/utf8.asp"-->
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<!--include virtual="/api/include/requireLogin.asp"-->
<meta name="Keywords" content="마이페이지, BBQ치킨">
<meta name="Description" content="마이페이지">
<title>마이페이지 | BBQ치킨</title>
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
</head>
<%
	order_idx = GetReqStr("oidx","")
	order_num = GetReqStr("onum","")
	curPage = GetReqNum("gotoPage",1)
	cmobile = GetReqStr("cmobile","")
	rtnUrl = GetReqStr("rtnUrl","")

	If order_idx = "" And order_num = "" Then
%>
	<script type="text/javascript">
		alert("잘못된 접근입니다.");
		history.back();
	</script>
<%
		Response.End
	End If

	If order_idx = "" Then order_idx = 0


	If CheckLogin() Then
		Set aCmd = Server.CreateObject("ADODB.Command")
		With aCmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_order_select_one_member"

			.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)
			.Parameters.Append .CreateParameter("@order_num", adVarChar, adParamInput, 50, order_num)
			.Parameters.Append .CreateParameter("@member_idx", adInteger, adParamInput, , Session("userIdx"))

			Set aRs = .Execute
		End With
		Set aCmd = Nothing
	Else
		If FncIsBlank(Session("ORDER_NOMEMBERHP")) Then 
%>
	<script type="text/javascript">
		alert("잘못된 접근입니다.");
		history.back();
	</script>
<%
			Response.End
		End If 
		Set aCmd = Server.CreateObject("ADODB.Command")
		With aCmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_order_select_one_nomember"

			.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)
			.Parameters.Append .CreateParameter("@order_num", adVarChar, adParamInput, 50, order_num)
			.Parameters.Append .CreateParameter("@nomember_hp", adVarChar, adParamInput, 20, Session("ORDER_NOMEMBERHP"))

			Set aRs = .Execute
		End With
		Set aCmd = Nothing
	End If 



	If Not (aRs.BOF Or aRs.EOF) Then
		order_idx = aRs("order_idx")
		vOrderNum = aRs("order_num")
		vBrandName = aRs("brand_name")
		vOrderDate = aRs("order_date")
		vBrandCode = aRs("brand_code")
		vOrderType = aRs("order_type")
		vOrderTypeName = aRs("order_type_name")
		vPayType = aRs("pay_type")
		vPayTypeName = aRs("pay_type_name")
		vOrderStatus = aRs("order_status")
		vOrderStatusName = aRs("order_status_name")
		vOrderAmt = aRs("order_amt")
		vDeliveryFee = aRs("delivery_fee")
		vDiscountAmt = aRs("discount_amt")
		vPayAmt = aRs("pay_amt")
		vDeliveryMessage = aRs("delivery_message")

		vBranchName = aRs("branch_name")
		vBranchTel = aRs("branch_tel")

		vAddressName = aRs("addr_name")
		vMobile = aRs("delivery_mobile")
		vZipCode = aRs("delivery_zipcode")
		vAddress = aRs("delivery_address")&" "&aRs("delivery_address_detail")
	Else
%>
	<script type="text/javascript">
		alert("주문내역이 없습니다.");
		history.back();
	</script>
<%
		Response.End
	End If

	If vOrderType = "D" Then
		order_type_title = "배달정보"
		order_type_name = "배달매장"
		address_title = "배달주소"
	ElseIf vOrderType = "P" Then
		order_type_title = "포장정보"
		order_type_name = "포장매장"
		address_title = "포장매장 주소"
	End If

	Select Case vPayType
		Case "Card":
		pay_type_title = "온라인결제"
		pay_type_name = "신용카드"
		Case "Phone":
		pay_type_title = "온라인결제"
		pay_type_name = "휴대전화 결제"
		Case "Later":
		pay_type_title = "현장결제"
		pay_type_name = "신용카드"
		Case "Cash":
		pay_type_title = "현장결제"
		pay_type_name = "현금"
		Case "Payco":
		pay_type_title = "페이코"
		pay_type_name = "간편결제"
		Case "Paycoin":
		pay_type_title = "페이코인"
		pay_type_name = "간편결제"
		Case "OFF":
		pay_type_title = "현장결제"
		pay_type_name = "현장결제"
	End Select
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
		<div class="breadcrumb-wrap">
			<ul class="breadcrumb">
				<li>bbq home</li>
				<li>마이페이지</li>
				<li>주문내역</li>
			</ul>
		</div>
		<!--// BreadCrumb -->
		
		<!-- Content -->
		<article class="content">
			<%
				If CheckLogin() Then
			%>
			<h1>마이페이지</h1>
			<!-- Membership -->
			<section class="section section_membership">
				<!-- My Info -->
				<!--#include virtual="/includes/mypage.inc.asp"-->
				<!--// My Info -->
				<!-- My Menu -->
				<!--#include virtual="/includes/mypagemenu.inc.asp"-->
				<!--// My Menu -->
			</section>
			<!--// Membership -->
			<%
				End If
			%>
			<!-- 주문내역 -->
			<section class="section">
				<div class="section-header">
					<h3>주문내역상세</h3>
				</div>
				<div class="section-body">
					
				<!-- 주문요약정보 -->
				<div class="section_orderNumDate">
					<dl>
						<dt>주문번호 : </dt>
						<dd><%=vOrderNum%></dd>
					</dl>
					<dl>
						<dt>주문일시 : </dt>
						<dd><%=vOrderDate%></dd>
					</dl>
				</div>
				<!-- //주문요약정보 -->

			</section>
			<!--// 주문내역 -->


			<!-- 장바구니 테이블 -->
			<section class="section">
				<div class="section-header2">
					<h4>브랜드  : <span class="ico-branch red"><%=vBrandName%><%If vOrderType="X" Then%>(off)<%End If%></span></h4>
					<div class="right">
						<ul class="state_sum">
							<li class="red"><img src="/images/mypage/<%If vOrderType="D" Then%>ico_order_basic.png<%ElseIf vOrderType="P" Then%>ico_order_pick.png<%Else%>ico_order_shop.png<%End If%>" alt=""> <%=vOrderTypeName%></li>
							<li><img src="/images/mypage/ico_ok.gif" alt=""> <%=vOrderStatusName%></li>
						</ul>
					</div>
				</div>
				
				<div class="section-body">
					<table border="1" cellspacing="0" class="tbl-cart">
						<caption>장바구니</caption>
						<colgroup>
							<col style="width:105px;">
							<col>
							<col style="width:150px;">
							<%If vOrderType = "D" Then%>
							<col style="width:150px;">
							<%End If%>
							<col style="width:150px;">
						</colgroup>
						<thead>
							<tr>
								<th colspan="2">상품정보</th>
								<th>상품금액</th>
								<%If vOrderType = "D" Then%>
								<th>배달정보</th>
								<%End If%>
								<th>합계</th>
							</tr>
						</thead>
						<tbody>

<%
	Set aCmd = Server.CreateObject("ADODB.Command")
	With aCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_order_detail_select_main"

		.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)

		Set aRs = .Execute
	End With
	Set aCmd = Nothing

	If Not (aRs.BOF Or aRs.EOF) Then
		order_detail_idx = 0
		Do Until aRs.EOF
%>
							<tr>
								<td class="img">
									<a href="#" onclick="javascript:return false;"><img src="<%=SERVER_IMGPATH%><%=aRs("thumb_file_path")%><%=aRs("thumb_file_name")%>" width="85px" height="85px"/></a>
								</td>
								<td class="info ta-l">
									<div class="pdt-info div-table">
										<dl class="tr">
											<dt class="td"><%If aRs("coupon_pin") = "GIFTCOUPON" Then%>(증정쿠폰)<%End If%> <%=aRs("menu_name")%></dt>
											<dd class="td pm"><%=aRs("menu_qty")%>개</dd>
											<dd class="td sum"><%=FormatNumber(aRs("menu_price"),0)%>원</dd>
										</dl>
<%
			Set aCmd = Server.CreateObject("ADODB.Command")
			With aCmd
				.ActiveConnection = dbconn
				.NamedParameters = True
				.CommandType = adCmdStoredProc
				.CommandText = "bp_order_detail_select_side"

				.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)
				.Parameters.Append .CreateParameter("@upper_order_detail_idx", adInteger, adParamInput, , aRs("order_detail_idx"))

				Set aRs2 = .Execute
			End With
			Set aCmd = Nothing

			If Not(aRs2.BOF OR aRs2.EOF) Then
				Do Until aRs2.EOF
%>
										<dl class="tr">
											<dt class="td"><%=aRs2("menu_name")%></dt>
											<dd class="td pm"><%=aRs2("menu_qty")%>개</dd>
											<dd class="td sum"><%=FormatNumber(aRs2("menu_price"),0)%>원</dd>
										</dl>
<%
					aRs2.MoveNext
				Loop
			ENd If

			Set aRs2 = Nothing
%>
									</div>
								</td>
								<td class="pay"><%=FormatNumber(aRs("side_sum")+(aRs("menu_price")*aRs("menu_qty")),0)%>원</td>
<%
			If order_detail_idx = 0 Then
				If vOrderType = "D" Then
%>
								<td class="move" rowspan="<%=aRs.RecordCount%>">배달비<br/><%=FormatNumber(vDeliveryFee,0)%>원</td>
<%
				End If
%>
								<td class="pay" rowspan="<%=aRs.RecordCount%>"><%=FormatNumber(vOrderAmt+vDeliveryFee,0)%>원</td>
<%
			End If
%>
							</tr>
<%
			order_detail_idx = aRs("order_detail_idx")
			aRs.MoveNext
		Loop
	End If
%>

<%
	Set aCmd = Server.CreateObject("ADODB.Command")
	With aCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_order_detail_select_barcode"

		.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)

		Set aRs = .Execute
	End With
	Set aCmd = Nothing

	If Not (aRs.BOF Or aRs.EOF) Then
		Do Until aRs.EOF
%>
							<tr>
								<td class="img">
									<a href="#" onclick="javascript:return false;"><img src="/images/menu/store_menu.jpg" width="85px" height="85px"/></a>
								</td>
								<td class="info ta-l">
									<div class="pdt-info div-table">
										<dl class="tr">
											<dt class="td"><%=aRs("CGOODNM")%></dt>
											<dd class="td pm"><%=aRs("FQTY")%>개</dd>
											<dd class="td sum"><%=FormatNumber(aRs("FAMT"),0)%>원</dd>
										</dl>
									</div>
								</td>
								<td class="pay"><%=FormatNumber(aRs("FAMT"),0)%>원</td>
								<td class="pay"><%=FormatNumber(aRs("FAMT"),0)%>원</td>
							</tr>
<%
			aRs.MoveNext
		Loop
	End If
%>
						</tbody>
					</table>
				</div>
			</section>
			<!-- //장바구니 테이블 -->

			<!-- 장바구니 하단 정보 -->
			<div class="cart-botInfo div-table">
				<div class="tr">
					
					<div class="td rig">
						<span>총 상품금액</span>
						<strong><%=FormatNumber(vOrderAmt,0)%></strong>
						<span>원</span>
						<%If vOrderType = "D" Then%>
						<em><img src="/images/mypage/ico_calc_plus.png" alt=""></em>
						<span>배달비</span>
						<strong><%=FormatNumber(vDeliveryFee,0)%></strong>
						<span>원</span>
						<%End If%>
						<em><img src="/images/mypage/ico_calc_minus.png" alt=""></em>
						<span>할인금액</span>
						<strong><%=FormatNumber(vDiscountAmt,0)%></strong>
						<span>원</span>
						<em><img src="/images/mypage/ico_calc_equal.png" alt=""></em>
						<span>최종 결제금액</span>
						<strong class="red"><%=FormatNumber(vPayAmt,0)%></strong>
						<span>원</span>
					</div>
				</div>
			</div>
			<!-- //장바구니 하단 정보 -->


			<!-- 배달정보 -->
			<div class="section-item">
				<h4><%=order_type_title%></h4>
				<table class="tbl-write">
					<caption>배달정보</caption>
					<tbody>
						<tr>
							<th scope="row"><%=order_type_name%></th>
							<td><span class="red"><%=vBranchName%></span>(<%=vBranchTel%>)</td>
						</tr>
						<tr>
							<th scope="row"><%=address_title%></th>
							<td><%If vOrderType = "D" Then%><%=vAddressName%>  /  <%=vMobile%>  /  (<%=vZipCode%>) <%End If%><%=vAddress%></td>
						</tr>
						<tr>
							<th scope="row">기타요청사항</th>
							<td><%=vDeliveryMessage%></td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- //배달정보 -->
			<!-- 결제정보 -->
			<div class="section-item">
				<h4>결제정보</h4>
				<table class="tbl-write">
					<caption>결제정보</caption>
					<tbody>
						<tr>
							<th scope="row">결제방법</th>
							<td>
								<%=pay_type_title%> / <%=pay_type_name%>
							</td>
						</tr>
						<tr>
							<th scope="row">결제금액</th>
							<td>
								<strong class="fs20"><%=FormatNumber(vPayAmt,0)%></strong>원
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- //결제정보 -->


			<div class="btn-wrap two-up inner mar-t60">
<%
	If rtnUrl <> "" Then
%>
				<a href="<%=rtnUrl%>" class="btn btn-lg btn-black"><span>목록</span></a>
<%
	Else
		If CheckLogin() Then
%>
				<a href="/mypage/orderList.asp?gotopage=<%=curPage%>" class="btn btn-lg btn-black"><span>목록</span></a>
<%
		Else
%>
				<a href="/mypage/orderListNonMem.asp?gotopage=<%=curPage%>" class="btn btn-lg btn-black"><span>목록</span></a>
<%
		End if
	End If
%>
			</div>


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
