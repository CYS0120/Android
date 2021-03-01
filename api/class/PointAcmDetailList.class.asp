<%
'주문확정 탭
Class clsPointAcmDetailList
	Public mProductCode, mPayMethodCode, mAcmDetailNo, mAcmAmount, mAcmRate

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "productCode") Then
			mProductCode = obj.productCode
		End If
		If JSON.hasKey(obj, "payMethodCode") Then
			mPayMethodCode = obj.payMethodCode
		End If
		If JSON.hasKey(obj, "acmDetailNo") Then
			mAcmDetailNo = obj.acmDetailNo
		End If
		If JSON.hasKey(obj, "acmAmount") Then
			mAcmAmount = obj.acmAmount
		End If
		If JSON.hasKey(obj, "acmRate") Then
			mAcmRate = obj.acmRate
		End If
	End Function

	Private Sub Class_Initialize
		mProductCode = ""
		mPayMethodCode = ""
		mAcmDetailNo = ""
		mAcmAmount = 0
		mAcmRate = 0
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>