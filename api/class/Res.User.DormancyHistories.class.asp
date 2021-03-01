<%
'회원휴면내역조회
Class clsResUserDormancyHistories
	Public mResultCode, mResultMessage, mIsSuccessful, mDormancyHistoryList

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "header") Then
			If JSON.hasKey(obj.header, "resultCode") Then
				mResultCode = obj.header.resultCode
			End If
			If JSON.hasKey(obj.header, "resultMessage") Then
				mResultMessage = obj.header.resultMessage
			End If
			If JSON.hasKey(obj.header, "isSuccessful") Then
				mIsSuccessFul = obj.header.isSuccessful
			End If
		End If
		
		If JSON.hasKey(obj, "data") Then
			'dormancyHistoryList
			If JSON.hasKey(obj.data, "dormancyHistoryList") Then
				ReDim mDormancyHistoryList(obj.data.dormancyHistoryList.length-1)
				For i=0 To obj.data.dormancyHistoryList.length-1
					Dim tmpDormancyHistoryList : Set tmpDormancyHistoryList = New clsDormancyHistoryList
					tmpDormancyHistoryList.Init(obj.data.dormancyHistoryList.get(i))
					Set mDormancyHistoryList(i) = tmpDormancyHistoryList
				Next
			End If
		End If
	End Function

	Private Sub Class_Initialize
		mResultCode = 0
		mResultMessage = ""
		mIsSuccessful = false
		mDormancyHistoryList = Array()
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>