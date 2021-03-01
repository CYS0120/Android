<!--#include virtual="/api/include/utf8.asp"-->
<%
result = "{""code"":0,""message"":""SUCCESS"",""result"":{""pointInfo"":{""pointTradNo"":""2019032591988637"",""acmMinPayAmount"":100,""pointAcmDetailList"":[{""productCode"":""601000010"",""payMethodCode"":""24"",""acmDetailNo"":""2019032500015049"",""acmAmount"":18000,""acmRate"":5.0},{""productCode"":""601000040"",""payMethodCode"":""24"",""acmDetailNo"":""2019032500015048"",""acmAmount"":19000,""acmRate"":5.0}]},""couponAcmList"":[]}}"

				Set oJson = JSON.Parse(result)

				Dim resC : Set resC = New clsResOrderDecision
				resC.Init(oJson)
                '확정완료

				resCode = resC.mCode
				If resCode = 0 Then 
'Response.Write resC.mPointInfo.mPointTradeNo & "<br>"
'Response.Write resC.mPointInfo.mAcmMinPayAmount & "<br>"
'Response.Write resC.mPointInfo.mPointAcmtDetailList(0).mProductCode & "<br>"
'Response.Write resC.mPointInfo.mPointAcmtDetailList(0).mPayMethodCode & "<br>"
'Response.Write resC.mPointInfo.mPointAcmtDetailList(0).mAcmDetailNo & "<br>"
'Response.Write resC.mPointInfo.mPointAcmtDetailList(0).mAcmAmount & "<br>"
'Response.Write resC.mPointInfo.mPointAcmtDetailList(0).mAcmRate & "<br>"
'					mAcmAmount = resC.mPointInfo.mPointAcmtDetailList(0).mAcmAmount
'					mAcmRate = resC.mPointInfo.mPointAcmtDetailList(0).mAcmRate
'				Else
'					mAcmAmount = 0
'					mAcmRate = 0
				End If 
order_idx = 2109
				For SEQ = 0 To UBOUND(resC.mPointInfo.mPointAcmtDetailList)
					mAcmAmount = resC.mPointInfo.mPointAcmtDetailList(SEQ).mAcmAmount
					mAcmRate = resC.mPointInfo.mPointAcmtDetailList(SEQ).mAcmRate
					order_seq = SEQ + 1
Response.Write mAcmAmount & "<br>"
Response.Write mAcmRate & "<br>"
Response.Write order_seq & "<br>"

					Set cmd = Server.CreateObject("ADODB.Command")
					With cmd
						.ActiveConnection = dbconn
						.NamedParameters = True
						.CommandType = adCmdStoredProc
	'                    .CommandText = "bp_order_membership_update"
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

%>