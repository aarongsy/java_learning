<%@page import="com.weaver.general.BaseBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.sap.mw.jco.*"%>
<%@page import="com.weaver.integration.log.LogInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@page
	import="com.weaver.integration.datesource.SAPInterationDateSourceImpl"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="java.io.PrintWriter" %>

<%
	/**
	 * 从SAP获取到冲销凭证号，成功获取冲销凭证号的，则更正暂估单上的冲销凭证号、作废人、作废时间、暂估单状态，
	 */
	String BELNR = request.getParameter("BELNR");//SAP凭证编号
	String BUKRS = request.getParameter("BUKRS");//公司代码
	String GJAHR = request.getParameter("GJAHR");//会计年度
	String djbh=request.getParameter("djbh");//暂估单单据编号
	BaseBean bs = new BaseBean();
	String sql="";

	try{
		
		if(BELNR.equals("")||BELNR==null){
			RecordSet rs=new RecordSet();
			sql="update uf_zgfy set djstatus='4' where djbh='"+djbh+"'";
			bs.writeLog(sql);
			rs.execute(sql);
			JSONObject jsonObject=new JSONObject();
			jsonObject.put("msg","success");
			out.clear();
			out.write(jsonObject.toString());
			out.flush();
			return;
		}
	
	JCO.Client sapconnection = null;
	SAPInterationDateSourceImpl sapidsi = new SAPInterationDateSourceImpl();
	sapconnection = (JCO.Client) sapidsi.getConnection("1", new LogInfo());
	bs.writeLog("创建SAP连接");
	String strFunc = "ZOA_FI_DOC_REV";

	JCO.Repository myRepository = new JCO.Repository("Repository", sapconnection);
	IFunctionTemplate ft = myRepository.getFunctionTemplate(strFunc.toUpperCase());
	JCO.Function function = ft.getFunction();
	bs.writeLog("SAP已连接，开始设定值...");
	function.getImportParameterList().setValue(BELNR, "BELNR");
	function.getImportParameterList().setValue(BUKRS, "BUKRS");
	function.getImportParameterList().setValue(GJAHR, "GJAHR");
	
	sapconnection.execute(function);
	bs.writeLog("获取返回参数>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	String FLAG=function.getExportParameterList().getValue("FLAG").toString();	//单一字符标识
	bs.writeLog("FLAG:"+FLAG);
	String ERR_MSG=function.getExportParameterList().getValue("ERR_MSG").toString();	//消息文本
	bs.writeLog("ERR_MSG:"+ERR_MSG);
	String STBLG=function.getExportParameterList().getValue("STBLG").toString();	//冲销凭证号
	bs.writeLog("STBLG:"+STBLG);
	bs.writeLog("获取返回参数结束<<<<<<<<<<<<<<<<<<<<<<<<<<");
	sapidsi.releaseC(sapconnection);
	JSONObject jsonObject=new JSONObject();
	jsonObject.put("FLAG", FLAG);
	jsonObject.put("ERR_MSG", ERR_MSG);
	jsonObject.put("STBLG", STBLG);
		if ("X".equals(FLAG)){
			int invalidpsn=user.getUID();

			updateZFStatus(STBLG,djbh,invalidpsn);
		}
		out.clear();
		out.write(jsonObject.toString());
		out.flush();
		out.close();
	return;
	}catch(Exception e){
		bs.writeLog("报错了："+e);
		JSONObject jsonObject=new JSONObject();
		jsonObject.put("err", e+"");
		out.write(jsonObject.toString());
		
	}
	
	
	
%>
<%! public void updateZFStatus(String STBLG,String djbh,int invalidpsn){
    RecordSet recordSet=new RecordSet();
	SimpleDateFormat simpleDateFormat=new SimpleDateFormat("yyyy-MM-dd");
	Date date= new Date();
	String invalidtime=simpleDateFormat.format(date);
	User user=new User();

	recordSet.writeLog("invalidpsn:"+invalidpsn);
    StringBuffer stringBuffer=new StringBuffer().append("UPDATE UF_ZGFY SET ")
			.append("invalidpsn='"+invalidpsn+"',invalidtime='"+invalidtime+"',cxpzh='"+STBLG+"',djstatus='4'")
			.append(" where djbh='"+djbh+"'");
	recordSet.writeLog(stringBuffer.toString());
	recordSet.execute(stringBuffer.toString());


}

%>