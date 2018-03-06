<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<%@ include file="/base/init.jsp"%>
<%@ include file="/app/base/init.jsp"%>
<%@ page import="java.util.*,java.text.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<head>
<style type="text/css">
<!--
.STYLE1 {
	font-family: "微软雅黑";
	font-size: 22.4px;
	font-weight: bold;
}
.STYLE2 {font-family: "微软雅黑";font-size: 15.4px;}
.STYLE3 {font-family: "微软雅黑";font-size:9.8px;}
.STYLE6 {font-family: "微软雅黑"; font-size: 16.8px; }
.STYLE8 {
	font-family: "微软雅黑";
	font-size: 18.2px;
	font-weight: bold;
}
.STYLE11 {font-family: "微软雅黑"; font-weight: bold; font-size: 12.6px;}
body {
	margin-left: 30px;
	margin-right: 30px;
}
.STYLE13 {
	font-family: "微软雅黑";
	font-size: 15.4px;
	font-weight: bold;
}
.STYLE14 {
	font-size: 12.6px;
	font-weight: bold;
}
table tr td{line-height: 28px;}
-->
</style>
</head>
<body>
<%
//根据requestid来获取外销联络单相关数据
BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
String requestid=StringHelper.null2String(request.getParameter("requestid"));
String sql = "select u1.*,u2.companyname from uf_tr_expboxmain u1 left join uf_tr_cgswhd u2 on u1.shipcompany = u2.requestid where u1.requestid = '"+requestid+"'";
List list = baseJdbcDao.getJdbcTemplate().queryForList(sql);
String reqdate = "";
String soldname = "";
String vessel = "";
String vesselno = "";
String startdate = "";
String arrivedate = "";
String icon1text = "";
String icon2text = "";
String str1 = "";
String str2 = "";
String tel1 = "";
String fax1 = "";
String cocode = "";
String companyname = "";
String deliveryno = "";
String expno = "";
if (list.size() > 0) {
	Map map001 = (Map) list.get(0);
	reqdate = StringHelper.null2String(map001.get("reqdate"));//经办日期
	soldname = StringHelper.null2String(map001.get("soldname"));//售达方名称
	vessel = StringHelper.null2String(map001.get("vessel"));//船名
	vesselno = StringHelper.null2String(map001.get("vesselno"));//航次
	startdate = StringHelper.null2String(map001.get("startdate"));//预计开航日 
	arrivedate = StringHelper.null2String(map001.get("arrivedate"));//预计到港日
	icon1text = StringHelper.null2String(map001.get("icon1text"));//国贸条件1
	icon2text = StringHelper.null2String(map001.get("icon2text"));//国贸条件2
	cocode = StringHelper.null2String(map001.get("cocode"));//公司代码
	companyname = StringHelper.null2String(map001.get("companyname"));//船公司名称 
	deliveryno = StringHelper.null2String(map001.get("deliveryno"));//提单号码 
	expno = StringHelper.null2String(map001.get("expno"));//出口编号 
	if(cocode.equals("1010")){
		str1 = "CHANG CHUN CHEMICAL(JIANGSU) CO.,LTD.";
		str2 = "Changchun Rd,Riverside Industrial Park,Changshu Econnmic Development Zone,<BR>Jiangsu Province,China 215537";
		tel1 = "86-512-52648000";
		fax1 = "86-512-52645556";
	}else if(cocode.equals("1030")){
		str1 = "ADEKA FINE CHEMICAL (CHANGSHU) CO.,LTD.";
		str2 = "Changchun Rd.,Riverside Industrial Park,Changshu Economic Development Zone,<BR>Jiangsu P.C.:215537";
		tel1 = "0512-52648000";
		fax1 = "0512-52649000";
	}else if(cocode.equals("1020")){
		str1 = "CHANG CHUN SB(CHANGSHU)CO.,LTD.";
		str2 = "Changchun Rd.,Riverside Industrial Park,Changshu Economic Development Zone,<BR>Jiangsu P.C.:215537";
		tel1 = "0512-52648000";
		fax1 = "0512-52649000";
	}else if(cocode.equals("1050")){
		str1 = "CHANG CHUN TOK(CHANGSHU) CO.,LTD.";
		str2 = "Changchun Rd.,Riverside Industrial Park,Changshu Economic Development Zone,<BR>Jiangsu P.C.:215537";
		tel1 = "0512-52648000";
		fax1 = "0512-52649000";
	}else if(cocode.equals("1060")){
		str1 = "U-PICA RESIN (CHANGSHU) CO.,LTD.";
		str2 = "Changchun Rd.,Riverside Industrial Park,Changshu Economic Development Zone,<BR>Jiangsu P.C.:215537";
		tel1 = "86-512-52648000";
		fax1 = "86-512-52642268";
	}else if(cocode.equals("2010")){
		str1 = "CHANG CHUN CHEMICAL(PANJIN) CO.,LTD.";
		str2 = "LiaoBin Coastal Economic Zoon,PanJin, Liaoning Province，China P.C.:124211";
		tel1 = "86-427-6775001";
		fax1 = "86-427-6775012";
	}else if(cocode.equals("7010")){
		str1 = "DAIREN CHEMICAL (JIANGSU) CO., LTD.";
		str2 = "No.1,Dalian Road. Yangzhou Chemical Industry Park, 211900<BR>Yizheng,Jiangsu, China";
		tel1 = "002-86-514-83268888";
		fax1 = "002-86-514-83298833";
	}
}
 %>
<object ID='WebBrowser' WIDTH=0 HEIGHT=0 CLASSID='CLSID:8856F961-340A-11D0-A96B-00C04FD705A2'></object>
<table width="500" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td colspan="8"><input id="print" type="button" value="打印" onclick="print();" /><input id="printforview" type="button" value="打印预览" onclick="printforview();" /></td>
  </tr> 
  <tr>
    <td colspan="8" align="center"><span class="STYLE1"><%=str1 %></span></td>
  </tr>  
  <tr>
    <td colspan="8" align="center"><span class="STYLE2"><%=str2 %></span></td>
  </tr>
  <tr>
    <td width="14%" align="right"><span class="STYLE6">TEL:</span></td>
    <td colspan="2" align="left"><span class="STYLE6"><%=tel1 %></span></td>
    <td colspan="2">&nbsp;</td>
    <td colspan="3" align="center"><span class="STYLE6">FAX:&nbsp;<%=fax1 %></span></td>
  </tr>  
  <!--tr>
    <td width="46%" rowspan="2" align="left">
    <span class="STYLE2"><%=str2 %></span>    </td>
    <td width="54%" align="center"><span class="STYLE2">TEL:&nbsp;&nbsp;<%=tel1 %></span></td>
  </tr>
  <tr>
    <td align="center"><span class="STYLE2"> FAX:&nbsp;&nbsp;<%=fax1 %></span></td>
  </tr>
  <tr>
	<td height="50px"></td>
  </tr-->  
  <tr>
    <td >&nbsp;</td>
    <td width="13%">&nbsp;</td>
    <td width="17%">&nbsp;</td>
    <td colspan="2">&nbsp;</td>
    <td>&nbsp;</td>
    <td width="9%">&nbsp;</td>
    <td width="18%">&nbsp;</td>
  </tr>  
  <tr>
    <td colspan="8" align="center"><span class="STYLE8"><u>SHIPPING ADVICE</u> </span></td>
  </tr>
  <tr>
    <td colspan="8" width="100px"></td>
  </tr>
  <tr>
    <td colspan="5" align="left"><span class="STYLE2">&nbsp;</span></td>
    <td colspan="3" align="right"><span class="STYLE13">DATE:</span>&nbsp;<span class="STYLE2"><%=reqdate %></span></td>
  </tr>  
  <!--tr>
    <td>&nbsp;</td>
    <td align="right"><span class="STYLE5">DATE:</span><span class="STYLE2">&nbsp;&nbsp;<%=reqdate %></span></td>
  </tr-->
  <tr>
    <td colspan="8" align="left" ><span class="STYLE13">Atten:</span>&nbsp;<span class="STYLE2"><input style="width:600px;border: 0px;font-family: '微软雅黑';font-size:15.4px;" type="text" value="<%=soldname %>"/></span> </td>
  </tr>
  <tr>
    <td height="30" colspan="8" align="left" style="padding-left:50px;"><span class="STYLE2">We are pleased to advice that we have completed a shipment of your ordered goods as per the following specification.:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> </td>
  </tr>
  <%//出口外销出货明细
  String voucherno = "";
  String purcherno = "";
  String shipno = "";
  String stockno = "";
  String stocknotmp = "";
  String quanunit = "";
  Double shipnum = 0.0;
  String sql2 = "select voucherno,purcherno,shipno,stockno,shipnum,baseunit from uf_tr_shipment where requestid = '"+requestid+"'";
  List list2 = baseJdbcDao.getJdbcTemplate().queryForList(sql2);
  DecimalFormat df = new DecimalFormat("0.00");
  for(int j = 0;j < list2.size();j++){
  	Map map001 = (Map) list2.get(j);
  	if(list2.size() - j == 1){
		voucherno += StringHelper.null2String(map001.get("voucherno"));//销售订单号
		purcherno += StringHelper.null2String(map001.get("purcherno"));//采购订单编号
		shipno += StringHelper.null2String(map001.get("shipno"));//出货编号
		stocknotmp = StringHelper.null2String(map001.get("stockno"));//物料号
		stocknotmp = stocknotmp.replace("_X", "");
		stocknotmp = stocknotmp.replace("_Y", "");
		//stockno += StringHelper.null2String(map001.get("stockno"));	//物料号
		stockno += stocknotmp;		//物料号
		shipnum += NumberHelper.string2Double(StringHelper.null2String(map001.get("shipnum")));//出货数量
		quanunit = StringHelper.null2String(map001.get("baseunit")); //基本单位 
  	}else{
		voucherno += StringHelper.null2String(map001.get("voucherno")) + ",";//销售订单号
		purcherno += StringHelper.null2String(map001.get("purcherno")) + ",";//采购订单编号
		shipno += StringHelper.null2String(map001.get("shipno")) + ";";//出货编号
		stocknotmp = StringHelper.null2String(map001.get("stockno"));//物料号
		stocknotmp = stocknotmp.replace("_X", "");
		stocknotmp = stocknotmp.replace("_Y", "");		
		//stockno += StringHelper.null2String(map001.get("stockno")) + ";";//物料号
		stockno += stocknotmp + ";";//物料号
		shipnum += NumberHelper.string2Double(StringHelper.null2String(map001.get("shipnum")));//出货数量
		quanunit = StringHelper.null2String(map001.get("baseunit")); //基本单位 
  	}
  }
    String shipnumStr = df.format(shipnum) + "";
	String datas[] = shipnumStr.split("\\.");
	String str = "";
	if(datas.length > 1){
		if(Integer.valueOf(datas[1]) > 0){
			str = shipnumStr;
		}else{
			str = datas[0];
		}
	}
   %>
  <tr>
    <td colspan="8" align="left"><span class="STYLE13">PO NO.:</span>&nbsp;<span class="STYLE2"><%=purcherno %></span> </td>
  </tr>
  <tr>
    <td colspan="8" align="left"><span class="STYLE13">Grade:</span>&nbsp;<span class="STYLE2"><%=stockno %></span></td>
  </tr>
  <tr>
    <td colspan="8" align="left"><span class="STYLE13">Total Quantity:</span>&nbsp;<span class="STYLE2"><input class="input_txt" index="3" style="font-family: '微软雅黑';font-size:15.4px;width:70%;border: 0px;border-bottom: 1px solid;" type="text" value="<%=str %>  <%=quanunit %>"/></span> </td>
  </tr>
  <tr>
    <td colspan="8" align="left"><span class="STYLE13">Delivery Term:</span>&nbsp;<span class="STYLE2"><input class="input_txt" index="4" style="font-family: '微软雅黑';font-size:15.4px;width:70%;border: 0px;border-bottom: 1px solid;" type="text" value="<%=icon1text %>  <%=icon2text %>"/></span> </td>
  </tr>
  <tr>
    <td colspan="8" align="left"><span class="STYLE13">ETD Requested:</span>&nbsp;<span class="STYLE2"><input class="input_txt" index="5" style="font-family: '微软雅黑';font-size:15.4px;width:70%;border: 0px;border-bottom: 1px solid;" type="text" value="<%=startdate %>"/></span> </td>
  </tr>
  <tr>
    <td colspan="8" align="left"><span class="STYLE13">Invoice No.:</span>&nbsp;<span class="STYLE2"><input class="input_txt" index="6" style="font-family: '微软雅黑';font-size:15.4px;width:70%;border: 0px;border-bottom: 1px solid;" type="text" value="<%=expno %>"/></span> </td>
  </tr>
  <tr>
    <td colspan="8" align="left"><span class="STYLE13">ETD:</span>&nbsp;<span class="STYLE2"><%=startdate %></span> </td>
  </tr>
  <tr>
    <td colspan="8" align="left"><span class="STYLE13">ETA:</span>&nbsp;<span class="STYLE2"><%=arrivedate %></span> </td>
  </tr>
  <tr>
    <td colspan="8" align="left"><span class="STYLE13">Shipping Co.:&nbsp;&nbsp;</span><span class="STYLE2"><input class="input_txt" index="3" style="font-family: '微软雅黑';font-size:15.4px;width:70%;border: 0px;border-bottom: 1px solid;" type="text" value="<%=companyname %>"/></span></td>
  </tr>
  <tr>
    <td colspan="8" align="left"><span class="STYLE13">Vessel Name:</span>&nbsp;<span class="STYLE2"><%=vessel %></span> </td>
  </tr>
  <tr>
    <td colspan="8" align="left"><span class="STYLE13">Voy No.:</span>&nbsp;<span class="STYLE2"><%=vesselno %></span> </td>
  </tr>
  <tr>
    <td colspan="8" align="left"><span class="STYLE13">B/L No.(Origunal/ Surrendered):</span>&nbsp;<span class="STYLE2"><%=deliveryno %></span> </td>
  </tr>
  <tr>
    <td height="30" colspan="8" align="left" style="padding-left:50px;"><span class="STYLE2">We hope the goods will arrive at your hand in good condition.</span> </td>
  </tr>
  <tr>
    <td height="30" colspan="8" align="left" style="padding-left:50px;"><span class="STYLE2">Best Regards, </span></td>
  </tr>
  <tr>
    <td height="80" colspan="8" align="left" style="padding-left:50px;"><span class="STYLE2"></span></td>
  </tr>
  <tr>
    <td colspan="8" align="left" valign="bottom"><SPAN><BR><BR><BR></SPAN><textarea class="input_txt" index="1" style="overflow-y:visible;width:600px;border: 0px;border-bottom: 1px solid;font-size:25px;font-family:微软雅黑;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</textarea></td>    
  </tr>
  <tr>
  	<td colspan="4"></td>
    <td colspan="4" align="left"><span class="STYLE13"><%=str1 %></span></td>
  </tr>
  <tr>
    <td height="30" colspan="8"></td>
  </tr>
  <tr>
  	<td colspan="4"></td>
    <td align="left" colspan="4" style="border-bottom:inset 2px #000000;height:42px;"></td>
  </tr>
  <tr>
  	<td colspan="4"></td>
    <td align="left" colspan="4"><span class="STYLE13">(Authorized Signature)</span></td>
  </tr>  
  
  

  <!--tr>
    <td colspan="8" align="left" valign="bottom"><SPAN><BR><BR><BR><BR><BR><BR><BR><BR></SPAN><textarea class="input_txt" index="1" style="overflow-y:visible;width:600px;border: 0px;border-bottom: 1px solid;font-size:25px;font-family:微软雅黑;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</textarea></td>    
  </tr>
  <tr>
    <td colspan="2" align="right" style="margin-right: 50px;"><span class="STYLE8"><%=str1 %></span></td>
  </tr>
  <tr>
    <td height="30" colspan="1"></td>
  </tr>
  <tr>
  	<td colspan="1"></td>
    <td align="left" colspan="1" style="border-bottom:inset 2px #000000;"></span></td>
  </tr>
  <tr>
    <td colspan="2" align="right" style="margin-right: 50px;"><span class="STYLE8">(Authorized Signature)</span></td>
  </tr-->
</table>
</body>
<script type="text/javascript" src="/app/js/jquery.js"></script>
<script type="text/javascript">
var HKEY_Root,HKEY_Path,HKEY_Key; 
HKEY_Root="HKEY_CURRENT_USER"; 
HKEY_Path="\\Software\\Microsoft\\Internet Explorer\\PageSetup\\"; 
//设置网页打印的页眉页脚为空 
function PageSetup_Null() { 
	try { 
		var Wsh=new ActiveXObject("WScript.Shell"); 
		HKEY_Key="header"; 
		Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,""); 
		HKEY_Key="footer"; 
		Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,""); 
		HKEY_Key="margin_left";
	    Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"0");
	    HKEY_Key="margin_right";
	    Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"0");
	    HKEY_Key="margin_top";
	    Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"0.19");
	    HKEY_Key="margin_bottom";
	    Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"0.19");
	} catch(e) {
		alert("打印设置故障，请联系系统管理员！");
	} 
} 
//打印
function print(){
	PageSetup_Null();
	hideInput();
	//隐藏打印按钮和打印预览按钮
	jQuery("#print").css("display","none");
	jQuery("#printforview").css("display","none");
	//打印
	WebBrowser.ExecWB(6,1);
}
//打印预览
function printforview(){
	PageSetup_Null();
	hideInput();
	//隐藏打印按钮和打印预览按钮
	jQuery("#print").css("display","none");
	jQuery("#printforview").css("display","none");
	//打印
	WebBrowser.ExecWB(7,1);
}
//打印前先将输入框隐藏
function hideInput(){
	jQuery(".input_txt").each(function(){
		var index = jQuery(this).attr("index");
		jQuery(this).css("border","0");
		jQuery("#input_txt"+index).html(jQuery(this).val());
		//jQuery("#input_txt"+index).css("display","block");
	});
}
</script>
</html>
