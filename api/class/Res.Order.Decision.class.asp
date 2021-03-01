<%
'주문확정
Class clsResOrderDecision
	Public mCode, mMessage, mPointInfo
	
	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "code") Then
			mCode = obj.code
		End If
		If JSON.hasKey(obj, "message") Then
			mMessage = obj.message
		End If

		If JSON.hasKey(obj, "result") Then
			'PointInfo
			If JSON.hasKey(obj.result, "pointInfo") Then
				Set mPointInfo = New clsPointInfo
				mPointInfo.Init(obj.result.pointInfo)
			End If
		End If
	End Function

	Private Sub Class_Initialize
		mCode = 0
		mMessage = ""
		Set mPointInfo = New clsPointInfo
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>