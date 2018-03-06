<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.util.*"%>
<%@ page import="com.eweaver.base.*"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.app.trade.servlet.doexecuteSQL" %>


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
<!--script type="text/javascript" src="/js/ext/ext-all.js"></script-->
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
		setPrintDate();	
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
		zywpm();
		PageSetup_Null();
		//隐藏打印按钮和打印预览按钮
		jQuery("#print").css("display","none");
		jQuery("#printforview").css("display","none");
		jQuery("#auditid").css("display","none");
		jQuery("#inauditid").css("display","none");
		jQuery("#savefile").css("display","none");
	
		//打印
		WebBrowser.ExecWB(6,1);

	}
}
//打印预览
function printforview(){
	if(beforeprint("radiobutton","运费","yftxt") && beforeprint("radiobutton1","是否可以转运","zytxt")  && beforeprint("radiobutton2","拖车安排","tctxt")  && beforeprint("radiobutton4","提单要求","tdtxt")  ){
		setPrintDate();	
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
		zywpm();
		PageSetup_Null();
		//隐藏打印按钮和打印预览按钮
		jQuery("#print").css("display","none");
		jQuery("#printforview").css("display","none");
		jQuery("#auditid").css("display","none");
		jQuery("#inauditid").css("display","none");
		jQuery("#savefile").css("display","none");
			
		//打印
		WebBrowser.ExecWB(7,1);

		
	}
}

function setPrintDate(){
	var requestid = document.getElementById("requestid").value;
	var printman = document.getElementById("currentuserid").value;	
	var sql = "update uf_tr_ckwts set printdate=to_char(sysdate,'YYYY-MM-DD'),printpsn='"+printman+"' where requestid='"+requestid+"'";
	doSQL("update","",sql,"",requestid);
}


function zywpm(){
	var $ = jQuery;
	var zywpm = document.getElementById('zywpm');
	var zywpmnr = $("#zywpm").html();
	zywpmnr = zywpmnr.replace(/\n|\r|(\r\n)|(\u0085)|(\u2028)|(\u2029)/g,"</div><div style=\"border: 0px currentColor; border-image: none; width: 100%; height: auto; line-height:18px;font-size:12px/0.75em;font-family: 'Arial','SimSun','Microsoft YaHei';text-align:left;\">");
	$("#zywpm").hide();
	$("#zywpm").parent().append("<div style=\"border: 0px currentColor; border-image: none; width: 100%; height: auto; line-height:18px;font-size:12px/0.75em;font-family: 'Arial','SimSun','Microsoft YaHei';text-align:left;\">"+zywpmnr+"</div>");
	
	var shipmark = document.getElementById('shipmark');
	var shipmarknr = $("#shipmark").html();
	shipmarknr = shipmarknr.replace(/\n|\r|(\r\n)|(\u0085)|(\u2028)|(\u2029)/g,"</div><div style=\"border: 0px currentColor; border-image: none; width: 100%; height: auto; line-height:18px;font-size:12px/0.75em;font-family: 'Arial','SimSun','Microsoft YaHei';text-align:left;\">");
	$("#shipmark").hide();
	$("#shipmark").parent().append("<div style=\"border: 0px currentColor; border-image: none; width: 100%; height: auto; line-height:18px;font-size:12px/0.75em;font-family: 'Arial','SimSun','Microsoft YaHei';text-align:left;\">"+shipmarknr+"</div>");
	
	var consigneeid = document.getElementById('consigneeid');
	var consigneeidnr = $("#consigneeid").html();
	consigneeidnr = consigneeidnr.replace(/\n|\r|(\r\n)|(\u0085)|(\u2028)|(\u2029)/g,"</div><div style=\"border: 0px currentColor; border-image: none; width: 100%; height: auto; line-height:18px;font-size:12px/0.75em;font-family: 'Arial','SimSun','Microsoft YaHei';text-align:left;\">");
	$("#consigneeid").hide();
	$("#consigneeid").parent().append("<div style=\"border: 0px currentColor; border-image: none; width: 100%; height: auto; line-height:18px;font-size:12px/0.75em;font-family: 'Arial','SimSun','Microsoft YaHei';text-align:left;\">"+consigneeidnr+"</div>");	
	
	var notifypartyid = document.getElementById('notifypartyid');
	var notifypartyidnr = $("#notifypartyid").html();
	notifypartyidnr = notifypartyidnr.replace(/\n|\r|(\r\n)|(\u0085)|(\u2028)|(\u2029)/g,"</div><div style=\"border: 0px currentColor; border-image: none; width: 100%; height: auto; line-height:18px;font-size:12px/0.75em;font-family: 'Arial','SimSun','Microsoft YaHei';text-align:left;\">");
	$("#notifypartyid").hide();
	$("#notifypartyid").parent().append("<div style=\"border: 0px currentColor; border-image: none; width: 100%; height: auto; line-height:18px;font-size:12px/0.75em;font-family: 'Arial','SimSun','Microsoft YaHei';text-align:left;\">"+notifypartyidnr+"</div>");	
	
	var shipperid = document.getElementById('shipperid');
	var shipperidnr = $("#shipperid").html();
	shipperidnr = shipperidnr.replace(/\n|\r|(\r\n)|(\u0085)|(\u2028)|(\u2029)/g,"</div><div style=\"border: 0px currentColor; border-image: none; width: 100%; height: auto; line-height:18px;font-size:12px/0.75em;font-family: 'Arial','SimSun','Microsoft YaHei';text-align:left;\">");
	$("#shipperid").hide();
	$("#shipperid").parent().append("<div style=\"border: 0px currentColor; border-image: none; width: 100%; height: auto; line-height:18px;font-size:12px/0.75em;font-family: 'Arial','SimSun','Microsoft YaHei';text-align:left;\">"+shipperidnr+"</div>");
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
					if(trim(document.getElementById("othyftxt").value)==""){
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
				document.getElementById('hytdid').value = v.item(i).value;
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
	var packobj = document.getElementById("packid");
	var pack = document.getElementById("packid").value;
	var packtype = packobj.options[packobj.selectedIndex].text;

	//document.getElementById("packtxt").innerText = "        "+pack;
	document.getElementById("packtxt").value = "                     "+pack;
	document.getElementById("packtypetxt").value  = packtype;
}

function format(num) { 
    return (num+'').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,'); 
} 


function zcsavefile(){	
	if(beforeprint("radiobutton","运费","yftxt") && beforeprint("radiobutton1","是否可以转运","zytxt")  && beforeprint("radiobutton2","拖车安排","tctxt")  && beforeprint("radiobutton4","提单要求","tdtxt")  ){
		if(confirm('暂存修改！')){
			var requestid = document.getElementById("requestid").value;
			
			var shipper = document.getElementById('shipperid').value;
			var consignee = document.getElementById('consigneeid').value;
			var notifyparty = document.getElementById('notifypartyid').value;
			var shipping = document.getElementById('shipmark').value;
			var notifyparty2 = document.getElementById('zywpm').value;
			var yunfei = document.getElementById('yftxt').innerText;
			var shipcom = document.getElementById('shipcomid').value;
			var deadline = document.getElementById('deadlineid').value;
			var leavedate = document.getElementById('leavedateid').value;
			var iszy = document.getElementById('zytxt').innerText;
			var cararr = document.getElementById('tctxt').innerText;
			var packtotal = document.getElementById("packtxt").value;
			var temperature = document.getElementById("temperatureid").value;
			var ladtype = document.getElementById('hytdid').value;
			var speneed = document.getElementById("speneedid").value;
			var packtype = document.getElementById("packtypetxt").value;
			var sql = "update uf_tr_ckwts set  shipper='"+shipper+"',consignee='"+consignee+"',notifyparty='"+notifyparty+"',shipping='"+shipping+"',notifyparty2='"+notifyparty2+"',yunfei='"+yunfei+"',shipcom='"+shipcom+"',deadline='"+deadline+"',leavedate='"+leavedate+"',iszy='"+iszy+"',cararr='"+cararr+"',packtotal='"+packtotal+"',temperature='"+temperature+"',ladtype='"+ladtype+"',speneed='"+speneed+"',packtype='"+packtype+"',checkman='',checkdate='',chkstatus='暂存'  where requestid='"+requestid+"'";
			doSQL("update","",sql,"",requestid);
			alert('修改暂存OK!');
			window.location.reload();

		}
	}	
}

function savefile(){	
	if(beforeprint("radiobutton","运费","yftxt") && beforeprint("radiobutton1","是否可以转运","zytxt")  && beforeprint("radiobutton2","拖车安排","tctxt")  && beforeprint("radiobutton4","提单要求","tdtxt")  ){
		if(confirm('修改确认！')){
			var requestid = document.getElementById("requestid").value;
			
			var shipper = document.getElementById('shipperid').value;
			var consignee = document.getElementById('consigneeid').value;
			var notifyparty = document.getElementById('notifypartyid').value;
			var shipping = document.getElementById('shipmark').value;
			var notifyparty2 = document.getElementById('zywpm').value;
			var yunfei = document.getElementById('yftxt').innerText;
			var shipcom = document.getElementById('shipcomid').value;
			var deadline = document.getElementById('deadlineid').value;
			var leavedate = document.getElementById('leavedateid').value;
			var iszy = document.getElementById('zytxt').innerText;
			var cararr = document.getElementById('tctxt').innerText;
			var packtotal = document.getElementById("packtxt").value;
			var temperature = document.getElementById("temperatureid").value;
			var ladtype = document.getElementById('hytdid').value;
			var speneed = document.getElementById("speneedid").value;
			var packtype = document.getElementById("packtypetxt").value;
			var sql = "update uf_tr_ckwts set  shipper='"+shipper+"',consignee='"+consignee+"',notifyparty='"+notifyparty+"',shipping='"+shipping+"',notifyparty2='"+notifyparty2+"',yunfei='"+yunfei+"',shipcom='"+shipcom+"',deadline='"+deadline+"',leavedate='"+leavedate+"',iszy='"+iszy+"',cararr='"+cararr+"',packtotal='"+packtotal+"',temperature='"+temperature+"',ladtype='"+ladtype+"',speneed='"+speneed+"',packtype='"+packtype+"',checkman='',checkdate='',chkstatus='确认'  where requestid='"+requestid+"'";
			doSQL("update","",sql,"",requestid);
			alert('修改确认OK!');
			window.location.reload();

		}
	}	
}


function doSQL(action,roleid,sql,flag,requestid)
{
	loadXMLDoc(action,roleid,sql,flag,requestid);
}

function loadXMLDoc(action,roleid,sql,flag,requestid)
{
	var xmlhttp;
    if(window.XMLHttpRequest)  
    {   
        //DOM 2浏览器   
        xmlhttp = new XMLHttpRequest();  
    }  
    else if (window.ActiveXObject)  
    {  
        // IE浏览器   
        try  
        {  
            xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");  
		}  
        catch (e)  
        {  
           try  
           {  
                xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");  
           }  
           catch (e)  
           {  
				alert('CREATE XMLHttpRequest fail！');
           }  
        }  
    } 	
	
	
	xmlhttp.onreadystatechange=function()
	{
		
		if (xmlhttp.readyState==4 && xmlhttp.status==200)
		{
			if(action=="audit"){
				//alert(xmlhttp.responseText);
				jsonResult = eval('('+xmlhttp.responseText+')'); 
			
				if (jsonResult) {	
					if(jsonResult.msg){
						if(flag==1 || flag =='1'){
							alert('审核成功!');
						}else if(flag==0 || flag =='0'){
							alert('反审核成功!');
						}
						window.location.reload();

						//window.close(); 
						//window.open("/app/trade/excontact/CKWTSVIEW.jsp?requestid="+requestid,"_blank");				
					}else{						
						if(flag==1 || flag =='1'){
							alert('审核失败，请确认是否有审核权限!');
						}else if(flag==0 || flag =='0'){
							alert('反审核失败，请确认是否有审核权限!');
						}					
					}					
				}
			}			
		} 		
	}
	
	xmlhttp.open("POST","/app/trade/excontact/doExcSQL.jsp",true);
	xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
	xmlhttp.send("action="+action+"&roleid="+roleid+"&sql="+sql);
}



//审核  1:审核  0:反审核
function audit(flag){
	var requestid = document.getElementById("requestid").value;
	var checkman = document.getElementById("currentuserid").value;
	var roleid = "40285a8d53ab32090153ac485eb81c56";	//出口委托书审核角色
	var sql = "";
	if(flag==1 || flag =='1'){
		sql = "update uf_tr_ckwts set checkman='"+checkman+"',checkdate=to_char(sysdate,'YYYY-MM-DD'),printdate='',printpsn='' where requestid='"+requestid+"'";
		doSQL("audit",roleid,sql,flag,requestid);
	}else if(flag==0 || flag =='0'){
		sql = "update uf_tr_ckwts set checkman='',checkdate='',printdate='',printpsn='' where requestid='"+requestid+"'";
		doSQL("audit",roleid,sql,flag,requestid);
	}
}

function trim(str){ //删除左右两端的空格
　　return str.replace(/(^\s*)|(\s*$)/g, "");
}

</script>
</head>

<%
EweaverUser eweaveruser = BaseContext.getRemoteUser();
Humres currentuser = eweaveruser.getHumres();
String userid=currentuser.getId();//当前用户

//根据requestid来获取外销联络单相关数据
BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
DataService ds = new DataService();
//根据requestid/expno来获取出口委托书相关数据
String requestid=StringHelper.null2String(request.getParameter("requestid"));
String upsql=StringHelper.null2String(request.getParameter("upsql"));


//String expno=StringHelper.null2String(request.getParameter("expno"));
int existflag = Integer.parseInt(ds.getValue("select count(*) n from uf_tr_ckwts a,formbase b where a.requestid=b.id and b.isdelete=0 and a.requestid='"+requestid+"'"));
int auditmanflag = Integer.parseInt(ds.getValue("select count(userid) num from sysuserrolelink where roleid='40285a8d53ab32090153ac485eb81c56' and userid=(select id from sysuser where objid='"+userid+"')"));
String startdate = "";
String icon1text = "";
String icon2text = "";
String companyname = "";
String coname = "";
String comcode = "";
String comtype = "";
String reqcom = "";
String sagentname = "";
String shipper = "";
String destport = "";
String departure = "";
String consignee = "";
String notifyparty = "";
String shipping = "";
String goodsgroup = "";
String notifyparty2 = "";
String cbms = "";
String gwsum = "";
String stocktotal = "";
String xtbtotal = "";
String packtotal = "";
String packtype = "";
String llr = "";
String tel = "";
String fax = "";
String comfax = "";
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
String shipyears = "";
String outland = "";
String outcompany = "";
String transtype = "";
String reqdate = "";
String cabtype = "";
String cabtypenums = "";
String yunfei = "";
String iszy = "";
String cararr = "";
String temperature = "";
String isdagerflag = "";
String isdager  = "";
String unno = "";
String strs = "";
String ladtype = "";
String expno= "";
String checkman = "";
String checkdate = "";
String printdate = "";
String chkstatus = "";
String isotanknums= "";
	String err="";	

		String selsql = "select u1.*,h.objname reqmanname,s.objname isdagername from uf_tr_ckwts u1 left join humres h on u1.reqman = h.id left join selectitem s on s.id=u1.isdager where u1.requestid='"+requestid+"' and exists(select id from formbase where id=u1.requestid and isdelete=0)  ";
		System.out.println(" selsql: "+selsql);
		List sellist = baseJdbcDao.getJdbcTemplate().queryForList(selsql);
		if(sellist.size()>0){ 
			System.out.println(" sellist.size(): "+sellist.size());
			Map selmap = (Map)sellist.get(0);
			//String reqid = StringHelper.null2String(selmap.get("requestid"));
			expno=StringHelper.null2String(selmap.get("expno"));//委托编号
			isotanknums  = StringHelper.null2String(ds.getValue("select count(distinct p.cabno) from uf_tr_packtype p where p.requestid=(select requestid from uf_tr_expboxmain where expno='"+expno+"' and exists(select id from requestbase where id=requestid and isdelete=0))"));
			lastname = StringHelper.null2String(selmap.get("reqmanname"));//委托人
			//String orgid = ds.getValue("select orgid from humres where ID ='"+lastname+"'");
			coname =  StringHelper.null2String(selmap.get("comname"));//公司名称
			sagentname = StringHelper.null2String(selmap.get("sagentname"));//致货代公司		
			llr =  StringHelper.null2String(selmap.get("llr"));//联络人/TEL/FAX
			shipper = StringHelper.null2String(selmap.get("shipper"));//SHIPPER
			consignee = StringHelper.null2String(selmap.get("consignee"));//CONSIGNEE		
			notifyparty = StringHelper.null2String(selmap.get("notifyparty"));//NOTIFYPARTY	
			shipping = StringHelper.null2String(selmap.get("shipping"));//唛头		
			notifyparty2 = StringHelper.null2String(selmap.get("notifyparty2"));//中英文品名		
			destport = StringHelper.null2String(selmap.get("destport"));//目的港		
			departure = StringHelper.null2String(selmap.get("departure"));//出运港
			icon1text = StringHelper.null2String(selmap.get("icon1text"));//国贸条件
			yunfei = StringHelper.null2String(selmap.get("yunfei"));//运费
			companyname = StringHelper.null2String(selmap.get("shipcom"));//船公司
			deadline = StringHelper.null2String(selmap.get("deadline"));//客户要求最晚到货日
			startdate = StringHelper.null2String(selmap.get("startdate"));//客户要求最晚到货日
			leavedate = StringHelper.null2String(selmap.get("leavedate"));//船期
			iszy = StringHelper.null2String(selmap.get("iszy"));//是否可以转运
			leavedate = StringHelper.null2String(selmap.get("leavedate"));//装箱日期
			cararr = StringHelper.null2String(selmap.get("cararr"));//拖车安排
			packtotal = StringHelper.null2String(selmap.get("packtotal"));//件数
			stocktotal = StringHelper.null2String(selmap.get("stocktotal"));//托盘数合计
			xtbtotal = StringHelper.null2String(selmap.get("xtbtotal"));//木箱数/包数/桶数合计
			packtype = StringHelper.null2String(selmap.get("packtype"));//包装类型
			gwsum = StringHelper.null2String(selmap.get("gwsum"));//毛重（公斤）
			cbms = StringHelper.null2String(selmap.get("cbms"));//体积（M3）	
			cabtype = StringHelper.null2String(selmap.get("cabtype"));//柜型	
			cabtypenums = StringHelper.null2String(selmap.get("cabtypenums"));//柜数	
			temperature = StringHelper.null2String(selmap.get("temperature"));//温度要求	
			isdagerflag = StringHelper.null2String(selmap.get("isdagername"));//是否危险品	
			System.out.println(" isdagerflag:["+isdagerflag+"]");
			isdager = StringHelper.null2String(selmap.get("dagerlv"));//CLASS
			unno = StringHelper.null2String(selmap.get("unno"));//UN NO
			strs = StringHelper.null2String(selmap.get("cabprice"));//单柜海运费
			selectname = StringHelper.null2String(selmap.get("ladway"));//提单形式
			ladtype = StringHelper.null2String(selmap.get("ladtype"));//海运代理/货运代理
			deliremark = StringHelper.null2String(selmap.get("speneed"));//特殊要求		
			freedate = StringHelper.null2String(selmap.get("freedate"));//免箱期	
			freestack = StringHelper.null2String(selmap.get("freestack"));//免堆期	
			comfax = StringHelper.null2String(selmap.get("fax"));//FAX	
			reqdate = StringHelper.null2String(selmap.get("reqdate"));//委托日期
			checkman = StringHelper.null2String(selmap.get("checkman"));//审核人
			checkdate = StringHelper.null2String(selmap.get("checkdate"));//审核日期		
			printdate = StringHelper.null2String(selmap.get("printdate"));//打印日期
			chkstatus = StringHelper.null2String(selmap.get("chkstatus"));//保存状态
		}		
%>
 
<%   
//out.print("JSP获取upsql:"+request.getParameter("upsql"));   
//out.print("JSP获取requestid:"+request.getParameter("requestid"));   
String updateSql = request.getParameter("upsql");
baseJdbcDao.update(updateSql);
%>

<body >
	<object ID='WebBrowser' WIDTH=0 HEIGHT=0 CLASSID='CLSID:8856F961-340A-11D0-A96B-00C04FD705A2'></object>
	<div>
		<div align="left"><input id="print" type=<%=(checkman.equals("")?"hidden":"button") %> value="打印" onclick="print();" /><input id="printforview" type=<%=(checkman.equals("")?"hidden":"button") %> value="打印预览" onclick="printforview();" /><input id="zcsavefile" type=<%=(checkman.equals("")?"button":"hidden") %> value="修改暂存" onclick="zcsavefile()" /><input id="zcsavefile" type=<%=(checkman.equals("")?"button":"hidden") %> value="修改确认" onclick="savefile()" /><input id="auditid" type=<%=(auditmanflag>0 && chkstatus.equals("确认") ?"button":"hidden") %> value="审核" onclick="audit(1)" /><input id="inauditid" type=<%=(auditmanflag>0 && chkstatus.equals("确认")?"button":"hidden") %> value="反审核" onclick="audit(0)" /><input type="hidden" id="currentuserid" name="currentuserid" value="<%=userid %>" /><input type="hidden" id="checkmanid" name="checkmanid" value="<%=checkman %>" /><input type="hidden" id="checkdateid" name="checkdateid" value="<%=checkdate %>" /> <input type="hidden" id="printdateid" name="printdateid" value="<%=printdate %>" /> <input type="hidden" id="chkstatusid" name="chkstatusid" value="<%=chkstatus %>" />

		</div>
	</div>

	<form method="post" id="myForm">   
	<!--form action="/app/trade/excontact/CKWTSVIEW.jsp?requestid=<%=requestid %>" method="post" id="myForm"-->   
		<input type="hidden" id="upsql" name="upsql"/>  
		<input type="hidden" id="requestid" name="requestid" value="<%=requestid %>"/>			
		<!--input type="button" name="btn" value="btn" onclick="test()" /-->
		<!--input type="hidden" id="url" name="url"value="<%=request.getRequestURL() %>?<%=request.getQueryString() %>"-->
	</form>   

	<div>
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
			<td height="31"><SPAN class="STYLE3">联络人/TEL/FAX：<%=llr%></SPAN></td>
		</tr>
		<tr>
			<td rowspan="4"  valign="top"><SPAN class="STYLE3">SHIPPER:</SPAN><br />
				<textarea id="shipperid" class="input_txt" index="1" style="overflow-y:hidden;width:100%;height:80px;border: 0px;font-size:12px/0.75em;font-family:'Arial','SimSun','Microsoft YaHei';"><%=shipper %></textarea>
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
			<td colspan="2" align="center"><SPAN id="yftxt" class="STYLE3"><%=yunfei %> </SPAN><SPAN id="radiobutton">
				<input type="radio"  <%=(yunfei.equals("PREPAID")?"checked":"") %> name="radiobutton" value="PREPAID" />PREPAID&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="radio" <%=(yunfei.equals("COLLECT")?"checked":"") %> name="radiobutton" value="COLLECT" />COLLECT&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="radio" <%=(!yunfei.equals("PREPAID") && !yunfei.equals("COLLECT") && !yunfei.equals("")?"checked":"") %> name="radiobutton" value="其他" />其他&nbsp;&nbsp;&nbsp;&nbsp;
				<input id="othyftxt" type="text" style="text-decoration:underline;border: 0px;width:150px;font-size:12px/0.75em;font-family:'Arial','SimSun','Microsoft YaHei';" type="text" value="<%=(!yunfei.equals("PREPAID") && !yunfei.equals("COLLECT") && !yunfei.equals("")?yunfei:"") %> " /></SPAN>
				</td>
			</td>
		</tr>
		<tr >
			<td rowspan="4" valign="top" ><SPAN class="STYLE3">CONSIGNEE：</SPAN><br />
				<textarea id="consigneeid" class="input_txt" index="2" style="overflow-y:hidden;width:100%;height:120px;border: 0px;font-size:12px/0.75em;font-family:'Arial','SimSun','Microsoft YaHei';"><%=consignee %></textarea>
			</td>
			<td style="border-bottom:0px solid black;"><SPAN class="STYLE3" >船公司：</SPAN></td>			
			<td style="border-bottom:0px solid black;"><SPAN class="STYLE3">客户要求最晚到货日：</SPAN></td>			
		</tr>
		<tr >
			<td valign="top" style="border-top:0px solid black;">
				<textarea valign="top" id="shipcomid" style="overflow-y:hidden;width:100%;height:45px;border: 0px;font-size:12px/0.75em;font-family:'Arial','SimSun','Microsoft YaHei'"><%=companyname %></textarea>
			</td>
			<td style="border-top:0px solid black;">
				<textarea id="deadlineid" style="overflow-y:hidden;width:100%;height:40px;border: 0px;font-size:12px/0.75em;font-family:'Arial','SimSun','Microsoft YaHei'"><%=deadline %></textarea>
			</td>
		</tr>
		<tr>
			<td style="border-bottom:0px solid black;"><SPAN class="STYLE3">船期：</SPAN></td>			
			<td style="border-bottom:0px solid black;"><SPAN class="STYLE3">装箱日期：</SPAN></td>			
		</tr>
		<tr>
			<td style="border-top:0px solid black;"><SPAN style="font-size:12px/0.75em;font-family:'Arial';"><%=startdate %></SAPN></td>
			<td style="border-top:0px solid black;"><input id="leavedateid"  align="left" style="width:150px;border: 0px;font-size:12px/0.75em;font-family:'Arial','SimSun','Microsoft YaHei';" type="text"
				value="<%=leavedate %>" />	
			</td>
		</tr>
		<tr>
			<td rowspan="4" valign="top" ><SPAN class="STYLE3">NOTIFYPARTY：</SPAN><br />
				<textarea id="notifypartyid" class="input_txt" index="3" style="overflow-y:hidden;width:100%;height:120px;border: 0px;font-size:12px/0.75em;font-family:'Arial','SimSun','Microsoft YaHei';"><%=notifyparty %></textarea>
			</td>
			<td colspan="2" align="center"><SPAN class="STYLE3">是否可以转运</SPAN></td>
		</tr>
		<tr>
			<td colspan="2" align="center"><SPAN id="zytxt" class="STYLE3"><%=iszy %></SPAN>
				<SPAN id="radiobutton1">
				<input type="radio" <%=(iszy.equals("是")?"checked":"") %>  name="radiobutton1" value="是" />是&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="radio" <%=(iszy.equals("否")?"checked":"") %>  name="radiobutton1" value="否" />否</SPAN>
				
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center"><SPAN class="STYLE3">拖车安排</SPAN></td>
		</tr>
		<tr>
			<td colspan="2" align="center" style="border-bottom:0px solid black;"><SPAN id="tctxt" style="display:block;font-size:12px/0.75em;font-family:'Arial','SimSun','Microsoft YaHei';"><%=cararr %></SPAN>
				<SPAN id="radiobutton2">
				<input type="radio" <%=(cararr.equals("派车")?"checked":"") %>  name="radiobutton2" value="派车" />派车&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="radio" <%=(cararr.equals("自送")?"checked":"") %> name="radiobutton2" value="自送" />自送</SPAN>
				
			</td>
		</tr>
		<tr>
			<td rowspan="4" valign="top" ><SPAN class="STYLE3">唛头：</SPAN><br />
				<textarea id="shipmark" class="input_txt" index="3" style="overflow-y:hidden;width:100%;height:140px;border: 0px;font-size:12px/0.75em;font-family:'Arial','SimSun','Microsoft YaHei';"><%=shipping %></textarea>
			</td>
			<td rowspan="4" colspan="2" valign="top" ><SPAN class="STYLE3">中英文品名：</SPAN><br />
				<textarea id="zywpm" class="input_txt" index="3" style="overflow-y:hidden;width:100%;height:140px;border: 0px;font-size:12px/0.75em;font-family:'Arial','SimSun','Microsoft YaHei';"><%=notifyparty2 %></textarea>
			</td>
		</tr>
	</table>
	<table width="100%%" border="1" align="center" cellpadding="0" cellspacing="0" class="detail" style="border-bottom:0px solid black;border-right:0px solid black;border-top:0px solid black;">
	<TBODY>
		<tr>
			<td width="30%" align="center" style="border-top:0px solid black;"><SPAN class="STYLE3">件数</SPAN></td>
			<td width="30%" align="center" style="border-top:0px solid black;"><SPAN class="STYLE3">毛重(公斤)</SPAN></td>
			<td width="30%" align="center" style="border-top:0px solid black;"><SPAN class="STYLE3">体积(M3)</SPAN></td>
		</tr>
		<tr>
			<td style="border-bottom:0px solid black;" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input align="center" id="packtxt" style="width:100%;border: 0px;font-size:12px/0.75em;font-family: font-family:'Arial','SimSun','Microsoft YaHei';"  type="text" value="<%=packtotal %>" /><input align="center" id="packtypetxt" style="width:100%;border: 0px;font-size:12px/0.75em;font-family: font-family:'Arial','SimSun','Microsoft YaHei';"  type="text" value="<%=packtype %>" />
				<select id="packid" name="select" style="width:100%;height30px;font-size=24px;font-family:font-family:'Arial','SimSun','Microsoft YaHei';" onchange="chgpack();">
					<option value="<%=xtbtotal %> 包" <%=(packtype.equals("包")?"selected":"")%>  >包</option>
					<option value="<%=xtbtotal %> 桶" <%=(packtype.equals("桶")?"selected":"")%> >桶</option>
					<option value="<%=xtbtotal %> 木箱" <%=(packtype.equals("木箱")?"selected":"")%> >木箱</option>
					<option value="<%=isotanknums %> ISO-TANK" <%=(packtype.equals("ISO-TANK")?"selected":"")%> >ISO-TANK</option>
					<option value="<%=xtbtotal %> 散货船" <%=(packtype.equals("散货船")?"selected":"")%> >散货船</option>
					<option value="<%=stocktotal %> 托盘" <%=(packtype.equals("托盘")?"selected":"")%> >托盘</option>
					<option value="<%=xtbtotal %> PACKAGE" <%=(packtype.equals("PACKAGE")?"selected":"")%> >PACKAGE</option>
					<option value="<%=xtbtotal %> IN BULK" <%=(packtype.equals("IN BULK")?"selected":"")%> >IN BULK</option>
				</select>						
			</td>
			<td style="border-bottom:0px solid black;" align="center"><SPAN class="STYLE3" id="mwid"><%=gwsum %><SPAN></td>
			<td style="border-bottom:0px solid black;" align="center"><SPAN class="STYLE3"><%=cbms %><SPAN></td>
		</tr>
	</TBODY>
	</table>

	<table width="100%%" border="1" align="center" cellpadding="0" cellspacing="0" class="footer" style="border-right:0px solid black;">
		<tr>
			<td colspan="2" align="center" style="border-top:0px solid black;"><SPAN class="STYLE3">集装箱箱类<SPAN></td>
		</tr>
		<tr>
			<td width="51%" align="left"><SPAN class="STYLE3">柜型：<%=cabtype %><SPAN></td>
			<td width="49%" align="left"><SPAN class="STYLE3">若为冷冻\冷藏箱，温度要求 
			<input id="temperatureid" style="width:30px;border: 0px;font-size:12px/0.75em;" type="text" value=<%=temperature %> />℃<SPAN></td>
		</tr>
		<tr>
			<td colspan="2" align="left"><SPAN class="STYLE3">柜数：<%=cabtypenums %><SPAN></td>
		</tr>
		<tr>
			<td colspan="2" align="center"><SPAN class="STYLE3">是否为危险品<SPAN></td>
		</tr>
		<tr>
			<td align="center">
				<input type="radio" <%=(isdagerflag.equals("是")?"checked":"") %> name="radiobutton3" value="是" />是&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
				<input type="radio" <%=(isdagerflag.equals("否")?"checked":"") %> name="radiobutton3" value="否" />否
			</td>
			<td align="left"><SPAN class="STYLE3">（CLASS：<%=isdager %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; UN NO： <%=unno %>）<SPAN></td>
		</tr>
		<tr>
			<td align="left" ><SPAN class="STYLE3">单柜海运费：<SPAN></td>
			<td rowspan="2" align="left" >
				<SPAN id="tdtxt" class="STYLE3">提单形式：<%=selectname %>&nbsp;，</SPAN><SPAN id="radiobutton4">
				<input type="hidden" id="hytdid" value="" />
				<input type="radio"  <%=(ladtype.equals("海运提单")?"checked":"")%> name="radiobutton4" value="海运提单" />海运提单&nbsp;
				<input type="radio"  <%=(ladtype.equals("货代提单")?"checked":"")%> name="radiobutton4" value="货代提单" />货代提单</SPAN></td>
			</td>
		</tr>
		<tr>
			<td align="left" style="width:300px;border-top:0px solid black;"><SPAN class="STYLE3"><%=strs %><SPAN></td>
		</tr>
		<tr>
			<td colspan="2"><SPAN class="STYLE3">特殊要求：<SPAN><br /> <textarea id="speneedid"
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
		<tr align="left" >
			<td rowspan="2" valign="top"><SPAN class="STYLE3">确认回签：<SPAN></td>
			<td valign="center"><SPAN class="STYLE3">委托人：<%=lastname %><SPAN></td>
		</tr>
		<tr>
			<td align="left" style="border-top:0px solid black;" valign="center" ><SPAN class="STYLE3">委托日期：<%=DateHelper.getCurrentDate()%><SPAN></td>
		</tr>
		<tr>
			<td colspan="2" align="left"><SPAN class="STYLE3">FAX:<%=comfax %><SPAN></td>
		</tr>
	</table>
	</body>
</html>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            