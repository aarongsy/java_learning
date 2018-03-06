package com.eweaver.app.bbs.discuz.action;

import com.eweaver.app.bbs.discuz.client.Client;
import com.eweaver.app.bbs.discuz.util.XMLHelper;
import com.eweaver.base.AbstractAction;
import com.eweaver.base.BaseContext;
import com.eweaver.base.security.model.Sysuser;
import com.eweaver.base.security.service.logic.SysuserService;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringHelper;
import java.io.IOException;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.util.LinkedList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class DiscuzAction
  implements AbstractAction
{
  protected final Log logger = LogFactory.getLog(getClass());
  private HttpServletRequest request;
  private HttpServletResponse response;
  private SysuserService sysuserService;

  public DiscuzAction(HttpServletRequest request, HttpServletResponse response)
  {
    this.request = request;
    this.response = response;
    this.sysuserService = ((SysuserService)BaseContext.getBean("sysuserService"));
  }

  public void execute() throws IOException, ServletException
  {
    String action = StringHelper.null2String(this.request.getParameter("action"));

    String username = StringHelper.null2String(this.request.getParameter("username"));
    String password = StringHelper.null2String(this.request.getParameter("password"));
    PrintWriter pw = this.response.getWriter();
    Client uc = new Client();
    if ("syninit".equals(action)) {
      List allUser = this.sysuserService.findAllUser();
      for (int i = 0; (allUser != null) && (i < allUser.size()); i++) {
        Sysuser sysuser = (Sysuser)allUser.get(i);
        if ((sysuser != null) && (!StringHelper.isEmpty(sysuser.getId()))) {
          String uname = StringHelper.null2String(sysuser.getLongonname());
          String upass = Client.UC_PASSWORD;

          String email = "";
          if (StringHelper.isEmpty(email)) {
            email = uname + "@163.com";
          }
          String uid = uc.uc_user_register(uname, upass, email);
          if (NumberHelper.string2Int(uid) > 1)
            pw.write("用户：" + uname + "初始化成功！<br>");
          else
            pw.write("用户：" + uname + "初始化失败！<br>");
        }
      }
    } else if ("synlogin".equals(action))
    {
      String result = uc.uc_user_login(username, "123456");
      LinkedList rs = XMLHelper.uc_unserialize(result);
      if (rs.size() > 0) {
        int $uid = Integer.parseInt((String)rs.get(0));
        String $username = (String)rs.get(1);
        String $password = (String)rs.get(2);
        String $email = (String)rs.get(3);
        if ($uid > 0) {
          this.response.addHeader("P3P", " CP=\"CURa ADMa DEVa PSAo PSDo OUR BUS UNI PUR INT DEM STA PRE COM NAV OTC NOI DSP COR\"");

          System.out.println("登录成功");
          System.out.println($username);
          System.out.println($password);
          System.out.println($email);

          String $ucsynlogin = uc.uc_user_synlogin($uid);
          pw.write($ucsynlogin + "<script type='text/javascript'>window.onload=function(){" + "location.href='" + Client.BBS_API + "index.php'}</script>");
        }
        else if ($uid == -1) {
          System.out.println("用户不存在,或者被删除");
        } else if ($uid == -2) {
          System.out.println("密码错");
        } else {
          System.out.println("未定义");
        }
      } else {
        pw.write("<script type='text/javascript'>window.onload=function(){location.href='" + Client.BBS_API + "bbs/index.php'}</script>");
      }

    }
    else if (!"synlogonout".equals(action))
    {
      if ("syndelete".equals(action)) {
        String user = uc.uc_get_user("sysadmin", 0);
        List userList = XMLHelper.uc_unserialize(user);
        String uid = userList == null ? "-1" : StringHelper.null2String(userList.get(0));

        String returnval = uc.uc_user_delete(uid);
        if (NumberHelper.string2Int(returnval) > 0)
          pw.write("删除成功！");
        else
          pw.write("删除失败！");
      }
      else if ("register".equals(action)) {
        String uname = StringHelper.null2String("sysadmin");
        String upass = "123456";

        String email = "";
        if (StringHelper.isEmpty(email)) {
          email = uname + "@153.com";
        }
        String uid = uc.uc_user_register(uname, upass, email);
        if (NumberHelper.string2Int(uid) > 1)
          pw.write("用户：" + uname + "初始化成功！<br>");
        else
          pw.write("用户：" + uname + "初始化失败！<br>");
      }
    }
  }
}