<!--#include virtual="/api/include/utf8.asp"-->
<%
'	REFERERURL	= Request.ServerVariables("HTTP_REFERER")
'	If left(REFERERURL,19) = left(GetCurrentHost,19) Then 
'	Else 
'		Response.Write "{""result"":""0001"",""message"":""검색된 매장이 없습니다.""}"
'		Response.End 
'	End If

    addrData = GetReqStr("data","")
    lat = GetReqStr("lat","0") ' Y
    lng = GetReqStr("lng","0") ' X

    BCODE=""
    Bunji1 = ""
    Bunji2 = ""

    ' Response.Write addrData
    If addrData <> "" Then
        '주소로 조회'
        Set addr = JSON.Parse(addrData)

        If addr.addr_type = "R" Then
            BCODE = "R" & addr.sigungu_code & addr.roadname_code
        Else
            BCODE = "B" & addr.b_code
        End If

        JStr = Split(addr.address_main," ")

        ' Response.Write UBound(JStr)
        BStr = JStr(UBound(JStr))

        ' Response.Write BStr
        ' JStr = JStr(Ubound(JStr))
        ' Response.Write JStr
        If InStr(BStr,"-") > 0 Then
            BStr = Split(BStr,"-")

            Bunji1 = BStr(0)
            Bunji2 = BStr(1)
        Else
            Bunji1 = BStr
        End If

		lat = addr.lat
		lng = addr.lng

		If lat = "" Then lat = "0" End If
		If lng = "" Then lng = "0" End If

        ' JStr = Split(addr.address_jibun," ")
        ' Response.Write UBound(JStr)
        ' JAddr = JStr(UBound(Jstr))

        ' If InStr(JAddr,"-") > 0 Then
        '     BStr = Split(JStr,"-")

        '     Bunji1 = BStr(0)
        '     Bunji2 = BStr(1)
        ' Else
        '     Bunji1 = JAddr
        ' End If
    End If

    ' response.write BCODE & " || " & Bunji1 & " || " & Bunji2 & " || x:" & lng & " || y:" & lat  & "<br>"
    
    Function executeApi_map(method, reqcontent, data, url)
        Dim apiResult : apiResult = ""
        Set api = New ApiCall

        api.setMethod = method
        api.RequestContentType = reqcontent
        api.Authorization = "BF84B3C90590"
        api.SetData = data
        api.SetUrl = url

        apiResult = api.Run

        If Request.ServerVariables("SERVER_NAME") <> "localhost" Then
            PLog url, data, apiResult
        End If

        Set api = Nothing

        executeApi_map = apiResult
    End Function

    Function MapStore
        req_str = ""
        api_url = "https://api-2.bbq.co.kr/api/chaincheck/"
        result = ""
        If Request.ServerVariables("SERVER_NAME") = "localhost" Then
            result = "{""code"":200,""status"":true,""referedUrl"":null,""message"":""success"",""errorMessage"":null,""data"":[{""CD_BRAND"": ""01"",""CD_PARTNER"": ""7501401"",""NM_PARTNER"": ""방이스타점"",""NM_OWNER"": """",""NM_CLS_STORE"": ""올리브치킨"",""NO_TEL"": ""02-420-9198"",""NM_SV"": ""김태성"",""SV_TEL"": ""010-7495-2788"",""ST_STORE"": ""10"",""NM_ST_STORE"": ""정상"",""DIST"": ""528"",""STORE_AREA"": ""1"",""RLOGINYN"": ""Y"",""WEBINFO_OPENTIME"": ""0000"",""WEBINFO_CLOSETIME"": ""0000"",""COOKING_TIME"": ""30"",""CALLCENTER_MSG"": """",""TP_POS"": ""UNI"",""WGS84_X"": ""127.1098650"",""WGS84_Y"": ""37.5130280"",""ADDR"": ""서울특별시 송파구 오금로15길 16 (방이동) "",""ORDER_YN"": ""Y"",""COUPON_YN"": ""Y"",""DANAL_H_CPID"": ""9010049085"",""DELIVERY_FEE"": ""2000""}]}"
        Else
            Dim reqClass : Set reqClass = New clsReqMapStore
            reqClass.mBcode = BCODE
            reqClass.mBonbun = Bunji1
            reqClass.mBubun = Bunji2
            reqClass.mGx = lng
            reqClass.mGy = lat

            req_str = reqClass.toJson()

            result = executeApi_map ("POST", "application/json", req_str, api_url)

            ' Response.Write result & "<br><br>"
        End If

        Set oJson = JSON.Parse(result)
        ' Response.Write JSON.Parse(result) & "<br><br>"

        Dim resClass : Set resClass = New clsResMapStore
        resClass.Init(oJson)

        Set MapStore = resClass
    End Function

	Set pMapStore = MapStore


    If pMapStore.mCode = "400" Then
        xmlResult = "{""result"":""0001"",""message"":""근처에 배달 가능한 매장이 존재하지 않습니다.""}"
    Else
        xmlResult = ""
        
        ' 결과 코드 200(절대상권) / 201(배달상권) / 202(공백지) / 400(매장없음)
        If xmlResult <> "" Then xmlResult = xmlResult &"," End If
        xmlResult = xmlResult & """result"":""0000"""
        result_str = pMapStore.mCode
        ' 결과 메시지 success / fail
        If xmlResult <> "" Then xmlResult = xmlResult &"," End If
        xmlResult = xmlResult & """message"":""" & pMapStore.mMessage & """"
        result_msg_str = pMapStore.mMessage

        ' pMapStore.mDataList length만큼 Do Loop 돌리기
        i = 0
        Do While i < Ubound(pMapStore.mDataList) - Lbound(pMapStore.mDataList) + 1
            MemberShipCheck = "Y"
            Set node = pMapStore.mDataList(i)
            If Not node Is Nothing Then
                If xmlResult <> "" Then xmlResult = xmlResult &"," End If
                xmlResult = xmlResult & """branch_id"":""" & node.mCdPartner & """"

                '검색된 매장의 멤버쉽가입여부를 확인함
                Sql = "Select top 1 isnull(membership_yn_code, '50') as membership_yn_code from bt_branch Where branch_id='"& node.mCdPartner &"' "
                Set Binfo = dbconn.Execute(Sql)
                If Binfo.eof Then
                    MemberShipCheck = "N"
                Else
                    If Binfo("membership_yn_code") = 50 Then 
                    Else
                        MemberShipCheck = "N"
                    End If 
                End If 
            End If

            If Not node Is Nothing Then
                If xmlResult <> "" Then xmlResult = xmlResult &"," End If
                xmlResult = xmlResult & """brand_code"":""" & node.mCdBrand & """"
            End If
            If Not node Is Nothing Then
                If xmlResult <> "" Then xmlResult = xmlResult &"," End If
                xmlResult = xmlResult & """branch_name"":""" & node.mNmPartner & """"
            End If
            If Not node Is Nothing Then
                If xmlResult <> "" Then xmlResult = xmlResult &"," End If
                xmlResult = xmlResult & """branch_owner_name"":""" & node.mNmOwner & """"
            End If
            If Not node Is Nothing Then
                If xmlResult <> "" Then xmlResult = xmlResult &"," End If
                xmlResult = xmlResult & """branch_type"":""" & node.mNmClsStore & """"
            End If
            If Not node Is Nothing Then
                If xmlResult <> "" Then xmlResult = xmlResult &"," End If
                xmlResult = xmlResult & """branch_tel"":""" & node.mNoTel & """"
            End If
            ' mNmSv
            If Not node Is Nothing Then
                If xmlResult <> "" Then xmlResult = xmlResult &"," End If
                xmlResult = xmlResult & """branch_phone"":""" & node.mSvTel & """"
            End If
            If Not node Is Nothing Then
                If xmlResult <> "" Then xmlResult = xmlResult &"," End If
                xmlResult = xmlResult & """branch_status"":""" & node.mStStore & """"
            End If
            ' mNmStStore
            If Not node Is Nothing Then
                If xmlResult <> "" Then xmlResult = xmlResult &"," End If
                xmlResult = xmlResult & """dist"":" & node.mDist
            End If
            If Not node Is Nothing Then ' 1(절대) / 2(배달) / 3(공백)
                If xmlResult <> "" Then xmlResult = xmlResult &"," End If
                xmlResult = xmlResult & """STORE_AREA"":""" & node.mStoreArea & """"
            End If
            If Not node Is Nothing Then
                If xmlResult <> "" Then xmlResult = xmlResult &"," End If
                xmlResult = xmlResult & """online_status"":""" & node.mRloginYn & """"
            End If
            ' mWebinfoOpentime
            ' mWebinfoClosetime
            ' mCookingTime
            ' mCallcenterMsg
            ' mTpPos
            If Not node Is Nothing Then
                If xmlResult <> "" Then xmlResult = xmlResult &"," End If
                xmlResult = xmlResult & """wgs84_x"":" & node.mWgs84x
            End If
            If Not node Is Nothing Then
                If xmlResult <> "" Then xmlResult = xmlResult &"," End If
                xmlResult = xmlResult & """wgs84_y"":" & node.mWgs84y
            End If
            If Not node Is Nothing Then
                If xmlResult <> "" Then xmlResult = xmlResult &"," End If
                xmlResult = xmlResult & """branch_address"":""" & node.mAddr & """"
            End If
            If Not node Is Nothing Then
                If xmlResult <> "" Then xmlResult = xmlResult &"," End If
                xmlResult = xmlResult & """order_yn"":""" & node.mOrderYn & """"
            End If
            If Not node Is Nothing Then
                If xmlResult <> "" Then xmlResult = xmlResult &"," End If
                xmlResult = xmlResult & """coupon_yn"":""" & node.mCouponYn & """"
            End If
            ' mDanalHCpid
            ' mDeliveryFee

            Set node = Nothing
            i = i + 1
        Loop
        ' Loop 종료


        If MemberShipCheck = "N" Then
            xmlResult = "{""result"":""9000"",""message"":""고객님의 주소 상권 매장은 본사 멤버십 정책을 동의하지 않아 고객님께서 멤버십 혜택을 받으실 수 없습니다. 멤버십 혜택을 받으시려면 인근 매장에 포장 주문 해주시기 바랍니다.""}"
        Else 
            xmlResult = "{" & xmlResult & "}"
        End If 
        
    End If


    Response.Write xmlResult
    Call DBClose

%>