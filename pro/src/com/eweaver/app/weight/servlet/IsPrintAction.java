package com.eweaver.app.weight.servlet;

import com.eweaver.base.AbstractAction;
import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.DataService;
import com.eweaver.base.IDGernerator;
import com.eweaver.base.security.service.acegi.EweaverUser;
import com.eweaver.base.util.StringFilter;
import com.eweaver.base.util.StringHelper;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class IsPrintAction
  implements AbstractAction
{
  protected final Log logger = LogFactory.getLog(getClass());
  private HttpServletRequest request;
  private HttpServletResponse response;
  private HttpSession session;
  private DataService dataService;

  public IsPrintAction(HttpServletRequest request, HttpServletResponse response)
  {
    this.request = request;
    this.response = response;
    this.session = request.getSession();
    this.dataService = new DataService();
  }

  public void execute() throws IOException, ServletException
  {
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String userId = BaseContext.getRemoteUser().getId();
    String action = StringHelper.null2String(
      StringFilter.filterAll(this.request.getParameter("action")));
    if ("workflow".equals(action)) {
      String requestid = StringHelper.null2String(
        StringFilter.filterAll(this.request.getParameter("requestid")));
      String nodeid = StringHelper.null2String(StringFilter.filterAll(this.request
        .getParameter("nodeid")));
      String times = this.dataService
        .getValue("select isprint('" + requestid + "','" + nodeid + "') from dual");
      String retStr = "isable";

      if ("noxz".equals(times)) {
        retStr = "isable";
      } else if ("noable".equals(times)) {
        retStr = "noable";
      } else {
        String id = IDGernerator.getUnquieID();
        StringBuffer buffer = new StringBuffer(512);
        buffer.append("insert into uf_print_log");
        buffer.append("(id,requestid,reqid,node,isprint,sj,objname,humreid) values");
        buffer.append("('").append(id).append("',");
        buffer.append("(select max(a.requestid) ");
        buffer.append("from uf_print_main a ");
        buffer.append("left join requestbase b ");
        buffer.append("on a.workflow = b.workflowid ");
        buffer.append("where b.id ='").append(requestid).append("' ");
        buffer.append("and a.node = '").append(nodeid).append("'),");
        buffer.append("'").append(requestid).append("',");
        buffer.append("'").append(nodeid).append("',");
        buffer.append("'40288098276fc2120127704884290211',");
        buffer.append("to_char(sysdate,'yyyy-MM-dd hh24:mm:ss'),");
        buffer.append("(select a.requestname||'-'||a.objno from requestbase a where a.id = '").append(requestid).append("'),");
        buffer.append("'").append(userId).append("')");

        String insertSql = buffer.toString();
        baseJdbc.update(insertSql);
      }

      try
      {
        this.response.getWriter().print(retStr);
      } catch (IOException e) {
        e.printStackTrace();
      }
      return;
    }
    if ("formbase".equals(action)) {
      String requestid = StringHelper.null2String(
        StringFilter.filterAll(this.request.getParameter("requestid")));
      String times = this.dataService
        .getValue("select isprint('" + requestid + "','0') from dual");
      String retStr = "isable";

      if ("noxz".equals(times)) {
        retStr = "isable";
      } else if ("noable".equals(times)) {
        retStr = "noable";
      } else {
        String id = IDGernerator.getUnquieID();
        StringBuffer buffer = new StringBuffer(512);
        buffer.append("insert into uf_printform_log");
        buffer.append("(id,requestid,reqid,isprint,sj,humreid) values");
        buffer.append("('").append(id).append("',");
        buffer.append("(select max(a.requestid) ");
        buffer.append("from uf_printform_main a ");
        buffer.append("left join category c on a.categray = c.formid left join formbase b on c.id = b.categoryid ");
        buffer.append("where b.id ='").append(requestid).append("'),");
        buffer.append("'").append(requestid).append("',");
        buffer.append("'40288098276fc2120127704884290211',");
        buffer.append("to_char(sysdate,'yyyy-MM-dd hh24:mm:ss'),");
        buffer.append("'").append(userId).append("')");

        String insertSql = buffer.toString();
        baseJdbc.update(insertSql);
      }

      try
      {
        this.response.getWriter().print(retStr);
      } catch (IOException e) {
        e.printStackTrace();
      }
      return;
    }
  }
}