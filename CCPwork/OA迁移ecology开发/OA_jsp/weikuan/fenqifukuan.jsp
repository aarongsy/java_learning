<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService"%>
<%@ page import="com.eweaver.base.util.DateHelper"%>

<%@ page import="com.sap.conn.jco.JCoTable" %>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>

<%@ page import="com.eweaver.app.configsap.SapSync"%>

<%@ page import="java.text.DecimalFormat;"%>

<%
String requestid = StringHelper.null2String(request.getParameter("requestid"));
String purchno = StringHelper.null2String(request.getParameter("purchno"));//采购订单号


BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
String nodeshow=StringHelper.null2String(request.getParameter("nodeshow"));//注前逇郑矛泳訕貣讕c

int no=0;

String delsql = "delete  uf_fnwkpurchinfo   where requestid='"+requestid+"'";
baseJdbc.update(delsql);

//创建SAP对象		
SapConnector sapConnector = new SapConnector();
String functionName = "ZOA_MM_PAYMENT01";
JCoFunction function = null;
try {
	function = SapConnector.getRfcFunction(functionName);
} catch (Exception e) {
	// TODO Auto-generated catch block
	e.printStackTrace();
}
function.getImportParameterList().setValue("EBELN",purchno);//采购订单号
System.out.println("___*********"+purchno);
function.getImportParameterList().setValue("ZTYPE","B");

try {
		function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
	} catch (JCoException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	//返回值




//抓取抛SAP的返回值
			JCoTable newretTable = function.getTableParameterList().getTable("ZMM_PAY01");
			System.out.println("行数:"+newretTable.getNumRows());
			if(newretTable.getNumRows() >0)
			{
				for(int j = 0;j<newretTable.getNumRows();j++)
				{
					if(j == 0)
					{
						newretTable.firstRow();//获取返回表格数据中的第一行


						String EBELP = newretTable.getString("EBELP");//项次
						String TXZ01 = newretTable.getString("TXZ01");//短文本
						String MEINS = newretTable.getString("MEINS");//采购单位
						String MENGE = newretTable.getString("MENGE");//采购数量
						String WRBTR = newretTable.getString("WRBTR");//完税金额
						String WAERS = newretTable.getString("WAERS");//货币
						String RATPZ = newretTable.getString("RATPZ");//比例
						String ZNETWR = newretTable.getString("ZNETWR");//付款金额
					
						//更新数据库中对应的行项信息
						no++;
						String upsql = "insert into uf_fnwkpurchinfo   (ID, REQUESTID,no,purchorder,orderrow,text,unit,pcount,mon,cur,paycent,paymon  )  values ((select sys_guid() from dual), '"+requestid+"','"+no+"','"+purchno+"','"+EBELP+"','"+TXZ01+"','"+MEINS+"','"+MENGE+"','"+WRBTR+"','"+WAERS+"','"+RATPZ+"','"+ZNETWR+"')";   
						baseJdbc.update(upsql);
						System.out.println(upsql);
						}
					else
					{
						newretTable.nextRow();//获取下一行数据
						String EBELP = newretTable.getString("EBELP");//项次
						String TXZ01 = newretTable.getString("TXZ01");//短文本
						String MEINS = newretTable.getString("MEINS");//采购单位
						String MENGE = newretTable.getString("MENGE");//采购数量
						String WRBTR =newretTable.getString("WRBTR");//完税金额
						String WAERS = newretTable.getString("WAERS");//货币
						String RATPZ = newretTable.getString("RATPZ");//比例
						String ZNETWR = newretTable.getString("ZNETWR");//付款金额
				
						no++;
						String upsql= "insert into uf_fnwkpurchinfo   (ID, REQUESTID,  no,purchorder,orderrow,text,unit,pcount,mon,cur,paycent,paymon)  values ((select sys_guid() from dual), '"+requestid+"','"+no+"','"+purchno+"','"+EBELP+"','"+TXZ01+"','"+MEINS+"','"+MENGE+"','"+WRBTR+"','"+WAERS+"','"+RATPZ+"','"+ZNETWR+"')";  
						baseJdbc.update(upsql);
						System.out.println(upsql);
					}
					
				}
			}



		/*	do{
				newretTable.nextRow();//获取下一行数据
			    //EBELP = newretTable.getString("EBELP");
			    String BSART = newretTable.getString("BSART");//采购凭证类型
			    String TXZ01 = newretTable.getString("TXZ01");//短文本
			    String MEINS = newretTable.getString("MEINS");//订购单位
			    String MENGE = newretTable.getString("MENGE");//采购数量
			    String NETWR = newretTable.getString("NETWR");//付款金额
				String EBELP = newretTable.getString("EBELP");//项次
				String ZWERT1 = newretTable.getString("ZWERT1");//完税金额
		
				no++;
				String upsql= "insert into uf_fnwkpurchinfo   (ID, REQUESTID,  no,purchorder,orderrow,text,unit,pcount,mon,cur,paycent,paymon)  values ((select sys_guid() from dual), '"+requestid+"','"+no+"','"+purchno+"','"+EBELP+"','"+TXZ01+"','"+MEINS+"','"+MENGE+"','"+ZWERT1+"','"+WAERS+"','','"+NETWR+"')";  
				baseJdbc.update(upsql);
				System.out.println(upsql);
			}while(!newretTable.isLastRow());//如果不是最后一行*/



	JSONObject jo = new JSONObject();	
	/*jo.put("LIFNR", LIFNR);
	jo.put("NAME1", NAME1);
	jo.put("BSART", BSART);
	//jo.put("EBELN", EBELN);
	jo.put("EBELP", EBELP);
	jo.put("TXZ01", TXZ01);
	jo.put("MEINS", MEINS);
	jo.put("MENGE", MENGE);
	jo.put("WAERS", WAERS);
	jo.put("NETWR", NETWR);

*/
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>


