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
			    fields="name,code,dsid,isNeedReturn,fields,sql,description,interfaceTypeId,objid,objtype" 
			    tags="text,text,select,select,select,textarea,textarea,hidden,hidden,hidden" 
			    subject="数据库接口配置" 
			    contents="[{dsid:\"select id as objid,dsName as objname from dsentity where dstypeid = '4028825732056bd40132056ea5600002' \"},
			    {isNeedReturn:\"1__是,0__否\"}]"
			    showtest="true"
			    action="/ServiceAction/com.eweaver.sysinterface.base.servlet.InterfaceConfigAction?action=save" 
			    names="接口名称,接口编码,选择数据源,是否需要返回值,可选字段,SQL配置,接口描述,接口类型ID,关联对象ID,关联对象类型ID"
			>
			</ew:entity>
		</div>
	</body>
	<script>
	<%
	    String interfaceTypeId = request.getParameter("interfaceTypeId");
	%>
	var interfaceTypeId = '<%=interfaceTypeId%>';
	var objid = '<%=StringHelper.null2String(request.getParameter("objid"))%>';
	var objtype = '<%=StringHelper.null2String(request.getParameter("objtype"))%>';
	var id = '<%=request.getParameter("id")==null?"":request.getParameter("id")%>';
	$(document).ready(	   
		function(){		    
		    $('#ew_interfaceTypeId').val(interfaceTypeId);
		    fillFields('fields_td',objtype,objid,'ew_sql');
		    var html = $('#dsid_td').html();
		    $('#dsid_td').html(html + '<a href=\'javascript:onAddDs()\'><img src="/light/images/edit_on.gif" alt="新增"></a>');
		    if(id.length > 0){
		        var loadUrl = '/ServiceAction/com.eweaver.sysinterface.base.servlet.InterfaceConfigAction?action=load';		    
		        loadFromDb(loadUrl,'id='+id);
		        setCheckBox();
		    }
			$('#submit').click(function(){
				var checkfs = [{name:'name',text:'接口名称'}];
			    if(checkFields(checkfs)) {
			    	return;
			    }
			    var url = '/ServiceAction/com.eweaver.sysinterface.base.servlet.InterfaceConfigAction?action=save';
				saveToUrl('#EweaverForm',url,function(data){
					if(data && data.length == 32) {
					    $('#ew_id').val(data);
					    setSuccess('保存成功');
					    window.parent.onReload();
					} else {
						setSuccess('保存失败:'+data);
					}
				});			
			});
			$('#test').click(function(){
			    var url = '/ServiceAction/com.eweaver.sysinterface.base.servlet.InterfaceConfigAction?action=test';
			    var id = $('#ew_id').val();
				postToUrl('id='+id,url,function(data){
					if(data ) {					   
					    alert(data);
					}
				});			
			});
		}
	);
	
		function onAddDs() {
		    window.showModalDialog("dbmodify.jsp?dsTypeId=4028825732056bd40132056ea5600002","","dialogHeight:600px;dialogWidth:900px;status:no;center:yes;resizable:yes");    
	    }
	</script>
</html> 