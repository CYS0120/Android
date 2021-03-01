<%
'주문멤버십사용 탭
Class clsPointUseList
	Public mAccountTypeCode, mUsePoint, mPointTradNo, mUseDate, mCardNo

	Public function Init(ByRef obj)
		If JSON.hasKey(obj, "accountTypeCode") Then
			mAccountTypeCode = obj.accountTypeCode
		End If
		If JSON.hasKey(obj, "usePoint") Then
			mUsePoint = obj.usePoint
		End If
		If JSON.hasKey(obj, "pointTradeNo") Then
			mPointTradNo = obj.pointTradNo
		End If
		If JSON.hasKey(obj, "useDate") Then
			mUseDate = obj.useDate
		End If
		If JSON.hasKey(obj, "cardNo") Then
			mCardNo = obj.cardNo
		End If
	End function

	Private Sub Class_Initialize
		mAccountTypeCode = ""
		mUsePoint = 0
		mPointTradNo = ""
		mUseDate = ""
		mCardNo = ""
	End Sub

	Private Sub Class_Terminate
	End Sub

	Public Function toJson
		cResult = ""

		If cResult <> "" Then cResult = cResult & ","
		cResult = cResult & """accountTypeCode"":""" & mAccountTypeCode & """"

		If cResult <> "" Then cResult = cResult & ","
		cResult = cResult & """usePoint"":" & mUsePoint

		If cResult <> "" Then cResult = cResult & ","
		cResult = cResult & """pointTradeNo"":""" & mPointTradNo & """"

		If cResult <> "" Then cResult = cResult & ","
		cResult = cResult & """useDate"":""" & mUseDate & """"

		If cResult <> "" Then cResult = cResult & ","
		cResult = cResult & """cardNo"":""" & mCardNo & """"

		cResult = "{" & cResult & "}"

		toJson = cResult
	End Function
End Class
%>