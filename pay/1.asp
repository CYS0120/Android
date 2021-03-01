<!--#include virtual="/api/include/ktr_exchange_proc_utf8.asp"-->
<%

'''' 쿠폰취소 간단 코드
' SET KTR = NEW PosResult
' KTR.Smartcon_Proc "cancel", "111624916587", "7251403", "왕십리행운점", "0", Replace(Date, "-", ""), Replace(FormatDateTime(Time(), 4), ":","") & Right(Time(), 2), ok_num
' response.write 		KTR.m_StatusCode

'response.write "포인트 취소"
response.end 
response.end 
response.end 
response.end 
response.end 
response.end 
response.end 


    Response.AddHeader "pragma","no-cache"
    Response.AddHeader "Expires","0"

    ORDER_ID   = GetReqStr("order_id", "")
    sms_msg    = GetReqStr("sms_msg", "")
    If Len(sms_msg) = 0 Then sms_msg = ""

    is_call    = GetReqStr("is_call", "")
    If Len(is_call) = 0 Then is_call = ""

	
	
	ORDER_ID = "M20000000958148"





	dim cl_eCoupon : set cl_eCoupon = new eCoupon
	dim pg_RollBack : pg_RollBack = 0

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
		BRANCH_NM	= oRs("BRANCH_NM")
		CUST_ID		= oRs("CUST_ID")
		vPaycoin_Cpid		= oRs("paycoin_cpid")

	end if

	html_result = "SUCC|"

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
			ElseIf PAY_TYPE = "Sgpay" Then 
				payMethodCode = "51"
			ElseIf PAY_TYPE = "Later" Then 
				payMethodCode = "23"
			ElseIf PAY_TYPE = "Cash" Then 
				payMethodCode = "21"
			Else
				payMethodCode = "99"
			End If
response.write PAYCO_MEMBERSHIP_COMPANYCODE&"<br>"&"<br>"

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
	Response.write JSON.stringify(tC.toJson())&"<br>"&"<br>"&"<br>"
			reqC.addOuterPayMethodCancelList(tC)

	Response.write JSON.stringify(reqC.toJson())&"<br>"&"<br>"&"<br>"

			Set resC = OrderCancel(reqC.toJson())
	Response.Write resC.mCode & "<br>"&"<br>"
	Response.Write resC.mMessage & "<br>"

			resCode = resC.mCode
			If resCode = 0 Then
				
			Else
				
			End If
			Response.Write resCode & "<br>"
		End If 
	End If 
'Response.End 
%>