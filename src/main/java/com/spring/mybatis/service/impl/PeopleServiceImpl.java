package com.spring.mybatis.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.spring.mybatis.dao.PeopleMapper;
import com.spring.mybatis.entity.People;
import com.spring.mybatis.service.PeopleService;
import com.spring.mybatis.utils.Page;

@Service(value="peopleService")
public class PeopleServiceImpl implements PeopleService{

	@Resource(name="peopleMapper")
	public PeopleMapper peopleMapper;

	@Override
	public People findById(Integer id) {
		return peopleMapper.selectByPrimaryKey(id);
	}

	@Override
	public Page<People> pageList(Integer pageNo, Integer pageSize, People p) {
		Page<People> page = new Page<People>();
		page.setPageNo(pageNo);
		page.setPageSize(pageSize);
		page.setParams(p);//设置查询条件
		peopleMapper.queryList(page);
		return page;
	}

	@Override
	public void save(People bean) {
		peopleMapper.insert(bean);
	}

	@Override
	public void update(People bean) {
		peopleMapper.updateByPrimaryKey(bean);
	}

	@Override
	public void opera(String ids, String type) {
		if(null != ids && ids.length() != 0){
			String[] _ids = ids.split(",");
			for(String id : _ids){
				if(null == id || "".equals(id)) continue;
				People p = findById(Integer.parseInt(id));
				p.setOpera(type);
				update(p);
			}
		}else{
			throw new NullPointerException(String.format("参数id为空！"));
		}
	}
}
