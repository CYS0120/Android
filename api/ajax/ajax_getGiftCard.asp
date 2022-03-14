<!--#include virtual="/api/include/utf8.asp"-->
<!--#include virtual="/api/include/ktr_exchange_proc.asp"-->
<!--#include virtual="/api/include/aspJSON1.18.asp"-->
<%
	Dim mmidno, GiftPrice, callMode, Gc_List, Giftcard_list
'req mode [ insert 상품권 코드 입력(등록) , list 상품권 리스트 조회 , listCount 상품권갯수 조회 ] 
    callMode = GetReqStr("callMode","")
'req mode 끝
'회원 IDno 가져오기
    If Session("userIdNo") <> "" Then
        mmidno = Session("userIdNo")
    Else
        mmidno = "P"&Session.sessionid
        Response.Write "{""result"":5,""message"":""회원정보를 잃었습니다. 다시 로그인 시도하여 주시기 바랍니다.""}"
        response.end
    End If
'회원 IDno 가져오기 꿑

'상품권 코드 입력(등록)
    If callMode = "insert" Then
        Dim httpRequest

        giftPIN = GetReqStr("giftPIN","") ' 상품권 시리얼 값 판단
    
	    ' 2021-07 더페이 상품권 주석 처리 시작
        'Set httpRequest = Server.CreateObject("MSXML2.ServerXMLHTTP")
        'httpRequest.Open "GET", "http://api.bbq.co.kr/GiftCard_2.svc/GetGiftCard/"& giftPIN, False
        'httpRequest.SetRequestHeader "AUTH_KEY", "BF84B3C90590"
        'httpRequest.SetRequestHeader "Content-Type", "application/x-www-form-urlencoded"
        'httpRequest.Send
        ''Response.Write httpRequest.responseText
        '
        ''# postResponse Values
        ''ACT_TP ::처리구분
        ''AMT : 금액
        ''FROM_DATE ::발행일자
        ''OK_NUM ::승인번호(조회시 사용안함)
        ''RTN_CD ::결과코드
        ''RTN_MSG : 결과내용
        ''SEQ ::상품권 일련번호
        ''SN ::상품권 번호
        ''ST_CONFIRM ::확정여부
        ''TO_DATE ::종료일자
        ''U_CD_BRAND ::사용브랜드코드
        ''U_CD_PARTNER ::사용매장코드
        ''U_DATE ::사용일자
        ''U_NM_PARTNER : 사용매장명
        ''U_YN ::교환여부
        '
        'Set oJSON = New aspJSON
        'postResponse = "{""list"" : " & httpRequest.responseText & "}"
        'oJSON.loadJSON(postResponse)
        'Set this = oJSON.data("list")
        '
        '
        ''Response.Write "<script language='javascript'>alert('" & postResponse & "');</script>"
        '
	    'GiftPrice = this.item("AMT") '상품권 가격
        'From_date = this.item("FROM_DATE") ' 상품권 발행일자
        'To_date = this.item("TO_DATE") ' 상품권 종료일자
        'Gift_SEQ = this.item("SEQ") ' 상품권 일련번호
        'U_YN = this.item("U_YN") ' 상품권 교환여부
        '
        '
        'CountQuery = " SELECT COUNT(*) as cnt FROM bt_giftcard WHERE used_date is null AND giftcard_number = '"& giftPIN &"'"
        'Set Gift_Count = dbconn.Execute(CountQuery)
        'Gift_Count.movefirst
        '
        '
        'If Gift_Count("cnt") > 0 Then
        '    Response.Write "{""result"":""1""}" ' 이미 등록 된 상품권입니다.
        'ElseIf Gift_SEQ = 0 Then
        '    Response.Write "{""result"":""2""}" ' 존재하지않는 상품권입니다.
        'ElseIf U_YN <> "N"  Then
        '    Response.Write "{""result"":""3""}" ' 이미 사용한 상품권입니다.
        'Else
        '
        'Sql = "Insert Into bt_giftcard(giftcard_number, giftcard_amt, member_id, publish_date, usedate_from, usedate_to) values('"& giftPIN &"','"& GiftPrice &"','"& mmidno &"',SYSDATETIME(),'"& From_date &"','"& To_date &"')"
        'dbconn.Execute(Sql)
        'Response.Write "{""result"":0,""giftPIN"":""" & giftPIN &"""}"
        '
        'End If

	    ' 2021-07 더페이 상품권 주석 처리 끝 
		
	    ' 2021-07 더페이 상품권 시작    
	    dim jsonGiftcard : jsonGiftcard = ""
    
		jsonGiftcard = "{ ""SRV"":""HOMEPAGE"",""GIFTCARD"":["
	    jsonGiftcard = jsonGiftcard & "{""SN"":""" & giftPIN & """}"
        jsonGiftcard = jsonGiftcard & "]}"	
     
		Set httpRequest = Server.CreateObject("MSXML2.ServerXMLHTTP.6.0")  '(2022.2.25 변경) CreateObject("MSXML2.ServerXMLHTTP")

		httpRequest.Open "POST", "http://api-2.bbq.co.kr/api/VoucherInfo/", False
		httpRequest.SetRequestHeader "Authorization", "BF84B3C90590"  
		httpRequest.SetRequestHeader "Content-Type", "application/json"
        httpRequest.Send jsonGiftcard 
        'Response.Write httpRequest.responseText

        '# postResponse Values
        'ACT_TP ::처리구분
        'AMT : 금액
        'FROM_DATE ::발행일자
        'OK_NUM ::승인번호(조회시 사용안함)
        'RTN_CD ::결과코드
        'RTN_MSG : 결과내용
        'SEQ ::상품권 일련번호
        'SN ::상품권 번호
        'ST_CONFIRM ::확정여부
        'TO_DATE ::종료일자
        'U_CD_BRAND ::사용브랜드코드
        'U_CD_PARTNER ::사용매장코드
        'U_DATE ::사용일자
        'U_NM_PARTNER : 사용매장명
        'U_YN ::교환여부
      
		Set oJSON = New aspJSON 
		postResponse = "{""list"" : " & httpRequest.responseText & "}"
        Set httpRequest = Nothing
		oJSON.loadJSON(postResponse)
		Set this = oJSON.data("list")
     
		Sql = " INSERT INTO bt_giftcard_log(source_id, order_num, giftcard_no, api_nm, in_param, out_param, MA_RTN_CD, MA_RTN_MSG, regdate) "_
			& " VALUES ( '\api\ajax\ajax_getGiftCard.asp', '"& "" &"','"& giftPIN &"','http://api-2.bbq.co.kr/api/VoucherInfo/', '"& jsonGiftcard &"','"& postResponse &"','','', GETDATE() ) "
		dbconn.Execute(Sql)

        If this.Exists("Voucher_INFO") Then 'item 여부 확인 
            For Each row In this.item("Voucher_INFO").item("data")
                Set this1 = this.item("Voucher_INFO").item("data").item(row) 
                            
                GiftPrice = this1.item("AMT")       ' 상품권 가격
                From_date = this1.item("FROM_DATE") ' 상품권 발행일자
                To_date   = this1.item("TO_DATE")   ' 상품권 종료일자
                Gift_SEQ  = this1.item("SEQ")       ' 상품권 일련번호
                U_YN      = this1.item("U_YN")      ' 상품권 교환여부
        
                'CountQuery = " SELECT COUNT(*) as cnt FROM bt_giftcard WHERE used_date is null AND giftcard_number = '"& giftPIN &"'"
                CountQuery = " SELECT COUNT(*) as cnt FROM bt_giftcard WITH(NOLOCK) WHERE giftcard_number = '"& giftPIN &"'"
                Set Gift_Count = dbconn.Execute(CountQuery)
                Gift_Count.movefirst
        

                If U_YN <> "N"  Then
                    Response.Write "{""result"":""3""}" ' 이미 사용한 상품권입니다.
                ElseIf Gift_Count("cnt") > 0 Then
                    Response.Write "{""result"":""1""}" ' 이미 등록 된 상품권입니다.
                ElseIf Gift_SEQ = 0 Then
                    Response.Write "{""result"":""2""}" ' 존재하지않는 상품권입니다.
                Else 
                    Sql = "Insert Into bt_giftcard(giftcard_number, giftcard_amt, member_id, publish_date, usedate_from, usedate_to) values('"& giftPIN &"','"& GiftPrice &"','"& mmidno &"',SYSDATETIME(),'"& From_date &"','"& To_date &"')"
                    dbconn.Execute(Sql)
                    Response.Write "{""result"":0,""giftPIN"":""" & giftPIN &"""}" 
                End If 
		    Next
        Else
            Response.Write "{""result"":""4"", ""message"":""상품권 조회 중 오류 발생. 잠시 후 다시 시도하시기 바랍니다.""}" ' 오류 발생
        End If 
	    ' 2021-07 더페이 상품권 끝 
        
    End If
'상품권 코드 입력(등록) 끝

'상품권 조회 
    If callMode = "Select" Then
        giftPIN = GetReqStr("giftPIN","")
        sql = " SELECT giftcard_idx,giftcard_number,giftcard_amt FROM bt_giftcard WITH(NOLOCK) WHERE member_id = '"& mmidno &"' AND giftcard_number = '"& giftPIN &"'"
        Set Gc = dbconn.Execute(sql)
        If Not (Gc.BOF Or Gc.EOF) Then
            Gc.movefirst
            Giftcard = "["
                Do Until Gc.EOF
                    If Giftcard <> "[" Then Giftcard = Giftcard & "," End If
                    Giftcard = Giftcard & "{"
                    Giftcard = Giftcard & """giftcard_idx"":""" & Gc("giftcard_idx") & ""","
                    Giftcard = Giftcard & """giftcard_number"":""" & Gc("giftcard_number") & ""","
                    Giftcard = Giftcard & """giftcard_amt"":""" & Gc("giftcard_amt") & """"
                    Giftcard = Giftcard & "}"
                    Gc.MoveNext
                LOOP
            Giftcard = Giftcard & "]"
            Response.Write "{""result"":0,""Count"":" & Giftcard &"}"
        End If
    End If
'상품권 조회 끝

'상품권 갯수 조회 
    If callMode = "listCount" Then
        sql = " SELECT COUNT(*) as cnt FROM bt_giftcard WITH(NOLOCK) WHERE member_id = '"& mmidno &"' AND USED_DATE IS NULL AND CONVERT(VARCHAR(8), GETDATE(), 112) BETWEEN USEDATE_FROM AND USEDATE_TO"

        Set Gc_List = dbconn.Execute(sql)
        Gc_list.movefirst
        Response.Write "{""result"":0,""Count"":""" & Gc_List("cnt") &"""}"
        'Response.Write "{""result"":0,""Count"":""" & sql &"""}"
    End If
'상품권 갯수 조회 끝

'상품권 리스트 조회
    If callMode = "list" Then
        sql = " SELECT giftcard_idx,giftcard_number,giftcard_amt,member_id,order_num,used_date,usedate_from,usedate_to,publish_date FROM bt_giftcard WITH(NOLOCK) WHERE member_id = '"& mmidno &"' AND USED_DATE IS NULL AND CONVERT(VARCHAR(8), GETDATE(), 112) BETWEEN USEDATE_FROM AND USEDATE_TO "
        Set Gc_List = dbconn.Execute(sql)
        If Not (Gc_list.BOF Or Gc_list.EOF) Then
            Gc_list.movefirst
            Giftcard_list = "["
            Do Until Gc_list.EOF
                If Giftcard_list <> "[" Then Giftcard_list = Giftcard_list & "," End If
                Giftcard_list = Giftcard_list & "{"
                Giftcard_list = Giftcard_list & """giftcard_idx"":""" & Gc_list("giftcard_idx") & ""","
                Giftcard_list = Giftcard_list & """giftcard_number"":""" & Gc_list("giftcard_number") & ""","
                Giftcard_list = Giftcard_list & """giftcard_amt"":""" & Gc_list("giftcard_amt") & ""","
                Giftcard_list = Giftcard_list & """member_id"":""" & Gc_list("member_id") & ""","
                Giftcard_list = Giftcard_list & """order_num"":""" & Gc_list("order_num") & ""","
                Giftcard_list = Giftcard_list & """used_date"":""" & Gc_list("used_date") & ""","
                Giftcard_list = Giftcard_list & """usedate_from"":""" & Gc_list("usedate_from") & ""","
                Giftcard_list = Giftcard_list & """usedate_to"":""" & Gc_list("usedate_to") & ""","
                Giftcard_list = Giftcard_list & """publish_date"":""" & Gc_list("publish_date") & """"
                Giftcard_list = Giftcard_list & "}"
                Gc_List.MoveNext
            LOOP
            Giftcard_list = Giftcard_list & "]"
            Response.Write "{""result"":0,""Count"":" & Giftcard_list &"}"
        Else
            Response.Write "{""result"":""1""}" ' 상품권이 없습니다.
        End If
        
    End If
'상품권 리스트 조회 끝

'상품권 사용처리
If callMode = "use" Then
    serial = GetReqStr("serial","")
    Response.Write serial
    Sql = "UPDATE bt_giftcard SET used_date = GETDATE() WHERE member_id = '"& mmidno &"' AND giftcard_number = '"& serial &"'"
    dbconn.Execute(Sql)
    Response.Write "{""result"":0,""giftPIN"":""" & giftPIN &"""}"
End If

'상품권 사용처리

'상품권 선물 대상 조회
If callMode = "search" Then
    userid = GetReqStr("userid","")
    sql = " SELECT member_id as member,member_idno as member_idno FROM bt_member WITH(NOLOCK) WHERE member_id = '"& userid &"'"
    Set User = dbconn.Execute(sql)

    'Response.Write User("member_idno")

    If Not (User.BOF Or User.EOF) Then
		Response.Write "{""result"":0,""user_id"":""" & User("member") &""",""user_idno"":"""& User("member_idno") &"""}"
    Else
        Response.Write "{""result"":""1""}"
    end If
End If
'상품권 선물 대상 조회

'상품권 선물 처리
If callMode = "present" Then
    userid = GetReqStr("userid","")
    useridno = GetReqStr("useridno","")
    idx = GetReqStr("idx","")
    Sql = "UPDATE bt_giftcard SET member_id = '"& useridno &"' WHERE giftcard_idx = '"& idx &"'"
    dbconn.Execute(Sql)
    Response.Write "{""result"":0,""user_id"":""" & userid &"""}"
End If
'상품권 선물 처리

'지급쿠폰 조회

If callMode = "productCoupon" Then
    giftProductCode = GetReqStr("giftProductCode","")
    sql = " SELECT menu_price as m_price FROM bt_menu WITH(NOLOCK) WHERE menu_idx = '"& giftProductCode &"'"
    Set Product = dbconn.Execute(Sql)
    If Not (Product.BOF Or Product.EOF) Then
        Response.Write "{""result"":0,""price"":""" & Product("m_price") &"""}"
    end If
End If

'지급쿠폰 조회

'지급품목 조회
If callMode = "productSearch" Then
    giftProductCode = GetReqStr("giftProductCode","")
    sql = " SELECT menu_name as m_name, menu_price as m_price, (SELECT file_name FROM bt_menu_file WITH(NOLOCK) where menu_idx = '"& giftProductCode &"' AND file_type = 'THUMB') as m_file FROM bt_menu WITH(NOLOCK) WHERE menu_idx = '"& giftProductCode &"'"
    Set Product = dbconn.Execute(Sql)
    If Not (Product.BOF Or Product.EOF) Then
		Response.Write "{""result"":0,""name"":""" & Product("m_name") &""",""price"":"""& Product("m_price") &""",""file"":""" & Product("m_file") &"""}"
    end If
End If
'지급품목 조회

Call DBClose
%>