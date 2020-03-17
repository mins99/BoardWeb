## 5.1 파일 업로드 처리
(1) 파일 업로드 입력 화면
+ 파일을 업로드 할 수 있게 만들기 위해서는 `<form>` 태그에 enctype 속성을 추가하고, 속성 값을 멀티파트 형식인 "multipart/form-data"로 지정해야 함.

(2) Command 객체 수정
+ BoardVO에 파일 업로드와 관련된 변수 private MultipartFile uploadFile; 를 추가한다

(3) FileUpload 라이브러리 추가
+ Apache에서 제공하는 Common FileUpload 라이브러리를 사용하여 파일 업로드를 처리하려면 pom.xml에 관련 dependency를 추가한다
```
// pom.xml

<!-- FileUpload -->
    <dependency>
        <groupId>commons-fileupload</groupId>
        <artifactId>commons.fileupload</artifactId>
        <version>1.3.1</version>
    </dependency>
```

(4) MultipartResolver 설정
+ 스프링 설정 파일인 presentation-layer.xml에 CommonsMultipartResolver Bean 등록한다. 아이디 값은 무조건 multipartResolver로 사용해야 한다.
```
// presentation-layer.xml

<!-- 파일 업로드 설정 -->
    <bean id="multipartResolver" class="org.springframework.web.multipart.commons.CommonsMultipartResolver">
        <property name="maxUploadSize" value="100000"></property>
    </bean>
```
+ setUploadFile() 메소드 호출시 매개변수인 MultipartFile 객체는 스프링 컨테이너에서 생성한다.

| Method | Description |
| ------- | ---------- |
| String getOriginalFilename() | 업로드한 파일명을 문자열로 리턴 |
| void transferTo(File destFile) | 업로드한 파일을 destFile에 저장 |
| boolean isEmpty() | 업로드한 파일 존재 여부 리턴 |

## 5.2 예외 처리
### **5.2.1 어노테이션 기반의 예외 처리**
+ 스프링에서는 `@Controller`와 `@ExceptionHandler` 어노테이션을 이용하여 컨트롤의 메소드 수행 중 발생하는 에외를 일괄적으로 처리할 수 있다.
+ presentation-layer.xml 파일에 mvc 네임 스페이스를 추가하고 `<mvc:annotation-driven>` 엘리먼트 설정
  + `<mvc:annotation-driven>` 엘리먼트를 설정해야 `@ExceptionHandler` 인식가능
+ CommonExceptionHandler.java
  + `@ControllerAdvice("com.springbook.view")` 선언에 의해 CommonExceptionHandler 객체 생성
  + "com.springbook.view" 패키지로 시작하는 컨트롤러에서 에외가 발생하는 순간 `@ExceptionHandler`으로 지정한 메소드가 실행
```
// CommonExceptionHandler.java

package com.springbook.biz.common;

@ControllerAdvice("com.springbook.view")
public class CommonExceptionHandler {
    ...
}

// presentation-layer.xml

<?xml version="1.0" encoding="UTF-8"?>
    <beans xmlns:mvc="http://www.springframework.org/schema/mvc"
        xsi:schemaLocation="http://springframework.org/schema/mvc http://www.springframework.org/schema/mvc/spring-mvc-4.2.xsd">
        
    <mvc:annotation-driven></mvc:annotation-driven>
```

### **5.2.2 XML 기반의 예외 처리**
+ 어노테이션 기반의 설정과 개념은 같지만 예외처리 클래스(CommonExceptionHandler.java)를 별도로 구현하지 않아도 되며
+ presentation-layer.xml 파일에 SimpleMappingExceptionResolver 클래스를 `<bean>` 등록하기만 하면 됨
```
// presentation-layer.xml

    <!-- 예외 처리 설정 -->
    <bean id="exceptionResolver" class="org.springframework.web.servlet.handler.SimpleMappingExceptionResolver">
        <property name="exceptionMappings">
            <props>
                <prop key="java.lang.ArithmeticException">
                    common/arithmeticError.jsp
                </prop>
                <prop key="java.lang.NullPointerException">
                    common/nullPointerError.jsp
                </prop>
            </props>
        </property>
        <property name="defaultErrorView" value="common/error.jsp"/>
    </bean>
```
