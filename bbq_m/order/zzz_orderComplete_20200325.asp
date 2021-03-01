<!--#include virtual="/api/include/utf8.asp"-->
<!--#include virtual="/pay/coupon_use.asp"-->
<!--#include virtual="/api/order/class_order_db.asp"-->
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<script type="text/javascript">
	$(function(){
		clearCart();
	});

	history.pushState(null, null, "#noback");
	$(window).bind("hashchange", function(){
		history.pushState(null, null, "#noback");
	});
</script>
</head>

<body>
<div class="wrapper">
<%
	PageTitle = "주문완료"
%>
	<!--#include virtual="/includes/header.asp"-->
	<hr>

	<!-- Container -->
	<div class="container">
		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
		<hr>
<%
	Dim aCmd, aRs

	Dim order_idx : order_idx = Request("order_idx")
	Dim paytype : paytype = Request("pm")

	If IsEmpty(order_idx) Or IsNull(order_idx) Or Trim(order_idx) = "" Or Not IsNumeric(order_idx) Then order_idx = ""

	If order_idx = "" Or paytype = "" Then
%>
	<script type="text/javascript">
		alert("잘못된 접근입니다.");
		location.href = "/";
	</script>
<%
		Response.End
	End If

	Set aCmd = Server.CreateObject("ADODB.Command")

	With aCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_order_select_one"

		.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,,order_idx)

		Set aRs = .Execute
	End With
	Set aCmd = Nothing

	Dim order_num, order_date, order_amt, discount_amt, pay_amt, delivery_fee, order_type
	Dim branch_id, branch_name, branch_phone, branch_tel, addr_name, zipcode, address_main, address_detail, delivery_message, delivery_mobile
	Dim spent_time
	If Not (aRs.BOF Or aRs.EOF) Then
		order_idx = aRs("order_idx")
		order_num = aRs("order_num")
		order_type = aRs("order_type")
		member_idx = aRs("member_id")
		member_idno = aRs("member_idno")
		member_type = aRs("member_type")
		pay_type = aRs("pay_type")
		order_date = aRs("order_date")
		order_amt = aRs("order_amt")
		delivery_fee = aRs("delivery_fee")
		discount_amt = aRs("discount_amt")
		pay_amt = aRs("pay_amt")
		delivery_fee = aRs("delivery_fee")
		branch_id = aRs("branch_id")
		branch_name = aRs("branch_name")
		branch_phone = aRs("branch_phone")
		branch_tel = aRs("branch_tel")
		addr_name = aRs("addr_name")
		zipcode = aRs("delivery_zipcode")
		address_main = aRs("delivery_address")
		address_detail = aRs("delivery_address_detail")
		delivery_message = aRs("delivery_message")
		delivery_mobile = aRs("delivery_mobile")
		spent_time = aRs("spent_time")
		order_channel = aRs("order_channel")
		MENU_NAME		= aRs("MENU_NAME")
		If order_channel = "2" Or order_channel = "3"  Then
			order_channel = "WEB"
		Else
			order_channel = "APP"
		End If
	End If
	Set aRs = Nothing

	If order_type = "D" Then
		order_type_title = "배달정보"
		order_type_name = "배달매장"
		address_title = "배달주소"
		address = ""
	ElseIf order_type = "P" Then
		order_type_title = "포장정보"
		order_type_name = "포장매장"
		address_title = "포장매장주소"
		address = ""
	End If

	Select Case pay_type
		Case "Card":
		pay_type_title = "온라인결제"
		pay_type_name = "신용카드"
		payMethodCode = "23"
		Case "Phone":
		pay_type_title = "온라인결제"
		pay_type_name = "휴대전화 결제"
		payMethodCode = "24"
		Case "Point":
		pay_type_title = "온라인결제"
		pay_type_name = "포인트"
		payMethodCode = "99"
		Case "Later":
		pay_type_title = "현장결제"
		pay_type_name = "신용카드"
		payMethodCode = "23"
		Case "Cash":
		pay_type_title = "현장결제"
		pay_type_name = "현금"
		payMethodCode = "21"
		Case "Payco":
		pay_type_title = "페이코"
		pay_type_name = "간편결제"
		payMethodCode = "31"
		Case "Paycoin":
		pay_type_title = "페이코인"
		pay_type_name = "간편결제"
		payMethodCode = "41"
		Case "Sgpay":
		pay_type_title = "BBQ PAY"
		pay_type_name = "간편결제"
		payMethodCode = "51"
		Case "ECoupon":
		pay_type_title = "E 쿠폰"
		pay_type_name = "E 쿠폰"
		payMethodCode = "99"
	End Select

%>
			
		<!-- Content -->
		<article class="content">

			<!--#include virtual="/includes/step.asp"-->

			<!-- 주문완료 텍스트 -->
			<div class="order_CompleteTxt">
				<h3><span class="red">주문이 정상적으로 완료</span>되었습니다.</h3>
				<p><%=LoginUserName%>님께서 주문하신 내역입니다.</p>
			</div>
			<!-- //주문완료 텍스트 -->

			<!-- 주문번호/일시 -->
			<section class="section section_orderNumDate">
				<dl>
					<dt>주문번호</dt>
					<dd><%=order_num%></dd>
				</dl>
				<dl>
					<dt>주문일시</dt>
					<dd><%=order_date%></dd>
				</dl>
			</section>
			<!-- //주문번호/일시 -->

			<!-- 장바구니 리스트 -->
			<div class="section-wrap mar-t30">
				<section class="section section_orderDetail">
					<div class="section-header order_head mar-b0">
						<h3>주문메뉴</h3>
					</div>

					<%
						Set aCmd = Server.CreateObject("ADODB.Command")
						With aCmd
							.ActiveConnection = dbconn
							.NamedParameters = True
							.CommandType = adCmdStoredProc
							.CommandText = "bp_order_detail_select"

							.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,, order_idx)

							Set aRs = .Execute
						End With
						Set aCmd = Nothing

						Dim upper_order_detail_idx : upper_order_detail_idx = -1

						If Not (aRs.BOF Or aRs.EOF) Then
							aRs.MoveFirst

							Do Until aRs.EOF
								If upper_order_detail_idx = -1 Then
					%>

					<div class="order_menu">
						<div class="box div-table">
							<div class="tr">
								<div class="td img"><img src="<%=SERVER_IMGPATH%><%=aRs("main_file_path")&aRs("main_file_name")%>" width="120px" height="120px" onerror="this.src='http://placehold.it/160x160?text=1'" alt=""></div>
								<div class="td info">
									<div class="sum">
										<%
											ElseIf upper_order_detail_idx <> 0 And aRs("upper_order_detail_idx") = 0 Then
										%>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="order_menu">
						<div class="box div-table">
							<div class="tr">
								<div class="td img"><img src="<%=SERVER_IMGPATH%><%=aRs("main_file_path")&aRs("main_file_name")%>" width="120px" height="120px" onerror="this.src='http://placehold.it/160x160?text=1';" alt=""></div>
								<div class="td info">
									<div class="sum">

										<%
											End If
											upper_order_detail_idx = aRs("upper_order_detail_idx")
										%>

										<dl>
											<dt><%=aRs("menu_name")%></dt>
											<dd><%=FormatNumber(aRs("menu_price"),0)%>원 <span>/ <%=aRs("menu_qty")%>개</span></dd>
										</dl>

										<%
												aRs.MoveNext
											Loop
										%>

									</div>
								</div>
							</div>
						</div>
					</div>

					<%
						End If
					%>

					<div class="order_calc2">
						<div class="top div-table">
							<dl class="tr">
								<dt class="td">총 상품금액</dd>
								<dd class="td"><%=FormatNumber(order_amt,0)%>원</dd>
							</dl>
							<%If order_type = "D" Then%>
							<dl class="tr">
								<dt class="td">배달비</dd>
								<dd class="td"><%=FormatNumber(delivery_fee,0)%>원</dd>
							</dl>
							<%End If%>
							<dl class="tr">
								<dt class="td">할인금액</dd>
								<dd class="td"><%=FormatNumber(discount_amt,0)%>원</dd>
							</dl>
						</div>
						<div class="bot div-table">
							<dl class="tr">
								<dt class="td">최종 결제금액</dd>
								<dd class="td"><%=FormatNumber(pay_amt,0)%><span>원</span></dd>
							</dl>
						</div>
					</div>
				</section>
			</div>
			<!-- //장바구니 리스트 -->


			<!-- 포장, 배달정보 -->
			<div class="section-wrap section-orderInfo mar-t30">
				<div class="section-header order_head">
					<h3><%=order_type_title%></h3>
				</div>
				<div class="area">
					<dl>
						<dt><%=order_type_name%></dt>
						<dd><strong class="red"><%=branch_name%></strong>(<%=branch_tel%>)</dd>
					</dl>
					<dl>
						<dt><%=address_title%></dt>
						<dd><%If order_type = "D" Then%>
							<%=addr_name%>  /  <%=mobile%><br/>
							(<%=zipcode%>) <%End If%><%=address_main&" "&address_detail%>
						</dd>
					</dl>

					<%
						If order_type = "P" Then
					%>

					<dl>
						<dt>매장 도착예정 시간</dt>
						<dd>
							<%=spent_time%>분 후
						</dd>
					</dl>

					<%
						End If
					%>

					<dl>
						<dt>기타요청사항</dt>
						<dd><%=delivery_message%></dd>
					</dl>
				</div>
			</div>
			<!-- 포장, 배달정보 -->

			<!-- 결제정보 -->
			<div class="section-wrap section-orderInfo bor-none mar-t30">
				<div class="section-header order_head">
					<h3>결제정보</h3>
				</div>
				<div class="area">
					<dl>
						<dt>결제방법</dt>
						<dd><%=pay_type_title%> / <%=pay_type_name%></dd>
					</dl>
					<dl>
						<dt>결제금액</dt>
						<dd class="big"><strong><%=FormatNumber(pay_amt,0)%></strong>원</dd>
					</dl>
				</div>
				<div class="mar-t30">

					<%
						If CheckLogin() Then
					%>

					<a href="/mypage/orderView.asp?oidx=<%=order_idx%>" class="btn_middle btn-red">주문내역 확인</a>

					<%
						Else
					%>

					<a href="/" class="btn_middle btn-red">주문내역 확인</a>

					<%
						End If
					%>

				</div>
			</div>
			<!-- //결제정보 -->

			<!--주문완료 문구-->
				<div>
					<div class="order_CompleteTxt">
						<p>
							고객님께서 주문완료 하신 건은 온라인에서 주문취소가 불가하오니,<br>
							취소하실 고객께서는 콜센터(1588-9282)로 문의주시기 바랍니다.
						</p>
						
					</div>

				</div>
			<!--//주문완료 문구-->

		</article>
		<!--// Content -->

		<!-- Back to Top -->
		<a href="#Top" class="btn btn_scrollTop">페이지 상단으로 이동</a>
		<!--// Back to Top -->

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
</div>
</body>
</html>