<%
'카드충전내역목록조회 탭
Class clsChargeInfoList
	Public mMembershipChargeTradeNo, mChargeAmt, mChargeYmdt, mOuterChargeTradeNo, mCancelYn, mPayMethods

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "membershipChargeTradeNo") Then
			mMembershipChargeTradeNo = obj.membershipChargeTradeNo
		End If
		If JSON.hasKey(obj, "chargeAmt") Then
			mChargeAmt = obj.chargeAmt
		End If
		If JSON.hasKey(obj, "chargeYmdt") Then
			mChargeYmdt = obj.chargeYmdt
		End If
		If JSON.hasKey(obj, "outerChargeTradeNo") Then
			mOuterChargeTradeNo = obj.outerChargeTradeNo
		End If
		If JSON.hasKey(obj, "cancelYn") Then
			mCancelYn = obj.cancelYn
		End If

		'payMethods
		If JSON.hasKey(obj, "payMethods") Then
			ReDim mPayMethods(obj.payMethods.length - 1)
			For i = 0 To obj.payMethods.length - 1
				Dim tmpPayMethods : Set tmpPayMethods = New clsPayMethods
				tmpPayMethods.Init(obj.payMethods.get(i))
				Set mPayMethods(i) = tmpPayMethods
			Next
		End If
	End Function

	Private Sub Class_Initialize
		mMembershipChargeTradeNo = ""
		mChargeAmt = 0
		mChargeYmdt = ""
		mOuterChargeTradeNo = ""
		mCancelYn = ""
		mPayMethods = Array()
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>