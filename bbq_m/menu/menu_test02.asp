<!--#include virtual="/api/include/utf8.asp"-->
<!--#include virtual="/api/include/db_open.asp"-->

<%
    Dim aCmd, aRs
%>

<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->

<script type="text/javascript">
    
</script>

</head>

<body>

<div class="wrapper">

	<%
		PageTitle = "결제준비"
	%>

    <!--#include virtual="/includes/header.asp"-->

	<%

	%>

    <!-- Container -->
    <div class="container">

        <!-- Aside -->
        <!--#include virtual="/includes/aside.asp"-->
        <!--// Aside -->
            
        <!-- Content -->
        <article class="content">

			<%
				Dim addr_idx : addr_idx = Request("addr_idx")
				Dim item_amt : item_amt = Request("item_amount")
				Dim total_amt : total_amt = Request("total_amount")
				Dim item_data : item_data = Request("item_data")

				If IsEmpty(addr_idx) Or IsNull(addr_idx) Or Trim(addr_idx) = "" Or Not IsNumeric(addr_idx) Then addr_idx = 0
				If IsEmpty(item_amt) Or IsNull(item_amt) Or Trim(item_amt) = "" Or Not IsNumeric(item_amt) Then item_amt = 0
				If IsEmpty(total_amt) Or IsNull(total_amt) Or Trim(total_amt) = "" Or Not IsNumeric(total_amt) Then total_amt = 0
				If IsEmpty(item_data) Or IsNull(item_data) Or Trim(item_data) = "" Then item_data = ""

				If addr_idx = 0 Then
			%>

			<script type="text/javascript">
				alert("배송지가 지정되지 않았습니다.");
				history.back();
			</script>

			<%
					Response.End
				End If

				If item_amt = 0 Or total_amt = 0 Or item_data = "" Then
			%>

			<script type="text/javascript">
				alert("정보가 불확실합니다.");
				history.back();
			</script>

			<%
					Response.End
				End If

				' Response.Write item_data

				Dim iJson : Set iJson = JSON.Parse(item_data)

				Dim reqData : Set reqData = New clsReqOrderGetListForOrder

				reqData.mCompanyCode = PAYCO_MEMBERSHIP_COMPANYCODE
				reqData.mMerchantCode = PAYCO_MEMBERSHIP_MERCHANTCODE
				reqData.mMemberNo = Session("userIdNo")
				reqData.mOrderAmount = item_amt
				reqData.mAccountTypeCode = "SAVE"

				iL = iJson.Length-1

				Response.Write iL

				For i = 0 To iL
					Set tt = New clsProductList

					' Response.Write iJson.get(i)
					tt.mProductClassCd = "BK"
					tt.mProductCd = iJson.get(i).value.cd
					tt.mTargetUnitPrice = iJson.get(i).value.price
					tt.mUnitPrice = iJson.get(i).value.price
					tt.mProductCount = iJson.get(i).value.qty

					reqData.addProductList(tt)
				Next

				Response.Write reqData.toJson

				Dim resMemberShip : Set resMemberShip = OrderGetListForOrder(reqData.toJson)

				Response.Write resMemberShip.mCode

				Set aCmd = Server.CreateObject("ADODB.Command")
				With aCmd
					.ActiveConnection = dbconn
					.NamedParameters = True
					.CommandType = adCmdStoredProc
					.CommandText = "bp_member_addr_select"

					.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, Session("userIdNo"))
					.Parameters.Append .CreateParameter("@addr_idx", adInteger, adParamInput, , addr_idx)

					Set aRs = .Execute
				End With
				Set aCmd = Nothing

				If Not (aRs.BOF Or aRs.EOF) Then
					addr_idx = aRs("addr_idx")
					address = aRs("address_main") & " " & aRs("address_detail")
				End If
			%>


            <!-- 상단 배달정보 -->
            <section class="section section_cartSum">
                <dl>
                    <dt>배달매장 :</dt>
                    <dd><span class="red">구로점</span> <em>(02-123-4567)</em></dd>
                </dl>
                <dl class="address">
                    <dt>배달주소 :</dt>
                    <dd><span class="txt_overflow"><%=address%></span> <button type="button" onclick="javascript:lpOpen('.lp_orderShipping');" class="btn btn-sm btn-grayLine btn_lp_open">변경</button></dd>
                </dl>
            </section>
            <!-- //상단 배달정보 -->

            <!-- 장바구니 리스트 -->
            <section class="section section_orderDetail pad-t0">
                <div class="order_menu">
                    <div class="box div-table" id="order_table">

						<%
							Dim iLen : iLen = iJson.Length
							' Response.Write "dataLen: " & iLen & "<br>"
							Dim i
							For i = 0 To iLen - 1
								Dim ii : Set ii = iJson.get(i).value

								' Response.Write ii
						%>

                        <div class="tr">
                            <div class="td img"><img src="http://placehold.it/160x160?text=1" alt=""></div>
                            <div class="td info">
                                <div class="sum">
                                    <dl>
                                        <dt><%=ii.nm%></dt>
                                        <dd><%=ii.price%>원 <span>/ <%=ii.qty%>개</span></dd>
                                    </dl>
                                </div>
                                <div class="mar-t15 ta-r">
                                </div>
                                <button type="button" class="btn_del">삭제</button>
                            </div>
                        </div>

						<%
							Next
						%>

                        <!-- <div class="tr">
                            <div class="td img"><img src="http://placehold.it/160x160?text=1" alt=""></div>
                            <div class="td info">
                                <div class="sum">
                                    <dl>
                                        <dt>자메이카 + 올치팝(컵)</dt>
                                        <dd>18,000원 <span>/ 1개</span></dd>
                                    </dl>
                                </div>
                                <div class="mar-t15 ta-r">
                                    <button type="button" class="btn btn-sm btn-brown">사이드/수량변경</button>
                                </div>
                                <button type="button" class="btn_del">삭제</button>
                            </div>
                        </div> -->
                    </div>
                </div>

                <div class="order_calc">
                    <div class="top div-table mar-t30">
                        <dl class="tr">
                            <dt class="td">총 상품금액
                            </dt><dd class="td" id="item_amt"><%=FormatNumber(item_amt,0)%>원</dd>
                        </dl>
                        <dl class="tr">
                            <dt class="td">배달비
                            </dt><dd class="td" id="delivery_fee">2,000원</dd>
                        </dl>
                    </div>
                    <div class="bot div-table">
                        <dl class="tr">
                            <dt class="td">합계</dt>
                            <dd class="td" id="total_amt"><%=FormatNumber(total_amt,0)%><span>원</span></dd>
                        </dl>
                    </div>
                </div>

                <div class="mar-t40">
                    <button type="submit" class="btn btn-lg btn-red w-100p" onClick="javascript:checkOrder();">주문하기</button>
                </div>
            </section>
            <!-- //장바구니 리스트 -->

        </article>
        <!--// Content -->

    </div>
    <!--// Container -->

    <!-- Footer -->
    <!--#include virtual="/includes/footer.asp"-->
    <!--// Footer -->
