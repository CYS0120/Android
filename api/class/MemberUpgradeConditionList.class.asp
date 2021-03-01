<%
'회원등급혜택조회 탭
Class clsMemberUpgradeConditionList
	Public mUpgradeQualificationCode, mUpgradeQualificationName, mUpgradeQualificationValue

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "upgradeQualificationCode") Then
			mUpgradeQualificationCode = obj.upgradeQualificationCode
		End If
		If JSON.hasKey(obj, "upgradeQualificationName") Then
			mUpgradeQualificationName = obj.upgradeQualificationName
		End If
		If JSON.hasKey(obj, "upgradeQualificationValue") Then
			mUpgradeQualificationValue = obj.upgradeQualificationValue
		End If
	End Function

	Private Sub Class_Initialize
		mUpgradeQualificationCode = ""
		mUpgradeQualificationName = ""
		mUpgradeQualificationValue = 0
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>