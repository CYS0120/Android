<%
    Response.AddHeader "pragma","no-cache"

	param_tid = Request("tid")
	param_order_num = Request("order_num")
	param_vPaycoin_Cpid = Request("vPaycoin_Cpid")

	If param_tid <> "" Then ' get방식 주문취소일경우 (관리자페이지에서)
		paycoin_tid = param_tid
		paycoin_order_num = param_order_num
		paycoin_vPaycoin_Cpid = param_vPaycoin_Cpid
	Else
		paycoin_tid = Request.Cookies("paycoin_tid")
		paycoin_order_num = Request.Cookies("paycoin_order_num")
		paycoin_vPaycoin_Cpid = Request.Cookies("paycoin_vPaycoin_Cpid")
	End If 

	Response.Cookies("paycoin_tid") = ""
	Response.Cookies("paycoin_order_num") = ""
	Response.Cookies("paycoin_vPaycoin_Cpid") = ""


	order_num	= paycoin_order_num
	tid			= paycoin_tid
	pay_method	= "PAYCOIN"

	'/********************************************************************************
    ' *
    ' * 다날 휴대폰 결제 취소
    ' *
    ' * - 결제 취소 요청 페이지
    ' *      CP인증 및 결제 취소 정보 전달
    ' *
    ' * 결제 시스템 연동에 대한 문의사항이 있으시면 서비스개발팀으로 연락 주십시오.
    ' * DANAL Commerce Division Technique supporting Team
    ' * EMail : tech@danal.co.kr
    ' *
    ' ********************************************************************************/

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
		pay_transaction_id	= pRs("pay_transaction_id")
		CPID		= pRs("pay_cpid")
		SUBCPID		= pRs("pay_subcp")
		AMOUNT		= pRs("pay_amt")
		paytype		= pRs("pay_type")
	Else
		Response.write "FAIL|존재하지 않는 주문번호"
		response.End
	End If
	

	Set pRs = Nothing

	If tid <> pay_transaction_id Then
		Response.write "FAIL|TID 불일치"
		Response.end
	End If

	IF returncode = "0000" Then		
		returncode = "0"
		query = ""
		query = query & "INSERT INTO bt_paycoin_log (ACT, ORDER_NUM, AMT, CPID, SUBCP, TID, RESULT, ERRMSG, REGDATE) "
		query = query & "VALUES('CANCEL', '"& order_num &"', "& AMOUNT &", '"& CPID &"', '"& SUBCPID &"', '"& TID &"', '"& returncode &"', '"& returnmsg &"', GETDATE()) "
		dbconn.Execute(query)

		Response.write "SUCC|SUCCESS"
    Else
        Response.write "FAIL|FAIL"'&RES.Item("ErrMsg")
    End If

%>
