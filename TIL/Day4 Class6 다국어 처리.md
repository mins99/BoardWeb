## 6.1 메시지 파일 작성하기
+ 다국어 지원 : 하나의 페이지를 다양한 언어로 서비스 하는 것
+ 사용자가 원하는 언어로 메시지를 출력하려면 각 언어에 따른 메시지 파일을 작성해야 함
+ 기본적으로 '.properties' 확장자를 사용

## 6.2 MessageSource 등록
+ 언어별로 메시지 파일 작성 후에는 스프링 설정 파일에 메시지 파일들을 읽어 들이는 MessageSource 클래스를 `<bean>` 등록한다
+ ResourceBundleMessageSource 클래스 `<bean>` 등록시에는 id를 "messageSource"로 고정
+ value에는 현재 '.properties' 확장자가 아니라 파일명이 properties인 경우에 대해 처리하기 위해 확장자 앞의 파일 경로까지만 지정한다
```
// presentation-layer.xml

    <!-- 다국어 설정 -->
    <bean id="messageSource" class="org.springframework.context.support.ResourceBundleMessageSource">
        <property name="basenames">
            <list>
                <value>message.message</value>
            </list>
        </property>
    </bean>
```

## 6.3 LocaleResolver 등록
+ 웹브라우저가 서버에 요청하면 브라우저의 locale 정보가 HTTP 요청 메시지 헤더에 자동으로 설정되어 전송된다.
+ 이 때 스프링은 LocaleResolver를 통해 클라이언트의 locale 정보를 추출해 해당하는 언어의 메시지를 적용한다.

| LocaleResolver | Description |
| -------------- | ----------- |
| AcceptHeaderLocaleResolver | 브라우저에서 전송된 HTTP 요청 헤더에서 <br> Accept-Language에 설정된 Locale로 <br> 메시지를 적용한다. |
| CookieLocaleResolver | Cookie에 저장된 Locale 정보를 추출하여 <br>메시지를 적용한다. |
| SessionLocaleResolver | HttpSession에 저장된 Locale 정보를 추출하여 <br> 메시지를 적용한다. |
| FixedLocaleResolver | 웹 요청과 무관하게 특정 Locale로 고정한다. |

+ 스프링에서는 세션으로 Locale 정보를 추출하고 유지하는 SessionLocaleResolver 를 가장 많이 사용함
+ SessionLocaleResolver의 id는 "localeResolver"로 고정
```
// presentation-layer.xml

    <!-- LocaleResolver 등록 -->
    <bean id="localeResolver" class="org.springframework.web.servlet.i18n.SessionLocaleResolver"></bean>
```
