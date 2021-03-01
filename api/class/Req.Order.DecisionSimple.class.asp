<%
'주문확정 탭
Class clsReqOrderDecisionSimple
	Public mCompanyCode, mMerchantCode, mMemberNo, mServiceTradeNo, mProductList, mOrderChannel

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
		If JSON.hasKey(obj, "serviceTradeNo") Then
			mServiceTradeNo = obj.serviceTradeNo
		End If
		If JSON.hasKey(obj, "orderChannel") Then
			mOrderChannel = obj.orderChannel
		End If
	End Function

	Sub Class_Initialize
		mCompanyCode = ""
		mMerchantCode = ""
		mMemberNo = ""
		mServiceTradeNo = ""
		mOrderChannel = ""
	End Sub

	Sub Class_Terminate
	End Sub

	Function toJson
		Dim i
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
		If mServiceTradeNo <> "" Then
			If result <> "" Then result = result & ","
			result = result & """serviceTradeNo"":""" & mServiceTradeNo & """"
		End If
		If mOrderChannel <> "" Then
			If result <> "" Then result = result & ","
			result = result & """orderChannel"":""" & mOrderChannel & """"
		End If

		result = "{" & result & "}"
		toJson = result
	End Function
End Class
%>