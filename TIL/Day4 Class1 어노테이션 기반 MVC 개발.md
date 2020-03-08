+ 스프링은 어노테이션 기반 설정을 제공하여 과도한 XML 설정으로 인한 문제를 해결함

## 1.1 어노테이션 관련 설정
+ `<bean>` 루트 엘리먼트에 context 네임스페이스를 추가
+ HandlerMapping, Controller, ViewResolver 클래스에 대한 `<bean>` 등록을 모두 삭제하고 `<context:component-scan>` 엘리먼트로 대체
```
//presentation-layer.xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:context="http://www.springframework.org/schema/context"
	xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
		http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-4.2.xsd">

    <!-- base-package 속성에 "com.springbook.view"를 등록하여 모든 Controller 클래스가 스캔 범위에 포함되도록 함 -->
    <context:component-scan base-package="com.springbook.view"></context:component-scan>
</beans>
```
+ 어노테이션 활용에 집중하기 위해 스프링 설정 파일에 등록한 ViewResolver 설정 삭제
  + 기존 webapp/WEB-INF/board에 있던 getBoard.jsp, getBoardList.jsp 파일 위치를 webapp 으로 이동

## 1.2 @Controller 사용하기
+ Controller 클래스를 생성하려면 스프링 설정 파일에 `<bean>` 등록할 필요 없이 클래스 선언부 위에 `@Controller`를 붙이면 됨
  + `<context:component-scan>`으로 스프링 컨테이너가 컨트롤러 객체들을 자동으로 생성하기 때문
+ `@Component`를 상속한 `@Controller`는 `@Controller`가 붙은 클래스의 객체를 메모리에 생성하고 DispatcherServlet이 인식하는 Controller 객체로 만들어줌
+ `@Controller` 어노테이션을 사용하면 스프링 프레임워크가 지향하는 POJO(Plain Old Java Object) 스타일의 클래스로 구현 가능

## 1.3 @RequestMapping 사용하기
+ 기존에는 HandlerMapping을 이용하여 클라이언트의 요청을 매핑했다면 스프링에서는 `@RequestMapping` 어노테이션을 이용하여 설정을 대신함

## 1.4 클라이언트 요청 처리
+ 기존에는 정보를 HttpServletRequest의 getParameter() 메소드를 사용하여 추출
  + 사용자가 입력하는 정보가 많거나 변경되는 상황에는 소스코드가 길어지고 수정되어야 하는 번거로움이 있음
+ 메소드의 매개변수로 사용자가 입력한 값을 매핑할 VO 클래스를 선언하면 스프링 컨테이너가 메소드를 실행할때 Command 객체를 생성, 입력한 값을 세팅해서 넘겨준다
```
// InsertBoardController.java
package com.springbook.view.board;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.springbook.biz.board.BoardVO;
import com.springbook.biz.board.impl.BoardDAO;

// Controller 선언
@Controller
public class InsertBoardController {
	
	// 클라이언트로 부터 'insertBoard.do' 요청이 있을때 insertBoard 메소드를 매핑하겠다는 설정
	@RequestMapping(value="insertBoard.do")
	public void insertBoard(BoardVO vo) {       // 매개변수와 매핑한 값들을 BoardVO에 저장
		System.out.println("글 등록 처리");
		
		BoardDAO boardDAO = new BoardDAO();
		boardDAO.insertBoard(vo);
	}
}
```