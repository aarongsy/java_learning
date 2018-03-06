package com.eweaver.app.hrmanage;

import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.label.service.LabelService;
import com.eweaver.base.orgunit.model.Orgunit;
import com.eweaver.base.orgunit.model.Orgunitlink;
import com.eweaver.base.security.model.Sysuser;
import com.eweaver.base.util.StringHelper;
import com.eweaver.humres.base.model.Humres;
import com.eweaver.humres.base.model.Stationinfo;
import com.eweaver.humres.base.model.Stationlink;
import java.util.List;
import java.util.Map;
import org.hibernate.SessionFactory;

public class setHumresStatus
{
  public void check()
  {
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String sql = "select id from humres where isdelete=0 and extselectitemfield14='40288098276fc2120127704884290210' and hrstatus='4028804c16acfbc00116ccba13802935'";
    List list = baseJdbc.executeSqlForList(sql);
    if (list.size() > 0)
      for (int i = 0; i < list.size(); i++) {
        Map map = (Map)list.get(i);
        String hid = StringHelper.null2String(map.get("id"));
        sql = "select a.requestid from uf_hr_leave a,requestbase b where a.requestid=b.id and b.isdelete=0 and b.isfinished=1 and a.objname='" + hid + "' and (to_date(rleavedate,'yyyy-MM-dd')+1)<=to_date(to_char(sysdate,'yyyy-MM-dd'),'yyyy-MM-dd')";
        List list2 = baseJdbc.executeSqlForList(sql);
        if (list2.size() > 0) {
          sql = "update humres set hrstatus='4028804c16acfbc00116ccba13802936' where id='" + hid + "'";
          baseJdbc.update(sql);
          sql = "update sysuser set isclosed=1 where objid ='" + hid + "'";
          baseJdbc.update(sql);

          LabelService labelService = (LabelService)BaseContext.getBean("labelService");
          SessionFactory sessionFactory = (SessionFactory)BaseContext.getBean("sessionFactory");
          sessionFactory.evict(Orgunit.class);
          sessionFactory.evict(Humres.class);
          sessionFactory.evict(Stationinfo.class);
          sessionFactory.evict(Stationlink.class);
          sessionFactory.evict(Orgunitlink.class);
          sessionFactory.evict(Sysuser.class);
          sessionFactory.evictQueries();
        }
      }
  }
}