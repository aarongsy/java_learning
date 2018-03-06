package com.eweaver.app.dccm.dmlo.weigh.model;

import java.io.Serializable;

public class Uf_dmlo_budgetdetail
  implements Serializable
{
  private String id;
  private String requestid;
  private String rowindex;
  private String chargecode;
  private String subject;
  private String amount;
  private String notaxamount;
  private String saletax;
  private String costcentre;
  private String purchorder;
  private String saleorder;
  private String itemno;
  private String projecttext;
  private String isflag;
  private String wlh;
  private String detailid;

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

  public String getRowindex() {
    return this.rowindex;
  }

  public void setRowindex(String rowindex) {
    this.rowindex = rowindex;
  }

  public String getChargecode() {
    return this.chargecode;
  }

  public void setChargecode(String chargecode) {
    this.chargecode = chargecode;
  }

  public String getSubject() {
    return this.subject;
  }

  public void setSubject(String subject) {
    this.subject = subject;
  }

  public String getAmount() {
    return this.amount;
  }

  public void setAmount(String amount) {
    this.amount = amount;
  }

  public String getNotaxamount() {
    return this.notaxamount;
  }

  public void setNotaxamount(String notaxamount) {
    this.notaxamount = notaxamount;
  }

  public String getSaletax() {
    return this.saletax;
  }

  public void setSaletax(String saletax) {
    this.saletax = saletax;
  }

  public String getCostcentre() {
    return this.costcentre;
  }

  public void setCostcentre(String costcentre) {
    this.costcentre = costcentre;
  }

  public String getPurchorder() {
    return this.purchorder;
  }

  public void setPurchorder(String purchorder) {
    this.purchorder = purchorder;
  }

  public String getSaleorder() {
    return this.saleorder;
  }

  public void setSaleorder(String saleorder) {
    this.saleorder = saleorder;
  }

  public String getItemno() {
    return this.itemno;
  }

  public void setItemno(String itemno) {
    this.itemno = itemno;
  }

  public String getProjecttext() {
    return this.projecttext;
  }

  public void setProjecttext(String projecttext) {
    this.projecttext = projecttext;
  }

  public String getIsflag() {
    return this.isflag;
  }

  public void setIsflag(String isflag) {
    this.isflag = isflag;
  }

  public String getWlh() {
    return this.wlh;
  }

  public void setWlh(String wlh) {
    this.wlh = wlh;
  }

  public String getDetailid() {
    return this.detailid;
  }

  public void setDetailid(String detailid) {
    this.detailid = detailid;
  }
}