<%
'회원탈퇴내역조회
Class clsResUserWithdrawalHistories
	Public mResultCode, mResultMessage, mIsSuccessful, mWithdrawalHistoryList

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "header") Then
			If JSON.hasKey(obj.header, "resultCode") Then
				mResultCode = obj.header.resultCode
			End If
			If JSON.hasKey(obj.header, "resultMessage") Then
				mResultMessage = obj.header.resultMessage
			End If
			If JSON.hasKey(obj.header, "isSuccessful") Then
				mIsSuccessful = obj.header.isSuccessful
			End If
		End If

		If JSON.hasKey(obj, "data") Then
			'withdrawalHistoryList
			If JSON.hasKey(obj.data, "withdrawalHistoryList") Then
				ReDim mWithdrawalHistoryList(obj.data.withdrawalHistoryList.length-1)
				For i=0 To obj.data.withdrawalHistoryList.length-1
					Dim tmpWithdrawalHistoryList : Set tmpWithdrawalHistoryList = New clsWithdrawalHistoryList
					tmpWithdrawalHistoryList.Init(obj.data.withdrawalHistoryList.get(i))
					Set mWithdrawalHistoryList(i) = tmpWithdrawalHistoryList
				Next
			End If
		End If
	End Function

	Private Sub Class_Initialize
		mResultCode = 0
		mResultMessage = ""
		mIsSuccessful = false
		mWithdrawalHistoryList = Array()
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>