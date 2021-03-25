<!--#include virtual="/api/include/utf8.asp"-->
<!--#include virtual="/api/include/aspJSON1.18.asp"-->
<%
'유효스탬프 찾기
nowDate = Replace(Date(),"-","")
sql = " SELECT date_s as startYmd, date_e as endYmd FROM bt_event_mkt WHERE date_e >= "& nowDate &" AND date_s <= "& nowDate
Set Stamp = dbconn.Execute(Sql)
If Not (Stamp.BOF Or Stamp.EOF) Then
    startYmd = Stamp("startYmd") '스탬프 시작기간
    endYmd = Stamp("endYmd") '스탬프 종료기간
End If
'유효스탬프 찾기 끝

'스탬프 조회

    sql = "SELECT DISTINCT cust_id as userIdNo FROM BT_EVENT_MKT_COUPON WHERE USE_YN = 'Y'"
    Set bt_stamp = dbconn.Execute(sql)
        If Not (bt_stamp.BOF Or bt_stamp.EOF) Then
            bt_stamp.movefirst
            Do Until bt_stamp.EOF
            req_str = "{""companyCode"":""" & PAYCO_MEMBERSHIP_COMPANYCODE &""",""memberNo"":""" & bt_stamp("userIdNo") &""",""startYmd"":"&startYmd&",""endYmd"":"&endYmd&",""perPage"":""2"",""page"":""1""}"
            api_url = "/stamp/getHoldList"
            result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)
            'Response.Write req_str
            'Response.Write result
            Set oJSON = New aspJSON
            oJSON.loadJSON(result)
            Set this = oJSON.data("result")
            For Each row In this.item("holdList")
            Set this1 = this.item("holdList").item(row)
            Next
        '스탬프 조회 끝

        '스탬프 비교
            CountQuery = " SELECT COUNT(*) as cnt FROM BT_EVENT_MKT_COUPON WHERE cust_id = '"& bt_stamp("userIdNo") &"' AND USE_YN = 'Y'"
            Set Stamp_Coupon = dbconn.Execute(CountQuery)
            Stamp_Coupon.movefirst

            If this1.item("stampCount") <> Stamp_Coupon("cnt") Then
                If this1.item("stampCount") > Stamp_Coupon("cnt") Then
                    Mcount = Stamp_Coupon("cnt") - this1.item("stampCount")
                    sql = " SELECT stampId_payco as stampId  FROM bt_event_mkt WHERE date_e >= "& nowDate &" AND date_s <= "& nowDate
                    Set Stamp = dbconn.Execute(Sql)
                    If Not (Stamp.BOF Or Stamp.EOF) Then
                    req_str = "{""companyCode"":""" & PAYCO_MEMBERSHIP_COMPANYCODE &""",""stampId"":""" & Stamp("stampId") &""",""memberNo"":""" & bt_stamp("userIdNo") &""",""tradeType"":""MINUS"",""stampingCount"":"&Replace(Mcount,"-","")&"}"
                    api_url = "/stamp/tradeStamp"
                    result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)
                    End If
                ElseIf this1.item("stampCount") < Stamp_Coupon("cnt") Then
                    Mcount = this1.item("stampCount") - Stamp_Coupon("cnt")
                    sql = " SELECT stampId_payco as stampId  FROM bt_event_mkt WHERE date_e >= "& nowDate &" AND date_s <= "& nowDate
                    Set Stamp = dbconn.Execute(Sql)
                    If Not (Stamp.BOF Or Stamp.EOF) Then
                        req_str = "{""companyCode"":""" & PAYCO_MEMBERSHIP_COMPANYCODE &""",""stampId"":""" & Stamp("stampId") &""",""memberNo"":""" & bt_stamp("userIdNo") &""",""tradeType"":""PLUS"",""stampingCount"":"&Replace(Mcount,"-","")&"}"
                        api_url = "/stamp/tradeStamp"
                        result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)
                    End If
                End If
            End If
        '스탬프 비교 끝
        LOOP
        End If
%>