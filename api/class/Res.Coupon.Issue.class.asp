<%
'쿠폰발급
Class clsResCouponIssue
	Public mCode, mMessage, mIssueTypeCode, mCouponNo, mCouponId, mCouponName, mValidStartDate, mValidEndDate, mStatusCode, mExpiredYn, mBenefitTypeCode

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "code") Then
			mCode = obj.code
		End If
		If JSON.hasKey(obj, "message") Then
			mMessage = obj.message
		End If
		If JSON.hasKey(obj, "result") Then
			If JSON.hasKey(obj.result, "issueTypeCode") Then
				mIssueTypeCode = obj.result.issueTypeCode
			End If
			If JSON.hasKey(obj.result, "couponNo") Then
				mCouponNo = obj.result.couponNo
			End If
			If JSON.hasKey(obj.result, "couponId") Then
				mCouponId = obj.result.couponId
			End If
			If JSON.hasKey(obj.result, "couponName") Then
				mCouponName = obj.result.couponName
			End If
			If JSON.hasKey(obj.result, "validStartDate") Then
				mValidStartDate = obj.result.validStartDate
			End If
			If JSON.hasKey(obj.result, "validEndDate") Then
				mValidEndDate = obj.result.validEndDate
			End If
			If JSON.hasKey(obj.result, "statusCode") Then
				mStatusCode = obj.result.statusCode
			End If
			If JSON.hasKey(obj.result, "expiredYn") Then
				mExpiredYn = obj.result.expiredYn
			End If
			If JSON.hasKey(obj.result, "benefitTypeCode") Then
				mBenefitTypeCode = obj.result.benefitTypeCode
			End If
		End If
	End Function

	Private Sub Class_Initialize
		mCode = ""
		mMessage = ""
		mIssueTypeCode = ""
		mCouponNo = ""
		mCouponId = ""
		mCouponName = ""
		mValidStartDate = ""
		mValidEndDate = ""
		mStatusCode = ""
		mExpiredYn = ""
		mBenefitTypeCode = ""
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>