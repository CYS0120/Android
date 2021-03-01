<%
'충전내역조회
Class clsResCardChargeInfo
	Public mCode, mMessage, mCardStatus, mChargeYmdt, mOuterChargeTradeNo, mCancelYn, mCancelAbleYn, mCancelRefuseCause, mPayMethods

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "code") Then
			mCode = obj.code
		End If
		If JSON.hasKey(obj, "message") Then
			mMessage = obj.message
		End If
		If JSON.hasKey(obj, "result") Then
			If JSON.hasKey(obj.result, "cardStatus") Then
				mCardStatus = obj.result.cardStatus
			End If
			If JSON.hasKey(obj.result, "chargeYmdt") Then
				mChargeYmdt = obj.result.chargeYmdt
			End If
			If JSON.hasKey(obj.result, "outerChargeTradeNo") Then
				mOuterChargeTradeNo = obj.result.outerChargeTradeNo
			End If
			If JSON.hasKey(obj.result, "cancelYn") Then
				mCancelYn = obj.result.cancelYn
			End If
			If JSON.hasKey(obj.result, "cancelAbleYn") Then
				mCancelAbleYn = obj.result.cancelAbleYn
			End If
			If JSON.hasKey(obj.result, "cancelRefuseCause") Then
				mCancelRefuseCause = obj.result.cancelRefuseCause
			End If
		End If

		'payMethods
		If JSON.hasKey(obj.result, "payMethods") Then
			ReDim mPayMethods(obj.result.payMethods.length-1)
			For i=0 To obj.result.payMethods.length-1
				Dim tmpPayMethods : Set tmpPayMethods = New clsPayMethods
				tmpPayMethods.Init(obj.result.payMethods.get(i))
				Set mPayMethods(i) = tmpPayMethods
			Next
		End If
	End Function

	Private Sub Class_Initialize
		mCode = 0
		mMessage = ""
		mCardStatus = ""
		mChargeYmdt = ""
		mOuterChargeTradeNo = ""
		mCancelYn = ""
		mCancelAbleYn = ""
		mCancelRefuseCause = ""
		mPayMethods = Array()
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>