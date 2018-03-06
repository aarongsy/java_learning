package com.eweaver.app.configsap;

import java.io.Serializable;

public class SapConfig
  implements Serializable
{
  private String id;
  private String pid;
  private String name;
  private String remark;
  private String type;
  private String otabname;
  private String ofield;
  private String oconvert;
  private String oremark;
  private String isdelete;
  private String rfcid;

  public SapConfig()
  {
  }

  public SapConfig(String id, String pid, String name, String remark, String type, String otabname, String ofield, String oconvert, String oremark, String isdelete, String rfcid)
  {
    this.id = id;
    this.pid = pid;
    this.name = name;
    this.remark = remark;
    this.type = type;
    this.otabname = otabname;
    this.ofield = ofield;
    this.oconvert = oconvert;
    this.oremark = oremark;
    this.isdelete = isdelete;
    this.rfcid = rfcid;
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
  public String getName() {
    return this.name;
  }
  public void setName(String name) {
    this.name = name;
  }
  public String getRemark() {
    return this.remark;
  }
  public void setRemark(String remark) {
    this.remark = remark;
  }
  public String getType() {
    return this.type;
  }
  public void setType(String type) {
    this.type = type;
  }
  public String getOtabname() {
    return this.otabname;
  }
  public void setOtabname(String otabname) {
    this.otabname = otabname;
  }
  public String getOfield() {
    return this.ofield;
  }
  public void setOfield(String ofield) {
    this.ofield = ofield;
  }
  public String getOconvert() {
    return this.oconvert;
  }
  public void setOconvert(String oconvert) {
    this.oconvert = oconvert;
  }
  public String getOremark() {
    return this.oremark;
  }
  public void setOremark(String oremark) {
    this.oremark = oremark;
  }
  public String getIsdelete() {
    return this.isdelete;
  }
  public void setIsdelete(String isdelete) {
    this.isdelete = isdelete;
  }
  public String getRfcid() {
    return this.rfcid;
  }
  public void setRfcid(String rfcid) {
    this.rfcid = rfcid;
  }
}