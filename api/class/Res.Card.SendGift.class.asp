<%
'카드선물보내기
Class clsResCardSendGift
	Public mCode, mMessage, mCardGiftTradeNo, mCardNo

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "code") Then
			mCode = obj.code
		End If
		If JSON.hasKey(obj, "message") Then
			mMessage = obj.message
		End If
		If JSON.hasKey(obj, "result") Then
			If JSON.hasKey(obj.result, "cardGiftTradeNo") Then
				mCardGiftTradeNo = obj.result.cardGiftTradeNo
			End If
			If JSON.hasKey(obj.result, "cardNo") Then
				mCardNo = obj.result.cardNo
			End If
		End If
	End Function

	Private Sub Class_Initialize
		mCode = 0
		mMessage = ""
		mCardGiftTradeNo = ""
		mCardNo = 0
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>