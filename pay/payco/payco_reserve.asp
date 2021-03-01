<!--#include file="payco_config.asp"-->
<!--#include virtual="/api/include/db_open.asp"-->
<!--#include virtual="/api/include/func.asp"-->
<%
	'-----------------------------------------------------------------------------
	' PAYCO 주문 예약 페이지 샘플 ( ASP )
	' payco_reserve.asp
	' 2015-04-20	PAYCO기술지원 <dl_payco_ts@nhnent.com>
	'-----------------------------------------------------------------------------

	'-----------------------------------------------------------------------------
	' 이 문서는 json 형태의 데이터를 반환합니다.
	'-----------------------------------------------------------------------------
	Response.ContentType = "application/json"

	' 비비큐 주문정보 셋팅
	gubun = GetReqStr("gubun","")
    domain = GetReqStr("domain","")
    branch_id = GetReqStr("branch_id","")

	If branch_id = "" Then
%>
<script>
	alert('매장정보가 없습니다.');
    if(window.opener) {
        self.close();
    } else {
        history.back();
    }
</script>
<%
		response.End
	End If

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

	vUseDANAL = "N"
	vUsePAYCO = "N"

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

		if UCase(appMode) <> "TEST" then
			sellerKey				=	vPayco_Seller'"S0FSJE"									'(필수) 가맹점 코드 - 파트너센터에서 알려주는 값으로, 초기 연동 시 PAYCO에서 쇼핑몰에 값을 전달한다.
			cpId					=	vPayco_Cpid'"PARTNERTEST"								'(필수) 상점ID, 30자 이내
			productId				=	vPayco_Itemcd'"PROD_EASY"									'(필수) 상품ID, 50자 이내
		Else
			sellerKey				=	"S0FSJE"									'(필수) 가맹점 코드 - 파트너센터에서 알려주는 값으로, 초기 연동 시 PAYCO에서 쇼핑몰에 값을 전달한다.
			cpId					=	"PARTNERTEST"								'(필수) 상점ID, 30자 이내
			productId				=	"PROD_EASY"									'(필수) 상품ID, 50자 이내
		End If
		
		If vPayco_Seller = "" Then
%>
<script>
	alert('페이코 간편결제 가맹점이 아닙니다.');
    if(window.opener) {
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
	alert('매장정보가 없습니다.');
    if(window.opener) {
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

    'If gubun = "Order" Then
        order_idx = GetReqNum("order_idx", "")
        order_num = GetReqStr("order_num","")
        pay_method = GetReqStr("pay_method","")
        'sellerKey = GetReqStr("p_seller","")
        'cpId = GetReqStr("p_cpid","")
        'productId = GetReqStr("p_itemcd","")

        Response.Cookies("GUBUN") = gubun
        response.Cookies("ORDER_IDX") = order_idx
        
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
        ItemName = "BBQ Chicken"

        If Not (pRs.BOF Or pRs.EOF) Then
            USER_ID = pRs("member_idno")
            SUBCPID = pRs("danal_h_scpid")
            AMOUNT = pRs("order_amt")+pRs("delivery_fee")-pRs("discount_amt")
        Else
            USER_ID = ""
            SUBCPID = ""
            AMOUNT = ""
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

    'ElseIf gubun = "Charge" Then
    '    ItemName = "BBQCard Charge"
    '    SUBCPID = ""

    '    cardSeq = GetReqStr("card_seq","")

    '    Response.Cookies("GUBUN") = gubun
    '    Response.Cookies("CARD_SEQ") = cardSeq

    '    order_num = "P"&RIGHT("0000000" & cardSeq, 7)
    '    Set pCmd = Server.CreateObject("ADODB.Command")
    '    With pCmd
    '        .ActiveConnection = dbconn
    '        .NamedParameters = True
    '        .CommandType = adCmdStoredProc
    '        .CommandText = "bp_payco_card_select_one"

    '        .Parameters.Append .CreateParameter("@seq", adInteger, adParamInput, , cardSeq)

    '        Set pRs = .Execute
    '    End With
    '    Set pCmd = Nothing

    '    If Not(pRs.BOF Or pRs.EOF) Then
    '        USER_ID = pRs("member_idno")
    '        AMOUNT = pRs("charge_amount")
    '    Else
    '        USER_ID = ""
    '        AMOUNT = ""
    '    End If
    'ElseIf gubun = "Gift" Then
    '    ItemName = "BBQCard Gift"

    '    cardSeq = GetReqStr("card_seq","")

    '    Response.Cookies("GUBUN") = gubun
    '    Response.Cookies("CARD_SEQ") = cardSeq

    '    order_num = "P"&RIGHT("0000000" & cardSeq, 7)
    '    Set pCmd = Server.CreateObject("ADODB.Command")
    '    With pCmd
    '        .ActiveConnection = dbconn
    '        .NamedParameters = True
    '        .CommandType = adCmdStoredProc
    '        .CommandText = "bp_payco_card_select_one"

    '        .Parameters.Append .CreateParameter("@seq", adInteger, adParamInput, , cardSeq)

    '        Set pRs = .Execute
    '    End With
    '    Set pCmd = Nothing

    '    If Not(pRs.BOF Or pRs.EOF) Then
    '        USER_ID = pRs("member_idno")
    '        AMOUNT = pRs("charge_amount")
    '    Else
    '        USER_ID = ""
    '        AMOUNT = ""
    '    End If
    'End If
    
    userAgent = ""
    Select Case domain
        Case "pc": userAgent = "WP" 
        Case "mobile": userAgent = "WM"
    End Select

	'-----------------------------------------------------------------------------
	' (로그) 호출 시점과 호출값을 파일에 기록합니다.
	'-----------------------------------------------------------------------------
	Dim xform, receive_str
	receive_str = "payco_reserve.asp is Called - "
	For Each xform In Request.form
		receive_str = receive_str +  CStr(xform) + " : " + request(xform) + ", "
	Next
	Call Write_Log(receive_str)

	'---------------------------------------------------------------------------------
	' 이전 페이지에서 전달받은 고객 주문번호 설정
	'---------------------------------------------------------------------------------
	Dim customerOrderNumber
	Dim strJson

	customerOrderNumber = order_num'request("customerOrderNumber")		

	'---------------------------------------------------------------------------------
	' 상품정보 변수 선언 및 초기화
	'---------------------------------------------------------------------------------
	Dim OrderNumber, i
	Dim orderQuantity, productUnitPrice, productUnitPaymentPrice, productAmt, productPaymentAmt, TotalProductPaymentAmt
	Dim iOption, sortOrdering
	Dim productName, productInfoUrl, orderConfirmUrl, orderConfirmMobileUrl, productImageUrl, sellerOrderProductReferenceKey
	Dim jsonOrder
	Dim taxationType, unitTaxfreeAmt, unitTaxableAmt, unitVatAmt
	Dim totalTaxfreeAmt, totalTaxableAmt, totalVatAmt
	'---------------------------------------------------------------------------------

	'---------------------------------------------------------------------------------
	' 변수 초기화
	'---------------------------------------------------------------------------------
	TotalProductPaymentAmt = 0		'주문 상품이 여러개일 경우 상품들의 총 금액을 저장할 변수
	OrderNumber = 0					'주문 상품이 여러개일 경우 순번을 매길 변수
	totalTaxfreeAmt = 0				'총 면세 금액
	totalTaxableAmt = 0				'총 과세 공급가액
	totalVatAmt = 0					'총 과세 부가세액

	'---------------------------------------------------------------------------------
	' 구매 상품을 변수에 셋팅 ( JSON 문자열을 생성 )
	'---------------------------------------------------------------------------------
	Set jsonOrder = New aspJson			'JSON 을 작성할 OBJECT 선언

	With jsonOrder.data
		.Add "orderProducts", jsonOrder.Collection()						' (필수) 주문서에 담길 상품 목록 생성

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
		
		iOption = "245"														' 옵션 ( 최대 100 자리 )
		sortOrdering = OrderNumber											' (필수) 상품노출순서, 10자 이내
		productName = "BBQ Chicken"	' (필수) 상품명, 4000자 이내
		orderConfirmUrl = ""												' 주문완료 후 주문상품을 확인할 수 있는 url, 4000자 이내
		orderConfirmMobileUrl = ""											' 주문완료 후 주문상품을 확인할 수 있는 모바일 url, 1000자 이내
		productImageUrl = ""												' 이미지URL (배송비 상품이 아닌 경우는 필수), 4000자 이내, productImageUrl에 적힌 이미지를 썸네일해서 PAYCO 주문창에 보여줍니다.
		sellerOrderProductReferenceKey = "ITEM_100001"						' 외부가맹점에서 관리하는 주문상품 연동 키(sellerOrderProductReferenceKey)는 상품 별로 고유한 key이어야 합니다.)
		taxationType = "TAXATION"											' 과세타입(기본값 : 과세). DUTYFREE :면세, COMBINE : 결합상품, TAXATION : 과세

		'---------------------------------------------------------------------------------
		' 상품별 과세정보 설정
		'---------------------------------------------------------------------------------
		Select Case taxationType
			Case "TAXATION"													' 과세일경우
				unitTaxfreeAmt = 0													' 개별상품단위 면세 금액은 0 원으로 설정
				unitTaxableAmt = Round(productUnitPaymentPrice / 1.1, 0)			' 개별상품단위 상품금액으로 공급가액 계산
				unitVatAmt = Round((productUnitPaymentPrice / 1.1) * 0.1, 0 )		' 개별상품단위 상품금액으로 부가세액 계산
				If Not unitTaxableAmt + unitVatAmt = productUnitPaymentPrice Then	' 개별상품단위 공급가액과 부가세액을 더했을 경우 상품금액과 일치하지 않으면 
					unitTaxableAmt = productUnitPaymentPrice - unitVatAmt		' 공급가액에 1원을 더해 맞춤.
				End If
			Case "DUTYFREE"													' 면세일경우
				unitTaxfreeAmt = productUnitPaymentPrice					' 개별상품단위 면세금액에 상품금액 전체를 넣음.
				unitTaxableAmt = 0											' 개별상품단위 공급가액은 0 원
				unitVatAmt = 0												' 개별상품단위 부가세액은 0 원
			Case "COMBINE"													' 복합상품일 경우는
				unitTaxfreeAmt = 36000										' 개별상품단위 상품금액에서 면세 금액 부분을 입력. ( 샘플에서는 36,000으로 설정 )
				unitTaxableAmt = 30000										' 개별상품단위 공급가액을 입력.( 샘플에서는 30,000으로 설정 )
				unitVatAmt = 3000											' 개별상품단위 부가세액을 입력.( 샘플에서는  3,000으로 설정 )
		End Select

		totalTaxfreeAmt = totalTaxfreeAmt + unitTaxfreeAmt					'총 면세 금액 추가
		totalTaxableAmt = totalTaxableAmt + unitTaxableAmt					'총 과세 공급가액 추가
		totalVatAmt = totalVatAmt + unitVatAmt								'총 과세 부가세액 추가

		'---------------------------------------------------------------------------------
		' 상품값으로 읽은 변수들로 Json String 을 작성합니다.
		'---------------------------------------------------------------------------------
		With jsonOrder.data("orderProducts")
			.Add OrderNumber-1, jsonOrder.Collection()
			With .item(OrderNumber-1)
				.add "cpId",  CStr(cpId)
				.add "productId", CStr(productId)
				.add "productAmt", productAmt
				.add "productPaymentAmt", productPaymentAmt
				.add "orderQuantity", orderQuantity
				.add "option", CStr(iOption)
				.add "sortOrdering", sortOrdering
				.add "productName", CStr(productName)
				.add "orderConfirmUrl", CStr(orderConfirmUrl)
				.add "orderConfirmMobileUrl", CStr(orderConfirmMobileUrl)
				.add "productImageUrl", CStr(productImageUrl)
				.add "sellerOrderProductReferenceKey", CStr(sellerOrderProductReferenceKey)
				.add "taxationType", CStr(taxationType)
			End With
		End With

		'---------------------------------------------------------------------------------
		' 주문정보 변수 선언
		'---------------------------------------------------------------------------------
		Dim sellerOrderReferenceKey, sellerOrderReferenceKeyType
		Dim iCurrency
		Dim totalOrderAmt, totalDeliveryFeeAmt, totalPaymentAmt
		Dim orderSheetUiType
		Dim orderTitle, returnUrl, returnUrlParam, nonBankbookDepositInformUrl
		Dim orderChannel, inAppYn, customUrlSchemeUseYn
		Dim individualCustomNoInputYn, extraData
		Dim payExpiryYmdt, virtualAccountExpiryYmd, appUrl, cancelMobileUrl
		Dim paymentMethodOptions
		'---------------------------------------------------------------------------------

		'---------------------------------------------------------------------------------
		' 주문정보 값 입력 ( 가맹점 수정 가능 부분 )
		'---------------------------------------------------------------------------------
		sellerOrderReferenceKey = customerOrderNumber							' (필수) 외부가맹점의 주문번호
		sellerOrderReferenceKeyType	= "UNIQUE_KEY"								' 외부가맹점의 주문번호 타입(String 50) UNIQUE_KEY 유니크 키 - 기본값, DUPLICATE_KEY 중복 가능한 키( 외부가맹점의 주문번호가 중복 가능한 경우 사용)
		iCurrency = "KRW"														' 통화(default=KRW)
		totalOrderAmt = TotalProductPaymentAmt									' (필수) 총 주문금액. 지수형태를 피하고 문자열로 보낼려면 formatnumber(TotalProductPaymentAmt,0,,,0)
		totalDeliveryFeeAmt = 0													' 총 배송비(상품가격에 포함).
		totalPaymentAmt = totalOrderAmt+totalDeliveryFeeAmt						' (필수) 총 결재 할 금액.
		orderTitle = "BBQ Chicken"							' 주문 타이틀
		returnUrl = AppWebPath+"/payco_return.asp"								' 주문완료 후 Redirect 되는 Url
		Set returnUrlParam = New aspJson										' 주문완료 후 Redirect 되는 Url 에 함께 전달되어야 하는 파라미터

'		--------------------------------------------------------------------------------
'		여러개의 값을 보낼 경우 아래부분 주석 해제하고 더 아래 부분 주석 처리 
		With returnUrlParam.data											' (payco_reserve.asp에서 payco_return.asp로 전달할 값을 JSON 형태의 문자열로 전달)
			.add "taxationType",     CStr(taxationType)						' taxationType 라는 필드에 taxationType 값을 보냄.
			.add "totalTaxfreeAmt",  CStr(totalTaxfreeAmt)					' totalTaxfreeAmt 라는 필드에 totalTaxfreeAmt 값을 보냄.
			.add "totalTaxableAmt",  CStr(totalTaxableAmt)					' totalTaxableAmt 라는 필드에 totalTaxableAmt 값을 보냄.
			.add "totalVatAmt",      CStr(totalVatAmt)						' totalVatAmt 라는 필드에 totalVatAmt 값을 보냄.
		End With
'		--------------------------------------------------------------------------------

'		--------------------------------------------------------------------------------
'		한개의 값이 배열일 경우 아래부분 주석 해제하고 위에 부분 주석 처리 
'		Dim ArrayStringReturn(2)
'		ArrayStringReturn(0) = "001001"
'		ArrayStringReturn(1) = "001002"
'		ArrayStringReturn(2) = "001003"
'		With returnUrlParam.data
'			.add "SAMPLE_RETURN_PARAM", jsonOrder.Collection()
'			With returnUrlParam.data("SAMPLE_RETURN_PARAM")
'				For i=0 To Ubound(ArrayStringReturn)					' SAMPLE_RETURN_PARAM 라는 필드에 001001, 001002, 001003 이라는 배열값을 루프롤 돌면서 보냄.
'					.Add i, "'" + CStr(ArrayStringReturn(i)) + "'"		' PAY2는 returnURL 에서 결과값을 받을때 쌍따옴표를 받을 수 없는 현상을 감안하여 대체 문자로 감싸서 보냄. 
'																		' returnURL 에서 대체문자를 쌍따옴표로 replace를 해야함. 
'																		' 단, ArrayStringReturn(i) 문자열 안에 대체문자 자체가 존재하면 오류가 발생할 수 있으니 절대로 들어갈 수 없는 문자로 설정할 것. 
'																		' 예제는 싱글따옴표를 사용. 
'																		' 대체문자를 사용하지 않으면 001001 과 같은 문자열을 보냈을 경우 1001 처럼 숫자로 바뀌는 현상이 존재함.
'				Next
'			End With
'		End With
'		--------------------------------------------------------------------------------

		'nonBankbookDepositInformUrl = GetCurrentHost & "/pay/payco/payco_without_bankbook.asp"	'무통장입금완료통보 URL
		nonBankbookDepositInformUrl = "http://xxx.xxx.xxx.xxx/payco_without_bankbook.asp"	'무통장입금완료통보 URL
		orderChannel = WebMode													' 주문채널 ( default : PC / MOBILE )

		If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqiOS") > 0 Or instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Then
			inAppYn = "Y"

			If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqiOS") > 0 Then
				appUrl = "bbqchickenApp://open"																' IOS 인앱 결제시 ISP 모바일 등의 앱에서 결제를 처리한 뒤 복귀할 앱 URL
			End If
		Else
			inAppYn = "N"															' 인앱결제 여부( Y/N ) ( default = N )
			appUrl = ""																' IOS 인앱 결제시 ISP 모바일 등의 앱에서 결제를 처리한 뒤 복귀할 앱 URL
		End If

		individualCustomNoInputYn = "N"											' 개인통관고유번호 입력 여부 ( Y/N ) ( default = N )
 		orderSheetUiType = "GRAY"												' 주문서 UI 타입 선택 ( 선택 가능값 : RED / GRAY )

		'---------------------------------------------------------------------------------
		' 주문서에 담길 부가 정보( extraData ) 를 JSON 으로 작성
		'---------------------------------------------------------------------------------
		'payExpiryYmdt = "20161231145200"										' 해당 주문예약건 만료 처리 일시 (해당일시 이후에는 결제 불가) Ex. "20150210180000"
		'virtualAccountExpiryYmd = "20161231"									' 가상계좌만료일시. ( YYYYMMDD or YYYYMMDDHHmmss, Default 3일, YYYYMMDD 일 경우 그날 24시 만료. )
		'appUrl = ""																' IOS 인앱 결제시 ISP 모바일 등의 앱에서 결제를 처리한 뒤 복귀할 앱 URL
		if WebMode = "MOBILE" Then
			cancelMobileUrl = urlProtocol & "://" & Request.ServerVariables("HTTP_HOST") & +"/order/cart.asp?cancel_idx="&order_idx'"history.Back();"'AppWebPath+"/index.asp"							' (모바일이면 필수) 모바일 결제페이지에서 취소 버튼 클릭시 이동할 URL ( 결제창 이전 URL등 ).
			'cancelMobileUrl = ""
																				' 1순위 : (앱결제인 경우) 주문예약 > customUrlSchemeUseYn 의 값이 Y인 경우 => "nebilres://orderCancel" 으로 이동
																				' 2순위 : 주문예약 > extraData > cancelMobileUrl 값이 있을시 => cancelMobileUrl 이동
																				' 3순위 : 주문예약시 전달받은 returnUrl 이동 + 실패코드(오류코드:2222)
																				' 4순위 : 가맹점 URL로 이동(가맹점등록시 받은 사이트URL)
																				' 5순위 : 이전 페이지로 이동 => history.Back();
		Else
			cancelMobileUrl = ""
		End if

		Set extraData = New aspJson
		With extraData.data
			.add "payExpiryYmdt",  CStr(payExpiryYmdt)						
			.add "cancelMobileUrl", CStr(cancelMobileUrl)
			If Not appUrl = "" Then	.Add "appUrl", CStr(appUrl)
			.add "viewOptions", extraData.Collection()
			With extraData.data("viewOptions")
				.add "showMobileTopGnbYn", CStr("N")								' 모바일 상단 GNB 노출여부
				.add "iframeYn", CStr("N")											' Iframe 으로 호출 여부
			End with
		End With

		'---------------------------------------------------------------------------------
		' 설정한 주문정보들을 Json String 을 작성합니다.
		'---------------------------------------------------------------------------------
														.Add "sellerKey", CStr(sellerKey)
														.Add "sellerOrderReferenceKey", CStr(sellerOrderReferenceKey)
		If Not sellerOrderReferenceKeyType = "" Then	.Add "sellerOrderReferenceKeyType", CStr(sellerOrderReferenceKeyType)
		If Not iCurrency = "" Then						.Add "currency", CStr(iCurrency)
														.Add "totalPaymentAmt", totalPaymentAmt
														'---------------------------------------------------------------------------------
														' 세금 정보 입력
														'---------------------------------------------------------------------------------
														.Add "totalTaxfreeAmt", CStr(totalTaxfreeAmt)
														.Add "totalTaxableAmt", CStr(totalTaxableAmt)
														.Add "totalVatAmt", CStr(totalVatAmt)
		If Not orderTitle = "" Then						.Add "orderTitle", CStr(orderTitle)
		If Not returnUrl = "" Then						.Add "returnUrl", CStr(returnUrl)
														.Add "returnUrlParam", CStr(returnUrlParam.JSONoutput())
		If Not nonBankbookDepositInformUrl = "" Then	.Add "nonBankbookDepositInformUrl", CStr(nonBankbookDepositInformUrl)
														.Add "orderMethod", CStr(orderMethod)
		If Not orderChannel = "" Then					.Add "orderChannel", CStr(orderChannel)
		If Not inAppYn = "" Then						.Add "inAppYn", CStr(inAppYn)
		If Not individualCustomNoInputYn = "" Then		.Add "individualCustomNoInputYn", CStr(individualCustomNoInputYn)
		If Not orderSheetUiType = "" Then				.Add "orderSheetUiType", CStr(orderSheetUiType)
		If Not payMode = "" Then						.Add "payMode", CStr(payMode)
														.Add "extraData", CStr(extraData.JSONoutput())
	End With 

	
	Dim Result
	'---------------------------------------------------------------------------------
	' 주문 예약 함수 호출 ( JSON 데이터를 String 형태로 전달 )
	'---------------------------------------------------------------------------------
	Result = payco_reserve(jsonOrder.JSONoutput())
	'---------------------------------------------------------------------------------
	' 결과 그대로를 호출쪽에 반환
	'---------------------------------------------------------------------------------
	Response.Write Result
%>