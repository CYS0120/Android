<%
'카드잔액이전
Class clsResCardMovePoint
	Public mCode, mMessage, mMovedPoint

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "code") Then
			mCode = obj.code
		End If
		If JSON.hasKey(obj, "message") Then
			mMessage = obj.message
		End If
		If JSON.hasKey(obj, "result") Then
			If JSON.hasKey(obj.result, "movedPoint") Then
				mMovedPoint = obj.result.movedPoint
			End If
		End If
	End Function

	Private Sub Class_Initialize
		mCode = 0
		mMessage = ""
		mMovedPoint = 0
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>