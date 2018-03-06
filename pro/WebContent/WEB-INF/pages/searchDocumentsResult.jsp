<%@ page language="java" import="java.util.*" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<html><head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=request.getContextPath() %>/css/eweaver.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="<%=request.getContextPath() %>/js/weaverUtil.js"></script>
<script language="javascript" src="<%=request.getContextPath() %>/js/main.js"></script>
    <style type="text/css">
    	body{}
		.search{width:100%;padding:2px;}
		.searchInfo{background-color:#D9E1F7;height:20px;margin-bottom:12px;margin-top:5px;}
		.result{PADDING-LEFT: 15px; FONT-SIZE: 10pt;WORD-BREAK: break-all; LINE-HEIGHT: 120%; WORD-WRAP: break-word;}
		/** {font-size:10pt;margin:0px auto;} .f **/

		.result div{text-indent:20px;}
		.result b{color:#CC0000;}
		.result span{text-indent:0px;/*background-color:#DDDDDD;*/}
		.TotopSpace{padding-top:15px}
    </style>
    <script language="javascript">
//	    var p=<c:out value="${pageInfo}" escapeXml="false"/>;
	    var param='key='+encodeURIComponent('<c:out value="${key}"/>');
		var page=<c:out value="${page}"/>;
		var isLastPage=<c:out value="${isLastPage}"/>;
		var isNoResult='<c:out value="${isNoResult}"/>';
	    function getU(){
	    	return "<%=request.getContextPath()%>/ServiceAction/com.eweaver.search.servlet.SearchDocumentAction";
	    }
		function searchText(){//��������
			var key=document.getElementById("key").value;
			if(key==""){
				window.alert('关键字不能为空!');
			}else document.getElementById('frm1').submit();
		}
	    function initPage(){
			document.getElementById("key").focus();
		    if(!isLastPage && (isNoResult=="" || isNoResult=="true"))return;
		    var s='';
		    var getUrl=function(page,text){
		    	return "<a href='"+getU()+"?"+param+"&page="+page+"'>"+text+"</a>";
		    }

			var getPages=function(){
				var t='',t1;
				for(var i=1;i<=page;i++){
					t1="["+i+"]";
					if(i==page){t+=t1;continue;}
					//var t1=(i==1)?'��һҳ':'['+i+']';
					t+=getUrl(i,t1)+"&nbsp;";
				}
				return t;
			}
			var lll='下一页';
			if(page==1)s+=getUrl(2,lll);
			else s+=getPages()+"&nbsp;"+((isLastPage)?"":getUrl(page+1,lll));
		    pageInfo.innerHTML=s;
	    }
    </script>

</head>
<body onLoad="initPage()">
<table width="100%" height="98%" border="1" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10"/>
<col width=""/>
<col width="10"/>
</colgroup>
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<table width="100%" class=Shadow>
<tr>
<td width="656" valign="top">
<div class="search">
	<form action="<%=request.getContextPath() %>/ServiceAction/com.eweaver.search.servlet.SearchDocumentAction" method="get" name="frm1" id="frm1">
	<table width="100%" class="ViewForm">
	<tr><td height="18" colspan="2">全文检索</td></tr>
	<tr class="Spacing"><td class="Line1" colspan="2"></td></tr>
	<tr>
	  <td>模块</td>
	<td class="Field">
	<!--<label for="searchAll"><input type="radio" name="searchType" id="searchAll" value="all" >-->全部<!--</label>-->&nbsp;
		<label for="searchDocument"><input type="radio" name="searchType" id="searchDocument" checked value="document">文档</label>&nbsp;
		<!--<label for="searchWorkflow"><input type="radio" name="searchType" id="searchWorkflow" value="workflow" >-->流程<!--</label>-->&nbsp;协作<!--</label>-->&nbsp;
		<!--<label for="searchClient"><input type="radio" name="searchType" id="searchClient" value="client" >-->客户<!--</label>-->&nbsp;
		<!--<label for="searchProject"><input type="radio" name="searchType" id="searchProject" value="project" >-->项目<!--</label>-->&nbsp;	</td>
	</tr>
	<tr><td class="Line" colSpan="2"></td></tr>
	<tr>
	  <td>关键字</td>
	  <td class="Field"><!--�ؼ���-->
	    <input class="InputStyle" id="key" name="key" type="text" value='<c:out value="${key}"/>' size="50"/>
	    <input name="btnSearch" type="button" id="btnSearch" onClick="searchText()" value="搜索"/>	  </td>
	</tr>
	<tr><td class="Line" colSpan="2"></td></tr>
	<!--
	<tr>
	<td>类型</td><td class="Field">
	<label for="docAll"><input type="radio" id="docAll" name="sdoctype" checked >全部</label>&nbsp;
		<label for="docHtml"><input type="radio" id="docHtml" name="sdoctype" >HTML文档</label>&nbsp;
		<label for="docWord"><input type="radio" id="docWord" name="sdoctype" >WORD文档</label>&nbsp;
		<label for="docExcel"><input type="radio" id="docExcel" name="sdoctype" >EXCEL文档</label>&nbsp;
		<label for="docPdf"><input type="radio" id="docPdf" name="sdoctype" >PDF文档</label>&nbsp;
	</td>
	</tr>-->
	</table>
	<!--<label for="searchCollaboration"><input type="radio" name="searchType" id="searchCollaboration" value="collaboration" >-->
	</form>
	<div class="searchInfo" align="right">
		<c:out value="${info}"/>
	</div>
	<div class="result">
		<c:out value="${result}" escapeXml="false"/>
	</div>
	<div style="width:80%;text-align:right;"><span id="pageInfo"></span></div>

<!--
<form action="" method="get" name="frm2" id="frm2">
	<table width="100%"><tr>
	  <td width="7%">-->
	  <!--�ؼ���,,,关键字-->
	  <!--</td><td width="31%" class="Field" ><input class="InputStyle" style="FONT-FAMILY: arial;FONT-SIZE:16px;width:300px;" name="key" type="text" value='<c:out value="${key}"/>' size="50"/></td><td width="62%">
	<button accesskey="S" class="btn" onClick="document.getElementById('frm2').submit();"><u>S</u>-搜索</button>
	</td></tr></table>
	</form>
-->

</div></td>
</tr>
</table>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>
</body></html>
