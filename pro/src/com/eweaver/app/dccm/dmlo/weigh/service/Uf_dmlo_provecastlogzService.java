package com.eweaver.app.dccm.dmlo.weigh.service;


import com.eweaver.app.dccm.dmlo.weigh.model.Uf_dmlo_provecastlog;
import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.IDGernerator;
import com.eweaver.base.security.service.acegi.EweaverUser;
import com.eweaver.base.security.util.PermissionTool;
import com.eweaver.base.util.DateHelper;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringHelper;
import com.eweaver.workflow.form.model.FormBase;
import com.eweaver.workflow.form.service.FormBaseService;
import java.io.PrintStream;
import java.util.List;
import java.util.Map;

public class Uf_dmlo_provecastlogzService
{
  public int createLog(Uf_dmlo_provecastlog log)
  {
    int ret = 0;
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");

    String userId = BaseContext.getRemoteUser().getId();

    String orderno = log.getOrderno();
    String items = log.getItems();
    String ordertype = log.getMarked();
    String loadno = log.getLoadno();
    String zhangxiesql = "";
    if (ordertype.equals("采购订单")) {
      zhangxiesql = zhangxiesql + " and loadno ='" + loadno + "' ";
    }
    List list001 = baseJdbc.executeSqlForList("select * from uf_dmlo_provecastlogz where orderno = '" + orderno + "' and items='" + items + "'" + zhangxiesql);
    System.out.println("*********************************** orderno ***********************************" + orderno);
    if (list001.size() > 0) {
      System.out.println("------------修改交运单或者采购单开始-----------");
      Map map = (Map)list001.get(0);
      String carno = StringHelper.null2String(map.get("carno"));
      String _carno = StringHelper.null2String(log.getCarno());
      if (carno.indexOf(_carno) <= -1)
      {
        carno = carno + "," + _carno;
      }
      baseJdbc.update("update uf_dmlo_provecastlogz set yetloadnum = nvl(yetloadnum,0) + " + NumberHelper.string2Double(log.getYetloadnum(), 0.0D) + 
        ",nw=nvl(nw,0)+" + NumberHelper.string2Double(log.getNw(), 0.0D) + ",deliveydate='" + StringHelper.null2String(log.getDeliveydate()) + "',carno='" + carno + "' where orderno = '" + orderno + "' and items='" + items + "'" + zhangxiesql);
      System.out.println("------------修改交运单或者采购单结束-----------");
    } else {
      System.out.println("------------生成交运单或者采购单开始-----------");
      StringBuffer sbf = new StringBuffer(4096);
      sbf.append("insert into uf_dmlo_provecastlogz");
      sbf.append("(id,requestid,plant,marked,loadno,orderno,items,yetloadnum,deliveydate,unit,pack,state,realnum,carno,nw) values");

      sbf.append("('").append(IDGernerator.getUnquieID()).append("',");
      sbf.append("'").append("$ewrequestid$").append("',");
      sbf.append("'").append(StringHelper.null2String(log.getFactoryname())).append("',");
      sbf.append("'").append(StringHelper.null2String(log.getMarked())).append("',");
      sbf.append("'").append(StringHelper.null2String(log.getLoadno())).append("',");
      sbf.append("'").append(StringHelper.null2String(log.getOrderno())).append("',");
      sbf.append("'").append(StringHelper.null2String(log.getItems())).append("',");
      sbf.append("'").append(StringHelper.null2String(log.getYetloadnum())).append("',");
      sbf.append("'").append(StringHelper.null2String(log.getDeliveydate())).append("',");
      sbf.append("'").append(StringHelper.null2String(log.getUnit())).append("',");
      sbf.append("'").append(StringHelper.null2String(log.getPack())).append("',");
      sbf.append("'").append("40288098276fc2120127704884290211").append("',");
      sbf.append("'").append(StringHelper.null2String(log.getRealnum())).append("','" + 
        StringHelper.null2String(log.getCarno()) + "','" + StringHelper.null2String(log.getNw()) + "')");

      FormBase formBase = new FormBase();
      String categoryid = "40285a8d598aec6d01599040c0c61adb";

      formBase.setCreatedate(DateHelper.getCurrentDate());
      formBase.setCreatetime(DateHelper.getCurrentTime());
      formBase.setCreator(StringHelper.null2String(userId));
      formBase.setCategoryid(categoryid);
      formBase.setIsdelete(Integer.valueOf(0));
      FormBaseService formBaseService = (FormBaseService)
        BaseContext.getBean("formbaseService");
      formBaseService.createFormBase(formBase);
      String insertSql = sbf.toString();
      insertSql = insertSql.replace("$ewrequestid$", formBase.getId());
      ret += baseJdbc.update(insertSql);
      PermissionTool permissionTool = new PermissionTool();
      permissionTool.addPermission(categoryid, formBase.getId(), 
        "uf_dmlo_provecastlogz");
      System.out.println("------------生成交运单或者采购单结束-----------");
    }
    return ret;
  }
}