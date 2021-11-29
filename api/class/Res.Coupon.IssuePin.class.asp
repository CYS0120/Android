<%
'쿠폰발급
Class clsResCouponIssueByPinV2
	Public mCode, mMessage, mIssueTypeCode, mCouponNo, mCouponId, mCouponName, mValidStartDate, mValidEndDate, mStatusCode, mExpiredYn, mBenefitTypeCode, mConditionProductYn, mConditionProductList, mConditionAmountYn, mConditionAmountTypeCode, mConditionAmount, mRateTypeCode, mRateValue, mMaxRateAmount, mGiftApplicationType, mGiftProductList, mClientMessage

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
			If JSON.hasKey(obj.result, "conditionProductYn") Then
				mConditionProductYn = obj.result.conditionProductYn
			End If

			'conditionProductList
			If JSON.hasKey(obj.result, "conditionProductList") Then
				ReDim mConditionProductList(obj.result.conditionProductList.length-1)
				For i=0 To obj.result.conditionProductList.length-1
					Dim tmpConditionProductList : Set tmpConditionProductList = New clsConditionProductList
					tmpConditionProductList.Init(obj.result.conditionProductList.get(i))
					Set mConditionProductList(i) = tmpConditionProductList
				Next
			End If

			If JSON.hasKey(obj.result, "conditionAmountYn") Then
				mConditionAmountYn = obj.result.conditionAmountYn
			End If
			If JSON.hasKey(obj.result, "conditionAmountTypeCode") Then
				mConditionAmountTypeCode = obj.result.conditionAmountTypeCode
			End If
			If JSON.hasKey(obj.result, "conditionAmount") Then
				mConditionAmount = obj.result.conditionAmount
			End If
			If JSON.hasKey(obj.result, "rateTypeCode") Then
				mRateTypeCode = obj.result.rateTypeCode
			End If
			If JSON.hasKey(obj.result, "rateValue") Then
				mRateValue = obj.result.rateValue
			End If
			If JSON.hasKey(obj.result, "maxRateAmount") Then
				mMaxRateAmount = obj.result.maxRateAmount
			End If
			If JSON.hasKey(obj.result, "giftApplicationType") Then
				mGiftApplicationType = obj.result.giftApplicationType
			End If

			'giftProductList
			If JSON.hasKey(obj.result, "giftProductList") Then
				ReDim mGiftProductList(obj.result.giftProductList.length-1)
				For i=0 To obj.result.giftProductList.length-1
					Dim tmpGiftProductList : Set tmpGiftProductList = New clsGiftProductList
					tmpGiftProductList.Init(obj.result.giftProductList.get(i))
					Set mGiftProductList(i) = tmpGiftProductList
				Next
			End If

		End If
		If JSON.hasKey(obj, "info") Then
			If JSON.hasKey(obj.info, "clientMessage") Then
				mClientMessage = obj.info.clientMessage
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
		mConditionProductYn = ""
		mConditionProductList = Array()
		mConditionAmountYn = ""
		mConditionAmountTypeCode = ""
		mConditionAmount = ""
		mRateTypeCode = ""
		mRateValue = ""
		mMaxRateAmount = ""
		mGiftApplicationType = ""
		mGiftProductList = Array()
	End Sub

	Private Sub Class_Terminate
	End Sub
	
	Public Function toJson
		result = ""

		If result <> "" Then result = result & ","
		result = result & """code"":" & mCode

		If mMessage <> "" Then
			If result <> "" Then result = result & ","
			result = result & """message"":""" & mMessage & """"
		End If

		If result <> "" Then result = result & ","
		result = result & """result"":{"

		If mOrderNo <> "" Then
			If result <> "" Then result = result & ","
			result = result & """issueTypeCode"":""" & mIssueTypeCode & """"
		End If

		If mOrderDate <> "" Then
			If result <> "" Then result = result & ","
			result = result & """couponNo"":""" & mCouponNo & """"
		End If

		If mOrderDate <> "" Then
			If result <> "" Then result = result & ","
			result = result & """couponId"":""" & mCouponId & """"
		End If

		If mOrderDate <> "" Then
			If result <> "" Then result = result & ","
			result = result & """couponName"":""" & mCouponName & """"
		End If

		If mOrderDate <> "" Then
			If result <> "" Then result = result & ","
			result = result & """validStartDate"":""" & mValidStartDate & """"
		End If

		If mOrderDate <> "" Then
			If result <> "" Then result = result & ","
			result = result & """validEndDate"":""" & mValidEndDate & """"
		End If

		If mOrderDate <> "" Then
			If result <> "" Then result = result & ","
			result = result & """statusCode"":""" & mStatusCode & """"
		End If

		If mOrderDate <> "" Then
			If result <> "" Then result = result & ","
			result = result & """expiredYn"":""" & mExpiredYn & """"
		End If

		If mOrderDate <> "" Then
			If result <> "" Then result = result & ","
			result = result & """benefitTypeCode"":""" & mBenefitTypeCode & """"
		End If

		If mOrderDate <> "" Then
			If result <> "" Then result = result & ","
			result = result & """conditionProductYn"":""" & mConditionProductYn & """"
		End If

		If UBound(mConditionProductList) > -1 Then
			If result <> "" Then result = result & ","
			result = result & """conditionProductList"":["
			For i = 0 To UBound(mConditionProductList)
				If i > 0 Then result = result & ","
				result = result & mConditionProductList(i).toJson()
			Next
			result = result & "]"
		End If

		If mOrderNo <> "" Then
			If result <> "" Then result = result & ","
			result = result & """conditionAmountYn"":""" & mConditionAmountYn & """"
		End If

		If mOrderDate <> "" Then
			If result <> "" Then result = result & ","
			result = result & """conditionAmountTypeCode"":""" & mConditionAmountTypeCode & """"
		End If

		If mOrderDate <> "" Then
			If result <> "" Then result = result & ","
			result = result & """conditionAmount"":""" & mConditionAmount & """"
		End If

		If mOrderDate <> "" Then
			If result <> "" Then result = result & ","
			result = result & """rateTypeCode"":""" & mRateTypeCode & """"
		End If

		If mOrderDate <> "" Then
			If result <> "" Then result = result & ","
			result = result & """rateValue"":""" & mRateValue & """"
		End If

		If mOrderDate <> "" Then
			If result <> "" Then result = result & ","
			result = result & """maxRateAmount"":""" & mMaxRateAmount & """"
		End If

		If mOrderDate <> "" Then
			If result <> "" Then result = result & ","
			result = result & """giftApplicationType"":""" & mGiftApplicationType & """"
		End If

		If UBound(mGiftProductList) > -1 Then
			If result <> "" Then result = result & ","
			result = result & """giftProductList"":["
			For i = 0 To UBound(mGiftProductList)
				If i > 0 Then result = result & ","
				result = result & mGiftProductList(i).toJson()
			Next
			result = result & "]"
		End If

		result = result & "}"

		result = "{" & result & "}"

		toJson = result
	End Function

End Class
%>