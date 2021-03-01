<%
'주문사용가능멤버십조회 탭
Class clsReqOrderGetListForOrder
	Public mCompanyCode, mMerchantCode, mMemberNo, mOrderAmount, mAccountTypeCode, mCardNo, mProductList, mOrderChannel

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
		If JSON.hasKey(obj, "orderAmount") Then
			mOrderAmount = obj.orderAmount
		End If
		If JSON.hasKey(obj, "accountTypeCode") Then
			mAccountTypeCode = obj.accountTypeCode
		End If
		If JSON.hasKey(obj, "cardNo") Then
			mCardNo = obj.cardNo
		End If
		If JSON.hasKey(obj, "orderChannel") Then
			mOrderChannel = obj.orderChannel
		End If
		'If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqiOS") > 0 Or instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Then
		'	mOrderChannel = "APP"
		'Else
		'	mOrderChannel = "WEB"
		'End If
		
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
		mOrderAmount = 0
		mAccountTypeCode = ""
		mCardNo = ""
		mOrderChannel = ""
		mProductList = Array()
	End Sub

	Sub Class_Terminate
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
		
		If result <> "" Then result = result & ","
			result = result & """orderAmount"":" & mOrderAmount
		
		If mAccountTypeCode <> "" Then
			If result <> "" Then result = result & ","
			result = result & """accountTypeCode"":""" & mAccountTypeCode & """"
		End If
		If mCardNo <> "" Then
			If result <> "" Then result = result & ","
			result =  result & """cardNo"":""" & mCardNo & """"
		End If
		If mOrderChannel <> "" Then
			If result <> "" Then result = result & ","
			result =  result & """orderChannel"":""" & mOrderChannel & """"
		End If

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