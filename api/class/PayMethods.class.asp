<%
'카드충전내역목록조회 탭
'충전내역조회 탭
'카드충전 탭
'카드선물유효성체크 탭
'카드선물보내기 탭
Class clsPayMethods
	Public mPayMethodCode, mPayAmount, mPayApprovalNo

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "payMethodCode") Then
			mPayMethodCode = obj.payMethodCode
		End If
		If JSON.hasKey(obj, "payAmount") Then
			mPayAmount = obj.payAmount
		End If
		If JSON.hasKey(obj, "payApprovalNo") Then
			mPayApprovalNo = obj.payApprovalNo
		End If
	End Function

	Private Sub Class_Initialize
		mPayMethodCode = ""
		mPayAmount = 0
		mPayApprovalNo = ""
	End Sub

	Private Sub Class_Terminate
	End Sub

	Function toJson
		cResult = ""

		If mPayMethodCode <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """payMethodCode"":""" & mPayMethodCode & """"
		End If

		If cResult <> "" Then cResult = cResult & ","
		cResult = cResult & """payAmount"":" & mPayAmount

		If mPayApprovalNo <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """payApprovalNo"":""" & mPayApprovalNo & """"
		End If

		cResult = "{" & cResult & "}"
		toJson = cResult
	End Function
End Class
%>