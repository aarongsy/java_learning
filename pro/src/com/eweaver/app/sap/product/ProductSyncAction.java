package com.eweaver.app.sap.product;

import com.eweaver.base.AbstractAction;
import com.eweaver.base.DataService;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringFilter;
import com.eweaver.base.util.StringHelper;
import com.sap.conn.jco.JCoTable;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class ProductSyncAction
  implements AbstractAction
{
  protected final Log logger = LogFactory.getLog(getClass());
  private HttpServletRequest request;
  private HttpServletResponse response;
  private HttpSession session;
  private DataService dataService;
  private int pageNo;
  private int pageSize;

  public ProductSyncAction(HttpServletRequest request, HttpServletResponse response)
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
    this.pageSize = 
      NumberHelper.string2Int(StringFilter.filterAll(this.request
      .getParameter("pagesize")), 20);

    if (!StringHelper.isEmpty(StringFilter.filterAll(this.request
      .getParameter("start"))))
      this.pageNo = (NumberHelper.string2Int(
        StringFilter.filterAll(this.request.getParameter("start")), 0) / 
        this.pageSize + 1);
    String action = StringHelper.null2String(StringFilter.filterAll(this.request
      .getParameter("action")));
    String VBELN_VL = StringHelper.null2String(
      StringFilter.filterAll(this.request.getParameter("VBELN_VL")));
    String POSNR_VL = StringHelper.null2String(
      StringFilter.filterAll(this.request.getParameter("POSNR_VL")));
    String VBELN_VA = StringHelper.null2String(
      StringFilter.filterAll(this.request.getParameter("VBELN_VA")));
    if (action.equals("search")) {
      Product_Z_CCP_DELIVERY_DG app = new Product_Z_CCP_DELIVERY_DG(
        "Z_CCP_DELIVERY_DG");
      String werks = StringHelper.null2String(StringFilter.filterAll(this.request.getParameter("werks")));
      String wadat = StringHelper.null2String(StringFilter.filterAll(this.request.getParameter("wadat")));
      String wadae = StringHelper.null2String(StringFilter.filterAll(this.request.getParameter("wadae")));
      String vbeln_vl = StringHelper.null2String(StringFilter.filterAll(this.request.getParameter("vbeln_vl")));
      if ((vbeln_vl.trim().length() > 0) || ((wadat.trim().length() > 0) && (wadae.trim().length() > 0))) {
        JCoTable productTable = app.findData(vbeln_vl, wadat, wadae, werks);

        JSONArray array = new JSONArray();
        if (productTable != null) {
          for (int i = 0; i < productTable.getNumRows(); i++) {
            JSONObject object = new JSONObject();
            object.put("reqid", StringHelper.null2String(productTable.getString("VBELN_VL")) + StringHelper.null2String(productTable.getString("POSNR_VL")));
            object.put("deliveryno", StringHelper.null2String(productTable.getString("VBELN_VL")));
            object.put("deliveryitem", StringHelper.null2String(productTable.getString("POSNR_VL")));
            object.put("salesdocno", StringHelper.null2String(productTable.getString("VBELN_VA")));
            object.put("salesitem", StringHelper.null2String(productTable.getString("POSNR_VA")));
            object.put("salestype", StringHelper.null2String(productTable.getString("AUART")));
            object.put("customerno", StringHelper.null2String(productTable.getString("BSTNK")));
            object.put("soldto", StringHelper.null2String(productTable.getString("KUNAG")));
            object.put("soldtoname", StringHelper.null2String(productTable.getString("NAME_SOLD")));
            object.put("shipto", StringHelper.null2String(productTable.getString("KUNNR")));
            object.put("shiptoname", StringHelper.null2String(productTable.getString("NAME_SHIP")));
            object.put("shiptoaddress", StringHelper.null2String(productTable.getString("ADD_SHIP")));
            object.put("telephone", StringHelper.null2String(productTable.getString("TEL_NUMBER")));
            object.put("storageloc", StringHelper.null2String(productTable.getString("LGORT")));
            object.put("descofloc", StringHelper.null2String(productTable.getString("LGOBE")));
            object.put("materialno", StringHelper.null2String(productTable.getString("MATNR")));
            object.put("materialdesc", StringHelper.null2String(productTable.getString("MAKTX")));
            object.put("quantity", StringHelper.null2String(productTable.getString("LFIMG")));
            object.put("salesunit", StringHelper.null2String(productTable.getString("VRKME")));
            object.put("unitoftext", StringHelper.null2String(productTable.getString("MSEHT")));
            object.put("grossweight", StringHelper.null2String(productTable.getString("BRGEW")));
            object.put("plant", StringHelper.null2String(productTable.getString("WERKS")));
            object.put("materialofcust", StringHelper.null2String(productTable.getString("KDMAT")));
            object.put("materialtype", StringHelper.null2String(productTable.getString("VKAUS")));
            object.put("planneddate", StringHelper.null2String(productTable.getString("WADAT")));
            object.put("standard", StringHelper.null2String(productTable.getString("SPECS")));
            object.put("batchnum", StringHelper.null2String(productTable.getString("CHARG")));
            object.put("packagetype", StringHelper.null2String(productTable.getString("PACK")));
            object.put("packagecode", StringHelper.null2String(productTable.getString("AESKD")));
            object.put("kgrate", StringHelper.null2String(productTable.getString("KGBTR")));
            object.put("shipingpoint", StringHelper.null2String(productTable.getString("VSTEL")));
            object.put("delipriority", StringHelper.null2String(productTable.getString("LPRIO")));
            object.put("specialmark", StringHelper.null2String(productTable.getString("SDABW")));
            object.put("netweight", StringHelper.null2String(productTable.getString("NTGEW")));
            object.put("supplynumber", StringHelper.null2String(productTable.getString("BSTKD")));
            object.put("picking", StringHelper.null2String(productTable.getString("KOSTK")));
            object.put("dangerous", StringHelper.null2String(productTable.getString("FERTH")));
            object.put("goodsgroup", StringHelper.null2String(productTable.getString("SPART")));
            object.put("deliverylimit", StringHelper.null2String(productTable.getString("UEBTO")));
            object.put("overmark", StringHelper.null2String(productTable.getString("UEBTK")));
            object.put("lacking", StringHelper.null2String(productTable.getString("UNTTO")));
            object.put("uploadmark", StringHelper.null2String(productTable.getString("ZYUP")));
            object.put("purchcode", StringHelper.null2String(productTable.getString("ZGMZBH")));
            object.put("citymark", StringHelper.null2String(productTable.getString("ZADDFLAG")));
            object.put("transportno", StringHelper.null2String(productTable.getString("ZYSZBH")));
            object.put("purchasenum", StringHelper.null2String(productTable.getString("ZMENGE1")));
            object.put("transportnum", StringHelper.null2String(productTable.getString("ZMENGE2")));
            object.put("purchasemid", StringHelper.null2String(productTable.getString("ZMATNR")));
            object.put("transportcomp", StringHelper.null2String(productTable.getString("ZKUNNR")));
            object.put("transportname", StringHelper.null2String(productTable.getString("ZKUNNRTXT")));
            object.put("transexpiry", StringHelper.null2String(productTable.getString("ZDATELOW1")));
            object.put("transdeadline", StringHelper.null2String(productTable.getString("ZDATEHIGH1")));
            object.put("purchexpiry", StringHelper.null2String(productTable.getString("ZDATELOW2")));
            object.put("purchdeadline", StringHelper.null2String(productTable.getString("ZDATEHIGH2")));
            object.put("carsno", StringHelper.null2String(productTable.getString("ZCARS")));
            object.put("memo1", StringHelper.null2String(productTable.getString("BEIZHU1")));
            object.put("Memo2", StringHelper.null2String(productTable.getString("BEIZHU2")));
            object.put("Memo3", StringHelper.null2String(productTable.getString("BEIZHU3")));

            array.add(object);

            productTable.nextRow();
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
      }
      return;
    }if (action.equals("synchronous")) {
      String jsonstr = StringHelper.null2String(StringFilter.filterAll(this.request
        .getParameter("jsonstr")));
      Product_Z_CCP_DELIVERY_DG app = new Product_Z_CCP_DELIVERY_DG(
        "Z_CCP_DELIVERY_DG");
      try
      {
        String[] str = jsonstr.split(",");
        for (int i = 0; i < str.length; i++) {
          app.saveProduct(str[i]);
        }

        this.response.getWriter().print("同步成功！");
      } catch (IOException e) {
        e.printStackTrace();
      }
      return;
    }
  }
}