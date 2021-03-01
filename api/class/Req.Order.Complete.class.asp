<%
'주문완료 탭
Class clsReqOrderComplete
	Public mCompanyCode, mMerchantCode, mMemberNo, mServiceTradeNo, mOrderYmdt, mSaveYn, mDeliveryCharge, mOuterPayMethodList, mProductList, mOrderChannel

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "companyCode") Then
			mCompanyCode = obj.companyCode
		End If
		If JSON.hasKey(obj, "merchantCode") Then
			mMerchantCode = obj.merchantCode
		End If
		If JSON.hasKey(obj, "memberNo") Then
			mMemberNo = obj.memberNo
		End If
		If JSON.hasKey(obj, "serviceTradeNo") Then
			mServiceTradeNo = obj.serviceTradeNo
		End If
		If JSON.hasKey(obj, "orderYmdt") Then
			mOrderYmdt = obj.orderYmdt
		End If
		If JSON.hasKey(obj, "saveYn") Then
			mSaveYn = obj.saveYn
		End If
		If JSON.hasKey(obj, "deliveryCharge") Then
			mDeliveryCharge = obj.deliveryCharge
		End If
		If JSON.hasKey(obj, "orderChannel") Then
			mOrderChannel = obj.orderChannel
		End If

		'outerPayMethodList
		If JSON.hasKey(obj, "outerPayMethodList") Then
			ReDim mOuterPayMethodList(obj.outerPayMethodList.length - 1)
			For i = 0 To obj.outerPayMethodList.length - 1
				Dim tmpOuterPayMethodList : Set tmpOuterPayMethodList = New clsOuterPayMethodList
				tmpOuterPayMethodList.Init(obj.outerPayMethodList.get(i))
				Set mOuterPayMethodList(i) = tmpOuterPayMethodList
			Next
		End If

		'productList
		If JSON.hasKey(obj, "productList") Then
			ReDim mProductList(obj.productList.length - 1)
			For i = 0 To obj.productList.length - 1
				Dim tmpProductList : Set tmpProductList = New clsProductList
				tmpProductList.Init(obj.productList.get(i))
				Set mProductList(i) = tmpProductList
			Next
		End If
	End Function

	Sub Class_Initialize
		mCompanyCode = ""
		mMerchantCode = ""
		mMemberNo = ""
		mServiceTradeNo = ""
		mOrderYmdt = ""
		mSaveYn = ""
		mDeliveryCharge = 0
		mOrderChannel = ""
		mOuterPayMethodList = Array()
		mProductList = Array()
	End Sub

	Sub Class_Terminate
	End Sub

	Public Sub addOuterPayMethodList(productInfo)
		ReDim Preserve mOuterPayMethodList(UBound(mOuterPayMethodList) + 1)
		Set mOuterPayMethodList(UBound(mOuterPayMethodList)) = productInfo
	End Sub
	Public Sub addProductList(productInfo)
		ReDim Preserve mProductList(UBound(mProductList) + 1)
		Set mProductList(UBound(mProductList)) = productInfo
	End Sub

	Function toJson
		Dim i
		Dim result : result = ""

		If mCompanyCode <> "" Then
			If result <> "" Then result = result & ","
			result = result & """companyCode"":""" & mCompanyCode & """"
		End If
		If mMerchantCode <> "" Then
			If result <> "" Then result = result & ","
			result = result & """merchantCode"":""" & mMerchantCode & """"
		End If
		If mMemberNo <> "" Then
			If result <> "" Then result = result & ","
			result = result & """memberNo"":""" & mMemberNo & """"
		End If
		If mServiceTradeNo <> "" Then
			If result <> "" Then result = result & ","
			result = result & """serviceTradeNo"":""" & mServiceTradeNo & """"
		End If
		If mOrderYmdt <> "" Then
			If result <> "" Then result = result & ","
			result = result & """orderYmdt"":""" & mOrderYmdt & """"
		End If
		If mSaveYn <> "" Then
			If result <> "" Then result = result & ","
			result = result & """saveYn"":""" & mSaveYn & """"
		End If

		If result <> "" Then result = result & ","
		result = result & """deliveryCharge"":" & mDeliveryCharge

		If mOrderChannel <> "" Then
			If result <> "" Then result = result & ","
			result =  result & """orderChannel"":""" & mOrderChannel & """"
		End If
		
		'outerPayMethodList
		If result <> "" Then result = result & ","
			result = result & """outerPayMethodList"":["
			For i = 0 To UBound(mOuterPayMethodList)
				If i > 0 Then result = result & ","
				result = result & mOuterPayMethodList(i).toJson()
			Next
			result = result & "]"

		'productList
		If result <> "" Then result = result & ","
			result = result & """productList"":["
			For i = 0 To UBound(mProductList)
				If i > 0 Then result = result & ","
				result = result & mProductList(i).toJson()
			Next
			result = result & "]"

			result = "{" & result & "}"
			toJson = result
	End Function
End Class
%>