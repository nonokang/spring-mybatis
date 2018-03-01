<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/plugin/layui/css/layui.css">
<script type="text/javascript" src="<%=request.getContextPath()%>/assets/plugin/layui/layui.js"></script>
<!-- jquery插件 -->
<script type="text/javascript" src="<%=request.getContextPath()%>/assets/plugin/jquery-3.3.1.min.js"></script>
<title>测试界面</title>
</head>
<style>
.layui-nav-custom{
    width: auto!important;
    display: inline-block;
    height: 38px;
    line-height: 38px;
    padding: 0 18px;
    background-color: #009688
}
.layui-nav-item-custom{
	position: initial!important;
	line-height: 38px!important;
}
.layui-nav-child-custom{
	top: 38px;
}
.layui-nav-custom > .layui-nav-bar{
	width: 0px!important;
}
</style>
<body>

<!-- 内容主体区域 -->
<div style="padding: 15px;">
	<div class="layui-btn-group demoTable">
		<ul class="layui-nav layui-nav-custom">
			<li class="layui-nav-item layui-nav-item-custom">批量操作<span class="layui-nav-more"></span>
				<dl class="layui-nav-child layui-nav-child-custom">
					<dd><a href="javascript:;" class="layui-btn" data-type="batchDel">删除</a></dd>
					<!-- <dd><a href="">下线</a></dd>
					<dd><a href="">上线</a></dd> -->
				</dl>
			</li>
		</ul>
<!-- 					<button class="layui-btn" data-type="getCheckData">获取选中行数据</button> -->
		<button class="layui-btn" data-type="addData">新增</button>
	</div>
	<div class="demoTable" style="float: right;">
		搜索：
		<div class="layui-inline">
			<input class="layui-input" id="searchVal" autocomplete="off">
		</div>
		<button class="layui-btn" data-type="reload">搜索</button>
	</div>
	<table class="layui-table" id="p-table" lay-filter="table-filter"></table>
</div>
	
<script type="text/html" id="operBar">
  	<a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
  	<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
</script>

<script>
	//定义元素事件（如：批量操作）
	layui.use('element', function(){
	  	  var element = layui.element;
	});
	
	//定义表事件
	layui.use('table', function(){
		  var table = layui.table;
		  
		  //方法渲染
		  var tableObj = table.render({
			  elem: '#p-table' //指定原始表格元素选择器（推荐id选择器）
//			  ,height: 'full-20' //容器高度，默认情况高度自动调整
//			  ,width: '100%'	//默认自动调整
			  ,page:true	//是否开启分页
			  ,id: 'tableLable'	//设置容器唯一id
			  ,url: '/spring-mybatis/people/list'	//异步获取数据
			  ,cols: [[
				  {checkbox: true, fixed: 'left'}
				  ,{field:'id', title: 'ID', width: 100, sort: true, fixed: true}
				  ,{field:'name', title: '用户名'}
				  ,{field:'age', title: '年龄', sort: true}
				  ,{field:'remark', title: '描述'}
				  ,{fixed: 'right', title: '操作', width: 150, align:'center', toolbar: '#operBar'}
			  ]] //设置表头 
			  ,limit: 5 //每页显示条数
			  ,limits: [5,10,25,50,100] //选择显示条数
			  ,text: {none: '暂无相关数据'}
			  ,done: function(res, curr, count){
				    //如果是异步请求数据方式，res即为你接口返回的信息。
				    //如果是直接赋值的方式，res即为：{data: [], count: 99} data为当前页数据、count为数据总长度
				    console.log(res);
				    //得到当前页码
				    console.log(curr);
				    //得到数据总量
				    console.log(count);
				}
			});
		  
		  //监听表格复选框选择
		  table.on('checkbox(table-filter)', function(obj){
		    console.log(obj)
		  });
		  
		  //监听工具条
		  table.on('tool(table-filter)', function(obj){
		    var data = obj.data;
		    if(obj.event === 'del'){//删除
		      layer.confirm('是否确认删除？', function(index){
			      layer.close(index);
			      var _ids = [];
			      _ids.push(data.id);
	              $.ajax({
	                    type: 'post',
	                    url: '/spring-mybatis/people/opera',
	                    dataType: 'json',
	                    data: {
	                    	ids : _ids.join(','),
	                    	type : '-1'	
	                    },//使用delete类型时，data传递参数无效
	                    success: function (res) {
	                        if (res.success) {
	                        	tableObj.reload(); //重载表格
	            			    layer.msg('删除成功！');
	                        } else {
	                        	layer.alert(res.msg);
	                        }
	                    }
	              });
		      });
		    } else if(obj.event === 'edit'){//编辑
		        layer.open({
		          type: 2 //此处以iframe举例
		          ,title: '编辑'
		          ,area: ['700px', '350px']//模态框大小
		          ,shade: 0.5 //遮罩
		          ,maxmin: true
		          ,offset: [50,0] //模态框坐标
		          ,content: '/spring-mybatis/people/detail?id='+data.id
		         /*  ,btn: ['保存', '关闭'] //只是为了演示
		          ,yes: function(index, layero){//保存
		        	  debugger
		        	  if(layero.length == 1){
		        		  var _content = $(layero[0]).find(".layui-layer-content");
		        		  var _iframe = $(_content).find("iframe");
		        		  if(_iframe.length == 1){
			        		  var _contents = $(_iframe[0]).contents();
			        		  var _form = $(_contents).find("#peopleForm");
			        		  debugger
		        		  }
		        	  }
		          }
		          ,btn2: function(index, layero){//关闭
		        	  debugger
		            layer.closeAll();
		          } */
		        });
		    }
		  });
		  
		  var $ = layui.$, active = {
			batchDel: function(){ //批量删除
		      var checkStatus = table.checkStatus('tableLable');
		      var data = checkStatus.data;
		      if(data.length != 0){
		    	  var _ids = [];
		    	  $.each(data,function(){
		    		  if(_ids.indexOf(this.id) == -1){
		    			  _ids.push(this.id);
		    		  }
		    	  })
		    	  if(_ids.length > 0){
		              $.ajax({
		                    type: 'post',
		                    url: '/spring-jpa/people/opera',
		                    dataType: 'json',
	 	                    data: {
	 	                    	ids : _ids.join(','),
	 	                    	type : "-1"
	 	                    },//使用delete类型时，data传递参数无效
		                    success: function (res) {
		                        if (res.success) {
		                        	tableObj.reload(); //重载表格
		            			    layer.msg('删除成功！');
		                        } else {
		                        	layer.alert(res.msg);
		                        }
		                    }
		              });
		    	  }
		      }else{
		    	  layer.msg("请先选择数据！");
		      }
		    },
		  	addData: function(){
		        layer.open({
			          type: 2 //此处以iframe举例
			          ,title: '新增'
			          ,area: ['700px', '350px']//模态框大小
			          ,shade: 0.5 //遮罩
			          ,maxmin: true
			          ,offset: [50,0] //模态框坐标
			          ,content: '/spring-mybatis/people/detail'
			        });
		  	}
		    ,reload: function(){
		        var searchVal = $('#searchVal').val();
		        //执行重载
		        table.reload('tableLable', {
		          page: {
		            curr: 1 //重新从第 1 页开始
		          }
		          ,where: {
		        	  searchName: searchVal
		            /* key: {
		              id: searchVal
		            } */
		          }
		        });
		     }
		  };
		  
		  $('.demoTable .layui-btn').on('click', function(){
		    var type = $(this).data('type');
		    active[type] ? active[type].call(this) : '';
		  });
		});
</script>
</body>
</html>