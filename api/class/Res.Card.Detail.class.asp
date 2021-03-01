<%
'카드상세조회
Class clsResCardDetail
	Public mCode, mMessage, mCardDetail

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "code") Then
			mCode = obj.code
		End If
		If JSON.hasKey(obj, "message") Then
			mMessage = obj.message
		End If

		If JSON.hasKey(obj, "result") Then
			Set mCardDetail = New clsCardDetail
			mCardDetail.Init(obj.result)
		End If
	End Function

	Private Sub Class_Initialize
		mCode = 0
		mMessage = ""
		mCardDetail = Null
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>