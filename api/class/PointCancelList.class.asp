<%
'주문멤버십사용취소 탭
Class clsPointCancelList
	Public mAccountTypeCode, mUsePoint, mCancelDate, mCardNo

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "accountTypeCode") Then
			mAccountTypeCode = obj.accountTypeCode
		End If
		If JSON.hasKey(obj, "usePoint") Then
			mUsePoint = obj.usePoint
		End If
		If JSON.hasKey(obj, "cancelDate") Then
			mCancelDate = obj.cancelDate
		End If
		If JSON.hasKey(obj, "cardNo") Then
			mCardNo = obj.cardNo
		End If
	End Function

	Private Sub Class_Initialize
		mAccountTypeCode = ""
		mUsePoint = 0
		mCancelDate = ""
		mCardNo = ""
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>