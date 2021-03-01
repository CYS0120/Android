<%
'주문확정
Class clsResOrderDecisionSimple
	Public mCode, mMessage, mPointInfo, mCouponAcmPoint, mPayAcmPoint, mRestPoint

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "code") Then
			mCode = obj.code
		End If
		If JSON.hasKey(obj, "message") Then
			mMessage = obj.message
		End If
		If JSON.hasKey(obj, "result") Then
			If JSON.hasKey(obj.result, "couponAcmPoint") Then
				mCouponAcmPoint = obj.result.couponAcmPoint
			End If
			If JSON.hasKey(obj.result, "payAcmPoint") Then
				mPayAcmPoint = obj.result.payAcmPoint
			End If
			If JSON.hasKey(obj.result, "restPoint") Then
				mRestPoint = obj.result.restPoint
			End If
		End If
	End Function

	Private Sub Class_Initialize
		mCode = 0
		mMessage = ""
		mCouponAcmPoint = ""
		mPayAcmPoint = ""
		mRestPoint = ""
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>