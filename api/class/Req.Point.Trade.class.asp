<%
'포인트거래 탭
Class clsReqPointTrade
	Public mCompanyCode, mMerchantCode, mMemberNo, mTradeType, mPoint, mDescription

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
		If JSON.hasKey(obj, "tradeType") Then
			mTradeType = obj.tradeType
		End If
		If JSON.hasKey(obj, "point") Then
			mPoint = obj.point
		End If
		If JSON.hasKey(obj, "description") Then
			mDescription = obj.description
		End If
	End Function

	Sub Class_Initialize
		mCompanyCode = ""
		mMerchantCode = ""
		mMemberNo = ""
		mTradeType = ""
		mPoint = 0
		mDescription = ""
	End Sub

	Sub Class_Terminate
	End Sub

	Function toJson
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
		If mTradeType <> "" Then
			If result <> "" Then result = result & ","
			result = result & """tradeType"":""" & mTradeType & """"
		End If

		If result <> "" Then result = result & ","
			result = result & """point"":" & mPoint

		If mDescription <> "" Then
			If result <> "" Then result = result & ","
			result = result & """description"":""" & mDescription & """"
		End If

		result = "{" & result & "}"
		toJson = result
	End Function
End Class
%>