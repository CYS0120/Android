<%
'충전내역조회 탭
Class clsReqCardChargeInfo
	Public mCompanyCode, mBrandCode, mMemberNo, mMembershipChargeTradeNo

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
		If JSON.hasKey(obj, "membershipChargeTradeNo") Then
			mMembershipChargeTradeNo = obj.membershipChargeTradeNo
		End If
	End Function

	Sub Class_Initialize
		mCompanyCode = ""
		mBrandCode = ""
		mMemberNo = ""
		mMembershipChargeTradeNo = ""
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
		If mMembershipChargeTradeNo <> "" Then
			If result <> "" Then result = result & ","
			result = result & """membershipChargeTradeNo"":""" & mMembershipChargeTradeNo & """"
		End If

		result = "{" & result & "}"
		toJson = result
	End Function
End Class
%>