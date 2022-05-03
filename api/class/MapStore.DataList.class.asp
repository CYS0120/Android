<%
'회원등급혜택조회 탭
Class clsMapStoreDataList
	Public mCdBrand, mCdPartner, mNmPartner, mNmOwner, mNmClsStore, mNoTel, mNmSv, mSvTel, mStStore, mNmStStore, mDist, mStoreArea, mRloginYn, mWebinfoOpentime, mWebinfoClosetime, mCookingTime, mCallcenterMsg, mTpPos, mWgs84x, mWgs84y, mAddr, mOrderYn, mCouponYn, mDanalHCpid, mDeliveryFee

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "CD_BRAND") Then
			mCdBrand = obj.CD_BRAND
		End If
		If JSON.hasKey(obj, "CD_PARTNER") Then
			mCdPartner = obj.CD_PARTNER
		End If
		If JSON.hasKey(obj, "NM_PARTNER") Then
			mNmPartner = obj.NM_PARTNER
		End If
		If JSON.hasKey(obj, "NM_OWNER") Then
			mNmOwner = obj.NM_OWNER
		End If
		If JSON.hasKey(obj, "NM_CLS_STORE") Then
			mNmClsStore = obj.NM_CLS_STORE
		End If
		If JSON.hasKey(obj, "NO_TEL") Then
			mNoTel = obj.NO_TEL
		End If
		If JSON.hasKey(obj, "NM_SV") Then
			mNmSv = obj.NM_SV
		End If
		If JSON.hasKey(obj, "SV_TEL") Then
			mSvTel = obj.SV_TEL
		End If
		If JSON.hasKey(obj, "ST_STORE") Then
			mStStore = obj.ST_STORE
		End If
		If JSON.hasKey(obj, "NM_ST_STORE") Then
			mNmStStore = obj.NM_ST_STORE
		End If
		If JSON.hasKey(obj, "DIST") Then
			mDist = obj.DIST
		End If
		If JSON.hasKey(obj, "STORE_AREA") Then
			mStoreArea = obj.STORE_AREA
		End If
		If JSON.hasKey(obj, "RLOGINYN") Then
			mRloginYn = obj.RLOGINYN
		End If
		If JSON.hasKey(obj, "WEBINFO_OPENTIME") Then
			mWebinfoOpentime = obj.WEBINFO_OPENTIME
		End If
		If JSON.hasKey(obj, "WEBINFO_CLOSETIME") Then
			mWebinfoClosetime = obj.WEBINFO_CLOSETIME
		End If
		If JSON.hasKey(obj, "COOKING_TIME") Then
			mCookingTime = obj.COOKING_TIME
		End If
		If JSON.hasKey(obj, "CALLCENTER_MSG") Then
			mCallcenterMsg = obj.CALLCENTER_MSG
		End If
		If JSON.hasKey(obj, "TP_POS") Then
			mTpPos = obj.TP_POS
		End If
		If JSON.hasKey(obj, "WGS84_X") Then
			mWgs84x = obj.WGS84_X
		End If
		If JSON.hasKey(obj, "WGS84_Y") Then
			mWgs84y = obj.WGS84_Y
		End If
		If JSON.hasKey(obj, "ADDR") Then
			mAddr = obj.ADDR
		End If
		If JSON.hasKey(obj, "ORDER_YN") Then
			mOrderYn = obj.ORDER_YN
		End If
		If JSON.hasKey(obj, "COUPON_YN") Then
			mCouponYn = obj.COUPON_YN
		End If
		If JSON.hasKey(obj, "DANAL_H_CPID") Then
			mDanalHCpid = obj.DANAL_H_CPID
		End If
		If JSON.hasKey(obj, "DELIVERY_FEE") Then
			mDeliveryFee = obj.DELIVERY_FEE
		End If
	End Function

	Private Sub Class_Initialize
		mCdBrand = ""
		mCdPartner = ""
		mNmPartner = ""
		mNmOwner = ""
		mNmClsStore = ""
		mNoTel = ""
		mNmSv = ""
		mSvTel = ""
		mStStore = ""
		mNmStStore = ""
		mDist = 0
		mStoreArea = ""
		mRloginYn = ""
		mWebinfoOpentime = ""
		mWebinfoClosetime = ""
		mCookingTime = ""
		mCallcenterMsg = ""
		mTpPos = ""
		mWgs84x = ""
		mWgs84y = ""
		mAddr = ""
		mOrderYn = ""
		mCouponYn = ""
		mDanalHCpid = ""
		mDeliveryFee = 0
	End Sub

	Private Sub Class_Terminate
	End Sub
End Class
%>