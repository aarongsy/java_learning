package com.eweaver.app.hrmanage;

import com.eweaver.base.AbstractAction;
import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.DataService;
import com.eweaver.base.util.StringFilter;
import com.eweaver.base.util.StringHelper;
import java.io.IOException;
import java.io.PrintStream;
import java.io.PrintWriter;
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

public class setHumXzpass
  implements AbstractAction
{
  protected final Log logger = LogFactory.getLog(getClass());
  private HttpServletRequest request;
  private HttpServletResponse response;
  private HttpSession session;
  private DataService dataService;
  private int pageNo;
  private int pageSize;

 /* public setHumXzpass(HttpServletRequest request, HttpServletResponse response)
  {
    this.request = request;
    this.response = response;
    this.session = request.getSession();
    this.dataService = new DataService();
  }
*/
  public void execute() throws IOException, ServletException {
    String userid = StringHelper.null2String(StringFilter.filterAll(this.request
      .getParameter("userid")));
    String oldpass = StringHelper.null2String(StringFilter.filterAll(this.request
      .getParameter("xzoldpass")));
    String newpass = StringHelper.null2String(StringFilter.filterAll(this.request
      .getParameter("xznewpass")));

    String msg = "";
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    DigestUtils digest = new DigestUtils();
    System.out.println("管理员密码：" + DigestUtils.md5Hex("123"));
    String sql = "select passw from  uf_hr_ygxzpass where humid='" + userid + "'";
    List list = baseJdbc.executeSqlForList(sql);
    int size = list.size();
    if (size <= 0)
    {
      msg = "不存在该用户的初始密码";
      System.out.println(msg);
    }
    else
    {
      Map map = (Map)list.get(0);
      String passw = StringHelper.null2String(map.get("passw"));

      String passm = DigestUtils.md5Hex(oldpass);
      System.out.println("数据库：" + passw);
      System.out.println("输入原始密码：" + passm);
      if (!passw.equals(passm))
      {
        msg = "原始密码不正确";
      }
      else {
        String passnew = DigestUtils.md5Hex(newpass);
        String insql = "update uf_hr_ygxzpass set passw='" + passnew + "' where humid='" + userid + "'";
        System.out.println(insql);
        baseJdbc.update(insql);
        msg = "密码修改成功";
      }
      System.out.println(msg);
    }
    JSONObject objectresult = new JSONObject();
    objectresult.put("msg", msg);
    try {
      this.response.setContentType("application/json; charset=utf-8");

      this.response.getWriter().write(objectresult.toString());
      this.response.getWriter().flush();
      this.response.getWriter().close();
      this.response.setHeader("Pragma","No-cache"); 

      this.response.setHeader("Cache-Control","no-cache"); 

      this.response.setDateHeader("Expires", 0);  


    } catch (IOException e) {
      e.printStackTrace();
    }
  }
}