package com.eweaver.app.weight.model;

import java.io.Serializable;

public class Uf_lo_pandmain
  implements Serializable
{
  private String id;
  private String requestid;
  private String runningno;
  private String carno;
  private String plannum;
  private String loadno;
  private String materialno;
  private String materialdesc;
  private String soldtoname;
  private String shiptoname;
  private String conname;
  private String servicetype;
  private String drivername;
  private String conno;
  private String trailerno;
  private String signno;

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
  public String getRunningno() {
    return this.runningno;
  }
  public void setRunningno(String runningno) {
    this.runningno = runningno;
  }
  public String getCarno() {
    return this.carno;
  }
  public void setCarno(String carno) {
    this.carno = carno;
  }
  public String getPlannum() {
    return this.plannum;
  }
  public void setPlannum(String plannum) {
    this.plannum = plannum;
  }
  public String getLoadno() {
    return this.loadno;
  }
  public void setLoadno(String loadno) {
    this.loadno = loadno;
  }
  public String getMaterialno() {
    return this.materialno;
  }
  public void setMaterialno(String materialno) {
    this.materialno = materialno;
  }
  public String getMaterialdesc() {
    return this.materialdesc;
  }
  public void setMaterialdesc(String materialdesc) {
    this.materialdesc = materialdesc;
  }
  public String getSoldtoname() {
    return this.soldtoname;
  }
  public void setSoldtoname(String soldtoname) {
    this.soldtoname = soldtoname;
  }
  public String getShiptoname() {
    return this.shiptoname;
  }
  public void setShiptoname(String shiptoname) {
    this.shiptoname = shiptoname;
  }
  public String getConname() {
    return this.conname;
  }
  public void setConname(String conname) {
    this.conname = conname;
  }
  public String getServicetype() {
    return this.servicetype;
  }
  public void setServicetype(String servicetype) {
    this.servicetype = servicetype;
  }
  public String getDrivername() {
    return this.drivername;
  }
  public void setDrivername(String drivername) {
    this.drivername = drivername;
  }
  public String getConno() {
    return this.conno;
  }
  public void setConno(String conno) {
    this.conno = conno;
  }
  public String getTrailerno() {
    return this.trailerno;
  }
  public void setTrailerno(String trailerno) {
    this.trailerno = trailerno;
  }
  public String getSignno() {
    return this.signno;
  }
  public void setSignno(String signno) {
    this.signno = signno;
  }

  public boolean equals(Object o) {
    if (this == o) return true;
    if ((o == null) || (getClass() != o.getClass())) return false;

    Uf_lo_pandmain p = (Uf_lo_pandmain)o;

    if (this.id != null ? !this.id.equals(p.id) : p.id != null) return false;

    return true;
  }
}