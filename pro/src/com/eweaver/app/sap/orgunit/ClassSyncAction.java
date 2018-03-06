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

public class ClassSyncAction
  implements AbstractAction
{
  protected final Log logger = LogFactory.getLog(getClass());
  private HttpServletRequest request;
  private HttpServletResponse response;
  private HttpSession session;
  private DataService dataService;
  private int pageNo;
  private int pageSize;

  public ClassSyncAction(HttpServletRequest request, HttpServletResponse response)
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
      String sapno = StringHelper.null2String(StringFilter.filterAll(this.request.getParameter("objno")));
      String orgid = StringHelper.null2String(StringFilter.filterAll(this.request.getParameter("orgid")));
      String isroot = StringHelper.null2String(StringFilter.filterAll(this.request.getParameter("isroot")));

      BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");

      String sql = "select objno,exttextfield15 sapno,objname,get_all_orgpath(orgid) org,get_namebyid(mainstation, 6) sta,get_namebyid(extselectitemfield11, 0) zu,get_namebyid(extselectitemfield12, 0) zizu from humres where isdelete = 0 and hrstatus = '4028804c16acfbc00116ccba13802935' and objname <> 'sysadmin' ";

      if ((ccpno != null) && (ccpno.length() > 0)) {
        sql = sql + "and instr(objno,'" + ccpno + "') > 0 ";
      }
      if ((sapno != null) && (sapno.length() > 0)) {
        sql = sql + "and instr(exttextfield15,'" + sapno + "') > 0 ";
      }
      if ((orgid != null) && (orgid.length() > 0)) {
        if ("1".equals(isroot))
          sql = sql + "and instr(get_all_orgid(orgid),'" + orgid + "') >0 ";
        else {
          sql = sql + "and instr(orgid,'" + orgid + "') >0 ";
        }

      }

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
    }if (action.equals("synchronous")) {
      String jsonstr = StringHelper.null2String(StringFilter.filterAll(this.request
        .getParameter("jsonstr")));
      String kssj = StringHelper.null2String(StringFilter.filterAll(this.request
        .getParameter("kssj")));
      String jssj = StringHelper.null2String(StringFilter.filterAll(this.request
        .getParameter("jssj")));
      Class_ZHR_PERSONAL_DWS_GET app = new Class_ZHR_PERSONAL_DWS_GET(
        "ZHR_PERSONAL_DWS_GET");
      try
      {
        String[] str = jsonstr.split(",");
        for (int i = 0; i < str.length; i++) {
          app.syncClass(str[i], kssj, jssj);
        }
        this.response.getWriter().print("同步结束！");
      } catch (IOException e) {
        e.printStackTrace();
      } catch (ParseException e) {
        e.printStackTrace();
      }

      return;
    }
  }
}