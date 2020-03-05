## 7.1 트랜잭션 네임스페이스 등록
- 스프링에서는 트랜잭션 관련 설정을 AOP로 처리

## 7.2 트랜잭션 관리자 등록
- 데이터베이스 연동 기술에 따라 트랜잭션 관리자가 달라짐
- 모든 트랜잭션 관리자는 PlatformTransactionManager 인터페이스를 구현한 클래스들

## 7.3 트랜잭션 어드바이스 설정
- `<tx:advice>` 엘리먼트를 사용하여 설정
- 아래 소스코드는 get으로 시작하는 모든 메소드는 읽기 전용, 트랜잭션 관리 대상에서 제외하고 나머지는 트랜잭션 관리에 포함한다는 의미
```
<tx:advice id="txAdvice" transaction-manager="txManager">
    <tx:attributes>
        <tx:method name="get*" read-only="true"/>
        <tx:method name="*"/>
    </tx:attributes>	
</tx:advice>
```

## 7.4 AOP 설정을 통한 트랜잭션 적용
- aspect의 경우 어드바이스 메소드 이름을 알 수 없으므로 `<aop:advisor>` 사용