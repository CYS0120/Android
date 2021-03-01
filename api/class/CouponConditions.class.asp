<%
'보유스탬프조회 탭
Class clsCouponConditions
	Public mStampId, mCouponId, mCouponName, mCompleteType, mGoalCount

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "stampId") Then
			mStampId = obj.stampId
		End If
		If JSON.hasKey(obj, "couponId") Then
			mCouponId = obj.couponId
		End If
		If JSON.hasKey(obj, "couponName") Then
			mCouponName = obj.couponName
		End If
		If JSON.hasKey(obj, "completeType") Then
			mCompleteType = obj.completeType
		End If
		If JSON.hasKey(obj, "goalCount") Then
			mGoalCount = obj.goalCount
		End If
	End Function

	Private Sub Class_Initialize
		mStampId = ""
		mCouponId = ""
		mCouponName = ""
		mCompleteType = ""
		mGoalCount = 0
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>