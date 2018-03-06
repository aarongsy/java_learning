<%@ page contentType="text/html; charset=UTF-8"%>

<%@ include file="/base/init.jsp"%>
<%

String opType=request.getParameter("opType");
String portrait=request.getParameter("portrait");
String header="";
String footer="&b&p/&P";
boolean isPageDialog=false;
boolean isPrtDialog=true;
Double leftMg=null;
Double topMg=null;
Double rightMg=null;
Double bottomMg=null;
double zoom=1.0;
int pageRort=0;
boolean isUseScriptX=true;
boolean portraitbool=true;
if(portrait!=null&&portrait.equals("false"))
	portraitbool=false;

%>
<style>
ul li ol{margin-left:10px;}
table{width:auto;}
.x-window-footer table,.x-toolbar table{width:auto;}
</style>
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
       repContent=opener.document.getElementById("ext-comp-1003").innerHTML;
	 else
	   repContent=parent.document.getElementById("ext-comp-1003").innerHTML;	 
     document.getElementById("ext-comp-1003").innerHTML=repContent;
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
       alert("<%=labelService.getLabelNameByKeyId("402883d934c1237c0134c1237cec0000") %>");//当前环境不支持打印预览
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
         alert("<%=labelService.getLabelNameByKeyId("402883d934c126cb0134c126cc0a0000") %>");//ScriptX控件没有成功加载! 无法打印预览！
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
       document.getElementById("ext-comp-1003").style.zoom=zoom;*/
     if(isPreview)
     {       
       try
       {
         factory.printing.preview();
       }
       catch(e)
       {
         alert("<%=labelService.getLabelNameByKeyId("402883d934c12ab50134c12ab5cb0000") %>"+e.description);//无法打印预览，可能IE版本过低，错误信息为:
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

<body class="printRep" onload="javascript:onloadPrt();" onunload="javascript:restore();">
<div style="zoom:<%=zoom%>" id="ext-comp-1003">
</div>
<%
if(isUseScriptX)
{
%>
<!-- MeadCo ScriptX Control -->
<object id="factory" style="display:none" viewastext classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/app/ActiveX/ScriptX.cab#Version=6,2,433,14"></object>
<%
}
%>
</body>


