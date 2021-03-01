<!--#include virtual="/api/include/utf8.asp"-->
<%
    Response.AddHeader "pragma","no-cache"
    Response.AddHeader "Expires","0"

response.end 

ORDERID   = "M20000000017548,M20000000017495,M20000000017465,M20000000017463,W20000000017445,M20000000017425,W20000000017414,W20000000017347,M20000000017303,W20000000017283,M20000000017274,W20000000017267,M20000000017251,M20000000017156,M20000000017123,M20000000017118,M20000000017001,W20000000016958,W20000000016950,M20000000016811,M20000000016772,M20000000016697,M20000000016535,M20000000016557,M20000000015567,W20000000015543,W20000000015289,W20000000015105,W20000000014214,W20000000013219,W20000000013162,M20000000013082,M20000000013043,W20000000013040,W20000000013038,W20000000013037,W20000000013036,W20000000013035,M20000000013031,M20000000013029,W20000000013028,M20000000012985,M20000000012798,M20000000012655,M20000000012426,W20000000012309,W20000000012305,M20000000012300,W20000000012279,M20000000012215,W20000000012208,M20000000012200,W20000000012179,W20000000012132,M20000000012127,W20000000012126,M20000000012123,M20000000012041,M20000000011992,M20000000011650,M20000000010739,M20000000010734,W20000000010656,M20000000010585,M20000000010555"

ArrORDERID = Split(ORDERID,",")
For Cnt = 0 To Ubound(ArrORDERID)
	ORDER_ID = Trim(ArrORDERID(Cnt))

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
		ORDER_IDX	= oRs("ORDER_IDX")
		ORDER_ID	= oRs("ORDER_ID")
		PAY_TYPE	= oRs("PAY_TYPE")
		PAY_AMT		= oRs("PAY_AMT")
		TID			= oRs("TID")
		BRANCH_ID	= oRs("BRANCH_ID")
		CUST_ID		= oRs("CUST_ID")

		If PAY_TYPE = "Card" Then 
			payMethodCode = "23"
		ElseIf PAY_TYPE = "Phone" Then 
			payMethodCode = "24"
		ElseIf PAY_TYPE = "Payco" Then 
			payMethodCode = "31"
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

Response.Write ORDER_ID & ":"
		resCode = resC.mCode
		If resCode = 0 Then
			
		Else
			
		End If
Response.Write resCode & "<br>"
	End If
Next 
%>