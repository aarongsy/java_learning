package com.eweaver.base.category.model;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.GenericGenerator;

@Entity
@Cache(region="eweaverCache", usage=CacheConcurrencyStrategy.READ_WRITE)
public class Categorylink
  implements Serializable
{
  private String id;
  private String objid;
  private String objtype;
  private String categoryid;
  private Integer ptype;
  private String col1;
  private String col2;
  private String col3;
  private Integer isdelete = Integer.valueOf(0);

  public Integer getIsdelete() { return this.isdelete; }

  public void setIsdelete(Integer isdelete)
  {
    this.isdelete = isdelete;
  }

  public Categorylink() {
  }

  public Categorylink(String objid, String objtype, String categoryid) {
    this.objid = objid;
    this.objtype = objtype;
    this.categoryid = categoryid;
  }
  @Id
  @GenericGenerator(name="generator", strategy="uuid")
  @GeneratedValue(generator="generator")
  public String getId() { return this.id; }

  public void setId(String id)
  {
    this.id = id;
  }

  public String getObjid() {
    return this.objid;
  }

  public void setObjid(String objid) {
    this.objid = objid;
  }

  public String getObjtype() {
    return this.objtype;
  }

  public void setObjtype(String objtype) {
    this.objtype = objtype;
  }

  public String getCategoryid() {
    return this.categoryid;
  }

  public void setCategoryid(String categoryid) {
    this.categoryid = categoryid;
  }

  public Integer getPtype() {
    return this.ptype;
  }

  public void setPtype(Integer ptype) {
    this.ptype = ptype;
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
}