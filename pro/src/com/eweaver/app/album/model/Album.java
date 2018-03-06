package com.eweaver.app.album.model;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import org.hibernate.annotations.Formula;
import org.hibernate.annotations.GenericGenerator;

@Entity
public class Album
{
  private String id;
  private String objname;
  private String photoSavePath;
  private Integer dsporder;
  private String pid;
  private Integer isdelete = Integer.valueOf(0);
  private Integer childrennum;

  @Id
  @GenericGenerator(name="generator", strategy="uuid")
  @GeneratedValue(generator="generator")
  public String getId()
  {
    return this.id;
  }

  public void setId(String id) {
    this.id = id;
  }

  public String getObjname() {
    return this.objname;
  }

  public void setObjname(String objname) {
    this.objname = objname;
  }

  public String getPhotoSavePath() {
    return this.photoSavePath;
  }

  public void setPhotoSavePath(String photoSavePath) {
    this.photoSavePath = photoSavePath;
  }

  public Integer getDsporder() {
    return this.dsporder;
  }

  public void setDsporder(Integer dsporder) {
    this.dsporder = dsporder;
  }

  public String getPid() {
    return this.pid;
  }

  public void setPid(String pid) {
    this.pid = pid;
  }

  public Integer getIsdelete() {
    return this.isdelete;
  }

  public void setIsdelete(Integer isdelete) {
    this.isdelete = isdelete;
  }

  @Formula("( SELECT count(d.id) FROM Album d WHERE d.pid=id and d.isdelete<1)")
  public Integer getChildrennum()
  {
    return this.childrennum;
  }

  public void setChildrennum(Integer childrennum) {
    this.childrennum = childrennum;
  }
}