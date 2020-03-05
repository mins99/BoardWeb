## 5.1 Spring MVC 수행 흐름
+ 실행 순서
  1. 클라이언트가 "~.do" 요청 전송
  2. DispatcherServlet이 요청을 받아 HandlerMapping 객체를 통해 Controller를 검색하여 실행
  3. Controller는 비즈니스 로직 수행 결과로 Model과 View 정보를 ModelAndView 객체에 저장하여 리턴
  4. DispatcherServlet은 ModelAndView로부터 View 정보를 추출, ViewResolver를 이용하여 View를 얻어내서 실행한다
  
## 5.2 DispatcherSevlet 등록 및 스프링 컨테이너 구동
### **5.2.1 DispatcherServlet 등록**
+ WEB-INF/web.xml 파일의 DispatcherServlet 클래스를 Spring framework에서 제공하는 DispatcherServlet으로 변경
```
// web.xml
<servlet>
    <servlet-name>action</servlet-name>
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
</servlet>

```

### **5.2.2 스프링 컨테이너 구동**
+ Spring MVC 구성요소 중 DispatcherServlet 클래스가 유일한 서블릿
+ DispatcherServlet은 클라이언트의 요청 처리에 필요한 HandlerMapping, Controller, ViewResolver 객체를 생성하기 위해 스프링 컨테이너 구동
+ Servlet Container가 DispatcherServlet 객체 생성 후 init() 메소드 실행으로 스프링 설정 파일(action-servlet.xml) 로딩하여 XmlWebApplicationContext 생성(스프링 컨테이너 구동)
+ action-servlet.xml에 HandlerMapping, Controller, ViewResolver 클래스를 bean 등록하여 생성

## 5.3 스프링 설정 파일 변경
+ 스프링 컨테이너를 위한 설정 파일의 이름과 위치 변경 가능
```
// web.xml
<servlet>
    <servlet-name>action</servlet-name>
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
    <init-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>/WEB-INF/config/presentation-layer.xml</param-value>
    </init-param>
</servlet>
```

## 5.4 인코딩 설정
+ 인코딩 처리를 위해 web.xml 파일에 CharacterEncodingFilter 클래스 등록