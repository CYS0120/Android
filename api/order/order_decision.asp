<!--#include virtual="/api/include/utf8.asp"-->
<%
    Set cmd = Server.CreateObject("ADODB.Command")
    With cmd
        .ActiveConnection = dbconn
        .NamedParameters = True
        .CommandType = adCmdStoredProc
        .CommandText = "bp_order_complete_sel"

        Set rs = .Execute
    End With
    Set cmd = Nothing
    If Not (rs.BOF Or rs.EOF) Then
        Do Until rs.EOF
            order_idx = rs("order_idx")
            order_channel = rs("order_channel")

			If order_channel = "2" Or order_channel = "3"  Then
				order_channel = "WEB"
			Else
				order_channel = "APP"
			End If

			Set reqC = New clsReqOrderDecisionSimple
			reqC.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
            'reqC.mMerchantCode = PAYCO_MERCHANTCODE
            reqC.mMerchantCode = rs("branch_id")
            reqC.mMemberNo = rs("member_idno")
            reqC.mServiceTradeNo = rs("order_num")
			reqC.mOrderChannel = order_channel

'Response.write JSON.stringify(reqC.toJson())
'Response.End 
            Set resC = OrderDecisionSimple(reqC.toJson())
            '확정완료

Response.Write rs("order_idx") & "<br>"
Response.Write resC.mCode & "<br>"
Response.Write resC.mMessage & "<br>"

			resCode = resC.mCode
			resMessage = resC.mMessage
			If resCode = 0 Then 
				mCouponAcmPoint = resC.mCouponAcmPoint
				mPayAcmPoint = resC.mPayAcmPoint
				mRestPoint = resC.mRestPoint
				If FncIsBlank(mCouponAcmPoint) Then mCouponAcmPoint = 0
				If FncIsBlank(mPayAcmPoint) Then mPayAcmPoint = 0
				If FncIsBlank(mRestPoint) Then mRestPoint = 0
			Else
				mCouponAcmPoint = 0
				mPayAcmPoint = 0
				mRestPoint = 0
			End If

			Set cmd = Server.CreateObject("ADODB.Command")
			With cmd
				.ActiveConnection = dbconn
				.NamedParameters = True
				.CommandType = adCmdStoredProc
				.CommandText = "bp_order_decisionsimple_update"

				.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)
				.Parameters.Append .CreateParameter("@result", adInteger, adParamInput, , resCode)
				.Parameters.Append .CreateParameter("@message", adVarChar, adParamInput, 2000, resMessage)
				.Parameters.Append .CreateParameter("@CouponAcmPoint", adInteger, adParamInput, , mCouponAcmPoint)
				.Parameters.Append .CreateParameter("@PayAcmPoint", adInteger, adParamInput, , mPayAcmPoint)
				.Parameters.Append .CreateParameter("@RestPoint", adInteger, adParamInput, , mRestPoint)

				.Execute
			End With
			Set cmd = Nothing

            rs.MoveNext
'Response.End 
        Loop
    End If
Response.Write "END"
%>