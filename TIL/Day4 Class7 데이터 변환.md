## 7.1 JSON으로 변환하기
+ JSON(Javascript Object Notation) : 데이터 교환 포맷. XML을 대체해서 많이 사용된다.

### **7.1.1 Jackson2 라이브러리 내려받기**
+ JSON 사용을 위해 pom.xml에 jackson2 라이브러리와 관련한 dependency를 추가한다
```
// pom.xml

    <!-- Jackson2 -->
    <dependency>
        <groupId>com.fasterxml.jackson.core</groupId>
        <artifactId>jackson-databind</artifactId>
        <version>2.7.2</version>
    </dependency>
```

### **7.1.2 HttpMessageConverter 등록**
+ 브라우저에서 서블릿이나 JSP 파일을 요청하면, 서버는 클라이언트가 요청한 서블릿이나 JSP를 찾아서 실행하고 Http 응답 프로토콜 메시지 바디에 저장하여 브라우저에 전송함
+ 응답 결과를 JSON이나 XML로 변환하여 메시지 바디에 저장하려면 스프링에서 제공하는 변환기(Converter)를 사용해야 함
+ presentation-layer.xml에 관련 설정을 추가한다
```
// presentation-layer.xml

    <mvc:annotation-driven></mvc:annotation-driven>
```

### **7.1.4 실행 결과 확인**
+ `@JsonIgnore` : 자바 객체를 JSON으로 변환할 때, 특정 변수를 변환에서 제외시키는 어노테이션. VO 클래스의 Getter 메소드 위에 설정함
```java
// BoardVO.java

import com.fasterxml.jackson.annotation.JsonIgnore;

public class BoardVO {

    @JsonIgnore
    public String getSearchCondition() {
        return searchCondition;
    }
}
```