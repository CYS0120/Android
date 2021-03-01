<%
'카드등록
Class clsReqCardRegRealCard
	Public mCompanyCode, mBrandCode, mMemberNo, mCardNo, mCardPinNo, mCardNickName

	Public Function Init(ByRef obj)
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
		If JSON.hasKey(obj, "cardPinNo") Then
			mCardPinNo = obj.cardPinNo
		End If
		If JSON.hasKey(obj, "cardNickName") Then
			mCardNickName = obj.cardNickName
		End If
	End Function

	Sub Class_Initialize
		mCompanyCode = ""
		mBrandCode = ""
		mMemberNo = ""
		mCardNo = ""
		mCardPinNo = ""
		mCardNickName = ""
	End Sub

	Sub Class_Terminate
	End Sub

	Function toJson
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
		If mCardPinNo <> "" Then
			If result <> "" Then result = result & ","
			result = result & """cardPinNo"":""" & mCardPinNo & """"
		End If
		If mCardNickName <> "" Then
			If result <> "" Then result = result & ","
			result = result & """mCardNickName"":""" & mCardNickName &""""
		End If

		result = "{" & result & "}"
		toJson = result
	End Function
End Class
%>