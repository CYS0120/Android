<!--#include virtual="/api/include/utf8.asp"-->
<%
    Response.AddHeader "pragma","no-cache"
    Response.AddHeader "Expires","0"

    Function URL_Send(host, params)
        url = host&"?"&params
'        Response.write url & "<BR>"
        Set objHttp = server.CreateObject("Msxml2.ServerXMLHTTP")

        If IsNull(objHttp) Then
            URL_Send = ""
        Else
            objHttp.Open "POST", url, False
            objHttp.SetRequestHeader "Content-Type","application/x-www-form-urlencoded;charset=utf-8"
            objHttp.Send data

            URL_Send = objHttp.responseText ' 결과데이터 파서로 넘기기 위해 별도 저장

            Set objHttp = Nothing '개체 소멸
        End If

    End Function
	'http://bbq.fuzewire.com/pay/pay_cancel.asp?order_id=W20000000002117

    ORDER_ID   = GetReqStr("order_id", "")
    sms_msg    = GetReqStr("sms_msg", "")
    If Len(sms_msg) = 0 Then sms_msg = ""

    is_call    = GetReqStr("is_call", "")
    If Len(is_call) = 0 Then is_call = ""

    Set oCmd = Server.CreateObject("ADODB.Command")
    Set oRs = server.createobject("ADODB.RecordSet")

    with oCmd
        .ActiveConnection = dbconn
        .CommandText = "BBQ.DBO.UP_ORDER_CANCEL_INFO"
        .CommandType = adCmdStoredProc

        .Parameters.Append .CreateParameter("@ORDER_ID", advarchar, adParamInput, 40, ORDER_ID)

        oRs.CursorLocation = adUseClient
        oRs.Open oCmd
    End With

    If Not oRs.EOF Then
'		Response.write oRs("ORDER_IDX") & " | " & oRs("ORDER_ID") & " | " & oRs("PAY_TYPE") & " | " & oRs("PAY_AMT") & " | " & oRs("TID") & " | " & oRs("BRANCH_ID") & " | " & oRs("CUST_ID") & "<BR>"

		ORDER_IDX	= oRs("ORDER_IDX")
		ORDER_ID	= oRs("ORDER_ID")
		PAY_TYPE	= oRs("PAY_TYPE")
		PAY_AMT		= oRs("PAY_AMT")
		TID			= oRs("TID")
		BRANCH_ID	= oRs("BRANCH_ID")
		CUST_ID		= oRs("CUST_ID")
		vPaycoin_Cpid		= oRs("paycoin_cpid")

		'결제수단 취소
        If PAY_TYPE = "Phone" Then

			host = SITE_DOMAINURL_BBQ & "/pay/danal/BillCancel.asp"
			params = "tid="& TID &"&order_num="& ORDER_ID
			html_result = URL_Send(host, params)

        ElseIf PAY_TYPE = "Card" Then

			host = SITE_DOMAINURL_BBQ & "/pay/danal_card/BillCancel.asp"
			params = "tid="& TID &"&order_num="& ORDER_ID
			html_result = URL_Send(host, params)

        ElseIf PAY_TYPE = "Payco" Then

            host = SITE_DOMAINURL_BBQ & "/pay/payco/payco_cancel.asp"
            params = "tid="& TID &"&order_num="& ORDER_ID
            html_result = URL_Send(host, params)

        ElseIf PAY_TYPE = "Paycoin" Then

            host = SITE_DOMAINURL_BBQ & "/pay/paycoin/cancel_ajax.aspx"
            params = "tid="& TID &"&orderid="& ORDER_ID &"&cp_id="& vPaycoin_Cpid
            html_result = URL_Send(host, params)

			' paycoin은 닷넷이라 실제로 취소후 데이터 처리
			arr_result = Split(html_result, "|")

			Set pCmd = Server.CreateObject("ADODB.Command")
			With pCmd
				.ActiveConnection = dbconn
				.NamedParameters = True
				.CommandType = adCmdStoredProc
				.CommandText = "bp_payment_detail_select_pg"

				.Parameters.Append .CreateParameter("@order_num", advarchar, adParamInput, 40, ORDER_ID)
				.Parameters.Append .CreateParameter("@pay_method", advarchar, adParamInput, 20, "PAYCOIN")

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
			End If

			returncode = arr_result(2)
			returnmsg = arr_result(3)

			If returncode = "0000" Then 
				returncode = "0"
			End If 

			query = ""
			query = query & "INSERT INTO bt_paycoin_log (ACT, ORDER_NUM, AMT, CPID, SUBCP, TID, RESULT, ERRMSG, REGDATE) "
			query = query & "VALUES('CANCEL', '"& ORDER_ID &"', "& AMOUNT &", '"& CPID &"', '"& SUBCPID &"', '"& TID &"', '"& returncode &"', '"& returnmsg &"', GETDATE()) "
			dbconn.Execute(query)

		Else
			html_result = "SUCC|"
		End If
		
        '쿠폰 취소 및 주문 상태 변경
		arr_result = Split(html_result, "|")
		If arr_result(0) = "SUCC" Then
			'쿠폰 취소처리시  주문 취소도 함께 처리
			host = SITE_DOMAINURL_BBQ & "/pay/ktr/Coupon_Cancel_html.asp"
            params = "order_id="& ORDER_ID &"&tid="& TID
            html_result = URL_Send(host, params)			

		' 주문상태 변경?
			Set aCmd = Server.CreateObject("ADODB.Command")
			With aCmd
				.ActiveConnection = dbconn
				.NamedParameters = True
				.CommandType = adCmdStoredProc
				.CommandText = "bp_order_status_update"

				.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , ORDER_IDX)
				.Parameters.Append .CreateParameter("@order_status", adVarChar, adParamInput, 10, "C")
				.Parameters.Append .CreateParameter("@pay_type", adVarChar, adParamInput, 10, PAY_TYPE)
				.Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
				.Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

				.Execute

				errCode = .Parameters("@ERRCODE").Value
				errMsg = .Parameters("@ERRMSG").Value		

				'response.write errCode
				'response.write errMsg
			End With
			Set aCmd = Nothing
	'Response.write "aa"&order_idx	
			' 주문상태 변경? C -> B
			Set aCmd = Server.CreateObject("ADODB.Command")
			With aCmd
				.ActiveConnection = dbconn
				.NamedParameters = True
				.CommandType = adCmdStoredProc
				.CommandText = "bp_order_status_update"

				.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , ORDER_IDX)
				.Parameters.Append .CreateParameter("@order_status", adVarChar, adParamInput, 10, "B")
				.Parameters.Append .CreateParameter("@pay_type", adVarChar, adParamInput, 10, PAY_TYPE)
				.Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
				.Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

				.Execute

				errCode = .Parameters("@ERRCODE").Value
				errMsg = .Parameters("@ERRMSG").Value		

				'response.write errCode
				'response.write errMsg
			End With
			Set aCmd = Nothing

			Set Cmd = Server.CreateObject("ADODB.Command")
			With Cmd
				.ActiveConnection = dbconn
				.NamedParameters = True
				.CommandType = adCmdStoredProc
				.CommandText = "bp_payment_update_status"

				.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,, ORDER_IDX)
				.Parameters.Append .CreateParameter("@pay_status", adVarChar, adParamInput, 10, "Canceled")
				.Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
				.Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput,500)

				.Execute

				errCode = .Parameters("@ERRCODE").Value
				errMsg = .Parameters("@ERRMSG").Value
			End With
			Set Cmd = Nothing

		End If
	Else
		html_result = "FAIL|NO DATA"
	End If

    Response.write html_result

'    Response.End

    ' 발송 메시지가 없다면 기본 문자 발송 (취소 사유 없을 시)
'html_result = "SUCC|"

    arr_result = Split(html_result, "|")
	
	PAY_GB = Left(ORDER_ID,1)	'W, M, X 만 페이코로 전송
'	If PAY_TYPE = "Phone" Or PAY_TYPE = "Card" Or PAY_TYPE = "Payco" Then
	If PAY_GB = "W" Or PAY_GB = "M" Or PAY_GB = "X" Then 
		If arr_result(0) = "SUCC" Then	'성공이면 페이코에 주문취소 전문 발송

			If PAY_TYPE = "Card" Then 
				payMethodCode = "23"
			ElseIf PAY_TYPE = "Phone" Then 
				payMethodCode = "24"
			ElseIf PAY_TYPE = "Payco" Then 
				payMethodCode = "31"
			ElseIf PAY_TYPE = "Paycoin" Then 
				payMethodCode = "41"
			ElseIf PAY_TYPE = "Later" Then 
				payMethodCode = "23"
			ElseIf PAY_TYPE = "Cash" Then 
				payMethodCode = "21"
			Else
				payMethodCode = "99"
			End If

			Set reqC = New clsReqOrderCancel
			reqC.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
			reqC.mMerchantCode = BRANCH_ID
			reqC.mMemberNo = CUST_ID
			reqC.mServiceTradeNo = ORDER_ID
			reqC.mCancelType = "ALL"

			Set tC = New clsOuterPayMethodCancelList
			tC.mCode = payMethodCode
			tC.mPayAmount = PAY_AMT
			tC.mApprovalNo = TID
			tC.mApprovalYmdt = ""
	'Response.write JSON.stringify(tC.toJson())
			reqC.addOuterPayMethodCancelList(tC)

	'Response.write JSON.stringify(reqC.toJson())

			Set resC = OrderCancel(reqC.toJson())
	'Response.Write resC.mCode & "<br>"
	'Response.Write resC.mMessage & "<br>"

			resCode = resC.mCode
			If resCode = 0 Then
				
			Else
				
			End If
	'		Response.Write resCode & "<br>"
		End If 
	End If 
'Response.End 
	If arr_result(0) = "SUCC" And Len(is_call) = 0 Then

		Set Mcmd = Server.CreateObject("ADODB.Command")
		With Mcmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "BBQ.DBO.bp_bbq_order_cancel"
			.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , ORDER_IDX)
			
			.Execute
		End With
		Set Mcmd = Nothing

		If Date <= "2019-05-20" Then 
			Set Mcmd = Server.CreateObject("ADODB.Command")
			With Mcmd
				.ActiveConnection = dbconn
				.NamedParameters = True
				.CommandType = adCmdStoredProc
				.CommandText = "BBQ.DBO.bp_event_point_reuse"
				.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , ORDER_IDX)
				
				.Execute
			End With
			Set Mcmd = Nothing
		End If 

		If TESTMODE = "Y" Then 
			Set Mcmd = Server.CreateObject("ADODB.Command")
			With Mcmd
				.ActiveConnection = dbconn
				.NamedParameters = True
				.CommandType = adCmdStoredProc
				.CommandText = "BBQ.DBO.bp_order_msg_info"
				.Parameters.Append .CreateParameter("@order_num", adVarChar, adParamInput, 50, order_id)
				Set Mrs = .Execute
			End With
			Set Mcmd = Nothing
			If Not Mrs.Eof Then

				delivery_mobile	= Mrs("delivery_mobile")
				branch_name		= Mrs("branch_name")
				branch_phone	= Mrs("branch_phone")
				branch_tel		= Mrs("branch_tel")
				MENU_NAME		= Mrs("MENU_NAME")
				
				TP	= "AT" '알림톡
				CD	= "bizp_2019031817132511385617140"
				PARAM = "고객이름="& Right(delivery_mobile,4) &"||매장명="& branch_name &"|사유="& sms_msg
				'고객이름=[고객이름]||매장명=[매장명]|사유=[사유]
				DEST_PHONE = delivery_mobile	'고객 전화번호
				SEND_PHONE = "15889282"

				RET = "0000"

				Sql = "	INSERT INTO TB_WEB_ORDER_SEND_MSG_LOG(ORDER_ID, ORDER_STATE, TARGET, DEST_PHONE, CD, SEND_MSG, SEND_RESULT, SEND_DTS)	" & _
					"	VALUES('"& order_id &"', 'B', 'M', '"& DEST_PHONE &"', '"& CD &"', '"& PARAM &"', '"& RET &"', GETDATE())	"
				dbconn.Execute(Sql)

				CD	= "bizp_2019031516533413182201091"
				PARAM = "고객전화번호="& delivery_mobile
				'고객전화번호=[고객전화번호]
				DEST_PHONE = branch_phone	'매장 전화번호
				SEND_PHONE = "15889282"

				RET = "0000"

				Sql = "	INSERT INTO TB_WEB_ORDER_SEND_MSG_LOG(ORDER_ID, ORDER_STATE, TARGET, DEST_PHONE, CD, SEND_MSG, SEND_RESULT, SEND_DTS)	" & _
					"	VALUES('"& order_id &"', 'B', 'P', '"& DEST_PHONE &"', '"& CD &"', '"& PARAM &"', '"& RET &"', GETDATE())	"
				dbconn.Execute(Sql)
			End If 
		Else
			Set Mcmd = Server.CreateObject("ADODB.Command")
			With Mcmd
				.ActiveConnection = dbconn
				.NamedParameters = True
				.CommandType = adCmdStoredProc
				.CommandText = "BBQ.DBO.bp_order_msg_info"
				.Parameters.Append .CreateParameter("@order_num", adVarChar, adParamInput, 50, order_id)
				Set Mrs = .Execute
			End With
			Set Mcmd = Nothing
			If Not Mrs.Eof Then

				delivery_mobile	= Mrs("delivery_mobile")
				branch_name		= Mrs("branch_name")
				branch_phone	= Mrs("branch_phone")
				branch_tel		= Mrs("branch_tel")
				MENU_NAME		= Mrs("MENU_NAME")
				
				TP	= "AT" '알림톡
				CD	= "bizp_2019031817132511385617140"
				PARAM = "고객이름="& Right(delivery_mobile,4) &"||매장명="& branch_name &"|사유="& sms_msg
				'고객이름=[고객이름]||매장명=[매장명]|사유=[사유]
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
					"	VALUES('"& order_id &"', 'B', 'M', '"& DEST_PHONE &"', '"& CD &"', '"& PARAM &"', '"& RET &"', GETDATE())	"
				dbconn.Execute(Sql)

				CD	= "bizp_2019031516533413182201091"
				PARAM = "고객전화번호="& delivery_mobile
				'고객전화번호=[고객전화번호]
				DEST_PHONE = branch_phone	'매장 전화번호
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
					"	VALUES('"& order_id &"', 'B', 'P', '"& DEST_PHONE &"', '"& CD &"', '"& PARAM &"', '"& RET &"', GETDATE())	"
				dbconn.Execute(Sql)
			End If 
		End If 
'        Response.write "sms_msg : " & sms_msg
    End If
%>