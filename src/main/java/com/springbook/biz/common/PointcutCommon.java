package com.springbook.biz.common;

import org.aspectj.lang.annotation.*;
import org.springframework.stereotype.Service;

@Service
@Aspect
public class PointcutCommon {
	@Pointcut("execution(*com.springbook.biz..*Impl.*(..))")
	public void allPointcut(){}
	
	@Pointcut("execution(*com.springbook.biz..*Impl.get*(..))")
	public void getPointcut(){}
}
