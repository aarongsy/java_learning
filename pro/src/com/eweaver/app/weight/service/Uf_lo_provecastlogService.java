package com.eweaver.app.weight.service;

import com.eweaver.app.weight.model.Uf_lo_provecastlog;
import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.IDGernerator;
import com.eweaver.base.security.service.acegi.EweaverUser;
import com.eweaver.base.security.util.PermissionTool;
import com.eweaver.base.util.DateHelper;
import com.eweaver.base.util.StringHelper;
import com.eweaver.workflow.form.model.FormBase;
import com.eweaver.workflow.form.service.FormBaseService;

public class Uf_lo_provecastlogService
{
  public int createLog(Uf_lo_provecastlog log)
  {
    int ret = 0;
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");

    String userId = BaseContext.getRemoteUser().getId();

    StringBuffer buffer = new StringBuffer(4096);

    buffer.append("insert into uf_lo_provecastlog");
    buffer.append("(id,requestid,billno,loadno,marked,orderno,items,storageloc,plant,yetloadnum,carno,deliveydate,unit,pack,carname,realnum,zorderno,zitems,zmark,zmessage) values");

    buffer.append("('").append(IDGernerator.getUnquieID()).append("',");
    buffer.append("'").append("$ewrequestid$").append("',");
    buffer.append("'").append(StringHelper.null2String(log.getBillno())).append("',");
    buffer.append("'").append(StringHelper.null2String(log.getLoadno())).append("',");
    buffer.append("'").append(StringHelper.null2String(log.getMarked())).append("',");
    buffer.append("'").append(StringHelper.null2String(log.getOrderno())).append("',");
    buffer.append("'").append(StringHelper.null2String(log.getItems())).append("',");
    buffer.append("'").append(StringHelper.null2String(log.getStorageloc())).append("',");
    buffer.append("'").append(StringHelper.null2String(log.getPlant())).append("',");
    buffer.append("'").append(StringHelper.null2String(log.getYetloadnum())).append("',");
    buffer.append("'").append(StringHelper.null2String(log.getCarno())).append("',");
    buffer.append("'").append(StringHelper.null2String(log.getDeliveydate())).append("',");
    buffer.append("'").append(StringHelper.null2String(log.getUnit())).append("',");
    buffer.append("'").append(StringHelper.null2String(log.getPack())).append("',");
    buffer.append("'").append(StringHelper.null2String(log.getCarname())).append("',");
    buffer.append("'").append(StringHelper.null2String(log.getRealnum())).append("',");
    buffer.append("'").append(StringHelper.null2String(log.getZorderno())).append("',");
    buffer.append("'").append(StringHelper.null2String(log.getZitems())).append("',");
    buffer.append("'").append(StringHelper.null2String(log.getZmark())).append("',");
    buffer.append("'").append(StringHelper.null2String(log.getZmessage())).append("')");

    FormBase formBase = new FormBase();
    String categoryid = "40285a8d4b4d99d1014b52bdedb850fb";

    formBase.setCreatedate(DateHelper.getCurrentDate());
    formBase.setCreatetime(DateHelper.getCurrentTime());
    formBase.setCreator(StringHelper.null2String(userId));
    formBase.setCategoryid(categoryid);
    formBase.setIsdelete(Integer.valueOf(0));
    FormBaseService formBaseService = (FormBaseService)
      BaseContext.getBean("formbaseService");
    formBaseService.createFormBase(formBase);
    String insertSql = buffer.toString();
    insertSql = insertSql.replace("$ewrequestid$", formBase.getId());
    ret += baseJdbc.update(insertSql);
    PermissionTool permissionTool = new PermissionTool();
    permissionTool.addPermission(categoryid, formBase.getId(), 
      "uf_lo_provecastlog");

    return ret;
  }
}