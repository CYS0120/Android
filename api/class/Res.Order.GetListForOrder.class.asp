<%
'주문사용가능멤버십조회
Class clsResOrderGetListForOrder
	Public mCode, mMessage, mQueryDate, mCouponList, mPointList, mTotalPoint

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
					Set mPointList(i) = tmpPointList
					mTotalPoint = mTotalPoint+obj.result.pointList.get(i).restPoint
				Next
			End If

			'couponList
			If JSON.hasKey(obj.result, "couponList") Then
				ReDim mCouponList(obj.result.couponList.length-1)
				For i=0 To obj.result.couponList.length-1
					Dim tmpCouponList : Set tmpCouponList = New clsCouponList
					tmpCouponList.Init(obj.result.couponList.get(i))
					Set mCouponList(i) = tmpCouponList
				Next
			End If
		End If
	End Function

	Private Sub Class_Initialize
		mCode = 0
		mMessage = ""
		mQueryDate = ""
		mPointList = Array()
		mCouponList = Array()
		mTotalPoint = 0
	End Sub

	Private Sub Class_Terminate
	End Sub

End Class
%>