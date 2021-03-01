<%
'쿠폰보유내역조회 탭
Class clsReqCouponGetDetail
	Public mCompanyCode, mCouponId

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "companyCode") Then
			mCompanyCode = obj.companyCode
		End If
		If JSON.hasKey(obj, "couponId") Then
			mCouponId = obj.couponId
		End If
	End Function

	Sub Class_Initialize
		mCompanyCode = ""
		mCouponId = ""
	End Sub

	Sub Class_Terminate
	End Sub

	Function toJson
		Dim result : result = ""

		If mCompanyCode <> "" Then
			If result <> "" Then result = result & ","
			result = result & """companyCode"":""" & mCompanyCode & """"
		End If
		If mCouponId <> "" Then
			If result <> "" Then result = result & ","
			result = result & """couponId"":""" & mCouponId & """"
		End If

		result = "{" & result & "}"
		toJson = result
	End Function
End Class
%>