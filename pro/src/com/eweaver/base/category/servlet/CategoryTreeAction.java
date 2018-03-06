package com.eweaver.base.category.servlet;

import com.eweaver.base.AbstractAction;
import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.category.model.Category;
import com.eweaver.base.category.service.CategoryService;
import com.eweaver.base.label.service.LabelCustomService;
import com.eweaver.base.menu.service.MenuService;
import com.eweaver.base.util.JSONUtil;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringHelper;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.SessionFactory;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class CategoryTreeAction
  implements AbstractAction
{
  protected final Log logger = LogFactory.getLog(getClass());
  private HttpServletRequest request;
  private HttpServletResponse response;
  private CategoryService categoryService;
  private String id;
  private String pid;
  private String objname;
  private String objdesc;
  private Integer dsporder;
  private Integer otype;
  private Integer mtype;
  private Integer isdelete;
  private String formid;
  private String workflowid;
  private Integer isApprove;
  private Integer importDetail;
  private String docField;
  private String humresid;
  private String createlayoutid;
  private String viewlayoutid;
  private String editlayoutid;
  private String reflayoutid;
  private String printlayoutid;
  private String reportid;
  private String uniquefliter;
  private String actionClazz;
  private String col1;
  private String col2;
  private String col3;
  private Integer isfastnew;
  private Integer isprint;
  private String moduleid;
  private String attachSavePath;
  private Integer docattachcanedit;
  private String refHtmlTemplateId;
  private String refWordTemplateId;
  private String refExcelTemplateId;
  private MenuService menuService;
  private BaseJdbcDao baseJdbcDao;
  private LabelCustomService labelCustomService;

  public CategoryTreeAction(HttpServletRequest request, HttpServletResponse response)
  {
    this.request = request;
    this.response = response;
    this.categoryService = ((CategoryService)BaseContext.getBean("categoryService"));
    this.labelCustomService = ((LabelCustomService)BaseContext.getBean("labelCustomService"));
    this.menuService = ((MenuService)BaseContext.getBean("menuService"));
    this.baseJdbcDao = ((BaseJdbcDao)BaseContext.getBean("baseJdbcDao"));
  }

  public void execute()
    throws IOException, ServletException
  {
    String action = StringHelper.null2String(this.request.getParameter("action"));

    if (action.equalsIgnoreCase("getChildrenForCreate")) {
      PrintWriter objPrintWriter = this.response.getWriter();
      String data = StringHelper.null2String(this.request.getParameter("data"));
      String model = StringHelper.trimToNull(this.request.getParameter("model"));
      String showtotal = StringHelper.trimToNull(this.request.getParameter("showtotal"));
      String tagetUrl = StringHelper.trimToNull(this.request.getParameter("tagetUrl"));

      if (tagetUrl != null) {
        tagetUrl = URLDecoder.decode(tagetUrl, "UTF-8");
      }

      String _pid = StringHelper.trimToNull(JSONUtil.getValueByKey(JSONUtil.getJSONObjectByKey(data, "node"), "objectId"));

      JSONArray jsonArray = new JSONArray();

      List categoryList = this.categoryService.getSubCategoryList(_pid, model);
      for (int i = 0; i < categoryList.size(); i++) {
        Category category1 = (Category)categoryList.get(i);
        String objname = category1.getObjname();
        String objid = category1.getId();

        if ("1".equals(category1.getCol3())) {
          objname = "<a href='#' onclick=doUrl('" + objid + "'); >" + objname + "</a>";
        }

        int childrennum = category1.getChildrennum().intValue();
        if (showtotal != null) {
          int totalOjbs = category1.getTotalObjs().intValue();
          objname = objname + "(" + totalOjbs + ")";
        }

        JSONObject jsonObject = new JSONObject();
        jsonObject.put("title", objname);
        jsonObject.put("widgetId", objid);
        jsonObject.put("objectId", objid);
        if (tagetUrl == null)
          jsonObject.put("object", category1.getObjname());
        else {
          jsonObject.put("object", tagetUrl + objid);
        }
        jsonObject.put("isFolder", Boolean.valueOf(childrennum > 0));
        jsonArray.add(jsonObject);
      }

      objPrintWriter.print(jsonArray.toString());
      return;
    }

    if (action.equalsIgnoreCase("getChildrenForSelect")) {
      PrintWriter objPrintWriter = this.response.getWriter();
      String data = StringHelper.null2String(this.request.getParameter("data"));
      String model = StringHelper.trimToNull(this.request.getParameter("model"));
      String showtotal = StringHelper.trimToNull(this.request.getParameter("showtotal"));
      String tagetUrl = StringHelper.trimToNull(this.request.getParameter("tagetUrl"));
      String categoryid = StringHelper.trimToNull(this.request.getParameter("categoryid"));
      String reportid = StringHelper.trimToNull(this.request.getParameter("reportid"));
      if ("Docbase".equalsIgnoreCase(model))
        tagetUrl = this.request.getContextPath() + "/ServiceAction/com.eweaver.document.base.servlet.DocbaseAction?action=search&from=search&reportid=" + reportid + "&categoryid=";
      else {
        tagetUrl = this.request.getContextPath() + "/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&isformbase=1&categoryid=";
      }
      String _pid = StringHelper.null2String(this.request.getParameter("node"));
      if (_pid.equals("r00t")) {
        _pid = categoryid;
      }
      JSONArray jsonArray = new JSONArray();
      List categoryList = this.categoryService.getSubCategoryList2(_pid, null, null, null);
      for (int i = 0; i < categoryList.size(); i++) {
        Category category1 = (Category)categoryList.get(i);
        String objname = this.labelCustomService.getLabelNameByCategoryForCurrentLanguage(category1);

        String objid = category1.getId();
        int childrennum = category1.getChildrennum().intValue();

        JSONObject jsonObject = new JSONObject();
        jsonObject.put("text", objname);
        jsonObject.put("allowDrag", Boolean.valueOf(false));
        jsonObject.put("id", objid);
        jsonObject.put("hrefTarget", "categoryframe");
        jsonObject.put("href", tagetUrl + objid);
        if (childrennum > 0) {
          jsonObject.put("leaf", Boolean.valueOf(false));
        } else {
          jsonObject.put("expanded", Boolean.valueOf(true));
          jsonObject.put("leaf", Boolean.valueOf(false));
          jsonObject.put("'cls'", "x-tree-node-collapsed");
        }
        jsonArray.add(jsonObject);
      }

      objPrintWriter.print(jsonArray.toString());
      return;
    }

    if (action.equalsIgnoreCase("getChildren")) {
      PrintWriter objPrintWriter = this.response.getWriter();
      String data = StringHelper.null2String(this.request.getParameter("data"));

      String _pid = StringHelper.trimToNull(JSONUtil.getValueByKey(JSONUtil.getJSONObjectByKey(data, "node"), "objectId"));

      JSONArray jsonArray = new JSONArray();
      List categoryList = this.categoryService.getSubCategoryList2(_pid, null, null, null);
      for (int i = 0; i < categoryList.size(); i++) {
        Category category1 = (Category)categoryList.get(i);
        String objname = category1.getObjname();
        String objid = category1.getId();

        int childrennum = category1.getChildrennum().intValue();

        JSONObject jsonObject = new JSONObject();

        jsonObject.put("title", objname);
        jsonObject.put("widgetId", objid);
        jsonObject.put("objectId", objid);
        jsonObject.put("object", "categorymodify.jsp?id=" + objid);
        jsonObject.put("isFolder", Boolean.valueOf(childrennum > 0));
        jsonArray.add(jsonObject);
      }

      objPrintWriter.print(jsonArray.toString());
      return;
    }
    if (action.equalsIgnoreCase("getChildrenExt")) {
      String moduleid = StringHelper.trimToNull(this.request.getParameter("moduleid"));
      PrintWriter objPrintWriter = this.response.getWriter();
      String _pid = StringHelper.null2String(this.request.getParameter("node"));
      String browser = StringHelper.null2String(this.request.getParameter("browser"));
      String sqlwhere = StringHelper.null2String(this.request.getParameter("sqlwhere"));
      sqlwhere = StringHelper.getDecodeStr(sqlwhere);
      if ((!_pid.equals("r00t")) && (!StringHelper.isEmpty(moduleid)))
        moduleid = null;
      if (_pid.equals("r00t")) {
        _pid = null;
      }
      JSONArray jsonArray = new JSONArray();
      List categoryList = new ArrayList();
      categoryList = this.categoryService.getSubCategoryList2(_pid, null, null, null, moduleid, sqlwhere);

      for (int i = 0; i < categoryList.size(); i++) {
        Category category1 = (Category)categoryList.get(i);

        String objname = this.labelCustomService.getLabelNameByCategoryForCurrentLanguage(category1);
        String objid = category1.getId();
        int childrennum = category1.getChildrennum().intValue();
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("text", objname);
        jsonObject.put("allowDrag", Boolean.valueOf(false));
        jsonObject.put("id", objid);
        if (StringHelper.isEmpty(browser)) {
          jsonObject.put("hrefTarget", "categoryframe");
          jsonObject.put("href", "categorymodify.jsp?moduleid=" + moduleid + "&id=" + objid);
        } else {
          jsonObject.put("hrefTarget", "");
          jsonObject.put("href", "");
        }
        if (childrennum > 0) {
          jsonObject.put("leaf", Boolean.valueOf(false));
        } else {
          jsonObject.put("expanded", Boolean.valueOf(true));
          jsonObject.put("leaf", Boolean.valueOf(false));
          jsonObject.put("'cls'", "x-tree-node-collapsed");
        }

        jsonArray.add(jsonObject);
      }

      objPrintWriter.print(jsonArray.toString());
      return;
    }
    if (action.equalsIgnoreCase("getCategoryList")) {
      PrintWriter objPrintWriter = this.response.getWriter();
      String objname = StringHelper.trimToNull(this.request.getParameter("objname"));
      String moduleid = StringHelper.trimToNull(this.request.getParameter("moduleid"));
      String sqlwhere = StringHelper.null2String(this.request.getParameter("sqlwhere"));
      sqlwhere = StringHelper.getDecodeStr(sqlwhere);
      List categoryList = this.categoryService.getCategoryListInfo(objname, moduleid, sqlwhere);

      JSONArray jsonArray = new JSONArray();
      for (int i = 0; i < categoryList.size(); i++) {
        Category category1 = (Category)categoryList.get(i);
        String objname1 = category1.getObjname();
        String objid = category1.getId();

        String categoryDir = getCategoryDirectory(objid);
        JSONObject jsonObject = new JSONObject();

        jsonObject.put("objname", objname1);
        jsonObject.put("objid", objid);
        jsonObject.put("categoryDir", categoryDir);
        jsonArray.add(jsonObject);
      }
      JSONObject objectresult = new JSONObject();
      objectresult.put("result", jsonArray);
      objPrintWriter.print(objectresult.toString());
      return;
    }

    if (action.equalsIgnoreCase("getChildrenForRightTransfer")) {
      PrintWriter objPrintWriter = this.response.getWriter();
      String data = StringHelper.null2String(this.request.getParameter("data"));

      String _pid = StringHelper.trimToNull(JSONUtil.getValueByKey(JSONUtil.getJSONObjectByKey(data, "node"), "objectId"));

      JSONArray jsonArray = new JSONArray();
      List categoryList = this.categoryService.getSubCategoryList2(_pid, null, null, null);
      for (int i = 0; i < categoryList.size(); i++) {
        Category category1 = (Category)categoryList.get(i);
        String objname = category1.getObjname();
        String objid = category1.getId();

        int childrennum = category1.getChildrennum().intValue();

        JSONObject jsonObject = new JSONObject();

        jsonObject.put("title", "<a href='#' onclick=doUrl('" + objid + "'); >" + objname + "</a>");
        jsonObject.put("widgetId", objid);
        jsonObject.put("objectId", objid);
        jsonObject.put("object", objname);
        jsonObject.put("isFolder", Boolean.valueOf(childrennum > 0));
        jsonArray.add(jsonObject);
      }

      objPrintWriter.print(jsonArray.toString());
      return;
    }
    if (action.equalsIgnoreCase("createChild")) {
      PrintWriter objPrintWriter = this.response.getWriter();
      String data = StringHelper.null2String(this.request.getParameter("data"));

      JSONObject jsonObject = JSONUtil.getJSONObjectByKey(data, "data");
      objPrintWriter.print(jsonObject.toString());
      return;
    }

    if (action.equalsIgnoreCase("removeNode")) {
      PrintWriter objPrintWriter = this.response.getWriter();
      String data = StringHelper.null2String(this.request.getParameter("data"));

      String objid = StringHelper.trimToNull(JSONUtil.getValueByKey(JSONUtil.getJSONObjectByKey(data, "node"), "objectId"));

      String retval = "true";
      if (objid != null)
      {
        Category category = this.categoryService.getCategoryById(objid);
        String pid = category.getPid();
        if (!this.categoryService.deleteCategory(objid)) {
          retval = "false";
        } else {
          SessionFactory sessionFactory = (SessionFactory)BaseContext.getBean("sessionFactory");
          if (!StringHelper.isEmpty(pid))
            sessionFactory.evict(category.getClass(), pid);
        }
      }
      objPrintWriter.print(retval);
      return;
    }
    if (action.equalsIgnoreCase("move"))
    {
      String objid = StringHelper.null2String(this.request.getParameter("categorynodeid"));

      String nodeid = StringHelper.null2String(this.request.getParameter("modulenodeid"));
      Category categoryp = this.categoryService.getCategoryById(objid);
      categoryp.setModuleid(nodeid);
      this.categoryService.modifyCategory(categoryp);
      List categoryList = this.categoryService.getSubCategoryList2(objid, null, null, null);
      for (int i = 0; i < categoryList.size(); i++)
      {
        Category categorymodule = (Category)categoryList.get(i);
        categorymodule.setModuleid(nodeid);
        this.categoryService.modifyCategory(categorymodule);
      }
    }

    if (action.equalsIgnoreCase("removeNodeExt")) {
      PrintWriter objPrintWriter = this.response.getWriter();
      String objid = StringHelper.null2String(this.request.getParameter("node"));

      String retval = "{success:true}";
      if (objid != null)
      {
        Category category = this.categoryService.getCategoryById(objid);
        String pid = category.getPid();
        if (!this.categoryService.deleteCategory(objid)) {
          retval = "{success:false}";
        } else {
          SessionFactory sessionFactory = (SessionFactory)BaseContext.getBean("sessionFactory");
          if (!StringHelper.isEmpty(pid))
            sessionFactory.evict(category.getClass(), pid);
        }
      }
      objPrintWriter.print(retval);
      return;
    }
    if (action.equalsIgnoreCase("modify")) {
      PrintWriter objPrintWriter = this.response.getWriter();

      Category category = new Category();
      String id = null;
      String pid = null;
      String oid = null;
      try {
        id = StringHelper.trimToNull(this.request.getParameter("id"));
        pid = StringHelper.trimToNull(this.request.getParameter("pid"));
        if ((pid != null) && (pid.equals("r00t")))
          pid = null;
        oid = StringHelper.trimToNull(this.request.getParameter("oid"));
        this.objname = StringHelper.trimToNull(this.request.getParameter("objname"));
        this.objdesc = StringHelper.trimToNull(this.request.getParameter("objdesc"));
        this.dsporder = Integer.valueOf(NumberHelper.string2Int(StringHelper.null2String(this.request.getParameter("dsporder")), 1));
        this.otype = this.dsporder;
        this.mtype = Integer.valueOf(2);
        this.isdelete = Integer.valueOf(0);
        this.col1 = StringHelper.trimToNull(this.request.getParameter("col1"));
        this.col2 = null;
        this.col3 = null;

        this.formid = StringHelper.trimToNull(this.request.getParameter("formid"));
        this.workflowid = StringHelper.trimToNull(this.request.getParameter("workflowid"));
        this.isApprove = Integer.valueOf(NumberHelper.string2Int(StringHelper.null2String(this.request.getParameter("isApprove"))));
        this.docField = StringHelper.trimToNull(this.request.getParameter("docField"));

        this.humresid = StringHelper.trimToNull(this.request.getParameter("humresid"));
        this.createlayoutid = StringHelper.trimToNull(this.request.getParameter("createlayoutid"));
        this.viewlayoutid = StringHelper.trimToNull(this.request.getParameter("viewlayoutid"));
        this.editlayoutid = StringHelper.trimToNull(this.request.getParameter("editlayoutid"));
        this.reflayoutid = StringHelper.trimToNull(this.request.getParameter("reflayoutid"));
        this.printlayoutid = StringHelper.trimToNull(this.request.getParameter("printlayoutid"));
        this.reportid = StringHelper.trimToNull(this.request.getParameter("reportid"));
        this.isfastnew = Integer.valueOf(NumberHelper.string2Int(StringHelper.null2String(this.request.getParameter("isfastnew")), 0));
        this.isprint = Integer.valueOf(NumberHelper.string2Int(StringHelper.null2String(this.request.getParameter("isprint")), 0));
        this.uniquefliter = StringHelper.trimToNull(this.request.getParameter("uniquefliter"));
        this.actionClazz = StringHelper.trimToNull(this.request.getParameter("actionClazz"));
        this.moduleid = StringHelper.trimToNull(this.request.getParameter("moduleid"));

        Integer deleteType = Integer.valueOf(NumberHelper.string2Int(StringHelper.null2String(this.request.getParameter("deleteType"))));
        this.attachSavePath = StringHelper.trimToNull(this.request.getParameter("attachSavePath"));
        this.docattachcanedit = Integer.valueOf(NumberHelper.string2Int(this.request.getParameter("docattachcanedit"), 0));
        this.refHtmlTemplateId = StringHelper.trimToNull(this.request.getParameter("refHtmlTemplateId"));
        this.refWordTemplateId = StringHelper.trimToNull(this.request.getParameter("refWordTemplateId"));
        this.refExcelTemplateId = StringHelper.trimToNull(this.request.getParameter("refExcelTemplateId"));

        category.setId(id);
        category.setPid(pid);
        category.setObjname(this.objname);
        category.setObjdesc(this.objdesc);
        category.setDsporder(this.dsporder);
        category.setOtype(this.otype);
        category.setMtype(this.mtype);
        category.setIsdelete(this.isdelete);
        if (StringHelper.isEmpty(this.formid)) {
          this.formid = category.getPFormid();
        }
        category.setFormid(this.formid);
        category.setCreatelayoutid(this.createlayoutid);
        category.setViewlayoutid(this.viewlayoutid);
        category.setEditlayoutid(this.editlayoutid);
        category.setReflayoutid(this.reflayoutid);
        category.setPrintlayoutid(this.printlayoutid);
        category.setReportid(this.reportid);
        category.setUniquefliter(this.uniquefliter);
        category.setActionClazz(this.actionClazz);
        category.setCol1(this.col1);
        category.setCol2(this.col2);
        category.setCol3(this.col3);
        category.setIsfastnew(this.isfastnew);
        category.setIsprint(this.isprint);
        category.setModuleid(this.moduleid);
        category.setIsApprove(this.isApprove);
        category.setImportDetail(this.importDetail);
        category.setWorkflowid(this.workflowid);
        category.setDocField(this.docField);
        category.setDeleteType(deleteType);
        category.setAttachSavePath(this.attachSavePath);
        category.setDocattachcanedit(this.docattachcanedit);
        category.setRefHtmlTemplateId(this.refHtmlTemplateId);
        category.setRefWordTemplateId(this.refWordTemplateId);
        category.setRefExcelTemplateId(this.refExcelTemplateId);

        if (StringHelper.isEmpty(id)) {
          this.categoryService.createCategory(category);
        }
        else {
          this.labelCustomService.createOrModifyDefaultCNLabel(category);
          this.categoryService.modifyCategory(category);
        }

        SessionFactory sessionFactory = (SessionFactory)BaseContext.getBean("sessionFactory");
        if (!StringHelper.isEmpty(pid))
          sessionFactory.evict(category.getClass(), pid);
        if ((!StringHelper.isEmpty(oid)) && (!oid.equals(pid)))
          sessionFactory.evict(category.getClass(), oid);
      }
      catch (Exception e)
      {
        e.printStackTrace();
      }
      boolean iscreate = false;
      if (StringHelper.isEmpty(id)) {
        iscreate = true;
      }
      PrintWriter writer = this.response.getWriter();
      try {
        writer.write("{id:'" + category.getId() + "',iscreate:" + iscreate + "}");
      } catch (Exception e) {
        e.printStackTrace();
      } finally {
        writer.flush();
        writer.close();
      }
      return;
    }
  }

  public String getCategoryDirectory(String categoryid) {
    Category category = this.categoryService.getCategoryById(categoryid);
    if (category != null) {
      String categoryDir = "";
      if ((category.getPid() == null) || (StringHelper.isEmpty(category.getPid()))) {
        String moduleid = category.getModuleid();
        String sql2 = "select id,objname from module where id='" + moduleid + "'";
        List moduleList = this.baseJdbcDao.executeSqlForList(sql2);
        if ((moduleList != null) && (moduleList.size() != 0)) {
          String mname = (String)((Map)moduleList.get(0)).get("objname");
          categoryDir = StringHelper.null2String(mname);
        }
        return categoryDir + "/" + StringHelper.null2String(category.getObjname());
      }
      String newId = category.getPid();
      categoryDir = getCategoryDirectory(newId) + "/" + StringHelper.null2String(category.getObjname());
      return categoryDir;
    }

    return "";
  }
}