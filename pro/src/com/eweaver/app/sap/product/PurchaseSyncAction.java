package com.eweaver.app.sap.product;

import com.eweaver.base.AbstractAction;
import com.eweaver.base.DataService;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringFilter;
import com.eweaver.base.util.StringHelper;
import com.sap.conn.jco.JCoTable;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class PurchaseSyncAction
  implements AbstractAction
{
  protected final Log logger = LogFactory.getLog(getClass());
  private HttpServletRequest request;
  private HttpServletResponse response;
  private HttpSession session;
  private DataService dataService;
  private int pageNo;
  private int pageSize;

  public PurchaseSyncAction(HttpServletRequest request, HttpServletResponse response)
  {
    this.request = request;
    this.response = response;
    this.session = request.getSession();
    this.dataService = new DataService();
  }

  public void execute() throws IOException, ServletException
  {
    this.pageNo = NumberHelper.string2Int(
      StringFilter.filterAll(this.request.getParameter("pageno")), 1);
    this.pageSize = NumberHelper.string2Int(
      StringFilter.filterAll(this.request.getParameter("pagesize")), 20);

    if (!StringHelper.isEmpty(StringFilter.filterAll(this.request
      .getParameter("start"))))
      this.pageNo = (NumberHelper.string2Int(
        StringFilter.filterAll(this.request.getParameter("start")), 0) / 
        this.pageSize + 1);
    String action = StringHelper.null2String(StringFilter.filterAll(this.request
      .getParameter("action")));
    if (action.equals("search")) {
      Purchase_Z_CCP_PO_DG app = new Purchase_Z_CCP_PO_DG("Z_CCP_PO_DG");
      String werks = StringHelper.null2String(
        StringFilter.filterAll(this.request.getParameter("werks")));
      String eadat = StringHelper.null2String(
        StringFilter.filterAll(this.request.getParameter("eadat")));
      String eadae = StringHelper.null2String(
        StringFilter.filterAll(this.request.getParameter("eadae")));
      String ebeln = StringHelper.null2String(
        StringFilter.filterAll(this.request.getParameter("ebeln")));

      JCoTable purchaseTable = (JCoTable)app.findData(ebeln, eadat, eadae, werks).get("main");

      JSONArray array = new JSONArray();

      if (purchaseTable != null) {
        if (purchaseTable.getNumColumns() > 12)
          for (int i = 0; i < purchaseTable.getNumRows(); i++) {
            JSONObject object = new JSONObject();

            object.put("buyer", 
              StringHelper.null2String(purchaseTable.getString("BUKRS")));
            object.put("purchaseorg", 
              StringHelper.null2String(purchaseTable.getString("EKORG")));
            object.put("purchaseorder", 
              StringHelper.null2String(purchaseTable.getString("EBELN")));
            object.put("purchaseitem", 
              StringHelper.null2String(purchaseTable.getString("EBELP")));
            object.put("purchasetype", 
              StringHelper.null2String(purchaseTable.getString("BSART")));
            object.put("vendorno", 
              StringHelper.null2String(purchaseTable.getString("LIFNR")));
            object.put("vendorname", 
              StringHelper.null2String(purchaseTable.getString("NAME1")));
            object.put("materialno", 
              StringHelper.null2String(purchaseTable.getString("MATNR")));
            object.put("materialdesc", 
              StringHelper.null2String(purchaseTable.getString("MAKTX")));
            object.put("plant", 
              StringHelper.null2String(purchaseTable.getString("WERKS")));
            object.put("quantity", 
              StringHelper.null2String(purchaseTable.getString("MENGE")));
            object.put("openquantity", 
              StringHelper.null2String(purchaseTable.getString("LFIMG")));
            object.put("purchunit", 
              StringHelper.null2String(purchaseTable.getString("BPRME")));
            object.put("unitoftext", 
              StringHelper.null2String(purchaseTable.getString("MSEHT")));
            object.put("deliverydate", 
              StringHelper.null2String(purchaseTable.getString("EINDT")));
            object.put("bulkflag", 
              StringHelper.null2String(purchaseTable.getString("SCHGT")));
            object.put("purchasing", 
              StringHelper.null2String(purchaseTable.getString("EKGRP")));
            object.put("materialtype", 
              StringHelper.null2String(purchaseTable.getString("MTART")));
            object.put("pruchaseno", 
              StringHelper.null2String(purchaseTable.getString("BANFN")));
            object.put("storageloc", 
              StringHelper.null2String(purchaseTable.getString("LGORT")));
            object.put("goodsgroup", 
              StringHelper.null2String(purchaseTable.getString("SPART")));
            object.put("delflag", 
              StringHelper.null2String(purchaseTable.getString("LOEKZ")));
            object.put("batchnum", 
              StringHelper.null2String(purchaseTable.getString("CHARG")));
            object.put("assetsno", 
              StringHelper.null2String(purchaseTable.getString("ANLN1")));
            object.put("deliverylimit", 
              StringHelper.null2String(purchaseTable.getString("UEBTO")));

            object.put("overmark", 
              StringHelper.null2String(purchaseTable.getString("UEBTK")));
            object.put("lacking", 
              StringHelper.null2String(purchaseTable.getString("UNTTO")));
            object.put("uploadmark", 
              StringHelper.null2String(purchaseTable.getString("ZYUP")));

            object.put("applicant", 
              StringHelper.null2String(purchaseTable.getString("AFNAM")));
            object.put("applyloc", 
              StringHelper.null2String(purchaseTable.getString("LGOBE")));
            object.put("costcentre", 
              StringHelper.null2String(purchaseTable.getString("KOSTL")));
            object.put("createman", 
              StringHelper.null2String(purchaseTable.getString("NAME2")));
            object.put("permitcode", 
              StringHelper.null2String(purchaseTable.getString("ZGMZBH")));

            object.put("purchasenum", 
              StringHelper.null2String(purchaseTable
              .getString("ZMENGE1")));

            object.put("purchasemid", 
              StringHelper.null2String(purchaseTable.getString("ZMATNR")));

            object.put("purchexpiry", 
              StringHelper.null2String(purchaseTable
              .getString("ZDATELOW2")));
            object.put("purchdeadline", 
              StringHelper.null2String(purchaseTable
              .getString("ZDATEHIGH2")));

            object.put("memo1", 
              StringHelper.null2String(purchaseTable
              .getString("BEIZHU1")));
            object.put("memo2", 
              StringHelper.null2String(purchaseTable
              .getString("BEIZHU2")));
            object.put("memo3", 
              StringHelper.null2String(purchaseTable
              .getString("BEIZHU3")));

            array.add(object);

            purchaseTable.nextRow();
          }
        else {
          for (int i = 0; i < purchaseTable.getNumRows(); i++) {
            JSONObject object = new JSONObject();
            object.put("purchaseorder", 
              StringHelper.null2String(purchaseTable.getString("EBELN")));
            object.put("purchaseitem", 
              StringHelper.null2String(purchaseTable.getString("EBELP")));
            object.put("materialno", 
              StringHelper.null2String(purchaseTable.getString("MATNR")));
            object.put("plant", 
              StringHelper.null2String(purchaseTable.getString("WERKS")));
            object.put("quantity", 
              StringHelper.null2String(purchaseTable.getString("BDMNG")));
            object.put("purchunit", 
              StringHelper.null2String(purchaseTable.getString("MEINS")));
            object.put("deliverydate", 
              StringHelper.null2String(purchaseTable.getString("BDTER")));
            object.put("batchnum", 
              StringHelper.null2String(purchaseTable.getString("CHARG")));
            object.put("storageloc", 
              StringHelper.null2String(purchaseTable.getString("LGORT")));

            array.add(object);

            purchaseTable.nextRow();
          }
        }

      }

      JSONObject objectresult = new JSONObject();
      objectresult.put("result", array);
      objectresult.put("totalcount", Integer.valueOf(array.size()));
      try {
        this.response.getWriter().print(objectresult.toString());
      } catch (IOException e) {
        e.printStackTrace();
      }
      return;
    }if (action.equals("synchronous")) {
      String jsonstr = StringHelper.null2String(
        StringFilter.filterAll(this.request.getParameter("jsonstr")));
      Purchase_Z_CCP_PO_DG app = new Purchase_Z_CCP_PO_DG("Z_CCP_PO_DG");
      try
      {
        String[] str = jsonstr.split(",");
        for (int i = 0; i < str.length; i++)
        {
          app.savePurchase(str[i]);
        }

        if (str.length < 1)
          this.response.getWriter().print("未选择同步数据！");
        else
          this.response.getWriter().print("同步结束！");
      }
      catch (IOException e) {
        e.printStackTrace();
      }
      return;
    }
  }
}