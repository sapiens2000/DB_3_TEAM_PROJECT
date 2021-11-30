# Phase 2 - Logical database design
## ERD 수정   
![image](https://user-images.githubusercontent.com/33113480/143772912-a9face08-c10f-4bb3-b010-1fbab9bcd3c4.png)

## ERD TO RELATIONAL DIAGRAM   
![relation_phase2_최종](https://user-images.githubusercontent.com/33113480/143677847-57727783-9e01-4a66-8ca0-913f51633a0e.jpg)

## ER Schema 수정사항   
* 1. BROKER 삭제 - 최초에는 증권회사를 의미했으나, 제작하려는 웹 서비스 자체가 증권회사의 성격을 지니기 때문에 삭제   
* 2. COMPANY 삭제 - 회사별이 아닌, 주식명과 업종명으로 주식 구분   
* 3. NOTABLE_PERSON 삭제 - 뉴스 엔티티와 겹치는 엔티티   
* 4. SCALE 삭제 - SCALE 을 CHART 로 변경하며 속성 추가 및 의미 구체화   
* 5. SECTOR 추가 - 주식의 업종명 구분   
* 6. CHART 추가 - 3과 동일   

### Phase1 평가의견   
* 5. 한 회사에 여러 주식이 상장 해 있을 수 있다.   
-> 보통주, 우선주의 경우 코드도 다르고 별도로 존재하기 때문에 구분 가능   

————————————————————————————————————————————————————————————————————————————————————————————————    
## ER Schema - Relational Schema Mapping   
* USER - RANKING   
한 명의 유저가 하나의 랭킹 리스트만을 가진다.   
랭킹은 해당 유저의 랭킹 순위를 가지고 있다.   
1:1 관계   
   
* USER - TRANSACTION_LIST   
유저는 거래내역이 없을 수도 있고, 여러 개가 있을 수 있다.   
거래 내역은 한 명의 유저에게만 속한다.   
N : 1 관계   
   
* USER - STOCK   
한 명의 유저는 주식이 없을 수도 있고, 여러 주식을 가질 수 있다.   
특정 주식을 아무도 보유하지 않을 수도 있으며, 여러 사람이 보유할 수도 있다.   
M : N 관계    
    
* STOCK - SECTOR   
하나의 주식은 하나의 업종을 가지고 있다.   
하나의 업종은 여러 주식에 속할 수 있다.   
1 : N 관계   
   
* STOCK - NEWS   
하나의 주식은 관련된 여러 뉴스를 가질 수 있다.   
뉴스는 관련된 주식을 한 개 이상 가자고 있다.   
M : N 관계   
   
* STOCK - CHART   
하나의 주식은 Cscale 과 Cstart_date 에 따른 여러가지 차트를 가질 수 있다.   
N : 1 관계   
   