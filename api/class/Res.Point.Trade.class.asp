<%
'포인트거래
Class clsResPointTrade
	Public mCode, mMessage, mQueryDate, mTrade

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "code") Then
			mCode = obj.code
		End If
		If JSON.hasKey(obj, "message") Then
			mMessage = obj.message
		End If
		If JSON.hasKey(obj, "result") Then
			If JSON.hasKey(obj.result, "queryDate") Then
				mQueryDate = obj.result.queryDate
			End If

			'trade
			If JSON.hasKey(obj.result, "trade") Then
				Set mTrade = New clsTrade
				mTrade.Init(obj.result.trade)
			End If
		End If
	End Function

	Function toJson
		Dim result : result = ""

		If mCardNo <> "" Then
			If result <> "" Then result = result & ","
			result = result & """code"":" & mCode
		End If
		If mMessage <> "" Then
			If result <> "" Then result = result & ","
			result = result & """message"":""" & mMessage & """"
		End If
		If mQueryDate <> "" Then
			If result <> "" Then result = result & ","
			result = result & """queryDate"":""" & mQueryDate & """"
		End If
		If IsObject(mTrade) Then
			If result <> "" Then result = result & ","
				result = result & """trade"":" & mTrade.toJson()
		End If

		result = "{" & result & "}"
		toJson = result
	End Function

	Private Sub Class_Initialize
		mCode = 0
		mMessage = ""
		mQueryDate = ""
		Set mTrade = New clsTrade
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>