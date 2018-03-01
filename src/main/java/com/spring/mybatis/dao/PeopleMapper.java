package com.spring.mybatis.dao;

import java.util.List;

import com.spring.mybatis.entity.People;
import com.spring.mybatis.utils.Page;

public interface PeopleMapper {
	
    int deleteByPrimaryKey(Integer id);

    int insert(People record);

    int insertSelective(People record);

    People selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(People record);

    int updateByPrimaryKey(People record);
    
    List<People> queryList(Page<People> page);
    
}