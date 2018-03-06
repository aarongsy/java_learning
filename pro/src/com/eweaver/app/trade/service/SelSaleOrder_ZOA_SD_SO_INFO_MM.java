package com.eweaver.app.trade.service;

import com.eweaver.app.configsap.SapConnector_EN;
import com.eweaver.base.util.StringHelper;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoTable;
import java.io.PrintStream;
import java.util.ArrayList;
import java.util.List;
import org.json.simple.JSONArray;

public class SelSaleOrder_ZOA_SD_SO_INFO_MM
{
  public String functionname;

  public static void main(String[] str)
  {
    SelSaleOrder_ZOA_SD_SO_INFO_MM app = new SelSaleOrder_ZOA_SD_SO_INFO_MM("ZOA_SD_SO_INFO_MM");
    app.getDetailData("");
  }

  public SelSaleOrder_ZOA_SD_SO_INFO_MM(String functionname)
  {
    setFunctionname(functionname);
  }

  public List<SelSODetail_MM> getDetailData(String vbeln)
  {
    List selsodetails = new ArrayList();
    try
    {
      String errorMessage = "";
      //SapConnector sapConnector = new SapConnector();
      String functionName = "ZOA_SD_SO_INFO_MM";
      JCoFunction function = SapConnector_EN.getRfcFunction(functionName);
      if (function == null) {
        System.out.println(functionName + " not found in SAP.");
        System.out.println("SAP_RFC中没有此函数!");
        errorMessage = functionName + " not found in SAP.";
      }

      function.getImportParameterList().setValue("VBELN", vbeln);

      function.execute(SapConnector_EN.getDestination("sanpowersap"));

      if (!"X".equals(function.getExportParameterList().getValue("FLAG"))) {
        return null;
      }

      String auart = StringHelper.null2String(function.getExportParameterList().getValue("AUART"));
      String typed = StringHelper.null2String(function.getExportParameterList().getValue("TYPED"));
      String bstnk = StringHelper.null2String(function.getExportParameterList().getValue("BSTNK"));
      String prctr = StringHelper.null2String(function.getExportParameterList().getValue("PRCTR"));
      String sdabw = StringHelper.null2String(function.getExportParameterList().getValue("SDABW"));
      String specd = StringHelper.null2String(function.getExportParameterList().getValue("SPECD"));
      String kunnr = StringHelper.null2String(function.getExportParameterList().getValue("KUNNR"));
      String name1 = StringHelper.null2String(function.getExportParameterList().getValue("NAME1"));
      String land1 = StringHelper.null2String(function.getExportParameterList().getValue("LAND1"));
      String stras1 = StringHelper.null2String(function.getExportParameterList().getValue("STRAS1"));
      String sunnr = StringHelper.null2String(function.getExportParameterList().getValue("SUNNR"));
      String name2 = StringHelper.null2String(function.getExportParameterList().getValue("NAME2"));
      String land2 = StringHelper.null2String(function.getExportParameterList().getValue("LAND2"));
      String stras2 = StringHelper.null2String(function.getExportParameterList().getValue("STRAS2"));
      String zterm = StringHelper.null2String(function.getExportParameterList().getValue("ZTERM"));
      String text1 = StringHelper.null2String(function.getExportParameterList().getValue("TEXT1"));
      String inco1 = StringHelper.null2String(function.getExportParameterList().getValue("INCO1"));
      String bezei = StringHelper.null2String(function.getExportParameterList().getValue("BEZEI"));
      String inco2 = StringHelper.null2String(function.getExportParameterList().getValue("INCO2"));
      String waerk = StringHelper.null2String(function.getExportParameterList().getValue("WAERK"));
      String zlsch = StringHelper.null2String(function.getExportParameterList().getValue("ZLSCH"));
      String text2 = StringHelper.null2String(function.getExportParameterList().getValue("TEXT2"));
      String bukrs_vf = StringHelper.null2String(function.getExportParameterList().getValue("BUKRS_VF"));
      String butxt = StringHelper.null2String(function.getExportParameterList().getValue("BUTXT"));
      String kostl = StringHelper.null2String(function.getExportParameterList().getValue("KOSTL"));
      String vtext = StringHelper.null2String(function.getExportParameterList().getValue("VTEXT"));
      String vtweg = StringHelper.null2String(function.getExportParameterList().getValue("VTWEG"));
      String lcnum = StringHelper.null2String(function.getExportParameterList().getValue("LCNUM"));
      String zcldate = StringHelper.null2String(function.getExportParameterList().getValue("ZCLDATE"));//预计结关日
      String zetd = StringHelper.null2String(function.getExportParameterList().getValue("ZETD"));//预计开航日
      String zeta = StringHelper.null2String(function.getExportParameterList().getValue("ZETA"));//预计到港日

      JCoTable jcotable = function.getTableParameterList().getTable("SD_SO_ITEMS");
      JSONArray array = new JSONArray();
      if (jcotable != null) {
        for (int i = 0; i < jcotable.getNumRows(); i++) {
          jcotable.setRow(i);

          String vbeln2 = StringHelper.null2String(jcotable.getString("VBELN"));
          String posnr = StringHelper.null2String(jcotable.getString("POSNR"));
          String matnr = StringHelper.null2String(jcotable.getString("MATNR"));
          String arktx = StringHelper.null2String(jcotable.getString("ARKTX"));
          String kwmeng = StringHelper.null2String(jcotable.getString("KWMENG"));
          String vrkme = StringHelper.null2String(jcotable.getString("VRKME"));
          String aeskd = StringHelper.null2String(jcotable.getString("AESKD"));
          String lgort = StringHelper.null2String(jcotable.getString("LGORT"));
          String charg = StringHelper.null2String(jcotable.getString("CHARG"));
          String vdatu = StringHelper.null2String(jcotable.getString("VDATU"));
          String klmeng = StringHelper.null2String(jcotable.getString("KLMENG"));
          String meins = StringHelper.null2String(jcotable.getString("MEINS"));
          String netpr = StringHelper.null2String(jcotable.getString("NETPR2"));
          String netwr = StringHelper.null2String(jcotable.getString("NETWR"));
          String maktx = StringHelper.null2String(jcotable.getString("MAKTX"));
          String kwert = StringHelper.null2String(jcotable.getString("KWERT"));
          String kdkg3 = StringHelper.null2String(jcotable.getString("KDKG3"));
          String msehl = StringHelper.null2String(jcotable.getString("MSEHL"));
          String kmatnr = StringHelper.null2String(jcotable.getString("KMATNR"));//客户物料描述
          String remark = StringHelper.null2String(jcotable.getString("REMARK"));//客户备注
          String twaerk = StringHelper.null2String(jcotable.getString("WAERK"));//SD凭证货币
          String netpr1 = StringHelper.null2String(jcotable.getString("NETPR1"));//净价值
          String bstdk = StringHelper.null2String(jcotable.getString("BSTDK"));//客户采购订单日期

          SelSODetail_MM selsodetail = new SelSODetail_MM();
          selsodetail.setZsono(vbeln2);
          selsodetail.setZsoitem(posnr);
          selsodetail.setZwlh(matnr);
          selsodetail.setZshorttxt(arktx);
          selsodetail.setZquantity(kwmeng);
          selsodetail.setZunit(vrkme);
          selsodetail.setZgcxg(aeskd);
          selsodetail.setZwhloc(lgort);
          selsodetail.setZbatchno(charg);
          selsodetail.setZshipdate(vdatu);
          selsodetail.setZbasequan(klmeng);
          selsodetail.setZbaseunit(meins);
          selsodetail.setZprice(netpr);
          selsodetail.setZamount(netwr);
          selsodetail.setZpackdesc(maktx);
          selsodetail.setZcommission(kwert);

          selsodetail.setZordertype(auart);
          selsodetail.setZordertypedes(typed);
          selsodetail.setZpono(bstnk);
          selsodetail.setZprofit(prctr);
          selsodetail.setZspeflag(sdabw);
          selsodetail.setZspeflagdesc(specd);
          selsodetail.setZsellto(kunnr);
          selsodetail.setZselltoname(name1);
          selsodetail.setZselltocontry(land1);
          selsodetail.setZselltoaddr(stras1);
          selsodetail.setZsendto(sunnr);
          selsodetail.setZsendtoname(name2);
          selsodetail.setZsendtocontry(land2);
          selsodetail.setZsendtoaddr(stras2);
          selsodetail.setZpaytermcode(zterm);
          selsodetail.setZpaytermdesc(text1);
          selsodetail.setZicon1(inco1);
          selsodetail.setZicon1desc(bezei);
          selsodetail.setZicon2(inco2);
          selsodetail.setZcurrency(waerk);
          selsodetail.setZpaycode(zlsch);
          selsodetail.setZpaycodedesc(text2);
          selsodetail.setZcomcode(bukrs_vf);
          selsodetail.setZcompany(butxt);
          selsodetail.setZcostcenm(kostl);
          selsodetail.setZcpdlm(vtext);
          selsodetail.setZfxqdm(vtweg);
          selsodetail.setZkhtjm(kdkg3);
          selsodetail.setPcdes(msehl);
          selsodetail.setZcredit(lcnum);
          
          selsodetail.setZcldate(zcldate);//预计结关日
          selsodetail.setZeta(zeta);//预计到港日
          selsodetail.setZetd(zetd);//预计开航日
          selsodetail.setZkhwlms(kmatnr);//客户物料描述
          selsodetail.setZkhbz(remark);//客户备注
          selsodetail.setZpzhb(twaerk);//SD凭证货币
          selsodetail.setZjjz(netpr1);//净价值
          selsodetail.setZkhcgddrq(bstdk);//客户采购订单日期
          selsodetails.add(selsodetail);
        }
      }
    }
    catch (Exception e)
    {
      e.printStackTrace();
    }

    return selsodetails;
  }

  public String getFunctionname()
  {
    return this.functionname;
  }

  public void setFunctionname(String functionname) {
    this.functionname = functionname;
  }
}