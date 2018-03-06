<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.dbbase.service.DBService"%>
<%@ page import="com.eweaver.base.util.*"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.ResultSetMetaData"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.eweaver.document.goldgrid.*"%>
<%@ include file="/base/init.jsp"%>
<html>
<head>
<title>EweaverReport</title>
  <%
  		List rslist = (List)request.getAttribute("rslist");
  		String modelfile = (String)request.getAttribute("modelfile");
%>
<script language=vbs>
Sub Load()

  webform.WebOffice.RecordID="1158299558125"
  webform.WebOffice.FileName="eweaverReport.xls"
  webform.WebOffice.FileType=".xls"
  webform.WebOffice.EditType="1"
  webform.WebOffice.WebMkDirectory "c:\temp"	 
  webform.WebOffice.WebDownLoadFile "<%=modelfile%>","c:\\TEMP\\temp.xls"
  webform.WebOffice.WebOpenLocalFile "c:\\TEMP\\temp.xls"
dim   tempArray()
<%
  		for(int i=0; i<rslist.size(); i++){
%>
  		webform.WebOffice.WebObject.Application.Sheets(<%=i+1%>).Select
<%
  			List list2 = (List)rslist.get(i);

  			int rows = list2.size();
  			if(rows>0){
	  			int cols = ((Map)list2.get(0)).size();
	%>

redim   tempArray(<%=rows%>,<%=cols%>) 
	<%	
				for(int j=0; j< rows; j++){
					Map rsmap = (Map)list2.get(j);
					Iterator rsit = rsmap.keySet().iterator();
					String rsvalue ="";
					int k=0;
					while (rsit.hasNext()) {
						String rskey = (String)rsit.next();
						if(rsmap.get(rskey) != null){
							rsvalue = rsmap.get(rskey).toString();
						}else{
							rsvalue = "";
						}
						
						if(!rsvalue.equals("")){
							rsvalue = StringHelper.replaceString(rsvalue,"\r\n","");
							rsvalue = StringHelper.replaceString(rsvalue,"\"","");
						}
	%>

tempArray(<%=j%>,<%=k%>)= "<%=rsvalue%>"

	<%				
						k++;
					}
				}
	%>

webform.WebOffice.WebObject.Application.Range(webform.WebOffice.WebObject.Application.Cells(2,1),webform.WebOffice.WebObject.Application.Cells(<%=rows+1%>,<%=cols%>)).Value = tempArray
webform.WebOffice.WebObject.Application.Cells(1,<%=cols +2%>)=<%=rows%>
	<%	
			}
  		}
%>

End Sub

</script>
<script language=javascript>

function StatusMsg(mString){
  StatusBar.innerText=mString;
}



function UnLoad(){
  try{
  if (!webform.WebOffice.WebClose()){
     StatusMsg(webform.WebOffice.Status);
  }else{
     StatusMsg(" ");
  }
  }catch(e){}
}
//作用：存为本地文件


function WebSaveLocal(){
  try{
    webform.WebOffice.WebSaveLocal();
    StatusMsg(webform.WebOffice.Status);
  }catch(e){}
}

</script>
</head>
<INPUT TYPE="button" onclick="WebSaveLocal()" value="<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a003f") %>"><!-- 保存为本地文件 -->
<body bgcolor="#ffffff" onload="Load()" onunload="UnLoad()"> 
  <form name="webform" method="post" > 
	<object id="WebOffice" style="POSITION: relative;top:-20" width=100% height=680 classid="<%=WebOffice.clsid%>" codebase="<%=WebOffice.codebase%>">
		<param name="WebUrl" value="<%=WebOffice.mServerName%>">
		<param name="ShowToolBar" value="0">
		<param name="ShowMenu" value="0">
		</OBJECT>
	</div>
	<div id=StatusBar><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0040") %><!-- 状态栏 --></div>
  </form>
</body>
</html>