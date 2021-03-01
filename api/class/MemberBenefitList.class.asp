<%
'회원등급혜택조회 탭
Class clsMemberBenefitList
	Public mCouponId, mCouponName, mIssueDay

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "couponId") Then
			mCouponId = obj.couponId
		End If
		If JSON.hasKey(obj, "couponName") Then
			mCouponName = obj.couponName
		End If
		If JSON.hasKey(obj, "issueDay") Then
			mIssueDay = obj.issueDay
		End If
	End Function

	Private Sub Class_Initialize
		mCouponId = ""
		mCouponName = ""
		mIssueDay = 0
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>