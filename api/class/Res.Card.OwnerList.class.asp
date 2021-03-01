<%
'보유카드조회
Class clsResCardOwnerList
	Public mCode, mMessage, mCardDetail

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "code") Then
			mCode = obj.code
		End If
		If JSON.hasKey(obj, "message") Then
			mMessage = obj.message
		End If
		If JSON.hasKey(obj, "result") Then
			ReDim mCardDetail(obj.result.length-1)
			For i = 0 To obj.result.length-1
				Dim tmpCardDetail : Set tmpCardDetail = New clsCardDetail
				tmpCardDetail.Init(obj.result.get(i))
				Set mCardDetail(i) = tmpCardDetail
			Next
		End If
	End Function

	Private Sub Class_Initialize
		mCode = 0
		mMessage = ""
		mCardDetail = Array()
	End Sub

	Private Sub Class_Terminate
	End Sub

	Public Function toJson
		result = ""

		If result <> "" Then result = result & ","
		result = result & """code"":" & mCode

		If result <> "" Then result = result & ","
		result = result & """message"":" & mMessage & """"

		If UBound(mCardDetail) > -1 Then
			If result <> "" Then result = result & ","
			result = result & """cardDetail"":["

			For i = 0 To UBound(mCardDetail)
				If i > 0 Then result = result & ","

				result = result & mCardDetail(i).toJson()
			Next

			result = result & "]"

		End If

		result = "{" & result & "}"

		toJson = result
	End Function
End Class
%>