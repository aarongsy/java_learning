package com.ccp.servlet;

import java.io.IOException;
import java.lang.reflect.Method;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public abstract class BaseServlet extends HttpServlet {
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		/*
		 * 1.获取参数，用来识别用户想请求的方法
		 * 2.然后判断是否存在方法，然后调用
		 */
		String methodName = request.getParameter("method");
		
		if(methodName == null || methodName.trim().isEmpty()) {
			throw new RuntimeException("您没有传递method参数，无法确定你要调用的方法！");
		}
		/*
		 * 得到方法名称，通过反射来调用方法
		 * 1.得到方法名，通过方法名再得到Method类的对象
		 * 需要得到Class,然后调用它的方法进行查询，得到Method
		 * 我们要查询的是当前类的方法，所以需要得到当前类的Class
		 */
		Class c = this.getClass();
		Method method = null;
			try {
				method = c.getMethod(methodName, HttpServletRequest.class,HttpServletResponse.class);
			} catch (Exception e) {
				throw new RuntimeException("您要调用的方法"+methodName+"不存在");
			} 
			/*
			 * 调用method表示的方法
			 */
			try {
				String result = (String)method.invoke(this, request, response);
				/*
				 * 获取请求处理方法执行后返回的字符串，它表示重定向或转发的路径
				 * 帮它完成转发或者重定向
				 */
				/* 
				 * 如果字符串为null,什么也不做
				 */
				if(result == null || result.trim().isEmpty()){
					return;
				}
				/* 
				 * 没有冒号，转发
				 * 有，使用冒号分割字符串
				 * 前缀是r，表示重定向，f转发，i表示包含，后缀表示路径
				 */
				if(result.contains(":")){
					//使用冒号分割字符串
					int index = result.indexOf(":");
					String pref = result.substring(0, index);//前缀
					String path = result.substring(index+1);
					if(pref.equalsIgnoreCase("r")){//重定向
						response.sendRedirect(request.getContextPath()+path);
					}else if (pref.equalsIgnoreCase("i")) {//包含
						request.getRequestDispatcher(path).include(request, response);
					}else if (pref.equalsIgnoreCase("f")) {
						request.getRequestDispatcher(path).forward(request, response);
					}else {
						throw new RuntimeException("您指定的操作"+pref+"当前版本不支持");
					}
				}else{//没有冒号，默认转发
					request.getRequestDispatcher(result).forward(request, response);
				}
			} catch (Exception e) {
				throw new RuntimeException("您调用的方法内部出现了异常："+e);
			}	
	}
	

}
