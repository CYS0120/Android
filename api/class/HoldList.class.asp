<%
'쿠폰보유내역조회 탭
'보유스탬프조회 탭
Class clsHoldList
	Public mIssueTypeCode, mCouponNo, mCouponId, mCouponName, mValidStartDate, mValidEndDate, mStatusCode, mExpiredYn, mBenefitTypeCode, mConditionProductYn, mConditionProductClassCode, mConditionProductCode, mConditionAmountYn, mConditionAmountTypeCode, mConditionAmount, mRateTypeCode, mRateValue, mMaxRateAmount, mGiftApplicationType, mGiftProductCode, mGiftProductClassCode
	Public mStampId, mStampName, mStampCount, mAccumulatedStampCount, mCouponIssueCount, mStampCompletedCount, mStampFinishCount, mPromotionStartDate, mPromotionEndDate, mCouponConditions
	Public mCouponUseTypeCode, mPasswordUseYn, mConditionProducts, mGiftProducts

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "issueTypeCode") Then
			mIssueTypeCode = obj.issueTypeCode
		End If
		If JSON.hasKey(obj, "couponNo") Then
			mCouponNo = obj.couponNo
		End If
		If JSON.hasKey(obj, "couponId") Then
			mCouponId = obj.couponId
		End If
		If JSON.hasKey(obj, "couponName") Then
			mCouponName = obj.couponName
		End If
		If JSON.hasKey(obj, "validStartDate") Then
			mValidStartDate = obj.validStartDate
		End If
		If JSON.hasKey(obj, "validEndDate") Then
			mValidEndDate = obj.validEndDate
		End If
		If JSON.hasKey(obj, "statusCode") Then
			mStatusCode = obj.statusCode
		End If
		If JSON.hasKey(obj, "expiredYn") Then
			mExpiredYn = obj.expiredYn
		End If
		If JSON.hasKey(obj, "benefitTypeCode") Then
			mBenefitTypeCode = obj.benefitTypeCode
		End If
		If JSON.hasKey(obj, "conditionProductYn") Then
			mConditionProductYn = obj.conditionProductYn
		End If
		If JSON.hasKey(obj, "conditionProductClassCode") Then
			mConditionProductClassCode = obj.conditionProductClassCode
		End If
		If JSON.hasKey(obj, "conditionProductCode") Then
			mConditionProductCode = obj.conditionProductCode
		End If
		If JSON.hasKey(obj, "conditionAmountYn") Then
			mConditionAmountYn = obj.conditionAmountYn
		End If
		If JSON.hasKey(obj, "conditionAmountTypeCode") Then
			mConditionAmountTypeCode = obj.conditionAmountTypeCode
		End If
		If JSON.hasKey(obj, "conditionAmount") Then
			mConditionAmount = obj.conditionAmount
		End If
		If JSON.hasKey(obj, "rateTypeCode") Then
			mRateTypeCode = obj.rateTypeCode
		End If
		If JSON.hasKey(obj, "rateValue") Then
			mRateValue = obj.rateValue
		End If
		If JSON.hasKey(obj, "maxRateAmount") Then
			mMaxRateAmount = obj.maxRateAmount
		End If
		If JSON.hasKey(obj, "giftApplicationType") Then
			mGiftApplicationType = obj.giftApplicationType
		End If
		If JSON.hasKey(obj, "giftProductCode") Then
			mGiftProductCode = obj.giftProductCode
		End If
		If JSON.hasKey(obj, "giftProductClassCode") Then
			mGiftProductClassCode = obj.giftProductClassCode
		End If

		If JSON.hasKey(obj, "stampId") Then
			mStampId = obj.stampId
		End If
		If JSON.hasKey(obj, "stampName") Then
			mStampName = obj.stampName
		End If
		If JSON.hasKey(obj, "stampCount") Then
			mStampCount = obj.stampCount
		End If
		If JSON.hasKey(obj, "accumulatedStampCount") Then
			mAccumulatedStampCount = obj.accumulatedStampCount
		End If
		If JSON.hasKey(obj, "couponIssueCount") Then
			mCouponIssueCount = obj.couponIssueCount
		End If
		If JSON.hasKey(obj, "stampCompletedCount") Then
			mStampCompletedCount = obj.stampCompletedCount
		End If
		If JSON.hasKey(obj, "stampFinishCount") Then
			mStampFinishCount = obj.stampFinishCount
		End If
		If JSON.hasKey(obj, "promotionStartDate") Then
			mPromotionStartDate = obj.promotionStartDate
		End If
		If JSON.hasKey(obj, "promotionEndDate") Then
			mPromotionEndDate = obj.promotionEndDate
		End If

		'couponConditions
		If JSON.hasKey(obj, "couponConditions") Then
			ReDim mCouponConditions(obj.couponConditions.lengh - 1)
			For i = 0 To obj.couponConditions.length - 1
				Dim tmpCouponConditions : Set tmpCouponConditions = New clsCouponConditions
				tmpCouponConditions.Init(obj.couponConditions.get(i))
				Set mCouponConditions(i) = tmpCouponConditions
			Next
		End If

		If JSON.hasKey(obj, "couponUseTypeCode") Then
			mCouponUseTypeCode = obj.couponUseTypeCode
		End If
		If JSON.hasKey(obj, "passwordUseYn") Then
			mPasswordUseYn = obj.passwordUseYn
		End If
		If JSON.hasKey(obj, "conditionProducts") Then
			mConditionProducts = obj.conditionProducts
		End If
		If JSON.hasKey(obj, "giftProducts") Then
			mGiftProducts = obj.giftProducts
		End If
	End Function

	Private Sub Class_Initialize
		mIssueTypeCode = ""
		mCouponNo = ""
		mCouponId = ""
		mCouponName = ""
		mValidStartDate = ""
		mValidEndDate = ""
		mStatusCode = ""
		mExpiredYn = ""
		mBenefitTypeCode = ""
		mConditionProductYn = ""
		mConditionProductClassCode = ""
		mConditionProductCode = ""
		mConditionAmountYn = ""
		mConditionAmountTypeCode = ""
		mConditionAmount = 0
		mRateTypeCode = ""
		mRateValue = 0
		mMaxRateAmount = 0
		mGiftApplicationType = ""
		mGiftProductCode = ""
		mGiftProductClassCode = ""

		mStampId = ""
		mStampName = ""
		mStampCount = 0
		mAccumulatedStampCount = 0
		mCouponIssueCount = 0
		mStampCompletedCount = 0
		mStampFinishCount = 0
		mPromotionStartDate = ""
		mPromotionEndDate = ""
		mCouponConditions = Array()

		mCouponUseTypeCode = ""
		mPasswordUseYn = ""
		mConditionProducts = ""
		mGiftProducts = ""
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>