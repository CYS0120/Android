<%
'카드충전취소
Class clsResCardChargeCancel
	Public mCode, mMessage, mCancelChargePoint, mCardPayPoint

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "code") Then
			mCode = obj.code
		End If
		If JSON.hasKey(obj, "message") Then
			mMessage = obj.message
		End If
		If JSON.hasKey(obj, "result") Then
			If JSON.hasKey(obj.result, "cancelChargePoint") Then
				mCancelChargePoint = obj.result.cancelChargePoint
			End If
			If JSON.hasKey(obj.result, "cardPayPoint") Then
				mCardPayPoint = obj.result.cardPayPoint
			End If
		End If
	End Function

	Private Sub Class_Initialize
		mCode = 0
		mMessage = ""
		mCancelChargePoint = 0
		mCardPayPoint = 0
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>