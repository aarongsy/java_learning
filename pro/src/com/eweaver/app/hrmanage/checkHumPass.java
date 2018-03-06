package com.eweaver.app.hrmanage;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.simple.JSONObject;

import com.eweaver.base.AbstractAction;
import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.DataService;
import com.eweaver.base.util.StringFilter;
import com.eweaver.base.util.StringHelper;

public class checkHumPass 
 implements AbstractAction{
	  protected final Log logger = LogFactory.getLog(getClass());
	  private HttpServletRequest request;
	  private HttpServletResponse response;
	  private HttpSession session;
	  private DataService dataService;
	  private int pageNo;
	  private int pageSize;
	  public checkHumPass(HttpServletRequest request, HttpServletResponse response)
	  {
	    this.request = request;
	    this.response = response;
	    this.session = request.getSession();
	    this.dataService = new DataService();
	  }
	  public void execute() throws IOException, ServletException
	  {
		  String userid = StringHelper.null2String(StringFilter.filterAll(this.request
			      .getParameter("userid")));
		  String pass = StringHelper.null2String(StringFilter.filterAll(this.request
			      .getParameter("pass")));
		  
		  String msg="";
		  BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		  DigestUtils digest=new DigestUtils();
		  System.out.println("查询密码未编译："+pass);
		  String sql="select passw from  uf_hr_ygxzpass where humid='"+userid+"'";
		  List list = baseJdbc.executeSqlForList(sql);
		  int size=list.size();
		  if (size<=0)
		  {
			  msg="不存在该用户的初始密码，无法查询";
			  System.out.println(msg);
		  }
		  else
		  {
			  Map map = (Map)list.get(0);
			  String passw = StringHelper.null2String(map.get("passw"));

			  String passm=digest.md5Hex(pass);
			  System.out.println("设定密码："+passw);
			  System.out.println("查询密码："+passm);
			  if(!passw.equals(passm))
			  {
				  msg="密码不正确";
			  }
			  else{
				  msg="查询成功";
			  }
			  System.out.println(msg);
		  }
		  JSONObject objectresult = new JSONObject();
	      objectresult.put("msg", msg);
	      try {
	    	response.setContentType("application/json; charset=utf-8");
	        //this.response.getWriter().print(objectresult.toString());
	        this.response.getWriter().write(objectresult.toString());
	        response.getWriter().flush();
			response.getWriter().close();
	      } catch (IOException e) {
	        e.printStackTrace();
	      }
	      return;
	  }

}
