<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- 避免IE使用兼容模式 -->
<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1">
<meta name="renderer" content="webkit">
<meta name="keywords" content="easyui,jui,jquery easyui,easyui demo,easyui中文">
<meta name="description" content="TopJUI前端框架，基于最新版EasyUI前端框架构建，纯HTML调用功能组件，不用写JS代码的EasyUI，专注你的后端业务开发！">
<!-- 浏览器标签图片 -->
<link rel="shortcut icon" href="<%=request.getContextPath()%>/assets/images/favicon.ico">
<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/font-awesome-4.7.0/css/font-awesome.min.css">
<!-- layui插件 -->
<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/plugin/layui/css/layui.css">
<script type="text/javascript" src="<%=request.getContextPath()%>/assets/plugin/layui/layui.js"></script>
<!-- jquery插件 -->
<script type="text/javascript" src="<%=request.getContextPath()%>/assets/plugin/jquery-3.3.1.min.js"></script>

<style type="text/css">
html, body {
	height: 100%;
	margin: 0px;
}

.box {
	background: url("<%=request.getContextPath()%>/assets/images/loginBg.jpg") no-repeat center center;
	background-size: cover;
	margin: 0 auto;
	position: relative;
	width: 100%;
	height: 100%;
}

.login-box {
	width: 100%;
	max-width: 500px;
	height: 400px;
	position: absolute;
	top: 50%;
	margin-top: -200px;
	/*设置负值，为要定位子盒子的一半高度*/
}

@media screen and (min-width: 500px) {
	.login-box {
		left: 50%;
		/*设置负值，为要定位子盒子的一半宽度*/
		margin-left: -250px;
	}
}

.form {
	width: 100%;
	max-width: 500px;
	height: 275px;
	margin: 2px auto 0px auto;
}

.login-content {
	border-bottom-left-radius: 8px;
	border-bottom-right-radius: 8px;
	height: 250px;
	width: 100%;
	max-width: 500px;
	background-color: rgba(255, 250, 2550, .6);
	float: left;
}

.form-actions {
	margin-top: 30px;
}

.form-group {
	margin-bottom: 0px !important;
}

.login-title {
	border-top-left-radius: 8px;
	border-top-right-radius: 8px;
	padding: 20px 10px;
	background-color: rgba(0, 0, 0, .6);
}

.login-title h1 {
	margin-top: 10px !important;
}

.login-title small {
	color: #fff;
}

.link p {
	line-height: 20px;
	margin-top: 30px;
}

.flag {
	position: absolute;
	top: 10px;
	right: 10px;
	color: #fff;
	font-weight: bold;
	font: 14px/normal "microsoft yahei", "Times New Roman", "宋体", Times,
		serif;
}
</style>
<title>登录界面</title>
</head>
<body>
	<div class="box">
		<div class="login-box">
			<div class="login-title" align="center">
				<span class="flag"><i class="fa fa-user"></i> 用户登陆</span>
				<h1>
					<small>layui前端框架</small>
				</h1>
			</div>
			<div class="login-content">
				<div class="form" align="center">
<!-- 					<form class="layui-form layui-form-pane" role="form" method="post"> -->
					<div class="layui-form layui-form-pane">
						<div class="layui-form-item" style="margin: 30px 0px 15px 80px;">
							<label class="layui-form-label" style="width: 45px; padding: 12px 0px;"><i class="fa fa-user fa-fw"></i></label>
							<div class="layui-input-inline" style="width: 280;">
								<input type="text" name="username" lay-verify="required"
									placeholder="请输入" autocomplete="off" class="layui-input">
							</div>
						</div>
						<div class="layui-form-item" style="margin: 20px 0px 15px 80px;">
							<label class="layui-form-label" style="width: 45px; padding: 12px 0px;"><i class="fa fa-key fa-fw"></i></label>
							<div class="layui-input-inline" style="width: 280;">
								<input type="password" name="password" placeholder="请输入密码"
									autocomplete="off" class="layui-input">
							</div>
						</div>
						<div class="form-group form-actions">
							<button class="layui-btn" id="login">
								<span class="fa fa-check-circle"></span>登录
							</button>
							<button class="layui-btn layui-btn-danger" id="reset">
								<span class="fa fa-close"></span>重置
							</button>
						</div>
					</div>
<!-- 					</form> -->
				</div>
			</div>
		</div>
	</div>

<script type="text/javascript">
    if (navigator.appName == "Microsoft Internet Explorer" &&
            (navigator.appVersion.split(";")[1].replace(/[ ]/g, "") == "MSIE6.0" ||
            navigator.appVersion.split(";")[1].replace(/[ ]/g, "") == "MSIE7.0" ||
            navigator.appVersion.split(";")[1].replace(/[ ]/g, "") == "MSIE8.0")
    ) {
        alert("您的浏览器版本过低，请使用360安全浏览器的极速模式或IE9.0以上版本的浏览器");
    }
</script>
<script type="text/javascript">
    $(function () {
        $('#password').keyup(function (event) {
            if (event.keyCode == "13") {
                $("#login").trigger("click");
                return false;
            }
        });

        $("#login").on("click", function () {
            submitForm();
        });

        function submitForm() {
            if (navigator.appName == "Microsoft Internet Explorer" &&
                    (navigator.appVersion.split(";")[1].replace(/[ ]/g, "") == "MSIE6.0" ||
                    navigator.appVersion.split(";")[1].replace(/[ ]/g, "") == "MSIE7.0" ||
                    navigator.appVersion.split(";")[1].replace(/[ ]/g, "") == "MSIE8.0")
            ) {
                alert("您的浏览器版本过低，请使用360安全浏览器的极速模式或IE9.0以上版本的浏览器");
            } else {
                var formData = {
                    username: $('input[name="username"]').val(),
                    password: $('input[name="password"]').val(),
                };
                $.ajax({
                    type: 'POST',
                    url: '/spring-mybatis/login/login',
//                     contentType: "application/json; charset=utf-8",
                    dataType: 'json',
                    async: false,
                    data: formData,
//                     data: JSON.stringify(formData),
                    success: function (data) {
                        if (data.statusCode == 200) {
                            location.href = "/spring-mybatis/login/loginSuccess";
                        } else {
                            alert("用户名或密码错误！");
                        }
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                    }
                });
            }
        }

        $("#reset").on("click", function () {
            $('input[name="username"]').val("");
            $('input[name="password"]').val("");
        });
    });
</script>

</body>
</html>