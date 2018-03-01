package com.spring.mybatis.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping(value="/login")
public class LoginController {

	@RequestMapping(value="/index")
	public ModelAndView index(){
		ModelAndView mav = new ModelAndView("login");
		return mav;
	}

	@RequestMapping(value="/login")
	@ResponseBody
	public Map<String, Object> login(){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("statusCode", 200);
		return map;
	}

	@RequestMapping(value="/loginSuccess")
	public ModelAndView loginSuccess(){
		ModelAndView mav = new ModelAndView("index");
		return mav;
	}
}
