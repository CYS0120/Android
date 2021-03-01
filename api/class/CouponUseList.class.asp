<%
'주문멤버십사용 탭
Class clsCouponUseList
	Public mCouponNo, mUseDate

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "couponNo") Then
			mCouponNo = obj.couponNo
		End If
		If JSON.hasKey(obj, "useDate") Then
			mUseDate = obj.useDate
		End If
	End Function

	Private Sub Class_Initialize
		mCouponNo = ""
		mUseDate = ""
	End Sub

	Private Sub Class_Terminate
	End Sub

	Public Function toJson
		cResult = ""

		If cResult <> "" Then cResult = cResult & ","
		cResult = cResult & """couponNo"":""" & mCouponNo & """"

		If cResult <> "" Then cResult = cResult & ","
		cResult = cResult & """useDate"":""" & mUseDate & """"

		cResult = "{" & cResult & "}"

		toJson = cResult
	End Function
End Class
%>