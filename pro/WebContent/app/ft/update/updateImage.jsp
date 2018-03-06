<%@ page
	import="com.eweaver.workflow.workflow.service.WorkflowinfoService"%>
<%@ page import="com.eweaver.workflow.workflow.model.Workflowinfo"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.workflow.subprocess.service.SubprocesssetService"%>
<%@ page import="com.eweaver.workflow.subprocess.model.Subprocessset"%>
<%@ page import="com.eweaver.workflow.workflow.service.NodeinfoService"%>
<%@ page import="com.eweaver.base.msg.EweaverMessage"%>
<%@ page import="com.app.fangtian.AlterUploadImage"%>
<%@ page import="java.io.File"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<html>
	<%
		//获取某文件夹下所有文件名称
		File file=new File("E:\\test\\img1");
		  String test[];
		  test=file.list();
		  for(int i=0;i<test.length;i++)
		  {
		   System.out.println(test[i]);
			AlterUploadImage aul = new AlterUploadImage("E:\\test\\img1\\", "E:\\test\\img2\\",
					test[i], test[i], 220, 100, false);
			boolean ischange=false;
			ischange=aul.alterImageSize();
			System.out.println(ischange);
		  }
   	
%>
	<head>
		<Script>
		/**//***
path 要显示值的对象id
****/
function browseFolder(path) {
try {
var Message = "\u8bf7\u9009\u62e9\u6587\u4ef6\u5939"; //选择框提示信息
var Shell = new ActiveXObject("Shell.Application");
var Folder = Shell.BrowseForFolder(0, Message, 64, 17); //起始目录为：我的电脑
//var Folder = Shell.BrowseForFolder(0,Message,0); //起始目录为：桌面
if (Folder != null) {
Folder = Folder.items(); // 返回 FolderItems 对象
Folder = Folder.item(); // 返回 Folderitem 对象
Folder = Folder.Path; // 返回路径
if (Folder.charAt(Folder.length - 1) != "") {
Folder = Folder + "";
}
document.getElementById(path).value = Folder;
return Folder;
}
}
catch (e) {
alert(e.message);
}
}

	</Script>
	</head>
	<body>
		
	</body>
</html>