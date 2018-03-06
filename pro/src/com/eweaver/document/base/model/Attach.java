package com.eweaver.document.base.model;

import com.eweaver.base.util.StringHelper;
import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Transient;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.GenericGenerator;

@Entity
@Cache(region="eweaverCache", usage=CacheConcurrencyStrategy.READ_WRITE)
public class Attach
  implements Serializable
{
  private String id;
  private String objname;
  private String filedir;
  private String filetype;
  private Integer iszip;
  private Integer isencrypt;
  private String col1;
  private String col2;
  private String col3;
  private Integer isdelete = Integer.valueOf(0);
  private Long filesize;

  public Integer getIsdelete()
  {
    return this.isdelete;
  }

  public void setIsdelete(Integer isdelete) {
    this.isdelete = isdelete;
  }
  @Id
  @GenericGenerator(name="generator", strategy="uuid")
  @GeneratedValue(generator="generator")
  public String getId() { return this.id; }

  public void setId(String id)
  {
    this.id = id;
  }

  public String getObjname() {
    return this.objname;
  }

  public void setObjname(String objname) {
    this.objname = objname;
  }

  public String getFiledir() {
    return this.filedir;
  }

  public void setFiledir(String filedir) {
    this.filedir = filedir;
  }

  public String getFiletype() {
    return this.filetype;
  }

  public void setFiletype(String filetype) {
    this.filetype = filetype;
  }

  public Integer getIszip() {
    return this.iszip;
  }

  public void setIszip(Integer iszip) {
    this.iszip = iszip;
  }

  public Integer getIsencrypt() {
    return this.isencrypt;
  }

  public void setIsencrypt(Integer isencrypt) {
    this.isencrypt = isencrypt;
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

  public Long getFilesize() {
    return this.filesize;
  }

  public void setFilesize(Long filesize) {
    this.filesize = filesize;
  }

  @Transient
  public boolean isOffice() {
    return (isWord()) || (isExcel()) || (isPowerPoint()) || (isOffice1());
  }

  @Transient
  public boolean isImage() {
    return ((getFiletype() != null) && (getFiletype().toLowerCase().indexOf("image") > -1)) || (StringHelper.null2String(getObjname().toLowerCase()).endsWith(".jpg")) || (StringHelper.null2String(getObjname().toLowerCase()).endsWith(".gif")) || (StringHelper.null2String(getObjname().toLowerCase()).endsWith(".png")) || (StringHelper.null2String(getObjname().toLowerCase()).endsWith(".jpeg")) || (StringHelper.null2String(getObjname().toLowerCase()).endsWith(".bmp"));
  }

  @Transient
  public boolean isWord()
  {
    return (getFiletype() != null) && ((getFiletype().toLowerCase().indexOf("word") > -1) || (getFiletype().endsWith(".doc")) || (getFiletype().endsWith(".docx")) || ((StringHelper.null2String(getFiletype()).equals("application/octet-stream")) && (StringHelper.null2String(getObjname()).endsWith(".doc"))) || ((StringHelper.null2String(getFiletype()).equals("application/octet-stream")) && (StringHelper.null2String(getObjname()).endsWith(".docx"))));
  }

  @Transient
  public boolean isOffice1()
  {
    return (getFiletype() != null) && (getFiletype().toLowerCase().indexOf("office") > -1);
  }

  @Transient
  public boolean isExcel() {
    return (getFiletype() != null) && ((getFiletype().toLowerCase().indexOf("excel") > -1) || (getFiletype().endsWith(".xls")) || (getFiletype().endsWith(".xlsx")) || ((StringHelper.null2String(getFiletype()).equals("application/octet-stream")) && (StringHelper.null2String(getObjname()).endsWith(".xls"))) || ((StringHelper.null2String(getFiletype()).equals("application/octet-stream")) && (StringHelper.null2String(getObjname()).endsWith(".xlsx"))));
  }

  @Transient
  public boolean isPowerPoint()
  {
    return (getFiletype() != null) && ((getFiletype().toLowerCase().indexOf("powerpoint") > -1) || (getFiletype().endsWith(".ppt")) || (getFiletype().endsWith(".pptx")) || ((StringHelper.null2String(getFiletype()).equals("application/octet-stream")) && (StringHelper.null2String(getObjname()).endsWith(".ppt"))) || ((StringHelper.null2String(getFiletype()).equals("application/octet-stream")) && (StringHelper.null2String(getObjname()).endsWith(".pptx"))));
  }

  @Transient
  public boolean isPDF()
  {
    return ((getFiletype() != null) && (getFiletype().toLowerCase().indexOf(".pdf") > -1)) || (StringHelper.null2String(getObjname()).endsWith(".pdf"));
  }

  @Transient
  public boolean isTxt()
  {
    return ((getFiletype() != null) && (getFiletype().toLowerCase().indexOf("text") > -1)) || (StringHelper.null2String(getObjname()).endsWith(".txt")) || (StringHelper.null2String(getObjname()).endsWith(".sql"));
  }

  @Transient
  public boolean isApplication()
  {
    return ((getFiletype() != null) && (getFiletype().toLowerCase().indexOf("octet-stream") > -1) && (!StringHelper.null2String(getObjname().toLowerCase()).endsWith(".doc")) && (!StringHelper.null2String(getObjname().toLowerCase()).endsWith(".docx")) && (!StringHelper.null2String(getObjname().toLowerCase()).endsWith(".xls")) && (!StringHelper.null2String(getObjname().toLowerCase()).endsWith(".xlsx")) && (!StringHelper.null2String(getObjname().toLowerCase()).endsWith(".ppt")) && (!StringHelper.null2String(getObjname().toLowerCase()).endsWith(".pptx")) && (!StringHelper.null2String(getObjname().toLowerCase()).endsWith(".pdf")) && (!StringHelper.null2String(getObjname().toLowerCase()).endsWith(".txt")) && (!StringHelper.null2String(getObjname().toLowerCase()).endsWith(".jpg")) && (!StringHelper.null2String(getObjname().toLowerCase()).endsWith(".png")) && (!StringHelper.null2String(getObjname().toLowerCase()).endsWith(".gif")) && (!StringHelper.null2String(getObjname().toLowerCase()).endsWith(".jpeg")) && (!StringHelper.null2String(getObjname().toLowerCase()).endsWith(".sql")) && (!StringHelper.null2String(getObjname().toLowerCase()).endsWith(".bmp"))) || ((getObjname() != null) && (((getObjname().toLowerCase().indexOf(".rar") > -1) && (StringHelper.null2String(getObjname()).endsWith(".rar"))) || ((getObjname().toLowerCase().indexOf(".zip") > -1) && (StringHelper.null2String(getObjname()).endsWith(".zip"))) || ((getObjname().toLowerCase().indexOf(".jsp") > -1) && (StringHelper.null2String(getObjname()).endsWith(".jsp")))));
  }
}