<%
'쿠폰보유내역조회 탭
Class clsResCouponGetDetail
	Public mCode, mMessage, mTotalCount, mQueryDate, mHoldList, mCouponInfo

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
			If JSON.hasKey(obj.result, "couponInfo") Then
				mCouponInfo = obj.result.couponInfo
			End If
			'holdList
			If JSON.hasKey(obj.result, "holdList") Then
				ReDim mHoldList(obj.result.holdList.length-1)
				For i=0 To obj.result.holdList.length-1
					Dim tmpHoldList : Set tmpHoldList = New clsHoldList
					tmpHoldList.Init(obj.result.holdList.get(i))
					Set mHoldList(i) = tmpHoldList
				Next
			End If
		End If
	End Function

	Private Sub Class_Initialize
		mCouponInfo = ""
		mCode = 0
		mMessage = ""
		mTotalCount = 0
		mQueryDate = ""
		mHoldList = Array()
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>