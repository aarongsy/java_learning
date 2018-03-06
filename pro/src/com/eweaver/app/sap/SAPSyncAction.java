package com.eweaver.app.sap;

import com.eweaver.app.sap.common.SAPQuerySyncService;
import com.eweaver.base.AbstractAction;
import com.eweaver.base.BaseContext;
import com.eweaver.base.DataService;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringHelper;
import com.eweaver.workflow.form.model.Formfield;
import com.eweaver.workflow.form.service.FormfieldService;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class SAPSyncAction
  implements AbstractAction
{
  protected final Log logger = LogFactory.getLog(getClass());
  private HttpServletRequest request;
  private HttpServletResponse response;
  private HttpSession session;
  private DataService dataService;
  private int pageNo;
  private int pageSize;
  private boolean ispage;

  public SAPSyncAction(HttpServletRequest request, HttpServletResponse response)
  {
    this.request = request;
    this.response = response;
    this.session = request.getSession();
    this.dataService = new DataService();
  }

  public void execute() throws IOException, ServletException
  {
    String action = StringHelper.null2String(this.request.getParameter("action"));
    this.ispage = false;
    if ("1".equals(StringHelper.null2String(this.request.getParameter("ispage")))) {
      this.ispage = true;
    }
    this.pageNo = NumberHelper.string2Int(this.request.getParameter("pageno"), 1);
    this.pageSize = NumberHelper.string2Int(this.request.getParameter("pagesize"), 20);
    if (!StringHelper.isEmpty(this.request.getParameter("start")))
      this.pageNo = (NumberHelper.string2Int(this.request.getParameter("start"), 0) / this.pageSize + 1);
    if (action.equals("browser"))
      getSAPBrowserData();
  }

  public void getSAPBrowserData()
  {
    String formfieldid = StringHelper.null2String(this.request.getParameter("formfieldid"));
    FormfieldService formfieldService = (FormfieldService)BaseContext.getBean("formfieldService");
    Formfield formfield = formfieldService.getFormfieldById(formfieldid);
    String sapconfig = StringHelper.null2String(formfield.getSapconfig());
    net.sf.json.JSONObject sapConfigObject = net.sf.json.JSONObject.fromObject(sapconfig);
    String functionname = StringHelper.null2String(sapConfigObject.get("functionname"));
    String resulttablename = StringHelper.null2String(sapConfigObject.get("resulttablename"));
    net.sf.json.JSONArray queryparamArray = sapConfigObject.getJSONArray("queryparam");
    net.sf.json.JSONArray resultfieldnamesArray = sapConfigObject.getJSONArray("resultfieldnames");
    String paramName = "";
    String paramValue = "";
    String resultfieldnames = "";
    for (int i = 0; i < queryparamArray.size(); i++) {
      net.sf.json.JSONObject tmp = net.sf.json.JSONObject.fromObject(StringHelper.null2String(queryparamArray.get(i)));
      String pn = StringHelper.null2String(tmp.get("paramname"));
      if (!StringHelper.isEmpty(pn))
      {
        String pv = StringHelper.null2String(this.request.getParameter(pn));
        if (StringHelper.isEmpty(pv)) {
          pv = "null";
        }
        paramName = paramName + "," + pn;
        paramValue = paramValue + "," + pv;
      }
    }
    if (paramName.length() > 0) {
      paramName = paramName.substring(1);
    }
    if (paramValue.length() > 0) {
      paramValue = paramValue.substring(1);
    }
    if (this.ispage) {
      paramName = paramName + ",PAGE_NO";
      paramValue = paramValue + "," + this.pageNo;
    }
    for (int i = 0; i < resultfieldnamesArray.size(); i++) {
      net.sf.json.JSONObject tmp = net.sf.json.JSONObject.fromObject(StringHelper.null2String(resultfieldnamesArray.get(i)));
      String rfn = StringHelper.null2String(tmp.get("fieldname"));
      if (!StringHelper.isEmpty(rfn))
      {
        resultfieldnames = resultfieldnames + "," + rfn;
      }
    }
    if (resultfieldnames.length() > 0) {
      resultfieldnames = resultfieldnames.substring(1);
    }
    SAPQuerySyncService sapSelectSyncService = new SAPQuerySyncService();
    org.json.simple.JSONObject result = sapSelectSyncService.getSapTable(functionname, paramName, paramValue, resulttablename, resultfieldnames, this.ispage);
    org.json.simple.JSONObject objectresult = new org.json.simple.JSONObject();
    int pageCount = NumberHelper.getIntegerValue(result.get("pageCount"), 0).intValue();
    org.json.simple.JSONArray array = (org.json.simple.JSONArray)result.get("array");
    objectresult.put("result", array);
    objectresult.put("totalcount", Integer.valueOf(pageCount));
    try {
      this.response.getWriter().print(objectresult.toString());
    } catch (IOException e) {
      e.printStackTrace();
    }
  }
}