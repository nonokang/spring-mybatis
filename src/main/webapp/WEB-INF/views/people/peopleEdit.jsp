<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<title>编辑模板</title>
<!-- layui插件 -->
<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/plugin/layui/css/layui.css">
<script type="text/javascript" src="<%=request.getContextPath()%>/assets/plugin/layui/layui.js"></script>
<!-- jquery插件 -->
<script type="text/javascript" src="<%=request.getContextPath()%>/assets/plugin/jquery-3.3.1.min.js"></script>
</head>
<body>
	<form class="layui-form" action="">
		<div class="layui-form-item">
			<input type="hidden" name="id" value="${bean.id}">
		</div>
		<div class="layui-form-item">
			<label class="layui-form-label">姓名：</label>
			<div class="layui-col-xs9">
				<input type="text" name="name" value="${bean.name }" lay-verify="name" autocomplete="off" placeholder="请输入姓名" class="layui-input">
			</div>
		</div>
		<div class="layui-form-item">
			<label class="layui-form-label">年龄：</label>
			<div class="layui-col-xs9">
				<input type="text" name="age" value="${bean.age }" lay-verify="age" placeholder="请输入年龄" autocomplete="off" class="layui-input">
			</div>
		</div>
		<div class="layui-form-item layui-form-text">
			<label class="layui-form-label">描述：</label>
			<div class="layui-col-xs9">
				<textarea placeholder="请输入内容" name="remark" lay-verify="remark" class="layui-textarea">${bean.remark }</textarea>
			</div>
		</div>
		<div class="layui-form-item">
		    <div class="layui-input-block">
		      <button class="layui-btn" lay-submit="" lay-filter="_submit">提交</button>
		      <button type="reset" class="layui-btn layui-btn-primary">重置</button>
		    </div>
		</div>
	</form>
	<script type="text/javascript">
	layui.use(['form'], function(){
		  var form = layui.form
		  //自定义验证规则
		  form.verify({
			name: function(value){
// 		      if(value.length < 5){
// 		        return '标题至少得5个字符啊';
// 		      }
		    }
// 		    ,age: [/(.+){6,12}$/, '密码必须6到12位']
		    ,remark: function(value){
		    	
		    }
		  });
		  //监听提交  
		  form.on('submit(_submit)', function(data){
              $.ajax({
                  type: 'post',
                  url: '/spring-mybatis/people/save',
                  dataType: 'json',
                  data: data.field,
                  success: function (res) {
                      if (res.success) {
                    	parent.layer.closeAll();
          			    layer.msg('操作成功！');
                      } else {
                      	layer.alert(res.msg);
                      }
                  }
            });
			    return false;  
		  });
	});
	</script>
</body>
</html>