# 주식박사

This Repository is Database (COMP322) Project of 3 TEAM







**Build Environment**

[![Java 7+](https://img.shields.io/badge/Java-7%2B-informational)](http://java.oracle.com)
[![Tomcat 8.5](https://img.shields.io/badge/Tomcat-8.5%2B-informational)](https://tomcat.apache.org/download-80.cgi)
[![Oracle 19c](https://img.shields.io/badge/Oracle-19c-informational)](https://www.oracle.com/database/technologies)
[![ Build Status (Windows)](https://img.shields.io/appveyor/build/parrt/antlr4?label=Windows)](https://www.microsoft.com/ko-kr/windows)
[![ Build Status (MAC)](https://img.shields.io/badge/Mac-issue-yellow)](https://support.apple.com/ko-kr/HT201260)

**Additional Libs**
* [JSON simple](https://code.google.com/archive/p/json-simple/)
* [JSoup](https://jsoup.org/)
* [orai18n(for ojdbc8)](https://www.oracle.com/database/technologies/appdev/jdbc-ucp-19-7-c-downloads.html)   

**필수**
* 이클립스에 프로젝트 추가 후, 본인 환경에 따라 톰캣 및 jre 버전 수정 필요   
* orai18n.jar 추가 후 나오는 Tomcat Warnings 제거 방법   
톰캣 xml 파일 중 context.xml에 &#60;JarScanner scanManifest	&#61;	&#34;false&#34;&#47;&#62; 추가   
* 본인 컴퓨터의 톰캣 설치 경로의 Lib 폴더에 상기한 4개 jar 파일을 추가해 주지 않으면 실행할 때 오류가 발생함.

**Data Set**

* [KRX 데이터](http://data.krx.co.kr/contents/MDC/MAIN/main/index.cmd), [키움 API](https://www.kiwoom.com/h/customer/download/VOpenApiInfoView) 
를 활용해 코스피 상장 종목들의 한 달간의 주가 데이터를 받아옴. (2021 11 24 기준)




## 프로젝트 소개

### 배경

주식 투자에 대한 열풍으로 투자를 시작하는 사람은 많지만 정작 수익을 내는 사람은 많지 않아서 실제 투자를 하기전 간단하게 체험해 볼 수 있는 서비스의 필요성을 느껴
프로젝트 주제로 삼게 되었음.

### 주요 기능

* 주식 정보 조회 :기본적인 정보부터 시작하여 사용자가 원하는 조건을 토대로 다양한 검색방법 제공.
* 모의투자 : 원하는 주식을 가상으로 사고 팔 수 있음.
* 랭킹 : DB에 등록된 사용자들은 자산을 바탕으로 랭킹이 매겨짐. 랭킹 정보 조회 가능.

## Summary

* [Phase 1](https://github.com/sapiens2000/DB_3_TEAM_PROEJCT/blob/main/Phase/Phase1) : Conceptual Design -> ERD
![erd](https://user-images.githubusercontent.com/33113480/143677997-8ac3320a-750b-4f85-a89d-5641dfe24066.JPG)

* [Phase 2](https://github.com/sapiens2000/DB_3_TEAM_PROEJCT/blob/main/Phase/Phase2) : Logical Design -> ERD to Relation Diagram
![relation_phase2_최종](https://user-images.githubusercontent.com/33113480/143677847-57727783-9e01-4a66-8ca0-913f51633a0e.jpg)

* [Phase 3](https://github.com/sapiens2000/DB_3_TEAM_PROEJCT/blob/main/Phase/Phase3) : Console Program (Java)
![system](https://user-images.githubusercontent.com/33113480/143678034-690e52ce-d291-44f2-a88d-0a22e880745e.JPG)

* [Phase 4](https://github.com/sapiens2000/DB_3_TEAM_PROEJCT/blob/main/Phase/Phase4) : Web Service
![Main](https://user-images.githubusercontent.com/33113480/143679109-ec8230f6-5a27-4360-b4fa-243fb520fbc6.JPG)


## Contributors

* [박휘성](https://github.com/hwistar0717)
* [류수성](https://github.com/Hermes997)
* [전병규](https://github.com/sapiens2000)
