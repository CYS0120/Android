<%
'쿠폰발급 탭
Class clsReqCouponIssueByPinV2
	Public mCompanyCode, mMemberNo, mPinNo

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "companyCode") Then
			mCompanyCode = obj.companyCode
		End If
		If JSON.hasKey(obj, "memberNo") Then
			mMemberNo = obj.memberNo
		End If
		If JSON.hasKey(obj, "pinNo") Then
			mPinNo = obj.pinNo
		End If
	End Function

	Sub Class_Initialize
		mCompanyCode = ""
		mMemberNo = ""
		mPinNo = ""
	End Sub

	Sub Class_Terminate
	End Sub

	Function toJson
		Dim result : result = ""

		If mCompanyCode <> "" Then
			If result <> "" Then result = result & ","
			result = result & """companyCode"":""" & mCompanyCode & """"
		End If
		If mMemberNo <> "" Then
			If result <> "" Then result = result & ","
			result = result & """memberNo"":""" & mMemberNo & """"
		End If
		If mPinNo <> "" Then
			If result <> "" Then result = result & ","
			result = result & """pinNo"":""" & mPinNo & """"
		End If

		result = "{" & result & "}"
		toJson = result
	End Function
End Class
%>