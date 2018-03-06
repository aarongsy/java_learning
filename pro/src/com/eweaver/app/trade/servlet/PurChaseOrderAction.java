package com.eweaver.app.trade.servlet;
import com.eweaver.base.AbstractAction;
import com.eweaver.base.DataService;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringFilter;
import com.eweaver.base.util.StringHelper;
import com.eweaver.sysinterface.base.Param;
import com.eweaver.app.configsap.SapConnector;
import com.eweaver.sysinterface.javacode.EweaverExecutorBase;
import com.sap.conn.jco.JCoException;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoTable;
import com.sap.conn.jco.JCoStructure;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
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


public class PurChaseOrderAction
implements AbstractAction
{
	protected final Log logger = LogFactory.getLog(getClass());
	private HttpServletRequest request;
	private HttpServletResponse response;
	private HttpSession session;
	private DataService dataService;
	private int pageNo;
	private int pageSize;

public PurChaseOrderAction(HttpServletRequest request, HttpServletResponse response)
{
    this.request = request;
    this.response = response;
    this.session = request.getSession();
    this.dataService = new DataService();
}

public void execute() throws IOException, ServletException
{
	this.pageNo = NumberHelper.string2Int(StringFilter.filterAll(this.request.getParameter("pageno")), 1);
    this.pageSize = NumberHelper.string2Int(StringFilter.filterAll(this.request.getParameter("pagesize")), 20);

    if (!StringHelper.isEmpty(StringFilter.filterAll(this.request.getParameter("start"))))
	{
		  this.pageNo = (NumberHelper.string2Int(StringFilter.filterAll(this.request.getParameter("start")), 0) / this.pageSize + 1);
	}

    String action = StringHelper.null2String(StringFilter.filterAll(this.request.getParameter("action")));
    if (action.equals("search"))
	{
    JSONArray array = new JSONArray();
      String ebeln = StringHelper.null2String(StringFilter.filterAll(this.request.getParameter("ebeln")));//采购订单编号
	  String suppcode=StringHelper.null2String(StringFilter.filterAll(this.request.getParameter("suppcode")));//供应商简码
	  String flower=StringHelper.null2String(StringFilter.filterAll(this.request.getParameter("flower")));//流程单号
      if (ebeln.trim().length() > 0)
	  {
		  SapConnector sapConnector=new SapConnector();
		  String functionName="XYZ";//接口名称
		  JCoFunction function=null;

		  try
		  {
			  function = SapConnector.getRfcFunction(functionName);

			  //建表
			  JCoTable retTable = function.getTableParameterList().getTable("abc");
			  retTable.appendRow();
			  retTable.setValue("A", ebeln); //采购订单编号
			  retTable.setValue("B", suppcode);//供应商简码
		      retTable.setValue("C", flower); //流程单号
			  try
			  {
				  function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
			  }
			  catch (JCoException e)
			  {
				  e.printStackTrace();
			  }
			  catch(Exception e)
			  {
				  e.printStackTrace();
			  }
			  	//抓取SAP的返回值
				String SS=function.getExportParameterList().getValue("SS").toString();//供应商简码
				String TT=function.getExportParameterList().getValue("TT").toString();//供应商名称
				String UU=function.getExportParameterList().getValue("UU").toString();//采购员
				String VV=function.getExportParameterList().getValue("VV").toString();//品名
				String WW=function.getExportParameterList().getValue("WW").toString();//数量
				String XX=function.getExportParameterList().getValue("XX").toString();//完成质量验收状态
				String YY=function.getExportParameterList().getValue("YY").toString();//现场端冻结验收SAP标识
				String ZZ=function.getExportParameterList().getValue("ZZ").toString();//财务端冻结付款SAP标识

				JSONObject object = new JSONObject();
	            object.put("pono",SS );
	            array.add(object);
				//可更新数据库中对应的信息(即SAP将要返回的信息如：现场端冻结验收SAP标识)
		  }
		  catch (JCoException e)
		  {
			  e.printStackTrace();
		  }
		  catch(Exception e)
		  {
			  e.printStackTrace();
		  }

		  JSONObject jo = new JSONObject();		
		  jo.put("pono", array);
		  
		  response.setContentType("application/json; charset=utf-8");
		  response.getWriter().write(jo.toString());
		  response.getWriter().flush();
		  response.getWriter().close();
      }
      return;
    }
  }
}