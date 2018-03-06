package com.eweaver.app.cooperation;

import com.eweaver.base.BaseContext;
import com.eweaver.base.DataService;
import com.eweaver.base.util.StringHelper;
import com.eweaver.cowork.dao.CoworksetDao;
import com.eweaver.cowork.model.Coworkset;
import com.eweaver.cowork.service.CoworksetService;
import java.util.HashMap;
import java.util.Map;

public class CoworkHelper
{
  private static DataService ds = new DataService();
  private static Coworkset coworkset = new Coworkset();
  private static Map<String, String> params = new HashMap();

  public static boolean IsNullCoworkset()
  {
    if ((coworkset != null) && (!StringHelper.isEmpty(coworkset.getId()))) {
      return false;
    }
    return true;
  }

  public static String getParams(String key)
  {
    return (String)params.get(key);
  }

  public static Coworkset getCoworkset() {
    if ((coworkset != null) && (!StringHelper.isEmpty(coworkset.getId()))) {
      return coworkset;
    }
    coworkset = new Coworkset();
    return coworkset;
  }

  public static void resetCoWorkSet()
  {
    String coworksetid = StringHelper.null2String(ds.getValue("select id from coworkset where createlayout is not null and editlayout is not null"));
    CoworksetService coworksetService = (CoworksetService)BaseContext.getBean("coworksetService");
    Coworkset cset = coworksetService.getCoworksetDao().getById(coworksetid);
    if ((cset != null) && (!StringHelper.isEmpty(cset.getId()))) {
      coworkset = cset;
      String mainform = StringHelper.null2String(ds.getValue("SELECT objtablename FROM forminfo WHERE ID='" + coworkset.getFormid() + "' AND objtype ='0' AND isdelete=0"));
      params.put("mainform", mainform);
      params.put("mainformid", coworkset.getFormid());
      String replydate = StringHelper.null2String(ds.getValue("SELECT fieldname FROM formfield WHERE ID='" + coworkset.getReplydate() + "'"));
      params.put("replydate", replydate);
      String replytime = StringHelper.null2String(ds.getValue("SELECT fieldname FROM formfield WHERE ID='" + coworkset.getReplytime() + "'"));
      params.put("replytime", replytime);
      String replyform = StringHelper.null2String(ds.getValue("SELECT objtablename FROM forminfo WHERE ID='" + coworkset.getReplyformid() + "' AND objtype ='0' AND isdelete=0"));
      params.put("replyform", replyform);
      params.put("replyformid", coworkset.getReplyformid());
      String replymembers = StringHelper.null2String(ds.getValue("SELECT fieldname FROM formfield WHERE ID='" + coworkset.getReplymembers() + "'"));
      params.put("replymembers", replymembers);
      params.put("replymembersid", coworkset.getReplymembers());
      String replycontent = StringHelper.null2String(ds.getValue("SELECT fieldname FROM formfield WHERE ID='" + coworkset.getReplycontent() + "'"));
      params.put("replycontent", replycontent);
      params.put("replyfield", coworkset.getReplycontent());
      String coworktype = StringHelper.null2String(ds.getValue("SELECT fieldtype FROM formfield WHERE ID='" + coworkset.getCoworktype() + "'"));
      params.put("coworktype", coworktype);
      params.put("coworktypeid", coworkset.getCoworktype());
      String titleobjname = StringHelper.null2String(ds.getValue("SELECT fieldname FROM formfield WHERE ID='" + coworkset.getSubject() + "' AND isdelete=0"));
      params.put("titleobjname", titleobjname);
      params.put("title", StringHelper.null2String(coworkset.getSubject()));
      params.put("coworkremark", coworkset.getCoworkremark());
      params.put("defshow1", coworkset.getDefshow1());
      params.put("defshow2", coworkset.getDefshow2());
    }
  }

  static
  {
    resetCoWorkSet();
  }
}