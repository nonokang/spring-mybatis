var comm = {};
(function(n){
	
	//初始化工具
	n.initSettings = function(){
		//设置全局ajax
		globalAjax();
	}
	
	/** 全局异步设置*/
	function globalAjax(){
		$.ajaxSetup({
			type : 'POST',
			dataType : 'json',
			cache : false,
			timeout : 6000 * 1000,
			error : function(xhr,status,error){ 
				debugger
                alert("错误处理!");  
			},
			beforeSend : function(xhr){ 
				debugger
//                alert("登入超时,系统将自动跳转到登陆页面,请重新登入!");  
			},
			success : function(result,status,xhr){
				debugger
			},
			complete : function(xhr,status){ 
				debugger
	            if(xhr.getResponseHeader("sessionstatus")=='timeout'){  
	                alert("登入超时,系统将自动跳转到登陆页面,请重新登入!");  
//	                window.location = "/spring-jpa/login/login"; //如重定向到登陆页面   
	                window.top.location = "/spring-jpa/login/login"; //如重定向到登陆页面   
//	                parent.location.href = "/spring-jpa/login/login";
	            }
			}
		});
	}
	
})(comm)