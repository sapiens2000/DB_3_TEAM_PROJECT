--1a.
--외국인 보유비율 30%이상 주식 이름과 일련번호 쿼리
SELECT Sname, Scode
FROM STOCK S
Where S.Sforeign_rate > 30;

--1b
--현금 100000이상 보유 유저의 Unum과 보유금액 출력
SELECT U.Unum, U.Ucash
FROM USERS U
WHERE U.Ucash > 100000;

--1c
--'삼성전자'로 포함하는 타이틀을 가진 기업관련 뉴스의 url 출력
SELECT N.Nurl, N.Ncompany
FROM NEWS N
WHERE N.Ncompany LIKE '%삼성전자%';

--2a. 
--PER 이 10을 넘는 주식의 2021년일자 관련뉴스 url출력
SELECT N.Nurl, N.Nwhen
FROM STOCK S, NEWS N, MENTION M
WHERE  S.Scode = M.Mcode
	AND M.Murl = N.Nurl
	AND S.sper > 10
	AND (N.Nwhen >= '20210101' 
         AND N.Nwhen < '20211231');


--2b.
--유저랭킹 100이내의 유저의 Unum, 나이, 성 출력
SELECT U.Unum, U.Uage, U.Usex
FROM USERS U, RANKING R, RANKING RK
WHERE U.User_id = R.Ruser_id
	AND R.Ruser_id = RK.Ruser_id
	AND R.Rank < 100;
	
--2c.
--특정 한 사람의 2020년 거래내역 출력
SELECT U.User_id, T.Twhen, T.Tname, T.Type, T.Tvolume
FROM USERS U, HISTORY H, TRANSACTION_LIST T
WHERE U.Unum = H.Hunum
	AND H.Htnum = T.Tnum
	AND T.Twhen >= '2020-01-01'
	AND T.Twhen < '2021-01-01';


--3a. 
--'삼성전자'으로 시작하는 이름의 주식을 가진 사람들의 숫자를 주식 코드별로 쿼리
SELECT  I.In_scode, COUNT(U.Unum) as NumUser
FROM USERS U, STOCK S, INTEREST I
WHERE I.In_unum = U.Unum
	AND I.In_scode = S.Scode
	AND I.Quantity > 0
	AND S.Sname LIKE '삼성전자%'
GROUP BY I.In_scode;

--3b. 
--'삼성전자' 주식을 가진 사람 중 나이대별 주식 보유량 출력
SELECT U.Uage, SUM(I.Quantity)
FROM USERS U, INTEREST I, STOCK S
WHERE I.In_unum = U.Unum
    AND I.In_scode = S.Scode
    AND S.Sname = '삼성전자'
GROUP BY Uage;

--4a.
--ROE가 10%초과인 주식의 이름과 PBR출력
SELECT S.Sname, S.spbr
FROM STOCK S
WHERE S.spbr IN (SELECT S.spbr
					FROM STOCK S
					WHERE S.sroe > 10.0);

--4b. 
--섬유의복 섹터의 모든 기업들보다 시가총액이 높은 전기전자 섹터의 기업목록 출력
SELECT S.Sname, S.Smarket_cap
FROM STOCK S, SECTOR SS
WHERE S.Smarket_cap > ALL (SELECT S.Smarket_cap
							FROM STOCK 
							WHERE Sector_name = '섬유의복')
    AND S.scode = ss.scode
    AND SS.sector_name = '전기전자';

--5b.
--전체 시총의 0.1%이하 소유한 사람이 있는 주식이름, 사람, 해당 주식 보유량 출력 (단위 1억)
SELECT S.Sname, U.Unum, I.Item_assets
FROM STOCK S, USERS U, INTEREST I
WHERE I.In_unum = U.Unum
   AND I.In_scode = S.Scode
   AND EXISTS (SELECT I.Item_assets
               FROM STOCK S, USERS U, INTEREST I
               WHERE I.In_unum = U.Unum
                  AND I.In_scode = S.Scode
                  AND I.Item_assets <= S.Smarket_cap * 0.0001 * 100000000);

--6a.
--Scale이 일봉이고 변동률이 -1%이하인 차트 정보 출력(기준일자, 끝 일자, 주식이름, 주식가격, 날짜, 차트 구분(스케일))
-- 삼성전자 차트만 넣어서 삼성전자만 나옴
SELECT Cstart_date, Cend_date, Sname, Cclose_price, Cscale
FROM STOCK, CHART 
WHERE Scode = Ccode 
    AND Ccode IN (SELECT C.Ccode
   FROM CHART C
   WHERE C.Cscale = 'D'
   AND (C.Cstart_price - C.Cclose_price) / C.Cclose_price * 100 < -0.1);


--6b.
--2020년 10월 이후에 그래프에서 한번이라도 하루만에 2%가 오른적이 있는 주식이름 출력
SELECT DISTINCT S.Sname
FROM STOCK S, CHART C
WHERE S.Scode = C.Ccode
	AND S.Scode IN (SELECT S.Scode
					FROM STOCK S, CHART C
					WHERE S.Scode = C.Ccode
						AND C.Cstart_date >= '20201001'
						AND (C.Cstart_price / C.Cclose_price) >= 0.02);


--7a.
-- 특정 기간(2020~2021)의 주식별 총거래량을 Type별로 출력
SELECT HS.Tname, HS.Type, SortByType.SumofTrans
FROM (SELECT TS.Type, SUM(TS.Tvolume) SumofTrans
		FROM TRANSACTION_LIST TS
		GROUP BY TS.Type) SortByType
		, TRANSACTION_LIST HS
WHERE HS.Twhen > '20200101' AND HS.Twhen <= '20211231';

--7b.
--2021년 8월 이후의 뉴스 중 관련 기업이 '삼성전자'인 뉴스 url 출력
SELECT NC.Nurl, NC.Ncompany
FROM (SELECT N.Nurl, N.Ncompany
		FROM NEWS N
		WHERE N.Nwhen >= '20210801') NC
WHERE NC.Ncompany = '삼성전자';

--8a.
--주식의 보유량이 1이상의 사람의 Unum, 보유개수, 전화번호 출력 후 보유개수가 높은 사람부터 정렬
SELECT U.Unum, I.Quantity, U.Ucell_phone_number
FROM USERS U, INTEREST I, STOCK S
WHERE I.In_unum = U.Unum
	AND I.In_scode = S.Scode
	AND I.Quantity >= 1
ORDER BY I.Quantity DESC;

--8b.
--랭킹 1~9의 특정 날짜의 거래내역을 출력하고 랭킹 순으로 오름차순 정렬
SELECT R.Ruser_id, T.Twhen, T.Tname, T.Type, T.Tvalue, T.Tvolume
FROM RANKING R, USERS U, HISTORY H, TRANSACTION_LIST T
WHERE R.Ruser_id = U.User_id
	AND U.Unum = H.Hunum
    AND H.Htnum = T.Tnum    
	AND R.Rank < 10
ORDER BY R.Rank ASC;

--9a
--섹터 중 2021년 6월 이후의 1일 스케일중에서 시가 총액이 100이상인 주식이름의 차트를 출력하고
--섹터별로 그룹화, 카운트별 오름차순 정렬
SELECT ST.Sector_name, COUNT(S.Sname) AS CT
FROM STOCK S, CHART C, SECTOR ST
WHERE S.Scode = C.Ccode
    AND ST.Scode = S.Scode
    AND C.Cstart_date > '20210601'
	AND C.Cscale = 'D'
	AND S.Smarket_cap >= 100
GROUP BY ST.Sector_name
ORDER BY CT;

--10a
--11번 유저와 65번 유저가 가진 주를 모두 출력
SELECT DISTINCT Sname, U.Unum, I.Quantity
FROM USERS U, INTEREST I, STOCK S
WHERE U.Unum = I.In_unum    
	AND I.In_Scode = S.Scode
	AND U.Unum = 11
UNION
SELECT DISTINCT Sname, U.Unum, I.Quantity
FROM USERS U, INTEREST I, STOCK S
WHERE U.Unum = I.In_unum
	AND I.In_Scode = S.Scode
	AND U.Unum = 65;






