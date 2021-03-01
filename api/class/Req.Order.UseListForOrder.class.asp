<%
'주문멤버십사용 탭
Class clsReqOrderUseListForOrder
	Public mCompanyCode, mMerchantCode, mMemberNo, mServiceTradeNo, mTotalOrderAmount, mCouponList, mPointList, mProductList, mOrderChannel

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
		If JSON.hasKey(obj, "totalOrderAmount") Then
			mTotalOrderAmount = obj.totalOrderAmount
		End If
		If JSON.hasKey(obj, "orderChannel") Then
			mOrderChannel = obj.orderChannel
		End If
		'If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqiOS") > 0 Or instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Then
		'	mOrderChannel = "APP"
		'Else
		'	mOrderChannel = "WEB"
		'End If

		'couponList
		If JSON.hasKey(obj, "couponList") Then
			ReDim mCouponList(obj.couponList.length - 1)
			For i = 0 To obj.couponList.length - 1
				Dim tmpCouponList : Set tmpCouponList = New clsCouponList
				tmpCouponList.Init(obj.couponList.get(i))
				Set mCouponList(i) = tmpCouponList
			Next
		End If

		'pointList
		If JSON.hasKey(obj, "pointList") Then
			ReDim mPointList(obj.pointList.length - 1)
			For i = 0 To obj.pointList.length - 1
				Dim tmpPointList : Set tmpPointList = New clsPointList
				tmpPointList.Init(obj.pointList.get(i))
				Set mPointList(i) = tmpPointList
			Next
		End If

		'productList
		If JSON.hasKey(obj, "productList") Then
			ReDim mProductList(obj.productList.length - 1)
			For i = 0 To obj.productList.length - 1
				Dim tmpProductList : Set tmpProductList = New clsProductList
				tmpProductList.Init(obj.productList.get(i))
				Set mProductList = tmpProductList
			Next
		End If
	End Function

	Sub Class_Initialize
		mCompanyCode = ""
		mMerchantCode = ""
		mMemberNo = ""
		mServiceTradeNo = ""
		mTotalOrderAmount = 0
		mOrderChannel = ""
		mCouponList = Array()
		mPointList = Array()
		mProductList = Array()
	End Sub

	Sub Class_Terminate
	End Sub

	Public Sub addCouponList(productInfo)
		ReDim Preserve mCouponList(UBound(mCouponList) + 1)
		Set mCouponList(UBound(mCouponList)) = productInfo
	End Sub
	Public Sub addPointList(productInfo)
		ReDim Preserve mPointList(UBound(mPointList) + 1)
		Set mPointList(UBound(mPointList)) = productInfo
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

		If result <> "" Then result = result & ","
		result = result & """totalOrderAmount"":" & mTotalOrderAmount

		If mOrderChannel <> "" Then
			If result <> "" Then result = result & ","
			result =  result & """orderChannel"":""" & mOrderChannel & """"
		End If
		
		'couponList
		If result <> "" Then result = result & ","
			result = result & """couponList"":["
			For i = 0 To UBound(mCouponList)
				If i > 0 Then result = result & ","
				result = result & mCouponList(i).toJson()
			Next
			result = result & "]"

		'pointList
		If result <> "" Then result = result & ","
			result = result & """pointList"":["
			For i = 0 To UBound(mPointList)
				If i > 0 Then result = result & ","
				result = result & mPointList(i).toJson()
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