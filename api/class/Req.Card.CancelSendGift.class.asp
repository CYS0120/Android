<%
'카드선물보내기취소 탭
Class clsReqCardCancelSendGift
	Public mCompanyCode, mBrandCode, mMemberNo, mCardGiftTradeNo, mOuterCancelChargeTradeNo

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
		If JSON.hasKey(obj, "cardGiftTradeNo") Then
			mCardGiftTradeNo = obj.cardGiftTradeNo
		End If
		If JSON.hasKey(obj, "outerCancelChargeTradeNo") Then
			mOuterCancelChargeTradeNo = obj.outerCancelChargeTradeNo
		End If
	End Function

	Sub Class_Initialize
		mCompanyCode = ""
		mBrandCode = ""
		mMemberNo = ""
		mCardGiftTradeNo = ""
		mOuterCancelChargeTradeNo = ""
	End Sub

	Sub Class_Terminate
	End Sub

	Function toJson
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
		If mCardGiftTradeNo <> "" Then
			If result <> "" Then result = result & ","
			result = result & """cardGiftTradeNo"":""" & mCardGiftTradeNo & """"
		End If
		If mOuterCancelChargeTradeNo <> "" Then
			If result <> "" Then result = result & ","
			result = result & """outerCancelChargeTradeNo"":""" & mOuterCancelChargeTradeNo & """"
		End If

		result = "{" & result & "}"
		toJson = result
	End Function
End Class
%>