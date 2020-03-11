+ 스프링에서는 횡단 관심에 해당하는 어드바이스 메소드에게 클라이언트가 호출한 비즈니스 메소드의 이름이나 메소드가 속한 클래스, 패키지 정보등을 이용할 수 있도록 JoinPoint 인터페이스를 제공

## 4.1 JoinPoint 메소드
+ JoinPoint에서 제공하는 메소드

| Method | Description |
| ------------ | ----------------- |
| Signature getSignature() | 클라이언트가 호출한 메소드의 시그니처(리턴타입, 이름, 매개변수) 정보가 저장된 Signature 객체 리턴 |
| Object getTarget() | 클라이언트가 호출한 비즈니스 메소드를 포함하는 비즈니스 객체 리턴 |
| Object[] getArgs() | 클라이언트가 메소드를 호출할 때 넘겨준 인자 목록을 Object 배열 로 리턴 |

+ Signature가 제공하는 메소드

| Method | Description |
| ------------ | ----------------- |
| String getName() | 클라이언트가 호출한 메소드 이름 리턴 |
| String toLongString() | 클라이언트가 호출한 메소드의 리턴타입, 이름, 매개변수(시그니처)를 패키지 경로까지 포함 하여 리턴 |
| String toShortString() | 클라이언트가 호출한 메소드 시그니처를 축약한 문자열로 리턴 |

+ JoinPoint를 어드바이스 메소드 매개변수로 선언하면 클라이언트가 비즈니스 메소드 호출 시 스프링 컨테이너는 메소드 호출과 관련된 모든 정보를 JoinPoint 객체에 저장하고 인자로 넘겨준다

```
// LogAdvice.java

import org.aspectj.lang.JoinPoint;

public class LogAdvice {
    public void printLog(JoinPoint jp) {
        System.out.println("[공통 로그] 비즈니스 로직 수행 전 동작");
    }
}
```

## 4.2 Before 어드바이스
+ 호출된 메소드 시그니처만 알 수 있으면 비즈니스 메소드가 실행되기 전 동작할 로직 구현

```
// BeforeAdvice.java

import org.aspectj.lang.JoinPoint;

public class BeforeAdvice {
    public void beforeLog(JoinPoint jp) {       // 매개변수로 JoinPoint 선언
        String method = jp.getSignature().getName();    // getSignature 메소드로 클라이언트가 호출한 메소드 이름 출력
        Object[] args = jp.getArgs();                   // getArgs 메소드로 인자 목록을 Object 배열로 얻어냄
    
        System.out.println("[사전 처리] " + method + "() 메소드 ARGS 정보 : " + args[0].toString());
    }
}
```

## 4.3 After Returning 어드바이스
+ 비즈니스 메소드가 수행되고 나서, 리턴되는 결과 데이터에 따라 다양한 사후 처리 기능 구현
+ 바인드 변수 : 비즈니스 메소드가 리턴한 결과를 바인딩하는 목적의 변수. 리턴 타입을 알수 없으므로 Object로 선언. 해당 변수가 추가된 경우 반드시 매핑 설정을 스프링 파일에 추가해야 함
```
// AfterReturningAdvice.java

import org.aspectj.lang.JoinPoint;

public class AfterReturningAdvice {
    public void afterLog(JoinPoint jp, Object returnObj) {
        String method = jp.getSignature().getName();
        
        if(returnObj instanceof UserVO) {
            UserVO user = (UserVO) returnObj;
            
            if(user.getRole().equals("Admin")) {
                System.out.println(user.getName() + " 로그인(Admin)");
            }
        }
        
        System.out.println("[사후 처리] " + method + "() 메소드 리턴값 : " + returnObj.toString());
    }
}

// applicationContext.xml

<bean id="afterReturning" class="com.springbook.biz.common.AfterReturningAdvice"></bean>
<aop:config>
    <aop:pointcut id="getPointcut" expression="execution(* com.springbook.biz..*Impl.get*(..))" />
    <aop:aspect ref="afterReturning">
        <aop:after-returning pointcut-ref="getPointcut" method="afterLog" returning="returnObj" />
    </aop:aspect>
</aop:config>
```

## 4.4 After Throwing 어드바이스
+ 비즈니스 메소드가 수행되다가 예외가 발생할 때 동작하는 어드바이스
+ 비즈니스 메소드에서 발생한 예외 객체를 에외 클래스의 최상위 타입인 Exception으로 선언한 바인드 변수로 받음. 해당 변수가 추가된 경우 반드시 매핑 설정을 스프링 파일에 추가해야 함
+ exceptionLog 메소드 구현시 발생하는 예외 객체의 종류에 따라 다양하게 예외 처리 가능
```
// AfterThrowingAdvice.java

import org.aspectj.lang.JoinPoint;

public class AfterThrowingAdvice {
	public void exceptionLog(JoinPoint jp, Exception exceptObj) {
        String method = jp.getSignature().getName();
        System.out.println(method + "() 메소드 수행 중 예외 발생!");
        
        if(exceptObj instanceof IllegalArgumentException) {
            System.out.println("부적합한 값이 입력되었습니다.");
        } else if(exceptObj instanceof NumberFormatException) {
            System.out.println("숫자 형식의 값이 아닙니다.");
        } else if(exceptObj instanceof Exception) {
            System.out.println("문제가 발생했습니다.");
        }
	}
}

// applicationContext.xml

<bean id="afterThrowing" class="com.springbook.biz.common.AfterThrowingAdvice"></bean>
<aop:config>
    <aop:pointcut id="allPointcut" expression="execution(* com.springbook.biz..*Impl.*(..))" />
    <aop:aspect ref="afterThrowing">
        <aop:after-throwing pointcut-ref="allPointcut" method="exceptionLog" returning="exceptObj" />
    </aop:aspect>
</aop:config>
```

## 4.5 Around 어드바이스
+ 다른 어드바이스와 다르게 반드시 JoinPoint를 상속한 ProceedingJoinPoint 객체를 매개변수로 받음

```
// AroundAdvice.java

import org.aspectj.lang.ProceedingJoinPoint;

public class AroundAdvice {
	public Object aroundLog(ProceedingJoinPoint pjp) throws Throwable {
	    ...
    }
}
```