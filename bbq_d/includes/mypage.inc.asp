<%
	Set pUserInfo = UserGetInfo
	Set pCouponList = CouponGetHoldList("NONE", "N", 100, 1)
	Set pPointBalance = PointGetPointBalance("SAVE", 30)
	Set pCardOwnerList = CardOwnerList("USE")
%>
				<div class="myInfo-wrap">
					<div class="myInfo-membership">
						<div class="myInfo-memGrade">
							<p class="memGrade"><strong><%=Session("userName")%></strong>님 안녕하세요!</p>
							<p class="memTxt">세상에서 가장 건강하고 맛잇는 치킨 bbq 입니다.</p>
							<p class="memTxt"></p>
							<div class="btn-wrap">
								<button type="button" class="btn btn-sm2 btn-grayLine" onClick="location.href='/mypage/memEdit.asp'"><span>개인정보 변경</span></button>
								<button type="button" class="btn btn-sm2 btn-black mar-l10" onClick="javascript:alert('준비중입니다.');"><span>치킨캠프 신청내역</span></button>
							</div>
						</div>
						<!-- <div class="myInfo-inquiry">
							<dl class="itemInfo">
								<dt>1:1 문의내역</dt>
								<dd><span>1</span>건</dd>
							</dl>
							<dl class="itemInfo">
								<dt>상품문의내역</dt>
								<dd><span>1</span>건</dd>
							</dl>
						</div> -->
					</div>
					<div class="myInfo-shopping">
						<dl class="itemInfo itemInfo-point" onclick="location.href='./mileage.asp';">
							<dt>포인트</dt>
							<dd>
								<div class="count"><span><%=FormatNumber(pPointBalance.mTotalPoint,0)%></span>P</div>
							</dd>
						</dl>
						<dl class="itemInfo itemInfo-coupon" onclick="location.href='./couponList.asp';">
							<dt>쿠폰</dt>
							<dd>
								<div class="count"><span><%=pCouponList.mTotalCount%></span>장</div>
								<!-- <a href="#" class="link-go">쿠폰 등록하기</a> -->
							</dd>
						</dl>
						<dl class="itemInfo itemInfo-card" onclick="location.href='./cardList.asp';">
							<dt>카드</dt>
							<dd>
								<div class="count"><span><%=UBound(pCardOwnerList.mCardDetail)+1%></span>장</div>
							</dd>
						</dl>						
					</div>
				</div>
