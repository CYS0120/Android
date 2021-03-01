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
On Error Resume next
    If Not (rs.BOF Or rs.EOF) Then
        Do Until rs.EOF
            order_idx = rs("order_idx")

			Set reqC = New clsReqOrderDecision
			reqC.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
            'reqC.mMerchantCode = PAYCO_MERCHANTCODE
            reqC.mMerchantCode = rs("branch_id")
            reqC.mMemberNo = rs("member_idno")
            reqC.mServiceTradeNo = rs("order_num")

			'payMethodCode	결제수단코드	포인트 적립 대상 결제수단코드
			'(11 충전포인트 / 21 현금 / 22 현금영수증 / 23 신용카드 / 24 휴대폰결제 / 31 페이코 / 32 카카오페이 / 41 가상계좌 / 42 실시간계좌이체 / 99 기타결제)"
			pay_type = rs("pay_type")
			If pay_type = "Card" Then 
				payMethodCode = "23"
			ElseIf pay_type = "Phone" Then 
				payMethodCode = "24"
			ElseIf pay_type = "Payco" Then 
				payMethodCode = "31"
			ElseIf pay_type = "Later" Then 
				payMethodCode = "23"
			ElseIf pay_type = "Cash" Then 
				payMethodCode = "21"
			Else
				payMethodCode = "99"
			End If

			Set cmd = Server.CreateObject("ADODB.Command")
            With cmd
                .ActiveConnection = dbconn
                .NamedParameters = True
                .CommandType = adCmdStoredProc
                .CommandText = "bp_order_detail_select"

                .Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)

                Set drs = .Execute
            End With
            Set cmd = Nothing

            If Not (drs.BOF Or drs.EOF) Then
                Do Until drs.EOF
                    Set tC = New clsProductList
                    tC.mProductCd = drs("poscode")
                    If drs("upper_order_detail_idx") = 0 Then
                        tC.mProductClassCd = "M"
                    Else
                        tC.mProductClassCd = "S"
                    End If
                    tC.mTargetUnitPrice = drs("menu_price")
                    tC.mProductCount = drs("menu_qty")
		            tC.mpayMethodCode = payMethodCode
'Response.write JSON.stringify(tC.toJson())
                    reqC.addProductList(tC)

                    drs.MoveNext
                Loop

'Response.write JSON.stringify(reqC.toJson())
'Response.End 

                Set resC = OrderDecision(reqC.toJson())
                '확정완료

'Response.Write rs("order_idx") & "<br>"
'Response.Write resC.mCode & "<br>"
'Response.Write resC.mMessage & "<br>"

				resCode = resC.mCode
				If resCode = 0 Then 
					For SEQ = 0 To UBOUND(resC.mPointInfo.mPointAcmtDetailList)
						mAcmAmount = resC.mPointInfo.mPointAcmtDetailList(SEQ).mAcmAmount
						mAcmRate = resC.mPointInfo.mPointAcmtDetailList(SEQ).mAcmRate
						order_seq = SEQ + 1

						Set cmd = Server.CreateObject("ADODB.Command")
						With cmd
							.ActiveConnection = dbconn
							.NamedParameters = True
							.CommandType = adCmdStoredProc
							.CommandText = "bp_order_decision_update"

							.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)
							.Parameters.Append .CreateParameter("@order_seq", adInteger, adParamInput, , order_seq)
							.Parameters.Append .CreateParameter("@result", adInteger, adParamInput, , resCode)
							.Parameters.Append .CreateParameter("@AcmAmount", adInteger, adParamInput, , mAcmAmount)
							.Parameters.Append .CreateParameter("@AcmRate", adInteger, adParamInput, , mAcmRate)

							.Execute
						End With
						Set cmd = Nothing
					Next
				Else
					mAcmAmount = 0
					mAcmRate = 0
					order_seq = 1
					Set cmd = Server.CreateObject("ADODB.Command")
					With cmd
						.ActiveConnection = dbconn
						.NamedParameters = True
						.CommandType = adCmdStoredProc
						.CommandText = "bp_order_decision_update"

						.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)
						.Parameters.Append .CreateParameter("@order_seq", adInteger, adParamInput, , order_seq)
						.Parameters.Append .CreateParameter("@result", adInteger, adParamInput, , resCode)
						.Parameters.Append .CreateParameter("@AcmAmount", adInteger, adParamInput, , mAcmAmount)
						.Parameters.Append .CreateParameter("@AcmRate", adInteger, adParamInput, , mAcmRate)

						.Execute
					End With
					Set cmd = Nothing
				End If 


			End If
            Set drs = Nothing
            rs.MoveNext
'Response.End 
        Loop
    End If
%>