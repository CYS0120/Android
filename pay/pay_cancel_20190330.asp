<!--#include virtual="/api/include/utf8.asp"-->
<%
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

    order_num    = GetReqStr("order_id", "")
    sms_msg    = GetReqStr("sms_msg", "")
    If Len(sms_msg) = 0 Then sms_msg = ""

    is_call    = GetReqStr("is_call", "")
    If Len(is_call) = 0 Then is_call = ""


    'Call DBConnect

    Set oCmd = Server.CreateObject("ADODB.Command")
    Set oRs = server.createobject("ADODB.RecordSet")

    with oCmd
        .ActiveConnection = dbconn
        .CommandText = "bp_payment_detail_select"'"BBQ.DBO.UP_ORDER_CANCEL_INFO"
        .CommandType = adCmdStoredProc

        .Parameters.Append .CreateParameter("@order_num", advarchar, adParamInput, 40, order_num)
		.Parameters.Append .CreateParameter("@TotalCount", adInteger, adParamOutput)

		total_count = .Parameters("@TotalCount").Value

        oRs.CursorLocation = adUseClient
        oRs.Open oCmd
    End with

	paycoDone = False
	paycoMembership_result = ""
	paycoMembership = False
	paycoMembershipCnt = 0

    While Not oRs.EOF
    'If Not oRs.EOF Then
'        Response.write oRs("TP") & " | " & oRs("TID") & " | " & oRs("AMOUNT") & "<BR>"
		
		order_idx = oRs("order_idx")
		branch_id = oRs("branch_id")
		'pay_transaction_id = oRs("pay_transaction_id")

        If oRs("pay_method") = "DANALPHONE" Then

			host = "http://bbq.fuzewire.com/pay/danal/BillCancel.asp"
			params = "order_idx="&order_idx&"&tid="&oRs("pay_transaction_id")&"&order_num="&order_num&"&gubun=Order"
			html_result = URL_Send(host, params)

        ElseIf oRs("pay_method") = "DANALCARD" Then

			'host = "https://api.bbq.co.kr:446/danal_cc/BillCancel.aspx"
			'params = "loginCredential=C3FC3899301A3758AF2C546604158BFBF4F79D3AC2041BEF7566EBBA3F58D379F09C55C29FFD2ADD5DDEA80BE69628EC754BEA683EF07158FBB7F26F190BA89E2ADEAD2A862B4171AF3D956B95C586437BA7D069C0EC2903E740AAFA44CAB467AFC6D07F84C163CCEECDD8BB496DE5524440D4A90D11445C2844056642BBB1DD" & "&orderID="&order_id&"&cancelRequester=WEBADMIN&cancelDescription=WEBADMIN&isDebug=false"
			host = "http://bbq.fuzewire.com/pay/danal_card/BillCancel.asp"
			params = "order_idx="&order_idx&"&tid="&oRs("pay_transaction_id")&"&order_num="&order_num&"&gubun=Order"
			html_result = URL_Send(host, params)

        ElseIf oRs("pay_method") = "PAYCO" Then

            host = "https://bbq.fuzewire.com/pay/payco/payco_cancel.asp"
            params = "order_idx="&order_idx&"&tid="&oRs("pay_err_msg")&"&order_num="&order_num

            html_result = URL_Send(host, params)

        ElseIf oRs("pay_method") = "PAYCOPOINT" Or oRs("pay_method") = "PAYCOCOUPON" Then
			paycoMembership = True
			paycoMembershipCnt = paycoMembershipCnt + 1

			'If paycoDone = False Then
				Set resMC = OrderCancelListForOrderV2(order_idx, oRs("branch_id"))

				If resMC.mCode = 0 Then
                    paycoMembership_result = "SUCC|"
					paycoDone = True
                Else
                    paycoMembership_result = "FAIL|"
				End If
                
			'End If
        End If

		'On Error Resume Next 'try
		'kt_host = "https://www.bbq.co.kr/pay/kt/point_cancel.asp"
		'kt_param = "ORDER_ID="&order_id
		'kt_result = URL_Send(kt_host, kt_param)

		'If Not Err.Number = 0 Then 'catch
		'	kt_host = "https://www.bbq.co.kr/pay/kt/point_cancel.asp"
		'	kt_param = "ORDER_ID="&order_id
		'	kt_result = URL_Send(kt_host, kt_param)
		'End If

		' 취소가 정상적으로 되지 않은 경우 두번 더 시도
		'If kt_result <> "0000" Then
		'	kt_host = "https://www.bbq.co.kr/pay/kt/point_cancel.asp"
		'	kt_param = "ORDER_ID="&order_id
		'	kt_result = URL_Send(kt_host, kt_param)
		'End If

		'If kt_result <> "0000" Then
		'	kt_host = "https://www.bbq.co.kr/pay/kt/point_cancel.asp"
		'	kt_param = "ORDER_ID="&order_id
		'	kt_result = URL_Send(kt_host, kt_param)
		'End If

        'Response.write html_result

    'End If

'        Response.write "HTML_RESULT : " & html_result & "<BR>"

        oRs.MoveNext
    Wend

    If total_count = paycoMembershipCnt Then
        Response.write paycoMembership_result
    Else
        Response.write html_result
    End If

'    Response.End

    ' 발송 메시지가 없다면 기본 문자 발송 (취소 사유 없을 시)

    arr_result = Split(html_result, "|")

    If arr_result(0) = "SUCC" And Len(is_call) = 0 Then

      Set oCmd = Server.CreateObject("ADODB.Command")

        with oCmd
            .ActiveConnection = dbconn
            .CommandText = "BBQ.DBO.UP_ORDER_SEND_MESSAGE"
            .CommandType = adCmdStoredProc

            .Parameters.Append .CreateParameter("@ORDER_ID",        adVarChar,  adParamInput,100, order_id )
            .Parameters.Append .CreateParameter("@MSG",      adVarChar,  adParamInput, 100, sms_msg)

            .Execute , , adExecuteNoRecords
        End with

        Set oCmd = Nothing
'        Response.write "sms_msg : " & sms_msg
    End If

    'Call DBDisConnect

%>