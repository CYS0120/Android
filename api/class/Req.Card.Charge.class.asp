<%
'카드충전 탭
Class clsReqCardCharge
	Public mCompanyCode, mBrandCode, mMemberNo, mCardNo, mMerchantCode, mOuterChargeTradeNo, mPayMethods

	Public Function init(ByRef obj)
		If JSON.hasKey(obj, "companyCode") Then
			mCompanyCode = obj.companyCode
		End If
		If JSON.hasKey(obj, "brandCode") Then
			mBrandCode = obj.brandCode
		End If 
		If JSON.hasKey(obj, "memberNo") Then
			mMemberNo = obj.memberNo
		End If
		If JSON.hasKey(obj, "cardNo") Then
			mCardNo = obj.cardNo
		End If
		If JSON.hasKey(obj, "merchantCode") Then
			mMerchantCode = obj.merchantCode
		End If
		If JSON.hasKey(obj, "outerChargeTradeNo") Then
			mOuterChargeTradeNo = obj.outerChargeTradeNo
		End If

		'payMethods
		If JSON.hasKey(obj, "payMethods") Then
			ReDim mPayMethods(obj.PayMethods.lengh - 1)
			For i = 0 To obj.payMethods.length - 1
				Dim tmpPayMethods : Set tmpPayMethods = New clsPayMethods
				tmpPayMethods.Init(obj.payMethods.get(i))
				Set mPayMethods(i) = tmpPayMethods
			Next
		End If
	End Function

	Sub Class_Initialize
		mCompanyCode = ""
		mBrandCode = ""
		mMemberNo = ""
		mCardNo = ""
		mMerchantCode = ""
		mOuterChargeTradeNo = ""
		mPayMethods = Array()
	End Sub

	Sub Class_Terminate
	End Sub

	Public Sub addPayMethods(productInfo)
		ReDim Preserve mPayMethods(UBound(mPayMethods) + 1)
		Set mPayMethods(UBound(mPayMethods)) = productInfo
	End Sub

	Function toJson
		Dim i
		Dim result : result = ""

		If mCompanyCode <> "" Then
			If result <> "" Then result = result & ","
			result = result & """companyCode"":""" & mCompanyCode & """"
		End If
		If mBrandCode <> "" Then
			If result <> "" Then result = result & ","
			result = result & """brandCode"":""" & mBrandCode & """"
		End If
		If mMemberNo <> "" Then
			If result <> "" Then result = result & ","
			result = result & """memberNo"":""" & mMemberNo & """"
		End If
		If mCardNo <> "" Then
			If result <> "" Then result = result & ","
			result = result & """cardNo"":""" & mCardNo & """"
		End If
		If mMerchantCode <> "" Then
			If result <> "" Then result = result & ","
			result = result & """merchantCode"":""" & mMerchantCode & """"
		End If
		If mOuterChargeTradeNo <> "" Then
			If result <> "" Then result = result & ","
			result = result & """outerChargeTradeNo"":""" & mOuterChargeTradeNo & """"
		End If

		'payMethods
		If result <> "" Then result = result & ","
			result = result & """payMethods"":["
			For i = 0 To UBound(mPayMethods)
				If i > 0 Then result = result & ","
				result = result & mPayMethods(i).toJson()
			Next
			result = result & "]"

		result = "{" & result & "}"
		toJson = result
	End Function
End Class
%>