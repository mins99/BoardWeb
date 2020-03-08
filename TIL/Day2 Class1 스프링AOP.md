+ 비즈니스 컴포넌트 개발에서 가장 중요한 원칙 : 낮은 결합도, 높은 응집도
+ 스프링의 의존성 주입(Dependency Injection, DI) 이용하면 비즈니스 컴포넌트 객체들의 결합도를 떨어트려 의존관계 쉽게 변경 가능
+ IoC는 결합도와 관련된 기능, AOP(Aspect Oriented Programming)는 응집도와 관련된 기능



## 1.1 AOP 이해하기
+ 로깅, 예외, 트랜잭션 처리 등의 부가적인 코드로 인해 메소드의 복잡도가 증가함
+ 횡단 관심(Crosscutting Concerns) : 메소드마다 공통으로 등장하는 로깅이나 예외, 트랜잭션 처리 같은 코드들
+ 핵심 관심(Core Concerns) : 사용자의 요청에 따라 실제로 수행되는 핵심 비즈니스 로직
+ 관심 분리(Separation of Concerns) : 횡단 관심을 분리하여 간결하고 응집도 높은 코드 유지
<br><br>
+ BoardService 컴포넌트의 모든 비즈니스 메소드가 실행되기 직전에 공통으로 처리할 로직을 LogAdvice 클래스에 printLog() 메소드로 구현
  + BoardServiceImpl 클래스와 LogAdvice 객체가 소스코드에서 강하게 결합되어 있어서 LogAdvice를 변경하거나 printLog() 메소드의 시그니처가 변경되는 사항에서는 유연하게 대처할 수 없다.
```
// LogAdvice.java
package com.springbook.biz.common;

public class LogAdvice {
    public void printLog() {
        System.out.println("[공통 로그] 비지니스 로직 수행 전 동작");
    }
}

// BoardServiceImpl.java
package com.springbook.biz.board.impl;

import com.springbook.biz.common.LogAdvice;

@Service("boardService")
public class BoardServiceImpl implements BoardService {
    private LogAdvice log;
    
    public BoardServiceImpl() {
        log = new LogAdvice();
    }
    
    public void insertBoard(BoardVO vo) {
        log.printLog();
        boardDAO.insertBoard(vo);
    }
}
```

## 1.2 AOP 시작하기
+ 스프링의 AOP를 이용하여 핵심 관심과 횡단 관심을 분리
### **1.2.2 AOP 라이브러리 추가**
```
// pom.xml
    <!-- AspectJ -->
    <dependency>
        <groupId>org.aspectj</groupId>
        <artifactId>aspectjrt</artifactId>
        <version>${org.aspectj-version}</version>
    </dependency>	
    <dependency>
        <groupId>org.aspectj</groupId>
        <artifactId>aspectjweaver</artifactId>
        <version>1.8.8</version>
    </dependency>
```

### **1.2.3 네임스페이스 추가 및 AOP 설정**
+ 스프링의 AOP는 클라이언트가 핵심 관심에 해당하는 비즈니스 메소드를 호출할 때, 횡단 관심에 해당하는 메소드를 적절하게 실행해준다
+ 핵심 관심 메소드와 횡단 관심 메소드 사이에서 소스상의 결합은 발생하지 않음
```
// applicationContext.xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:context="http://www.springframework.org/schema/context"
	xmlns:aop="http://www.springframework.org/schema/aop"
	xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
		http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-4.2.xsd
		http://www.springframework.org/schema/aop http://www.springframework.org/schema/aop/spring-aop-4.2.xsd">
		
    <aop:config>
        <aop:pointcut id="allPointcut" expression="execution(* com.springbook.biz..*Impl.*(..))"/>
        <aop:aspect ref="log">
            <aop:after pointcut-ref="allPointcut" method="printLog"/>
        </aop:aspect>
    </aop:config>
```