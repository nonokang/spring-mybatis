<%@ page language="java" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE>
<html>
<head>
<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/plugin/layui/css/layui.css">
<script type="text/javascript" src="<%=request.getContextPath()%>/assets/plugin/layui/layui.js"></script>
<!-- jquery插件 -->
<script type="text/javascript" src="<%=request.getContextPath()%>/assets/plugin/jquery-3.3.1.min.js"></script>
<title>layui学习平台</title>
</head>
<body class="layui-layout-body">
	<div class="layui-layout layui-layout-admin">
		<div class="layui-header">
			<div class="layui-logo">layui 平台管理</div>
			<!-- 头部区域（可配合layui已有的水平导航） -->
			<ul class="layui-nav layui-layout-left">
				<li class="layui-nav-item"><a href="javascript:;" class="_url" data-url="<%=request.getContextPath()%>/people/index">主页</a></li>
				<%-- <li class="layui-nav-item"><a href="javascript:;">系统管理<span class="layui-nav-more"></span></a>
					<dl class="layui-nav-child">
						<dd><a href="">用户管理</a></dd>
						<dd><a href="">日志管理</a></dd>
					</dl>
				</li> --%>
			</ul>
			<ul class="layui-nav layui-layout-right">
				<li class="layui-nav-item">
					<a href="javascript:;"><img src="http://t.cn/RCzsdCq" class="layui-nav-img"> 贤心 <span class="layui-nav-more"></span></a>
					<dl class="layui-nav-child">
						<dd><a href="">基本资料</a></dd>
						<dd><a href="">安全设置</a></dd>
					</dl>
				</li>
				<li class="layui-nav-item"><a href="">退了</a></li>
			</ul>
		</div>

		<div class="layui-side layui-bg-black">
			<div class="layui-side-scroll">
				<!-- 左侧导航区域（可配合layui已有的垂直导航） -->
				<ul class="layui-nav layui-nav-tree">
					<li class="layui-nav-item layui-nav-itemed">
						<a class="" href="javascript:;">模板管理<span class="layui-nav-more"></span></a>
						<dl class="layui-nav-child">
							<dd>
								<a href="javascript:;" class="_url" data-url="<%=request.getContextPath()%>/people/index">模板功能</a>
							</dd>
						</dl>
					</li>
					<li class="layui-nav-item">
						<a class="" href="javascript:;">系统管理<span class="layui-nav-more"></span></a>
						<dl class="layui-nav-child">
							<dd>
								<a href="javascript:;" class="_url" data-url="<%=request.getContextPath()%>/people/index">用户管理</a>
							</dd>
							<dd>
								<a href="javascript:;" class="_url" data-url="<%=request.getContextPath()%>/people/index">日志管理</a>
							</dd>
						</dl>
					</li>
				</ul>
			</div>
		</div>
		<div class="layui-body" style="bottom: 0px;">
			<iframe id="myframe" src="<%=request.getContextPath()%>/people/index" width="100%" height="100%" frameborder="0"></iframe>
		</div>
	</div>

	<script>
	//JavaScript代码区域
	layui.use('element', function(){
	  var element = layui.element;
	});
	$(function(){
		var urls = $("._url");
		$.each(urls,function(){
			$(this).bind("click",function(){
				var url = $(this).data("url");
				$("#myframe")[0].src = url;
			})
		})
	})
	</script>
</body>
</html>