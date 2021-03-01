<%
'포인트잔액조회 탭
Class clsReqPointGetPointBalance
	Public mCompanyCode, mMerchantCode, mMemberNo, mAccountTypeCode, mExpirePeriod

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
		If JSON.hasKey(obj, "accountTypeCode") Then
			mAccountTypeCode = obj.accountTypeCode
		End If
		If JSON.hasKey(obj, "expirePeriod") Then
			mExpirePeriod = obj.expirePeriod
		End If
	End Function

	Sub Class_Initialize
		mCompanyCode = ""
		mMerchantCode = ""
		mMemberNo = ""
		mAccountTypeCode = ""
		mExpirePeriod = 0
	End Sub

	Sub Class_Terminate
	End Sub

	Function toJson
		Dim result : result = ""

		If mCompanyCode <> "" Then
			If result <> "" Then result = result & "."
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
		If mAccountTypeCode <> "" Then
			If result <> "" Then result = result & ","
			result = result & """accountTypeCode"":""" & mAccountTypeCode & """"
		End If

		If result <> "" Then result = result & ","
			result = result & """expirePeriod"":" & mExpirePeriod

		result = "{" & result & "}"
		toJson = result
	End Function
End Class
%>