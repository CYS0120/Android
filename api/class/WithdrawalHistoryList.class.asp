<%
'회원탈퇴내역조회 탭
Class clsWithdrawalHistoryList
	Public mSequence, mIdNo, mIp, mJoinYmdt, mJoinChannel, mJoinDetailChannel, mChannel, mRegistrant, mRegistrationYmdt, m_Id

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "sequence") Then
			mSequence = obj.sequence
		End If
		If JSON.hasKey(obj, "idNo") Then
			mIdNo = obj.idNo
		End If
		If JSON.hasKey(obj, "ip") Then
			mIp = obj.ip
		End If
		If JSON.hasKey(obj, "joinYmdt") Then
			mJoinYmdt = obj.joinYmdt
		End If
		If JSON.hasKey(obj, "joinChannel") Then
			mJoinChannel = obj.joinChannel
		End If
		If JSON.hasKey(obj, "joinDetailChannel") Then
			mJoinDetailChannel = obj.joinDetailChannel
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
		If JSON.hasKey(obj, "id") Then
			m_Id = obj.id
		End If
	End Function

	Private Sub Class_Initialize
		mSequence = 0
		mIdNo = ""
		mIp = ""
		mJoinYmdt = ""
		mJoinChannel = ""
		mJoinDetailChannel = ""
		mChannel = ""
		mRegistrant = ""
		mRegistrationYmdt = ""
		m_Id = ""
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>