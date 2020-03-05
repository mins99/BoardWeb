## 3.1 스프링 IoC 시작하기

### **3.1.3 스프링 컨테이너의 종류**

-   BeanFactory
    -   스프링 설정 파일에 등록된 `<Bean>` 객체 생성, 관리
    -   지연 로딩(Lazy Loading) 방식 제공 : 클라이언트의 요청(Look up)에 의해서만 `<Bean>` 객체 생성
    -   일반적인 스프링 프로젝트에서 사용할 일 없음
-   ApplicationContext
    -   `<Bean>` 객체 관리 기능, 트랜잭션 관리, 메시지 기반의 다국어 처리 등 지원
    -   즉시 로딩(Pre Loading) 방식으로 동작 : 컨테이너 구동 시점에 `<Bean>` 등록된 클래스들 객체 생성
    -   웹 애플리케이션 개발 지원
    -   구현 클래스 : GenericXmlApplicationContext(XML), XmlWebApplicationContext(Spring MVC)

## 3.2 스프링 XML 설정

-   `<bean>` 루트 엘리먼트
    
    -   스프링 컨테이너는 xml 설정 파일을 참조하여 의 생명주기를 관리하고 서비스를 제공함
    -   네임스페이스를 비롯한 xml 스키마 관련 정보 설정
-   `<import>`엘리먼트
    
    -   설정 파일을 여러개의 xml파일로 나누어 설정하고 import 할 수 있다
-   `<bean>` 엘리먼트
    
    -   스프링 설정 파일에 클래스를 등록하기 위해 사용
    -   id 속성은 생략 가능, class 속성은 필수

### **3.2.4 `<bean>` 엘리먼트 속성**

-   init-method 속성
    
    -   Servlet에서는 init 메소드를 재정의 하여 멤버 변수를 초기화
    -   스프링에서는 init-method 속성을 사용하여 멤버 변수를 초기화
-   destroy-method 속성
    
    -   스프링 컨테이너가 객체를 삭제하기 직전에 호출된 메소드 지정
-   lazy-init 속성
    
    -   ApplicationContext를 이용하여 컨테이너 구동시 구동 시점에 `<bean>` 생성(즉시 로딩 방식)
    -   자주 사용되지 않으면서 메모리를 많이 차지하여 시스템에 부담을 주는 `<bean>`에 lazy-init 속성을 사용하여 클라이언트가 요청하는 시점에 `<bean>` 을 생성
-   scope 속성
    
    -   객체 생성시의 사용 범위에 대한 속성
        -   singleton : 하나의 객체만 생성하는 것
        -   prototype : 매번 새로운 객체를 생성하여 반환