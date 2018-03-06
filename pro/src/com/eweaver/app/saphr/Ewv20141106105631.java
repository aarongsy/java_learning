package com.eweaver.app.saphr;

import com.eweaver.app.configsap.SapConnector;
import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.util.StringHelper;
import com.eweaver.sysinterface.base.Param;
import com.eweaver.sysinterface.javacode.EweaverExecutorBase;
import com.sap.conn.jco.JCoException;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoTable;
import java.util.List;
import java.util.Map;

public class Ewv20141106105631 extends EweaverExecutorBase
{
  public void doExecute(Param paramParam)
  {
    String str1 = this.requestid;

    BaseJdbcDao localBaseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String str2 = "select themonth from uf_hr_monthtotal where requestid='" + str1 + "'";
    List localList1 = localBaseJdbcDao.executeSqlForList(str2);
    if (localList1.size() > 0) {
      Map localMap1 = (Map)localList1.get(0);
      String str3 = StringHelper.null2String(localMap1.get("themonth"));
      str3 = str3.replace("-", "");

      SapConnector localSapConnector = new SapConnector();
      String str4 = "ZHR_IT0015_M1_CREATE";
      JCoFunction localJCoFunction = null;
      try {
        localJCoFunction = SapConnector.getRfcFunction(str4);
      }
      catch (Exception localException1) {
        localException1.printStackTrace();
      }

      localJCoFunction.getImportParameterList().setValue("LGART", "7020");
      localJCoFunction.getImportParameterList().setValue("MONTH", str3);

      JCoTable localJCoTable1 = localJCoFunction.getTableParameterList().getTable("IT0015");
      str2 = "select sapid,total from uf_hr_monthtotalsub where requestid='" + str1 + "'";
      List localList2 = localBaseJdbcDao.executeSqlForList(str2);
      String str5;
      String str6;
      if (localList2.size() > 0)
        for (int i = 0; i < localList2.size(); i++) {
          Map localMap2 = (Map)localList2.get(i);
          str5 = StringHelper.null2String(localMap1.get("sapid"));
          str6 = StringHelper.null2String(localMap1.get("total"));
          localJCoTable1.appendRow();
          localJCoTable1.setValue("PERNR", str5);
          localJCoTable1.setValue("BETRG", str6);
        }
      try
      {
        localJCoFunction.execute(SapConnector.getDestination("sanpowersap"));
      }
      catch (JCoException localJCoException) {
        localJCoException.printStackTrace();
      }
      catch (Exception localException2) {
        localException2.printStackTrace();
      }

      JCoTable localJCoTable2 = localJCoFunction.getTableParameterList().getTable("MESSAGE");

      for (int j = 0; j < localJCoTable2.getNumRows(); j++) {
        str5 = localJCoTable2.getValue("PERNR").toString();
        str6 = localJCoTable2.getValue("MSGTX").toString();
        String str7 = localJCoTable2.getValue("MSGTY").toString();
        String str8 = "update uf_hr_monthtotalsub set message='" + str6 + "',msgty='" + str7 + "' where requestid='" + str1 + "' and sapid='" + str5 + "'";
        localBaseJdbcDao.update(str8);
        localJCoTable1.nextRow();
      }
    }
  }
}