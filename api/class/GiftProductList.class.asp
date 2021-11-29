<%
'주문멤버십사용 탭
Class clsGiftProductList
	Public mGiftProductClassCode, mGiftProductClassName, mGiftProductCode, mGiftProductName

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "giftProductClassCode") Then
			mGiftProductClassCode = obj.giftProductClassCode
		End If
		If JSON.hasKey(obj, "giftProductClassName") Then
			mGiftProductClassName = obj.giftProductClassName
		End If
		If JSON.hasKey(obj, "giftProductName") Then
			mGiftProductCode = obj.giftProductName
		End If
		If JSON.hasKey(obj, "giftProductName") Then
			mGiftProductName = obj.giftProductName
		End If
	End Function

	Private Sub Class_Initialize
		mGiftProductClassCode = ""
		mGiftProductClassName = ""
		mGiftProductCode = ""
		mGiftProductName = ""
	End Sub

	Private Sub Class_Terminate
	End Sub

	Public Function toJson
		cResult = ""

		If cResult <> "" Then cResult = cResult & ","
		cResult = cResult & """giftProductClassCode"":""" & mGiftProductClassCode & """"

		If cResult <> "" Then cResult = cResult & ","
		cResult = cResult & """giftProductClassName"":""" & mGiftProductClassName & """"

		If cResult <> "" Then cResult = cResult & ","
		cResult = cResult & """giftProductName"":""" & mGiftProductCode & """"

		If cResult <> "" Then cResult = cResult & ","
		cResult = cResult & """giftProductName"":""" & mGiftProductName & """"

		cResult = "{" & cResult & "}"

		toJson = cResult
	End Function
End Class
%>
