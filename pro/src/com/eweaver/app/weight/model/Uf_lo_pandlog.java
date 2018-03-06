package com.eweaver.app.weight.model;

import java.io.Serializable;

public class Uf_lo_pandlog
  implements Serializable
{
  private String id;
  private String requestid;
  private String factory;
  private String company;
  private String ladingno;
  private String xieplanno;
  private String trailerno;
  private String carno;
  private Double inweight;
  private Double outweight;
  private String intype;
  private String outtype;
  private String correction;
  private String createtime;
  private String edittime;

  public String getId()
  {
    return this.id;
  }
  public void setId(String id) {
    this.id = id;
  }
  public String getRequestid() {
    return this.requestid;
  }
  public void setRequestid(String requestid) {
    this.requestid = requestid;
  }
  public String getFactory() {
    return this.factory;
  }
  public void setFactory(String factory) {
    this.factory = factory;
  }
  public String getCompany() {
    return this.company;
  }
  public void setCompany(String company) {
    this.company = company;
  }
  public String getLadingno() {
    return this.ladingno;
  }
  public void setLadingno(String ladingno) {
    this.ladingno = ladingno;
  }
  public String getXieplanno() {
    return this.xieplanno;
  }
  public void setXieplanno(String xieplanno) {
    this.xieplanno = xieplanno;
  }
  public String getTrailerno() {
    return this.trailerno;
  }
  public void setTrailerno(String trailerno) {
    this.trailerno = trailerno;
  }
  public String getCarno() {
    return this.carno;
  }
  public void setCarno(String carno) {
    this.carno = carno;
  }
  public Double getInweight() {
    return this.inweight;
  }
  public void setInweight(Double inweight) {
    this.inweight = inweight;
  }
  public Double getOutweight() {
    return this.outweight;
  }
  public void setOutweight(Double outweight) {
    this.outweight = outweight;
  }
  public String getCorrection() {
    return this.correction;
  }
  public void setCorrection(String correction) {
    this.correction = correction;
  }
  public String getCreatetime() {
    return this.createtime;
  }
  public void setCreatetime(String createtime) {
    this.createtime = createtime;
  }
  public String getEdittime() {
    return this.edittime;
  }
  public void setEdittime(String edittime) {
    this.edittime = edittime;
  }
  public String getIntype() {
    return this.intype;
  }
  public void setIntype(String intype) {
    this.intype = intype;
  }
  public String getOuttype() {
    return this.outtype;
  }
  public void setOuttype(String outtype) {
    this.outtype = outtype;
  }
  public boolean equals(Object o) {
    if (this == o) return true;
    if ((o == null) || (getClass() != o.getClass())) return false;

    Uf_lo_pandlog p = (Uf_lo_pandlog)o;

    if (this.id != null ? !this.id.equals(p.id) : p.id != null) return false;

    return true;
  }
}