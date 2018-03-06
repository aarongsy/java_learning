package com.eweaver.base.category.service;

import com.eweaver.base.AbstractBaseService;
import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.DataService;
import com.eweaver.base.IDGernerator;
import com.eweaver.base.category.dao.CategoryDao;
import com.eweaver.base.category.dao.CategorylinkDao;
import com.eweaver.base.category.model.Category;
import com.eweaver.base.category.model.Categorylink;
import com.eweaver.base.security.service.logic.PermissiondetailService;
import com.eweaver.base.util.StringHelper;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.springframework.jdbc.core.JdbcTemplate;

public class CategoryService extends AbstractBaseService
{
  private BaseJdbcDao baseJdbcDao;
  private CategoryDao categoryDao;
  private CategorylinkDao categorylinkDao;
  private PermissiondetailService permissiondetailService;

  public BaseJdbcDao getBaseJdbcDao()
  {
    return this.baseJdbcDao;
  }

  public void setBaseJdbcDao(BaseJdbcDao baseJdbcDao) {
    this.baseJdbcDao = baseJdbcDao;
  }
  public Connection saveHibernateConnection(boolean isClose) {
    BaseJdbcDao jdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");

    String sql = "insert into test1 values('1','conn11111')";

    this.baseJdbcDao.update(sql);
    Category category = new Category();
    String id = IDGernerator.getUnquieID();

    jdbc = null;
    return null;
  }

  public void createCategory(Category category)
  {
    this.categoryDao.createCategory(category);
  }

  public void modifyCategory(Category category) {
    if ((!category.getId().equals(category.getPid())) && (!isAncestor(category.getPid(), category.getId())))
    {
      this.categoryDao.modifyCategory(category);
    }
  }

  public void saveOrUpdate(Category category) {
    if ((!category.getId().equals(category.getPid())) && (!isAncestor(category.getPid(), category.getId())))
    {
      this.categoryDao.saveOrUpdate(category);
    }
  }

  public boolean deleteCategory(Category category) {
    return deleteCategory(category.getId());
  }

  public boolean deleteCategory(String id) {
    if (getSubCategoryList2(id, null, null, null).size() == 0) {
      this.categoryDao.deleteCategory(id);
      deleteCategorylinkByCategory(id);
      return true;
    }
    return false;
  }

  public List getCategoryListInfo(String objname, String moduleid)
  {
    return this.categoryDao.getCategoryList(objname, moduleid);
  }

  public List getCategoryListInfo(String objname, String moduleid, String sqlwhere) {
    return this.categoryDao.getCategoryList(objname, moduleid, sqlwhere);
  }

  public Category getCategoryById(String id) {
    return this.categoryDao.getCategory(id);
  }

  public List<Category> getCategoryListById(String[] categoryids) {
    List categoryList = new ArrayList();
    for (String id : categoryids) {
      Category category = getCategoryById(id);
      if ((category != null) && (category.getId() != null)) {
        categoryList.add(category);
      }
    }
    return categoryList;
  }

  public List<Category> getCategoryListByObj(String objid) {
    ArrayList categoryList = new ArrayList();
    for (Categorylink categorylink : getCategorylinkByObj(objid)) {
      categoryList.add(getCategoryById(categorylink.getCategoryid()));
    }
    return categoryList;
  }

  public Category getCategoryByObj(String objid) {
    List categoryList = getCategoryListByObj(objid);
    Category category = null;
    if (categoryList.size() > 0)
      category = (Category)categoryList.get(0);
    return category;
  }

  public String getCategoryidStrByObj(String objid) {
    String categoryidStr = "";
    for (Categorylink categorylink : getCategorylinkByObj(objid)) {
      categoryidStr = categoryidStr + "," + categorylink.getCategoryid();
    }
    if (categoryidStr.length() > 0) categoryidStr = categoryidStr.substring(1, categoryidStr.length());
    return categoryidStr;
  }

  public String getCategoryNameStrByCategory(String categoryids) {
    String objname = "";

    for (String categoryid : StringHelper.null2String(categoryids).split(",")) {
      Category category = getCategoryById(categoryid);
      if ((category != null) && (category.getId() != null) && (category.getObjname() != null)) {
        objname = objname + "," + category.getObjname();
      }
    }
    if (objname.length() > 0) objname = objname.substring(1, objname.length());
    return objname;
  }

  public String getCategoryPath(List<Category> categoryList, String otype, String mtype) {
    String path = "";
    for (Category category : categoryList) {
      path = path + "," + getCategoryPath(category.getId(), otype, mtype);
    }
    if (path.length() > 0)
      path = path.substring(1, path.length());
    return path;
  }

  public String getCategoryPath(String ids, String otype, String mtype) {
    String paths = "";
    String path = "";
    if (ids != null) {
      for (String categoryid : ids.split(",")) {
        for (Category category : getParentCategoryList(categoryid, otype, mtype)) {
          if (category.getObjname() != null) {
            path = category.getObjname() + "/" + path;
          }
        }

        if (path.length() > 0)
          path = path.substring(0, path.length() - 1);
        if (path.length() > 0)
          paths = paths + "," + path;
        path = "";
      }
    }
    if (paths.length() > 0) paths = paths.substring(1, paths.length());

    return paths;
  }

  public String getDocCategoryPath(List<Category> categoryList, String otype, String mtype)
  {
    String path = "";
    for (Category category : categoryList) {
      if (category.getObjname() != null) {
        path = path + "<a href=\"/ServiceAction/com.eweaver.document.base.servlet.DocbaseAction?action=search&from=search&categoryid=" + category.getId() + "\" target=\"_blank\">" + category.getObjname() + "</a>&nbsp;";
      }
    }
    return path;
  }

  public String getDocCategoryPath(String ids, String otype, String mtype)
  {
    String path = "";
    if (ids != null) {
      for (String categoryid : ids.split(",")) {
        Category category = getCategoryById(categoryid);
        if (category.getObjname() != null) {
          path = path + "<a href=\"/ServiceAction/com.eweaver.document.base.servlet.DocbaseAction?action=search&from=search&categoryid=" + categoryid + "\" target=\"_blank\">" + category.getObjname() + "</a>&nbsp;";
        }
      }
    }
    return path;
  }

  public List searchCategoryByName(String categoryname, String model)
  {
    List categorylist = this.categoryDao.searchCategoryByname(categoryname);
    List returnList = new ArrayList();
    for (int i = 0; i < categorylist.size(); i++) {
      Category category = (Category)categorylist.get(i);
      Categorylink categorylink = this.categorylinkDao.getCategorylink(model, category.getId());
      String objid = categorylink.getObjid();

      boolean flag = true;

      if (category.getIsdelete().intValue() == 1) {
        flag = false;
      }

      if (flag) {
        flag = this.permissiondetailService.checkOpttype(objid, 2);
      }
      int returnValue = 0;
      if (flag) {
        category.setCol3(returnValue + "");
        List list = this.categorylinkDao.getCategorylinkByCategory(category.getId(), model);
        category.setTotalObjs(Integer.valueOf(list.size()));
        returnList.add(category);
        returnValue = 1;
      } else {
        returnValue = 2;
      }
    }
    return returnList;
  }

  public List searchCategoryByName1(String categoryname, String model)
  {
    String tModel = null;
    if ("Docbase".equalsIgnoreCase(model)) {
      tModel = "Doctype";
    }
    if ("Product".equalsIgnoreCase(model)) {
      tModel = "Producttype";
    }
    if ("Customer".equalsIgnoreCase(model)) {
      tModel = "Customertype";
    }
    if ("Assets".equalsIgnoreCase(model)) {
      tModel = "Assetstype";
    }
    if ("Project".equalsIgnoreCase(model)) {
      tModel = "Projecttype";
    }
    if ("Contract".equalsIgnoreCase(model)) {
      tModel = "Contracttype";
    }
    if ("Provider".equalsIgnoreCase(model)) {
      tModel = "Providertype";
    }
    List listObj = new ArrayList();

    listObj.add("40288148117d0ddc01117d8c36e00dd4");
    List categoryList = getchild("40288148117d0ddc01117d8c36e00dd4", listObj);
    List categorylist = this.categoryDao.searchCategoryByname1(categoryname, categoryList);
    List returnList = new ArrayList();
    for (int i = 0; i < categorylist.size(); i++) {
      Category category = (Category)categorylist.get(i);

      Categorylink categorylink = this.categorylinkDao.getCategorylink(tModel, category.getId());

      String objid = categorylink.getObjid();

      boolean flag = true;

      if (category.getIsdelete().intValue() == 1) {
        flag = false;
      }

      int returnValue = 0;
      if (flag) {
        category.setCol3(returnValue + "");
        List list = this.categorylinkDao.getCategorylinkByCategory(category.getId(), model);
        category.setTotalObjs(Integer.valueOf(list.size()));
        returnList.add(category);
        returnValue = 1;
      } else {
        returnValue = 2;
      }
    }
    return returnList;
  }

  public List<Category> getSubCategoryList(String id, String model)
  {
    String tModel = null;
    if ("Docbase".equalsIgnoreCase(model)) {
      tModel = "Doctype";
    }

    boolean prightflag = false;
    prightflag = this.permissiondetailService.checkOpttype(id, 2);
    String pid = getCategoryById(id).getPid();
    while ((!prightflag) && (pid != null) && (!pid.equals(""))) {
      prightflag = this.permissiondetailService.checkOpttype(pid, 2);
      pid = getCategoryById(pid).getPid();
    }

    List categorylist = this.categoryDao.getSubCategoryList(id, null, null);
    List returnList = new ArrayList();
    for (int i = 0; i < categorylist.size(); i++) {
      Category category = (Category)categorylist.get(i);

      boolean flag = prightflag;

      if (category.getIsdelete().intValue() == 1)
        flag = false;
      else if (!flag)
      {
        flag = this.permissiondetailService.checkOpttype(category.getId(), 2);
      }

      int returnValue = 0;
      if (flag)
        returnValue = 1;
      else {
        returnValue = 2;
      }

      category.setCol3(returnValue + "");
      List list = this.categorylinkDao.getCategorylinkByCategory(category.getId(), model);
      category.setTotalObjs(Integer.valueOf(list.size()));
      returnList.add(category);
    }

    return returnList;
  }

  public int checkSubCategory(Category category, String model, String tModel)
  {
    int returnValue = 0;
    Categorylink categorylink = this.categorylinkDao.getCategorylink(tModel, category.getId());
    String objid = categorylink.getObjid();
    boolean flag = this.permissiondetailService.checkOpttype(objid, 2);
    if (flag) {
      returnValue = 1;
    } else {
      String categoryid = category.getId();
      List sCategorylist = this.categoryDao.getSubCategoryList(categoryid, null, null);
      for (Category sCategory : sCategorylist)
      {
        returnValue = checkSubCategory(sCategory, model, tModel);
        if (returnValue == 1) {
          returnValue = 2;
          return returnValue;
        }
      }
    }
    return returnValue;
  }

  public List<Category> getSubCategoryList2(String id, String model, String otype, String mtype)
  {
    List categorylist = this.categoryDao.getSubCategoryList(id, otype, mtype);
    return categorylist;
  }

  public List<Category> getSubCategoryList2(String pid, String model, String otype, String mtype, String moduleid) {
    List categorylist = this.categoryDao.getSubCategoryList2(pid, otype, mtype, moduleid);
    return categorylist;
  }

  public List<Category> getSubCategoryList2(String pid, String model, String otype, String mtype, String moduleid, String sqlwhere) {
    List categorylist = this.categoryDao.getSubCategoryList2(pid, otype, mtype, moduleid, sqlwhere);
    return categorylist;
  }

  public String getUniqueRequestId(String formname, String[] fliterlist, String[] valuelist)
  {
    String returnValue = "";
    boolean isparafull = true;
    if ((fliterlist != null) && (valuelist != null) && (fliterlist.length == valuelist.length)) {
      String sql = "select requestid from " + formname + " where ";
      for (int i = 0; i < fliterlist.length; i++) {
        if (!StringHelper.isEmpty(valuelist[i])) {
          if (i == 0)
            sql = sql + fliterlist[i] + "='" + valuelist[i] + "' ";
          else
            sql = sql + "and " + fliterlist[i] + "='" + valuelist[i] + "' ";
        } else {
          isparafull = false;
          break;
        }
      }
      if (isparafull) {
        DataService dataService = new DataService();
        returnValue = dataService.getValue(sql);
        if (returnValue.indexOf(",") > 0) {
          returnValue = returnValue.substring(0, returnValue.indexOf(","));
        }
      }
    }

    return returnValue;
  }

  public String getSubCategoryListStr(String id, String model, String otype, String mtype)
  {
    List categorylist = getSubCategoryList2(id, model, otype, mtype);
    String ids = "";
    for (Category category : categorylist) {
      ids = ids + "," + category.getId();
    }
    if (ids.length() > 0)
      ids = ids.substring(1, ids.length());
    return ids;
  }
  public List<Category> getParentCategoryList(String id, String otype, String mtype) {
    return this.categoryDao.getParentCategoryList(id, otype, mtype);
  }

  public boolean isAncestor(String id, String pid) {
    if (pid == null)
      return true;
    if (id == null)
      return false;
    for (Category category : getParentCategoryList(id, null, null)) {
      if (category.getId().equals(pid)) {
        return true;
      }
    }
    return false;
  }

  public void createCategorylink(Categorylink categorylink) {
    this.categorylinkDao.createCategorylink(categorylink);
  }

  public void createCategorylink(String objid, String objtype, String[] categoryids) {
    for (String categoryid : categoryids)
      this.categorylinkDao.createCategorylink(new Categorylink(objid, objtype, categoryid));
  }

  public void modifyCategorylink(Categorylink categorylink)
  {
    this.categorylinkDao.modifyCategorylink(categorylink);
  }

  public void deleteCategorylink(Categorylink categorylink) {
    this.categorylinkDao.deleteCategorylink(categorylink);
  }

  public void deleteCategorylink(String categorylinkid) {
    this.categorylinkDao.deleteCategorylink(categorylinkid);
  }
  public void deleteCategorylinkByObj(String objid) {
    for (Categorylink categorylink : getCategorylinkByObj(objid))
      this.categorylinkDao.deleteCategorylink(categorylink);
  }

  public void deleteCategorylinkByCategory(String categoryid) {
    for (Categorylink categorylink : getCategorylinkListByCategory(categoryid))
      this.categorylinkDao.deleteCategorylink(categorylink);
  }

  public void deleteCategorylinkByCategory(String categoryid, String classname) {
    for (Categorylink categorylink : getCategorylinkListByCategory(categoryid, classname))
      this.categorylinkDao.deleteCategorylink(categorylink);
  }

  public Categorylink getCategorylink(String id)
  {
    return this.categorylinkDao.getCategorylink(id);
  }

  public List<Categorylink> getCategorylinkByObj(String objid) {
    return this.categorylinkDao.getCategorylinkByObj(objid);
  }

  public List<Categorylink> getCategorylinkListByCategory(String categoryid) {
    return getCategorylinkListByCategory(categoryid, null);
  }

  public List<Categorylink> getCategorylinkListByCategory(String categoryid, String classname)
  {
    return this.categorylinkDao.getCategorylinkByCategory(categoryid, classname);
  }

  public Categorylink getCategorylinkByCategory(String categoryid) {
    return getCategorylinkByCategory(categoryid, null);
  }

  public Categorylink getCategorylinkByCategory(String categoryid, String classname) {
    List categorylinkList = getCategorylinkListByCategory(categoryid, classname);
    Categorylink categorylink = null;
    if (categorylinkList.size() > 0)
      categorylink = (Categorylink)categorylinkList.get(0);
    return categorylink;
  }

  public CategoryDao getCategoryDao()
  {
    return this.categoryDao;
  }

  public void setCategoryDao(CategoryDao categoryDao)
  {
    this.categoryDao = categoryDao;
  }

  public CategorylinkDao getCategorylinkDao()
  {
    return this.categorylinkDao;
  }

  public void setCategorylinkDao(CategorylinkDao categorylinkDao)
  {
    this.categorylinkDao = categorylinkDao;
  }

  public PermissiondetailService getPermissiondetailService() {
    return this.permissiondetailService;
  }

  public void setPermissiondetailService(PermissiondetailService permissiondetailService)
  {
    this.permissiondetailService = permissiondetailService;
  }

  public List getchild(String categoryid, List l)
  {
    String sqlstr = " select id as id from category ca where ca.pid=?";

    List idds = this.baseJdbcDao.getJdbcTemplate().queryForList(sqlstr, new Object[] { categoryid });
    for (Iterator i$ = idds.iterator(); i$.hasNext(); ) { Object o = i$.next();

      String id = (String)((Map)o).get("ID");
      l.add(id);
      getchild(id, l);
    }

    return l;
  }

  public void getChildren(String categoryid, List<String> list)
  {
    list.add(categoryid);
    String sql = "select id from category where pid = ? and isdelete = 0";
    List ids = this.baseJdbcDao.getJdbcTemplate().queryForList(sql, new Object[] { categoryid });
    for (Map o : ids) {
      String id = (String)o.get("id");
      getChildren(id, list);
    }
  }

  public List getCategoryByModuleid(String moduleid) {
    List list = new ArrayList();
    list = this.categoryDao.getCategoryByModuleid(moduleid);
    return list;
  }

  public String getCategoryAttachSavePath(String categoryId)
  {
    Category category = getCategoryById(categoryId);
    String attachSavePath = StringHelper.null2String(category.getAttachSavePath());
    if (StringHelper.isEmpty(attachSavePath)) {
      while (!StringHelper.isEmpty(category.getPid())) {
        category = getCategoryById(category.getPid());
        if (!StringHelper.isEmpty(category.getAttachSavePath())) {
          attachSavePath = category.getAttachSavePath();
        }
      }
    }

    return attachSavePath;
  }
}