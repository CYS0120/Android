<%
Class clsPointAcmtDetailList
	Public mProductCode, mPayMethodCode, mAcmDetailNo, mAcmAmount, mAcmRate

	Public Default Function Init(ByRef obj)
		mProductCode = obj.productCode
		mPayMethodCode = obj.payMethodCode
		mAcmDetailNo = obj.acmDetailNo
		mAcmAmount = obj.acmAmount
		mAcmRate = obj.acmRate
		
		Set Init = Me
	End Function

	Sub Class_Initialize
		mProductCode = ""
		mPayMethodCode = ""
		mAcmDetailNo = ""
		mAcmAmount = 0
		mAcmRate = 0
	End Sub

	Sub Class_Terminate
	End Sub
End Class
%>