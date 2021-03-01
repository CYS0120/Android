<%
'주문취소 탭
Class clsReqOrderCancel
	Public mCompanyCode, mMerchantCode, mMemberNo, mServiceTradeNo, mCancelServiceTradeNo, mCancelType, mOuterPayMethodCancelList, mProductCancelList, mPointUseCancelList, mPointAcmCancelList

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
		If JSON.hasKey(obj, "cancelServiceTradeNo") Then
			mCancelServiceTradeNo = obj.cancelServiceTradeNo
		End If
		If JSON.hasKey(obj, "cancelType") Then
			mCancelType = obj.cancelType
		End If
		
		'outerPayMethodCancelList
		If JSON.hasKey(obj, "outerPayMethodCancelList") Then
			ReDim mOuterPayMethodCancelList(obj.outerPayMethodCancelList.length - 1)
			For i = 0 To obj.outerPayMethodCancelList.length - 1
				Dim tmpOuterPayMethodCancelList : Set tmpOuterPayMethodCancelList = New clsOuterPayMethodCancelList
				tmpOuterPayMethodCancelList.Init(obj.outerPayMethodCancelList.get(i))
				Set mOuterPayMethodCancelList(i) = tmpOuterPayMethodCancelList
			Next
		End If

		'productCancelList
		If JSON.hasKey(obj, "productCancelList") Then
			ReDim mProductCancelList(obj.productCancelList.length - 1)
			For i = 0 To obj.productCancelList.length - 1
				Dim tmpProductCancelList : Set tmpProductCancelList = New clsProductCancelList
				tmpProductCancelList.Init(obj.productCancelList.get(i))
				Set mProductCancelList(i) = tmpProductCancelList
			Next
		End If

		'pointUseCancelList
		If JSON.hasKey(obj, "pointUseCancelList") Then
			ReDim mPointUseCancelList(obj.pointUseCancelList.length - 1)
			For i = 0 To obj.pointUseCancelList.length - 1
				Dim tmpPointUseCancelList : Set tmpPointUseCancelList = New clsPointUseCancelList
				tmpPointUseCancelList.Init(obj.pointUseCancelList.get(i))
				Set mPointUseCancelList(i) = tmpPointUseCancelList
			Next
		End If

		'pointAcmCancelList
		If JSON.hasKey(obj, "pointAcmCancelList") Then
			ReDim mPointAcmCancelList(obj.pointAcmCancelList.length - 1)
			For i = 0 To obj.pointAcmCancelList.length - 1
				Dim tmpPointAcmCancelList : Set tmpPointAcmCancelList = New clsPointAcmCancelList
				tmpPointAcmCancelList.Init(obj.pointAcmCancelList.get(i))
				Set mPointAcmCancelList(i) = tmpPointAcmCancelList
			Next
		End If
	End Function

	Sub Class_Initialize
		mCompanyCode = ""
		mMerchantCode = ""
		mMemberNo = ""
		mServiceTradeNo = ""
		mCancelServiceTradeNo = ""
		mCancelType = ""
		mOuterPayMethodCancelList = Array()
		mProductCancelList = Array()
		mPointUseCancelList = Array()
		mPointAcmCancelList = Array()
	End Sub

	Sub Class_Terminate
	End Sub

	Public Sub addOuterPayMethodCancelList(productInfo)
		ReDim Preserve mOuterPayMethodCancelList(UBound(mOuterPayMethodCancelList) + 1)
		Set mOuterPayMethodCancelList(UBound(mOuterPayMethodCancelList)) = productInfo
	End Sub
	Public Sub addProductCancelList(productInfo)
		ReDim Preserve mProductCancelList(UBound(mProductCancelList) + 1)
		Set mProductCancelList(UBound(mProductCancelList)) = productInfo
	End Sub
	Public Sub addPointUseCancelList(productInfo)
		ReDim Preserve mPointUseCancelList(UBound(mPointUseCancelList) + 1)
		Set mPointUseCancelList(UBound(mPointUseCancelList)) = productInfo
	End Sub
	Public Sub addPointAcmCancelList(productInfo)
		ReDim Preserve mPointAcmCancelList(UBound(mPointAcmCancelList) + 1)
		Set mPointAcmCancelList(UBound(mPointAcmCancelList)) = productInfo
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
		If mCancelServiceTradeNo <> "" Then
			If result <> "" Then result = result & ","
			result = result & """cancelServiceTradeNo"":""" & mCancelServiceTradeNo & """"
		End If
		If mCancelType <> "" Then
			If result <> "" Then result = result & ","
			result = result & """cancelType"":""" & mCancelType & """"
		End If

		'outerPayMethodCancelList
		If result <> "" Then result = result & ","
			result = result & """outerPayMethodCancelList"":["
			For i = 0 To UBound(mOuterPayMethodCancelList)
				If i > 0 Then result = result & ","
				result = result & mOuterPayMethodCancelList(i).toJson()
			Next
			result = result & "]"

		'productCancelList
		If result <> "" Then result = result & ","
			result = result & """productCancelList"":["
			For i = 0 To UBound(mProductCancelList)
				If i > 0 Then result = result & ","
				result = result & mProductCancelList(i).toJson()
			Next
			result = result & "]"

		'pointUseCancelList
		If result <> "" Then result = result & ","
			result = result & """pointUseCancelList"":["
			For i = 0 To UBound(mPointUseCancelList)
				If i > 0 Then result = result & ","
				result = result & mPointUseCancelList(i).toJson()
			Next
			result = result & "]"

		'pointAcmCancelList
		If result <> "" Then result = result & ","
			result = result & """pointAcmCancelList"":["
			For i = 0 To UBound(mPointAcmCancelList)
				If i > 0 Then result = result & ","
				result = result & mPointAcmCancelList(i).toJson()
			Next
			result = result & "]"

		result = "{" & result & "}"
		toJson = result
	End Function
End Class
%>