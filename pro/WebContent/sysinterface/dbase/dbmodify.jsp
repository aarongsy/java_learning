<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ taglib uri="/WEB-INF/tags/eweaver.tld" prefix="ew"%>
<%@ page import="com.eweaver.sysinterface.ds.model.*"%>
<%@ page import="com.eweaver.sysinterface.ds.service.*"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<html>  

<head>  
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />  
  <script src="/js/jquery/1.6.2/jquery.min.js"/></script>
  <script src="/js/jquery/1.6.2/jq.eweaver.js"/></script>

</head> 
 <body>
		<div>
			<ew:entity 
			    fields="dsName,dsType,dbType,minClients,maxClients,isStart,driverClassName,url,userName,password,description,dsTypeId" 
			    tags="text,text,select,text,text,select,text,text,text,text,textarea,hidden" 
			    subject="数据库接口配置" 
			    contents="[{dbType:\"0__Oracle,1__SQLServer,3__MySQL,2__DB2\"},{isStart:\"1__是,0__否\"}]"
			    action="/ServiceAction/com.eweaver.sysinterface.base.servlet.InterfaceConfigAction?action=save" 
			    names="数据源名称,数据源编码,数据库类型,最小连接数,最大连接数,是否随系统启动,驱动包路径,URL,用户名,密码,数据源描述,接口类型ID"
			>
			</ew:entity>
		</div>
	</body>
	<script>
	<%
	    String dsTypeId = request.getParameter("dsTypeId");
	%>
	var dsTypeId = '<%=dsTypeId%>';
	var id = '<%=request.getParameter("id")==null?"":request.getParameter("id")%>';
	$(document).ready(
	   
		function(){		    
		    $('#ew_dsTypeId').val(dsTypeId);
		    if(id.length > 0){
		        var loadUrl = '/ServiceAction/com.eweaver.sysinterface.ds.servlet.DsAction?action=load';		    
		        loadFromDb(loadUrl,'id='+id);
		        setCheckBox();
		    }
			$('#submit').click(function(){
				var checkfs = [{name:'dsName',text:'数据源名称'},{name:'dbType',text:'数据库类型'}];
			    if(checkFields(checkfs)) {
			    	return;
			    }
			    var url = '/ServiceAction/com.eweaver.sysinterface.ds.servlet.DsAction?action=save';
				saveToUrl('#EweaverForm',url,function(data){
					if(data && data.length == 32) {
					    $('#ew_id').val(data);
					    setSuccess('保存成功');
					}
				});			
			});
		}
	);
	
	</script>
</html> 