<%
'주문취소 탭
Class clsProductCancelList
	Public mProductClassCd, mProductCd, mUnitPrice, mProductCount, mProductSaveYn

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "productClassCd") Then
			mProductClassCd = obj.productClassCd
		End If
		If JSON.hasKey(obj, "productCd") Then
			mProductCd = obj.productCd
		End If
		If JSON.hasKey(obj, "unitPrice") Then
			mUnitPrice = obj.unitPrice
		End If
		If JSON.hasKey(obj, "productCount") Then
			mProductCount = obj.productCount
		End If
		If JSON.hasKey(obj, "productSaveYn") Then
			mProductSaveYn = obj.productSaveYn
		End If
	End Function

	Sub Class_Initialize
		mProductClassCd = ""
		mProductCd = ""
		mUnitPrice = 0
		mProductCount = 0
		mProductSaveYn = ""
	End Sub

	Sub Class_Terminate
	End Sub

	Function toJson
		cResult = ""

		If mProductClassCd <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """productClassCd"":""" & mProductClassCd & """"
		End If
		If mProductCd <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """productCd"":""" & mProductCd & """"
		End If

		If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """unitPrice"":" & mUnitPrice
		If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """productCount"":" & mProductCount

		If mProductSaveYn <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """productSaveYn"":""" & mProductSaveYn & """"
		End If

		cResult = "{" & cResult & "}"
		toJson = cResult
	End Function
End Class
%>