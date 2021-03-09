<!--#include virtual="/api/include/utf8.asp"-->
<%
	Response.Cookies("GUBUN") = ""
	Response.Cookies("ORDER_IDX") = ""
%>
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<meta name="Keywords" content="주문완료, BBQ치킨">
<meta name="Description" content="주문완료 메인">
<title>주문완료 | BBQ치킨</title>
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
	$(function(){
		clearCart();
	});
</script>
</head>

<body>
<div class="wrapper">
	<!-- Header -->
	<!--#include virtual="/includes/header.asp"-->
	<!--// Header -->
	<hr>
	
	<!-- Container -->
	<div class="container">
<%
	Dim aCmd, aRs

	Dim order_idx : order_idx = Request("order_idx")

	If IsEmpty(order_idx) Or IsNull(order_idx) Or Trim(order_idx) = "" Or Not IsNumeric(order_idx) Then order_idx = ""

	If order_idx = "" Then
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
		.CommandText = "bp_order_status_update"

		.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)
		.Parameters.Append .CreateParameter("@order_status", adVarChar, adParamInput, 10, "P")
		.Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
		.Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

		.Execute

		errCode = .Parameters("@ERRCODE").Value
		errMsg = .Parameters("@ERRMSG").Value		
	End With
	Set aCmd = Nothing

	If errCode <> 0 Then
		'상태업데이트가 제대로 이루어지지 않음
		'POS에서 가져갈 상태로 만들지 못함......
	End If

	Set aCmd = Server.CreateObject("ADODB.Command")
	With aCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_bbq_order"

		.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)

		.Execute
	End With
	Set aCmd = Nothing

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
	Dim branch_id, branch_name, branch_tel, addr_name, zipcode, address_main, address_detail, delivery_message
	If Not (aRs.BOF Or aRs.EOF) Then
		order_idx = aRs("order_idx")
		order_num = aRs("order_num")
		order_type = aRs("order_type")
		pay_type = aRs("pay_type")
		order_date = aRs("order_date")
		order_amt = aRs("order_amt")
		delivery_fee = aRs("delivery_fee")
		discount_amt = aRs("discount_amt")
		pay_amt = aRs("pay_amt")
		delivery_fee = aRs("delivery_fee")
		branch_id = aRs("branch_id")
		branch_name = aRs("branch_name")
		branch_tel = aRs("branch_tel")
		addr_name = aRs("addr_name")
		zipcode = aRs("delivery_zipcode")
		address_main = aRs("delivery_address")
		address_detail = aRs("delivery_address_detail")
		delivery_message = aRs("delivery_message")
	End If
	Set aRs = Nothing

	If order_type = "D" Then
		order_type_title = "배달정보"
		order_type_name = "배달매장"
		address_title = "배달주소"
		address = addr_name & " / " & mobile & " / (" & zipcode & ") " & address_main&" "&address_detail
	ElseIf order_type = "P" Then
		order_type_title = "픽업정보"
		order_type_name = "픽업매장"
		address_title = "픽업매장 주소"
		address = address_main
	End If

	Select Case pay_type
		Case "Card":
		pay_type_title = "온라인결제"
		pay_type_name = "신용카드"
		Case "Phone":
		pay_type_title = "온라인결제"
		pay_type_name = "휴대전화 결제"
		Case "Point":
		pay_type_title = "온라인결제"
		pay_type_name = "포인트"
		Case "Later":
		pay_type_title = "현장결제"
		pay_type_name = "신용카드"
		Case "Cash":
		pay_type_title = "현장결제"
		pay_type_name = "현금"
	End Select

    Dim reqOC : Set reqOC = New clsReqOrderComplete
    reqOC.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
    ' reqOC.mMerchantCode = branch_id
    reqOC.mMerchantCode = PAYCO_MEMBERSHIP_MERCHANTCODE
    reqOC.mMemberNo = Session("userIdNo")
    reqOC.mServiceTradeNo = order_num
    reqOC.mOrderYmdt = dd&" "&dt
    reqOC.mSaveYn = "Y"
    reqOC.mDeliveryCharge = delivery_fee

    Set aCmd = Server.CreateObject("ADODB.Command")
    With aCmd
    	.ActiveConnection = dbconn
    	.NamedParameters = True
    	.CommandType = adCmdStoredProc
    	.CommandText = "bp_order_detail_select"

    	.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)

    	Set aRs = .Execute
    End With
    Set aCmd = Nothing

    If Not (aRs.BOF Or aRs.EOF) Then
    	aRs.MoveFirst
    	Do until aRs.EOF
    		Set pItem = New clsProductList
    		If aRs("upper_order_detail_idx") = 0 Then
    			pItem.mProductClassCd = "M"
    			pItem.mProductClassNm = "메인"
    		Else
    			pItem.mProductClassCd = "S"
    			pItem.mProductClassNm = "사이드"
    		End If
    		pItem.mProductCd = aRs("menu_idx")
    		pItem.mProductNm = aRs("menu_name")
    		pItem.mUnitPrice = aRs("menu_price")
    		pItem.mProductCount = aRs("menu_qty")
    		pItem.mProductSaveYn = "Y"

    		reqOC.addProductList(pItem)
    		aRs.MoveNext
    	Loop
    End If
    Set aRs = Nothing

    If CheckLogin() Then
	    Dim resOC : Set resOC = OrderComplete(reqOC.toJson())

	    If resOC.mMessage = "SUCCESS" Then
	    	Set aCmd = Server.CreateObject("ADODB.Command")
	    	With aCmd
	    		.ActiveConnection = dbconn
	    		.NamedParameters = True
	    		.CommandType = adCmdStoredProc
	    		.CommandText = "bp_order_update_payco"

	    		.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)
	    		.Parameters.Append .CreateParameter("@payco_orderno", adVarChar, adParamInput, 50, resOC.mOrderNo)
	    		.Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
	    		.Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

	    		.Execute

	    		errCode = .Parameters("@ERRCODE").Value
	    		errMsg = .Parameters("@ERRMSG").Value
	    	End With
	    	Set aCmd = Nothing
	    End If
	End If
%>		
		<!-- Content -->
		<article class="content">
	
			<!-- 주문단계 -->
			<section class="section section-orderStep">
				<ul>
					<li class="step1"><span>01 장바구니</span></li>
					<li class="step2"><span>02 주문/결제</span></li>
					<li class="step3 on"><span>03 주문완료</span></li>
				</ul>
			</section>
			<!-- //주문단계 -->

			<h1 class="line">주문완료</h1>

			<!-- 주문완료 텍스트 -->
			<div class="order_CompleteTxt">
				<h3><span class="red">주문이 정상적으로 완료</span>되었습니다.</h3>
				<p><%=LoginUserName%>님께서 주문하신 내역입니다.</p>
			</div>
			<!-- //주문완료 텍스트 -->

			<!-- 주문요약정보 -->
			<section class="section section_orderNumDate">
				<dl>
					<dt>주문번호 : </dt>
					<dd><%=order_num%></dd>
				</dl>
				<dl>
					<dt>주문일시 : </dt>
					<dd><%=order_date%></dd>
				</dl>
			</section>
			<!-- //주문요약정보 -->


			<!-- 장바구니 테이블 -->
			<div class="section-item">
				<h4>주문메뉴</h4>
				<table border="1" cellspacing="0" class="tbl-cart">
					<caption>장바구니</caption>
					<colgroup>
						<col style="width:141px;">
						<col>
						<col style="width:150px;">
						<%If order_type = "D" Then%>
						<col style="width:150px;">
						<%End If%>
						<col style="width:150px;">
					</colgroup>
					<thead>
						<tr>
							<th colspan="2">상품정보</th>
							<th>상품금액</th>
							<%If order_type = "D" Then%>
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
		.CommandText = "bp_order_detail_select"

		.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,, order_idx)

		Set aRs = .Execute
	End With
	Set aCmd = Nothing

	Dim upper_order_detail_idx : upper_order_detail_idx = -1
	Dim isFrist : isFrist = True
	If Not (aRs.BOF Or aRs.EOF) Then
		aRs.MoveFirst

		Dim subAmt, totAmt
		totAmt = 0
		subAmt = 0
		Do Until aRs.EOF
			totAmt = totAmt + (aRs("menu_price") * aRs("menu_qty"))
			If upper_order_detail_idx = -1 Then
				subAmt = subAmt + (aRs("menu_price") * aRs("menu_qty"))
%>
						<tr>
							<td class="img">
								<a href="#" onclick="javascript:return false;"><img src="<%=aRs("main_file_path")&aRs("main_file_name")%>" width="120px" height="120px" onerror="this.rc='http://placehold.it/120x120';"/></a>
							</td>
							<td class="info ta-l">
								<div class="pdt-info div-table">
									<dl class="tr">
										<dt class="td"><%=aRs("menu_name")%></dt>
										<dd class="td pm"><%=aRs("menu_qty")%>개</dd>
										<dd class="td sum"><%=FormatNumber(aRs("menu_price"),0)%>원</dd>
									</dl>
<%
			ElseIf upper_order_detail_idx <> 0 And aRs("upper_order_detail_idx") = 0 Then
%>
								</div>
							</td>
							<td class="pay"><%=FormatNumber(subAmt,0)%>원</td>
<%
				If isFrist Then
					isFrist = False
					If order_type = "D" Then
%>
							<td class="move" rowspan="2">배달비<br/><%=FormatNumber(delivery_fee,0)%>원</td>
<%
					End If
%>
							<td class="pay" rowspan="2" id="tot_ord_mat"><%=FormatNumber(pay_amt,0)%>원</td>
<%
				End If
%>
						</tr>
						<tr>
							<td class="img">
								<a href="#" onclick="javascript:return false;"><img src="http://placehold.it/120x120"/></a>
							</td>
							<td class="info ta-l">
								<div class="pdt-info div-table">
									<dl class="tr">
										<dt class="td"><%=aRs("menu_name")%></dt>
										<dd class="td pm"><%=aRs("menu_qty")%>개</dd>
										<dd class="td sum"><%=FormatNumber(aRs("menu_price"),0)%>원</dd>
									</dl>
<%
				subAmt = 0
			Else
%>
									<dl class="tr">
										<dt class="td"><%=aRs("menu_name")%></dt>
										<dd class="td pm"><%=aRs("menu_qty")%>개</dd>
										<dd class="td sum"><%=FormatNumber(aRs("menu_price"),0)%>원</dd>
									</dl>
<%
				subAmt = subAmt + (aRs("menu_price") * aRs("menu_qty"))
			End If
			upper_order_detail_idx = aRs("upper_order_detail_idx")
			aRs.MoveNext
		Loop
	End If

	If isFrist Then
%>
								</div>
							</td>
							<td class="pay"><%=FormatNumber(subAmt,0)%>원</td>
<%
		If order_type = "D" Then
%>
							<td class="move" rowspan="2">배달비<br/><%=FormatNumber(delivery_fee,0)%>원</td>
<%
		End If
%>
							<td class="pay" rowspan="2" id="tot_ord_mat"><%=FormatNumber(totAmt,0)%>원</td>
						</tr>
<%
	Else
%>
							<td class="pay"><%=FormatNumber(subAmt,0)%>원</td>
						</tr>
<%
	End If

	Set aRs = Nothing
%>
					</tbody>
				</table>
			</div>
			<!-- //장바구니 테이블 -->
			<script type="text/javascript">$("#tot_ord_mat").text(numberWithCommas(<%=totAmt+delivery_fee%>)+"원");</script>
			<!-- 장바구니 하단 정보 -->
			<div class="cart-botInfo div-table">
				<div class="tr">
					
					<div class="td rig">
						<span>총 상품금액</span>
						<strong><%=FormatNumber(totAmt,0)%></strong>
						<span>원</span>
						<%If order_type = "D" Then%>
						<em><img src="/images/mypage/ico_calc_plus.png" alt=""></em>
						<span>배달비</span>
						<strong><%=FormatNumber(delivery_fee,0)%></strong>
						<span>원</span>
						<%End If%>
						<em><img src="/images/mypage/ico_calc_minus.png" alt=""></em>
						<span>할인금액</span>
						<strong><%=Formatnumber(discount_amt,0)%></strong>
						<span>원</span>
						<em><img src="/images/mypage/ico_calc_equal.png" alt=""></em>
						<span>최종 결제금액</span>
						<strong class="red"><%=FormatNumber(pay_amt,0)%></strong>
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
							<td><span class="red"><%=branch_name%></span>(<%=branch_tel%>)</td>
						</tr>
						<tr>
							<th scope="row"><%=address_title%></th>
							<td><%=address%></td>
						</tr>
						<tr>
							<th scope="row">기타요청사항</th>
							<td><%=delivery_message%></td>
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
								<strong><%=FormatNumber(pay_amt,0)%></strong>원
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- //결제정보 -->


			<div class="btn-wrap two-up inner mar-t60">
				<a href="<%If CheckLogin() Then Response.Write "/mypage/orderView.asp?oidx="&order_idx Else Response.Write "/" End If%>" class="btn btn-lg btn-red"><span>주문내역 확인</span></a>
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
