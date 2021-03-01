<%
'주문확정 탭
Class clsPointInfo
	Public mPointTradeNo, mAcmMinPayAmount, mPointAcmtDetailList

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "pointTradNo") Then
			mPointTradeNo = obj.pointTradNo
		End If
		If JSON.hasKey(obj, "acmMinPayAmount") Then
			mAcmMinPayAmount = obj.acmMinPayAmount
		End If

		'pointAcmDetailList
		If JSON.hasKey(obj, "pointAcmDetailList") Then
			ReDim mPointAcmtDetailList(obj.pointAcmDetailList.length - 1)
			For i = 0 To obj.pointAcmDetailList.length - 1
				Dim tmpPointAcmtDetailList : Set tmpPointAcmtDetailList = New clsPointAcmtDetailList
				tmpPointAcmtDetailList.Init(obj.pointAcmDetailList.get(i))
				Set mPointAcmtDetailList(i) = tmpPointAcmtDetailList
			Next
		End If
	End Function

	Private Sub Class_Initialize
		mPointTradeNo = ""
		mAcmMinPayAmount = 0
		mPointAcmtDetailList = Array()
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>