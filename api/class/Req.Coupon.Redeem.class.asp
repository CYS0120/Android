<%
'점원수동사용
Class clsReqCouponRedeem
	Public mCompanyCode, mMemberNo, mCouponNo, mPassword

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "companyCode") Then
			mCompanyCode = obj.companyCode
		End If
		If JSON.hasKey(obj, "memberNo") Then
			mMemberNo = obj.memberNo
		End If
		If JSON.hasKey(obj, "couponNo") Then
			mCouponNo = obj.couponNo
		End If
		If JSON.hasKey(obj, "password") Then
			mPassword = obj.password
		End If
	End Function

	Sub Class_Initialize
		mCompanyCode = ""
		mMemberNo = ""
		mCouponNo = ""
		mPassword = ""
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
		If mCouponNo <> "" Then
			If result <> "" Then result = result & ","
			result = result & """couponNo"":""" & mCouponNo & """"
		End If
		If mPassword <> "" Then
			If result <> "" Then result = result & ","
			result = result & """password"":""" & mPassword & """"
		End If

		result = "{" & result & "}"
		toJson = result
	End Function
End Class
%>