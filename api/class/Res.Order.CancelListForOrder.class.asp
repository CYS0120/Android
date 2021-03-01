<%
'주문멤버십사용취소
Class clsResOrderCancelListForOrder
	Public mCode, mMessage, mCancelDate, mCouponCancelList, mPointCancelList

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "code") Then
			mCode = obj.code
		End If
		If JSON.hasKey(obj, "message") Then
			mMessage = obj.message
		End If
		If JSON.hasKey(obj, "result") Then
			If JSON.hasKey(obj.result, "cancelDate") Then
				mCancelDate = obj.result.cancelDate
			End If

			'couponCancelList
			If JSON.hasKey(obj.result, "couponCancelList") Then
				ReDim mCouponCancelList(obj.result.couponCancelList.length-1)
				For i=0 To obj.result.couponCancelList.length-1
					Dim tmpCouponCancelList : Set tmpCouponCancelList = New clsCouponCancelList
					tmpCouponCancelList.Init(obj.result.couponCancelList.get(i))
					Set mCouponCancelList(i) = tmpCouponCancelList
				Next
			End If

			'pointCancelList
			If JSON.hasKey(obj.result, "pointCancelList") Then
				ReDim mPointCancelList(obj.result.pointCancelList.length-1)
				For i=0 To obj.result.pointCancelList.length-1
					Dim tmpPointCancelList : Set tmpPointCancelList = New clsPointCancelList
					tmpPointCancelList.Init(obj.result.pointCancelList.get(i))
					Set mPointCancelList(i) = tmpPointCancelList
				Next
			End If
		End If
	End Function

	Private Sub Class_Initialize
		mCode = 0
		mMessage = ""
		mCancelDate = ""
		mCouponCancelList = Array()
		mPointCancelList = Array()
	End Sub

	Private Sub Class_Terminate
	End Sub

End Class
%>