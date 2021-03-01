<%
'포인트거래 탭
Class clsTrade
	Public mTradeDate, mAccountType, mAccountTypeName, mCardNo, mPointTradNo, mPointTradeTypeName, mDetailTradeReasonName, mTradePoint, mSnapshotTotalRestPoint, mValidStartDate, mValidEndDate, mTradeCompanyCode, mTradeMerchantCode, mMerchantTypeName, mServiceTradeNo

	Public Function Init(Byref obj)
		If JSON.hasKey(obj, "tradeDate") Then
			mTradeDate = obj.tradeDate
		End If
		If JSON.hasKey(obj, "accountType") Then
			mAccountType = obj.accountType
		End If
		If JSON.hasKey(obj, "accountTypeName") Then
			mAccountTypeName = obj.accountTypeName
		End If
		If JSON.hasKey(obj, "cardNo") Then
			mCardNo = obj.cardNo
		End If
		If JSON.hasKey(obj, "pointTradeNo") Then
			mPointTradNo = obj.pointTradeNo
		End If
		If JSON.hasKey(obj, "pointTradeTypeName") Then
			mPointTradeTypeName = obj.pointTradeTypeName
		End If
		If JSON.hasKey(obj, "detailTradeReasonName") Then
			mDetailTradeReasonName = obj.detailTradeReasonName
		End If
		If JSON.hasKey(obj, "tradePoint") Then
			mTradePoint = obj.tradePoint
		End If
		If JSON.hasKey(obj, "snapshotTotalRestPoint") Then
			mSnapshotTotalRestPoint = obj.snapshotTotalRestPoint
		End If
		If JSON.hasKey(obj, "validStartDate") Then
			mValidStartDate = obj.validStartDate
		End If
		If JSON.hasKey(obj, "validEndDate") Then
			mValidEndDate = obj.validEndDate
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
	End Function

	Private Sub Class_Initialize
		mTradeDate = ""
		mAccountType = ""
		mAccountTypeName = ""
		mCardNo = ""
		mPointTradNo = 0
		mPointTradeTypeName = ""
		mDetailTradeReasonName = ""
		mTradePoint = 0
		mSnapshotTotalRestPoint = 0
		mValidStartDate = ""
		mValidEndDate = ""
		mTradeCompanyCode = ""
		mTradeMerchantCode = ""
		mMerchantTypeName = ""
		mServiceTradeNo = ""
	End Sub

	Private Sub Class_Terminate
	End Sub

	Function toJson
		cResult = ""

		If mTradeDate <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """tradeDate"":""" & mTradeDate & """"
		End If
		If mAccountType <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """accountType"":""" & mAccountType & """"
		End If
		If mAccountTypeName <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """accountTypeName"":""" & mAccountTypeName & """"
		End If
		If mCardNo <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """cardNo"":""" & mCardNo & """"
		End If
		If mPointTradeNo <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """pointTradeNo"":""" & mPointTradeNo & """"
		End If
		If mPointTradeMark <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """pointTradeMark"":""" & mPointTradeMark & """"
		End If
		If mPointTradeTypeName <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """pointTradeTypeName"":""" & mPointTradeTypeName & """"
		End If
		If mDetailTradeReasonName <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """detailTradeReasonName"":""" & mDetailTradeReasonName & """"
		End If
		If mTradePoint <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """tradePoint"":" & mTradePoint
		End If
		If mSnapshotTotalRestPoint <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """snapshotTotalRestPoint"":" & mSnapshotTotalRestPoint
		End If
		If mValidStartDate <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """validStartDate"":""" & mValidStartDate & """"
		End If
		If mValidEndDate <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """validEndDate"":""" & mValidEndDate & """"
		End If
		If mTradeCompanyCode <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """tradeCompanyCode"":""" & mTradeCompanyCode & """"
		End If
		If mTradeMerchantCode <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """tradeMerchantCode"":""" & mTradeMerchantCode & """"
		End If
		If mTradeMerchantName <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """tradeMerchantName"":""" & mTradeMerchantName & """"
		End If
		If mMerchantTypeName <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """merchantTypeName"":""" & mMerchantTypeName & """"
		End If
		If mServiceTradeNo <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """serviceTradeNo"":""" & mServiceTradeNo & """"
		End If

		cResult = "{" & cResult & "}"
		toJson = cResult
	End Function
End Class
%>