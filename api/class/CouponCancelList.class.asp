<%
'주문멤버십사용취소 탭
Class clsCouponCancelList
	Public mCouponNo, mCancelDate

	Public function Init(ByRef obj)
		If JSON.hasKey(obj, "couponNo") Then
			mCouponNo = obj.couponNo
		End If
		If JSON.hasKey(obj, "cancelDate") Then
			mCancelDate = obj.cancelDate
		End If
	End Function

	Private Sub Class_Initialize
		mCouponNo = ""
		mCancelDate = ""
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>