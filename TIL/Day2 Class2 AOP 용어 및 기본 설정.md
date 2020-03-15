## 2.1 AOP 용어 정리

### **2.1.1 조인포인트(Joinpoint)**
- 클라이언트가 호출하는 모든 비즈니스 메소드(~ServiceImpl.java)
- 조인포인트 중에서 포인트컷이 선택되기 때문에 포인트컷 대상 또는 포인트컷 후보 라고도 함

### **2.1.2 포인트컷(Pointcut)**
- 필터링된 조인포인트
- 비즈니스 메소드 중에서 원하는 특정 메소드에서만 횡단 관심에 해당하는 공통 기능을 수행시키기 위해 필요
- 메소드가 포함된 클래스, 패키지, 메소드 시그니처까지 정확하게 지정 가능
- `<aop:pointcut>` 엘리먼트로 선언하고 id 속성으로 포인트컷을 식별하기 위한 유일한 문자열을 선언
<br><img src="https://t1.daumcdn.net/cfile/tistory/175FBB1049E397CE07" width="500">

### **2.1.3 어드바이스(Advice)**
- 횡단 관심에 해당하는 공통 기능의 코드. 독립된 클래스의 메소드로 작성함.
+ 어드바이스로 구현된 메소드가 언제 동작할지 스프링 설정파일을 통해 지정할 수 있다.

### **2.1.4 위빙(Weaving)**
+ 포인트컷으로 지정한 핵심 관심 메소드가 호출될 때, 어드바이스에 해당하는 횡단 관심 메소드가 삽입되는 과정을 의미
+ 비즈니스 메소드를 수정하지 않고도 횡단 관심에 해당하는 기능을 추가하거나 변경 가능
+ 스프링에서는 런타임(Runtime) 위빙 지원
<br><img src="http://mblogthumb2.phinf.naver.net/20160423_37/tlsdlf5_1461397164414fJARX_PNG/042316_0739_SpringAOP3.png?type=w2">

### **2.1.5 애스펙트(Aspect) 또는 어드바이저(Advisor)**
+ Aspect : AOP의 핵심. 포인트컷과 어드바이스의 결합. 포인트컷 메소드에 대해 어떤 어드바이스 메소드를 실행할지 결정
+ Aspect 실행순서
  1) applicationContext.xml에서 pointcut id로 설정한 메소드(getPointcut)가 호출
  2) aspect ref 데이터에 해당하는 어드바이스 객체(LogAdvice)의 method가 실행되며(printLog)
  3) 해당 메소드의 설정(`<aop:before>`)에 따라 동작시점이 정해짐
  
```
// applicationContext.xml

<bean id="log" class="com.springbook.biz.common.LogAdvice"></bean>

<aop:config>
    <aop:pointcut expression="execution(* com.springbook.biz..*Impl.*(..))" id="allPointcut"/>
    <aop:pointcut expression="execution(* com.springbook.biz..*Impl.get*(..))" id="getPointcut"/>
    <aop:aspect ref="log">
        <aop:before pointcut-ref="getPointcut" method="printLog"/>
    </aop:aspect>
</aop:config>
```

+ 트랜잭션 설정에서는 `<aop:advisor>` 사용

### **2.1.6 AOP 용어 종합**

<img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fk.kakaocdn.net%2Fdn%2FbWBKfN%2FbtqCIEUlWce%2F2uBpWbCmz1jeGiwUqyJj5k%2Fimg.png">

1) 사용자는 시스템을 사용하면서 자연스럽게 비즈니스 컴포넌트의 여러 Joinpoint를 호출
2) 이 때 특정 Pointcut으로 지정한 메소드가 호출
3) Advice 객체의 Advice 메소드가 실행
4) Pointcut으로 지정한 메소드가 호출될 때 Advice 메소드를 삽입하도록 하는 설정을 Aspect 라고 하며
5) Aspect 설정에 따라 Weaving이 처리됨

<br><img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fk.kakaocdn.net%2Fdn%2F9v4Yp%2FbtqCJl1fDvX%2FZ4fvkf2Kl5oSrbkCCYCrMK%2Fimg.png" width="500">

## 2.2 AOP 엘리먼트
### **2.2.1 `<aop:config>` 엘리먼트**
+ 루트 엘리먼트로 여러번 사용 가능하고 하위에는 `<aop:pointcut>`, `<aop:aspect>` 엘리먼트가 위치

### **2.2.2 `<aop:pointcut>` 엘리먼트**
+ 포인트컷을 지정하기 위해 사용. `<aop:config>`의 자식이나 `<aop:aspect>` 자식으로 사용 가능
+ 여러 개 정의할 수 있으며, 유일한 아이디를 할당하여 애스팩트를 설정할 때 포인트컷을 참조하는 용도로 사용

### **2.2.3 `<aop:aspect>` 엘리먼트**
+ 핵심 관심에 해당하는 포인트컷 메소드와 횡단 관심에 해당하는 어드바이스 메소드를 결합하기 위해 사용
+ aspect 설정에 따라 weaving 결과가 달라지므로 AOP에서 가장 중요한 설정

### **2.2.4 `<aop:advisor>` 엘리먼트**
+ 포인트컷과 어드바이스를 결합한다는 점은 aspect와 같지만 트랜잭션 설정시에는 advisor를 사용
+ aspect 에서는 객체의 id를 모르거나 메소드 이름을 확인할 수 없을 때 설정이 불가능하지만, advisor 사용시에는 스프링 컨테이너가 설정 파일에 등록된 `<tx:advice>` 엘리먼트를 해석하여 트랜잭션 관리 기능의 어드바이스 객체를 메모리에 생성

```
// applicationContext.xml

<bean id="txManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
   <property name="dataSource" ref="dataSource"></property>
</bean>

<tx:advice id="txAdvice" transaction-manager="txManager">
    <tx:attributes>
        <tx:method name="get*" read-only="true"/>
        <tx:method name="*"/>
    </tx:attributes>	
</tx:advice>

<aop:config>
    <aop:pointcut id="allPointcut" expression="execution(* com.springbook.biz..*(..))"/>
    <aop:advisor pointcut-ref="allPointcut" advice-ref="txAdvice"/>
</aop:config>
```

## 2.3 포인트컷 표현식
+ 포인트컷을 이용하면 어드바이스 메소드가 적용될 비즈니스 메소드를 정확하게 필터링 가능
<br><img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fk.kakaocdn.net%2Fdn%2F9v4Yp%2FbtqCJl1fDvX%2FZ4fvkf2Kl5oSrbkCCYCrMK%2Fimg.png" width="500">

1. 리턴타입 지정 : 가장 기본적인 방법은 '*' 캐릭터를 이용하는 것
2. 패키지 지정 : 패키지 경로를 지정할 때는 '*', '..' 캐릭터를 이용한다
3. 클래스 지정 : 클래스 이름을 지정할 때는 '*', '+' 캐릭터를 이용한다
4. 메소드 지정 : 메소드를 지정할 때는 주로 '*' 캐릭터를 사용하고 매개변수를 지정할 때는 '..'을 사용한다
5. 매개변수를 지정할 때는 '..', '*' 캐릭터를 사용하거나 정확한 타입을 지정한다