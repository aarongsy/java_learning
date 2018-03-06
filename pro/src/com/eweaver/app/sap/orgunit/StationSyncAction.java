package com.eweaver.app.sap.orgunit;

import com.eweaver.base.AbstractAction;
import com.eweaver.base.BaseContext;
import com.eweaver.base.DataService;
import com.eweaver.base.label.service.LabelService;
import com.eweaver.base.orgunit.model.Orgunit;
import com.eweaver.base.orgunit.model.Orgunitlink;
import com.eweaver.base.security.model.Sysuser;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringFilter;
import com.eweaver.base.util.StringHelper;
import com.eweaver.humres.base.model.Humres;
import com.eweaver.humres.base.model.Stationinfo;
import com.eweaver.humres.base.model.Stationlink;
import com.sap.conn.jco.JCoTable;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.SessionFactory;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class StationSyncAction
  implements AbstractAction
{
  protected final Log logger = LogFactory.getLog(getClass());
  private HttpServletRequest request;
  private HttpServletResponse response;
  private HttpSession session;
  private DataService dataService;
  private int pageNo;
  private int pageSize;

  public StationSyncAction(HttpServletRequest request, HttpServletResponse response)
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
      Station_ZHR_POSITION_GET app = new Station_ZHR_POSITION_GET(
        "ZHR_POSITION_GET");
      String orgeh = StringHelper.null2String(StringFilter.filterAll(this.request.getParameter("orgeh")));
      String overdate = StringHelper.null2String(this.request.getParameter("overdate"));

      JCoTable staTable = app.findData(orgeh, overdate);

      JSONArray array = new JSONArray();
      if (staTable != null) {
        for (int i = 0; i < staTable.getNumRows(); i++) {
          JSONObject object = new JSONObject();
          object.put("stext", StringHelper.null2String(staTable.getString("STEXT")));
          object.put("begda", StringHelper.null2String(staTable.getString("BEGDA")));
          object.put("endda", StringHelper.null2String(staTable.getString("ENDDA")));
          object.put("orgeh", StringHelper.null2String(staTable.getString("ORGEH")));
          object.put("seqnr", StringHelper.null2String(staTable.getString("SEQNR")));
          object.put("chgor", StringHelper.null2String(staTable.getString("CHGOR")));
          object.put("number", StringHelper.null2String(staTable.getString("NUMBER")));

          array.add(object);
          staTable.nextRow();
        }
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
      Station_ZHR_POSITION_GET app = new Station_ZHR_POSITION_GET(
        "ZHR_POSITION_GET");
      String overdate = StringHelper.null2String(this.request.getParameter("overdate"));
      try
      {
        String[] str = jsonstr.split(",");
        for (int i = 0; i < str.length; i++) {
          app.syncStations(str[i], overdate);
        }
        LabelService labelService = (LabelService)BaseContext.getBean("labelService");
        SessionFactory sessionFactory = (SessionFactory)BaseContext.getBean("sessionFactory");
        sessionFactory.evict(Orgunit.class);
        sessionFactory.evict(Humres.class);
        sessionFactory.evict(Stationinfo.class);
        sessionFactory.evict(Stationlink.class);
        sessionFactory.evict(Orgunitlink.class);
        sessionFactory.evict(Sysuser.class);
        sessionFactory.evictQueries();
        this.response.getWriter().print("同步结束！");
      } catch (IOException e) {
        e.printStackTrace();
      }
      return;
    }
  }
}