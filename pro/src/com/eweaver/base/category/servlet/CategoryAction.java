package com.eweaver.base.category.servlet;

import com.eweaver.base.AbstractAction;
import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.Page;
import com.eweaver.base.category.model.Category;
import com.eweaver.base.category.service.CategoryService;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringHelper;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

public class CategoryAction
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
  private String col1;
  private String col2;
  private String col3;
  private String categoryname;
  private String model;
  private BaseJdbcDao baseJdbcDao;
  private int pageNo;
  private int pageSize;

  public CategoryAction(HttpServletRequest request, HttpServletResponse response)
  {
    this.request = request;
    this.response = response;
    this.categoryService = ((CategoryService)BaseContext.getBean("categoryService"));

    this.baseJdbcDao = ((BaseJdbcDao)BaseContext.getBean("baseJdbcDao"));
  }

  public void execute()
    throws IOException, ServletException
  {
    String action = StringHelper.trimToNull(this.request.getParameter("action")).trim().toLowerCase();

    this.pageNo = NumberHelper.string2Int(this.request.getParameter("pageno"), 1);
    this.pageSize = NumberHelper.string2Int(this.request.getParameter("pagesize"), 20);
    if (!StringHelper.isEmpty(this.request.getParameter("start"))) {
      this.pageNo = (NumberHelper.string2Int(this.request.getParameter("start"), 0) / this.pageSize + 1);
    }
    this.id = StringHelper.trimToNull(this.request.getParameter("id"));
    this.pid = StringHelper.trimToNull(this.request.getParameter("pid"));
    if ((this.pid != null) && (this.pid.equals("r00t")))
      this.pid = null;
    this.objname = StringHelper.trimToNull(this.request.getParameter("objname"));
    this.objdesc = StringHelper.trimToNull(this.request.getParameter("objdesc"));
    this.dsporder = Integer.valueOf(NumberHelper.string2Int(this.request.getParameter("dsporder"), 1));
    this.otype = Integer.valueOf(NumberHelper.string2Int(this.request.getParameter("dsporder"), 1));
    this.mtype = Integer.valueOf(2);
    this.isdelete = Integer.valueOf(0);
    this.col1 = StringHelper.trimToNull(this.request.getParameter("col1"));
    this.col2 = StringHelper.trimToNull(this.request.getParameter("col2"));
    this.col3 = StringHelper.trimToNull(this.request.getParameter("col3"));

    this.categoryname = StringHelper.null2String(this.request.getParameter("categoryname"));

    this.model = StringHelper.null2String(this.request.getParameter("model"));
    String messageid = "";
    Category category = getCategory();
    if (action.equals("searchm")) {
      String method = StringHelper.null2String(this.request.getParameter("method"));

      List list = new ArrayList();
      if (method.equals("create")) {
        list = this.categoryService.searchCategoryByName(this.categoryname, this.model);
      }
      else {
        list = this.categoryService.searchCategoryByName1(this.categoryname, this.model);
      }

      this.request.setAttribute("results", list);
      this.request.setAttribute("from", "search");
      this.request.getRequestDispatcher("/base/category/categorybrowserm.jsp?model=" + this.model).forward(this.request, this.response);
    }

    if (action.equals("search")) {
      String method = StringHelper.null2String(this.request.getParameter("method"));

      List list = new ArrayList();
      if (method.equals("create")) {
        list = this.categoryService.searchCategoryByName(this.categoryname, this.model);
      }
      else {
        list = this.categoryService.searchCategoryByName1(this.categoryname, this.model);
      }

      this.request.setAttribute("results", list);
      this.request.setAttribute("from", "search");
      this.request.getRequestDispatcher("/base/category/categorybrowser.jsp?model=" + this.model).forward(this.request, this.response);
    }

    if (action.equals("create")) {
      this.categoryService.createCategory(category);
      this.response.sendRedirect(this.request.getContextPath() + "/base/category/categorymodify.jsp?isrefresh=1&messageid=" + messageid + "&id=" + category.getId());
    }

    if (action.equals("modify")) {
      this.categoryService.modifyCategory(category);
      this.response.sendRedirect(this.request.getContextPath() + "/base/category/categorymodify.jsp?isrefresh=1&messageid=" + messageid + "&id=" + category.getId());
    }

    if (action.equals("delete")) {
      if (this.categoryService.getSubCategoryList2(category.getId(), null, null, null).size() == 0)
      {
        category.setIsdelete(Integer.valueOf(1));
        this.categoryService.modifyCategory(category);
      } else {
        messageid = "402881e70ad99396010ad994399f0001";
        this.response.sendRedirect(this.request.getContextPath() + "/base/category/categorymodify.jsp?isrefresh=1&messageid=" + messageid + "&id=" + category.getId());
      }

    }

    if (action.equals("subcalist")) {
      String sql = "select * from category where pid is null and isdelete=0 order by dsporder,id";
      Page page = this.baseJdbcDao.pagedQuery(sql, this.pageNo, this.pageSize);
      JSONArray array = new JSONArray();
      Iterator i$;
      if (page.getTotalSize() > 0) {
        List result = (List)page.getResult();
        for (i$ = result.iterator(); i$.hasNext(); ) { Object o = i$.next();
          JSONObject object = new JSONObject();
          String id = (String)((Map)o).get("id");
          String objname = ((Map)o).get("objname") == null ? "" : ((Map)o).get("objname").toString();
          object.put("id", id);
          object.put("objname", objname);
          array.add(object);
        }
      }

      JSONObject objectresult = new JSONObject();
      objectresult.put("result", array);
      objectresult.put("totalcount", Integer.valueOf(page.getTotalSize()));
      this.response.getWriter().print(objectresult.toString());
      return;
    }
    if (action.equals("getcategorylist")) {
      String model = StringHelper.null2String(this.request.getParameter("model"));
      String pid = StringHelper.null2String(this.request.getParameter("pid"));
      List cl = this.categoryService.getSubCategoryList(pid, model);
      JSONArray array = new JSONArray();
      if (cl.size() > 0) {
        for (Category c : cl) {
          JSONObject object = new JSONObject();
          String id = c.getId();
          String objname = c.getObjname() == null ? "" : c.getObjname();
          object.put("id", id);
          object.put("objname", objname);
          object.put("col3", c.getCol3());
          array.add(object);
        }
      }

      this.response.getWriter().print(array.toString());
      return;
    }
    if (action.equalsIgnoreCase("saveSortResult")) {
      String sortResult = StringHelper.null2String(this.request.getParameter("sortResult"));
      if (!StringHelper.isEmpty(sortResult)) {
        PrintWriter writer = this.response.getWriter();
        try {
          JSONArray categoryDatas = (JSONArray)JSONValue.parse(sortResult);
          for (int i = 0; i < categoryDatas.size(); i++) {
            JSONObject categoryData = (JSONObject)categoryDatas.get(i);
            String id = StringHelper.null2String(categoryData.get("id"));
            Category c = this.categoryService.getCategoryById(id);
            if ((c != null) && (!StringHelper.isEmpty(c.getId()))) {
              Long colInStartDocument = (Long)categoryData.get("colInStartDocument");
              Long dsporderInStartDocument = (Long)categoryData.get("dsporderInStartDocument");
              c.setColInStartDocument(Integer.valueOf(colInStartDocument.intValue()));
              c.setDsporderInStartDocument(Integer.valueOf(dsporderInStartDocument.intValue()));
              this.categoryService.modifyCategory(c);
            }
          }
          writer.print("success");
        }
        catch (Exception e) {
          e.printStackTrace();
          writer.print(e.getMessage());
        } finally {
          if (writer != null) {
            writer.flush();
            writer.close();
          }
        }
      }
    }
  }

  private Category getCategory() {
    Category category = new Category();
    category.setId(this.id);
    category.setPid(this.pid);
    category.setObjname(this.objname);
    category.setObjdesc(this.objdesc);
    category.setDsporder(this.dsporder);
    category.setOtype(this.otype);
    category.setMtype(this.mtype);
    category.setIsdelete(this.isdelete);
    category.setCol1(this.col1);
    category.setCol2(this.col2);
    category.setCol3(this.col3);
    return category;
  }
}