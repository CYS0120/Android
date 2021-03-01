<%
'쿠폰사용내역조회 탭
Class clsUseList
	Public mUseDate, mCouponNo, mCouponId, mCouponName, mDiscountAmount, mHistoryStatus, mTradeCompanyCode, mTradeMerchantCode, mMerchantTypeName, mServiceTradeNo, mBenefitTypeCode

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "useDate") Then
			mUseDate = obj.useDate
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
		If JSON.hasKey(obj, "discountAmount") Then
			mDiscountAmount = obj.discountAmount
		End If
		If JSON.hasKey(obj, "historyStatus") Then
			mHistoryStatus = obj.historyStatus
		End If
		If JSON.hasKey(obj, "tradeCompanyCode") Then
			mTradeCompanyCode = obj.tradeCompanyCode
		End If
		If JSON.hasKey(obj, "tradeMerchantCode") Then
			mTradeMerchantCode = obj.tradeMerchantCode
		End If
		If JSON.hasKey(obj, "merchantTypeName") Then
			mMerchantTypeName = obj.merchantTypeName
		End If
		If JSON.hasKey(obj, "serviceTradeNo") Then
			mServiceTradeNo = obj.serviceTradeNo
		End If
		If JSON.hasKey(obj, "benefitTypeCode") Then
			mBenefitTypeCode = obj.benefitTypeCode
		End If
	End Function

	Private Sub Class_Initialize
		mUseDate = ""
		mCouponNo = ""
		mCouponId = ""
		mCouponName = ""
		mDiscountAmount = 0
		mHistoryStatus = ""
		mTradeCompanyCode = ""
		mTradeMerchantCode = ""
		mMerchantTypeName = ""
		mServiceTradeNo = ""
		mBenefitTypeCode = ""
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>