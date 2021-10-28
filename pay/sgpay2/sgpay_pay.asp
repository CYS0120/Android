<!--#include file="sgpay.inc.asp" -->
<%
    REFERERURL	= Request.ServerVariables("HTTP_REFERER")
	If Not CheckLogin() Then
        if len(REFERERURL) = 0 or instr(REFERERURL, g2_bbq_m_url) < 0 then
			REFERERURL = "/"
		end if
%>
<script>
	alert('회원 서비스입니다.');
</script>
<%
        response.redirect g2_bbq_m_url
		Response.End
	End If
	IF LEN(REFERERURL) = 0 THEN REFERERURL = g2_bbq_m_url & "/order/payment.asp"

	' 비비큐 주문정보 셋팅
	gubun = GetReqStr("gubun", "")
	domain = GetReqStr("domain", "")
	branch_id = GetReqStr("branch_id", "")
	cart_value = GetReqStr("cart_value", "")

	If branch_id = "" Then
%>
<script>
	alert('매장정보가 없습니다.');
</script>
<%
        response.redirect g2_bbq_m_url
		Response.End
	End If

	' ' 간편결제 등록 여부 확인
	' payInfo = GetpayInfo(g_corpMemberNo, g_userMngNo)
	' ' JSON 객체 생성
	' Set payInfoToJson = New aspJSON
	' ' JSON 문자열 파싱
	' payInfoToJson.loadJSON(Result)
	' sgpay_payListCnt = payInfoToJson.data("payListCnt")

	sgpay_userInfo = GetuserInfo(g_corpMemberNo)

	' JSON 객체 생성
	Set readTokenToJson = New aspJSON
	' JSON 문자열 파싱
	readTokenToJson.loadJSON(sgpay_userInfo)
	if readTokenToJson.data("resultCode") = "0000" and readTokenToJson.data("statusCd") = "0" then
	else
%>
<script>
	alert('간편결제 등록이 되지 않은 사용자입니다. 먼저 가입을 부탁드립니다.');
	document.location.href = "/pay/sgpay2/sgpay_MemReg.asp";
</script>
<%
		Response.End
	end if

	' 매장정보 조회...
	Set aCmd = Server.CreateObject("ADODB.Command")

	With aCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_branch_select"

		.Parameters.Append .CreateParameter("@branch_id", adInteger, adParamInput, , branch_id)

		Set aRs = .Execute
	End With

	Set aCmd = Nothing

	If Not (aRs.BOF Or aRs.EOF) Then
		vBranchName = aRs("branch_name")
		vBranchTel = aRs("branch_tel")
		vDeliveryFee = aRs("delivery_fee")
		vSubCPID = aRs("DANAL_H_SCPID")
		vUseDANAL = aRs("USE_DANAL")
		vUsePAYCO = aRs("USE_PAYCO")
		vPayco_Seller = aRs("payco_seller")
		vPayco_Cpid = aRs("payco_cpid")
		vPayco_Itemcd = aRs("payco_itemcd")
		' s_MERTNO = aRs("sgpay_merchant")
		s_MERTNO = aRs("sgpay_merchant_v2")

		If s_MERTNO = "" Then
%>
<script>
	alert("BBQ PAY 가맹점이 아닙니다.");
	if (window.opener) {
		self.close();
	} else {
		history.back();
	}
</script>
<%
			Set aRs = Nothing
			response.End
		End If
	Else
%>
<script>
	alert("매장정보가 없습니다.");
	if (window.opener) {
		self.close();
	} else {
		history.back();
	}
</script>
<%
		Set aRs = Nothing
		response.End
	End If

	If Not IsNumeric(vDeliveryFee) Then vDeliveryFee = 0

	If order_type = "P" Then vDeliveryFee = 0

	Set aRs = Nothing

	order_idx = GetReqNum("order_idx", "")
	order_num = GetReqStr("order_num","")
	pay_method = GetReqStr("pay_method","")

	Response.Cookies("GUBUN") = gubun
	Response.Cookies("ORDER_IDX") = order_idx

	Set pCmd = Server.CreateObject("ADODB.Command")
	With pCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_order_for_pay"

		.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)

		Set pRs = .Execute
	End With
	Set pCmd = Nothing

	If Not (pRs.BOF Or pRs.EOF) Then
		USER_ID			= pRs("member_idno")
		DELIVERY_FEE	= pRs("delivery_fee")
		AMOUNT			= pRs("order_amt")-pRs("discount_amt")
	Else
		USER_ID			= ""
		DELIVERY_FEE	= ""
		AMOUNT			= ""
	End If

	' 제주/산간 =========================================================================================
	Set pCmd = Server.CreateObject("ADODB.Command")
	With pCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_order_detail_select_1138"

		.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)

		Set pRs = .Execute
	End With
	Set pCmd = Nothing

	If Not (pRs.BOF Or pRs.EOF) Then
		AMOUNT = AMOUNT + (pRs("menu_price")*pRs("menu_qty"))
	End If
	' =========================================================================================

	'-----------------------------------------------------------------------------
	' (로그) 호출 시점과 호출값을 파일에 기록합니다.
	'-----------------------------------------------------------------------------
	Dim xform, receive_str
	receive_str = "sgpay_pay.asp is Called - "
	For Each xform In Request.form
		receive_str = receive_str +  CStr(xform) + " : " + request(xform) + ", "
	Next
	Call Write_Log(receive_str)

	'---------------------------------------------------------------------------------
	' 이전 페이지에서 전달받은 고객 주문번호 설정
	'---------------------------------------------------------------------------------
	Dim customerOrderNumber

	customerOrderNumber = order_num'request("customerOrderNumber")

	'---------------------------------------------------------------------------------
	' 상품정보 변수 선언 및 초기화
	'---------------------------------------------------------------------------------
	Dim OrderNumber, i
	Dim orderQuantity, productUnitPrice, productUnitPaymentPrice, productAmt, productPaymentAmt, TotalProductPaymentAmt
	Dim productName, productPrice, productQuantity, couponPin


	'---------------------------------------------------------------------------------
	' 변수 초기화
	'---------------------------------------------------------------------------------
	TotalProductPaymentAmt = 0		'주문 상품이 여러개일 경우 상품들의 총 금액을 저장할 변수
	OrderNumber = 0					'주문 상품이 여러개일 경우 순번을 매길 변수

	'---------------------------------------------------------------------------------
	' 구매 상품을 변수에 셋팅 ( JSON 문자열을 생성 )
	'---------------------------------------------------------------------------------
	With jsonOrder.data

		'---------------------------------------------------------------------------------
		' 상품정보 값 입력(여러개의 상품일 경우 묶어서 한개의 정보로 포함해서 보내주시면 됩니다. 배송비 포함)
		'---------------------------------------------------------------------------------
		OrderNumber = OrderNumber + 1										' 상품에 순번을 정하기 위해 값을 증가합니다.

		orderQuantity =	1													' (필수) 주문수량 (배송비 상품인 경우 1로 세팅)
		'상품단가(productAmt)는 원 상품단가이고 상품결제단가(productPaymentAmt)는 상품단가에서 할인등을 받은 금액입니다. 실제 결제에는 상품결제단가가 사용됩니다.
		productUnitPrice = AMOUNT											' (필수) 상품 단가 ( 테스트용으로써 70,000원으로 설정. )
		productUnitPaymentPrice = AMOUNT										' (필수) 상품 결제 단가 ( 테스트용으로써 69,000원으로 설정. )

		productAmt = productUnitPrice * orderQuantity						' (필수) 상품 결제금액(상품단가 * 수량)
		productPaymentAmt = productUnitPaymentPrice * orderQuantity			' (필수) 상품 결제금액(상품결제단가 * 수량)
		TotalProductPaymentAmt = TotalProductPaymentAmt + productPaymentAmt	' 주문정보를 구성하기 위한 상품들 누적 결제 금액(상품 결제 금액), 면세금액,과세금액,부가세의 합

		'---------------------------------------------------------------------------------
		' 주문정보 변수 선언
		'---------------------------------------------------------------------------------
		Dim totalOrderAmt, totalDeliveryFeeAmt, totalPaymentAmt
		Dim resultUrl, successUrl
		'---------------------------------------------------------------------------------

		'---------------------------------------------------------------------------------
		' 주문정보 값 입력 ( 가맹점 수정 가능 부분 )
		'---------------------------------------------------------------------------------
		totalOrderAmt = TotalProductPaymentAmt									' (필수) 총 주문금액. 지수형태를 피하고 문자열로 보낼려면 formatnumber(TotalProductPaymentAmt,0,,,0)
		totalDeliveryFeeAmt = DELIVERY_FEE													' 총 배송비(상품가격에 포함).
		totalPaymentAmt = totalOrderAmt+totalDeliveryFeeAmt						' (필수) 총 결재 할 금액.

		returnUrl = AppWebPath & "/pay/sgpay2/sgpay_pay_result.asp"


		'---------------------------------------------------------------------------------
		' 상품정보
		'---------------------------------------------------------------------------------
		Dim productsList, Main_product
		Set productList = New aspJson
		With productList.data
			Dim cJson : Set cJson = JSON.Parse(cart_value)
			Dim iLen : iLen = cJson.length
			For i = 0 To iLen - 1
				productName		= CStr(cJson.get(i).value.nm)
				productPrice		= cJson.get(i).value.price
				productQuantity	= cJson.get(i).value.qty
				couponPin			= cJson.get(i).value.pin
				if i = 0 then Main_product = productName

				If couponPin <> "" Then
					productName	= productName & "[E-쿠폰]"
					productPrice	= 0
				End If

				.Add i, productList.Collection()
				With .item(i)
					.add "name", cstr(productName)
					.add "price", cstr(productPrice)
					.add "quantity", cstr(productQuantity)
				End With
			Next

			' 배달비 전송 추가 | 2020-05-07 | Sewoni31™
			If totalDeliveryFeeAmt <> 0 Then
				.Add iLen, productList.Collection()
				With .item(iLen)
					.add "name", CStr("배달비")
					.add "price", cstr(totalDeliveryFeeAmt)
					.add "quantity", cstr(1)
				End With
			End If

			Main_product = Main_product & " 외 " & cJson.length

		End With
	End With


	'-------------------------------------------------------
	' 1. 파라미터 설정
	'-------------------------------------------------------
	' 입력 파라미터
	corpNo 			= g_CORPNO			        ' [필수] 기업관리번호
	mertNo 			= s_MERTNO					' [필수] 가맹점관리번호	
	corpMemberNo 	= g_corpMemberNo		    ' [필수] 기업(가맹점) 회원번호 - (SEED 암호화 대상필드)
	userMngNo 		= g_userMngNo				' [필수] 간편결제 회원관리번호 - (SEED 암호화 대상필드)
	' response.write "corpMemberNo : " & corpMemberNo & "<BR>"
	' response.write "userMngNo : " & userMngNo & "<BR>"

	orderNo 		= order_num					' [필수] 주문번호
	goodsName 		= Main_product				' [필수] 상품명 - (URL Encoding 대상필드) 
	goodsPrice 		= totalPaymentAmt			' [필수] 상품가격
	products 		= replace(replace(replace(productList.JSONoutput(), chr(13), ""), chr(10), ""), " ", "")	' [필수] 상품 정보 - (URL Encoding 대상필드) 
	buyerName 		= corpMemberNo				' [필수] 구매자명 - (URL Encoding 대상필드) 
	buyerTel 		= ""						' [옵션] 구매자 전화번호
	buyerEmail 		= ""						' [옵션] 구매자 이메일

	disPayUiType 	= "D1"						' [옵션] 결제수단 표시 UI - ('D1':카드,계좌 분리 UI, 'D2':카드,계좌 통합UI)
	payReqUiType 	= "P1"						' [옵션] 결제요청 UI타입 - ('P1':주문정보와 Pin입력 통합 UI, 'P2':Pin번호입력 UI)
	payUniqNo 		= ""						' [옵션] 결제수단 고유번호
	payMethod 		= ""						' [옵션] 결제수단 코드 - ('C':신용카드, 'A':계좌이체)
	bankCardCode 	= ""						' [옵션] 은행/카드 코드
	cardQuota 		= ""						' [옵션] 할부개월수(00:일시불)
	cardInterest 	= ""						' [옵션] 무이자여부(Y/N)
	tax 			= ""						' [옵션] 과세금액(카드 경우만 해당)
	taxFree 		= ""						' [옵션] 비과세금액(카드 경우만 해당)
	settleAmt 		= ""						' [옵션] 정산대상금액
	
	'returnUrl 		= request("returnUrl")		' [필수] 회원가입 결과전달 URL - (URL Encoding 대상필드) 
	
	' 공통 CSS
	content 		= request("content")
	biImgUrl 		= request("biImgUrl")
	bgColor 		= request("bgColor")
	mainColor 		= request("mainColor")
	secuKeypadType 	= request("secuKeypadType")
	
	'-------------------------------------------------------
	' 2. 암호화 대상 필드 Seed 암호화  
	'-------------------------------------------------------
	corpMemberNo 	= seedEncrypt(corpMemberNo, g_SEEDKEY, g_SEEDIV)
	userMngNo 		= seedEncrypt(userMngNo, g_SEEDKEY, g_SEEDIV)
	' response.write "corpMemberNo(E) : " & corpMemberNo & "<BR>"
	' response.write "userMngNo(E) : " & userMngNo & "<BR>"

	'-------------------------------------------------------
	' 3. URLEncode 대상 필드 encode처리(UTF-8)  
	'-------------------------------------------------------
	goodsName 		= Server.URLencode(goodsName)
	products		= Server.URLencode(products)
	buyerName 		= Server.URLencode(buyerName)
	returnUrl 		= Server.URLencode(returnUrl)

	biImgUrl 		= Server.URLencode(biImgUrl)
	content 		= Server.URLencode(content)
	bgColor 		= Server.URLencode(bgColor)
	mainColor 		= Server.URLencode(mainColor)
	secuKeypadType 	= Server.URLencode(secuKeypadType)
	'-------------------------------------------------------
	' 4. 위변조 방지체크를 위한 signature 생성
	'   (순서주의:연동규약서 참고)
	'-------------------------------------------------------
	srcStr = ""
	srcStr = "corpNo=" & corpNo
	srcStr = srcStr & "&mertNo=" & mertNo
	srcStr = srcStr & "&corpMemberNo=" & corpMemberNo
	srcStr = srcStr & "&userMngNo=" & userMngNo
	srcStr = srcStr & "&disPayUiType=" & disPayUiType
	srcStr = srcStr & "&payReqUiType=" & payReqUiType
	srcStr = srcStr & "&payUniqNo=" & payUniqNo
	srcStr = srcStr & "&payMethod=" & payMethod
	srcStr = srcStr & "&bankCardCode=" & bankCardCode
	srcStr = srcStr & "&orderNo=" & orderNo
	srcStr = srcStr & "&goodsName=" & goodsName
	srcStr = srcStr & "&goodsPrice=" & goodsPrice
	srcStr = srcStr & "&products=" & products
	srcStr = srcStr & "&buyerName=" & buyerName
	srcStr = srcStr & "&buyerTel=" & buyerTel
	srcStr = srcStr & "&buyerEmail=" & buyerEmail
	srcStr = srcStr & "&cardQuota=" & cardQuota
	srcStr = srcStr & "&cardInterest=" & cardInterest
	srcStr = srcStr & "&tax=" & tax
	srcStr = srcStr & "&taxFree=" & taxFree
	srcStr = srcStr & "&settleAmt=" & settleAmt
	srcStr = srcStr & "&returnUrl=" & returnUrl
	srcStr = srcStr & "&hashKey=" & g_HASHKEY
	
	signature = SHA256_Encrypt(srcStr)

	Call Write_Log("Web Post   " & GetCurrentHost & request.servervariables("HTTP_url") & " Mode : " & " Param : " & CStr(srcStr))
%>

<!DOCTYPE html>
<html>
<body onload="document.getElementById('SendPayForm_id').submit();">
<form id="SendPayForm_id" name="SendPayForm" method="POST" action="<%=sgpay_PaymentUrl%>">
	<input type="hidden" name="corpNo"			id="corpNo" 		value="<%=corpNo%>">
	<input type="hidden" name="mertNo"			id="mertNo" 		value="<%=mertNo%>">
	<input type="hidden" name="corpMemberNo"	id="corpMemberNo" 	value="<%=corpMemberNo%>">
	<input type="hidden" name="userMngNo"		id="userMngNo" 		value="<%=userMngNo%>">
	<input type="hidden" name="disPayUiType"	id="disPayUiType" 	value="<%=disPayUiType%>">
	<input type="hidden" name="payReqUiType"	id="payReqUiType" 	value="<%=payReqUiType%>">
	<input type="hidden" name="payUniqNo"		id="payUniqNo" 		value="<%=payUniqNo%>">
	<input type="hidden" name="payMethod"		id="payMethod" 		value="<%=payMethod%>">
	<input type="hidden" name="bankCardCode"	id="bankCardCode" 	value="<%=bankCardCode%>">
	<input type="hidden" name="orderNo"			id="orderNo" 		value="<%=orderNo%>">
	<input type="hidden" name="goodsName"		id="goodsName" 		value="<%=goodsName%>">
	<input type="hidden" name="goodsPrice"		id="goodsPrice" 	value="<%=goodsPrice%>">
	<input type="hidden" name="products"		id="products" 		value="<%=products%>">
	<input type="hidden" name="buyerName"		id="buyerName" 		value="<%=buyerName%>">
	<input type="hidden" name="buyerTel"		id="buyerTel" 		value="<%=buyerTel%>">
	<input type="hidden" name="buyerEmail"		id="buyerEmail" 	value="<%=buyerEmail%>">
	<input type="hidden" name="cardQuota"		id="cardQuota" 		value="<%=cardQuota%>">
	<input type="hidden" name="cardInterest"	id="cardInterest" 	value="<%=cardInterest%>">
	<input type="hidden" name="tax"				id="tax" 			value="<%=tax%>">
	<input type="hidden" name="taxFree"			id="taxFree" 		value="<%=taxFree%>">
	<input type="hidden" name="settleAmt"		id="settleAmt" 		value="<%=settleAmt%>">
	<input type="hidden" name="returnUrl" 		id="returnUrl" 		value="<%=returnUrl%>">
	<input type="hidden" name="signature" 		id="signature" 		value="<%=signature%>">
	<input type="hidden" name="biImgUrl"		id="biImgUrl" 		value="<%=biImgUrl%>">
	<input type="hidden" name="content"			id="content" 		value="<%=content%>">
	<input type="hidden" name="bgColor"			id="bgColor" 		value="<%=bgColor%>">
	<input type="hidden" name="mainColor"		id="mainColor" 		value="<%=mainColor%>">
	<input type="hidden" name="secuKeypadType"	id="secuKeypadType" value="<%=secuKeypadType%>">
</form>
</body>
</html>