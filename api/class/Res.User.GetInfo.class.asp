<%
'회원등급혜택조회
Class clsResUserGetInfo
	Public mCode, mMessage, mMemberGradeCode, mMemberGradeName, mMemberUpgradeConditionList, mMemberBenefitList, mPayAcmRateList

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "code") Then
			mCode = obj.code
		End If
		If JSON.hasKey(obj, "message") Then
			mMessage = obj.message
		End If
		If JSON.hasKey(obj, "result") Then
			If JSON.hasKey(obj.result, "memberGradeCode") Then
				mMemberGradeCode = obj.result.memberGradeCode
			End If
			If JSON.hasKey(obj.result, "memberGradeName") Then
				mMemberGradeName = obj.result.memberGradeName
			End If

			'memberUpgradeConditionList
			If JSON.hasKey(obj.result, "memberUpgradeConditionList") Then
				ReDim mMemberUpgradeConditionList(obj.result.memberUpgradeConditionList.length-1)
				For i=0 To obj.result.memberUpgradeConditionList.length-1
					Dim tmpMemberUpgradeConditionList : Set tmpMemberUpgradeConditionList = New clsMemberUpgradeConditionList
					tmpMemberUpgradeConditionList.Init(obj.result.memberUpgradeConditionList.get(i))
					Set mMemberUpgradeConditionList(i) = tmpMemberUpgradeConditionList
				Next
			End If

			'memberBenefitList
			If JSON.hasKey(obj.result, "memberBenefitList") Then
				ReDim mMemberBenefitList(obj.result.memberBenefitList.length-1)
				For i=0 To obj.result.memberBenefitList.length-1
					Dim tmpMemberBenefitList : Set tmpMemberBenefitList = New clsMemberBenefitList
					tmpMemberBenefitList.Init(obj.result.memberBenefitList.get(i))
					Set mMemberBenefitList(i) = tmpMemberBenefitList
				Next
			End If

			'payAcmRateList
			If JSON.hasKey(obj.result, "payAcmRateList") Then
				ReDim mPayAcmRateList(obj.result.payAcmRateList.length-1)
				For i=0 To obj.result.payAcmRateList.length-1
					Dim tmpPayAcmRateList : Set tmpPayAcmRateList = New clsPayAcmRateList
					tmpPayAcmRateList.Init(obj.result.payAcmRateList.get(i))
					Set mPayAcmRateList(i) = tmpPayAcmRateList
				Next
			End If
		End If
	End Function

	Private Sub Class_Initialize
		mCode = 0
		mMessage = ""
		mMemberGradeCode = ""
		mMemberGradeName = ""
		mMemberUpgradeConditionList = Array()
		mMemberBenefitList = Array()
		mPayAcmRateList = Array()
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>