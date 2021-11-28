# Phase 1 - Conceptual database design

**ER Diagram**
<img width="95%" src="https://user-images.githubusercontent.com/33113480/140756323-dfc6419c-bfbe-427b-bec1-b99f0944e6fc.jpg"/>

## Description
*1.SECTOR*   

Scode : 주식코드   
Sector_name : 업종명   
Sname : 주식명   

*2.STOCK*   

Scode : 주식코드   
Sname : 주식명   
Smarket: 시장구분 1 = 코스피, 10 = 코스닥   
Smarket_cap : 시가총액   
Sforeign_rate : 외국인 소진율   
Supdate_date : 주식 정보 업데이트 날짜   
Ssector_name : 업종명   
PER : PER 정보   
PBR : PBR 정보   
ROE : ROE 정보   

*3.CHART*   

Ccode: 주식코드   
CStart_date: 기준일자   
Cend_date : 끝일자 ( 주봉 월봉 년봉만 해당 일봉은 NULL 값이 들어감)   
Cstart_price: 시가   
Cclose_price: 종가   
Chigh_price: 고가   
Clow_price: 저가   
Cscale: 스케일 ( 일봉 = D, 주봉 = W, 월봉 = M, 년봉 = Y)   
Crate_of_fluctutation: 변동률   

*4.USER*   
User_id: 유저 id   
Upassword: 유저 비밀번호   
Unum: 등록번호   
Ucash: 보유금액   
Uage : 나이   
Usex: 성별   
Ucurrent_total_asset : 현재 자산 = 보유금액 + 보유주식 평가금액   
Uemail_address : 이메일   
Ucell_phone_number : 휴대폰번호   

*5.RANKING*   
Ruser_id : 유저 id   
rank : 순위   

*6.TRANSACTION_LIST*   
Twhen: 거래 일시   
Tname: 거래 종목   
Ttype: 매수 or 매도   
Tnum: 거래내역 번호   
Tpar_value_at_the_time: 거래 당시 주당 금액   
Tvolume: 수량   

*7.NEWS*   
Nurl: 기사 url 링크   
Ntitle: 기사 제목   
Ndate: 기사 작성 날짜   
Ncompany: 언급된 주식 or 기업   

*8.INTEREST*   
Quantity: 보유 수량   
Item_assets: 관심 주식 평가금액   
