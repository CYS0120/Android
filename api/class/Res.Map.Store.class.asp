<%
'회원등급혜택조회
Class clsResMapStore
	Public mCode, mStatus, mReferedUrl, mMessage, mErrorMessage, mDataList

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "code") Then
			mCode = obj.code
		End If
		If JSON.hasKey(obj, "status") Then
			mStatus = obj.code
		End If
		If JSON.hasKey(obj, "referedUrl") Then
			mReferedUrl = obj.code
		End If
		If JSON.hasKey(obj, "message") Then
			mMessage = obj.message
		End If
		If JSON.hasKey(obj, "errorMessage") Then
			mErrorMessage = obj.errorMessage
		End If

		'DataList
		If JSON.hasKey(obj, "data") Then
			If obj.data <> "" Then
				ReDim mDataList(obj.data.length-1)
				For i=0 To obj.data.length-1
					Dim tmpDataList : Set tmpDataList = New clsMapStoreDataList
					tmpDataList.Init(obj.data.get(i))
					Set mDataList(i) = tmpDataList
				Next
			End If
		End If
	End Function

	Private Sub Class_Initialize
		mCode = 0
		mStatus = ""
		mReferedUrl = ""
		mMessage = ""
		mErrorMessage = ""
		mDataList = Array()
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>