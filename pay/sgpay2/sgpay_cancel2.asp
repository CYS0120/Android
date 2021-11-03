<!--#include file="sgpay.inc.asp" -->
<%
	order_num		= GetReqStr("order_num","")
	tid				= GetReqStr("tid","")
	pay_method		= "SGPAY2"
	sms_msg			= GetReqStr("sms_msg","")


	' //-------------------------------------------------------
	' // 사전체크
	' //-------------------------------------------------------

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
		TxId			= pRs("pay_transaction_id")
		Corporation		= pRs("pay_cpid")
		s_MERTNO		= pRs("pay_subcp")
		Amount			= pRs("pay_amt")
		pay_err_msg		= pRs("pay_err_msg")
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
		pay_time	= sRs("paymenttime")
		pay_no		= sRs("paymentno")

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

	'-----------------------------------------------------------------------------
	' (로그) 호출 시점과 호출값을 파일에 기록합니다.
	'-----------------------------------------------------------------------------
	Dim xform, receive_str
	receive_str = "sgpay_cancel2.asp is Called - "
	For Each xform In Request.form
		receive_str = receive_str +  CStr(xform) + " : " + request(xform) + ", "
	Next
	Call Write_Log(receive_str)

	s_userMngNo = GetuserMngNo(USER_ID)
	Result = PayCancel(s_MERTNO, USER_ID, s_userMngNo, TxId, sms_msg)

	Dim Verify_Read_Data
	Set Verify_Read_Data = New aspJSON		'Read_Data.data("result").item("orderProducts")
	Verify_Read_Data.loadJSON(Result)

	Dim returnMsg, errMsg, resultCode

	resultCode = Verify_Read_Data.data("resultCode")

	If resultCode = "0000" or resultCode = "5409" Then
		returnMsg	= "SUCC|취소 완료"
		errMsg		= "취소 성공"
	Else
		returnMsg	= "FAIL|" & Verify_Read_Data.data("resultMsg")
		errMsg		= "취소 실패"
	End If

	'sgpay_pay_log 생성'
	Set aCmd = Server.CreateObject("ADODB.Command")

	With aCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_sgpay2_log_insert"

		.Parameters.Append .CreateParameter("@act", adVarChar, adParamInput, 30, "CANCEL")
		.Parameters.Append .CreateParameter("@order_num", adVarChar, adParamInput, 50, order_num)
		.Parameters.Append .CreateParameter("@amt", adCurrency, adParamInput,, AMOUNT)
		.Parameters.Append .CreateParameter("@corporation", adVarChar, adParamInput, 32, g_CORPNO)
		.Parameters.Append .CreateParameter("@merchant", adVarChar, adParamInput, 32, s_MERTNO)
		.Parameters.Append .CreateParameter("@corpMemberNo", adVarChar, adParamInput, 100, USER_ID)
		.Parameters.Append .CreateParameter("@userMngNo", adVarChar, adParamInput, 100, s_userMngNo)
		.Parameters.Append .CreateParameter("@txid", adVarChar, adParamInput, 32, TxId)
		.Parameters.Append .CreateParameter("@result", adVarChar, adParamInput, 10, resultCode)
		.Parameters.Append .CreateParameter("@paymentno", adVarChar, adParamInput, 50, "")
		.Parameters.Append .CreateParameter("@paymenttime", adVarChar, adParamInput, 14, "")
		.Parameters.Append .CreateParameter("@errmsg", adVarChar, adParamInput, 1000, returnMsg)
		.Parameters.Append .CreateParameter("@etc1", adLongVarWChar, adParamInput, 2147483647, "")
		.Parameters.Append .CreateParameter("@seq", adInteger, adParamOutput)

		.Execute

	End With
	Set aCmd = Nothing

	Response.Write returnMsg

	Call Write_Log("sgpay_cancel2.asp Complete!")

%>