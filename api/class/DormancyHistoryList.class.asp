<%
'회원휴면내역조회 탭
Class clsDormancyHistoryList
	Public mSequence, mIdNo, mIp, mChannel, mRegistrant, mRegistrationYmdt, mType

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "sequence") Then
			mSequence = obj.sequence
		End If
		If JSON.hasKey(obj, "idNo")	 Then
			mIdNo = obj.idNo
		End If
		If JSON.hasKey(obj, "ip") Then
			mIp = obj.ip
		End If
		If JSON.hasKey(obj, "channel") Then
			mChannel = obj.channel
		End If
		If JSON.hasKey(obj, "registrant") Then
			mRegistrant = obj.registrant
		End If
		If JSON.hasKey(obj, "registrationYmdt") Then
			mRegistrationYmdt = obj.registrationYmdt
		End If
		If JSON.hasKey(obj, "type") Then
			mType = obj.type
		End If
	End Function

	Private Sub Class_Initialize
		mSequence = 0
		mIdNo = ""
		mIp = ""
		mChannel = ""
		mRegistrant = ""
		mRegistrationYmdt = ""
		mType = ""
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>