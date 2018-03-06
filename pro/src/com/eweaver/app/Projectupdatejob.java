package com.eweaver.app;

import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.msg.EweaverMessage;
import com.eweaver.base.msg.EweaverMessageProducer;
import com.eweaver.base.util.DateHelper;
import com.eweaver.base.util.StringHelper;
import com.eweaver.humres.base.model.Humres;
import com.eweaver.humres.base.service.HumresService;
import java.util.List;
import java.util.Map;
import org.springframework.jdbc.core.JdbcTemplate;

public class Projectupdatejob
{
  public void check()
  {
    BaseJdbcDao localBaseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    HumresService localHumresService = (HumresService)BaseContext.getBean("humresService");
    String str1 = "select * from uf_itemmang where (modifydate is null or modifydate='') and  requestid in (select id from formbase where isdelete=0) and requestid='402880862c542361012c6211630d303b'";
    EweaverMessageProducer localEweaverMessageProducer = (EweaverMessageProducer)BaseContext.getBean("eweaverMessageProducer");
    List localList1 = localBaseJdbcDao.getJdbcTemplate().queryForList(str1);
    if (localList1.size() > 0)
      for (int i = 0; i < localList1.size(); i++)
      {
        String str2 = ((Map)localList1.get(i)).get("syc") == null ? "" : ((Map)localList1.get(i)).get("syc").toString();
        String str3 = ((Map)localList1.get(i)).get("creator") == null ? "" : ((Map)localList1.get(i)).get("creator").toString();
        String str4 = ((Map)localList1.get(i)).get("creatdate") == null ? "" : ((Map)localList1.get(i)).get("creatdate").toString();
        String str5 = ((Map)localList1.get(i)).get("itemname") == null ? "" : ((Map)localList1.get(i)).get("itemname").toString();
        String str6 = "select * from uf_project where requestid='" + str5 + "' and requestid in (select id from formbase where isdelete=0)";
        List localList2 = localBaseJdbcDao.getJdbcTemplate().queryForList(str6);
        String str7 = "";
        if (localList2.size() > 0)
          str7 = ((Map)localList2.get(0)).get("project") == null ? "" : ((Map)localList2.get(0)).get("project").toString();
        String str8 = "select * from humres where orgid='" + str2 + "' and (seclevel=75 or seclevel=85) ";
        String str9 = DateHelper.dayMove(str4, 16);
        String str10 = DateHelper.getCurrentDate();
        Object localObject2;
        Object localObject3;
        Object localObject1;
        String str12;
        String str13;
        Object localObject4;
        if ((str9.endsWith(str10)) && (!StringHelper.isEmpty(str3)))
        {
          localObject1 = localHumresService.getHumresById(str3);
          String str11 = ((Humres)localObject1).getExtrefobjfield15();
          if (!StringHelper.isEmpty(str11))
          {
            localObject2 = localHumresService.getHumresById(str11);
            localObject3 = ((Humres)localObject2).getTel2();
            if (!StringHelper.isEmpty((String)localObject3))
            {
              str12 = str7 + "案场案前进度表15天逾期未更新，请检查。";
              str13 = "402880862b4c1aff012b4c8d17453074";
              localObject4 = new EweaverMessage("sms", str13, (String)localObject3, str12);
              localEweaverMessageProducer.send((EweaverMessage)localObject4);
            }
          }
        }
         localObject1 = localBaseJdbcDao.getJdbcTemplate().queryForList(str8);
        if (((List)localObject1).size() > 0)
          for (int j = 0; j < ((List)localObject1).size(); j++)
          {
            localObject2 = ((Map)((List)localObject1).get(j)).get("id") == null ? "" : ((Map)((List)localObject1).get(j)).get("id").toString();
            if (!StringHelper.isEmpty((String)localObject2))
            {
              localObject3 = localHumresService.getHumresById((String)localObject2);
              str12 = ((Humres)localObject3).getTel2();
              if (!StringHelper.isEmpty(str12))
              {
                str13 = str7 + "案场案前进度表15天逾期未更新，请检查。";
                localObject4 = "402880862b4c1aff012b4c8d17453074";
                EweaverMessage localEweaverMessage = new EweaverMessage("sms", (String)localObject4, str12, str13);
                localEweaverMessageProducer.send(localEweaverMessage);
              }
            }
          }
      }
  }
}