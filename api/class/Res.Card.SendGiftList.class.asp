<%
'보낸카드선물목록조회
Class clsResCardSendGiftList
	Public mCode, mMessage, mCardGiftTradeNo, mReceiverName, mReceiverPhoneNo, mAmount, mTitle, mContent, mSendYmdt, mGiftCardNo, mSendStatusCd, mCancelAbleYn, mCancelRejectReason

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
			If JSON.hasKey(obj.result, "receiverName") Then
				mReceiverName = obj.result.receiverName
			End If
			If JSON.hasKey(obj.result, "receiverPhoneNo") Then
				mReceiverPhoneNo = obj.result.receiverPhoneNo
			End If
			If JSON.hasKey(obj.result, "amount") Then
				mAmount = obj.result.amount
			End If
			If JSON.hasKey(obj.result, "title") Then
				mTitle = obj.result.title
			End If
			If JSON.hasKey(obj.result, "content") Then
				mContent = obj.result.content
			End If
			If JSON.hasKey(obj.result, "sendYmdt") Then
				mSendYmdt = obj.result.sendYmdt
			End If
			If JSON.hasKey(obj.result, "giftCardNo") Then
				mGiftCardNo = obj.result.giftCardNo
			End If
			If JSON.hasKey(obj.result, "sendStatusCd") Then
				mSendStatusCd = obj.result.sendStatusCd
			End If
			If JSON.hasKey(obj.result, "cancelAbleYn") Then
				mCancelAbleYn = obj.result.cancelAbleYn
			End If
			If JSON.hasKey(obj. result, "cancelRejectReason") Then
				mCancelRejectReason = obj.result.cancelRejectReason
			End If
		End If
	End Function

	Private Sub Class_Initialize
		mCode = 0
		mMessage = ""
		mCardGiftTradeNo = ""
		mReceiverName = ""
		mReceiverPhoneNo = ""
		mAmount = 0
		mTitle = ""
		mContent = ""
		mSendYmdt = ""
		mGiftCardNo = ""
		mSendStatusCd = ""
		mCancelAbleYn = ""
		mCancelRejectReason = ""
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>