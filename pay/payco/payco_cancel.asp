<!--#include file="payco_config.asp"-->
<!--#include virtual="/api/include/db_open.asp"-->
<!--#include virtual="/api/include/func.asp"-->
<%

	Response.addHeader "Access-Control-Allow-Origin", "http://10.0.9.165"
	Response.addHeader "Access-Control-Allow-Methods", "POST, GET, OPTIONS"
	Response.addHeader "Access-Control-Allow-Headers:orgin", "x-requested-with"

	'-----------------------------------------------------------------------------
	' PAYCO 주문 취소 페이지 샘플 ( ASP )
	' payco_cancel.asp
	' 2015-03-25	PAYCO기술지원 <dl_payco_ts@nhnent.com>
	'-----------------------------------------------------------------------------

	'-----------------------------------------------------------------------------
	' 이 문서는 json 형태의 데이터를 반환합니다.
	'-----------------------------------------------------------------------------
	Response.ContentType = "application/json"

	order_num	= GetReqStr("order_num","")
	tid			= GetReqStr("tid","")
	pay_method	= "PAYCO"

	Set pCmd = Server.CreateObject("ADODB.Command")
	With pCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_payment_detail_select_pg"

		.Parameters.Append .CreateParameter("@order_num", advarchar, adParamInput, 40, order_num)
		.Parameters.Append .CreateParameter("@pay_method", advarchar, adParamInput, 20, pay_method)

		Set pRs = .Execute
	End With
	Set pCmd = Nothing

	If Not (pRs.BOF Or pRs.EOF) Then
		order_idx	= pRs("order_idx")
		payco_OrderNo	= pRs("pay_transaction_id")
		vPayco_Cpid		= pRs("pay_cpid")
		sellerKey		= pRs("pay_subcp")
		AMOUNT			= pRs("pay_amt")
		orderCertifyKey = pRs("pay_err_msg")
		paytype			= pRs("pay_type")
	Else
		Response.write "FAIL|존재하지 않는 주문번호"
		response.End
	End If
	Set pRs = Nothing

	If tid <> orderCertifyKey Then
		Response.write "FAIL|TID 불일치"
		Response.end
	End If

	'Response.write order_num
	'Response.end
	'-----------------------------------------------------------------------------
	' (로그) 호출 시점과 호출값을 파일에 기록합니다.
	'-----------------------------------------------------------------------------
	Dim xform, receive_str
	receive_str = "payco_cancel.asp is Called - "
	For Each xform In Request.form
		receive_str = receive_str +  CStr(xform) + " : " + request(xform) + ", "
	Next
	Call Write_Log(receive_str)

	'---------------------------------------------------------------------------------
	' 가맹점 주문 번호로 상품 불러오기
	' DB에 연결해서 가맹점 주문 번호로 해당 상품 목록을 불러옵니다.
	'---------------------------------------------------------------------------------
	Dim orderNo, sellerOrderReferenceKey, sellerOrderProductReferenceKey, orderCertifyKey, cancelTotalAmt, cancelAmt
	Dim totalCancelTaxfreeAmt, totalCancelTaxableAmt, totalCancelVatAmt, totalCancelPossibleAmt, requestMemo, cancelDetailContent
	Dim cancelType
	Dim resultValue			'결과 리턴용 JSON 변수 선언
	Set resultValue = New aspJSON

	cancelType = "ALL"'UCase(request("cancelType"))										' 취소 Type 받기 - ALL 또는 PART
	orderNo = payco_OrderNo'request("orderNo")													' PAYCO에서 발급받은 주문서 번호
	sellerOrderReferenceKey = order_num'request("sellerOrderReferenceKey")					' 가맹점 주문 연동 키	
	orderCertifyKey = orderCertifyKey'request("orderCertifyKey")									' PAYCO에서 발급받은 인증값
	cancelTotalAmt = AMOUNT'request("cancelTotalAmt")										' 총 주문 금액
	totalCancelTaxfreeAmt = request("totalCancelTaxfreeAmt")						' 주문 총 면세금액
	totalCancelTaxableAmt = request("totalCancelTaxableAmt")						' 주문 총 과세 공급가액
	totalCancelVatAmt = request("totalCancelVatAmt")								' 주문 총 과세 부가세액
	totalCancelPossibleAmt = request("totalCancelPossibleAmt")						' 총 취소가능금액
	sellerOrderProductReferenceKey = request("sellerOrderProductReferenceKey")		' 가맹점 주문 상품 연동 키 ( PART 취소 시 )
	requestMemo = request("requestMemo")											' 취소처리 요청메모
	cancelDetailContent = request("cancelDetailContent")							' 취소 상세 사유
	cancelAmt = AMOUNT'request("cancelAmt")												' 취소 상품 금액 ( PART 취소 시 )

	'-----------------------------------------------------------------------------
	' sellerOrderReferenceKey, cancelTotalAmt 값이 없으면 로그를 기록한 뒤 JSON 형태로 오류를 돌려주고 API를 종료합니다.
	'-----------------------------------------------------------------------------
	If sellerOrderReferenceKey = "" Then
		With resultValue.data
			.Add "result", "취소주문연동키 값이 전달되지 않았습니다."
			.Add "message", "sellerOrderReferenceKey is Nothing."
			.Add "code", 9999
		End With 
		Response.write "FAIL|취소주문연동키 값이 전달되지 않았습니다."
		'Response.Write resultValue.JSONoutput()
		Response.End
	End If 
	If orderCertifyKey = "" Then
		With resultValue.data
			.Add "result", "PAYCO에서 발급받은 인증값이 전달되지 않았습니다."
			.Add "message", "orderCertifyKey is Nothing."
			.Add "code", 9999
		End With 
		Response.write "FAIL|PAYCO에서 발급받은 인증값이 전달되지 않았습니다."
		'Response.Write resultValue.JSONoutput()
		Response.End
	End If 
	If cancelTotalAmt = "" Then
		With resultValue.data
			.Add "result", "총 주문금액이 전달되지 않았습니다."
			.Add "message", "cancelTotalAmt is Nothing."
			.Add "code", 9999
		End With 
		Response.write "FAIL|총 주문금액이 전달되지 않았습니다."
		'Response.Write resultValue.JSONoutput()
		Response.End
	End If 

	'---------------------------------------------------------------------------------
	' 상품정보 변수 선언
	'---------------------------------------------------------------------------------
	Dim cancelOrder
	Dim orderQuantity, productUnitPrice, productAmt
	Dim cancelTotalFeeAmt
	Dim TotalUnitPrice, TotalProductPaymentAmt
	Dim i, ProductsList, itemCount

	'-----------------------------------------------------------------------------
	' 취소 내역을 담을 JSON OBJECT를 선언합니다.
	'-----------------------------------------------------------------------------
	Set cancelOrder = New aspJSON
	With cancelOrder.data
		'---------------------------------------------------------------------------------
		' 전체 취소 = "ALL", 부분취소 = "PART"
		'---------------------------------------------------------------------------------
		Select Case cancelType
			Case "ALL"
				'---------------------------------------------------------------------------------
				' 파라메터로 값을 받을 경우 필요가 없는 부분이며
				' 주문 키값으로만 DB에서 데이터를 불러와야 한다면 이 부분에서 작업하세요.
				'---------------------------------------------------------------------------------
			Case "PART"
				'-----------------------------------------------------------------------------
				' sellerOrderProductReferenceKey, cancelAmt 값이 없으면 로그를 기록한 뒤 JSON 형태로 오류를 돌려주고 API를 종료합니다.
				'-----------------------------------------------------------------------------
				If sellerOrderProductReferenceKey = "" Then
					With resultValue.data
						.Add "result", "취소상품연동키 값이 전달되지 않았습니다."
						.Add "message", "sellerOrderProductReferenceKey is Nothing."
						.Add "code", 9999
					End With 
					Response.write "FAIL|취소상품연동키 값이 전달되지 않았습니다."
					'Response.Write resultValue.JSONoutput()
					Response.End
				End If 
				If cancelAmt = "" Then
					With resultValue.data
						.Add "result", "취소상품 금액이 전달되지 않았습니다."
						.Add "message", "cancelAmt is Nothing."
						.Add "code", 9999
					End With 
					Response.write "FAIL|취소상품 금액이 전달되지 않았습니다."
					'Response.Write resultValue.JSONoutput()
					Response.End
				End If 

				'---------------------------------------------------------------------------------
				' 주문상품 데이터 불러오기
				' 파라메터로 값을 받을 경우 받은 값으로만 작업을 하면 됩니다.
				' 주문 키값으로만 DB에서 취소 상품 데이터를 불러와야 한다면 이 부분에서 작업하세요.
				'---------------------------------------------------------------------------------

				.Add "orderProducts", cancelOrder.Collection()
				'---------------------------------------------------------------------------------
				' 취소 상품값으로 읽은 변수들로 Json String 을 작성합니다.
				'---------------------------------------------------------------------------------
				With cancelOrder.data("orderProducts")
					.Add 0, cancelOrder.Collection()
					With .item(0)
						.Add "sellerOrderProductReferenceKey", CStr(sellerOrderProductReferenceKey)		'취소 상품 연동 키 ( 파라메터로 넘겨 받은 값 - 필요서 DB에서 불러와 대입 ) (필수)
						.Add "cpId", CStr(cpId)															'상점 ID , payco_config.asp 에 설정 (필수)
						.Add "productId", CStr(productId)												'상품 ID , payco_config.asp 에 설정 (필수)
						.Add "productAmt", cancelAmt													'취소 상품 금액 ( 파라메터로 넘겨 받은 금액 - 필요서 DB에서 불러와 대입 ) (필수)
						.Add "cancelDetailContent", CStr(cancelDetailContent)							'취소 상세 사유 ( 160 byte 이내 )
					End With 
				End With					

				'---------------------------------------------------------------------------------
			Case Else
				'---------------------------------------------------------------------------------
				' 취소타입이 잘못되었음. ( ALL과 PART 가 아닐경우 )
				'---------------------------------------------------------------------------------
				With resultValue.data
					.Add "result", "CANCEL_TYPE_ERROR"
					.Add "message", "취소 요청 타입이 잘못되었습니다."
					.Add "code", 9999
				End With 
				Response.write "FAIL|취소 요청 타입이 잘못되었습니다."
				'Response.Write resultValue.JSONoutput()
				Response.End
		End Select 
		'Response.write "aa"&order_idx
		'---------------------------------------------------------------------------------
		' 설정한 주문정보 변수들로 Json String 을 작성합니다.
		'---------------------------------------------------------------------------------
		.Add "sellerKey", CStr(sellerKey)								'가맹점 코드. payco_config.asp 에 설정 (필수)
		.Add "sellerOrderReferenceKey", CStr(sellerOrderReferenceKey)	'취소주문연동키. ( 파라메터로 넘겨 받은 값 ) (필수)
		.Add "orderCertifyKey", CStr(orderCertifyKey)					'PAYCO에서 발급받은 인증값 (필수)
		.Add "orderNo", CStr(orderNo)									'주문번호
		.Add "cancelTotalAmt", CStr(cancelTotalAmt)						'주문서의 총 금액을 입력합니다. (전체취소, 부분취소 전부다) (필수)
		.Add "totalCancelTaxfreeAmt", CStr(totalCancelTaxfreeAmt)		'총 취소할 면세금액
		.Add "totalCancelTaxableAmt", CStr(totalCancelTaxableAmt)		'총 취소할 과세금액
		.Add "totalCancelVatAmt", CStr(totalCancelVatAmt)				'총 취소할 부가세
		.Add "totalCancelPossibleAmt", CStr(totalCancelPossibleAmt)		'총 취소가능금액(현재기준 : 취소가능금액 체크시 입력)
		.Add "requestMemo", CStr(requestMemo)							'취소처리 요청메모

		Dim Result 
		'---------------------------------------------------------------------------------
		' 주문 결제 취소 API 호출 ( JSON 데이터로 호출 )
		'---------------------------------------------------------------------------------
		Result = payco_cancel(cancelOrder.JSONoutput())

		'-----------------------------------------------------------------------------
		' 결과를 호출한 쪽에 리턴
		'-----------------------------------------------------------------------------
		'Response.write Result

		'dim Info : set Info = JSON.parse(join(array(Result)))
		Dim Verify_Read_Data
		Set Verify_Read_Data = New aspJSON		'Read_Data.data("result").item("orderProducts")
		Verify_Read_Data.loadJSON(Result)
'Response.write "aa"&order_idx
		If Verify_Read_Data.data("code") = "0" Then

			'payco_pay_log 생성'
			Set aCmd = Server.CreateObject("ADODB.Command")

			With aCmd
				.ActiveConnection = dbconn
				.NamedParameters = True
				.CommandType = adCmdStoredProc
				.CommandText = "bp_payco_pay_log_insert"

				.Parameters.Append .CreateParameter("@pay_act", adVarChar, adParamInput, 30, "CANCEL")
				.Parameters.Append .CreateParameter("@pay_order_num", adVarChar, adParamInput, 50, order_num)
				.Parameters.Append .CreateParameter("@pay_amt", adCurrency, adParamInput,, AMOUNT)
				.Parameters.Append .CreateParameter("@pay_payco_orderNo", adVarChar, adParamInput, 50, orderNo)
				.Parameters.Append .CreateParameter("@pay_cpid", adVarChar, adParamInput, 50, vPayco_Cpid)
				.Parameters.Append .CreateParameter("@pay_subcp", adVarChar, adParamInput, 50, sellerKey)
				.Parameters.Append .CreateParameter("@pay_tid", adVarChar, adParamInput, 100, orderCertifyKey)
				.Parameters.Append .CreateParameter("@pay_result_code", adVarChar, adParamInput, 10, Verify_Read_Data.data("code"))
				.Parameters.Append .CreateParameter("@pay_err_msg", adVarChar, adParamInput, 1000, Verify_Read_Data.data("message"))
				.Parameters.Append .CreateParameter("@pay_etc1", adLongVarWChar, adParamInput, 2147483647, "")
				.Parameters.Append .CreateParameter("@pay_idx", adInteger, adParamOutput)

				.Execute

				payco_pay_log_idx = .Parameters("@pay_idx").Value


			End With

			Set aCmd = Nothing

			Response.write "SUCC|취소 완료"
			'Response.End
		Else
			if appMode <> "TEST" Then
				If Verify_Read_Data.data("code") = "1309" Then ' 이미 취소된 내역
					Response.write "SUCC|취소 완료"
				Else 
					Response.write "FAIL|FAIL"	'Info.message
				End If 
			else
				Response.write "FAIL|" & Verify_Read_Data.data("message")	'Info.message
			end if
		End If

	End With

%>