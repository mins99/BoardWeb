+ Class2까지 Spring MVC 기반으로 개발한 프로그램의 구조와 실행 순서
  1) 브라우저에서 클릭 이벤트로 서버에 요청을 서블릿 컨테이너가 생성한 DispatcherServlet에 전송
  2) DispatcherServlet이 스프링 컨테이너가 생성한 Controller에게 요청 전달
  4) Controller은 매개변수를 통해 전달된 DAO 객체를 이용하여 사용자가 요청한 로직을 처리

## 3.1 비즈니스 컴포넌트 사용
+ Controller에서 직접 DAO를 호출하는 것은 문제를 일으키므로 비즈니스 컴포넌트를 이용하여 사용자의 요청을 처리해야 함

(1) DAO 클래스 교체하기
+ 유지보수 과정에서 DAO 클래스를 다른 클래스로 쉽게 교체하기 위해 Controller에서 직접 호출하지 않아야 한다

(2) AOP 설정 적용하기
+ 현재 구현된 모든 어드바이스는 반드시 Service 구현 클래스의 비즈니스 메소드(BoardServiceImpl.java)가 호출될 때 동작한다.
+ Controller 클래스가 비즈니스 컴포넌트의 인터페이스 타입 멤버변수를 가지고 있고, 이 변수에 비즈니스 객체를 의존성 주입하여 비즈니스 객체의 메소드를 호출.

```
// Spring MVC 적용 이전
// BoardServiceClient.java

// 1. Spring 컨테이너를 구동한다.
AbstractApplicationContext container = new GenericXmlApplicationContext("applicationContext.xml");

// 2. Spring 컨테이너로부터 BoardServiceImpl 객체를 Lookup한다.
BoardService boardService = (BoardService) container.getBean("boardService");

// Spring MVC 적용 이후
// BoardController.java

public class BoardController {
	@Autowired
	private BoardService boardService;
	...
}
```

(3) 비즈니스 컴포넌트 의존성 주입하기
+ 프로젝트 실행 후 클라이언트로부터 ".do" 요청이 들어오면 서블릿 컨테이너가 DispatcherServlet를 생성하고, 스프링 설정 파일인 presentation-layer.xml을 로딩하여 스프링 컨테이너를 구동
+ 이 때 `<context:component-scan base-package="com.springbook.view"/>`를 선언하여 비즈니스 컴포넌트를 먼저 생성하도록 함

## 3.2 비즈니스 컴포넌트 로딩
### **3.2.1 2-Layered 아키텍쳐**
+ 2-Layered architecture style : 일반적인 프레임워크 기반의 웹 프로젝트는 Presentation-layer(MVC), Business layer로 구성
![](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fk.kakaocdn.net%2Fdn%2FrKCoW%2FbtqCLetj61g%2F9tmrOYMfxeTbtW8IrhPpf0%2Fimg.png)
*출처 : https://tmxhsk99.tistory.com/39?category=725455*

### **3.2.2 ContextLoaderListener 등록**
+ ContextLoaderListener : 스프링 컨테이너 구동시 Controller 객체가 메모리에 생성되기 전 먼저 applicationContext.xml 파일을 읽어 비즈니스 컴포넌트를 생성하기 위해 사용
+ web.xml 파일에 `<listener-class>` 태그를 이용하여 등록
+ ContextLoaderListener는 기본적으로 /WEB-INF/applicationContext.xml 파일을 읽으므로 `<context-param>` 설정으로 경로 지정 가능
```
// web.xml

<context-param>
    <param-name>contextConfigLocation</param-name>
    <param-value>classpath:applicationContext.xml</param-value>
</context-param>

<listener>
    <listener-class>
        org.springframework.web.context.ContextLoaderListener
    </listener-class>
</listener>
```

### **3.2.3 스프링 컨테이너의 관계**
+ 스프링 컨테이너의 구동 순서와 관계
1) 톰캣 서버 구동시 web.xml 파일을 로딩하여 Servlet Container 구동
2) Servlet Container는 ContextLoaderListener 객체를 생성(Pre Loading)
3) ContextLoaderListener 객체가 applicationContext.xml 파일을 로딩
4) Spring Container 구동(ROOT Container)되며 Service 구현 클래스나 DAO 객체들이 메모리에 생성
5) 클라이언트가 ".do" 요청을 서버에 전달
6) Servlet Container가 DispatcherServlet 객체를 생성
7) DispatcherServlet 객체가 presentation-layer.xml 파일을 로딩하여 두번째 Spring Container 구동하며 Controller 객체를 메모리에 생성
![](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fk.kakaocdn.net%2Fdn%2Fbtns3R%2FbtqCF7CICwb%2FLjR0hCl4G1FKYiJKihPFO0%2Fimg.png)
*출처 : https://javannspring.tistory.com/231*

+ ContextLoaderListener가 생성하는 스프링 컨테이너를 ROOT 컨테이너라고 하며, DispatcherServlet이 생성한 컨테이너를 자식 컨테이너라고 하며 부모 컨테이너가 생성한 비즈니스 객체를 자식 컨테이너가 생성한 Controller에서 참조하여 사용
![](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fk.kakaocdn.net%2Fdn%2FcJFiqT%2FbtqCF7CIWe5%2Fy3cmxHZQlvYKB8diWrR0l0%2Fimg.png)
*출처 : https://tmxhsk99.tistory.com/41*