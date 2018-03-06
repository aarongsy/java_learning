package com.eweaver.app.dccm.dmlo.weigh.servlet;

import com.eweaver.app.dccm.dmlo.weigh.LoadPublicService;
import com.eweaver.app.dccm.dmlo.weigh.model.Uf_dmlo_pandlog;
import com.eweaver.app.dccm.dmlo.weigh.model.Uf_dmlo_pandrecord;
import com.eweaver.app.dccm.dmlo.weigh.service.Uf_dmlo_budgetService;
import com.eweaver.app.dccm.dmlo.weigh.service.Uf_dmlo_pandService;
import com.eweaver.app.dccm.dmlo.weigh.service.Uf_dmlo_tuil;
import com.eweaver.base.AbstractAction;
import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.DataService;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringFilter;
import com.eweaver.base.util.StringHelper;
import java.io.IOException;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class Uf_dmlo_pandAction
  implements AbstractAction
{
  protected final Log logger = LogFactory.getLog(getClass());
  private HttpServletRequest request;
  private HttpServletResponse response;
  private HttpSession session;
  private DataService dataService;
  private Uf_dmlo_pandService uf_dmlo_pandService;

  public Uf_dmlo_pandAction(HttpServletRequest request, HttpServletResponse response)
  {
    this.request = request;
    this.response = response;
    this.session = request.getSession();
    this.dataService = new DataService();
    this.uf_dmlo_pandService = new Uf_dmlo_pandService();
  }

  public void execute() throws IOException, ServletException
  {
    String action = StringHelper.null2String(StringFilter.filterAll(this.request
      .getParameter("action")));
    if ("searchMain".equals(action)) {
      String plate = StringHelper.null2String(this.request.getParameter("plate"));
      String weighType = StringHelper.null2String(this.request.getParameter("weighType"));
      	
      //装卸计划号
      String loadingno = StringHelper.null2String(this.dataService.getValue("select loadingno from uf_dmlo_ladingmain   where (ladingno = '" + plate + "' or carno='"+plate+"')"));

      String sql = "select d.id id, d.requestid requestid, d.runningno runningno, m.carno carno, d.deliverdnum plannum, m.loadingno loadno, d.orderno ladno, d.vendorname gys, d.materialno materialno, d.materialdesc materialdesc, m.soldtoname soldtoname, m.shiptoname shiptoname, c.carriername conname, s.objname servicetype, m.drivername drivername, m.loanno conno, m.trailerno trailerno, m.signno signno,m.ispond ispond,d.itemno,d.salesunit,m.createtime,m.ladingno from uf_dmlo_ladingmain  m "
    	  +"left join uf_dmlo_ladingdetail d on m.requestid = d.requestid left join uf_dmlo_carrierinfo c on m.conname = c.requestid left join selectitem s on m.servicetype = s.id "
    	  +"where m.ispond = '40288098276fc2120127704884290210' and not exists(select 1 from uf_dmlo_pondrecord where uf_dmlo_pondrecord.isvalid = '40288098276fc2120127704884290210' and uf_dmlo_pondrecord.ladingno = m.ladingno) and m.loadingno = '" + 
        loadingno + "' ";
      System.out.println(sql);
      List list = this.dataService.getValues(sql);

      JSONArray array = new JSONArray();
      for (int i = 0; i < list.size(); i++) {
        JSONObject object = new JSONObject();
        Map atmap = (Map)list.get(i);
        object.put("id", atmap.get("id"));
        object.put("requestid", atmap.get("requestid"));
        object.put("runningno", atmap.get("runningno"));
        object.put("carno", atmap.get("carno"));
        object.put("plannum", atmap.get("plannum"));
        object.put("loadno", atmap.get("loadno"));
        object.put("ladno", atmap.get("ladno"));
        object.put("materialno", atmap.get("materialno"));
        object.put("materialdesc", atmap.get("materialdesc"));
        object.put("soldtoname", atmap.get("soldtoname"));
        object.put("shiptoname", atmap.get("shiptoname"));
        object.put("gys", atmap.get("gys"));
        object.put("conname", atmap.get("conname"));
        object.put("servicetype", atmap.get("servicetype"));
        object.put("drivername", atmap.get("drivername"));
        object.put("conno", atmap.get("conno"));
        object.put("trailerno", atmap.get("trailerno"));
        object.put("signno", atmap.get("signno"));
        object.put("ispond", atmap.get("ispond"));
        object.put("itemno", atmap.get("itemno"));
        object.put("salesunit", atmap.get("salesunit"));
        object.put("createtime", atmap.get("createtime"));
        object.put("ladingno", atmap.get("ladingno"));
        array.add(object);
      }
      JSONObject objectresult = new JSONObject();
      objectresult.put("result", array);
      try {
        this.response.getWriter().print(objectresult.toString());
      } catch (IOException e) {
        e.printStackTrace();
      }
      return;
    }
    //过磅日志
    if ("searchRecord".equals(action)) {
      String plate = StringHelper.null2String(StringFilter.filterAll(this.request
        .getParameter("plate")));
      Uf_dmlo_pandrecord record = this.uf_dmlo_pandService.getRecord(plate);
      JSONArray array = new JSONArray();
      if (record == null) {
        JSONObject objectresult = new JSONObject();
        objectresult.put("result", array);
        try {
          this.response.getWriter().print(objectresult.toString());
        } catch (IOException e) {
          e.printStackTrace();
        }
        return;
      }
      JSONObject object = new JSONObject();
      object.put("id", record.getId());
      object.put("requestid", record.getRequestid());
      String isvirtual = "40288098276fc2120127704884290211".equals(record.getIsvirtual()) ? "真实" : "虚拟";
      object.put("isvirtual", isvirtual);

      object.put("pondcode", record.getPondcode());
      object.put("ladingno", record.getLadingno());
      object.put("trailerno", record.getTrailerno());
      object.put("carno", record.getCarno());
      object.put("tare", String.format("%.2f", new Object[] { Double.valueOf(NumberHelper.string2Double(record.getTare(), 0.0D)) }));
      object.put("grosswt", String.format("%.2f", new Object[] { Double.valueOf(NumberHelper.string2Double(record.getGrosswt(), 0.0D)) }));
      object.put("accessvalue", String.format("%.2f", new Object[] { Double.valueOf(NumberHelper.string2Double(record.getAccessvalue(), 0.0D)) }));
      object.put("nw", String.format("%.2f", new Object[] { Double.valueOf(NumberHelper.string2Double(record.getNw(), 0.0D)) }));
      String nottote = "40288098276fc2120127704884290210".equals(record.getNottote()) ? "无货柜" : "";
      object.put("nottote", nottote);

      String isvalid = "40288098276fc2120127704884290210".equals(record.getIsvalid()) ? "生效" : "";
      object.put("isvalid", isvalid);

      object.put("edittime", record.getEdittime());

      array.add(object);

      JSONObject objectresult = new JSONObject();
      objectresult.put("result", array);
      try
      {
        this.response.getWriter().print(objectresult.toString());
      } catch (IOException e) {
        e.printStackTrace();
      }
      return;
    }
    //计重
    if ("inweigh".equals(action)) {
      String plate = StringHelper.null2String(StringFilter.filterAll(this.request
        .getParameter("plate")));
      //计重方式 无货柜 空柜
      String weighType = StringHelper.null2String(StringFilter.filterAll(this.request
        .getParameter("weighType")));
      String weight = StringHelper.null2String(StringFilter.filterAll(this.request
        .getParameter("weight")));
      //Uf_dmlo_pandlog log = new Uf_dmlo_pandlog();
      if (this.uf_dmlo_pandService.isInWeightable(plate)) {//打印并未计重
    	  //过磅记录
        this.uf_dmlo_pandService.setInRecordByLadingno(plate, weight);
        this.uf_dmlo_pandService.setInWeightLog(plate, weight, weighType);
        this.response.getWriter().print("success");
      }
      else if (this.uf_dmlo_pandService.isPrint(plate)) {//打印提入单
        this.response.getWriter().print("unable");
      } else {
        this.response.getWriter().print("unprint");
      }

      return;
    }if ("outweigh".equals(action)) {
      String plate = StringHelper.null2String(StringFilter.filterAll(this.request
        .getParameter("plate")));
      String weighType = StringHelper.null2String(StringFilter.filterAll(this.request
        .getParameter("weighType")));
      String weight = StringHelper.null2String(StringFilter.filterAll(this.request
        .getParameter("weight")));
      Uf_dmlo_pandlog log = new Uf_dmlo_pandlog();
      if (!this.uf_dmlo_pandService.getslbj(plate, weight)) {//校验磅值
        this.response.getWriter().print("slbj");
        return;
      }

      if (!this.uf_dmlo_pandService.getyzd(plate, weight)) {//易制毒日期
        this.response.getWriter().print("yzd");
        return;
      }

      if (this.uf_dmlo_pandService.getZxSlBj(plate, weight)) {//校验交运单、采购订单过量上线范围
        if (this.uf_dmlo_pandService.transceiver(plate)) {//是否现场收发货
          if (this.uf_dmlo_pandService.isOutWeightable(plate))//是否已计重
          {
            if (this.uf_dmlo_pandService.getFranchiseScope(plate, weight))//校验过磅允差
            {
              String ret = this.uf_dmlo_pandService.setOutRecordByLadingno(plate, weight, weighType);
              this.uf_dmlo_pandService.setOutWeightLog(plate, weight, weighType);

              BaseJdbcDao daseDB = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
              List list;
              if (this.uf_dmlo_pandService.isOverWeighByPlan(plate)) {//费自提
                Uf_dmlo_budgetService bs = new Uf_dmlo_budgetService();
                String planrequestid = bs.getRequestidByLadingno(plate);
                LoadPublicService loadPublicService = new LoadPublicService();//import com.eweaver.app.logi.LoadPublicService;
                loadPublicService.refreshRealLoadPlan(planrequestid);
                loadPublicService.reCalcFreightFee(planrequestid);

                daseDB.update("update uf_dmlo_ladingmain set sfygb = 'y' where ladingno = '" + plate + "'");
                String sql = "select sfygb,count(*) total from uf_dmlo_ladingmain where exists (select 1 from formbase where id = requestid and isdelete <> 1) and sfygb is null and ladingno in(select laddelino from uf_dmlo_transhortdetail where requestid = '" + 
                  planrequestid + "'" + 
                  ") group by sfygb";
                list = daseDB.executeSqlForList(sql);
                Double total = Double.valueOf(0.0D);
                if (list.size() > 0) {
                  Map pMap = (Map)list.get(0);
                  total = Double.valueOf(NumberHelper.string2Double(pMap.get("total"), 0.0D));
                }
                try {
                  if (total.doubleValue() != 0.0D) 
                	  {daseDB.update("update uf_dmlo_ladingmain set status = '40285a8d4d5b981f014d6a12a9ec0009' where ladingno = '" + plate + "' ");}
                  System.out.println("---------------- 过磅暂估生成开始 -----------------");
                  bs.createBudgetByPlan(planrequestid,plate);
                  System.out.println("---------------- 过磅暂估生成结束 -----------------");
                }
                catch (Exception e) {
                  System.out.println("生成暂估单异常 E:" + e);
                }
              }
              else {//自提不生成暂估单
                Uf_dmlo_budgetService bs = new Uf_dmlo_budgetService();
                String planrequestid = bs.getRequestidByLadingno(plate);//装卸计划号
                LoadPublicService loadPublicService = new LoadPublicService();
                loadPublicService.refreshRealLoadPlan(planrequestid);
              }


              this.uf_dmlo_pandService.getbzbshx(plate);

              Uf_dmlo_tuil loTuil = new Uf_dmlo_tuil();
              loTuil.getworth(plate, weight);

              List<Uf_dmlo_pandrecord> recordList = this.uf_dmlo_pandService.getNoInvalidRecords(plate);
              if ((recordList != null) && (!recordList.isEmpty())) {
                for (Uf_dmlo_pandrecord lo_pandrecord : recordList) {
                  lo_pandrecord.setTare(weight);
                  this.uf_dmlo_pandService.updateRecord(lo_pandrecord);
                }
              }
              this.response.getWriter().print(ret);
            }//end 过磅允差
            else {
              this.response.getWriter().print("ycpd");
            }
          }
          else
          {
            this.response.getWriter().print("unable");
          }
        }
        else {
          this.response.getWriter().print("noplate");
        }
      }
      else {
        this.response.getWriter().print("gbnoplatenum");
      }

      return;
    }if ("viroutweigh".equals(action)) {
      String plate = StringHelper.null2String(StringFilter.filterAll(this.request
        .getParameter("plate")));
      String weighType = StringHelper.null2String(StringFilter.filterAll(this.request
        .getParameter("weighType")));
      String weight = StringHelper.null2String(StringFilter.filterAll(this.request
        .getParameter("weight")));
      Uf_dmlo_pandlog log = new Uf_dmlo_pandlog();
      if (!this.uf_dmlo_pandService.getslbj(plate, weight)) {//校验磅值
        this.response.getWriter().print("slbj");
        return;
      }

      if (this.uf_dmlo_pandService.getZxSlBj(plate, weight))//校验是否符合允差
      {
        if (this.uf_dmlo_pandService.isOutWeightable(plate)) {//是否计重
          String ret = this.uf_dmlo_pandService.virOutRecordByLadingno(plate, weight, weighType);

          this.response.getWriter().print(ret);
        }
        else {
          this.response.getWriter().print("unable");
        }

      }
      else
      {
        this.response.getWriter().print("gbnoplatenum");
      }

      return;
    }if ("deleteweigh".equals(action)) {
      String plate = StringHelper.null2String(StringFilter.filterAll(this.request
        .getParameter("plate")));
      String reason = StringHelper.null2String(StringFilter.filterAll(this.request
        .getParameter("reason")));
      if (this.uf_dmlo_pandService.isDeleteWeightable(plate)) {//提单存在且未过磅
        int ret = this.uf_dmlo_pandService.deleteWeigh(plate, reason);
        this.response.getWriter().print(ret);
      } else {
        this.response.getWriter().print("unable");
      }
      return;
    }
  }
}