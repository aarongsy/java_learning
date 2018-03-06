package com.eweaver.app.sap.orgunit;

import com.eweaver.base.AbstractAction;
import com.eweaver.base.BaseContext;
import com.eweaver.base.DataService;
import com.eweaver.base.orgunit.model.Orgunit;
import com.eweaver.base.orgunit.model.Orgunitlink;
import com.eweaver.base.security.model.Sysuser;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringFilter;
import com.eweaver.base.util.StringHelper;
import com.eweaver.humres.base.model.Humres;
import com.eweaver.humres.base.model.Stationinfo;
import com.eweaver.humres.base.model.Stationlink;
import com.eweaver.humres.base.service.StationinfoService;
import com.sap.conn.jco.JCoTable;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.SessionFactory;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class HumreSyncAction
  implements AbstractAction
{
  protected final Log logger = LogFactory.getLog(getClass());
  private HttpServletRequest request;
  private HttpServletResponse response;
  private HttpSession session;
  private DataService dataService;
  private int pageNo;
  private int pageSize;

  public HumreSyncAction(HttpServletRequest request, HttpServletResponse response)
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
      Humre_ZHR_ENTRY_INF_GET app = new Humre_ZHR_ENTRY_INF_GET(
        "ZHR_ENTRY_INF_GET");

      String usrid_low = StringHelper.null2String(StringFilter.filterAll(this.request.getParameter("usrid_low")));
      String usrid_high = StringHelper.null2String(StringFilter.filterAll(this.request.getParameter("usrid_high")));

      String date_low = StringHelper.null2String(StringFilter.filterAll(this.request.getParameter("date_low")));
      String date_high = StringHelper.null2String(StringFilter.filterAll(this.request.getParameter("date_high")));
      JCoTable hrTable;
      if ((date_low.length() > 3) || (date_high.length() > 3))
        hrTable = app.findData2(date_low, date_high);
      else {
        hrTable = app.findData(usrid_low, usrid_high);
      }

      JSONArray array = new JSONArray();
      if (hrTable != null) {
        for (int i = 0; i < hrTable.getNumRows(); i++) {
          JSONObject object = new JSONObject();

          object.put("pernr", StringHelper.null2String(hrTable.getString("PERNR")));
          object.put("usrid1", StringHelper.null2String(hrTable.getString("USRID1")));
          object.put("ename", StringHelper.null2String(hrTable.getString("ENAME")));
          object.put("persg", StringHelper.null2String(hrTable.getString("PERSG")));
          object.put("persk", StringHelper.null2String(hrTable.getString("PERSK")));
          object.put("orgeh", StringHelper.null2String(hrTable.getString("ORGEH")));
          object.put("plans", StringHelper.null2String(hrTable.getString("PLANS")));
          object.put("trfar", StringHelper.null2String(hrTable.getString("TRFAR")));
          object.put("trfgb", StringHelper.null2String(hrTable.getString("TRFGB")));
          object.put("trfgr", StringHelper.null2String(hrTable.getString("TRFGR")));
          object.put("trfst", StringHelper.null2String(hrTable.getString("TRFST")));
          object.put("stext", StringHelper.null2String(hrTable.getString("STEXT")));
          object.put("zzck2", StringHelper.null2String(hrTable.getString("ZZCK2")));
          object.put("zzauf", StringHelper.null2String(hrTable.getString("ZZAUF")));
          object.put("ltext", StringHelper.null2String(hrTable.getString("LTEXT")));
          object.put("gesch", StringHelper.null2String(hrTable.getString("GESCH")));
          object.put("gbdat", StringHelper.null2String(hrTable.getString("GBDAT")));
          object.put("famst", StringHelper.null2String(hrTable.getString("FAMST")));
          object.put("gbort", StringHelper.null2String(hrTable.getString("GBORT")));
          object.put("slart", StringHelper.null2String(hrTable.getString("SLART")));
          object.put("stext1", StringHelper.null2String(hrTable.getString("STEXT1")));
          object.put("usrid", StringHelper.null2String(hrTable.getString("USRID")));
          object.put("cmdata", StringHelper.null2String(hrTable.getString("CMDATA")));
          object.put("wkdata", StringHelper.null2String(hrTable.getString("WKDATA")));
          object.put("icnum", StringHelper.null2String(hrTable.getString("ICNUM")));
          object.put("ltext1", StringHelper.null2String(hrTable.getString("LTEXT1")));

          array.add(object);
          hrTable.nextRow();
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
      Humre_ZHR_ENTRY_INF_GET app = new Humre_ZHR_ENTRY_INF_GET(
        "ZHR_ENTRY_INF_GET");
      StationinfoService stationinfoService = (StationinfoService)
        BaseContext.getBean("stationinfoService");
      Date start = new Date();
      try {
        String[] str = jsonstr.split(",");
        for (int i = 0; i < str.length; i++) {
          app.syncHumre(str[i]);
        }
        stationinfoService.updateAllStationHumres();

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
      } catch (ParseException e) {
        e.printStackTrace();
      }
      return;
    }
  }
}