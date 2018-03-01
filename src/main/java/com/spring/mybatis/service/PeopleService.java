package com.spring.mybatis.service;

import com.spring.mybatis.entity.People;
import com.spring.mybatis.utils.Page;

public interface PeopleService {

	public People findById(Integer id);
	
	public Page<People> pageList(Integer pageNo, Integer pageSize, People p);
	
	public void save(People bean);
	
	public void update(People bean);
	
	public void opera(String ids, String type);
	
}
