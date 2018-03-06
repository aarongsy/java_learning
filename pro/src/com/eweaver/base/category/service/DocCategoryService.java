package com.eweaver.base.category.service;

import com.eweaver.base.BaseContext;
import com.eweaver.base.DataService;
import com.eweaver.base.SQLMap;
import com.eweaver.base.category.model.Category;
import com.eweaver.base.label.service.LabelCustomService;
import com.eweaver.base.security.service.acegi.EweaverUser;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.SqlHelper;
import com.eweaver.base.util.StringHelper;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class DocCategoryService
{
  private static DataService dataService = new DataService();
  private static boolean init = false;
  private static List all = null;
  private int showLevel = 2;
  private String objids;
  private String url = "#";
  private CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
  private LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");

  public DocCategoryService(String moduleid)
  {
    String sql = "select id,pid,objname,dsporder,isdelete,colInStartDocument as colinstartdocument from category where moduleid='" + moduleid + "' and isdelete=0 order by colInStartDocument,dsporderInStartDocument,dsporder";
    all = dataService.getValues(sql);
    init = true;
  }

  public void init(String moduleid, String pid) {
    String updatesql = "update category set moduleid='" + moduleid + "' where pid='" + pid + "'";
    dataService.executeSql(updatesql);
    String sql = "select id,pid from category where pid='" + pid + "'";
    List list = dataService.getValues(sql);
    for (int i = 0; i < list.size(); i++) {
      Map m = (Map)list.get(i);
      String cpid = (String)m.get("id");
      init(moduleid, cpid);
    }
  }

  public List getChileren(String pid) {
    List list = new ArrayList();
    for (int i = 0; i < all.size(); i++) {
      Map m = (Map)all.get(i);
      if ((pid != null) && (pid.equals(m.get("pid")))) {
        String isdelete = m.get("isdelete").toString();
        if (isdelete.equals("0")) {
          String id = (String)m.get("id");
          Category category = this.categoryService.getCategoryById(id);
          String objname = this.labelCustomService.getLabelNameByCategoryForCurrentLanguage(category);
          m.remove("objname");
          m.put("objname", objname);
          list.add(m);
        }
      }
    }
    return list;
  }

  public List<CategoryTree>[] getDocCategory(String categoryid, int division, EweaverUser user) {
    List[] lists = new ArrayList[division];
    this.objids = getPermitIds(user);
    for (int d = 0; d < division; d++) {
      lists[d] = new ArrayList();
    }
    List list = getChileren(categoryid);

    for (int i = 0; i < list.size(); i++) {
      Map m = (Map)list.get(i);
      String id = (String)m.get("id");
      Category category = this.categoryService.getCategoryById(id);
      String name = this.labelCustomService.getLabelNameByCategoryForCurrentLanguage(category);
      boolean permission = (this.objids.indexOf(categoryid) > -1) || (this.objids.indexOf(id) > -1);
      CategoryTree tree = createCategoryTree(id, name, permission);
      Integer colInStartDocument = NumberHelper.getIntegerValue(m.get("colinstartdocument"));
      if ((colInStartDocument != null) && (colInStartDocument.intValue() > 0) && (colInStartDocument.intValue() <= division)) {
        lists[(colInStartDocument.intValue() - 1)].add(tree);
      } else {
        int dsporder = m.get("dsporder") == null ? 0 : NumberHelper.getIntegerValue(m.get("dsporder")).intValue();
        int order = dsporder % division;
        lists[order].add(tree);
      }
    }
    return lists;
  }

  public String getCategoryHtml(CategoryTree tree, int level) {
    level++;
    StringBuffer buffer = new StringBuffer();
    boolean hasChildren = tree.getSize() > 0;
    boolean hidden = level >= this.showLevel;
    String showname = tree.getName();
    if (showname.length() > 32) {
      showname = showname.substring(0, 30) + "...";
    }
    String link = tree.isHasPermission() ? "<a href=\"" + this.url.replace("{id}", tree.id) + "\">" + showname + "</a>" : showname;

    if (hasChildren) {
      if (hidden) {
        buffer.append("<li><img class='hand' onclick=\"javascript:closeopen(this,'").append(tree.id).append("');\" align = \"absmiddle\" src=\"/images/doc/folder.gif\">").append(link).append("</li>");

        buffer.append("<ul id=\"").append(tree.id).append("\" style=\"display:none;\">");
      } else {
        buffer.append("<li><img class='hand' onclick=\"javascript:closeopen(this,'").append(tree.id).append("');\" align = \"absmiddle\" src=\"/images/doc/folderopen.gif\">").append(link).append("</li>");

        buffer.append("<ul id=\"").append(tree.id).append("\">");
      }
      List children = tree.getChildren();
      for (int k = 0; k < children.size(); k++) {
        CategoryTree child = (CategoryTree)children.get(k);
        buffer.append(getCategoryHtml(child, level));
      }
      buffer.append("</ul>");
    } else {
      buffer.append("<li><img align = \"absmiddle\" src=\"/images/doc/page.gif\">").append(link).append("</li>");
    }
    return buffer.toString();
  }

  private String getPermitIds(EweaverUser eweaveruser) {
    String userid = eweaveruser.getId();
    String orgids = eweaveruser.getOrgids();
    int userlevel = eweaveruser.getSeclevel();
    String stationid = StringHelper.null2String(eweaveruser.getStationids());

    StringBuffer perhql = new StringBuffer();
    if (SQLMap.getDbtype().equals("4")) {
      perhql.append(" select p.objid from Permissiondetail p where p.opttype=2 and p.objtable='docbase'").append(" and ").append("((p.userid='").append(userid).append("')  or (p.stationid is not null and locate(p.stationid,'" + stationid + "')>0)  or (( p.isalluser=1 or (p.orgid is not null and locate(p.orgid,'" + orgids + "')>0 )) and (p.minseclevel <= ").append(userlevel).append(" and ((( maxseclevel is not null) and (").append(userlevel).append("<= maxseclevel)) or (maxseclevel is null").append(")))))");
    }
    else
    {
      perhql.append(" select p.objid from Permissiondetail p where p.opttype=2 and p.objtable='docbase'").append(" and ").append("((p.userid='").append(userid).append("')  or (p.stationid is not null and '" + stationid + "' like '%'" + SqlHelper.getConcatStr() + "p.stationid" + SqlHelper.getConcatStr() + "'%') or (( p.isalluser=1 or (p.orgid is not null and '" + orgids + "' like '%'" + SqlHelper.getConcatStr() + "p.orgid" + SqlHelper.getConcatStr() + "'%')) and (p.minseclevel <= ").append(userlevel).append(" and ((( maxseclevel is not null) and (").append(userlevel).append("<= maxseclevel)) or (maxseclevel is null").append(")))))");
    }

    return dataService.getSQLValue(perhql.toString());
  }

  private CategoryTree createCategoryTree(String id, String name, boolean hasPermission) {
    CategoryTree tree = new CategoryTree(id, name, hasPermission);
    List children = getChileren(id);
    for (int i = 0; i < children.size(); i++) {
      Map m = (Map)children.get(i);
      String childId = (String)m.get("id");
      String childName = (String)m.get("objname");
      boolean permission = (hasPermission) || (this.objids.indexOf(childId) > -1);
      CategoryTree child = createCategoryTree(childId, childName, permission);
      tree.addChild(child);
    }
    return tree;
  }

  public int getShowLevel()
  {
    return this.showLevel;
  }

  public void setShowLevel(int showLevel) {
    this.showLevel = showLevel;
  }

  public String getUrl() {
    return this.url;
  }

  public void setUrl(String url) {
    this.url = url;
  }

  public class CategoryTree
  {
    private String id;
    private String name;
    private String pid;
    private int size = 0;
    private boolean hasPermission;
    private List<CategoryTree> children = new ArrayList();

    CategoryTree(String id, String name, boolean hasPermission) { this.id = id;
      this.name = name;
      this.hasPermission = hasPermission; }

    public void addChild(CategoryTree child) {
      this.children.add(child);
      this.size += 1;
    }
    public String getId() {
      return this.id;
    }
    public void setId(String id) {
      this.id = id;
    }
    public String getPid() {
      return this.pid;
    }
    public void setPid(String pid) {
      this.pid = pid;
    }
    public List getChildren() {
      return this.children;
    }
    public void setChildren(List children) {
      this.children = children;
    }
    public String getName() {
      return this.name;
    }
    public void setName(String name) {
      this.name = name;
    }
    public void setSize(int size) {
      this.size = size;
    }
    public int getSize() {
      return this.size;
    }
    public boolean isHasPermission() {
      return this.hasPermission;
    }
    public void setHasPermission(boolean hasPermission) {
      this.hasPermission = hasPermission;
    }
  }
}