## 4장에서 만든 MVC 프레임워크 구조

| Class | Operation |
| ------ | ----------- |
| DispatcherServlet   | 유일한 서블릿 클래스. 모든 클라이언트의 요청을 가장 먼저 처리하는 Front Controller |
| HandlerMapping | 클라이언트의 요청을 처리할 Controller 매핑 |
| Controller    | 실질적인 클라이언트의 요청 처리 |
| ViewResolver | Controller가 리턴한 View 이름으로 실행될 JSP 경로 완성 |

+ 실행 순서
  1. 클라이언트가 로그인 버튼을 클릭하여 "login.do" 요청 전송
  2. DispatcherServlet이 요청을 받아 HandlerMapping 객체를 통해 LoginController를 검색
  3. LoginController의 handleRequest() 메소드 호출하여 로그인 로직 처리
  4. 로그인 후 "getBoardList.do" 요청 전송
  5. DispatcherServlet이 ViewResolver를 통해 getBoardList.jsp 검색
  6. getBoardList.jsp 실행하여 화면에 나타남

+ view.board
  + DeleteBoardController.java
  + GetBoardController.java
  + GetBoardListController.java
  + InsertBoardController.java
  + UpdateBoardController.java
+ view.controller
  + Controller.java
  + DispatcherServlet.java
  + HandlerMapping.java
  + ViewResolver.java
+ view.user
  + LoginController.java
  + LogoutController.java