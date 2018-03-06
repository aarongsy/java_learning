<%@ page contentType="text/html; charset=gb2312"%>
<%@ page
	import="java.io.*,java.text.*,java.util.*,java.sql.*,java.text.SimpleDateFormat,java.text.DateFormat,java.util.Date,javax.servlet.*,javax.servlet.http.*,DBstep.iDBManager2000.*"%>
<%@page import="com.eweaver.document.base.model.*" %>
<html>
	<head>
		<title>PDF查看</title>
		<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
		<script type="text/javascript">
	function Load() {
		webform.WebPDF.WebUrl = "/ServiceAction/com.eweaver.document.file.FileDownload?action=getKingGridPDF"; //WebUrl:系统服务器路径，与服务器文件交互操作，如保存、打开文档 
		webform.WebPDF.RecordID = "<%=((Attach)request.getAttribute("attach")).getId()%>"; //RecordID:本文档记录编号
		webform.WebPDF.FileName = "<%=((Attach)request.getAttribute("attach")).getObjname()%>"; //FileName:文档名称
		webform.WebPDF.UserName = "undefine"; //UserName:操作用户名

		webform.WebPDF.ShowMenus = 0;//菜单栏是否可见
		webform.WebPDF.EnableTools("另存为",2);//另存为是否可见(0,禁用；1,可用；2,不可见)
		webform.WebPDF.EnableTools("保存文档",2);//保存文档是否可见(0,禁用；1,可用；2,不可见)
		
		webform.WebPDF.ShowTools = 1; //工具栏可见（1,可见；0,不可见）
		webform.WebPDF.SaveRight = 1; //是否允许保存当前文档（1,允许；0,不允许）
		webform.WebPDF.PrintRight = 0; //是否允许打印当前文档（1,允许；0,不允许）
		webform.WebPDF.AlterUser = false; //是否允许由控件弹出提示框 true表示允许  false表示不允许

		webform.WebPDF.ShowBookMark = 1; //是否显示书签树按钮（1,显示；0,不显示）
		webform.WebPDF.ShowSigns = 1; //设置签章工具栏当前是否可见（1,可见；0,不可见）
		webform.WebPDF.SideWidth = 0; //设置侧边栏的宽度
		
		webform.WebPDF.WebOpen(); //打开该文档    交互OfficeServer的OPTION="LOADFILE"
		webform.WebPDF.Zoom = 100; //缩放比例
		webform.WebPDF.Rotate = 360; //当显示页释放角度
		webform.WebPDF.CurPage = 1; //当前显示的页码
	}
</script>
	</head>
	<body onLoad="Load()" onUnload="" style="margin: 0px;">
		<!--引导和退出iWebPDF-->
		<form name="webform" method="post" action="DocumentSave.jsp">
			<object id="WebPDF" width="100%" height="100%" align="middle"
				border="0" classid="clsid:39E08D82-C8AC-4934-BE07-F6E816FD47A1"
				codebase="iWebPDF.cab#version=7,2,0,338" VIEWASTEXT>
			</object>
		</form>
	</body>
</html>