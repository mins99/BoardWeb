## 5.1 어노테이션 설정 기초

### **5.1.1 Context 네임스페이스 추가**
+ applicationContext.xml 파일에 context 관련 네임스페이스와 스키마 문서 위치 등록
```
// applicationContext.xml

<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:context="http://www.springframework.org/schema/context"
	xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
		http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-4.2.xsd>
```

### **5.1.2 컴포넌트 스캔(component-scan) 설정**
+ `<bean>` 등록하지 않고 자동으로 생성하려면 `<context:component-scan/>` 엘리먼트를 정의
+ 클래스 패스에 있는 클래스를 스캔하여 @Component가 설정된 클래스들을 자동으로 객체 생성
+ base-package 속성 : 속성값을 "com.springbook.biz" 형태로 지정하면 해당 패키지로 시작하는 모든 패키지를 스캔 대상에 포함
```
// applicationContext.xml
   
<context:component-scan base-package="polymorphism"></context:component-scan>
```

### **5.1.3 @Component**
+ 기존 applicationContext.xml에 bean 등록하지 않고 클래스 선언부 위에 @Component만 선언하면 됨
```
// applicationContext.xml
<bean class="polymorphism.LgTV"></bean>

// LgTV.java
@Component
public class LgTV implements TV {
    public LgTV() {
        System.out.println("===> LgTV 객체 생성");
    }
}
```

+ 클라이언트가 스프링 컨테이너가 생성한 객체를 요청하려면 아이디나 이름이 반드시 설정되어 있어야 함
```
// 1. Spring 컨테이너를 구동한다.
    AbstractApplicationContext factory = new GenericXmlApplicationContext("applicationContext.xml");

// 2. Spring 컨테이너로부터 필요한 객체를 요청한다.
    Tv tv = (TV)factory.getBean("tv");
```
```
// applicationContext.xml
<bean id="tv" class="polymorphism.LgTV"></bean>

// LgTV.java
@Component("tv")
public class LgTV implements TV {
    public LgTV() {
        System.out.println("===> LgTV 객체 생성");
    }
}
```

## 5.2 의존성 주입 설정

### **5.2.1 의존성 주입 어노테이션**
| Annotation | Description |
| ---------- | ----------- |
| @Autowired   | 주로 변수 위에 설정하여 해장 타입의 객체를 찾아서 자동으로 할당한다.<br>org.springframework.beans.factory.annotation.Autowired |
| @Qualifier | 특정 객체의 이름을 이용하여 의존성 주입할 때 사용한다.<br>org.springframework.beans.factory.annotation.Qualifier |
| @Inject    | @Autowired와 동일한 기능을 제공한다.<br>javax.annotation.Resource |
| @Resource    | @Autowired와 @Qualifier의 기능을 결합한 어노테이션이다.<br>javax.inject.Inject |
+ @Autowired, @Qualifier만 스프링에서 제공



### **5.2.2 @Autowired**
+ 생성자, 메소드, 멤버변수 위에 모두 사용할 수 있다(대부분 멤버변수)
+ 스프링 컨테이너가 해당 변수의 타입을 체크하여 객체가 메모리에 존재하는지 확인 후 객체를 변수에 주입
+ 메모리에 없는 경우 `NoSuchBeanDefinitionException` 발생

```
// LgTV.java
@Component("tv")
public class LgTV implements TV {
    @Autowired
    private Speaker speaker;
    public LgTV() {
        System.out.println("===> LgTV 객체 생성");
    }
}
```

+ @Autowired 설정시 해당 클래스에는 의존성 주입에 사용했던 Setter 메소드나 생성자 필요 없음
+ 스프링 설정 파일에 `<context:component-scan/>` 외에는 설정할 필요 없음
+ 선언한 객체가 메모리에 없으면 에러가 발생하므로 생성 필요(XML 설정 or Annotation 설정)
```
// 1) XML 설정
<bean id="sony" class="polymorphism.SonySpeaker"></bean>

// 2) Annotation 설정
@Component("sony")
public class SonySpeaker implements Speaker {
    public SonySpeaker() {
        System.out.println("===> SonySpeaker 객체 생성");
    }
}
```

### **5.2.3 @Qualifier**
+ 의존성 주입 대상이 되는 동일 타입의 객체가 두 개 이상일 때 컨테이너는 어떤 객체를 할당할지 스스로 판단할 수 없어서 에러 발생
+ `@Qualifier` 어노테이션을 이용하여 의존성 주입될 객체의 아이디나 이름을 지정
```
// LgTV.java
@Component("tv")
public class LgTV implements TV {
    @Autowired
    @Qualifier("apple")
    private Speaker speaker;
    
    public LgTV() {
        System.out.println("===> LgTV 객체 생성");
    }
    ~생략~   
}
```

### **5.2.4 @Resource**
+ name 속성을 사용하여 스프링 컨테이너가 해당 이름으로 생성된 객체를 검색하여 의존성 주입 처리
```
// LgTV.java
import javax.annotation.Resource;

@Component("tv")
public class LgTV implements TV {
    @Resource(name="apple")
    private Speaker speaker;
    
    public LgTV() {
        System.out.println("===> LgTV 객체 생성");
    }
    ~생략~   
}
```

### **5.2.5 어노테이션과 XML 설정 병행하여 사용하기**
+ 어노테이션
  + XML 설정에 대한 부담이 없음
  + 자바 소스에 의존관계에 대한 정보가 들어있어 사용하기 편함
  + 의존성 주입할 객체의 이름이 자바 소스에 명시되어야 하므로 객체 변경시 자바 소스를 수정해야 함
  
+ XML
  + 자바 소스를 수정하지 않고 XML 파일 설정만 변경하면 실행되는 객체를 변경할 수 있어 유지보수가 편하다
  + 자바 소스에 의존관계와 관련된 어떤 메타메이터가 없으므로 XML 설정을 해석해야 의존성 주입되는 객체 확인 가능

+ 어노테이션과 XML 설정 병행
  + 클라이언트가 요청하는 부분은 `@Component` 어노테이션으로 처리, 의존성 주입하는 부분은 `@Autowired`로 처리
  + 변경될 객체 부분은 XML에서 수정
  + 라이브러리 형태로 제공되는 클래스는 반드시 XML 설정을 통해서만 사용 가능함
  
## 5.3 추가 어노테이션
+ 스프링 프레임워크의 시스템 구조에는 Controller, ServiceImpl, DAO 클래스 존재 
+ 모든 클래스에 @Component를 할당하면 어떤 클래스가 어떤 역할을 수행하는지 파악하기 어려움
+ @Component를 상속하는 어노테이션 제공

| Annotation | Location | Meaning |
| ---------- | ----------- | ----------- |
| @Service | XXXServiceImpl | 비즈니스 로직을 처리하는 Service 클래스 |
| @Repository | XXXDAO | 데이터베이스 연동을 처리하는 DAO 클래스 <br>DB 연동 과정에서 발생하는 예외를 변환해줌|
| @Controller | XXXController | 사용자 요청을 제어하는 Controller 클래스 <br>MVC 아키텍처에서 컨트롤러 객체로 인식하도록 해줌 |