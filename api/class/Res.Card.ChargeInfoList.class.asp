<%
'카드충전내역목록조회
Class clsResCardChargeInfoList
	Public mCode, mMessage, mCardStatus, mCardPayPoint, mChargeInfoList

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "code") Then
			mCode = obj.code
		End If
		If JSON.hasKey(obj, "message") Then
			mMessage = obj.message
		End If
		If JSON.hasKey(obj, "result") Then
			If JSON.hasKey(obj.result, "cardStatus") Then
				mCardStatus = obj.result.cardStatus
			End If
			If JSON.hasKey(obj,result, "cardPayPoint") Then
				mCardPayPoint = obj.result.cardPayPoint
			End If
		End If

		'chargeInfoList
		If JSON.hasKey(obj.result, "chargeInfoList") Then
			ReDim mChargeInfoList(obj.result.chargeInfoList.length-1)
			For i=0 To obj.result.chargeInfoList.length-1
				Dim tmpChargeInfoList : Set tmpChargeInfoList = New clsChargeInfoList
				tmpChargeInfoList.Init(obj.result.chargeInfoList.get(i))
				Set mChargeInfoList(i) = tmpChargeInfoList
			Next
		End If
	End Function

	Private Sub Class_Initialize
		mCode = 0
		mMessage = ""
		mCardStatus = ""
		mCardPayPoint = 0
		mChargeInfoList = Array()
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>