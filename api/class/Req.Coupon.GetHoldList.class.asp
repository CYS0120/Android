<%
'쿠폰보유내역조회 탭
Class clsReqCouponGetHoldList
	Public mCompanyCode, mMerchantCode, mMemberNo, mStatusCode, mIncludeExpired, mPerPage, mPage, mRateValue

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
		If JSON.hasKey(obj, "statusCode") Then
			mStatusCode = obj.statusCode
		End If
		If JSON.hasKey(obj, "includeExpired") Then
			mIncludeExpired = obj.includeExpired
		End If
		If JSON.hasKey(obj, "perPage") Then
			mPerPage = obj.perPage
		End If
		If JSON.hasKey(obj, "page") Then
			mPage = obj.page
		End If
		If JSON.hasKey(obj, "rateValue") Then
			mRateValue = obj.rateValue
		End If
	End Function

	Sub Class_Initialize
		mCompanyCode = ""
		mMerchantCode = ""
		mMemberNo = ""
		mStatusCode = ""
		mIncludeExpired = ""
		mPerPage = 0
		mPage = 0
		mRateValue = 0
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
		If mStatusCode <> "" Then
			If result <> "" Then result = result & ","
			result = result & """statusCode"":""" & mStatusCode & """"
		End If
		If mIncludeExpired <> "" Then
			If result <> "" Then result = result & ","
			result = result & """includeExpired"":""" & mIncludeExpired & """"
		End If

		If result <> "" Then result = result & ","
		result = result & """perPage"":" & mPerPage

		If result <> "" Then result = result & ","
		result = result & """page"":" & mPage

		If result <> "" Then result = result & ","
		result = result & """rateValue"":" & mRateValue

		result = "{" & result & "}"
		toJson = result
	End Function
End Class
%>