<!--#include virtual="/api/include/utf8.asp"-->
<%
'	If GetReferer = GetCurrentHost Then  
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

    ' Response.Write Bunji1 & "----" & Bunji2

'    reqUrl = "http://wcf.genesiskorea.co.kr/CALLCENTER/FIND_STORE_v3.svc"
    reqUrl = "http://wcf.genesiskorea.co.kr/CALLCENTER/FIND_STORE_v4.svc"

    'reqData = "strKey=BF84B3C90590&strBCODE="&BCODE&"&strBUNJI_1="&Bunji1&"&strBUNJI_2="&Bunji2&"&fX="&lat&"&fY="&lng

    ' Set httpObj = Server.CreateObject("WinHttp.WinHttpRequest.5.1")
    ' httpObj.open "GET", reqUrl & "?" & reqData, False
    ' httpObj.Send()

    ' httpObj.WaitForResponse
    ' If httpObj.Status = "200" Then
    '     result = httpObj.ResponseText
    ' End if

    ' Response.Write result

    ' "<soapenv:Header/>"& _
    reqData = "<soapenv:Envelope xmlns:soapenv=""http://schemas.xmlsoap.org/soap/envelope/"" xmlns:tem=""http://tempuri.org/"">" &_
    "<soapenv:Body>"& _
    "<tem:Search_Partner_Key>"& _
    "<tem:strKey>BF84B3C90590</tem:strKey>" & _
    "<tem:strBCODE>"&BCODE&"</tem:strBCODE>" & _
    "<tem:strBUNJI_1>"&Bunji1&"</tem:strBUNJI_1>" & _
    "<tem:strBUNJI_2>"&Bunji2&"</tem:strBUNJI_2>" & _
    "<tem:fX>"&lng&"</tem:fX>" & _
    "<tem:fY>"&lat&"</tem:fY>" & _
    "</tem:Search_Partner_Key>" & _
    "</soapenv:Body>" & _
    "</soapenv:Envelope>"

    Set req = Server.CreateObject("MSXML2.ServerXMLHTTP")
    req.Open "POST", reqUrl, False
    req.SetRequestHeader "Content-Type", "text/xml; charset=utf-8"
    ' req.SetRequestHeader "Content-Type", "application/x-www-form-urlencoded"
    ' req.SetRequestHeader "SOAPAction", reqUrl&"/Search_Partner_Key"
'    req.SetRequestHeader "SOAPAction", "http://tempuri.org/IFIND_STORE_v3/Search_Partner_Key"
    req.SetRequestHeader "SOAPAction", "http://tempuri.org/IFIND_STORE_v4/Search_Partner_Key"
    req.Send reqData

    result = req.responseText

    ' Response.Write result

    Set xmlDom = Server.CreateObject("Microsoft.XMLDOM")

    xmlDom.async = False
    xmlDom.loadXml(result)

    Set searchResult = xmlDom.getElementsByTagName("Search_Partner_KeyResult")(0)

    ' Response.Write xmlDom.getElementsByTagName("a:RESULT").Length

    If searchResult.ChildNodes.length = 0 Then
        xmlResult = "{""result"":""0001"",""message"":""배달 가능한 매장이 존재하지 않습니다.""}"
    Else
        xmlResult = ""

		error_yn = False
		
        Set node = Nothing
        Set node = searchResult.getElementsByTagName("a:RESULT")
        If Not node Is Nothing Then
            If xmlResult <> "" Then xmlResult = xmlResult &","
            xmlResult = xmlResult & """result"":""" & node(0).text & """"
        End If
		If node(0) <> "0000" Then error_yn = True
		
		If Not error_yn Then
			Set node = Nothing
			Set node = searchResult.getElementsByTagName("a:RESULT_MSG")
			If Not node Is Nothing Then
				If xmlResult <> "" Then xmlResult = xmlResult &","
				xmlResult = xmlResult & """message"":""" & node(0).text & """"
			End If

			MemberShipCheck = "Y"
			Set node = searchResult.getElementsByTagName("a:CD_PARTNER")
			If Not node Is Nothing Then
				If xmlResult <> "" Then xmlResult = xmlResult &","
				xmlResult = xmlResult & """branch_id"":""" & node(0).text & """"

				'검색된 매장의 멤버쉽가입여부를 확인함
				Sql = "Select top 1 isnull(membership_yn_code, '50') as membership_yn_code from bt_branch Where branch_id='"& node(0).Text &"' "
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
			Set node = Nothing
			Set node = searchResult.getElementsByTagName("a:CD_BRAND")
			If Not node Is Nothing Then
				If xmlResult <> "" Then xmlResult = xmlResult &","
				xmlResult = xmlResult & """brand_code"":""" & node(0).text & """"
			End If
			Set node = Nothing
			Set node = searchResult.getElementsByTagName("a:NM_PARTNER")
			If Not node Is Nothing Then
				If xmlResult <> "" Then xmlResult = xmlResult &","
				xmlResult = xmlResult & """branch_name"":""" & node(0).text & """"
			End If
			Set node = Nothing
			Set node = searchResult.getElementsByTagName("a:NM_OWNER")
			If Not node Is Nothing Then
				If xmlResult <> "" Then xmlResult = xmlResult &","
				xmlResult = xmlResult & """branch_owner_name"":""" & node(0).text & """"
			End If
			Set node = Nothing
			Set node = searchResult.getElementsByTagName("a:SV_TEL")
			If Not node Is Nothing Then
				If xmlResult <> "" Then xmlResult = xmlResult &","
				xmlResult = xmlResult & """branch_phone"":""" & node(0).text & """"
			End If
			Set node = Nothing
			Set node = searchResult.getElementsByTagName("a:NO_TEL")
			If Not node Is Nothing Then
				If xmlResult <> "" Then xmlResult = xmlResult &","
				xmlResult = xmlResult & """branch_tel"":""" & node(0).text & """"
			End If
			Set node = Nothing
			Set node = searchResult.getElementsByTagName("a:ADDR")
			If Not node Is Nothing Then
				If xmlResult <> "" Then xmlResult = xmlResult &","
				xmlResult = xmlResult & """branch_address"":""" & node(0).text & """"
			End If
			Set node = Nothing
			Set node = searchResult.getElementsByTagName("a:NM_CLS_STORE")
			If Not node Is Nothing Then
				If xmlResult <> "" Then xmlResult = xmlResult &","
				xmlResult = xmlResult & """branch_type"":""" & node(0).text & """"
			End If
			Set node = Nothing
			Set node = searchResult.getElementsByTagName("a:ST_STORE")
			If Not node Is Nothing Then
				If xmlResult <> "" Then xmlResult = xmlResult &","
				xmlResult = xmlResult & """branch_status"":""" & node(0).text & """"
			End If
			Set node = Nothing
			Set node = searchResult.getElementsByTagName("a:LOC_X")
			If Not node Is Nothing Then
				If xmlResult <> "" Then xmlResult = xmlResult &","
				xmlResult = xmlResult & """wgs84_x"":" & node(0).text
			End If
			Set node = Nothing
			Set node = searchResult.getElementsByTagName("a:LOC_Y")
			If Not node Is Nothing Then
				If xmlResult <> "" Then xmlResult = xmlResult &","
				xmlResult = xmlResult & """wgs84_y"":" & node(0).text
			End If
			Set node = Nothing
			Set node = searchResult.getElementsByTagName("a:RLOGINYN")
			If Not node Is Nothing Then
				If xmlResult <> "" Then xmlResult = xmlResult &","
				xmlResult = xmlResult & """online_status"":""" & node(0).text & """"
			End If
			Set node = Nothing
			Set node = searchResult.getElementsByTagName("a:ORDER_YN")
			If Not node Is Nothing Then
				If xmlResult <> "" Then xmlResult = xmlResult &","
				xmlResult = xmlResult & """order_yn"":""" & node(0).text & """"
			End If
			Set node = Nothing
			Set node = searchResult.getElementsByTagName("a:COUPON_YN")
			If Not node Is Nothing Then
				If xmlResult <> "" Then xmlResult = xmlResult &","
				xmlResult = xmlResult & """coupon_yn"":""" & node(0).text & """"
			End If

			' Payco 간편결제 가맹점 정보
			'Set node = Nothing
			'Set node = searchResult.getElementsByTagName("a:PAYCO_SELLER")
			'If Not node Is Nothing Then
			'    If xmlResult <> "" Then xmlResult = xmlResult &","
			'    xmlResult = xmlResult & """payco_seller"":""" & node(0).text & """"
			'End If
			'Set node = Nothing
			'Set node = searchResult.getElementsByTagName("a:PAYCO_CPID")
			'If Not node Is Nothing Then
			'    If xmlResult <> "" Then xmlResult = xmlResult &","
			'    xmlResult = xmlResult & """payco_cpid"":""" & node(0).text & """"
			'End If
			'Set node = Nothing
			'Set node = searchResult.getElementsByTagName("a:PAYCO_ITEMCD")
			'If Not node Is Nothing Then
			'    If xmlResult <> "" Then xmlResult = xmlResult &","
			'    xmlResult = xmlResult & """payco_itemcd"":""" & node(0).text & """"
			'End If
		Else
			xmlResult = "{""result"":""0001"",""message"":""배달 가능한 매장이 존재하지 않습니다.""}"
		End If

        ' Set searchResult = searchResult.ChildNodes(0)
        ' For i = 0 To searchResult.ChildNodes.length -1
        '     If xmlResult <> "" Then xmlResult = xmlResult &","
        '     ' Response.Write Replace(searchResult.ChildNodes(i).NodeName,"a:","")
        '     ' Response.Write searchResult.ChildNodes(i).Text
        '     xmlResult = xmlResult & """" & Replace(searchResult.ChildNodes(i).NodeName,"a:","") & """:""" & searchResult.ChildNodes(i).Text & """"
        '     searchResult.ChildNodes[i]
        ' Next



        ' If xmlDom.getElementsByTagName("a:CD_BRAND")(0).text <> "" Then
        '     If xmlResult <> "" Then xmlResult = xmlResult &","
        '     xmlResult = xmlResult & """CD_BRAND"":""" &xmlDom.getElementsByTagName("a:CD_BRAND")(0).text & """"
        ' End If
        ' If xmlDom.getElementsByTagName("a:CD_PARTNER")(0).text <> "" Then
        '     If xmlResult <> "" Then xmlResult = xmlResult &","
        '     xmlResult = xmlResult & """CD_PARTNER"":""" &xmlDom.getElementsByTagName("a:CD_PARTNER")(0).text & """"
        ' End If
        ' If xmlDom.getElementsByTagName("a:NM_PARTNER")(0).text <> "" Then
        '     If xmlResult <> "" Then xmlResult = xmlResult &","
        '     xmlResult = xmlResult & """NM_PARTNER"":""" &xmlDom.getElementsByTagName("a:NM_PARTNER")(0).text & """"
        ' End If
        ' If xmlDom.getElementsByTagName("a:NM_OWNER")(0).text <> "" Then
        '     If xmlResult <> "" Then xmlResult = xmlResult &","
        '     xmlResult = xmlResult & """NM_OWNER"":""" &xmlDom.getElementsByTagName("a:NM_OWNER")(0).text & """"
        ' End If
        ' If xmlDom.getElementsByTagName("a:NM_CLS_STORE")(0).text <> "" Then
        '     If xmlResult <> "" Then xmlResult = xmlResult &","
        '     xmlResult = xmlResult & """NM_CLS_STORE"":""" &xmlDom.getElementsByTagName("a:NM_CLS_STORE")(0).text & """"
        ' End If
        ' If xmlDom.getElementsByTagName("a:NO_TEL")(0).text <> "" Then
        '     If xmlResult <> "" Then xmlResult = xmlResult &","
        '     xmlResult = xmlResult & """NO_TEL"":""" &xmlDom.getElementsByTagName("a:NO_TEL")(0).text & """"
        ' End If
        ' If xmlDom.getElementsByTagName("a:NM_SV")(0).text <> "" Then
        '     If xmlResult <> "" Then xmlResult = xmlResult &","
        '     xmlResult = xmlResult & """NM_SV"":""" &xmlDom.getElementsByTagName("a:NM_SV")(0).text & """"
        ' End If
        ' If xmlDom.getElementsByTagName("a:ST_STORE")(0).text <> "" Then
        '     If xmlResult <> "" Then xmlResult = xmlResult &","
        '     xmlResult = xmlResult & """ST_STORE"":""" &xmlDom.getElementsByTagName("a:ST_STORE")(0).text & """"
        ' End If
        ' If xmlDom.getElementsByTagName("a:NM_ST_STORE")(0).text <> "" Then
        '     If xmlResult <> "" Then xmlResult = xmlResult &","
        '     xmlResult = xmlResult & """NM_ST_STORE"":""" &xmlDom.getElementsByTagName("a:NM_ST_STORE")(0).text & """"
        ' End If
        ' If xmlDom.getElementsByTagName("a:RLOGINYN")(0).text <> "" Then
        '     If xmlResult <> "" Then xmlResult = xmlResult &","
        '     xmlResult = xmlResult & """RLOGINYN"":""" &xmlDom.getElementsByTagName("a:RLOGINYN")(0).text & """"
        ' End If
        ' If xmlDom.getElementsByTagName("a:DIST")(0).text <> "" Then
        '     If xmlResult <> "" Then xmlResult = xmlResult &","
        '     xmlResult = xmlResult & """DIST"":""" &xmlDom.getElementsByTagName("a:DIST")(0).text & """"
        ' End If
        ' If xmlDom.getElementsByTagName("a:STORE_AREA")(0).text <> "" Then
        '     If xmlResult <> "" Then xmlResult = xmlResult &","
        '     xmlResult = xmlResult & """STORE_AREA"":""" &xmlDom.getElementsByTagName("a:STORE_AREA")(0).text & """"
        ' End If
        ' If xmlDom.getElementsByTagName("a:TP_POS")(0).text <> "" Then
        '     If xmlResult <> "" Then xmlResult = xmlResult &","
        '     xmlResult = xmlResult & """TP_POS"":""" &xmlDom.getElementsByTagName("a:TP_POS")(0).text & """"
        ' End If
        ' If xmlDom.getElementsByTagName("a:LOC_X")(0).text <> "" Then
        '     If xmlResult <> "" Then xmlResult = xmlResult &","
        '     xmlResult = xmlResult & """LOC_X"":""" &xmlDom.getElementsByTagName("a:LOC_X")(0).text & """"
        ' End If
        ' If xmlDom.getElementsByTagName("a:LOC_Y")(0).text <> "" Then
        '     If xmlResult <> "" Then xmlResult = xmlResult &","
        '     xmlResult = xmlResult & """LOC_Y"":""" &xmlDom.getElementsByTagName("a:LOC_Y")(0).text & """"
        ' End If
        ' If xmlDom.getElementsByTagName("a:ADDR")(0).text <> "" Then
        '     If xmlResult <> "" Then xmlResult = xmlResult &","
        '     xmlResult = xmlResult & """ADDR"":""" &xmlDom.getElementsByTagName("a:ADDR")(0).text & """"
        ' End If
        ' If xmlDom.getElementsByTagName("a:ORDER_YN")(0).text <> "" Then
        '     If xmlResult <> "" Then xmlResult = xmlResult &","
        '     xmlResult = xmlResult & """ORDER_YN"":""" &xmlDom.getElementsByTagName("a:ORDER_YN")(0).text & """"
        ' End If
        ' If xmlDom.getElementsByTagName("a:COUPON_YN")(0).text <> "" Then
        '     If xmlResult <> "" Then xmlResult = xmlResult &","
        '     xmlResult = xmlResult & """COUPON_YN"":""" &xmlDom.getElementsByTagName("a:COUPON_YN")(0).text & """"
        ' End If
        ' If xmlDom.getElementsByTagName("a:RESULT")(0).text <> "" Then
        '     If xmlResult <> "" Then xmlResult = xmlResult &","
        '     xmlResult = xmlResult & """RESULT"":""" &xmlDom.getElementsByTagName("a:RESULT")(0).text & """"
        ' End If
        ' If xmlDom.getElementsByTagName("a:RESULT_MSG")(0).text <> "" Then
        '     If xmlResult <> "" Then xmlResult = xmlResult &","
        '     xmlResult = xmlResult & """RESULT_MSG"":""" &xmlDom.getElementsByTagName("a:RESULT_MSG")(0).text & """"
        ' End If

		If MemberShipCheck = "N" And Not error_yn Then
		    xmlResult = "{""result"":""9000"",""message"":""고객님의 주소 상권 매장은 본사 멤버십 정책을 동의하지 않아 고객님께서 멤버십 혜택을 받으실 수 없습니다. 멤버십 혜택을 받으시려면 인근 매장에 포장 주문 해주시기 바랍니다.""}"
		Else 
	        xmlResult = "{" & xmlResult & "}"
		End If 
    End If

    Response.Write xmlResult


    ' Dim sql : sql = "select top 1 * from bt_branch (nolock) where brand_code='01' and branch_status='10' and del_yn <> 'Y' and use_yn = 'Y' order by newid()"

    ' Dim cmd, rs

    ' set cmd = server.createobject("ADODB.Command")

    ' with cmd
    '     .activeconnection = dbconn
    '     .commandtype = adcmdtext
    '     .commandtext = sql

    '     set rs = .execute
    ' end with
    ' set cmd = nothing

    ' dim k

    ' if round((rnd * 1000),0) mod 10 > 3 then
    '     k = "Y"
    ' else
    '     k = "N"
    ' End if

    ' if not (rs.bof or rs.eof) then
    '     response.write rs("branch_name")&","&k&","&rs("branch_id")
    ' end if
%>