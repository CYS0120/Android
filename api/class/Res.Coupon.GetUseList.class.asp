<%
'쿠폰사용내역조회
Class clsResCouponGetUseList
	Public mCode, mMessage, mTotalCount, mQueryDate, mUseList

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "code") Then
			mCode = obj.code
		End If
		If JSON.hasKey(obj, "message") Then
			mMessage = obj.message
		End If
		If JSON.hasKey(obj, "result") Then
			If JSON.hasKey(obj.result, "totalCount") Then
				mTotalCount = obj.result.totalCount
			End If
			If JSON.hasKey(obj.result, "queryDate") Then
				mQueryDate = obj.result.queryDate
			End If

			'useList
			If JSON.hasKey(obj.result, "useList") Then
				ReDim mUseList(obj.result.useList.length-1)
				For i=0 To obj.result.useList.length-1
					Dim tmpUseList : Set tmpUseList = New clsUseList
					tmpUseList.Init(obj.result.useList.get(i))
					Set mUseList(i) = tmpUseList
				Next
			End If
		End If
	End Function

	Private Sub Class_Initialize
		mCode = 0
		mMessage = ""
		mTotalCount = 0
		mQueryDate = ""
		mUseList = Array()
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>