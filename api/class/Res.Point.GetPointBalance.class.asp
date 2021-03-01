<%
'포인트잔액조회
Class clsResPointGetPointBalance
	Public mCode, mMessage, mQueryDate, mPointList, mTotalPoint, mTotalExtinctionExpectedPoint
	Public mPayPoint, mSavePoint

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "code") Then
			mCode = obj.code
		End If
		If JSON.hasKey(obj, "message") Then
			mMessage = obj.message
		End If
		If JSON.hasKey(obj, "result") Then
			If JSON.hasKey(obj.result, "queryDate") Then
				mQueryDate = obj.result.queryDate
			End If

			'pointList
			If JSON.hasKey(obj.result, "pointList") Then
				ReDim mPointList(obj.result.pointList.length-1)
				For i=0 To obj.result.pointList.length-1
					Dim tmpPointList : Set tmpPointList = New clsPointList
					tmpPointList.Init(obj.result.pointList.get(i))
					mTotalPoint = mTotalPoint + tmpPointList.mRestPoint
					mTotalExtinctionExpectedPoint = mTotalExtinctionExpectedPoint + tmpPointList.mExtinctionExpectPoint 
					If tmpPointList.mAccountTypeCode = "SAVE" Then
						mSavePoint = mSavePoint + tmpPointList.mRestPoint
					Else
						mPayPoint = mPayPoint + tmpPointList.mRestPoint
					End If
					Set mPointList(i) = tmpPointList
				Next
			End If
		End If
	End Function

	Private Sub Class_Initialize
		mCode = 0
		mMessage = ""
		mQueryDate = ""
		mPointList = Array()
		mTotalPoint = 0
		mTotalExtinctionExpectedPoint = 0
		mPayPoint = 0
		mSavePoint = 0
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>