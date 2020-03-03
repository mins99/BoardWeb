## 5.1 어노테이션 기반 AOP 설정

### **5.1.1 어노테이션 사용을 위한 스프링 설정**

-   AOP를 어노테이션으로 설정하려면 스프링 설정파일에 `<aop:aspectj-autoproxy>` 엘리먼트 설정
-   스프링 설정파일에 등록을 하거나 @Service 어노테이션 사용하여 컴포넌트가 검색될 수 있도록 함
-   어드바이스 객체가 생성되어 있으면 어드바이스 클래스에서 선언된 어노테이션들을 스프링 컨테이너가 처리

### **5.1.2 포인트컷 설정**

-   XMl 설정시에는 `<aop:pointcut>` 엘리먼트 사용
-   어노테이션 설정시에는 `@Pointcut` 사용
    -   여러 개의 포인트컷 선언시 참조 메소드를 이용하여 식별
    -   참조 메소드 : 메소드 몸체가 비어있는, 구현 로직이 없는 메소드. 기능 처리를 목적으로 하지 않고 단순 포인트컷 식별 용도

```
// XML 설정에서 포인트컷 선언
<aop:config>
    <aop:pointcut id="allPointcut" expression="execution(* com.springbook.biz..*Impl.*(..))"/>
    <aop:pointcut id="getPointcut" expression="execution(* com.springbook.biz..*Impl.*(..))"/>
    <aop:aspect ref="log">
        <aop:before pointcut-ref="allPointcut" method="printLog"/>
    </aop:aspect>
</aop:config>
```

### **5.1.3 어드바이스 설정**

-   어드바이스 메소드가 언제 동작할지 결정과 관련된 어노테이션을 메소드 위에 설정
-   반드시 어드바이스 메소드가 결합될 포인트컷을 참조해야 함
    -   어드바이스 어노테이션 뒤에 괄호를 추가하고 포인트컷 참조 메소드를 지정

| Annotation | Description |
| --- | --- |
| @Before | 비즈니스 메소드 실행 전 동작 |
| @AfterReturning | 비즈니스 메소드가 성공적으로 리턴되면 동작 |
| @AfterThrowing | 비즈니스 메소드 실행 중 예외가 발생하면 동작 |
| @After | 비즈니스 메소드가 실행된 후 무조건 실행 |
| @Around | 비즈니스 메소드 실행 전 후에 처리할 로직 삽입 |

### **5.1.4 애스펙트 설정**

-   Aspect : Pointcut + Advice

---

## 5.2 어드바이스 동작 시점

-   AfterReturning : 비즈니스 메소드 수행 결과를 받아내기 위해 바인드 변수 지정 필요(returning 속성 사용)
-   Around : 어드바이스 메소드 중 유일하게 JoinPoint가 아닌 ProceedingJoinPoint 객체를 매개변수로 받음(proceed 메소드 이용을 위해)