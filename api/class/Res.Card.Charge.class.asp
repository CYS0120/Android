<%
'카드충전
Class clsResCardCharge
	Public mCode, mMessage, mMembershipChargeTradeNo, mChargePoint, mCardPayPoint

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "code") Then
			mCode = obj.code
		End If
		If JSON.hasKey(obj, "message") Then
			mMessage = obj.message
		End If
		If JSON.hasKey(obj, "result") Then
			If JSON.hasKey(obj.result, "membershipChargeTradeNo") Then
				mMembershipChargeTradeNo = obj.result.membershipChargeTradeNo
			End If
			If JSON.hasKey(obj.result, "chargePoint") Then
				mChargePoint = obj.result.chargePoint
			End If
			If JSON.hasKey(obj.result, "cardPayPoint") Then
				mCardPayPoint = obj.result.cardPayPoint
			End If
		ENd If
	End Function

	Private Sub Class_Initialize
		mCode = 0
		mMessage = ""
		mMembershipChargeTradeNo = ""
		mChargePoint = 0
		mCardPayPoint = 0
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>