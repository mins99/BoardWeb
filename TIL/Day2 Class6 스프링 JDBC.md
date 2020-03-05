## 6.2 JdbcTemplate 클래스

-   GoF 디자인 패턴 중 템플릿 메소드 패턴이 적용된 클래스
-   템플릿 메소드 패턴 : 복잡하고 반복되는 알고리즘을 캡슐화해서 재사용하는 패턴

## 6.4 JdbcTemplate 메소드

### **6.4.1 update()**

```
// 1. SQL 구문에 설정된 "?" 수만큼 값들을 차례대로 나열
public void updateBoard(BoardVO vo) {
    String BOARD_UPDATE = "update board set title=?, content=?, where seq=?";
    int cnt = jdbcTemplate.update(BOARD_UPDATE, vo.getTitle(), vo.getContent(), vo.getSeq());

    System.out.println(cnt + "건 데이터 수정");
}

// 2. Object 배열 객체에 SQL 구문에 설정된 "?" 수만큼 값들을 세팅하여 배열 객체를 두 번째 인자로 전달
public void updateBoard(BoardVO vo) {
    String BOARD_UPDATE = "update board set title=?, content=?, where seq=?";
    Object[] args = { vo.getTitle(), vo.getContent(), vo.getSeq()};
    int cnt = jdbcTemplate.update(BOARD_UPDATE, args);

    System.out.println(cnt + "건 데이터 수정");
}
```

### **6.4.2 queryForInt()**

```
// 전체 게시글 수 조회
public int getBoardTotalCount(BoardVO vo) {
    String BOARD_TOT_COUNT = "select count(*) from board";
    int count = jdbcTemplate.queryForInt(BOARD_TOT_COUNT);

    System.out.println("전체 게시글 수 : " + count + "건);
}
```

### **6.4.3 queryForObject()**

-   select 구문의 실행 결과를 특정 자바 객체로 매핑하여 리턴
-   검색 결과가 없거나 두 개 이상인 경우 IncorrectResultSizeDataAccessException 발생
-   검색 결과를 자바 객체로 매핑할 RowMapper 객체 반드시 지정해야 함

```
// 글 상세 조회
public BoardVO getBoard(BoardVO vo) {
    String BOARD_GET = "select * from board where seq=?";
    Object[] args = { vo.getSeq() };
    return jdbcTemplate.queryForObject(BOARD_GET, args, new BoardRowMapper());
}
```

### **6.4.4 query()**

-   select 구문의 실행 결과가 목록일 때 사용

```
// 글 목록 조회
public List<BoardVO> getBoardList(BoardVO vo) {
    String BOARD_LIST = "select * from board order by seq desc";
    return jdbcTemplate.query(BOARD_LIST, new BoardRowMapper());
}
```

## 6.5 DAO 클래스 구현

### **6.5.1 첫 번째 방법 : JdbcDaoSupport 클래스 상속**

-   DAO 클래스를 구현할 때, JdbcDaoSupport 클래스를 부모 클래스로 지정하여 getJdbcTemplate() 상속 받아 JdbcTemplate 객체 구현
-   getJdbcTemplate() 메소드가 JdbcTemplate 객체를 리턴하려면 DataSource 객체가 필요 -> JdbcDaoSupport 클래스의 setDataSource() 메소드를 호출하여 객체 의존성 주입

### **6.5.2 두 번째 방법 : JdbcDaoSupport 클래스 Bean 등록, 의존성 주입**

-   JdbcTemplate 클래스를 bean 등록하고 의존성 주입으로 처리(Annotation)
-   일반적으로 사용하는 방법