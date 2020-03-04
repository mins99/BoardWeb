## 4.1 의존성 관리

### **4.1.1 스프링의 의존성 관리 방법**
+ 스프링 프레임워크는 객체의 생성과 의존관계를 컨테이너가 자동으로 관리한다(IoC, 제어의 역행)
  + Dependency Lookup : 컨테이너가 애플리케이션 운용에 필요한 객체를 생성하고, 클라이언트는 컨테이너가 생성한 객체를 검색하여 사용하는 방식(사용안함)
  + Dependency Injection(DI) 
    + 컨테이너가 직접 객체 사이의 의존관계를 처리하는 것
    + 스프링 설정 파일 수정만으로 의존성 설정 변경 가능
    + Setter Injection, Constructor Injection
    
### **4.1.2 의존성 관계**
+ 의존성 관계 : 객체와 객체의 결합 관계

## 4.2 생성자 인젝션 이용하기
+ 생성자 인젝션(Constructor Injection) : 기본 생성자 말고 매개변수로 의존관계에 있는 객체의 주소 정보를 전달
```
// applicationContext.xml 
    <bean id="tv" class="polymorphism.SamsungTV">
        <constructor-arg ref="sony"></constructor-arg>
    </bean>
    
    <bean id="sony" class="polymorphism.SonySpeaker"></bean>
```

### **4.2.1 다중 변수 매핑**
+ 생성자가 여러 개 오버로딩 되어있을 때 index 속성을 사용하여 순서 지정 가능


## 4.3 Setter 인젝션 이용하기
+ Setter 인젝션 : Setter 메소드를 호출하여 의존성 주입을 처리하는 방법

### **4.3.1 Setter 인젝션 기본**
```
// SamsungTV.java
    public void setSpeaker(Speaker speaker) {
        System.out.println("---> setSpeaker() 호출");
        this.speaker = speaker;
    }
    public void setPrice(int price) {
        System.out.println("---> setPrice() 호출");
        this.price = price;
    }
```

```
// applicationContext.xml 
    <bean id="tv" class="polymorphism.SamsungTV">
        <property name="speaker" ref="apple"></property>
        <property name="price" value="3000000"></property>
    </bean>
    
    <bean id="sony" class="polymorphism.SonySpeaker"></bean>
```

### **4.3.2 p 네임스페이스 사용하기**
+ Setter 인젝션 설정시 p 네임스페이스를 이용하여 효율적으로 의존성 주입 처리 가능
+ 네임스페이스에 대한 별도의 schemaLocation이 없다.
```
// applicationContext.xml 
 <beans xmlns:p="http://www.springframework.org/schema/p">
    
    <bean id="tv" class="polymorphism.SamsungTV" p:speaker-ref="sony" p:price="3000000" />
    <bean id="sony" class="polymorphism.SonySpeaker"></bean>
 <beans>
```    


##4.4 컬렉션(Collection) 객체 설정
| Collection | Element |
| ------ | ----------- |
| java.util.List, Arrays | `<list>` |
| java.util.Set | `<set>` |
| java.util.Map | `<map>` |
| java.util.Properties | `<props>` |

### **4.4.1 List 타입 매핑**
```
// applicationContext.xml 
    <bean id="collectionBean" class="com.springbook.ioc.injection.CollectionBean">
        <property name="addressList">
            <list>
                <value>서울시 강남구 역삼동</value>
                <value>서울시 성동구 행당동</value>
            </list>
        </property>
    </bean>
```

### **4.4.2 Set 타입 매핑**
```
// applicationContext.xml 
    <bean id="collectionBean" class="com.springbook.ioc.injection.CollectionBean">
        <property name="addressList">
            <set value-type"java.lang.String">
                <value>서울시 강남구 역삼동</value>
                <value>서울시 성동구 행당동</value>
            </set>
        </property>
    </bean>
```

### **4.4.3 Map 타입 매핑**
```
// applicationContext.xml 
    <bean id="collectionBean" class="com.springbook.ioc.injection.CollectionBean">
        <property name="addressList">
            <map>
                <entry>
                    <key><value>김민석</value></key>
                    <value>서울시 강남구 역삼동</value>
                </entry>
                <entry>
                    <key><value>박지훈</value></key>
                    <value>서울시 성동구 행당동</value>
                </entry>
            </map>
        </property>
    </bean>
```

### **4.4.4 Properties 타입 매핑**
```
// applicationContext.xml 
    <bean id="collectionBean" class="com.springbook.ioc.injection.CollectionBean">
        <property name="addressList">
            <props>
                <prop key="김민석">서울시 강남구 역삼동</prop>
                <prop key="박지훈">서울시 성동구 행당동</prop>
            </props>
        </property>
    </bean>
```