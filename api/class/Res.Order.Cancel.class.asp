<%
'주문취소
Class clsResOrderCancel
	Public mCode, mMessage

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "code") Then
			mCode = obj.code
		End If
		If JSON.hasKey(obj, "message") Then
			mMessage = obj.message
		End If
	End Function

	Private Sub Class_Initialize
		mCode = 0
		mMessage = ""
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>