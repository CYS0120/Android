<%
'주문완료
Class clsResOrderComplete
	Public mCode, mMessage, mOrderNo, mOrderDate

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "code") Then
			mCode = obj.code
		End If
		If JSON.hasKey(obj, "message") Then
			mMessage = obj.message
		End If
		If JSON.hasKey(obj, "result") Then
			If JSON.hasKey(obj.result, "orderNo") Then
				mOrderNo = obj.result.orderNo
			End If
			If JSON.hasKey(obj.result, "orderDate") Then
				mOrderDate = obj.result.orderDate
			End If
		End If
	End Function

	Private Sub Class_Initialize
		mCode = 0
		mMessage = ""
		mOrderNo = ""
		mOrderDate = ""
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>