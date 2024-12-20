<img src="https://github.com/user-attachments/assets/52261490-9e82-48f3-8da4-a958731f041f" width="700px"/>

***

## 개요

* **프로젝트 명**
  - 세상의 모든 레시피 FoodJoa
    
* **기간**
  - 2024.11.04 ~ 2024.12.09

* **팀원**
  - Leader : 이건용
      > 레시피 및 리뷰 CRUD
      > 전체적인 코드 관리 감독
  - Member : 이하나
      > 공지사항, 자유게시판, 공유게시판 CRUD,
      > 메인화면
  - Member : 서아론
      > 스토어(밀키트) 및 리뷰 CRUD
      > 결제화면
  - Member : 이혜원
      > 회원 로그인/가입/탈퇴
      > 최근 본 목록, 찜목록, 장바구니
      > 결제화면
  - Member : 최민석
      > 회원정보화면
      > 회원 수정
      > 회원이 주문한 품목
      > 회원이 등록한 품목 중 주문이 들어온 내역역

* **목차**
  - 개발 환경
  - 프로그램 구조 및 ERD
  - 구현한 기능

***

## 개발 환경

* 개발언어
  - HTML5, CSS3, JS(ES6), jQuery, JAVA, MySQL
  
* 개발 OS
  - Windows(10, 11), Mac

* Web Application Server
  - Apache Tomcat 9.0

* API
  - 네이버, 카카오 로그인
  - 네이버 지도
  - 카카오 결제
  - 다음 우편번호 서비스
  - tinymce 텍스트 에디터

* TOOLS
  - Eclipse, MySQL, Visual Studio Code

***
 
## 프로그램 구조 및 ERD

<details>
<summary>프로그램 구조</summary>
<div markdown="1" style="padding-left: 15px;">
<img src="https://github.com/user-attachments/assets/2d8980bb-4cc7-4c53-a1e0-5d5f0b18af60" width="800px"/>
</div>
</details>

<details>
<summary>ERD</summary>
<div markdown="1" style="padding-left: 15px;">
<img src="https://github.com/user-attachments/assets/10a3ae15-24a7-409f-b4d6-090d545eb073" width="800px"/>
</div>
</details>

***

## 구현한 기능

* 메인화면
![image](https://github.com/user-attachments/assets/388cca2c-c8e5-4d96-bdb6-e488a029175c)
  > 레시피, 스토어 품목 중 평점 상위 3개 출력
  > 공지사항 출력
  > 게시판 게시글 중 조회수 상위 5개 출력
---

* 레시피
![image](https://github.com/user-attachments/assets/22294854-fad1-42cd-bb55-d371f0f2c92b)
  > 레시피 CRUD
  > tinymce 텍스트 에디터 API 적용
  > 카테고리 별 조회
  > 검색 기능
  > 각 레시피의 리뷰 작성

---
    
* 스토어
![image](https://github.com/user-attachments/assets/716242a5-d8ea-440d-bc58-42696ecf159b)
  > 밀키트 CRUD
  > 카테고리 별 조회
  > 검색 기능
  > 각 밀키트의 리뷰 작성

---

* 게시판
![image](https://github.com/user-attachments/assets/98700e8b-c962-4f2e-b0ca-61ccc0a0188a)
  > 공지사항, 자유게시판, 공유게시판 CRUD
  > 검색 기능
  > 공유게시판 네이버 지도 API 적용

---

* 회원관리
![image](https://github.com/user-attachments/assets/23ba5f94-33ef-4684-b894-545fbf8231f6)
  > 네이버, 카카오 로그인 API 적용
  > 네이버, 카카오 인증 후 추가적인 정보 입력 시 다음 우편번호 API 적용
  > 회원 정보 수정 및 탈퇴
  > 작성한 레시피, 스토어, 리뷰 확인, 수정, 삭제
  > 사용자가 주문한 스토어 품목 내역 조회
  > 사용자가 등록한 스토어 품목 중 주문 내역 조회
  > 레시피, 스토어 품목 중 최근에 본 20개 목록 조회
  > 레시피, 스토어 품목 중 찜한 목록 조회
  > 스토어 품목 중 장바구니에 추가한 목록 조회

---

* 결제화면
![image](https://github.com/user-attachments/assets/2502f19c-9795-43d2-8302-506efb86ebfb)
  > 회원 정보를 출력 후 수정 가능하게 설정
  > 다음 우편번호 API 적용
  > 카카오 결제 API 적용
 
---

* 그 외 편의를 위한 코드
  - [DBConnector.java](https://github.com/euneick/FoodJoa/blob/main/src/Common/DBConnector.java)
    > DB 연결 시 과도하게 반복되는 코드를 모아놓은 클래스
  - [FileIOController.java](https://github.com/euneick/FoodJoa/blob/main/src/Common/FileIOController.java)
    > 사용자가 등록 및 삭제 한 파일을 다루기 위한 클래스
    > 사용자가 파일 업로드 시 발생하는 임계 구역의 문제를 해결하기 위해 synchronized 된 메소드를 구현
    > 파일 이동, 파일 및 경로 삭제 구현
  - [StringParser.java](https://github.com/euneick/FoodJoa/blob/main/src/Common/StringParser.java)
    > 사용자가 입력한 파일들의 이름 및 문자열을 재가공 하기 위한 클래스
    > 여러개의 문자열을 [문자열의크기][문자열의내용] 순서로 하나로 합치는 메소드 구현
    > XSS 공격을 대비하여 특수문자들을 html escape 코드로 변환하는 메소드 구현
