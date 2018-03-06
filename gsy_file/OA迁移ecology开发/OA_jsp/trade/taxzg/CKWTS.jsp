<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.util.*"%>
<%@ page import="com.eweaver.base.*"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="java.text.DecimalFormat"%>


<head>
<meta http-equiv="X-UA-Compatible" content="IE=EDGE" >
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type="text/css">
<!--
body {
	margin-left: 20px;
	margin-right: 20px;
}

.STYLE3 {font-family:'Arial','SimSun','Microsoft YaHei';font-size: 12px/0.75em;}

.STYLE9 {
	font-family: "微软雅黑";
	font-size: 25px;
	font-weight: bold;
}

.STYLE10 {
	font-family: "微软雅黑";
	font-size: 28px;
}

.header tr td {
	height: 23px;
	align: left;
	border-bottom:0px solid black;
	border-left:0px solid black;
}

.detail tr td {
	height: 23px;
	align: left;
	border-bottom:0px solid black;
	border-left:0px solid black;
	//font-family: "微软雅黑";
	//font-size: 12px;
}

.footer  tr td {
	height: 23px;
	align: left;
	border-bottom:0px solid black;
	border-left:0px solid black;
}

textarea 
{ 
width:100%; 
height:100%; 
} 

select option {
	font-size:16px; 
	font-family:"微软雅黑";
}


-->
</style>
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
	} catch(e) {} 
} 

//打印
function print(){
	if(beforeprint("radiobutton","运费","yftxt") && beforeprint("radiobutton1","是否可以转运","zytxt")  && beforeprint("radiobutton2","拖车安排","tctxt")  && beforeprint("radiobutton4","提单要求","tdtxt")  ){
		jQuery("#packid").css("display","none");
		jQuery("#packtxt").css("display","block");
		
		jQuery("#radiobutton").css("display","none");
		jQuery("#yftxt").css("display","block");
		jQuery("#radiobutton1").css("display","none");
		jQuery("#zytxt").css("display","block");
		jQuery("#radiobutton2").css("display","none");
		jQuery("#tctxt").css("display","block");
		jQuery("#radiobutton4").css("display","none");
		jQuery("#tdtxt").css("display","block");
		document.getElementById("mwid").innerText = format(document.getElementById("mwid").innerText);
		
		PageSetup_Null();
		//隐藏打印按钮和打印预览按钮
		jQuery("#print").css("display","none");
		jQuery("#printforview").css("display","none");
		
		//打印
		WebBrowser.ExecWB(6,1);
	}
}
//打印预览
function printforview(){
	if(beforeprint("radiobutton","运费","yftxt") && beforeprint("radiobutton1","是否可以转运","zytxt")  && beforeprint("radiobutton2","拖车安排","tctxt")  && beforeprint("radiobutton4","提单要求","tdtxt")  ){
		jQuery("#packid").css("display","none");
		jQuery("#packtxt").css("display","block");
		
		jQuery("#radiobutton").css("display","none");
		jQuery("#yftxt").css("display","block");
		jQuery("#radiobutton1").css("display","none");
		jQuery("#zytxt").css("display","block");
		jQuery("#radiobutton2").css("display","none");
		jQuery("#tctxt").css("display","block");
		jQuery("#radiobutton4").css("display","none");
		jQuery("#tdtxt").css("display","block");
		document.getElementById("mwid").innerText = format(document.getElementById("mwid").innerText);
		
		PageSetup_Null();
		//隐藏打印按钮和打印预览按钮
		jQuery("#print").css("display","none");
		jQuery("#printforview").css("display","none");
				
		//打印
		WebBrowser.ExecWB(7,1);
	}
}


function beforeprint(radioname,name,id){
	var flag = true;
	var v=document.getElementsByName(radioname);	
	var j=0;
	for (var i=0;i<v.length;i++){
		if(v.item(i).checked){ 
			j++; 
			if(id!="tdtxt"){
				if(id=="yftxt" && v.item(i).value=="其他"){
					if(document.getElementById("othyftxt").value==""){
						alert("运费其他，请输入!");
						flag = false;
						break;						
					}else{					
						document.getElementById(id).innerText = document.getElementById("othyftxt").value;
					}
				}else{
					document.getElementById(id).innerText = v.item(i).value;	
				}
			}else{
				document.getElementById(id).innerText = document.getElementById(id).innerText  +" "+ v.item(i).value;
			}
		}
	}
	if(j<1){
		alert(name+"必选");
		flag = false;
		return flag;
	}	
	return flag;
}

function chgpack(){
	var pack = document.getElementById("packid").value;
	document.getElementById("packtxt").innerText = "        "+pack;
}

function format(num) { 
    return (num+'').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,'); 
} 


</script>
</head>
<%
//根据requestid来获取外销联络单相关数据
BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
DataService ds = new DataService();
String requestid=StringHelper.null2String(request.getParameter("requestid"));
String sql = "select u1.*,u2.companyname,u3.describe describe1,u4.describe describe2,u5.pcategory,h.objname,s.objname selectname,fydl.contacts fyllr,fydl.telephone fytel,fydl.fax fyfax,hydl.contacts hyllr,hydl.telephone hytel,hydl.fax hyfax  from uf_tr_expboxmain u1 left join uf_tr_cgswhd u2 on u1.shipcompany = u2.requestid left join uf_tr_gkwhd u3 on u1.departure = u3.requestid left join uf_tr_gkwhd u4 on u1.destport = u4.requestid left join uf_tr_prodcate u5 on u5.requestid = u1.goodsgroup left join humres h on u1.bginfopsn = h.id left join selectitem s on u1.billtype = s.id left join uf_tr_ffinfo  fydl on fydl.concode=u1.agentcodetxt and fydl.company=u1.factory and fydl.state='40288098276fc2120127704884290210' left join uf_tr_ffinfo hydl on hydl.concode=u1.sagentcodetxt and hydl.company=u1.factory and hydl.state='40288098276fc2120127704884290210' where u1.requestid = '"+requestid+"'";
List list = baseJdbcDao.getJdbcTemplate().queryForList(sql);
String expno = "";
String startdate = "";
String icon1text = "";
String icon2text = "";
String companyname = "";
String coname = "";
String sagentname = "";
String SHIPPER = "";
String destport = "";
String departure = "";
String consignee = "";
String notifyparty = "";
String shipping = "";
String goodsgroup = "";
String cbms = "";
String gwsum = "";
String stocktotal = "";
String packtotal = "";
String llr = "";
String tel = "";
String fax = "";
String lastname = "";
String selectname = "";
String freedate = "";
String freestack = "";
String deliremark = "";
String leavedate = "";
String deadline = "";
String destfee = "";
String destfeedes = "";
String feeproj = "";
if (list.size() > 0) {
	Map map001 = (Map) list.get(0);
	expno = StringHelper.null2String(map001.get("expno"));//出口编号
	startdate = StringHelper.null2String(map001.get("startdate"));//预计开航日 
	icon1text = StringHelper.null2String(map001.get("icon1text"));//国贸条件1
	icon2text = StringHelper.null2String(map001.get("icon2text"));//国贸条件2
	companyname = StringHelper.null2String(map001.get("companyname"));//船公司名称 
	coname = StringHelper.null2String(map001.get("coname"));//公司名称 
	sagentname = StringHelper.null2String(map001.get("sagentname"));//海运代理名称 
	SHIPPER = StringHelper.null2String(map001.get("SHIPPER"));//SHIPPER
	departure = StringHelper.null2String(map001.get("describe1"));//起运港
	destport = StringHelper.null2String(map001.get("describe2"));//目的港
	consignee = StringHelper.null2String(map001.get("consignee"));//consignee
	notifyparty = StringHelper.null2String(map001.get("notifyparty"));//notifyparty
	shipping = StringHelper.null2String(map001.get("shipping"));//shipping
	goodsgroup = StringHelper.null2String(map001.get("notifyparty2"));//中英文品名 提单要求(货物描述)
	cbms = StringHelper.null2String(map001.get("cbmtotal"));//材积cbm合计
	gwsum = StringHelper.null2String(map001.get("gwsum"));//毛重合计
	stocktotal = StringHelper.null2String(map001.get("stocktotal"));//托盘数合计
	packtotal = StringHelper.null2String(map001.get("packtotal"));//木箱数/包数/桶数合计
	if ("FOB".equals(icon1text)) {
		llr = StringHelper.null2String(map001.get("fyllr"));//联络人	货运代理
		tel = StringHelper.null2String(map001.get("fytel"));//tel
		fax = StringHelper.null2String(map001.get("fyfax"));//fax
	}else{
		llr = StringHelper.null2String(map001.get("hyllr"));//联络人	海运代理
		tel = StringHelper.null2String(map001.get("hytel"));//tel
		fax = StringHelper.null2String(map001.get("hyfax"));//fax	
	}
	lastname = StringHelper.null2String(map001.get("objname"));//报关人
	selectname = StringHelper.null2String(map001.get("selectname"));//提单形式
	freedate = StringHelper.null2String(map001.get("freedate"));//免箱期
	freestack = StringHelper.null2String(map001.get("freestack"));//免堆期
	deliremark = StringHelper.null2String(map001.get("deliremark"));//出货备注
	leavedate = StringHelper.null2String(map001.get("leavedate"));//预计可出厂日 装箱日期
	deadline = StringHelper.null2String(map001.get("deadline")); //客户要求最晚到货日
	destfee = StringHelper.null2String(map001.get("destfee")); //目的港费用
	feeproj = StringHelper.null2String(map001.get("feeproj")); //费用项目
}



 %>
<body>
	<object ID='WebBrowser' WIDTH=0 HEIGHT=0 CLASSID='CLSID:8856F961-340A-11D0-A96B-00C04FD705A2'></object>
	<div>
		<div align="left"><input id="print" type="button" value="打印" onclick="print();" /><input id="printforview" type="button" value="打印预览" onclick="printforview();" /></div>
	</div>
	<!--div>
		<table width="100%%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="76%"></td>
				<td width="24%">编号:CQCB07515MK<BR>版别:1.2</td>
			</tr>
		</table>
	</div-->
	<!--div>
		<div align="right" style="height:25px;">编号:CQCB07515MK</div>
	</div>
	<div>
		<div align="right" style="margin-right:90px;height:25px;">版别:1.2</div>
	</div-->
	<div>
		<!--div align="center" class="STYLE9"><%=coname %></div-->
		<table width="100%%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="25%"></td>
				<td width="50%" align="center" ><SPAN class="STYLE9"><%=coname %></SPAN></td>
				<td width="25%">编号:CQCB07515MK<BR>版别:1.2</td>
			</tr>
		</table>
	</div>
	<div>
		<div align="center"><SPAN class="STYLE10">出口委托书</SPAN></div>
	</div>

	<table width="100%%" border="1" cellspacing="0" cellpadding="0" class="header" style="border-right:0px solid black;border-top:0px solid black;">
		<tr>
			<td width="51%"><SPAN class="STYLE3">致货代公司：<%=sagentname %></SPAN></td>
			<td colspan="2" rowspan="2"><SPAN class="STYLE3">委托编号：<%=expno %></SPAN></td>
		</tr>
		<tr>
			<td height="31"><SPAN class="STYLE3">联络人/TEL/FAX：<%=llr%>&nbsp;&nbsp;<%=tel%>&nbsp;&nbsp;<%=fax%></SPAN></td>
		</tr>
		<tr>
			<td rowspan="4"  valign="top"><SPAN class="STYLE3">SHIPPER:</SPAN><br />
				<textarea class="input_txt" index="1" style="overflow-y:hidden;width:100%;height:80px;border: 0px;font-size:12px/0.75em;font-family:'Arial','SimSun','Microsoft YaHei';"><%=SHIPPER %></textarea>
			</td>
			<td width="27%"><SPAN class="STYLE3">目的港：<%=destport %></SPAN></td>
			<td width="22%"><SPAN class="STYLE3">出运港：<%=departure %></SPAN></td>
		</tr>
		<tr>
			<td colspan="2"><SPAN class="STYLE3">国贸条件：<%=icon1text %></SPAN></td>
		</tr>
		<tr>
			<td colspan="2" align="center"><SPAN class="STYLE3">运费</SPAN></td>
		</tr>
		<tr>
			<td colspan="2" align="center"><SPAN id="yftxt" class="STYLE3"></SPAN><SPAN id="radiobutton"><input type="radio"
				name="radiobutton" value="PREPAID" />PREPAID&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="radio" name="radiobutton" value="COLLECT" />COLLECT&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="radio" name="radiobutton" value="其他" />其他&nbsp;&nbsp;&nbsp;&nbsp;
				<input id="othyftxt" type="text" style="text-decoration:underline;border: 0px;width:150px;font-size:12px/0.75em;font-family:'Arial','SimSun','Microsoft YaHei';" type="text" value="" /></SPAN>
				</td>
			</td>
		</tr>
		<tr >
			<td rowspan="4" valign="top" ><SPAN class="STYLE3">CONSIGNEE：</SPAN><br />
				<textarea class="input_txt" index="2" style="overflow-y:hidden;width:100%;height:120px;border: 0px;font-size:12px/0.75em;font-family:'Arial','SimSun','Microsoft YaHei';"><%=consignee %></textarea>
			</td>
			<td style="border-bottom:0px solid black;"><SPAN class="STYLE3" >船公司：</SPAN></td>			
			<td style="border-bottom:0px solid black;"><SPAN class="STYLE3">客户要求最晚到货日：</SPAN></td>			
		</tr>
		<tr >
			<td valign="top" style="border-top:0px solid black;">
				<textarea valign="top" style="overflow-y:hidden;width:100%;height:45px;border: 0px;font-size:12px/0.75em;font-family:'Arial','SimSun','Microsoft YaHei'"><%=companyname %></textarea>
			</td>
			<td style="border-top:0px solid black;">
				<textarea style="overflow-y:hidden;width:100%;height:40px;border: 0px;font-size:12px/0.75em;font-family:'Arial','SimSun','Microsoft YaHei'"><%=deadline %></textarea>
				<!--input align="left"	style="width:150px;border: 0px;font-size:12px;font-family:'Arial','SimSun','Microsoft YaHei';" type="text" value="<%=deadline %>" /-->
			</td>
		</tr>
		<tr>
			<td style="border-bottom:0px solid black;"><SPAN class="STYLE3">船期：</SPAN></td>			
			<td style="border-bottom:0px solid black;"><SPAN class="STYLE3">装箱日期：</SPAN></td>			
		</tr>
		<tr>
			<td style="border-top:0px solid black;"><SPAN style="font-size:12px/0.75em;font-family:'Arial';"><%=startdate %></SAPN></td>
			<td style="border-top:0px solid black;"><input align="left" style="width:150px;border: 0px;font-size:12px/0.75em;font-family:'Arial','SimSun','Microsoft YaHei';" type="text"
				value="<%=leavedate %>" />
				<!--textarea style="overflow-y:hidden;width:98%;height:20px;border: 0px;font-size:16px;"></textarea-->			
			</td>
		</tr>
		<tr>
			<td rowspan="4" valign="top" ><SPAN class="STYLE3">NOTIFYPARTY：</SPAN><br />
				<textarea class="input_txt" index="3" style="overflow-y:hidden;width:100%;height:120px;border: 0px;font-size:12px/0.75em;font-family:'Arial','SimSun','Microsoft YaHei';"><%=notifyparty %></textarea>
			</td>
			<td colspan="2" align="center"><SPAN class="STYLE3">是否可以转运</SPAN></td>
		</tr>
		<tr>
			<td colspan="2" align="center"><SPAN id="zytxt" class="STYLE3"></SPAN>
				<SPAN id="radiobutton1"><input type="radio"	name="radiobutton1" value="是" />是&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="radio" name="radiobutton1" value="否" />否</SPAN>
				
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center"><SPAN class="STYLE3">拖车安排</SPAN></td>
		</tr>
		<tr>
			<td colspan="2" align="center" style="border-bottom:0px solid black;"><SPAN id="tctxt" style="display:block;font-size:12px/0.75em;font-family:'Arial','SimSun','Microsoft YaHei';"></SPAN>
				<SPAN id="radiobutton2">
				<input type="radio" name="radiobutton2" value="派车" />派车&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="radio" name="radiobutton2" value="自送" />自送</SPAN>
				
			</td>
		</tr>
	</table>
	<table width="100%%" border="1" align="center" cellpadding="0" cellspacing="0" class="detail" style="border-bottom:0px solid black;border-right:0px solid black;border-top:0px solid black;">
		<tr>
			<td width="30%" align="center" style="border-top:0px solid black;"><SPAN class="STYLE3">唛头</SPAN></td>
			<td width="34%" align="center" style="border-top:0px solid black;"><SPAN class="STYLE3">中英文品名</SPAN></td>
			<td width="11%" align="center" style="border-top:0px solid black;"><SPAN class="STYLE3">件数</SPAN></td>
			<td width="11%" align="center" style="border-top:0px solid black;"><SPAN class="STYLE3">毛重(公斤)</SPAN></td>
			<td width="11%" align="center" style="border-top:0px solid black;"><SPAN class="STYLE3">体积(M3)</SPAN></td>
		</tr>
		<tr>
			<td style="border-bottom:0px solid black;word-break:break-all;" align="left" valign="top"><SPAN class="STYLE3"><%=shipping %><SPAN></td>
			<td style="border-bottom:0px solid black;word-break:break-all;" align="center" valign="top">
			<textarea class="input_txt" index="3" style="overflow-y:hidden;width:100%;height:140px;border: 0px;font-size:12px/0.75em;font-family:'Arial','SimSun','Microsoft YaHei';"><%=goodsgroup %></textarea><!--input
				style="width:98%;height:90px;border: 0px;font-size:16px;" type="text"
				value="<%=goodsgroup %>" /-->
			</td>
			<td style="border-bottom:0px solid black;" >
				<input align="center" id="packtxt" style="width:150px;border: 0px;font-size:12px/0.75em;font-family: font-family:'Arial','SimSun','Microsoft YaHei';"  type="text" value="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=packtotal %>&nbsp; 包" />
				<select id="packid" name="select" style="width:100%;height30px;font-size=24px;font-family:font-family:'Arial','SimSun','Microsoft YaHei';" onchange="chgpack();">
					<option value="<%=packtotal %>&nbsp; 包"><%=packtotal %>&nbsp; 包</option>
					<option value="<%=packtotal %>&nbsp; 桶"><%=packtotal %>&nbsp; 桶</option>
					<option value="<%=packtotal %>&nbsp; 木箱"><%=packtotal %>&nbsp; 木箱</option>
					<option value="<%=packtotal %>&nbsp; ISO-TANK"><%=packtotal %>&nbsp; ISO-TANK</option>
					<option value="<%=packtotal %>&nbsp; 散货船"><%=packtotal %>&nbsp; 散货船</option>
					<option value="<%=stocktotal %>&nbsp; 托盘"><%=stocktotal %>&nbsp; 托盘</option>
				</select>				
				<!--SPAN id="packtxt" style="display:block;font-size:16px;font-family:'微软雅黑';"><%=packtotal %>&nbsp; 包</SPAN-->				
			</td>
			<td style="border-bottom:0px solid black;" align="center"><SPAN class="STYLE3" id="mwid"><%=gwsum %><SPAN></td>
			<td style="border-bottom:0px solid black;" align="center"><SPAN class="STYLE3"><%=cbms %><SPAN></td>
		</tr>
	</table>
 <%
 String sql1 = "select  u1.cabtype,u1.isdager,u1.cabno from uf_tr_packtype u1 where u1.requestid = '"+requestid+"' group by u1.cabtype,u1.isdager,u1.cabno";
 List list1 = baseJdbcDao.getJdbcTemplate().queryForList(sql1);
 String cabtype = "";
 if (list1.size() > 0) {
	Map map001 = (Map) list1.get(0);
	cabtype = StringHelper.null2String(map001.get("cabtype"));//柜型
 }
 %>
	<table width="100%%" border="1" align="center" cellpadding="0" cellspacing="0" class="footer" style="border-right:0px solid black;">
		<tr>
			<td colspan="2" align="center" style="border-top:0px solid black;"><SPAN class="STYLE3">集装箱箱类<SPAN></td>
		</tr>
		<tr>
			<td width="51%" align="left"><SPAN class="STYLE3">柜型：<%=cabtype %><SPAN></td>
			<td width="49%" align="left"><SPAN class="STYLE3">若为冷冻\冷藏箱，温度要求 
			<input style="width:30px;border: 0px;font-size:12px/0.75em;" type="text" value="" />℃<SPAN></td>
		</tr>
		<tr>
			<td colspan="2" align="left"><SPAN class="STYLE3">柜数：<%=list1.size() %><SPAN></td>
		</tr>
		<tr>
			<td colspan="2" align="center"><SPAN class="STYLE3">是否为危险品<SPAN></td>
		</tr>
		<tr>

			 <%
			 String sql2 = "select distinct (select objname from selectitem where id= b.dangerouslv) isdager,b.unno from uf_tr_shipment a,uf_tr_materialsp b "
			 +"where a.stockno=b.materialno and a.requestid='"+requestid+"' order by isdager desc";
			 List list2 = baseJdbcDao.getJdbcTemplate().queryForList(sql2);
			 String isdager = "";
			 String unno = "";
			 String isdagerflag = "";
			 if (list2.size() > 0) {
				Map map001 = (Map) list2.get(0);
				isdager = StringHelper.null2String(map001.get("isdager"));				
				unno = StringHelper.null2String(map001.get("unno"));
				if ( "".equals(isdager) || "0".equals(isdager) ) {
					isdagerflag = "0";
				}else{
					isdagerflag = "1";
				}
			 }
			 %>
			<td align="center">
				<input type="radio" <%=(isdagerflag!="0"?"checked":"")%> name="radiobutton3" value="是" />是&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
				<input type="radio" <%=(isdagerflag=="0"?"checked":"")%> name="radiobutton3" value="否" />否
			</td>
			<td align="left"><SPAN class="STYLE3">（CLASS：<%=isdager %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; UN NO： <%=unno %>）<SPAN></td>
		</tr>
		<tr>
			 <%
			 String sql3 = "select freighttype,notaxprice,currency from uf_tr_ocfreight where requestid='"+requestid+"' and freighttype='海运费'";
			 List list3 = baseJdbcDao.getJdbcTemplate().queryForList(sql3);
			 String strs = "";
			 if (list3.size() > 0 && list1.size() > 0) {
				Map map003 = (Map) list1.get(0);
				String cabtype1 = StringHelper.null2String(map003.get("cabtype"));//柜型
			 	for(int i = 0;i < list3.size();i++){
					Map map001 = (Map) list3.get(i);
					String freighttype = StringHelper.null2String(map001.get("freighttype"));
					String notaxprice = StringHelper.null2String(map001.get("notaxprice"));
					String currency = StringHelper.null2String(map001.get("currency"));
					if(strs!=""){
						strs += "<br />" + freighttype + currency+ notaxprice + "/" + cabtype1;
					}else{
						strs = freighttype +" "+ currency+ notaxprice + "/" + cabtype1;
					}
			 	}
			 }
			 if ( !"".equals(strs) ) {
					strs += "<br />" ;
			}
			 if ( "40285a9049a231e70149a2b184c30ade".equals(destfee) ){	//承担				
				strs += "目的港费用 承担 ";
				if (!"".equals(feeproj) ) {
					String [] stringArr= feeproj.split(",");
					for ( int i = 0;i < stringArr.length;i++ ) {
						strs += ds.getValue("select costname from uf_tr_fymcwhd where requestid='"+stringArr[i]+"'") + " " ; //费用名称
					}
				}
			 } else if ( "40285a9049a231e70149a2b184c30adf".equals(destfee) ){	//不承担
				strs += "目的港费用 不承担";
			 }
			 %>
			<td align="left" ><SPAN class="STYLE3">单柜海运费：<SPAN></td>
			<td align="left" style="width:300px"><SPAN class="STYLE3">提单要求：<SPAN>
		</tr>
		<tr>
			<td align="left" style="width:300px;border-top:0px solid black;"><SPAN class="STYLE3"><%=strs %><SPAN></td>
			<td align="left" style="width:300px;border-top:0px solid black;">
				<SPAN id="tdtxt" class="STYLE3">提单形式：<%=selectname %>&nbsp;，</SPAN><SPAN id="radiobutton4"><input type="radio" name="radiobutton4" value="海运提单" />海运提单&nbsp;<input type="radio" name="radiobutton4" value="货代提单" />货代提单</SPAN></td>
			</td>
		</tr>
		<tr>
			<td colspan="2"><SPAN class="STYLE3">特殊要求：<SPAN><br /> <textarea
					style="overflow-y:hidden;width:98%;height:50px;border: 0px;font-size:12px/0.75em;"><%=deliremark %></textarea>
			</td>
		</tr>
		<tr>
			<td  align="left"><SPAN class="STYLE3">免箱期：<%=freedate %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;免堆期：<%=freestack %><SPAN></td>
			<td ></td>
		</tr>
		<tr>
			<td colspan="2" align="left"><SPAN class="STYLE3">备注：1.请提供清洁干燥，无油污、破洞，不渗水、生锈之柜况良好之柜子。<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.请提供符合及超过PAS ISO 17712标准的高安全系数封条。<br />
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3.货柜请放在平板车的后部，以便装箱。<br />
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4.所开发票请注明此委托书编号。<SPAN>
			</td>
		</tr>
		<!--tr>
			<td colspan="2" align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.请提供符合及超过PAS
				ISO 17712标准的高安全系数封条</td>
		</tr>
		<tr>
			<td colspan="2" align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3.货柜请放在平板车的后部，以便装箱。</td>
		</tr>
		<tr>
			<td colspan="2" align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4.所开发票请注明此委托书编号
			</td>
		</tr-->
		<tr align="left" >
			<td rowspan="2" valign="top"><SPAN class="STYLE3">确认回签：<SPAN></td>
			<td valign="center"><SPAN class="STYLE3">委托人：<%=lastname %><SPAN></td>
		</tr>
		<tr>
			<td align="left" style="border-top:0px solid black;" valign="center" ><SPAN class="STYLE3">委托日期：<%=DateHelper.getCurrentDate()%><SPAN></td>
		</tr>
		<tr>
			<td colspan="2" align="left"><SPAN class="STYLE3">FAX:0512-52645556<SPAN></td>
		</tr>
	</table>
	</body>
</html>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              