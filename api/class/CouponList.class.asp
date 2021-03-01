<%
'주문사용가능멤버십조회 탭
Class clsCouponList
	Public mIssueTypeCode, mCouponNo, mCouponId, mCouponName, mValidStartYmdt, mValidEndYmdt, mDiscountExpectAmount, mBenefitTypeCode
	Public mConditionProductYn, mConditionProductClassCode, mConditionAmountYn, mConditionAmountTypeCode, mConditionProductCode, mConditionAmount
	public mRateTypeCode, mRateValue, mMaxRateValue, mEachApplyYn, mGiftProductCode, mGiftProductClassCode
	Public mDiscountAmount

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
		If JSON.hasKey(obj, "validStartYmdt") Then
			mValidStartYmdt = obj.validStartYmdt
		End If
		If JSON.hasKey(obj, "validEndYmdt") Then
			mValidEndYmdt = obj.validEndYmdt
		End If
		If JSON.hasKey(obj, "discountExpectAmount") Then
			mDiscountExpectAmount = obj.discountExpectAmount
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
		If JSON.hasKey(obj, "maxRateValue") Then
			mMaxRateValue = obj.maxRateValue
		End If
		If JSON.hasKey(obj, "eachApplyYn") Then
			mEachApplyYn = obj.eachApplyYn
		End If
		If JSON.hasKey(obj, "giftProductCode") Then
			mGiftProductCode = obj.giftProductCode
		End If
		If JSON.hasKey(obj, "giftProductClassCode") Then
			mGiftProductClassCode = obj.giftProductClassCode
		End If

		'주문멤버십사용 탭 Req
		If JSON.hasKey(obj, "discountAmount") Then
			mDiscountAmount = obj.discountAmount
		End If
	End Function

	Private Sub Class_Initialize
		mIssueTypeCode = ""
		mCouponNo = ""
		mCouponId = ""
		mCouponName = ""
		mValidStartYmdt = ""
		mValidEndYmdt = ""
		mDiscountExpectAmount = 0
		mBenefitTypeCode = ""
		mConditionProductYn = ""
		mConditionProductClassCode = ""
		mConditionProductCode = ""
		mConditionAmountYn = ""
		mConditionAmountTypeCode = ""
		mConditionAmount = 0
		mRateTypeCode = ""
		mRateValue = 0
		mMaxRateValue = 0
		mEachApplyYn = ""
		mGiftProductCode = ""
		mGiftProductClassCode = ""

		'주문멤버십사용 탭 Req
		mDiscountAmount = 0
	End Sub

	Private Sub Class_Terminate
	End Sub

	Function toJson
		cResult = ""

		If mCouponNo <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """couponNo"":""" & mCouponNo & """"
		End If
		If mCouponId <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """couponId"":""" & mCouponId & """"
		End If

		If cResult <> "" Then cResult = cResult & ","
		cResult = cResult & """discountAmount"":" & mDiscountAmount

		If mGiftProductCode <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """giftProductCode"":""" & mGiftProductCode & """"
		End If
		If mGiftProductClassCode <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """giftProductClassCode"":""" & mGiftProductClassCode & """"
		End If

		cResult = "{" & cResult & "}"
		toJson = cResult
	End Function
End Class
%>