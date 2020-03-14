+ 어드바이스(Advice) : 각 조인포인트에 삽입되어 동작할 횡단 관심에 해당하는 공통 기능. 동작 시점은 각 AOP 기술마다 다르며 스프링에서는 다섯 가지의 동작 시점을 제공

| Timing | Description |
| ------ | ------ |
| Before | 비지니스 메소드 실행 전 동작 |
| After  | After Returning: 비지니스 메소드가 성공적으로 리턴되면 동작 <br> After Throwing: 비지니스 메소드 실행 중 예외가 발생하면 동작 <br> After : 비지니스 메소드가 실행된 후 무조건 실행 | 
| Around | Around는 메소드 호출 자체를 가로채 비지니스 메소드 실행 전후에 처리할 로직을 삽입할 수 있음 |

+ 어드바이스 메소드의 동작 시점은 `<aop:aspect>` 엘리먼트 하위에 각각 `<aop:before>`, `<aop:after-returning>`, `<aop:after-throwing>`, `<aop:after>`, `<aop:around>` 엘리먼트를 이용하여 지정

## 3.1 Before 어드바이스
+ 포인트컷으로 지정된 메소드 호출 시, 메소드가 실행되기 전에 처리될 내용들을 기술하기 위해 사용

```
// BeforeAdvice.java

package com.springbook.biz.common;

public class BeforeAdvice {
    public void beforeLog() {
        System.out.println("[사전 처리] 비즈니스 로직 수행 전 동작");
    }
}

// applicationContext.xml

<bean id="before" class="com.springbook.biz.common.BeforeAdvice"/>

<aop:config>
    <aop:pointcut id="allPointcut" expression="execution(* com.springbook.biz..*Impl.*(..))" />
    
    <aop:aspect ref="before">
        <aop:before pointcut-ref="allPointcut" method="beforeLog"/>
    </aop:aspect>
</aop:config>
```

<img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fk.kakaocdn.net%2Fdn%2FIc2M7%2FbtqCLdnFAne%2FItLkOuQWGfV3q0t1k0rgiK%2Fimg.png" width="500">

## 3.2 After Returning 어드바이스
+ 포인트컷으로 지정된 메소드가 정상적으로 실행되고 나서, 메소드 수행 결과로 생성된 데이터를 리턴하는 시점에 동작

```
// AfterReturningAdvice.java

package com.springbook.biz.common;

public class AfterReturningAdvice {
    public void afterLog() {
        System.out.println("[사후 처리] 비즈니스 로직 수행 후 동작");
    }
}

// applicationContext.xml

<bean id="afterReturning" class="com.springbook.biz.common.AfterReturningAdvice"/>

<aop:config>
    <aop:pointcut id="getPointcut" expression="execution(*com.springbook.biz..*Impl.get*(..))" />
    
    <aop:aspect ref="afterReturning">
        <aop:after-returning pointcut-ref="getPointcut" method="afterLog"/>
    </aop:aspect>
</aop:config>
```

<img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fk.kakaocdn.net%2Fdn%2Fba0KJu%2FbtqCJlzZMgU%2FvwMMw3wB8Oh0K6cLUogfIK%2Fimg.png" width="500">

## 3.3 After Throwing 어드바이스
+ 포인트컷으로 지정한 메소드가 실행되다가 예외가 발생하는 시점에 동작

```
// AfterThrowingAdvice.java

package com.springbook.biz.common;

public class AfterThrowingAdvice {
    public void exceptionLog() {
        System.out.println("[예외 처리] 비즈니스 로직 수행 중 예외 동작");
    }
}

// applicationContext.xml

<bean id="afterThrowing" class="com.springbook.biz.common.AfterThrowingAdvice"/>

<aop:config>
    <aop:pointcut id="allPointcut" expression="execution(* com.springbook.biz..*Impl.*(..))" />
    
    <aop:aspect ref="afterThrowing">
        <aop:after-throwing pointcut-ref="allPointcut" method="exceptionLog"/>
    </aop:aspect>
</aop:config>
```

<img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fk.kakaocdn.net%2Fdn%2FbwOheJ%2FbtqCKzR3kFl%2FZOH4cM78ntS1KrjF5Gz3Bk%2Fimg.png" width="500">

## 3.4 After 어드바이스
+ try-catch-finally 구문에서 finally 블록처럼 예외 발생 여부에 상관없이 무조건 수행되는 어드바이스를 등록할 때 사용

```
// AfterAdvice.java

package com.springbook.biz.common;

public class AfterAdvice {
    public void finallyLog() {
        System.out.println("[사후 처리] 비즈니스 로직 수행 후 무조건 동작");
    }
}

// applicationContext.xml

<bean id="after" class="com.springbook.biz.common.AfterAdvice"/>

<aop:config>
    <aop:pointcut id="allPointcut" expression="execution(* com.springbook.biz..*Impl.*(..))" />
    
    <aop:aspect ref="after">
        <aop:after pointcut-ref="allPointcut" method="finallyLog"/>
    </aop:aspect>
</aop:config>
```

<img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fk.kakaocdn.net%2Fdn%2F2tc8s%2FbtqCLcWCfMQ%2FjhyxU1F1ZA954EMs58O4Nk%2Fimg.png" width="500">

## 3.5 Around 어드바이스
+ 하나의 어드바이스가 비즈니스 메소드 실행 전과 후에 모두 동작하여 로직을 처리할 때 사용
+ 클라이언트의 메소드 호출을 가로채 사전 처리 로직을 수행하고, 비즈니스 메소드가 모두 실행되고 나서 사후 처리 로직을 수행함

```
// AroundAdvice.java

package com.springbook.biz.common;

import org.aspectj.lang.ProceedingJoinPoint;

public class AroundAdvice {
    public Object aroundLog(ProceedingJoinPoint pjp) throws Throwable {
        System.out.println("[BEFORE]: 비즈니스 메소드 수행 전에 처리할 내용...");
        Object returnObj = pjp.proceed();
        System.out.println("[AFTER]: 비즈니스 메소드 수행 후에 처리할 내용...");
        
        return retrunObj;
    }
}

// applicationContext.xml

<bean id="around" class="com.springbook.biz.common.AroundAdvice"/>

<aop:config>
    <aop:pointcut id="allPointcut" expression="execution(* com.springbook.biz..*Impl.*(..))" />
    
    <aop:aspect ref="around">
        <aop:around pointcut-ref="allPointcut" method="aroundLog"/>
    </aop:aspect>
</aop:config>
```

<img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fk.kakaocdn.net%2Fdn%2FwyHWJ%2FbtqCLetmu6t%2FxKWdSNiQh3Yvf85cTMcE8k%2Fimg.png" width="800">