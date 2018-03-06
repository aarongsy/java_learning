package com.eweaver.app.autotask;

import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringHelper;
import com.eweaver.interfaces.model.Cell;
import com.eweaver.interfaces.model.Dataset;
import com.eweaver.interfaces.workflow.RequestInfo;
import com.eweaver.interfaces.workflow.WorkflowServiceImpl;
import java.io.PrintStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

public class CheckGYS
{
  public void doAction()
  {
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String sql = "select requestid  from uf_oa_gyszz where pdjg = '40285a8d4fbaabf8014fbf02d88515c8' and 1<>(select isdelete from formbase where id = requestid)";
    sql = sql + " and (select to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd')  as sysdates from dual) > to_date(zzyxrq,'yyyy-mm-dd')";
    System.out.println("采购供应商判断是否合格" + sql);

    List list = baseJdbc.executeSqlForList(sql);
    if (list.size() > 0)
      for (int i = 0; i < list.size(); i++) {
        Map map = (Map)list.get(i);
        String onlyid = StringHelper.null2String(map.get("requestid"));
		String upsql = "update uf_oa_gyszz set pdjg = '40285a8d4fbaabf8014fbf02d88515c9' where requestid = '"+onlyid+"'";
		System.out.println(upsql);
		baseJdbc.update(upsql);
      }
  }

}