<%
'주문멤버십사용 탭
'주문완료 탭
'주문확정 탭
Class clsProductList
	Public mProductClassCd, mProductCd, mTargetUnitPrice, mUnitPrice, mProductCount, mCouponPin
	Public mProductClassNm, mProductNm
	Public mProductSaveYn
	Public mPayMethodCode

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "productClassCd") Then
			mProductClassCd = obj.productClassCd
		End If
		If JSON.hasKey(obj, "productCd") Then
			mProductCd = obj.productCd
		End If
		If JSON.hasKey(obj, "targetUnitPrice") Then
			mTargetUnitPrice = obj.targetUnitPrice
		End If
		If JSON.hasKey(obj, "unitPrice") Then
			mUnitPrice = obj.unitPrice
		End If
		If JSON.hasKey(obj, "productCount") Then
			mProductCount = obj.productCount
		End If
		If JSON.hasKey(obj, "couponPin") Then
			mCouponPin = obj.couponPin
		End If

		'주문멤버십사용 탭 Req
		If JSON.hasKey(obj, "productClassNm") Then
			mProductClassNm = obj.productClassNm
		End If
		If JSON.hasKey(obj, "productNm") Then
			mProductNm = obj.productNm
		End If

		'주문완료 탭 Req
		If JSON.hasKey(obj, "productSaveYn") Then
			mProductSaveYn = obj.productSaveYn
		End If

		'주문확정 탭 Req
		If JSON.hasKey(obj, "payMethodCode") Then
			mPayMethodCode = obj.payMethodCode
		End If
	End Function

	Sub Class_Initialize
		mProductClassCd = ""
		mProductCd = ""
		mTargetUnitPrice = 0
		mUnitPrice = 0
		mProductCount = 0
		mCouponPin = ""

		'주문멤버십사용 탭 Req
		mProductClassNm = ""
		mProductNm = ""

		'주문완료 탭 Req
		mProductSaveYn = ""

		'주문확정 탭 Req
		mPayMethodCode = ""
	End Sub

	Sub Class_Terminate
	End Sub

	Function toJson
		cResult = ""

		If mProductClassCd <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """productClassCd"":""" & mProductClassCd & """"
		End If
		If mProductClassNm <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """productClassNm"":""" & mProductClassNm & """"
		End If
		If mProductCd <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """productCd"":""" & mProductCd & """"
		End If
		If mProductNm <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """productNm"":""" & mProductNm & """"
		End If
		If mCouponPin <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """couponPin"":""" & mCouponPin & """"
		End If

		If cResult <> "" Then cResult = cResult & ","
		cResult = cResult & """unitPrice"":" & mUnitPrice

		If cResult <> "" Then cResult = cResult & ","
		cResult = cResult & """targetUnitPrice"":" & mTargetUnitPrice

		If cResult <> "" Then cResult = cResult & ","
		cResult = cResult & """productCount"":" & mProductCount
			
		If mProductSaveYn <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """productSaveYn"":""" & mProductSaveYn & """"
		End If
		If mPayMethodCode <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """payMethodCode"":""" & mPayMethodCode & """"
		End If

		cResult = "{" & cResult & "}"
		toJson = cResult
	End Function
End Class
%>