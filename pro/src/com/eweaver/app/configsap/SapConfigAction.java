package com.eweaver.app.configsap;

import com.eweaver.base.AbstractAction;
import com.eweaver.base.BaseContext;
import com.eweaver.base.DataService;
import com.eweaver.base.IDGernerator;
import com.eweaver.base.util.StringHelper;
import com.eweaver.workflow.form.model.Forminfo;
import com.eweaver.workflow.form.service.ForminfoService;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class SapConfigAction
  implements AbstractAction
{
  protected final Log logger = LogFactory.getLog(getClass());
  private HttpServletRequest request;
  private HttpServletResponse response;
  private HttpSession session;
  private DataService dataService;

  public SapConfigAction(HttpServletRequest request, HttpServletResponse response)
  {
    this.request = request;
    this.response = response;
    this.session = request.getSession();
    this.dataService = new DataService();
  }

  public void execute()
    throws IOException, ServletException
  {
    String action = StringHelper.null2String(this.request.getParameter("action"));
    if ("create".equals(action)) {
      String functionname = StringHelper.null2String(this.request.getParameter("functionname"));
      String functionremark = StringHelper.null2String(this.request.getParameter("functionremark"));
      String formid = StringHelper.null2String(this.request.getParameter("formid"));
      SapConfigService scService = new SapConfigService();
      ForminfoService fiService = (ForminfoService)BaseContext.getBean("forminfoService");
      Forminfo fi = fiService.getForminfoById(formid);
      SapConfig function = new SapConfig(IDGernerator.getUnquieID(), "", functionname, functionremark, "function", fi.getObjtablename(), "", "", fi.getObjname(), "0", "");
      try {
        this.response.getWriter().print(scService.createRfc(function));
      } catch (IOException e) {
        e.printStackTrace();
      } catch (Exception e) {
        e.printStackTrace();
      }
      return;
    }if ("overload".equals(action)) {
      String rfcid = StringHelper.null2String(this.request.getParameter("rfcid"));
      SapConfigService scService = new SapConfigService();
      try {
        scService.overloadRfc(scService.findSapConfigById(rfcid));
      } catch (Exception e) {
        e.printStackTrace();
      }
      this.response.sendRedirect("/app/sapconfig/configtree.jsp?id=" + rfcid);
      return;
    }if ("submit".equals(action)) {
      String rfcid = StringHelper.null2String(this.request.getParameter("rfcid"));
      SapConfigService scService = new SapConfigService();
      List sapConfigs = scService.findSapConfigs(rfcid);
      List updatesapConfigs = new ArrayList();
      for (int i = 0; i < sapConfigs.size(); i++) {
        if (("parameter".equals(((SapConfig)sapConfigs.get(i)).getType())) || ("column".equals(((SapConfig)sapConfigs.get(i)).getType()))) {
          ((SapConfig)sapConfigs.get(i)).setOtabname(StringHelper.null2String(this.request.getParameter(((SapConfig)sapConfigs.get(i)).getId() + "_select")));
          ((SapConfig)sapConfigs.get(i)).setOconvert(StringHelper.null2String(this.request.getParameter(((SapConfig)sapConfigs.get(i)).getId() + "_convert")).replace("'", "'''||'"));
          ((SapConfig)sapConfigs.get(i)).setIsdelete("0");
          updatesapConfigs.add((SapConfig)sapConfigs.get(i));
        }
      }
      scService.updateSapConfigs(updatesapConfigs);
      this.response.sendRedirect("/app/sapconfig/configtree.jsp?id=" + rfcid);
      return;
    }if ("reset".equals(action)) {
      String scid = StringHelper.null2String(this.request.getParameter("scid"));
      String otabid = StringHelper.null2String(this.request.getParameter("otabid"));
      SapConfigService scService = new SapConfigService();
      SapConfig sc = scService.findSapConfigById(scid);
      ForminfoService fiService = (ForminfoService)BaseContext.getBean("forminfoService");
      Forminfo fi = fiService.getForminfoById(otabid);
      sc.setOtabname(fi.getObjtablename());
      sc.setOremark(fi.getObjname());
      scService.updateSapConfig(sc);
      this.response.sendRedirect("/app/sapconfig/configtree.jsp?id=" + sc.getRfcid());
      return;
    }if ("ondelete".equals(action)) {
      String rfcid = StringHelper.null2String(this.request.getParameter("rfcid"));
      SapConfigService scService = new SapConfigService();
      scService.deleteSapConfigsByRfcId(rfcid);
      String pri = "<html><head></head><center><h1>配置已删除成功！</h1></center></html>";

      this.response.getWriter().print(pri);
      return;
    }
    if ("tooutput".equals(action)) {
      String scid = StringHelper.null2String(this.request.getParameter("scid"));
      SapConfigService scService = new SapConfigService();
      SapConfig sc = scService.findSapConfigById(scid);
      scService.inputToOutput(scid);
      this.response.sendRedirect("/app/sapconfig/configtree.jsp?id=" + sc.getRfcid());
      return;
    }
    if ("toinput".equals(action)) {
      String scid = StringHelper.null2String(this.request.getParameter("scid"));
      SapConfigService scService = new SapConfigService();
      SapConfig sc = scService.findSapConfigById(scid);
      scService.outputToInput(scid);
      this.response.sendRedirect("/app/sapconfig/configtree.jsp?id=" + sc.getRfcid());
      return;
    }if ("modify".equals(action)) {
      String scid = StringHelper.null2String(this.request.getParameter("id"));
      String functionremark = StringHelper.null2String(this.request.getParameter("functionremark"));
      SapConfigService scService = new SapConfigService();
      SapConfig sc = scService.findSapConfigById(scid);
      sc.setRemark(functionremark);
      int num = scService.updateFuncRemark(sc);
      if (num > 0)
        this.response.getWriter().print("OK!");
      else
        this.response.getWriter().print("失败!");
      return;
    }
  }
}