package com.eweaver.base.category.model;

import com.eweaver.base.BaseContext;
import com.eweaver.base.category.service.CategoryService;
import com.eweaver.base.util.StringHelper;
import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Transient;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Formula;
import org.hibernate.annotations.GenericGenerator;

@Entity
@Cache(region="eweaverCache", usage=CacheConcurrencyStrategy.READ_WRITE)
public class Category
  implements Serializable
{
  private String id;
  private String pid;
  private String objname;
  private String objdesc;
  private Integer dsporder;
  private Integer otype;
  private Integer mtype;
  private Integer isdelete = Integer.valueOf(0);
  private Integer deleteType;
  private String uniquefliter;
  private Integer importDetail = Integer.valueOf(0);
  private String col1;
  private String col2;
  private String col3;
  private Integer isfastnew;
  private Integer isApprove;
  private String docField;
  private String actionClazz;
  private String moduleid;
  private String attachSavePath;
  private Integer colInStartDocument;
  private Integer dsporderInStartDocument;
  private Integer docattachcanedit;
  private String refHtmlTemplateId;
  private String refWordTemplateId;
  private String refExcelTemplateId;
  private Integer totalObjs;
  private Integer childrennum;
  private String formid;
  private String workflowid;
  private String humresid;
  private String createlayoutid;
  private String viewlayoutid;
  private String editlayoutid;
  private String reflayoutid;
  private String reportid;
  private String printlayoutid;
  private Integer isprint;

  public Integer getImportDetail()
  {
    return Integer.valueOf(this.importDetail == null ? 0 : this.importDetail.intValue());
  }

  public void setImportDetail(Integer importDetail) {
    this.importDetail = importDetail;
  }

  @Transient
  public boolean isReallyDelete()
  {
    return (this.deleteType != null) && (this.deleteType.intValue() == 1);
  }

  public String getModuleid() {
    return this.moduleid;
  }

  public void setModuleid(String moduleid) {
    this.moduleid = moduleid;
  }

  public Integer getIsfastnew() {
    return this.isfastnew;
  }

  public void setIsfastnew(Integer isfastnew) {
    this.isfastnew = isfastnew;
  }

  public String getActionClazz() {
    return this.actionClazz;
  }

  public void setActionClazz(String actionClazz) {
    this.actionClazz = actionClazz;
  }
  @Id
  @GenericGenerator(name="generator", strategy="uuid")
  @GeneratedValue(generator="generator")
  public String getId() { return this.id; }

  public void setId(String id)
  {
    this.id = id;
  }

  public String getPid() {
    return this.pid;
  }

  public void setPid(String pid) {
    this.pid = pid;
  }

  public String getObjname() {
    return this.objname;
  }

  public void setObjname(String objname) {
    this.objname = objname;
  }

  public Integer getDsporder() {
    return this.dsporder;
  }

  public void setDsporder(Integer dsporder) {
    this.dsporder = dsporder;
  }

  public Integer getOtype() {
    return this.otype;
  }

  public void setOtype(Integer otype) {
    this.otype = otype;
  }

  public Integer getMtype() {
    return this.mtype;
  }

  public void setMtype(Integer mtype) {
    this.mtype = mtype;
  }

  public Integer getIsdelete() {
    return this.isdelete;
  }

  public void setIsdelete(Integer isdelete) {
    this.isdelete = isdelete;
  }

  public String getCol1() {
    return this.col1;
  }

  public void setCol1(String col1) {
    this.col1 = col1;
  }

  public String getCol2() {
    return this.col2;
  }

  public void setCol2(String col2) {
    this.col2 = col2;
  }

  public String getCol3() {
    return this.col3;
  }

  public void setCol3(String col3) {
    this.col3 = col3;
  }

  @Transient
  public Integer getTotalObjs()
  {
    return this.totalObjs;
  }

  public void setTotalObjs(Integer totalObjs)
  {
    this.totalObjs = totalObjs;
  }

  @Formula("( SELECT count(d.id) FROM category d WHERE d.pid=id and d.isdelete<1)")
  public Integer getChildrennum()
  {
    return this.childrennum;
  }

  public void setChildrennum(Integer childrennum) {
    this.childrennum = childrennum;
  }

  public String getPrintlayoutid()
  {
    return this.printlayoutid;
  }

  public void setPrintlayoutid(String printlayoutid) {
    this.printlayoutid = printlayoutid;
  }

  public Integer getIsprint()
  {
    return this.isprint;
  }

  public void setIsprint(Integer isprint) {
    this.isprint = isprint;
  }

  public String getWorkflowid() {
    return this.workflowid;
  }

  public void setWorkflowid(String workflowid) {
    this.workflowid = workflowid;
  }

  public String getHumresid() {
    return this.humresid;
  }

  public void setHumresid(String humresid) {
    this.humresid = humresid;
  }

  public String getCreatelayoutid() {
    return this.createlayoutid;
  }

  @Transient
  public String getPCreatelayoutid()
  {
    if ((this.pid == null) || (this.pid.equals("")) || ((this.createlayoutid != null) && (!this.createlayoutid.equals("")))) {
      return this.createlayoutid;
    }
    CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
    return categoryService.getCategoryById(this.pid).getPCreatelayoutid();
  }

  public void setCreatelayoutid(String createlayoutid)
  {
    this.createlayoutid = createlayoutid;
  }

  public String getViewlayoutid() {
    return this.viewlayoutid;
  }

  @Transient
  public String getPViewlayoutid()
  {
    if ((this.pid == null) || (this.pid.equals("")) || ((this.viewlayoutid != null) && (!this.viewlayoutid.equals("")))) {
      return this.viewlayoutid;
    }
    CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
    return categoryService.getCategoryById(this.pid).getPViewlayoutid();
  }

  public void setViewlayoutid(String viewlayoutid)
  {
    this.viewlayoutid = viewlayoutid;
  }

  public String getEditlayoutid() {
    return this.editlayoutid;
  }

  @Transient
  public String getPEditlayoutid()
  {
    if ((this.pid == null) || (this.pid.equals("")) || ((this.editlayoutid != null) && (!this.editlayoutid.equals("")))) {
      return this.editlayoutid;
    }
    CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
    return categoryService.getCategoryById(this.pid).getPEditlayoutid();
  }

  public void setEditlayoutid(String editlayoutid)
  {
    this.editlayoutid = editlayoutid;
  }

  public String getReflayoutid() {
    return this.reflayoutid;
  }

  @Transient
  public String getPReflayoutid()
  {
    if ((this.pid == null) || (this.pid.equals("")) || ((this.reflayoutid != null) && (!this.reflayoutid.equals("")))) {
      return this.reflayoutid;
    }
    CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
    return categoryService.getCategoryById(this.pid).getPReflayoutid();
  }

  public void setReflayoutid(String reflayoutid)
  {
    this.reflayoutid = reflayoutid;
  }

  public String getFormid() {
    return this.formid;
  }

  @Transient
  public String getPFormid()
  {
    if ((this.pid == null) || (this.pid.equals("")) || ((this.formid != null) && (!this.formid.equals("")))) {
      return this.formid;
    }
    CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
    return categoryService.getCategoryById(this.pid).getPFormid();
  }

  public void setFormid(String formid)
  {
    this.formid = formid;
  }

  public String getObjdesc() {
    return this.objdesc;
  }

  public void setObjdesc(String objdesc) {
    this.objdesc = objdesc;
  }

  public String getReportid() {
    return this.reportid;
  }

  @Transient
  public String getPReportid()
  {
    if ((this.pid == null) || (this.pid.equals("")) || ((this.reportid != null) && (!this.reportid.equals("")))) {
      return StringHelper.null2String(this.reportid);
    }
    CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
    return categoryService.getCategoryById(this.pid).getPReportid();
  }

  public void setReportid(String reportid)
  {
    this.reportid = reportid;
  }

  public String getUniquefliter() {
    return this.uniquefliter;
  }

  public void setUniquefliter(String uniquefliter) {
    this.uniquefliter = uniquefliter;
  }

  @Transient
  public String getPUniquefliter()
  {
    if ((this.pid == null) || (this.pid.equals("")) || ((this.uniquefliter != null) && (!this.uniquefliter.equals("")))) {
      return StringHelper.null2String(this.uniquefliter);
    }
    CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
    return categoryService.getCategoryById(this.pid).getUniquefliter();
  }

  public String getDocField()
  {
    return this.docField;
  }

  public void setDocField(String docField) {
    this.docField = docField;
  }

  public Integer getIsApprove() {
    return Integer.valueOf(this.isApprove == null ? 0 : this.isApprove.intValue());
  }

  public void setIsApprove(Integer isApprove) {
    this.isApprove = isApprove;
  }

  public Integer getDeleteType() {
    return this.deleteType;
  }

  public void setDeleteType(Integer deleteType) {
    this.deleteType = deleteType;
  }

  public String getAttachSavePath() {
    return this.attachSavePath;
  }

  public void setAttachSavePath(String attachSavePath) {
    this.attachSavePath = attachSavePath;
  }

  public Integer getColInStartDocument() {
    return this.colInStartDocument;
  }

  public void setColInStartDocument(Integer colInStartDocument) {
    this.colInStartDocument = colInStartDocument;
  }

  public Integer getDsporderInStartDocument() {
    return this.dsporderInStartDocument;
  }

  public void setDsporderInStartDocument(Integer dsporderInStartDocument) {
    this.dsporderInStartDocument = dsporderInStartDocument;
  }

  public Integer getDocattachcanedit() {
    return this.docattachcanedit;
  }

  public void setDocattachcanedit(Integer docattachcanedit) {
    this.docattachcanedit = docattachcanedit;
  }

  public String getRefHtmlTemplateId() {
    return this.refHtmlTemplateId;
  }

  public void setRefHtmlTemplateId(String refHtmlTemplateId) {
    this.refHtmlTemplateId = refHtmlTemplateId;
  }

  public String getRefWordTemplateId() {
    return this.refWordTemplateId;
  }

  public void setRefWordTemplateId(String refWordTemplateId) {
    this.refWordTemplateId = refWordTemplateId;
  }

  public String getRefExcelTemplateId() {
    return this.refExcelTemplateId;
  }

  public void setRefExcelTemplateId(String refExcelTemplateId) {
    this.refExcelTemplateId = refExcelTemplateId;
  }
}