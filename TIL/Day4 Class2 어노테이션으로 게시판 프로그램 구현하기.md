## 2.9 요청 방식에 따른 처리

### **2.9.1 method 속성**
+ `@RequestMapping`의 method 속성을 이용하면 클라이언트의 요청 방식(GET/POST)에 따라 수행될 메소드를 다르게 설정할 수 있다

```
// LoginController.java

@Controller
public class LoginController {
	
	@RequestMapping(value="/login.do", method=RequestMethod.GET)
	public String loginView(UserVO vo) {
		System.out.println("로그인 화면으로 이동");
		vo.setId("test");
		vo.setPassword("1234");
		return "login.jsp";
	}
	
	@RequestMapping(value="/login.do", method=RequestMethod.POST)
	public String login(UserVO vo, UserDAO userDAO) {
		System.out.println("로그인 인증 처리...");
		if(userDAO.getUser(vo) != null)
			return "getBoardList.do";
		else
			return "login.jsp";
	}
}
```

### **2.9.3 @ModelAttribute 사용**
+ 스프링 컨테이너가 생성하는 Command 객체의 이름은 클래스 이름의 첫 글자를 소문자로 변경한 이름이 자동으로 설정된다
+ Command 객체의 이름을 변경하려면 `@ModelAttribute`를 사용해야함

```
// LoginController.java

@Controller
public class LoginController {
	
	@RequestMapping(value="/login.do", method=RequestMethod.GET)
	public String loginView(@ModelAttribute("user") UserVO vo) {
		System.out.println("로그인 화면으로 이동");
		vo.setId("test");
		vo.setPassword("1234");
		return "login.jsp";
	}
}

// login.jsp
<tr>
    <td bgcolor="orange">아이디</td>
    <td><input type="text" name="id" value="${user.id }"/></td>
</tr>
<tr>
    <td bgcolor="orange">비밀번호</td>
    <td><input type="password" name="password" value="${user.password } "/></td>
</tr>
```

## 2.10 Servlet API 사용
+ 스프링 MVC에서는 Controller 메소드 매개변수로 다양한 Servlet API를 사용할 수 있도록 지원(HttpServletRequest, Command...)

## 2.11 Controller의 리턴타입
+ Controller 메소드 정의시, 리턴타입은 마음대로 결정 가능(String, ModelAndView...)

## 2.12 기타 어노테이션
### **2.12.1 @RequestParam 사용하기**
+ `@RequestParam` : Command 클래스에 없는 파라미터 정보를 추출할 수 있는 기능 제공
  + value : 화면으로부터 전달될 파라미터 이름
  + defaultValue : 화면으로부터 전달될 파라미터 정보가 없을 때, 설정할 기본값
  + required : 파라미터의 생략 여부
+ `@RequestParam` 대신 VO 클래스에 Getter/Setter를 추가하는 방법도 가능

```
// getBoardList.jsp

<form action="getBoardList.jsp" method="post">
    <table border="1" cellpadding="0" cellspacing="0" width="700">
        <tr>
            <td align="right"><select name="searchCondition">
                    <option value="TITLE">제목
                    <option value="CONTENT">내용
            </select> <input name="searchKeyword" type="text" /> <input type="submit"
                value="검색" /></td>
        </tr>
    </table>
</form>

// BoardController.java

// 글 목록 검색
@RequestMapping("/getBoardList.do")
public String getBoardList(@RequestParam(value="searchCondition", defaultValue="TITLE", required=false) String condition,
                           @RequestParam(value="searchKeyword", defaultValue="", required=false) String keyword,
                           BoardVO vo, BoardDAO boardDAO, Model model) {
    System.out.println("검색 조건 : " + condition);
    System.out.println("검색 단어" + keyword);
    model.addAttribute("boardList", boardDAO.getBoardList(vo));		// Model 정보 저장
    return "getBoardList.jsp";
}
```

### **2.12.2 @ModelAttribute 사용하기**
+ `@ModelAttribute` : Command 객체의 이름을 변경하거나 View(jsp)에서 사용할 데이터를 설정하는 용도로 사용
+ `@RequestParam`이 선언된 메소드보다 먼저 호출되고, 실행 결과로 리턴된 객체는 자동으로 Model에 저장되어 View 페이지에서 사용 가능

```
// BoardController.java

// 검색 조건 목록 설정
@ModelAttribute("conditionMap")
public Map<String, String> searchConditionMap() {
    Map<String, String> conditionMap = new HashMap<String, String>();
    conditionMap.put("제목", "TITLE");
    conditionMap.put("내용", "CONTENT");
    return conditionMap;
}
```

### **2.12.3 @SessionAttribute 사용하기**
+ `@SessionAttribute` : 수정 작업을 처리할 때, Model에 해당 이름으로 저장되는 데이터가 있다면 그 데이터를 세션(HttpSession)에도 자동으로 저장하는 설정
```
// BoardController.java

@Controller
@SessionAttributes("board")
public class BoardController {
	// 글 수정
	@RequestMapping("/updateBoard.do")
	public String updateBoard(@ModelAttribute("board") BoardVO vo, BoardDAO boardDAO) {
		System.out.println("번호 : " + vo.getSeq());
		System.out.println("제목 : " + vo.getTitle());
		System.out.println("작성자 : " + vo.getWriter());
		System.out.println("내용 : " + vo.getContent());
		System.out.println("등록일 : " + vo.getRegDate());
		System.out.println("조회수 : " + vo.getCnt());
		boardDAO.updateBoard(vo);
		return "getBoardList.do";
	}
}
```