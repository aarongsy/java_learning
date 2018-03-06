<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.DataService" %>
 <%
 String loginid = StringHelper.null2String(request.getParameter("loginid"));
 String isclosed = StringHelper.null2String(request.getParameter("isclosed"));

 
 String defaultUrl="/messager/images/logo_big.jpg";
 String sysUrl="";
 String strSql="select exttextfield29 from humres h join sysuser s on h.id = s.objid where s.longonname='"+loginid+"'"; 
 DataService dataService = new DataService();
 String messagerurl = dataService.getValue(strSql);
 if(!StringHelper.isEmpty(messagerurl)){
	defaultUrl=messagerurl;
 }
 %>
<HTML>
	<HEAD>	
		<LINK REL="stylesheet" type="text/css" HREF="/css/eweaver-default.css">
		<script type="text/javascript" src="/messager/jquery.js"></script>
	</HEAD>
	<body>
	<form name="frmMain" method="post" action="GetUserIconOpreate.jsp" enctype="multipart/form-data">
		<input name="loginid" value="<%=loginid%>" type="hidden">
		<input name="method" value="usericon" type="hidden">
		<table height="100%" width="100%" align="center"  valign="top" style="background:#eeeeff">		
			<input type="hidden" name="imagefileid" id="imagefileid"/>	
			<tr>
			<td colspan="3" height="20px">
				<div id="divSelected">请选择图片:<input class="url" id="fileSrcUrl"  type="file" name="fileSrcUrl"></div>
				<div  id="divInfo" style="display:none">点击拖动并在下图中选择相关区域 </div>		
			</td>
			</tr>
			<tr>
				<td   id="divLeft" style="color:#666666;" width="80%" valign="top">	
									  												
						<iframe id="ifrmSrcImg" 
						src="" name="ifrmSrcImg" 
						 style="border:1px solid #DDDDDD;"  height="96%" width="100%"	BORDER="0" 
						 FRAMEBORDER="no" NORESIZE="NORESIZE" scrolling="auto">
						</iframe>
				</td>
				<td   width="4" id="divRight" valign="top">&nbsp;</td>
				<td   id="divRight" valign="top" style="color:#666666;"  width="22%">		
								
						<div id="divSelect">							
							<div id="divTargetImg" style="border:1px solid #DDDDDD;height:102px;width:102px;background:#ffffff;overflow:auto"></div>
							<br>
							
							x1:<input name="x1" style="width:25px">&nbsp;&nbsp;
							y1:<input name="y1"  style="width:25px">
							<br><br>
							x2:<input name="x2"  style="width:25px">&nbsp;&nbsp;
							y2:<input name="y2"  style="width:25px">
							
							<br><br>
							<button type="button" onclick="doApply()">确认设置</button><br><br>
							<button type="button"  onclick="reSelect()">重新选取</button>
						</div>			
				</td>
			</tr>	
		<table>
		</form>
	</body>
</HTML>
<SCRIPT LANGUAGE="JavaScript">
	$(document).ready( function() {	
		$("#fileSrcUrl").change( function() {			
			var imgUrl=this.value;
			
			if(imgUrl!=''){
				if(imgUrl.toLowerCase().indexOf(".gif")==-1 && imgUrl.toLowerCase().indexOf("jpg")==-1) {
				    alert("只能是jpg和gif格式图片");
					return;
				}		
				$("#divSelected").hide();
				
				$("#divInfo").show();	

				$(ifrmSrcImg.document.body).append("<img src='/images/messageimages/loading.gif'/>加载中...");

				$('input[name=x1]').val('0');
				$('input[name=y1]').val('0');
				$('input[name=x2]').val('100');
				$('input[name=y2]').val('100');
							
				frmMain.target="ifrmSrcImg";
				frmMain.action="GetUserIconOnlyImg.jsp";
				
				frmMain.submit();
			}			
		}); 			
	});

	
	function doApply(){
		var srcUrl=frmMain.fileSrcUrl.value;		
		if($.trim(srcUrl.value)==""&&$.trim($("#divSelected").css("display"))!="none"){		
			alert("请选择好图片路径");
			return;
		} else if (srcUrl.toLowerCase().indexOf(".gif")==-1 && srcUrl.toLowerCase().indexOf("jpg")==-1){
			alert("只能是jpg和gif格式图片");
			return;
		} else {
			frmMain.target="_self";		
			frmMain.action="GetUserIconOpreate.jsp";
			frmMain.submit();
		}
	}

	function reSelect(){
		window.location.reload();
	}
</script>
<%
 if("true".equals(isclosed)){
	//String userid=rci.getUserIdByLoginId(loginid);
	//rci.updateResourceInfoCache(userid);
	out.println("<script>parent.imgWindow.hide();parent.reloadMyLogo();window.location='GetUserIcon.jsp?loginid="+loginid+"'</script>"); 
 }
  %>