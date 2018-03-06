package com.eweaver.app.dccm.dmsd;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import com.eweaver.base.AbstractAction;
import com.eweaver.base.DataService;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringFilter;
import com.eweaver.base.util.StringHelper;
import com.sap.conn.jco.JCoTable;
import com.eweaver.app.configsap.SapConnector;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoException;

public class PortSyncAction 
implements AbstractAction
{
	  protected final Log logger = LogFactory.getLog(getClass());
	  private HttpServletRequest request;
	  private HttpServletResponse response;
	  private HttpSession session;
	  private DataService dataService;
	  private int pageNo;
	  private int pageSize;

	  public PortSyncAction(HttpServletRequest request, HttpServletResponse response)
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
			    String action = "search";

			    if (action.equals("search")) {

			      String councode = StringHelper.null2String(StringFilter.filterAll(this.request.getParameter("councode")));
			      String port = StringHelper.null2String(StringFilter.filterAll(this.request.getParameter("port")));
			    //创建SAP对象
			  	SapConnector sapConnector = new SapConnector();
			  	String functionName = "ZOA_SD_PORT_MY";//马来港口
			  	JCoFunction function = null;
			  	try {
			  		function = SapConnector.getRfcFunction(functionName);
			  	} catch (Exception e) {
			  		// TODO Auto-generated catch block
			  		e.printStackTrace();
			  	}

			  	//插入字段至SAP(作为查询条件)
			  	function.getImportParameterList().setValue("LAND1",councode);//国家代码
			  	//function.getImportParameterList().setValue("INCO2",port);//PortName
			  	try 
			  	{
			  		function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
			  	} 
			  	catch (JCoException e) 
			  	{
			  		// TODO Auto-generated catch block
			  		e.printStackTrace();
			  	} 
			  	catch (Exception e) 
			  	{
			  		// TODO Auto-generated catch block
			  		e.printStackTrace();
			  	}

			  	//获取SAP子表返回值
			  	JCoTable newretTable = function.getTableParameterList().getTable("ZOA_PORT");
			      JSONArray array = new JSONArray();
			      if (newretTable != null) {
			        for (int i = 0; i < newretTable.getNumRows(); i++) {
			          JSONObject object = new JSONObject();
			          object.put("sno",(i+1));
			          object.put("portname", StringHelper.null2String(newretTable.getString("INCO2")));
			          object.put("councode", StringHelper.null2String(newretTable.getString("LAND1")));
			          object.put("counname", StringHelper.null2String(newretTable.getString("NAME1")));

			          array.add(object);
			          newretTable.nextRow();
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
			    }
	  }

}
