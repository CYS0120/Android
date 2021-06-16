<!--#include file="sgpay.inc.asp"-->
<!--#include virtual="/pay/coupon_use.asp"-->
<!--#include virtual="/pay/coupon_use_coop.asp"-->
<!--#include virtual="/api/order/class_order_db.asp"-->
<%
	'-----------------------------------------------------------------------------
	' 이 문서는 text/html 형태의 데이터를 반환합니다.
	'-----------------------------------------------------------------------------
	Response.ContentType = "text/html"

	Dim order_idx
	order_idx = Request("order_idx")
	Dim paytype : paytype = "Sgpay"

	'-----------------------------------------------------------------------------
	' (로그) 호출 시점과 호출값을 파일에 기록합니다.
	'-----------------------------------------------------------------------------
	Dim xQuery, receive_str
	receive_str = "sgpay_return.asp is Called - "
	receive_str = receive_str &  "POST DATA : "
	For Each xQuery In Request.Form
		receive_str = receive_str &  CStr(xQuery) & " : " & request(xQuery) & ", "
	Next
	receive_str = receive_str &  "GET DATA : "
	For Each xQuery In Request.QueryString
		receive_str = receive_str &  CStr(xQuery) & " : " & request(xQuery) & ", "
	Next
	Call Write_Log(receive_str)


	'-----------------------------------------------------------------------------
	' 오류가 발생했는지 기억할 변수와 결과를 담을 변수를 선언합니다.
	'-----------------------------------------------------------------------------
	Dim doApproval, resultValue
	Dim Read_code, Read_message
	Dim certify_reserveOrderNo, certify_paymentCertifyToken
	Dim returnUrlParam, returnUrlParam1, returnUrlParam2, returnUrlParam3

	doApproval = false											'기본적으로 승인을 받지 않는것으로 설정


	requestToken = Request("token")
	'Response.Write requestToken & "<br />"
	If requestToken = "" Then
		resultMsg = "결제 결과 수신 실패"
		Response.Write resultMsg
		Call Write_Log("sgpay_return.asp is canceled : " & CStr(resultMsg))
		Response.End
	End If

	Call Write_Log("sgpay_return.asp / SGPAY token : " & CStr(requestToken))

	'---------------------------------------------------------------------------------
	' 주문 예약 함수 호출 ( JSON 데이터를 String 형태로 전달 )
	'---------------------------------------------------------------------------------
	decryptedToken = Com.decrypt(requestToken, secretkey)
	'Response.Write decryptedToken & "<br />"
	Call Write_Log("sgpay_return.asp / SGPAY token_decrypted : " & CStr(decryptedToken))

	Set readTokenToJson = New aspJSON
	readTokenToJson.loadJSON(decryptedToken)
	Call Write_Log("sgpay_return.asp / Receive Json Data : " & readTokenToJson.JSONoutput())			' 디버그용
	With readTokenToJson
		ret_Merchant = .data("Merchant")
		ret_Amount = .data("Amount")
		ret_PaymentTime = .data("PaymentTime")
		ret_PaymentNo = .data("PaymentNo")
		ret_TxId = .data("TxId")
		ret_TradeNo = .data("TradeNo")

		If ret_PaymentTime = "" Or ret_PaymentNo = "" Or ret_TxId = "" Then
			resultMsg = "취소되었습니다."
			Call Write_Log("sgpay_return.asp is canceled : " & CStr(resultMsg))
			'Set resMC = OrderCancelListForOrder(order_idx)

			'If resMC.mCode = 0 Then
			'	sgpayDone = True
			'End If
			%>
			<html>
				<head>
					<title>주문 취소</title>
					<script type="text/javascript">
						alert("<%=resultMsg%>");
						<%
							If sgpayDone then
								order_idx = ""
							End If

							If WebMode = "MOBILE" Or Request.ServerVariables("HTTP_HOST") = "m.bbq.co.kr" Or Request.ServerVariables("HTTP_HOST") = "mtest.bbq.co.kr" Or Request.ServerVariables("HTTP_HOST") = "bbq.fuzewire.com:8010" Then
						%>
						location.href = "/order/cart.asp?cancel_idx=<%=order_idx%>";
						<%
							Else
								If Not sgpayDone Then
						%>
						opener.parent.cancelMembership();
						<%
								End If
						%>
						window.close();
						<%
							End If
						%>
					</script>
				</head>
			</html>
			<% 
			Response.End											'페이지 종료
		End If
	End With

	'-----------------------------------------------------------------------------
	' 오류 확인용 변수 선언
	'-----------------------------------------------------------------------------
	Dim RaiseError : RaiseError = False
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

	If Not (pRs.BOF Or pRs.EOF) Then
		USER_ID = pRs("member_idno")
		MEMBER_IDX = pRs("member_id")
		MEMBER_TYPE = pRs("member_type")

		order_num = pRs("order_num")

		PAYAMOUNT = pRs("order_amt") + pRs("delivery_fee")
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
			vSgpay_merchant = aRs("sgpay_merchant")

			If vSgpay_merchant = "" Then
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
	
	Call Write_Log("sgpay_return.asp : " & CStr(shopInfoError))

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
    Dim coupon_pin : coupon_pin = ""

	If IsNull(pinRs("coupon_pin")) = True Then
		coupon_pin = ""
	Else 
		coupon_pin = Cstr(pinRs("coupon_pin"))
	End If  

	prefix_coupon_no = LEFT(coupon_pin, 1)
	Set pinRs = Nothing

	If prefix_coupon_no = "6" or prefix_coupon_no = "8" Then		'COOP coupon prefix 
		eCouponType = "Coop"
	Else 
		eCouponType = "KTR"
	End If

	Dim CouponUseCheck : CouponUseCheck = "N"

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

	If (Not CStr(ret_Amount) = CStr(AMOUNT)) or (Not CStr(ret_TradeNo) = CStr(order_num)) Then		'위에서 파라메터로 받은 ret_Amount 값과 주문값이 같은지 비교합니다. 
																			'( 연동 실패를 테스트 하시려면 값을 주문값을 ret_Amount 값과 틀리게 설정하세요. )
		doApproval = false
		RaiseError = true
		ErrMessage = "주문금액(" & CStr(AMOUNT) & ")과 결제금액(" & CStr(ret_Amount) & ")이 틀립니다."
		
	ElseIf CouponUseCheck = "Y" Then 

		doApproval = false
		RaiseError = true
		ErrMessage = "주문내용에 이미 사용된 쿠폰이 있습니다"

	Else
		'-----------------------------------------------------------------------------
		' 결제 승인 성공시 데이터를 수신하여 사용( DB에 저장 )
		' 오류시 승인내역을 조회하여 취소할 수 있도록 RaiseError = False 설정
		'-----------------------------------------------------------------------------
		On Error Resume Next
		If shopInfoError Then
			RaiseError = True
		End If

		'---------------------------------------------------------------------------------
		' DB 저장중 오류가 발생하였으면 오류를 유발시킴
		'---------------------------------------------------------------------------------
		If Not Err.Number = 0 Then
			RaiseError = True
			ErrMessage = Err.Description
		End If
	End If

	If Not RaiseError Then
		Call Write_Log("sgpay_return.asp return success.")

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
'			Call Write_Log("pay_idx exist." & pay_idx)
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

		'Response.Write "order_idx : " & order_idx & "<br />"
		'Response.Write "orderNo : " & ret_TxId & "<br />"
		'Response.Write "ret_Corporation : " & ret_Corporation & "<br />"
		'Response.Write "ret_Merchant : " & ret_Merchant & "<br />"
		'Response.Write "AMOUNT : " & AMOUNT & "<br />"
		'Response.Write "order_num : " & order_num & "<br />"
		'Response.End

		Dim pay_detail_idx

		With aCmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_payment_detail_insert"

			.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,,order_idx)
			.Parameters.Append .CreateParameter("@pay_method", adVarChar, adParamInput, 10, "SGPAY")
			.Parameters.Append .CreateParameter("@pay_transaction_id", adVarChar, adParamInput, 50, ret_TxId)
			.Parameters.Append .CreateParameter("@pay_cp_id", adVarChar, adParamInput, 50, corporationToken)
			.Parameters.Append .CreateParameter("@pay_subcp", adVarChar, adParamInput, 50, ret_Merchant)
			.Parameters.Append .CreateParameter("@pay_amt", adCurrency, adParamInput,, AMOUNT)
			.Parameters.Append .CreateParameter("@pay_approve_num", adVarChar, adParamInput, 50, ret_PaymentNo)
			.Parameters.Append .CreateParameter("@pay_result_code", adVarChar, adParamInput, 10, "")
			.Parameters.Append .CreateParameter("@pay_err_msg", adVarChar, adParamInput, 1000, "")
			.Parameters.Append .CreateParameter("@pay_result", adLongVarWChar, adParamInput, 2147483647, "")
			.Parameters.Append .CreateParameter("@pay_detail_idx", adInteger, adParamOutput)

			.Execute

			pay_detail_idx = .Parameters("@pay_detail_idx").Value

		End With

		Call Write_Log("sgpay_return.asp : bp_payment_detail_insert")

		'sgpay_pay_log 생성'
		Set aCmd = Server.CreateObject("ADODB.Command")

		With aCmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_sgpay_log_insert"

			.Parameters.Append .CreateParameter("@act", adVarChar, adParamInput, 30, "PAY")
			.Parameters.Append .CreateParameter("@order_num", adVarChar, adParamInput, 50, order_num)
			.Parameters.Append .CreateParameter("@amt", adCurrency, adParamInput,, AMOUNT)
			.Parameters.Append .CreateParameter("@corporation", adVarChar, adParamInput, 32, corporationToken)
			.Parameters.Append .CreateParameter("@merchant", adVarChar, adParamInput, 32, ret_Merchant)
			.Parameters.Append .CreateParameter("@txid", adVarChar, adParamInput, 32, ret_TxId)
			.Parameters.Append .CreateParameter("@result", adVarChar, adParamInput, 10, "")
			.Parameters.Append .CreateParameter("@paymentno", adVarChar, adParamInput, 50, ret_PaymentNo)
			.Parameters.Append .CreateParameter("@paymenttime", adVarChar, adParamInput, 14, ret_PaymentTime)
			.Parameters.Append .CreateParameter("@errmsg", adVarChar, adParamInput, 1000, ErrMessage)
			.Parameters.Append .CreateParameter("@etc1", adLongVarWChar, adParamInput, 2147483647, "")
			.Parameters.Append .CreateParameter("@seq", adInteger, adParamOutput)

			.Execute

			sgpayco_log_idx = .Parameters("@seq").Value


		End With

		Set aCmd = Nothing

		Call Write_Log("bp_pay_detail_insert Execute. pay_detail_idx = " & pay_detail_idx)

	coupon_amt = 0

	Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','start','0','sgpay-000')"
	dbconn.Execute(Sql)

	dim pg_RollBack : pg_RollBack = 0

	dim db_call : set db_call = new Order_DB_Call
	db_call.DB_Order_State dbconn, order_idx, "P", paytype

	errCode = db_call.m_cd
	errMsg = db_call.m_message

	Call Write_Log("sgpay_return.asp : Order_DB_Call - (" & errCode & " ) " & errMsg)

	Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','DB_Order_State','0','sgpay-001')"
	dbconn.Execute(Sql)

	'response.write "errCode : " & errCode & "<BR>"
	'response.write "errMsg : " & errMsg & "<BR>"

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
		brand_code = aRs("brand_code")
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
		address = addr_name & " / " & mobile & " / (" & zipcode & ") " & address_main&" "&address_detail
	ElseIf order_type = "P" Then
		order_type_title = "포장정보"
		order_type_name = "포장매장"
		address_title = "포장매장 주소"
		address = address_main
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
		payMethodCode = "42"
		Case "ECoupon":
		pay_type_title = "E 쿠폰"
		pay_type_name = "E 쿠폰"
		payMethodCode = "99"
	End Select

	Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& order_channel &"','0','sgpay-002')"
	dbconn.Execute(Sql)

	giftcard_serial = Request.Cookies("giftcardSerial")
    If giftcard_serial <> "" Then
        ' 상품권 조회
        Set httpRequest = Server.CreateObject("MSXML2.ServerXMLHTTP")
        httpRequest.Open "GET", "http://api.bbq.co.kr/GiftCard_2.svc/GetGiftCard/"& giftcard_serial, False
        httpRequest.SetRequestHeader "AUTH_KEY", "BF84B3C90590"
        httpRequest.SetRequestHeader "Content-Type", "application/x-www-form-urlencoded"
        httpRequest.Send
        '상품권 조회
        '조회 상품권 text -> json
        Set oJSON = New aspJSON
        postResponse = "{""list"" : " & httpRequest.responseText & "}"
        oJSON.loadJSON(postResponse)
        Set this = oJSON.data("list")
        U_CD_BRAND = brand_code '사용브랜드코드
        U_CD_PARTNER = branch_id ' 사용매장코드
        AMT = this.item("AMT") ' 금액
        U_YN = this.item("U_YN") ' 사용여부
        '조회 상품권 text -> json

        ' 상품권 사용처리 data set
        If U_YN = "N" Then
            data = "{"
            data = data & """U_CD_BRAND"":""" & U_CD_BRAND & ""","
            data = data & """U_CD_PARTNER"":""" & U_CD_PARTNER & ""","
            data = data & """AMT"":""" & AMT & """"
            data = data & "}"
            ' 상품권 사용처리 data set
            Set httpRequest = nothing ' 초기화
            ' 상품권 사용처리
            Set httpRequest = Server.CreateObject("MSXML2.ServerXMLHTTP")
            httpRequest.Open "POST", "http://api.bbq.co.kr/GiftCard_2.svc/UseGiftCard/"& giftcard_serial, False
            httpRequest.SetRequestHeader "AUTH_KEY", "BF84B3C90590"
            'httpRequest.SetRequestHeader "Content-Type", "application/raw"
            httpRequest.Send data
            'Response.Write httpRequest.responseText
            'Response.Write data
            ' 상품권 사용처리
            '조회 상품권 text -> json
            Set gJSON = New aspJSON
            gpostResponse = "{""list"" : " & httpRequest.responseText & "}"
            gJSON.loadJSON(gpostResponse)
            Set this1 = gJSON.data("list")

            U_CD_BRAND = this1.item("U_CD_BRAND") '사용브랜드코드
            U_CD_PARTNER = this1.item("U_CD_PARTNER") ' 사용매장코드
            OK_NUM = this1.item("OK_NUM") ' 승인번호
            RTN_CD = this1.item("RTN_CD") ' 결과코드
            RTN_MSG = this1.item("RTN_MSG") ' 결과코드
            'Response.Write U_CD_BRAND& "<BR>111"
            'Response.Write U_CD_PARTNER& "<BR>222"
            'Response.Write order_num& "<BR>333"
            '조회 상품권 text -> json
            '상품권 사용처리
            If RTN_CD = "0000" Then
                Set pCmd = Server.CreateObject("ADODB.Command")
                    With pCmd
                        .ActiveConnection = dbconn
                        .NamedParameters = True
                        .CommandType = adCmdStoredProc
                        .CommandText = "bp_giftcard_status"

                        .Parameters.Append .CreateParameter("@mode", adVarChar, adParamInput,30,"giftcard_use")
                        .Parameters.Append .CreateParameter("@order_num", adVarChar, adParamInput,100,order_num)
                        .Parameters.Append .CreateParameter("@giftcard_number", adVarChar, adParamInput,100,giftcard_serial)
                        .Parameters.Append .CreateParameter("@u_cd_brand", adVarChar, adParamInput,10,U_CD_BRAND)
                        .Parameters.Append .CreateParameter("@u_cd_partner", adVarChar, adParamInput,50,U_CD_PARTNER)
                        .Parameters.Append .CreateParameter("@ok_num", adVarChar, adParamInput,50,OK_NUM)
                        .Execute
                    End With
                Set pCmd = Nothing
            Else
				ErrMessage = "쿠폰 사용에 실패하였습니다."
            End If
            '상품권 사용처리
            '쿠키 제거
            Response.Cookies("giftcard_serial") = ""
            Response.Cookies("brand_code") = ""
            '쿠키 제거
        Else
			ErrMessage = "쿠폰 사용에 실패하였습니다."
        End If
    End If
	
	Call Write_Log("sgpay_return.asp : bp_giftcard_status - " & ErrMessage)

	If errCode <> 0 Then
		'상태업데이트가 제대로 이루어지지 않음
		'페이지 리로드일 경우
		'POS에서 가져갈 상태로 만들지 못함......
		Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','errCode-"&errCode&"','0','sgpay-003')"
		dbconn.Execute(Sql)

	Else
		If member_type = "Member" Then
			Sql = "Select payco_log, coupon_amt From bt_order_payco Where order_idx="& order_idx
			Set Pinfo = dbconn.Execute(Sql)
			If Not Pinfo.eof Then 
				payco_log = Pinfo("payco_log")
				coupon_amt = Pinfo("coupon_amt")

				Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"','"& coupon_amt &"','sgpay-1')"
				dbconn.Execute(Sql)

				Set resC = OrderUseListForOrder(payco_log)
				If resC.mMessage = "SUCCESS" Then

					Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"','"& coupon_amt &"','sgpay-2')"
					dbconn.Execute(Sql)

					'pay_detail 생성
					'카드별 사용 포인트 추가
					For i = 0 To UBound(resC.mPointUseList)
						If resC.mPointUseList(i).mUsePoint > 0 Then
							db_call.DB_Payment_Insert order_idx, "PAYCOPOINT", resC.mCode, resC.mPointUseList(i).mAccountTypeCode, resC.mPointUseList(i).mCardNo, resC.mPointUseList(i).mUsePoint, "", resC.mCode, resC.mMessage, JSON.stringify(payco_log)
						End If
					Next

					Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"','"& coupon_amt &"','sgpay-3')"
					dbconn.Execute(Sql)

					'Response.write JSON.stringify(reqC.toJson())
					If coupon_amt > 0 Then
						db_call.DB_Payment_Insert order_idx, "PAYCOCOUPON", resC.mCode, "", "", coupon_amt, "", resC.mCode, resC.mMessage, JSON.stringify(payco_log)
					End If 

					Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"','"& coupon_amt &"','sgpay-4')"
					dbconn.Execute(Sql)

				Else
					If paytype = "Phone" Then
						CanCelURL = "/pay/danal/BillCancel.asp"
					ElseIf paytype = "Card" Then
						CanCelURL = "/pay/danal_card/BillCancel.asp"
					ElseIf paytype = "Payco" Then
					    CanCelURL = "/pay/payco/payco_cancel.asp"
					ElseIf paytype = "Paycoin" Then
					    CanCelURL = "/pay/paycoin/paycoin_cancel.asp"
					End If 

					Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","")  &"/"& Replace(resC.mMessage,"'","") &"/"& Replace(resC.mCode,"'","") &"/"&  CanCelURL &"','"& coupon_amt &"','sgpay-5')"
					dbconn.Execute(Sql)

					ErrMessage = "멤버십 처리 도중 오류가 발생했습니다."
				End If
			End If 
		End If 

		Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"','0','sgpay-6')"
		dbconn.Execute(Sql)

		'E 쿠폰처리 bt_order_detail 에 쿠폰 사용내역이 있다면 결제정보에 추가 함
		Set pinCmd = Server.CreateObject("ADODB.Command")
		with pinCmd
			.ActiveConnection = dbconn
			.CommandText = "bp_order_detail_select_ecoupon"
			.CommandType = adCmdStoredProc

			.Parameters.Append .CreateParameter("@ORDER_IDX", adInteger, adParamInput, , order_idx)
			Set pinRs = .Execute
		End With
		Set pinCmd = Nothing

		Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"','"& coupon_amt &"','sgpay-7')"
		dbconn.Execute(Sql)

		If pinRs.Eof And pinRs.Bof Then
		Else

			Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"','"& coupon_amt &"','sgpay-8')"
			dbconn.Execute(Sql)

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

			Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"/"& Replace(order_idx,"'","")  &"/"& Replace(member_idx,"'","")  &"/"& Replace(member_idno,"'","")  &"/"& Replace(member_type,"'","")  &"/"& Replace(pay_amt,"'","") &"','"& coupon_amt &"','sgpay-9')"
			dbconn.Execute(Sql)

			'연결된 pay가 있는지 확인'
			If Not (aRs.BOF Or aRs.EOF) Then

			Else
				'없으면 pay_idx 생성'
				Set aCmd = Server.CreateObject("ADODB.Command")
				With aCmd
					.ActiveConnection = dbconn
					.NamedParameters = True
					.CommandType = adCmdStoredProc
					.CommandText = "bp_payment_insert"

					.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,,order_idx)
					.Parameters.Append .CreateParameter("@member_idx", adInteger, adParamInput, , member_idx)
					.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, member_idno)
					.Parameters.Append .CreateParameter("@member_type", adVarChar, adParamInput, 10, member_type)
					.Parameters.Append .CreateParameter("@pay_amt", adCurrency, adParamInput,, pay_amt)
					.Parameters.Append .CreateParameter("@pay_status", adVarChar, adParamInput, 10, "P")

					.Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
					.Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

					.Execute

					errCode = .Parameters("@ERRCODE").Value
					errMsg = .Parameters("@ERRMSG").Value
				End With
				Set aCmd = Nothing

				Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"/"& errCode &"/"& errMsg &"','"& coupon_amt &"','sgpay-10')"
				dbconn.Execute(Sql)

			End If
			Set aRs = Nothing

			Do Until pinRs.EOF

				Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"','"& coupon_amt &"','sgpay-11')"
				dbconn.Execute(Sql)

				cl_eCoupon.KTR_Use_Pin pinRs("coupon_pin"), order_num, branch_id, branch_name, dbconn

				Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"/"& Replace(pinRs("coupon_pin"),"'","") &"','"& coupon_amt &"','sgpay-12')"
				dbconn.Execute(Sql)

				if cl_eCoupon.m_cd = "0" then
					db_call.DB_Payment_Insert order_idx, "ECOUPON", pinRs("coupon_pin"), "", "", pinRs("menu_price"), "", 0, "", ""

					' 마이 쿠폰사용
					Sql = "update bt_member_coupon set use_yn='Y', last_use_date=getdate(), order_idx='"& order_idx &"' where c_code='"& pinRs("coupon_pin") &"' "
					dbconn.Execute(Sql)



					Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"/"& Replace(pinRs("coupon_pin"),"'","") &"','"& coupon_amt &"','sgpay-13')"
					dbconn.Execute(Sql)

				else
					pg_RollBack = 1
				end if

				pinRs.MoveNext
			Loop

			ECOUPON_USECHECK = "Y"
		End If

		Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"','"& coupon_amt &"','sgpay_return-14')"
		dbconn.Execute(Sql)

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

		Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& order_idx &"','"& Replace(payco_log,"'","") &"','"& coupon_amt &"','sgpay-15')"
		dbconn.Execute(Sql)


		'====================================포인트 이벤트 2019-04-30 까지 진행
		PAYCOUPON_USEYN = "N"
		EVENTPOINT_PRODUCTCD = ""
		EVENT_POINT = 0
		If Date <= "2019-05-20" Then
			Set aCmd = Server.CreateObject("ADODB.Command")
			With aCmd
				.ActiveConnection = dbconn
				.NamedParameters = True
				.CommandType = adCmdStoredProc
				.CommandText = "bp_event_point_uselist"

				.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)

				Set aRs = .Execute
			End With
			Set aCmd = Nothing

			If Not (aRs.BOF Or aRs.EOF) Then
				aRs.MoveFirst
				Do until aRs.EOF
					EVT_PAYMETHOD	= aRs("pay_method")
					EVT_PRODUCTCD	= aRs("pay_transaction_id")

					If EVT_PAYMETHOD = "EVENTPOINT" Then 
						EVENTPOINT_PRODUCTCD = EVT_PRODUCTCD
						EVENT_POINT = 4000
					ElseIf EVT_PAYMETHOD = "PAYCOCOUPON" Then 
						PAYCOUPON_USEYN = "Y"
					End If 
					aRs.MoveNext
				Loop
			End If
			Set aRs = Nothing
		End If 

		Temp_EVENT_POINT = EVENT_POINT
		'====================================포인트 이벤트 2019-04-30 까지 진행

		Dim reqOC : Set reqOC = New clsReqOrderComplete
		reqOC.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
		reqOC.mMerchantCode = branch_id
	'    reqOC.mMerchantCode = PAYCO_MERCHANTCODE
		reqOC.mMemberNo = member_idno
		reqOC.mServiceTradeNo = order_num
		'reqOC.mOrderYmdt = dd&" "&dt

		If PAYCOUPON_USEYN = "Y" Then	'포인트이벤트에서 쿠폰사용시 적립안함
			reqOC.mSaveYn = "N"
		Else
			reqOC.mSaveYn = "Y"
		End If 

        If payMethodCode = "41" and cdate(date) >= cdate(paycoin_start_date) and cdate(date) <= cdate(paycoin_end_date) Then  '2020-12-02 페이코인 이벤트시 적립안함
            reqOC.mSaveYn = "N"
        End If 

		reqOC.mDeliveryCharge = delivery_fee
		reqOC.mOrderChannel = order_channel

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

		Set OItem = New clsOuterPayMethodList
		OItem.mCode = payMethodCode
		OItem.mPayAmount = pay_amt
		OItem.mApprovalNo = ""
		OItem.mApprovalYmdt = ""
		reqOC.addOuterPayMethodList(OItem)

		If Not (aRs.BOF Or aRs.EOF) Then
			aRs.MoveFirst
			Do until aRs.EOF
				Order_qty = aRs("menu_qty")
				Temp_Order_Qty = Order_qty

				If Temp_EVENT_POINT > 0 And ""&EVENTPOINT_PRODUCTCD = ""&aRs("menu_idx") Then '이벤트 포인트 사용한 경우
					Set pItem = New clsProductList
					If aRs("upper_order_detail_idx") = 0 Then
						pItem.mProductClassCd = "M"
						pItem.mProductClassNm = "메인"
					Else
						pItem.mProductClassCd = "S"
						pItem.mProductClassNm = "사이드"
					End If
					pItem.mProductCd = aRs("poscode")'aRs("menu_idx")'
					pItem.mProductNm = aRs("menu_name")
					pItem.mUnitPrice = aRs("menu_price") - Temp_EVENT_POINT
					pItem.mTargetUnitPrice = aRs("menu_price") - Temp_EVENT_POINT
					pItem.mProductCount = 1
					If Len(aRs("coupon_pin")) > 0 Then	'E 쿠폰 적립 제외
						pItem.mProductSaveYn = "N"
					else
						pItem.mProductSaveYn = "Y"
					End If 

					reqOC.addProductList(pItem)

					Temp_Order_Qty = Temp_Order_Qty - 1
					Temp_EVENT_POINT = 0

				End If 
				If Temp_Order_Qty > 0 Then 
					Set pItem = New clsProductList
					If aRs("upper_order_detail_idx") = 0 Then
						pItem.mProductClassCd = "M"
						pItem.mProductClassNm = "메인"
					Else
						pItem.mProductClassCd = "S"
						pItem.mProductClassNm = "사이드"
					End If
					pItem.mProductCd = aRs("poscode")'aRs("menu_idx")'
					pItem.mProductNm = aRs("menu_name")
					pItem.mUnitPrice = aRs("menu_price")
					pItem.mTargetUnitPrice = aRs("menu_price")
					pItem.mProductCount = Temp_Order_Qty
					If Len(aRs("coupon_pin")) > 0 Then	'E 쿠폰 적립 제외
						pItem.mProductSaveYn = "N"
					else
						pItem.mProductSaveYn = "Y"
					End If 

					reqOC.addProductList(pItem)
				End If 
				aRs.MoveNext
			Loop
		End If
		Set aRs = Nothing

		If member_type = "Member" Then
			SAMSUNG_EVENT = Session("SAMSUNG_EVENT")
			If SAMSUNG_EVENT = "Y" Then		'삼성이벤트는 페이코 전문 안보냄
				Session("SAMSUNG_EVENT") = ""
			Else 
				Dim resOC : Set resOC = OrderComplete(reqOC.toJson())
				Response.write "<!--complete "&resOC.mMessage&"||"&JSON.stringify(reqOC.toJson())&"-->"
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

			'포인트 이벤트 때문에 생성	
			If discount_amt > 0 Then	'이안에 이벤트 포인트 할인도 포함이 되어있어서 조건으로 사용 
				Set aCmd = Server.CreateObject("ADODB.Command")
				With aCmd
					.ActiveConnection = dbconn
					.NamedParameters = True
					.CommandType = adCmdStoredProc
					.CommandText = "bp_event_point_paymentyn"

					.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)
					.Parameters.Append .CreateParameter("@member_idx", adInteger, adParamInput, , member_idx)
					.Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)

					.Execute

					errCode = .Parameters("@ERRCODE").Value
				End With
				Set aCmd = Nothing
			End If 

		End If

		If TESTMODE <> "Y" Then 
			If Session("userName") <> "" Then 
				USERNAME = Session("userName")
			Else
				USERNAME = Right(delivery_mobile,4)
			End If 
			TP	= "AT" '알림톡
			CD	= "bizp_2019032115454613182471344"
			PARAM = "고객="& USERNAME &"|메뉴="& MENU_NAME & "|매장명="& branch_name	'[고객이름/번호]
			DEST_PHONE = delivery_mobile	'고객 전화번호
			SEND_PHONE = "15889282"

			Set aCmd = Server.CreateObject("ADODB.Command")
			With aCmd
				.ActiveConnection = dbconn
				.NamedParameters = True
				.CommandType = adCmdStoredProc
				.CommandText = "GNSIS_SMS.GNSIS_SMS.DBO.PRC_SET_SMS_WEB_V2"

				.Parameters.Append .CreateParameter("@TP", adVarChar, adParamInput, 10, TP)
				.Parameters.Append .CreateParameter("@CD", adVarChar, adParamInput, 40, CD)
				.Parameters.Append .CreateParameter("@PARAM", adVarChar, adParamInput, 4000, PARAM)
				.Parameters.Append .CreateParameter("@DEST_PHONE", adVarChar, adParamInput, 20, DEST_PHONE)
				.Parameters.Append .CreateParameter("@SEND_PHONE", adVarChar, adParamInput, 20, SEND_PHONE)
				.Parameters.Append .CreateParameter("@RET", adVarChar, adParamOutput, 4)

				.Execute
				RET = .Parameters("@RET").value
			End With
			Set aCmd = Nothing

			Sql = "	INSERT INTO TB_WEB_ORDER_SEND_MSG_LOG(ORDER_ID, ORDER_STATE, TARGET, DEST_PHONE, CD, SEND_MSG, SEND_RESULT, SEND_DTS)	" & _
				"	VALUES('"& order_num &"', 'P', 'M', '"& DEST_PHONE &"', '"& CD &"', '"& PARAM &"', '"& RET &"', GETDATE())	"
			dbconn.Execute(Sql)

			CD	= "bizp_2019031516533411385566079"
			PARAM = "고객전화번호="& delivery_mobile		'[고객전화번호]
			DEST_PHONE = branch_phone	'매장 전화번호

			Set aCmd = Server.CreateObject("ADODB.Command")
			With aCmd
				.ActiveConnection = dbconn
				.NamedParameters = True
				.CommandType = adCmdStoredProc
				.CommandText = "GNSIS_SMS.GNSIS_SMS.DBO.PRC_SET_SMS_WEB_V2"

				.Parameters.Append .CreateParameter("@TP", adVarChar, adParamInput, 10, TP)
				.Parameters.Append .CreateParameter("@CD", adVarChar, adParamInput, 40, CD)
				.Parameters.Append .CreateParameter("@PARAM", adVarChar, adParamInput, 4000, PARAM)
				.Parameters.Append .CreateParameter("@DEST_PHONE", adVarChar, adParamInput, 20, DEST_PHONE)
				.Parameters.Append .CreateParameter("@SEND_PHONE", adVarChar, adParamInput, 20, SEND_PHONE)
				.Parameters.Append .CreateParameter("@RET", adVarChar, adParamOutput, 4)

				.Execute
				RET = .Parameters("@RET").value
			End With
			Set aCmd = Nothing

			Sql = "	INSERT INTO TB_WEB_ORDER_SEND_MSG_LOG(ORDER_ID, ORDER_STATE, TARGET, DEST_PHONE, CD, SEND_MSG, SEND_RESULT, SEND_DTS)	" & _
				"	VALUES('"& order_num &"', 'P', 'P', '"& DEST_PHONE &"', '"& CD &"', '"& PARAM &"', '"& RET &"', GETDATE())	"
			dbconn.Execute(Sql)
		End If 
	End If

		Response.End
	Else
		'-----------------------------------------------------------------------------
		'
		' 오류일 경우 오류페이지를 표시하거나 결제되지 않았음을 고객에게 통보합니다.
		' 팝업창 닫기 또는 구매 실패 페이지 작성 ( 팝업창 닫을때 Opener 페이지 이동 등 )
		'
		'-----------------------------------------------------------------------------
		'결제 인증 후 내부 오류가 있어 승인은 받지 않았습니다. 오류내역을 여기에 표시하세요. 예) 재고 수량이 부족합니다.
		Call Write_Log("sgpay_return.asp Error : " & ErrMessage)

		Response.redirect "sgpay_cancel.asp?order_num="&order_num&"&tid="&ret_TxId
		'Set resMC = OrderCancelListForOrder(order_idx)

		If resMC.mCode = 0 Then
			paycoDone = True
		End If

	End if
%>