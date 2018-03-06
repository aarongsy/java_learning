<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%

String language="";
if(eweaveruser != null){
	language=StringHelper.null2String(eweaveruser.getSysuser().getLanguage());
}else{
	language="zh_CN";
}
String iwebversion = PropertiesHelper.getDocProps().getProperty("goldgrid.iweboffice.codebase");

System.out.println(iwebversion);
%>
<html>
<head>

<script language="javascript">

window.onload=function(){
	//<activexs>
	//<activex name="文件上传控件" clsid="CBD79B8A-7975-4DD7-AF00-7E5ED70F7485" progid="WeaverOcx.file" clsname="WeaverOcx.file" 
	//	version="version" filepath="/weaverplugin/fileupload.exe" filesize="110K" infos="用于附件上传和控制上传文件大小。" 
	//	checkpageurl="/activex/TestByFile.jsp" checkver="0" ></activex>
	//
	//</activexs>
	var xmlDoc ;
	 var xhttp ;
if(window.ActiveXObject){
	xmlDoc= new ActiveXObject("Microsoft.XMLDOM");//IE5以上
	xmlDoc.async = false;
	xmlDoc.resolveExternals = false;
	<% if("zh_CN".equals(language)){%>
     xmlDoc.load("ActiveX_CN.xml");//加载xml，中文
  <% }else{%>
     xmlDoc.load("ActiveX_EN.xml");//加载xml,英文
   <%}%>
}else{
	// code for Mozilla, Firefox, Opera, etc.
    //if (document.implementation && document.implementation.createDocument){
	             xhttp = new XMLHttpRequest();   
	            <%if("zh_CN".equals(language)){%>
                  xhttp.open("GET","ActiveX_CN.xml", false);    
               <%}else{%>
                  xhttp.open("GET","ActiveX_EN.xml", false);    //加载xml,英文
                <%}%>
	           xhttp.send("");   
	           xmlDoc = xhttp.responseXML;
       }
    var activexsRoot=xmlDoc.documentElement;//获取xml根节点
	var activeNodes=activexsRoot.childNodes;//获取根节点的子节点
	var oTable;//表
	var oTr;//行tr
	var oTd;//td
	var aProgID;//控件ProgID
	var filepath;//控件安装路径
	var filesize;//控件大小
	var activeXname;//控件名称
	var infos;//描述信息
	oTable = document.all("activeXList");
	var rownum=0;
    for(var i=0;i<activeNodes.length;i++){
    if(activeNodes[i].nodeType==1){
        rownum++;
    	//获取节点属性，如：<activex name="文件上传控件"  progid="WeaverOcx.file" clsname="WeaverOcx.file"></activex>
    	//name,progid,clsname都是节点属性。
    	//alert(activeNodes[i].attributes.getNamedItem("progid").value);//根据节点属性名称获取节点属性内容。
    	//for(var j=0;j<activeNodes[i].attributes.length;j++)	{ 
    		//alert(activeNodes[i].attributes[0].name); 
    		//alert(activeNodes[i].attributes[0].value); 
    		 try {
    			 aProgID=activeNodes[i].attributes.getNamedItem("progid").value;
    			 <%if(iwebversion.indexOf("2003")>-1&&iwebversion.indexOf("8,5,0,2")>-1){%>
    			 	 filepath='/plugin/iWebOffice2003_v8502.exe';
    			 <%}else{%>
    				 filepath=activeNodes[i].attributes.getNamedItem("filepath").value;
    			 <%}%>
    			 
    			 filesize=activeNodes[i].attributes.getNamedItem("filesize").value;
    			 activeXname=activeNodes[i].attributes.getNamedItem("name").value;	
    			 infos=activeNodes[i].attributes.getNamedItem("infos").value;
    			 //alert(infos);
    			 var ax = new ActiveXObject(aProgID);
    			 	//alert("控件--"+activeNodes[i].attributes.getNamedItem("progid").value+"---已安装");
        		 	//if(activeNodes[i].attributes[j].name=="progid"){
            		// 	alert("try");
            		// 	alert(activeNodes[i].getAttributesByName("progid"));
    				//	var ax = new ActiveXObject(activeNodes[i].attributes[j].value);
    				//	//document.getElementById("img2").src="/images/remind/check.png";
        		 	//}
        		 
     		 	//动态添加行
      		 	oTr = oTable.insertRow();

				oTd = oTr.insertCell(0);
				oTd.innerHTML = rownum;
				
              	oTd = oTr.insertCell(1);
				oTd.innerHTML =activeXname;

				oTd = oTr.insertCell(2);
				oTd.innerHTML = infos;
				
                oTd = oTr.insertCell(3);
				oTd.innerHTML =filesize;

				oTd = oTr.insertCell(4);
				oTd.innerHTML = "<img height='20'  src='/images/remind/check.png'/>";
				
                oTd = oTr.insertCell(5);
				oTd.innerHTML ="<img height='20' src='/images/remind/download_18.png'/><a href='"+filepath+"'><%= labelService.getLabelNameByKeyId("402881eb0bd74dcf010bd74fe5650002")%></a>";<!-- 下载 -->

   			} catch(e) {
   				//alert("控件--"+activeNodes[i].attributes.getNamedItem("progid").value+"---未安装");
				oTr = oTable.insertRow();

				oTd = oTr.insertCell(0);
				oTd.innerHTML = rownum;
				
              	oTd = oTr.insertCell(1);
				oTd.innerHTML =activeXname;

				oTd = oTr.insertCell(2);
				oTd.innerHTML = infos;
				
                oTd = oTr.insertCell(3);
				oTd.innerHTML =filesize;

				oTd = oTr.insertCell(4);
				oTd.innerHTML = "<img height='20'  src='/images/remind/close.png'/>";
				
                oTd = oTr.insertCell(5);
				oTd.innerHTML ="<img height='20' src='/images/remind/download_18.png'/><a href='"+filepath+"'><%= labelService.getLabelNameByKeyId("402881eb0bd74dcf010bd74fe5650002")%></a>";<!-- 下载 -->
   				//if(activeNodes[i].attributes[j].name=="progid"){
   				//	alert("catch");
   				//}
   				//document.getElementById("img2").src="/images/remind/close.png";
   			}
    	//}
    	    }  	
    }
}
</script>
<style>
.x-window-footer table,.x-toolbar table{width:auto;}
.hideleft {
	cursor: pointer;
	background: url( /images/silk/application_side_contract.gif ) center no-repeat;
}
.showleft {
	cursor: pointer;
	background: url( /images/silk/application_side_expand.gif ) center no-repeat;
}
</style>
<link rel=stylesheet type="text/css" href="/images/remind/plug.css" />
<title><%=labelService.getLabelNameByKeyId("297ec642366169c201366169c4ce0000")%></title>
</head>
<body>
<div align="center" >
<table id="activeXList" class="plug" cellspacing="0" cellpadding="0">
	<caption>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<%=labelService.getLabelNameByKeyId("297ec642366169c201366169c4ce0000")%><!-- 插件检测-->
	</caption>
        <tr class="header">
	   		<td ><%=labelService.getLabelNameByKeyId("297ec642366169c201366169c4ce0001")%> <!-- 序号 --></td>
	        <td ><%=labelService.getLabelNameByKeyId("297ec642366169c201366169c4ce0002")%><!-- 插件名称 --></td>
	        <td ><%=labelService.getLabelNameByKeyId("297ec642366169c201366169c4ce0003")%><!-- 描述 --></td>
	        <td ><%=labelService.getLabelNameByKeyId("297ec642366169c201366169c4ce0004")%><!-- 插件大小 --></td>
   			<td ><%=labelService.getLabelNameByKeyId("297ec642366169c201366169c4ce0005")%><!-- 状态 --></td>
   		    <td ><%=labelService.getLabelNameByKeyId("297ec642366169c201366169c4ce0006")%><!-- 下载并安装 --></td>
   		</tr>

</table>
</div>
</body>
</html>
