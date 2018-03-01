package com.spring.mybatis.controller;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.mybatis.entity.People;
import com.spring.mybatis.service.PeopleService;
import com.spring.mybatis.utils.Page;

@Controller
@RequestMapping(value="/people")
public class PeopleController{
	
	@Resource(name="peopleService")
	private PeopleService peopleService;

	@RequestMapping(value="/index")
	public ModelAndView index(){
		ModelAndView mav = new ModelAndView("/people/peopleIndex");
		return mav;
	}

	@RequestMapping(value="/list")
	@ResponseBody
	public Map<String, Object> list(Integer page, Integer limit, String searchName){
		Map<String,Object> map = new HashMap<String,Object>();
		boolean flag = true;
		try {
			People p = new People();
			p.setName(searchName);
			p.setOpera("-1");
			Page<People> pp = peopleService.pageList(page, limit, p);
			map.put("code", 0);
			map.put("count", pp.getTotalRecord());
			map.put("data", pp.getResults());
		} catch (Exception e) {
			flag = false;
			map.put("code", 0);
			map.put("count", 0);
			map.put("data", null);
			e.printStackTrace();
		}
		map.put("success", flag);
		return map;
	}

	@RequestMapping(value="/detail")
	public ModelAndView detail(Integer id){
		ModelAndView mav = new ModelAndView("/people/peopleEdit");
		if(null != id){
			People p = peopleService.findById(id);
			mav.addObject("bean", p);
		}
		return mav;
	}

	@RequestMapping(value="/save")
	@ResponseBody
	public Map<String, Object> save(People bean){
		Map<String, Object> map = new HashMap<String, Object>();
		boolean flag = true;
		try {
			if(null != bean.getId()){//修改
				People oldBean = peopleService.findById(bean.getId());
				oldBean.setAge(bean.getAge());
				oldBean.setName(bean.getName());
				oldBean.setOpera("0");
				oldBean.setRemark(bean.getRemark());
				peopleService.update(oldBean);
			}else{//新增
				bean.setOpera("0");
				peopleService.save(bean);
			}
		} catch (Exception e) {
			flag = false;
			map.put("msg", "操作异常："+e.getMessage());
		}
		map.put("success", flag);
		return map;
	}

	@RequestMapping(value="/opera")
	@ResponseBody
	public Map<String,Object> opera(String ids, String type){
		Map<String,Object> map = new HashMap<String,Object>();
		boolean flag = true;
		try {
			peopleService.opera(ids, type);
		} catch (Exception e) {
			flag = false;
			map.put("msg", e.getMessage());
			e.printStackTrace();
		}
		map.put("success", flag);
		return map;
	}
}
