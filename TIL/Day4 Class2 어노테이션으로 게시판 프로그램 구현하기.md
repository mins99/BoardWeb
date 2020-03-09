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

