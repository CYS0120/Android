<%
'주문취소 탭
Class clsPointUseCancelList
	Public mAccountTypeCode, mUseCancelPoint, mCardNo

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "accountTypeCode") Then
			mAccountTypeCode = obj.accountTypeCode
		End If
		If JSON.hasKey(obj, "useCancelPoint") Then
			mUseCancelPoint = obj.useCancelPoint
		End If
		If JSON.hasKey(obj, "cardNo") Then
			mCardNo = obj.cardNo
		End If
	End Function

	Sub Class_Initialize
		mAccountTypeCode = ""
		mUseCancelPoint = 0
		mCardNo = ""
	End Sub

	Sub Class_Terminate
	End Sub

	Function toJson
		cResult = ""

		If mAccountTypeCode <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """accountTypeCode"":""" & mAccountTypeCode & """"
		End If

		If cResult <> "" Then cResult = cResult & ","
		cResult = cResult & """useCancelPoint"":" & mUseCancelPoint

		If mCardNo <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """cardNo"":""" & mCardNo & """"
		End If

		cResult = "{" & cResult & "}"
		toJson = cResult
	End Function
End Class
%>