package com.eweaver.app.sap.orgunit;

import com.eweaver.base.AbstractAction;
import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.DataService;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringFilter;
import com.eweaver.base.util.StringHelper;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class ClassSyncAction1
  implements AbstractAction
{
  protected final Log logger = LogFactory.getLog(getClass());
  private HttpServletRequest request;
  private HttpServletResponse response;
  private HttpSession session;
  private DataService dataService;
  private int pageNo;
  private int pageSize;

  public ClassSyncAction1(HttpServletRequest request, HttpServletResponse response)
  {
    this.request = request;
    this.response = response;
    this.session = request.getSession();
    this.dataService = new DataService();
  }

  public void execute() throws IOException, ServletException
  {
    this.pageNo = NumberHelper.string2Int(
      StringFilter.filterAll(this.request.getParameter("pageno")), 1);
    this.pageSize = 
      NumberHelper.string2Int(StringFilter.filterAll(this.request
      .getParameter("pagesize")), 20);

    if (!StringHelper.isEmpty(StringFilter.filterAll(this.request
      .getParameter("start"))))
      this.pageNo = (NumberHelper.string2Int(
        StringFilter.filterAll(this.request.getParameter("start")), 0) / 
        this.pageSize + 1);
    String action = StringHelper.null2String(StringFilter.filterAll(this.request
      .getParameter("action")));

    if (action.equals("search")) {
      String ccpno = StringHelper.null2String(StringFilter.filterAll(this.request.getParameter("ccpno")));
      String currentuserid = StringHelper.null2String(StringFilter.filterAll(this.request.getParameter("ext15")));
      BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");

      String sql = "select objno,objname,thedate,days from  v_hr_classplancheck where  days<(select to_number(to_char(last_day(sysdate),'dd')) from dual)";
	  
      if ((ccpno != null) && (ccpno.length() > 0)) {
        sql = sql + "and objno='"+ccpno+"'";
      }
      if ((currentuserid != null) && (currentuserid.length() > 0)) {
          sql = sql + "and extrefobjfield5=(select extrefobjfield5 from humres where id='"+currentuserid+"')";
        }
System.out.println("排班异常sql:"+sql);
      List list = baseJdbc.executeSqlForList(sql);

      JSONArray array = new JSONArray();
      for (int i = 0; i < list.size(); i++) {
        JSONObject jsonresult = new JSONObject();
        Map r = (Map)list.get(i);
        Iterator it = r.keySet().iterator();
        while (it.hasNext()) {
          Object obj = it.next();
          jsonresult.put(obj, StringHelper.null2String(r.get(obj)));
        }
        array.add(jsonresult);
      }

      JSONObject objectresult = new JSONObject();
      objectresult.put("result", array);
      objectresult.put("totalcount", Integer.valueOf(array.size()));
      try {
        this.response.getWriter().print(objectresult.toString());
      } catch (IOException e) {
        e.printStackTrace();
      }
      return;
    }
  }
}