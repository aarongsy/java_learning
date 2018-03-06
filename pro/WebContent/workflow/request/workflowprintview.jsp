<%@ page contentType="text/html; charset=UTF-8"%>

<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.document.isignaturehtml.ISignatureHTML"%>
<%@page import="com.eweaver.base.setitem.model.Setitem"%>
<%

SetitemService setitemService=(SetitemService)BaseContext.getBean("setitemService");
String opType=request.getParameter("opType");
String portrait=request.getParameter("printdirection");
String header=request.getParameter("header");
if(header==null)
header="";
String footer=request.getParameter("footer");
if(footer==null)footer="&b&p/&P";
String zoom1=request.getParameter("zoom");
double zoom=1.0;
if(zoom1==null||zoom1.length()<1)zoom=1.0;
else
zoom=Double.valueOf(zoom1);
String pagedialog=request.getParameter("pagedialog");
String printdialog=request.getParameter("printdialog");

boolean isPageDialog=false;
boolean isPrtDialog=true;
if(printdialog==null)isPrtDialog=false;
if(pagedialog!=null)isPrtDialog=true;
String leftsize=request.getParameter("leftsize");
String rightsize=request.getParameter("rightsize");
Double leftMg=null;
Double topMg=null;
Double rightMg=null;
Double bottomMg=null;
if(leftsize!=null&&leftsize.length()>0)leftMg=Double.valueOf(leftsize);
if(rightsize!=null&&rightsize.length()>0)rightMg=Double.valueOf(rightsize);
int pageRort=0;
boolean isUseScriptX=true;
boolean portraitbool=true;
if(portrait!=null&&portrait.equals("0"))
	portraitbool=false;

String requestid = StringHelper.null2String(request.getParameter("requestid")).trim();
Setitem setitem=setitemService.getSetitem("402883303c289b29013c289b2ff70000");
boolean showHtmlSignature=false;
if(setitem!=null){
	String useHtmlSignature=StringHelper.null2String(setitem.getItemvalue(),"0");
	if(requestid.length()>0&&"1".equals(useHtmlSignature)){
		String sql="select count(*) num from HtmlSignature where documentid='"+requestid+"'";
		BaseJdbcDao baseJdbcDao=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		Map map=baseJdbcDao.executeForMap(sql);
		int num=NumberHelper.getIntegerValue(map.get("num"));
		if(num>0){
			showHtmlSignature=true;
		}
	}
}

String mServerName="/ServiceAction/com.eweaver.workflow.request.servlet.HtmlSignatureAction";
String mServerUrl="http://"+request.getServerName()+":"+request.getServerPort()+mServerName;
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=labelService.getLabelNameByKeyId("402883d934c121e20134c121e35a0000") %><!-- 打印预览 --></title>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script src='/dwr/interface/DataService.js'></script>

<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js"></script>
<script type='text/javascript' src='/js/iSignatureHtml.js'></script>
</head>
  <script language="javascript">
   //是否使用scriptX控件。
   var isUseScriptX=<%=isUseScriptX%>;
   var origHeader="";
   var origFooter="";
   var origPortrait=0;
   var origLeftMargin=0;
   var origTopMargin=0;
   var origRightMargin=0;
   var origBottomMargin=0;
   var isChgSettings=false;
   
   function showHtmlSignature(){
	<%if(showHtmlSignature){%>
		ShowSignatureByDocumentID('<%=requestid%>');
		var mLength=document.getElementsByName("iHtmlSignature").length; 
		for (var i=0;i<=mLength-1;i++){
			var vItem=document.getElementsByName("iHtmlSignature")[i];
			vItem.DrawSignatureEx(0);
			vItem.MovePositionToNoSave((i+1)*150,100);
		}
	<%}%>
   }

   /**
    * 页面加载完.<br />
    */
   function onloadPrt()
   {
     doPrint('<%=opType!=null && opType.equals("preview")?"preview":"print"%>');
   }
   
   /**
    * 报表打印。<br />
    * @param opType 操作类型，preview-预览,print-打印。<br />
    */
   function doPrint(opType)
   {
	 var repContent="";
	 if(opType=="preview")
       repContent=opener.document.getElementById("repContainer").innerHTML;
	 else
	   repContent=parent.document.getElementById("repContainer").innerHTML;
     document.getElementById("repContainer").innerHTML=repContent;
	 opener.close();
     chgBgColor();
			var timeout=0;
     if(repContent.indexOf("application/x-shockwave-flash")!=-1)//flash图表，需要显示完才能打印
	   timeout=3000;
     if( isUseScriptX)
     {
       try
       {
         setTimeout("doPrintWithScriptX('"+opType+"')",timeout);
       }
       catch(e)
       {
         setTimeout("doPrintWithNormal('"+opType+"')",timeout);
       }
     }
     else
       setTimeout("doPrintWithNormal('"+opType+"')",timeout);
   }

   /**
    * 普通打印报表。<br />
    * @param opType 操作类型，preview-预览,print-打印。<br />
    */
   function doPrintWithNormal(opType)
   {
     if(opType=="preview")
     {
       alert("<%=labelService.getLabelNameByKeyId("402883d934c1237c0134c1237cec0000") %>");//当前环境不支持打印预览!
       window.close();
       return;
     }
     window.print();
   }

   /**
    * 利用scriptX控件打印报表。<br />
    * @param opType 操作类型，preview-预览,print-打印。<br />
    */
   function doPrintWithScriptX(opType)
   {        
     var isPreview=false;
     if(opType=="preview")
     {	   
       this.moveTo(0,0);
       this.resizeTo(this.screen.width,this.screen.height);       
       isPreview=true;
     }
     if(!factory.object)
     {
       if(isPreview)
       {
         alert("<%=labelService.getLabelNameByKeyId("402883d934c126cb0134c126cc0a0000") %>");//ScriptX控件没有成功加载! 无法打印预览!
         return;
       }
       doPrintWithNormal(opType);
       return;
     }
     var units=1;
     try
     {
       units=factory.printing.GetMarginMeasure();//该方法目前版本scriptX能够用。
     }
     catch(e)
     {
       if(factory.printing.bottomMargin<3)
         units=2;
     }
     origHeader=factory.printing.header;
     origFooter=factory.printing.footer;
     origPortrait=factory.printing.portrait;
     origLeftMargin=factory.printing.leftMargin;
     origTopMargin=factory.printing.topMargin;
     origRightMargin=factory.printing.rightMargin;
     origBottomMargin=factory.printing.bottomMargin;
     isChgSettings=true;
     <%
     if(leftMg!=null)
     {
     %>
       var leftMargin=<%=leftMg%>;
       if(units==2)
         leftMargin=leftMargin/25.4;
       factory.printing.leftMargin=leftMargin;
     <%
     }
     if(topMg!=null)
     {
     %>
       var topMargin=<%=topMg%>;
       if(units==2)
         topMargin=topMargin/25.4;
       factory.printing.topMargin=topMargin;
     <%
     }
     if(rightMg!=null)
     {
     %>
       var rightMargin=<%=rightMg%>;
       if(units==2)
         rightMargin=rightMargin/25.4;
       factory.printing.rightMargin=rightMargin;
    <%
     }
     if(bottomMg!=null)
     {
     %>
       var bottomMargin=<%=bottomMg%>;
       if(units==2)
         bottomMargin=bottomMargin/25.4;
       factory.printing.bottomMargin=bottomMargin;
     <%}%>
     factory.printing.portrait = <%=portraitbool%>;
     factory.printing.header = "<%=header%>";
     factory.printing.footer = "<%=footer%>";
     var zoom=null;
     /*if(isPreview)
       zoom=self.opener.document.formExport.prtZoom.value;
     else
       zoom=parent.document.formExport.prtZoom.value;
     if(zoom!=null && zoom.length>0)
       document.getElementById("repContainer").style.zoom=zoom;*/
     if(isPreview)
     {       
       try
       {
         factory.printing.preview();
       }
       catch(e)
       {
         alert("<%=labelService.getLabelNameByKeyId("402883d934c12ab50134c12ab5cb0000") %>"+e.description);//无法打印预览，可能IE版本过低，错误信息为
       }       
       //restore();//不要加这句
	   if(window.name=="previewRep")
         window.close();
     }
     else
     {       
       try
       {
       <%if(isPageDialog)
         {%>
           factory.PageSetup();
       <%}%>
         factory.printing.print(<%=isPrtDialog%>);
	     alert("<%=labelService.getLabelNameByKeyId("402883d934c12c4b0134c12c4c0f0000") %>");//打印成功！
       }
       catch(e)
       {
         alert("<%=labelService.getLabelNameByKeyId("402883d934c12de50134c12de67e0000") %>"+e.description);//打印失败.错误信息为：
       }
       restore();
     }  
   }

   /**
    * 将列表式报表背景色改成白色，因为有的浏览器可能设为打印背景色。
    */
   function chgBgColor()
   {
     var tblObjArr=this.document.getElementsByTagName("table");
     if(tblObjArr==null)
       return;
     for(var i=0;i<tblObjArr.length;i++)
     {
       var trNum=tblObjArr[i].rows.length;
       for(var j=0;j<trNum;j++)
       {
         var trObj=tblObjArr[i].rows[j];
         trObj.style.backgroundColor="#FFFFFF";
       }
     }
   }

   /**
    * 鼠标移到对象时改变背景色，重载report.js中函数，因打印页不能有背景色.
    * @param obj 对象,如tr,td.
    */
   function listMouseOver(obj)
   {
     obj.style.backgroundColor="#FFFFFF";
   }

   /**
    * 鼠标移出对象时恢复颜色，重载report.js中函数，因打印页不能有背景色.
    * @param obj 对象，如tr,td.
    * @param flag 0-偶行，1-奇行.
    */
   function listMouseOut(obj,flag)
   {
     obj.style.backgroundColor="#FFFFFF";
   }
   
   /**
    * 窗口关闭时执行。
    */
   function restore()
   {    
     if(isUseScriptX && isChgSettings)
     {
       factory.printing.header=origHeader;
       factory.printing.footer=origFooter;
       factory.printing.portrait=origPortrait;
       factory.printing.leftMargin=origLeftMargin;
       factory.printing.topMargin=origTopMargin;
       factory.printing.rightMargin=origRightMargin;
       factory.printing.bottomMargin=origBottomMargin;
     }
   }

  </script>
</head>

<body onload="javascript:showHtmlSignature();onloadPrt();" onunload="javascript:restore();">

<%if(showHtmlSignature){%>
<OBJECT id="SignatureControl"  classid="<%=ISignatureHTML.clsid%>" codebase="<%=ISignatureHTML.codebase%>" width=0 height=0 VIEWASTEXT>
<param name="ServiceUrl" value="<%=mServerUrl%>"><!--读去数据库相关信息-->
<param name="DocumentID" value="<%=requestid%>">
<param name="WebAutoSign" value="0">        <!--是否自动数字签名(0:不启用，1:启用)-->
<param name="PrintControlType" value="2">   <!--打印控制方式（0:不控制  1：签章服务器控制  2：开发商控制）-->
<param name="MenuDigitalCert" value=false>	<!--菜单数字签名-->
<param name="MenuDocLocked" value=false>	<!--菜单文档锁定-->
<param name="MenuAbout" value=false>		<!--菜单版本信息-->
<param name="MenuDeleteSign" value=false>   <!--菜单撤消签章-->
<param name="MenuDocVerify" value=true>    <!--菜单验证文档-->
</OBJECT>
<%}%>

<div style="zoom:<%=zoom%>" id="repContainer">
</div>
<%
if(isUseScriptX)
{
%>
<object id="factory" viewastext style="display:none"
classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814"
  codebase="/app/ActiveX/smsx.cab#Version=6,3,435,20">
</object>
<!-- MeadCo ScriptX Control -->
<!--<object id="factory" style="display:none" viewastext classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/app/ActiveX/ScriptX.cab#Version=6,2,433,14"></object> -->
<%
}
%>
</body>
</html>


