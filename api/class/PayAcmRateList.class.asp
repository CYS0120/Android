<%
'회원등급혜택조회 탭
Class clsPayAcmRateList
	Public mPayMethodCode, mPayMethodName, mAcmRate

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "payMethodCode") Then
			mPayMethodCode = obj.payMethodCode
		End If
		If JSON.hasKey(obj, "payMethodName") Then
			mPayMethodName = obj.payMethodName
		End If
		If JSON.hasKey(obj, "acmRate") Then
			mAcmRate = obj.acmRate
		End If
	End Function

	Private Sub Class_Initialize
		mPayMethodCode = ""
		mPayMethodName = ""
		mAcmRate = 0
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>