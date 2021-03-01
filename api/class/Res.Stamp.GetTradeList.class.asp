<%
'스탬프 적립소진내역조회
Class clsResStampGetTradeList
	Public mResCode, mResMessage, mTotalCount, mQueryDate, mTradeList

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "resCode") Then
			mResCode = obj.resCode
		End If
		If JSON.hasKey(obj, "resMessage") Then
			mResMessage = obj.resMessage
		End If
		If JSON.hasKey(obj, "result") Then
			If JSON.hasKey(obj.result, "totalCount") Then
				mTotalCount = obj.result.totalCount
			End If
			If JSON.hasKey(obj.result, "queryDate") Then
				mQueryDate = obj.result.queryDate
			End If

			'tradeList
			If JSON.hasKey(obj.result, "tradeList") Then
				ReDim mTradeList(obj.result.tradeList.length-1)
				For i=0 To obj.result.tradeList.length-1
					Dim tmpTradeList : Set tmpTradeList = New clsTradeList
					tmpTradeList.Init(obj.result.tradeList.get(i))
					Set mTradeList(i) = tmpTradeList
				Next
			End If
		End If
	End Function

	Private Sub Class_Initialize
		mResCode = ""
		mResMessage = ""
		mTotalCount = 0
		mQueryDate = ""
		mTradeList = Array()
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>