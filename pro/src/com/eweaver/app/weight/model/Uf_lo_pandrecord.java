package com.eweaver.app.weight.model;

import java.io.Serializable;

public class Uf_lo_pandrecord
  implements Serializable
{
  private String id;
  private String requestid;
  private String pondcode;
  private String ladingno;
  private String trailerno;
  private String carno;
  private String tare;
  private String grosswt;
  private String accessvalue;
  private String nw;
  private String nottote;
  private String isvalid;
  private String isvirtual;
  private String edittime;
  private Integer marked;

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
  public String getPondcode() {
    return this.pondcode;
  }
  public void setPondcode(String pondcode) {
    this.pondcode = pondcode;
  }
  public String getLadingno() {
    return this.ladingno;
  }
  public void setLadingno(String ladingno) {
    this.ladingno = ladingno;
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
  public String getTare() {
    return this.tare;
  }
  public void setTare(String tare) {
    this.tare = tare;
  }
  public String getGrosswt() {
    return this.grosswt;
  }
  public void setGrosswt(String grosswt) {
    this.grosswt = grosswt;
  }
  public String getAccessvalue() {
    return this.accessvalue;
  }
  public void setAccessvalue(String accessvalue) {
    this.accessvalue = accessvalue;
  }
  public String getNw() {
    return this.nw;
  }
  public void setNw(String nw) {
    this.nw = nw;
  }
  public String getNottote() {
    return this.nottote;
  }
  public void setNottote(String nottote) {
    this.nottote = nottote;
  }
  public String getIsvalid() {
    return this.isvalid;
  }
  public void setIsvalid(String isvalid) {
    this.isvalid = isvalid;
  }
  public String getEdittime() {
    return this.edittime;
  }
  public void setEdittime(String edittime) {
    this.edittime = edittime;
  }
  public String getIsvirtual() {
    return this.isvirtual;
  }
  public void setIsvirtual(String isvirtual) {
    this.isvirtual = isvirtual;
  }
  public Integer getMarked() {
    return this.marked;
  }
  public void setMarked(Integer marked) {
    this.marked = marked;
  }
  public boolean equals(Object o) {
    if (this == o) return true;
    if ((o == null) || (getClass() != o.getClass())) return false;

    Uf_lo_pandrecord p = (Uf_lo_pandrecord)o;

    if (this.id != null ? !this.id.equals(p.id) : p.id != null) return false;

    return true;
  }
}