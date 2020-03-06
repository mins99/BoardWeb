## 6.1 Spring MVC 적용 준비
+ 기존 사용하던 모든 Controller 클래스들을 스프링에서 제공하는 Controller 인터페이스로 구현
  + com.spring.view.controller 패키지 삭제
+ handleRequest() 메소드의 리턴타입이 String에서 ModelAndView로 변경
```
// Spring에서 제공하는 Controller 인터페이스
package org.springframework.web.servlet.mvc;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

public interface Controller {
	ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response);
}
```

## 6.2 로그인 기능 구현
(2) HandlerMapping 등록
  + presentation-layer.xml에 HandlerMapping과 LoginController bean 등록
    + SimpleUrlHandlerMapping : Setter 인젝션을 통해 Properties 타입의 컬렉션 객체를 의존성 주입
    + Properties : "login.do" 경로 요청에 대해 아이디가 login인 객체 매핑
    + LoginController : SimpleUrlHandlerMapping에서 '/login.do' 킷값으로 매핑한 값과 동일한 아이디로 bean 등록
```
// presentation-layer.xml

<!--  HandlerMapping 등록 -->
<bean class="org.springframework.web.servlet.handler.SimpleUrlHandlerMapping">
    <property name="mappings">
        <props>
            <prop key="/login.do">login</prop>
        </props>
    </property>
</bean>

<!--  Controller 등록 -->
<bean id="login" class="com.springbook.view.user.LoginController"></bean>

// HandlerMapping.java

public HandlerMapping() {
    mappings = new HashMap<String, Controller>();
    //mappings.put("/login.do", new LoginController());	    // 주석 처리
}


```

## 6.3 글 목록 검색 기능 구현
(1) GetBoardListController 구현
  + 검색 결과를 세션에서 ModelAndView 객체에 저장하도록 변경
    + 세션(session) : 클라이언트 브라우저 하나당 하나씩 서버 메모리에 생성되어 클라이언트의 상태정보를 유지
  + DispatcherSerlvet은 Controller가 리턴한 ModelAndView 객체에서 Model 정보를 추출한 다음 HttpServletRequest 객체에 저장하여 JSP로 포워딩
  + JSP 파일에서는 정보를 HttpServletRequest로 부터 꺼내서 사용
```
// GetBoardListController.java

    // 3. 검색 결과를 세션에 저장하고 목록 화면을 리턴한다.
//  HttpSession session = request.getSession();
//  session.setAttribute("boardList", boardList);
//  return "getBoardList";
		
    // 3. 검색 결과를 화면 정보를 ModelAndView에 저장하여 리턴한다.
    ModelAndView mav = new ModelAndView();
    mav.addObject("boardList", boardList);      // Model 정보 저장
    mav.setViewName("getBoardList.jsp");        // View 정보 저장
    return mav;
```

+ 실행 순서
  1. 클라이언트가 "/getBoardList.do" 요청 전송
  2. DispatcherServlet이 요청을 받아 SimpleUrlHandlerMapping을 통해 요청을 처리할 GetBoardListController를 검색하여 실행
  3. GetBoardListController가 검색결과인 List<BoardVO>와 getBoardList.jsp 이름을 ModelAndView 객체에 저장하여 리턴
  4. DispatcherServlet이 ModelAndView로부터 View 정보를 추출하고 ViewResolver를 이용하여 getBoardList.jsp 검색 후 실행
  
## 6.9 ViewResolver 활용하기
(1) ViewResolver 적용
+ ViewResolver를 이용하면 클라이언트로부터의 직접적인 JSP 호출을 차단할 수 있어서 대부분의 웹 프로젝트에서 필수로 사용
+ WEB-INF 폴더 하위로 jsp 파일을 이동시키고 InternalResourceViewResolver를 설정하여 jsp 파일을 View 화면으로 사용
```
// presentation-layer.xml

<!-- ViewResolver 등록 -->
<bean id="viewResolver" class="org.springframework.web.servlet.view.InternalResourceViewResolver">
    <property name="prefix" value="/WEB-INF/board/"></property>
    <property name="suffix" value=".jsp"></property>
</bean>
```

(2) Controller 수정
+ InternalResourceViewResolver를 등록했을 때는 모든 View 이름에서 확장자 '.jsp'를 제거하고, 확장자가 '.do'인 요청은 앞에 'redirect:'를 붙여서 ViewResolver가 동작하지 않도록 해야함