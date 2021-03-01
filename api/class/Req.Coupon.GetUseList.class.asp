<%
'쿠폰사용내역조회 탭
Class clsReqCouponGetUseList
	Public mCompanyCode, mMerchantCode, mMemberNo, mStartYmd, mEndYmd, mPerPage, mPage

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
		If JSON.hasKey(obj, "startYmd") Then
			mStartYmd = obj.startYmd
		End If
		If JSON.hasKey(obj, "endYmd") Then
			mEndYmd = obj.endYmd
		End If
		If JSON.hasKey(obj, "perPage") Then
			mPerPage = obj.perPage
		End If
		If JSON.hasKey(obj, "page") Then
			mPage = obj.page
		End If
	End Function

	Sub Class_Initialize
		mCompanyCode = ""
		mMerchantCode = ""
		mMemberNo = ""
		mStartYmd = ""
		mEndYmd = ""
		mPerPage = 0
		mPage = 0
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
		If mStartYmd <> "" Then
			If result <> "" Then result = result & ","
			result = result & """startYmd"":""" & mStartYmd & """"
		End If
		If mEndYmd <> "" Then
			If result <> "" Then result = result & ","
			result = result & """endYmd"":""" & mEndYmd & """"
		End If

		If result <> "" Then result = result & ","
		result = result & """perPage"":" & mPerPage
		If result <> "" Then result = result & ","
		result = result & """page"":" & mPage

		result = "{" & result & "}"
		toJson = result
	End Function
End Class
%>