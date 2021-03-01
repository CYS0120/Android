<!--#include file="sgpay.inc.asp"-->
<%
	order_num		= GetReqStr("order_num","")
	tid					= GetReqStr("tid","")
	pay_method	= "SGPAY"

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
		order_idx		= pRs("order_idx")
		TxId				= pRs("pay_transaction_id")
		Corporation	= pRs("pay_cpid")
		Merchant		= pRs("pay_subcp")
		Amount			= pRs("pay_amt")
		pay_err_msg	= pRs("pay_err_msg")
		pay_type		= pRs("pay_type")

		Set sCmd = Server.CreateObject("ADODB.Command")
		With sCmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_sgpay_log_select_one"

			.Parameters.Append .CreateParameter("@order_num", advarchar, adParamInput, 40, order_num)

			Set sRs = .Execute
		End With
		Set sCmd = Nothing

		Merchantcd	= sRs("merchant")
		pay_time		= sRs("paymenttime")
		pay_no			= sRs("paymentno")

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
			USER_ID = pRs("member_idno")
		Else
			USER_ID = ""
		End If
		
		Set pRs = Nothing
	Else
		Response.write "FAIL|존재하지 않는 주문번호"
		response.End
	End If
	Set pRs = Nothing

	If tid <> TxId Then
		Response.write "FAIL|TID 불일치"
		Response.end
	End If

	'Response.write order_num
	'Response.end
	'-----------------------------------------------------------------------------
	' (로그) 호출 시점과 호출값을 파일에 기록합니다.
	'-----------------------------------------------------------------------------
	Dim xform, receive_str
	receive_str = "sgpay_cancel.asp is Called - "
	For Each xform In Request.form
		receive_str = receive_str +  CStr(xform) + " : " + request(xform) + ", "
	Next
	Call Write_Log(receive_str)


	'-----------------------------------------------------------------------------
	' 취소 값 검증
	'-----------------------------------------------------------------------------


	'-----------------------------------------------------------------------------
	' 취소 내역을 담을 JSON OBJECT를 선언합니다.
	'-----------------------------------------------------------------------------
	Dim cancelOrder
	Set cancelOrder = New aspJSON
	With cancelOrder.data
		'---------------------------------------------------------------------------------
		' 설정한 주문정보 변수들로 Json String 을 작성합니다.
		'---------------------------------------------------------------------------------
		.Add "Corporation", CStr(Corporation)				' 가맹점 코드
		.Add "Merchant", CStr(Merchantcd)					' 가맹점 코드
		.Add "Member", CStr(USER_ID)						' 회원코드
		.Add "TradeNo", CStr(order_num)					' 주문번호
		.Add "Amount", CStr(Amount)						' 주문금액
		.Add "PaymentTime", CStr(pay_time)				' 주문시간
		.Add "PaymentNo", CStr(pay_no)					' 결제번호
		.Add "TxId", CStr(TxId)									' 트랜잭션 식별자
	End With


	'---------------------------------------------------------------------------------
	' 암호화
	'---------------------------------------------------------------------------------
	encryptedJson = Com.encrypt(cancelOrder.JSONoutput(), secretkey)


	'---------------------------------------------------------------------------------
	' 주문 결제 취소 API 호출 ( JSON 데이터로 호출 )
	'---------------------------------------------------------------------------------
	Call Write_Log("cancelOrder.JSONoutput() : " & cancelOrder.JSONoutput())
	Call Write_Log("encryptedJson : " & encryptedJson)
	If corporationToken <> Corporation Then
		sgPayCancelUrl	= Replace(sgPayCancelUrl, "https://stg-stargate.kbstar.com", "https://stargate.kbstar.com")						' SG Pay 취소 URL
		If Corporation = "B6C3DAF451954724904D4D39F38E5B13" Then
			sgPayCancelUrl	= Replace(sgPayCancelUrl, "https://stargate.kbstar.com", "https://stg-stargate.kbstar.com")						' SG Pay 취소 URL
		End If
	End If
	Result = sgpay_cancel("token=" & encryptedJson)


	'-----------------------------------------------------------------------------
	' 결과를 호출한 쪽에 리턴
	'-----------------------------------------------------------------------------
	Call Write_Log("Result : " & Result)


	Dim Verify_Read_Data
	Set Verify_Read_Data = New aspJSON		'Read_Data.data("result").item("orderProducts")
	Verify_Read_Data.loadJSON(Result)

	Dim returnMsg, errMsg

	If Verify_Read_Data.data("Success") = True Then
		returnMsg	= "SUCC|취소 완료"
		errMsg		= "취소 성공"
	Else
		returnMsg	= "FAIL|FAIL"
		'errMsg		= Verify_Read_Data.data("Reason")
		errMsg		= "취소 실패"
	End If

	'sgpay_pay_log 생성'
	Set aCmd = Server.CreateObject("ADODB.Command")

	With aCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_sgpay_log_insert"

		.Parameters.Append .CreateParameter("@act", adVarChar, adParamInput, 30, "CANCEL")
		.Parameters.Append .CreateParameter("@order_num", adVarChar, adParamInput, 50, order_num)
		.Parameters.Append .CreateParameter("@amt", adCurrency, adParamInput,, AMOUNT)
		.Parameters.Append .CreateParameter("@corporation", adVarChar, adParamInput, 32, Corporation)
		.Parameters.Append .CreateParameter("@merchant", adVarChar, adParamInput, 32, Merchantcd)
		.Parameters.Append .CreateParameter("@txid", adVarChar, adParamInput, 32, TxId)
		.Parameters.Append .CreateParameter("@result", adVarChar, adParamInput, 500, Result)
		.Parameters.Append .CreateParameter("@paymentno", adVarChar, adParamInput, 50, pay_no)
		.Parameters.Append .CreateParameter("@paymenttime", adVarChar, adParamInput, 14, pay_time)
		.Parameters.Append .CreateParameter("@errmsg", adVarChar, adParamInput, 500, errMsg)
		.Parameters.Append .CreateParameter("@etc1", adLongVarWChar, adParamInput, 2147483647, returnMsg)
		.Parameters.Append .CreateParameter("@seq", adInteger, adParamOutput)

		.Execute

	End With
	Set aCmd = Nothing

	Response.Write returnMsg

	Call Write_Log("sgpay_cancel.asp Complete!")
%>