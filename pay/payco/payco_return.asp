<!--#include file="payco_config.asp"-->
<!--#include virtual="/api/include/g2.asp"-->
<!--#include virtual="/api/include/cv.asp"-->
<!--#include virtual="/includes/cv.asp"-->
<!--#include virtual="/api/include/json2.asp"-->
<!--#include virtual="/api/include/db_open.asp"-->
<!--#include virtual="/api/include/func.asp"-->
<!--#include virtual="/api/call_api.asp"-->
<!--#include virtual="/api/include/classes.asp"-->
<!--#include virtual="/api/membership.asp"-->
<!--#include virtual="/api/barcode/barcode.asp"-->
<!--#include virtual="/pay/coupon_use.asp"-->
<!--#include virtual="/pay/coupon_use_coop.asp"-->
<!--#include virtual="/api/include/inc_encrypt.asp"-->
<%
	'-----------------------------------------------------------------------------
	' PAYCO 주문완료시 호출되는 가맹점 SERVICE API 페이지 샘플 ( ASP )
	' payco_return.asp
	' 2015-03-25	PAYCO기술지원 <dl_payco_ts@nhnent.com>
	'-----------------------------------------------------------------------------

	'-----------------------------------------------------------------------------
	' 이 문서는 text/html 형태의 데이터를 반환합니다.
	'-----------------------------------------------------------------------------
	Response.ContentType = "text/html"

    order_idx = Request.Cookies("ORDER_IDX")

	'-----------------------------------------------------------------------------
	' (로그) 호출 시점과 호출값을 파일에 기록합니다.
	'-----------------------------------------------------------------------------
	Dim xQuery, receive_str
	receive_str = "payco_return.asp is Called - "
	receive_str = receive_str +  "POST DATA : "
	For Each xQuery In Request.Form
		receive_str = receive_str +  CStr(xQuery) + " : " + request(xQuery) + ", "
	Next
	receive_str = receive_str +  "GET DATA : "
	For Each xQuery In Request.QueryString
		receive_str = receive_str +  CStr(xQuery) + " : " + request(xQuery) + ", "
	Next
	Call Write_Log(receive_str)

	'-----------------------------------------------------------------------------
	' 오류가 발생했는지 기억할 변수와 결과를 담을 변수를 선언합니다.
	'-----------------------------------------------------------------------------
	Dim doApproval, resultValue
	Dim Read_code, Read_message
	Dim certify_reserveOrderNo, certify_sellerOrderReferenceKey, certify_paymentCertifyToken, certify_TotalPaymentAmt
	Dim returnUrlParam, returnUrlParam1, returnUrlParam2, returnUrlParam3

	doApproval = false											'기본적으로 승인을 받지 않는것으로 설정 (미사용 확인)

	'주문예약시 전달한 returnUrlParam 의 처리
	'---------------------------------------------------------------------------------
	'주문예약시 값을 여러개로 보냈을때 읽는 방법
	Dim taxationType, totalTaxfreeAmt, totalTaxableAmt, totalVatAmt
	taxationType = Request("taxationType")											' returnUrlParam 값으로 넘겨 받은 값
	totalTaxfreeAmt = Request("totalTaxfreeAmt")									' returnUrlParam 값으로 넘겨 받은 값
	totalTaxableAmt = Request("totalTaxableAmt")									' returnUrlParam 값으로 넘겨 받은 값
	totalVatAmt = Request("totalVatAmt")											' returnUrlParam 값으로 넘겨 받은 값
	'---------------------------------------------------------------------------------

	'---------------------------------------------------------------------------------
	'주문예약시 한개의 값에 배열로 보냈을때 읽는 방법(받은 값을 JSON 에 넣어서 읽음)
'		returnUrlParam = Request("SAMPLE_RETURN_PARAM")
'		Set Read_Data = New aspJSON
'		Call Write_Log("payco_return.asp receive json SAMPLE_RETURN_PARAM Origin : " + "SAMPLE_RETURN_PARAM : " + returnUrlParam)
'			Read_Data.loadJSON("{ ""SAMPLE_RETURN_PARAM"" : [" + Replace(returnUrlParam,"'","""") + "]}")
'		Call Write_Log("payco_return.asp receive json SAMPLE_RETURN_PARAM : " + Read_Data.JSONoutput())
'		Call Write_Log("payco_return.asp receive json SAMPLE_RETURN_PARAM(0) : " + CStr(Read_Data.data("SAMPLE_RETURN_PARAM").item(0)))
'		Call Write_Log("payco_return.asp receive json SAMPLE_RETURN_PARAM(1) : " + CStr(Read_Data.data("SAMPLE_RETURN_PARAM").item(1)))
'		Call Write_Log("payco_return.asp receive json SAMPLE_RETURN_PARAM(2) : " + CStr(Read_Data.data("SAMPLE_RETURN_PARAM").item(2)))
	'--------------------------------------------------------------------------------

	'호출 성공여부 읽기
	Read_code = Request("code")
	'-----------------------------------------------------------------------------
	' Read_code 값이 0 또는 2222, 또는 실패시 오류코드 값 중 하나가 옵니다.
	' 0 - 결제 인증 성공
	' 2222 - 사용자에 의한 결제 취소
	' 내역을 표시하고 창을 닫습니다.
	'-----------------------------------------------------------------------------
	If Not Read_code = "0" Then
		Read_message = Request("message")
		If CStr(Read_code) = "2222" Then Read_message = "사용자에 의해 취소되었음."
		resultValue = "Code : "+CStr(Read_code)+", message : " + CStr(Read_message)
		Call Write_Log("payco_return.asp is canceled : " + CStr(resultValue))

		Set resMC = OrderCancelListForOrder(order_idx)

		If resMC.mCode = 0 Then
			paycoDone = True
		End If
		%>
		<html>
			<head>
				<title>주문 취소</title>
				<script type="text/javascript">
					alert("<%=Read_message%>");
					<%
						If paycoDone then
							order_idx = ""
						End If

						if WebMode = "MOBILE" Or Request.ServerVariables("HTTP_HOST") = "m.bbq.co.kr" Or Request.ServerVariables("HTTP_HOST") = "mtest.bbq.co.kr" Or Request.ServerVariables("HTTP_HOST") = "bbq.fuzewire.com:8010" then	%>
							//location.href = "/order/payment.asp<%'=AppWebPath+"/index.asp"%>";
							location.href = "/order/cart.asp?cancel_idx=<%=order_idx%>";
					<%  else %>
							// opener.location.href = "<%=AppWebPath+"/index.asp"%>";

							<% If Not paycoDone then %>
								opener.parent.cancelMembership();
							<% End If %>
							window.close();
					<%  end if %>
				</script>
			</head>
		</html>
		<% 
		Response.End											'페이지 종료
	End If 

	'성공시 인증 정보 설정
	certify_reserveOrderNo = Request("reserveOrderNo")						' 주문예약번호
	certify_sellerOrderReferenceKey = Request("sellerOrderReferenceKey")	' 외부가맹점에서 관리하는 주문연동 Key
	certify_TotalPaymentAmt = Request("TotalPaymentAmt")					' 총 결제 금액
	certify_paymentCertifyToken = Request("paymentCertifyToken")			' PAYCO에서 발급한 결제인증토큰 - 결제승인시 필요

	Dim ErrMessage

	'처리 결과를 성공으로 가정
	doApproval = True
	ErrMessage = ""
	'On Error Resume Next															'제일 하단 Err.Number 로 오류 체크 하기 위해 사용됩니다.
	'★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
	'★★★★★★★★★★                                                     ★★★★★★★★★★
	'★★★★★★★★★★                    중요 사항                         ★★★★★★★★★★
	'★★★★★★★★★★                                                     ★★★★★★★★★★
	'★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
	'
	' 총 금액 결제된 금액을 주문금액과 비교.(반드시 필요한 검증 부분.)
	' 주문금액을 변조하여 결제를 시도 했는지 확인함.(반드시 DB에서 읽어야 함.)
	' 금액이 변조되었으면 반드시 승인을 취소해야 함.
	'
	'★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
	Dim myDBtotalValue

	'myDBtotalValue = 69000													'DB에서 주문시 주문했던 총 금액(PAYCO 에 주문예약할때 던졌던 값.)을 가져옵니다.(주문값)

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

	Dim shopInfoError
	shopInfoError = false

	'-----------------------------------------------------------------------------
	' 오류 확인용 변수 선언
	'-----------------------------------------------------------------------------
	Dim RaiseError
	RaiseError = False

	If Not (pRs.BOF Or pRs.EOF) Then
		USER_ID = pRs("member_idno")
		MEMBER_IDX = pRs("member_id")
		MEMBER_TYPE = pRs("member_type")

		order_num = pRs("order_num")

		PAYAMOUNT = pRs("order_amt")+pRs("delivery_fee")
		AMOUNT = PAYAMOUNT-pRs("discount_amt")
		branch_id = pRs("branch_id")

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

			If appMode <> "TEST" Then
				sellerKey				=	vPayco_Seller'"S0FSJE"									'(필수) 가맹점 코드 - 파트너센터에서 알려주는 값으로, 초기 연동 시 PAYCO에서 쇼핑몰에 값을 전달한다.
				cpId					=	vPayco_Cpid'"PARTNERTEST"								'(필수) 상점ID, 30자 이내
				productId				=	vPayco_Itemcd'"PROD_EASY"									'(필수) 상품ID, 50자 이내
			Else 
				sellerKey				=	"S0FSJE"									'(필수) 가맹점 코드 - 파트너센터에서 알려주는 값으로, 초기 연동 시 PAYCO에서 쇼핑몰에 값을 전달한다.
				cpId					=	"PARTNERTEST"								'(필수) 상점ID, 30자 이내
				productId				=	"PROD_EASY"									'(필수) 상품ID, 50자 이내
			End If 
			If vPayco_Seller = "" Then
				shopInfoError = True
				ErrMessage = "매장정보가 잘못되었습니다."

				Set aRs = Nothing
				'response.End
			End If
		Else
			shopInfoError = True
			ErrMessage = "매장정보가 없습니다."

			Set aRs = Nothing
			'response.End
		End If
	Else
		ORDER_NUM = ""
		USER_ID = ""
		MEMBER_IDX = 0
		MEMBER_TYPE = ""
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


	Set pRs = Nothing

	' 주문내에 e쿠폰 사용여부 체크 ##################
	Dim CouponUseCheck : CouponUseCheck = "N"
	dim cl_eCoupon : set cl_eCoupon = new eCoupon
	dim cl_eCouponCoop : set cl_eCouponCoop = new eCouponCoop

	Set pinCmd = Server.CreateObject("ADODB.Command")
	with pinCmd
		.ActiveConnection = dbconn
		.CommandText = "bp_order_detail_select_ecoupon"
		.CommandType = adCmdStoredProc

		.Parameters.Append .CreateParameter("@ORDER_IDX", adInteger, adParamInput, , order_idx)
		Set pinRs = .Execute
	End With
	Set pinCmd = Nothing

	If Not (pinRs.BOF Or pinRs.EOF) Then
		prefix_coupon_no = LEFT(pinRs("coupon_pin"), 1)
	end if 
	
	Set pinRs = Nothing

	If prefix_coupon_no = "6" or prefix_coupon_no = "8" Then		'COOP coupon prefix 
		eCouponType = "Coop"
	Else 
		eCouponType = "KTR"
	End If

	If eCouponType = "Coop" Then
		cl_eCouponCoop.Coop_Check_Order_Coupon order_idx, dbconn
		if cl_eCouponCoop.m_cd = "0" then
			CouponUseCheck = "N"
		else
			CouponUseCheck = "Y"
		end if
	Else
		cl_eCoupon.KTR_Check_Order_Coupon order_idx, dbconn                  
		if cl_eCoupon.m_cd = "0" then
			CouponUseCheck = "N"
		else
			CouponUseCheck = "Y"
		end if
	End If 

	If (Not CStr(certify_TotalPaymentAmt) = CStr(AMOUNT)) or (Not CStr(certify_sellerOrderReferenceKey) = CStr(order_num)) Then		'위에서 파라메터로 받은 certify_TotalPaymentAmt 값과 주문값이 같은지 비교합니다. 
																			'( 연동 실패를 테스트 하시려면 값을 주문값을 certify_TotalPaymentAmt 값과 틀리게 설정하세요. )
		doApproval = false
		RaiseError = true
		ErrMessage = "주문금액("+CStr(myDBtotalValue)+")과 결제금액("+CStr(certify_TotalPaymentAmt)+")이 틀립니다."
		
	ElseIf CouponUseCheck = "Y" Then 

		doApproval = false
		RaiseError = true
		ErrMessage = "주문내용에 이미 사용된 쿠폰이 있습니다"

	Else
		'-----------------------------------------------------------------------------
		' 처리 결과가 정상이면 PAYCO 에 인증 받았던 정보로 결제 승인을 요청
		'-----------------------------------------------------------------------------
		Dim Result_payco, Read_Data, approvalOrder

		'---------------------------------------------------------------------------------
		' 결제 승인 요청에 담을 JSON OBJECT를 선언합니다.
		'-----------------------------------------------------------------------------
		Set approvalOrder = New aspJSON
		With approvalOrder.data
			.Add "sellerKey", CStr(sellerKey)											'가맹점 코드. payco_config.asp 에 설정
			.Add "reserveOrderNo", CStr(certify_reserveOrderNo)							'예약주문번호.
			.Add "sellerOrderReferenceKey", CStr(certify_sellerOrderReferenceKey)		'가맹점주문번호연동키.
			.Add "paymentCertifyToken", CStr(certify_paymentCertifyToken)				'결제인증토큰.
			.Add "totalPaymentAmt", CStr(certify_TotalPaymentAmt)						'주문 총 금액.
		End With
		Result_payco = payco_approval(approvalOrder.JSONoutput())

		Set Read_Data = New aspJSON
		Read_Data.loadJSON(Result_payco)
		Call Write_Log("payco_return.asp receive json data : " + Read_Data.JSONoutput())			' 디버그용
		With Read_Data

			'-----------------------------------------------------------------------------
			' 결제 승인 수신 데이터 사용
			' .data("code") = "0" 이면 승인 결과값을 정상으로 받은것임.
			'-----------------------------------------------------------------------------

			RETURNCODE = .data("code")

			If .data("code") = "0" Then
				'-----------------------------------------------------------------------------
				' 결제 승인 성공시 데이터를 수신하여 사용( DB에 저장 )
				' 오류시 승인내역을 조회하여 취소할 수 있도록 RaiseError = False 설정
				'-----------------------------------------------------------------------------
				On Error Resume Next
				Dim sellerOrderReferenceKey, reserveOrderNo, orderNo, orderCertifyKey, memberName
				Dim totalOrderAmt, totalDeliveryFeeAmt, totalRemoteAreaDeliveryFeeAmt, totalPaymentAmt

				sellerOrderReferenceKey = .data("result").item("sellerOrderReferenceKey")					' 가맹점에서 발급했던 주문 연동 Key
				reserveOrderNo = .data("result").item("reserveOrderNo")										' PAYCO에서 발급한 주문예약번호
				orderNo = .data("result").item("orderNo")													' PAYCO에서 발급한 주문번호
				orderCertifyKey = .data("result").item("orderCertifyKey")									' PAYCO에서 발급받은 인증값
				memberName = .data("result").item("memberName")												' 주문자명
				totalOrderAmt = .data("result").item("totalOrderAmt")										' 총 주문 금액
				totalDeliveryFeeAmt = .data("result").item("totalDeliveryFeeAmt")							' 총 배송비 금액
				totalRemoteAreaDeliveryFeeAmt = .data("result").item("totalRemoteAreaDeliveryFeeAmt")		' 총 추가배송비 금액
				totalPaymentAmt = .data("result").item("totalPaymentAmt")									' 총 결제 금액

				Dim orderProduct
				Dim orderProductNo, sellerOrderProductReferenceKey, orderProductStatusCode, orderProductStatusName, productKindCode, productPaymentAmt, originalProductPaymentAmt 

				For Each orderProduct In .data("result").item("orderProducts")
					With .data("result").item("orderProducts").item(orderProduct)
						orderProductNo = .item("orderProductNo")									'주문상품번호
						sellerOrderProductReferenceKey = .item("sellerOrderProductReferenceKey")	'가맹점에서 보낸 상품키값
						orderProductStatusCode = .item("orderProductStatusCode")					'주문상품상태코드
						orderProductStatusName = .item("orderProductStatusName")					'주문상품상태명
						productKindCode = .item("productKindCode")									'상품종류코드
						productPaymentAmt = .item("productPaymentAmt")								'상품금액
						originalProductPaymentAmt = .item("originalProductPaymentAmt")				'상품원금액

						'★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
						'-----------------------------------------------------------------------------
						' 상품별 재고를 체크합니다.
						' 처리 결과를 실패로 가정
						' ErrMessage = "재고가 부족합니다."
						' RaiseError = True
						'-----------------------------------------------------------------------------
						Dim ItemName, ItemStock
						ItemName = "BBQ Chicken"
						ItemStock = 10                  '연동 실패를 테스트 하시려면 값을 0 으로 설정하시고 정상으로 테스트 하시려면 1보다 큰 값을 넣으세요.
						If ItemStock < 1 Then           '재고가 1보다 작다면 오류로 설정
							RaiseError = True
							ErrMessage = ItemName + "은 현재 재고가 부족합니다. 나중에 다시 주문하세요."
							Exit For
						End If
						'★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★

					End With
				Next

				If shopInfoError Then
					RaiseError = True
				End If

				If Not RaiseError Then
					Call Write_Log("orderProductStatusName : " + orderProductStatusName)				'변수 읽기 샘플

					Dim paymentDetail, paymentTradeNo, paymentMethodCode, paymentAmt, paymentMethodName
					Dim nonBankbookSettleInfo, bankName, bankCode, accountNo, paymentExpirationYmd
					Dim cardSettleInfo, cardCompanyName, cardCompanyCode, cardNo, cardInstallmentMonthNumber
					Dim realtimeAccountTransferSettleInfo
					Dim discountAmt, discountConditionAmt
					For Each paymentDetail In .data("result").item("paymentDetails")								
						with .data("result").item("paymentDetails").item(paymentDetail)
							paymentTradeNo = .item("paymentTradeNo")												'결제수단별거래번호
							paymentMethodCode = .item("paymentMethodCode")											'결제수단코드
							paymentAmt = .item("paymentAmt")														'결제수단 사용금액
							paymentMethodName = .item("paymentMethodName")											'결제수단명
							Select case paymentMethodCode
								case "02"																			'무통장입금
									With .item("nonBankbookSettleInfo")												'무통장입금 결제정보
										bankName = .item("bankName")												'은행명
										bankCode = .item("bankCode")												'은행코드 
										accountNo = .item("accountNo")												'계좌번호
										paymentExpirationYmd = .item("paymentExpirationYmd")						'입금만료일 
									End With
								case "31"																			'신용카드(일반) '신용카드
									With .item("cardSettleInfo")
										cardCompanyName = .item("cardCompanyName")									'카드사명
										cardCompanyCode = .item("cardCompanyCode")									'카드사코드 
										cardNo = .item("cardNo")													'카드번호	
										cardInstallmentMonthNumber = .item("cardInstallmentMonthNumber")			'할부개월(MM)
									End With
								case "35"																			'계좌이체 '바로이체
									With .item("realtimeAccountTransferSettleInfo")									'실시간계좌이체 결제정보
										bankName = .item("bankName")												'은행명
										bankCode = .item("bankCode")												'은행코드 
									End With
								case "76"																			'쿠폰사용정보
									With .item("couponSettleInfo")
										discountAmt = .item("discountAmt")											'쿠폰사용금액
										discountConditionAmt = .item("discountConditionAmt")						'쿠폰사용조건금액
									End With
								case "98"																			'포인트 사용정보
							End Select
						End With
					Next
					Call Write_Log("paymentDetails's CardNumber : " + cardNo)										'변수 읽기 샘플
				End If 
				'-----------------------------------------------------------------------------
				' ...
				' 결제 승인 수신 데이터를 이용하여 결제 승인후 처리할 부분을 이곳에 작성합니다.
				' 팝업창 닫기 또는 구매 완료 페이지 작성 ( 팝업창 닫을때 Opener 페이지 이동 등 )
				'
				'-----------------------------------------------------------------------------

				'---------------------------------------------------------------------------------
				' DB 저장중 오류가 발생하였으면 오류를 유발시킴
				'---------------------------------------------------------------------------------
				If Not Err.Number = 0 Then
					RaiseError = True
					ErrMessage = Err.Description
				End If
				
				'---------------------------------------------------------------------------------
				' 승인 완료를 했는데 오류가 났을 경우 조회를 해서 망 취소를 한다.
				'---------------------------------------------------------------------------------


				If RaiseError Then
					Dim jsonOrder
					Set jsonOrder = New aspJson			'JSON 을 작성할 OBJECT 선언

					With jsonOrder.data
						'---------------------------------------------------------------------------------
						' 설정한 주문정보들을 Json String 을 작성합니다.
						'---------------------------------------------------------------------------------
						.Add "sellerKey", CStr(sellerKey)
						.Add "sellerOrderReferenceKey", CStr(certify_sellerOrderReferenceKey)
						.Add "reserveOrderNo", CStr(certify_reserveOrderNo)
					End With 
					
					Dim VerifyResult
					'---------------------------------------------------------------------------------
					' 주문 예약 함수 호출 ( JSON 데이터를 String 형태로 전달 )
					'---------------------------------------------------------------------------------
					VerifyResult = payco_verifypayment(jsonOrder.JSONoutput())								
					Dim Verify_Read_Data
					Set Verify_Read_Data = New aspJSON		'Read_Data.data("result").item("orderProducts")
					Verify_Read_Data.loadJSON(VerifyResult)
					If Verify_Read_Data.data("code") = "0" Then
						Dim cancelOrder
						'-----------------------------------------------------------------------------
						' 취소 내역을 담을 JSON OBJECT를 선언합니다.
						'-----------------------------------------------------------------------------
						Set cancelOrder = New aspJSON
						With cancelOrder.data
							'결제내역이 있으니 해당 내역을 취소함.
							.Add "sellerKey", CStr(sellerKey)																'가맹점 코드. payco_config.asp 에 설정 (필수)
							.Add "sellerOrderReferenceKey", Verify_Read_Data.data("result").item("sellerOrderReferenceKey")	'취소주문연동키. ( 파라메터로 넘겨 받은 값 ) (필수)
							.Add "orderCertifyKey", Verify_Read_Data.data("result").item("orderCertifyKey")					'PAYCO에서 발급받은 인증값 (필수)
							.Add "orderNo", Verify_Read_Data.data("result").item("orderNo")									'주문번호
							.Add "cancelTotalAmt", Verify_Read_Data.data("result").item("totalPaymentAmt")					'주문서의 총 금액을 입력합니다. (전체취소, 부분취소 전부다) (필수)
							.Add "totalCancelTaxfreeAmt", CStr(totalTaxfreeAmt)												'총 취소할 면세금액
							.Add "totalCancelTaxableAmt", CStr(totalTaxableAmt)												'총 취소할 과세금액
							.Add "totalCancelVatAmt", Cstr(totalVatAmt)														'총 취소할 부가세
							.Add "totalCancelPossibleAmt", Verify_Read_Data.data("result").item("totalPaymentAmt")			'총 취소가능금액(현재기준 : 취소가능금액 체크시 입력)
							.Add "requestMemo", "망취소"																		'취소처리 요청메모
							
							Dim Cancel_Result
							Cancel_Result = payco_cancel(cancelOrder.JSONoutput())

							Dim Cancel_Read_Data
							Set Cancel_Read_Data = New aspJSON		'Read_Data.data("result").item("orderProducts")
							Cancel_Read_Data.loadJSON(Cancel_Result)
						End With 
					End If 

					'-----------------------------------------------------------------------------
					' 결제 승인 오류시 오류내역을 표시
					'-----------------------------------------------------------------------------
					Call Write_Log("payco_approval Error : code - " + CStr(.data("code")) + ", message - " + CStr(.data("message")))

					Set resMC = OrderCancelListForOrder(order_idx)

					If resMC.mCode = 0 Then
						paycoDone = True
					End If
					%>
					<html>
						<head>
							<title>주문 실패</title>
						</head>
						<body>
							<p>주문이 정상적으로 완료되지 않았습니다.</p>
							<p>- 오류내역 : code : <%=.data("code")%>, message : <%=.data("message")%> </p>
							<% If Not Cancel_Result ="" Then
								%><p>- 망취소 결과 : code : <%=Cancel_Read_Data.data("code")%>, message : <%=Cancel_Read_Data.data("message")%> </p><%
							End If %>
							<script type="text/javascript">
								<%
									If paycoDone then
										order_idx = ""
									End If

									if WebMode = "MOBILE" Or Request.ServerVariables("HTTP_HOST") = "m.bbq.co.kr" Or Request.ServerVariables("HTTP_HOST") = "mtest.bbq.co.kr" Or Request.ServerVariables("HTTP_HOST") = "bbq.fuzewire.com:8010" then	%>
										//location.href = "<%=AppWebPath+"/index.asp"%>";
										location.href = "/order/cart.asp?cancel_idx=<%=order_idx%>";
										//history.back();
										//opener.parent.cancelMembership();
										// window.close();
								<%  else %>
										// 주문페이지로 다시 돌아가기 위해 창만 닫거나 특정 페이지로 이동합니다.
										// opener.location.href = "<%=AppWebPath+"/index.asp"%>";
										<% If Not paycoDone then %>
											opener.parent.cancelMembership();
										<% End If %>
										window.close();
								<%  end if %>
							</script>
						</body>
					</html>
					<% 
					Response.End		'페이지 종료
				End if 
			Else
				RaiseError = True
				ErrMessage = "오류 발생\ncode : "+CStr(.data("code"))+", message : "+.data("message")
			End If
		End With 
	End If

	if ErrMessage <> "" Then
		Call Write_Log("payco_return.asp order_idx : " & cstr(order_idx) & " ErrMessage : " & ErrMessage)
	end if 

	' ## 오류가 없을 시 주문 완료 처리
	If Not RaiseError Then
		Call Write_Log("payco_return.asp return success.")

		'***** pay insert
		Set aCmd = Server.CreateObject("ADODB.Command")
		With aCmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_order_payment_select"

			.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)

			Set aRs = .Execute
		End With
		Set aCmd = Nothing

		'연결된 pay가 있는지 확인'
		If Not (aRs.BOF Or aRs.EOF) Then
'			pay_idx = aRs("pay_idx")
'			Call Write_Log("pay_idx exist." + pay_idx)
		Else
			'없으면 pay_idx 생성'
			Set aCmd = Server.CreateObject("ADODB.Command")
			With aCmd
				.ActiveConnection = dbconn
				.NamedParameters = True
				.CommandType = adCmdStoredProc
				.CommandText = "bp_payment_insert"

				.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,,order_idx)
				.Parameters.Append .CreateParameter("@member_idx", adInteger, adParamInput, , MEMBER_IDX)
				.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, USER_ID)
				.Parameters.Append .CreateParameter("@member_type", adVarChar, adParamInput, 10, MEMBER_TYPE)
				.Parameters.Append .CreateParameter("@pay_amt", adCurrency, adParamInput,, PAYAMOUNT)
				.Parameters.Append .CreateParameter("@pay_status", adVarChar, adParamInput, 10, "PAID")

				.Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
				.Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

				.Execute

				errCode = .Parameters("@ERRCODE").Value
				errMsg = .Parameters("@ERRMSG").Value

			End With

			Set aCmd = Nothing
		End If
		Set aRs = Nothing

		'pay_detail 생성'
		Set aCmd = Server.CreateObject("ADODB.Command")

		With aCmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_payment_detail_insert"

			.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,,order_idx)
			.Parameters.Append .CreateParameter("@pay_method", adVarChar, adParamInput, 10, "PAYCO")
			.Parameters.Append .CreateParameter("@pay_transaction_id", adVarChar, adParamInput, 50, orderNo)
			.Parameters.Append .CreateParameter("@pay_cp_id", adVarChar, adParamInput, 50, cpId)
			.Parameters.Append .CreateParameter("@pay_subcp", adVarChar, adParamInput, 50, sellerKey)
			.Parameters.Append .CreateParameter("@pay_amt", adCurrency, adParamInput,, AMOUNT)
			.Parameters.Append .CreateParameter("@pay_approve_num", adVarChar, adParamInput, 50, order_num)
			.Parameters.Append .CreateParameter("@pay_result_code", adVarChar, adParamInput, 10, RETURNCODE)
			.Parameters.Append .CreateParameter("@pay_err_msg", adVarChar, adParamInput, 1000, orderCertifyKey)
			.Parameters.Append .CreateParameter("@pay_result", adLongVarWChar, adParamInput, 2147483647, "")
			.Parameters.Append .CreateParameter("@pay_detail_idx", adInteger, adParamOutput)

			.Execute

			pay_detail_idx = .Parameters("@pay_detail_idx").Value

		End With

		Set aCmd = Nothing

		'payco_pay_log 생성'
		Set aCmd = Server.CreateObject("ADODB.Command")

		With aCmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_payco_pay_log_insert"

			.Parameters.Append .CreateParameter("@pay_act", adVarChar, adParamInput, 30, "PAY")
			.Parameters.Append .CreateParameter("@pay_order_num", adVarChar, adParamInput, 50, order_num)
			.Parameters.Append .CreateParameter("@pay_amt", adCurrency, adParamInput,, AMOUNT)
			.Parameters.Append .CreateParameter("@pay_payco_orderNo", adVarChar, adParamInput, 50, orderNo)
			.Parameters.Append .CreateParameter("@pay_cpid", adVarChar, adParamInput, 50, cpId)
			.Parameters.Append .CreateParameter("@pay_subcp", adVarChar, adParamInput, 50, sellerKey)
			.Parameters.Append .CreateParameter("@pay_tid", adVarChar, adParamInput, 100, orderCertifyKey)
			.Parameters.Append .CreateParameter("@pay_result_code", adVarChar, adParamInput, 10, RETURNCODE)
			.Parameters.Append .CreateParameter("@pay_err_msg", adVarChar, adParamInput, 1000, ErrMessage)
			.Parameters.Append .CreateParameter("@pay_etc1", adLongVarWChar, adParamInput, 2147483647, "")
			.Parameters.Append .CreateParameter("@pay_idx", adInteger, adParamOutput)

			.Execute

			payco_pay_log_idx = .Parameters("@pay_idx").Value


		End With

		Set aCmd = Nothing
		
		Call Write_Log("bp_pay_detail_insert Execute. pay_detail_idx = " + pay_detail_idx)

		Response.Redirect "/order/orderEnd.asp?order_idx="& order_idx &"&pm=Payco"
		Response.End

		%>
		<html>
			<head>
				<title>주문 완료</title>
				<script type="text/javascript">
					alert("주문이 정상적으로 완료되었습니다.");
					<%
						'암호화 order_idx (2022.04.28)
						eorder_idx = AESEncrypt(cstr(order_idx))
						
						if WebMode = "MOBILE" Or Request.ServerVariables("HTTP_HOST") = "m.bbq.co.kr" Or Request.ServerVariables("HTTP_HOST") = "mtest.bbq.co.kr" Or Request.ServerVariables("HTTP_HOST") = "bbq.fuzewire.com:8010" then	%>
							location.href = "/order/orderComplete.asp?order_idx=<%=eorder_idx%>&pm=Payco<%'=AppWebPath+"/complete.asp"%>";
							// opener.location.href = "/order/orderComplete.asp?order_idx=<%=eorder_idx%>&pm=Payco<%'=AppWebPath+"/complete.asp"%>";
							// window.close();
					<%  else %>
							opener.location.href = "/order/orderComplete.asp?order_idx=<%=eorder_idx%>&pm=Payco<%'=AppWebPath+"/complete.asp"%>";
							window.close();
							// var successPoller = setInterval(function() {
							// 		<% '결과를 complete.asp 페이지에 전송.  %>
							// 		try {
							// 			if(typeof opener.document.getElementById("reserveOrderNo_verify") !== 'undefined' ) {
							// 				opener.document.getElementById("sellerOrderReferenceKey").value = "<%=sellerOrderReferenceKey%>";
							// 				opener.document.getElementById("orderNo").value = "<%=orderNo%>";
							// 				opener.document.getElementById("sellerOrderProductReferenceKey").value = "<%=sellerOrderProductReferenceKey%>";

							// 				opener.document.getElementById("orderNo_all").value = "<%=orderNo%>";
							// 				opener.document.getElementById("sellerOrderReferenceKey_all").value = "<%=sellerOrderReferenceKey%>";
							// 				opener.document.getElementById("orderCertifyKey_all").value = "<%=orderCertifyKey%>";
							// 				opener.document.getElementById("cancelTotalAmt_all").value = "<%=totalPaymentAmt%>";
							// 				opener.document.getElementById("totalCancelTaxfreeAmt_all").value = "<%=totalTaxfreeAmt%>";
							// 				opener.document.getElementById("totalCancelTaxableAmt_all").value = "<%=totalTaxableAmt%>";
							// 				opener.document.getElementById("totalCancelVatAmt_all").value = "<%=totalVatAmt%>";
							// 				opener.document.getElementById("totalCancelPossibleAmt_all").value = "<%=totalPaymentAmt%>";
							// 				opener.document.getElementById("requestMemo_all").value = "전체취소 테스트입니다.";

							// 				opener.document.getElementById("orderNo_part").value = "<%=orderNo%>";
							// 				opener.document.getElementById("sellerOrderReferenceKey_part").value = "<%=sellerOrderReferenceKey%>";
							// 				opener.document.getElementById("orderCertifyKey_part").value = "<%=orderCertifyKey%>";
							// 				opener.document.getElementById("cancelTotalAmt_part").value = "<%=totalPaymentAmt%>";
							// 				opener.document.getElementById("totalCancelTaxfreeAmt_part").value = "<%=totalTaxfreeAmt%>";
							// 				opener.document.getElementById("totalCancelTaxableAmt_part").value = "<%=totalTaxableAmt%>";
							// 				opener.document.getElementById("totalCancelVatAmt_part").value = "<%=totalVatAmt%>";
							// 				opener.document.getElementById("totalCancelPossibleAmt_part").value = "<%=totalPaymentAmt%>";
							// 				opener.document.getElementById("sellerOrderProductReferenceKey_part").value = "<%=sellerOrderProductReferenceKey%>";
							// 				opener.document.getElementById("cancelDetailContent_part").value = "부분취소 테스트입니다.";
							// 				opener.document.getElementById("cancelAmt_part").value = "<%=totalPaymentAmt%>";
							// 				opener.document.getElementById("requestMemo_part").value = "부분취소 테스트입니다.";

							// 				opener.document.getElementById("sellerOrderReferenceKey_mile").value = "<%=sellerOrderReferenceKey%>";
							// 				opener.document.getElementById("cancelPaymentAmount_mile").value = "<%=totalPaymentAmt%>";

							// 				opener.document.getElementById("sellerOrderKey_Receipt").value = "<%=orderNo%>";

							// 				opener.document.getElementById("sellerOrderReferenceKey_verify").value = "<%=sellerOrderReferenceKey%>";
							// 				opener.document.getElementById("reserveOrderNo_verify").value = "<%=reserveOrderNo%>";

							// 				clearInterval(successPoller);
							// 				window.close();
							// 			}
							// 		}
							// 		catch (error) {
							// 			alert(error);
							// 		}
							// 	}, 500);

					<%  end if %>
				</script>
			</head>
		</html>
		<%
	Else
		'-----------------------------------------------------------------------------
		'
		' 오류일 경우 오류페이지를 표시하거나 결제되지 않았음을 고객에게 통보합니다.
		' 팝업창 닫기 또는 구매 실패 페이지 작성 ( 팝업창 닫을때 Opener 페이지 이동 등 )
		'
		'-----------------------------------------------------------------------------
		'결제 인증 후 내부 오류가 있어 승인은 받지 않았습니다. 오류내역을 여기에 표시하세요. 예) 재고 수량이 부족합니다.
		Call Write_Log("payco_return.asp Error : " + ErrMessage)

		Set resMC = OrderCancelListForOrder(order_idx)

		If resMC.mCode = 0 Then
			paycoDone = True
		End If

		%>
		<html>
			<head>
				<title>주문 취소</title>
				<script type="text/javascript">
					alert("<%=ErrMessage%>\n결제가 승인되지 않았습니다.");
						<%
							If paycoDone then
								order_idx = ""
							End If

							if WebMode = "MOBILE" Or Request.ServerVariables("HTTP_HOST") = "m.bbq.co.kr" Or Request.ServerVariables("HTTP_HOST") = "mtest.bbq.co.kr" Or Request.ServerVariables("HTTP_HOST") = "bbq.fuzewire.com:8010" then	%>
								//location.href = "<%=AppWebPath+"/index.asp"%>";
								location.href = "/order/cart.asp?cancel_idx=<%=order_idx%>";
								//history.back();
								// opener.parent.cancelMembership();
								// window.close();
						<%  else %>
								// 주문페이지로 다시 돌아가기 위해 창만 닫거나 특정 페이지로 이동합니다.
								// opener.location.href = "<%=AppWebPath+"/index.asp"%>";
								//opener.parent.cancelMembership();
								<% If Not paycoDone then %>
									opener.parent.cancelMembership();
								<% End If %>

								window.close();
						<%  end if %>
				</script>
			</head>
		</html>
		<% 
	End if
%>