package com.spring.mybatis.utils;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

public class RequestInterceptor implements HandlerInterceptor {
	
	private final static String USER_KEY = "user";

	@Override
	public boolean preHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler) throws Exception {
		System.out.println("====拦截前===="+request.getRequestURI());
		HttpSession session = request.getSession();
		//判断session中是否存在用户信息
		Object user = session.getAttribute(USER_KEY);
		//判断是否登录或者登录超时
		if(null == user){
	        if (request.getHeader("x-requested-with") != null  
	                && request.getHeader("x-requested-with").equalsIgnoreCase("XMLHttpRequest")) { // ajax 超时处理  
	            response.setHeader("sessionstatus", "timeout");  
	            return false;
	        }else { // http 超时处理  
				System.out.println("====超时处理===="+request.getContextPath());
				String url = request.getContextPath()+"/login/index";  
				response.setContentType("text/html;charset=utf-8");
				PrintWriter out = response.getWriter();  
		        out.println("<html>");   
		        out.println("<script>");  
		        out.print("alert('登入超时,系统将自动跳转到登陆页面,请重新登入!');");
		        out.println("window.open ('"+url+"','_parent');"); //作为父窗口打开  
		        out.println("</script>");   
		        out.println("</html>");
//	            response.sendRedirect(request.getContextPath() + "/login/index");  
	        }  
			session.setAttribute(USER_KEY, "1111");
	        return false;
		}else{
			System.out.println("=====已登录===登录信息："+(String)user);
		}
		return true;
	}

	@Override
	public void postHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		System.out.println("====拦截中====");
	}

	@Override
	public void afterCompletion(HttpServletRequest request,
			HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		System.out.println("====拦截后====");
	}

}
