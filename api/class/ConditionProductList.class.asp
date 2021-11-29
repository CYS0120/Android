<%
'주문멤버십사용 탭
Class clsConditionProductList
	Public mConditionProductClassCode, mConditionProductClassName, mConditionProductCode, mConditionProductName

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "conditionProductClassCode") Then
			mConditionProductClassCode = obj.conditionProductClassCode
		End If
		If JSON.hasKey(obj, "conditionProductClassName") Then
			mConditionProductClassName = obj.conditionProductClassName
		End If
		If JSON.hasKey(obj, "conditionProductName") Then
			mConditionProductCode = obj.conditionProductName
		End If
		If JSON.hasKey(obj, "conditionProductName") Then
			mConditionProductName = obj.conditionProductName
		End If
	End Function

	Private Sub Class_Initialize
		mConditionProductClassCode = ""
		mConditionProductClassName = ""
		mConditionProductCode = ""
		mConditionProductName = ""
	End Sub

	Private Sub Class_Terminate
	End Sub

	Public Function toJson
		cResult = ""

		If cResult <> "" Then cResult = cResult & ","
		cResult = cResult & """conditionProductClassCode"":""" & mConditionProductClassCode & """"

		If cResult <> "" Then cResult = cResult & ","
		cResult = cResult & """conditionProductClassName"":""" & mConditionProductClassName & """"

		If cResult <> "" Then cResult = cResult & ","
		cResult = cResult & """conditionProductName"":""" & mConditionProductCode & """"

		If cResult <> "" Then cResult = cResult & ","
		cResult = cResult & """conditionProductName"":""" & mConditionProductName & """"

		cResult = "{" & cResult & "}"

		toJson = cResult
	End Function
End Class
%>
