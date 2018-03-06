package com.eweaver.app.trade.service;

import com.eweaver.app.configsap.SapConnector;
import com.eweaver.base.util.StringHelper;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoTable;
import java.io.PrintStream;
import java.util.ArrayList;
import java.util.List;
import org.json.simple.JSONArray;

public class SelPurchase_ZOA_MM_PO_INFO
{
  public String functionname;

  public static void main(String[] str)
  {
    SelPurchase_ZOA_MM_PO_INFO app = new SelPurchase_ZOA_MM_PO_INFO("ZOA_MM_PO_INFO");
    app.getDetailData("");
  }

  public SelPurchase_ZOA_MM_PO_INFO(String functionname)
  {
    setFunctionname(functionname);
  }

  public List<SelPurDetail> getDetailData(String ebeln)
  {
    List selpurdetails = new ArrayList();
    try
    {
      String errorMessage = "";
      SapConnector sapConnector = new SapConnector();
      String functionName = "ZOA_MM_PO_INFO";
      JCoFunction function = SapConnector.getRfcFunction(functionName);
      if (function == null) {
        System.out.println(functionName + " not found in SAP.");
        System.out.println("SAP_RFC中没有此函数!");
        errorMessage = functionName + " not found in SAP.";
      }

      function.getImportParameterList().setValue("EBELN", ebeln);

      function.execute(SapConnector.getDestination("sanpowersap"));

      if (!"X".equals(function.getExportParameterList().getValue("FLAG"))) {
        return null;
      }

      String bsart = StringHelper.null2String(function.getExportParameterList().getValue("BSART"));
      String batxt = StringHelper.null2String(function.getExportParameterList().getValue("BATXT"));
      String lifnr = StringHelper.null2String(function.getExportParameterList().getValue("LIFNR"));
      String name1 = StringHelper.null2String(function.getExportParameterList().getValue("NAME1"));
      String zterm = StringHelper.null2String(function.getExportParameterList().getValue("ZTERM"));
      String text1 = StringHelper.null2String(function.getExportParameterList().getValue("TEXT1"));
      String inco1 = StringHelper.null2String(function.getExportParameterList().getValue("INCO1"));
      String bezei = StringHelper.null2String(function.getExportParameterList().getValue("BEZEI"));
      String inco2 = StringHelper.null2String(function.getExportParameterList().getValue("INCO2"));
      String waers = StringHelper.null2String(function.getExportParameterList().getValue("WAERS"));
      String wkurs = StringHelper.null2String(function.getExportParameterList().getValue("WKURS"));
      String bedat = StringHelper.null2String(function.getExportParameterList().getValue("BEDAT"));
      String bbsrt = StringHelper.null2String(function.getExportParameterList().getValue("BBSRT"));
      String ebele = StringHelper.null2String(function.getExportParameterList().getValue("EBELE"));
      String rlwrt = StringHelper.null2String(function.getExportParameterList().getValue("RLWRT"));
      String taxes = StringHelper.null2String(function.getExportParameterList().getValue("TAXES"));
      String bukrs = StringHelper.null2String(function.getExportParameterList().getValue("BUKRS"));
      String butxt = StringHelper.null2String(function.getExportParameterList().getValue("BUTXT"));
      String frgke = StringHelper.null2String(function.getExportParameterList().getValue("FRGKE"));
      String udate = StringHelper.null2String(function.getExportParameterList().getValue("UDATE"));
      String EKNAM=StringHelper.null2String(function.getExportParameterList().getValue("EKNAM"));
      JCoTable jcotable = function.getTableParameterList().getTable("MM_PO_ITEMS");
      JSONArray array = new JSONArray();
      if (jcotable != null) {
        for (int i = 0; i < jcotable.getNumRows(); i++) {
          jcotable.setRow(i);

          String ebeln2 = StringHelper.null2String(jcotable.getString("EBELN"));
          String ebelp = StringHelper.null2String(jcotable.getString("EBELP"));
          String matnr = StringHelper.null2String(jcotable.getString("MATNR"));
          String txz01 = StringHelper.null2String(jcotable.getString("TXZ01"));
          String menge = StringHelper.null2String(jcotable.getString("MENGE"));
          String meins = StringHelper.null2String(jcotable.getString("MEINS"));
          String eindt = StringHelper.null2String(jcotable.getString("EINDT"));
          String netpr = StringHelper.null2String(jcotable.getString("NETPR"));
          String waers2 = StringHelper.null2String(jcotable.getString("WAERS"));
          String netwr = StringHelper.null2String(jcotable.getString("NETWR"));
          String bsart2 = StringHelper.null2String(jcotable.getString("BSART"));
          String banfn = StringHelper.null2String(jcotable.getString("BANFN"));
          String bnfpo = StringHelper.null2String(jcotable.getString("BNFPO"));
          String rmenge = StringHelper.null2String(jcotable.getString("RMENGE"));
          String rmeins = StringHelper.null2String(jcotable.getString("RMEINS"));
          String aufnr = StringHelper.null2String(jcotable.getString("AUFNR"));
          String anln = StringHelper.null2String(jcotable.getString("ANLN"));
          String knttp = StringHelper.null2String(jcotable.getString("KNTTP"));
          String mwskz = StringHelper.null2String(jcotable.getString("MWSKZ"));
          String zwert1 = StringHelper.null2String(jcotable.getString("ZWERT1"));
          

          SelPurDetail selpurdetail = new SelPurDetail();
          selpurdetail.setZpono(ebeln2);
          selpurdetail.setZpoitem(ebelp);
          selpurdetail.setZwlh(matnr);
          selpurdetail.setZshorttxt(txz01);
          selpurdetail.setZquantity(menge);
          selpurdetail.setZunit(meins);
          selpurdetail.setZshipdate(eindt);
          selpurdetail.setZprice(netpr);
          selpurdetail.setZcurrency(waers2);
          selpurdetail.setZamount(netwr);
          selpurdetail.setZcgsqtype2(bsart2);
          selpurdetail.setZcgsqorder2(banfn);
          selpurdetail.setZcgsqitem(bnfpo);
          selpurdetail.setZqgquan(rmenge);
          selpurdetail.setZbaseunit(rmeins);
          selpurdetail.setZinnerorder(aufnr);
          selpurdetail.setZassetno(anln);
          selpurdetail.setZkmfp(knttp);
          selpurdetail.setZtaxcode(mwskz);
          selpurdetail.setZtaxprice(zwert1);

          selpurdetail.setZordertype(bsart);
          selpurdetail.setZordertypedes(batxt);
          selpurdetail.setZsupcode(lifnr);
          selpurdetail.setZsupname(name1);
          selpurdetail.setZpaytermcode(zterm);
          selpurdetail.setZpaytermdesc(text1);
          selpurdetail.setZicon1(inco1);
          selpurdetail.setZicon1desc(bezei);
          selpurdetail.setZicon2(inco2);
          selpurdetail.setZordercur(waers);
          selpurdetail.setZrate(wkurs);
          selpurdetail.setZorderdate(bedat);
          selpurdetail.setZcgsqtype(bbsrt);
          selpurdetail.setZcgsqorder(ebele);
          selpurdetail.setZtotalamt(rlwrt);
          selpurdetail.setZtotaltaxamt(taxes);
          selpurdetail.setZcomcode(bukrs);
          selpurdetail.setZcompany(butxt);
          selpurdetail.setZpzflag(frgke);
          selpurdetail.setZudate(udate);
          selpurdetail.setSupperson(EKNAM);

          selpurdetails.add(selpurdetail);
        }
      }
    }
    catch (Exception e)
    {
      e.printStackTrace();
    }

    return selpurdetails;
  }

  public String getFunctionname()
  {
    return this.functionname;
  }

  public void setFunctionname(String functionname) {
    this.functionname = functionname;
  }
}