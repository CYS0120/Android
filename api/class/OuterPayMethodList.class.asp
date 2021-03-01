<%
'주문완료 탭
Class clsOuterPayMethodList
	Public mCode, mPayAmount, mApprovalNo, mApprovalYmdt

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "code") Then
			mCode = obj.code
		End If
		If JSON.hasKey(obj, "payAmount") Then
			mPayAmount = obj.payAmount
		End If
		If JSON.hasKey(obj, "approvalNo") Then
			mApprovalNo = obj.approvalNo
		End If
		If JSON.hasKey(obj, "approvalYmdt") Then
			mApprovalYmdt = obj.approvalYmdt
		End If
	End Function

	Sub Class_Initialize
		mCode = ""
		mPayAmount = 0
		mApprovalNo = ""
		mApprovalYmdt = ""
	End Sub

	Sub Class_Terminate
	End Sub

	Function toJson
		cResult = ""

		If mCode <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """code"":""" & mCode & """"
		End If

		If cResult <> "" Then cResult = cResult & ","
		cResult = cResult & """payAmount"":" & mPayAmount

		If mApprovalNo <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """approvalNo"":""" & mApprovalNo & """"
		End If
		If mApprovalYmdt <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """approvalYmdt"":""" & mApprovalYmdt & """"
		End If

		cResult = "{" & cResult & "}"
		toJson = cResult
	End Function
End Class
%>