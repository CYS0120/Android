<!--#include virtual="/api/include/utf8.asp"-->
<%
result = "{""code"": 0,""message"": ""SUCCESS"",""result"": {""couponAcmPoint"": 0,""payAcmPoint"": 170,""restPoint"" : 1170} }"

			Set oJson = JSON.Parse(result)

			Dim resC : Set resC = New clsResOrderDecisionSimple
			resC.Init(oJson)
			'확정완료

'Response.Write resC.mCode & "<br>"
'Response.Write resC.mMessage & "<br>"
'Response.Write resC.mCouponAcmPoint & "<br>"
'Response.Write resC.mPayAcmPoint & "<br>"
'Response.Write resC.mRestPoint & "<br>"
order_idx = 2179
'Response.End 
			resCode = resC.mCode
			If resCode = 0 Then 
				mCouponAcmPoint = resC.mCouponAcmPoint
				mPayAcmPoint = resC.mPayAcmPoint
				mRestPoint = resC.mRestPoint
				If FncIsBlank(mCouponAcmPoint) Then mCouponAcmPoint = 0
				If FncIsBlank(mPayAcmPoint) Then mPayAcmPoint = 0
				If FncIsBlank(mRestPoint) Then mRestPoint = 0
				Set cmd = Server.CreateObject("ADODB.Command")
				With cmd
					.ActiveConnection = dbconn
					.NamedParameters = True
					.CommandType = adCmdStoredProc
					.CommandText = "bp_order_decisionsimple_update"

					.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)
					.Parameters.Append .CreateParameter("@result", adInteger, adParamInput, , resCode)
					.Parameters.Append .CreateParameter("@CouponAcmPoint", adInteger, adParamInput, , mCouponAcmPoint)
					.Parameters.Append .CreateParameter("@PayAcmPoint", adInteger, adParamInput, , mPayAcmPoint)
					.Parameters.Append .CreateParameter("@RestPoint", adInteger, adParamInput, , mRestPoint)

					.Execute
				End With
				Set cmd = Nothing
			Else
				mCouponAcmPoint = 0
				mPayAcmPoint = 0
				mRestPoint = 0
				Set cmd = Server.CreateObject("ADODB.Command")
				With cmd
					.ActiveConnection = dbconn
					.NamedParameters = True
					.CommandType = adCmdStoredProc
					.CommandText = "bp_order_decisionsimple_update"

					.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)
					.Parameters.Append .CreateParameter("@result", adInteger, adParamInput, , resCode)
					.Parameters.Append .CreateParameter("@CouponAcmPoint", adInteger, adParamInput, , mCouponAcmPoint)
					.Parameters.Append .CreateParameter("@PayAcmPoint", adInteger, adParamInput, , mPayAcmPoint)
					.Parameters.Append .CreateParameter("@RestPoint", adInteger, adParamInput, , mRestPoint)

					.Execute
				End With
				Set cmd = Nothing
			End If


%>