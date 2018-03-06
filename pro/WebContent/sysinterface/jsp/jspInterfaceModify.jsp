<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ taglib uri="/WEB-INF/tags/eweaver.tld" prefix="ew"%>
<%@ page import="com.eweaver.sysinterface.ds.model.*"%>
<%@ page import="com.eweaver.sysinterface.base.InterfaceConstants"%>
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
			    fields="name,code,jspfile,fields,paramType,parameters,description,interfaceTypeId,objid,objtype,jsppath" 
			    tags="text,text,text,select,select,textarea,textarea,hidden,hidden,hidden,hidden" 
			    subject="JSP接口配置" 
			    contents="[{paramType:\"2__文本格式\"}]"
			    action="/ServiceAction/com.eweaver.sysinterface.base.servlet.InterfaceConfigAction?action=save" 
			    names="接口名称,接口编码,jsp文件路径,可选字段,参数类型,接口参数,接口描述,接口类型ID,关联对象ID,关联对象类型ID,jsp文件路径"
			>
			</ew:entity>
		</div>
	</body>
	<script>
	<%
	    String interfaceTypeId = request.getParameter("interfaceTypeId");
	    String jpath = request.getContextPath();
        String jbasePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort() + jpath+"/";
	    
	%>
	var interfaceTypeId = '<%=interfaceTypeId%>';
	var id = '<%=request.getParameter("id")==null?"":request.getParameter("id")%>';
	var objid = '<%=StringHelper.null2String(request.getParameter("objid"))%>';
	var objtype = '<%=StringHelper.null2String(request.getParameter("objtype"))%>';
	var jsppath = '<%=jbasePath + InterfaceConstants.EXT_JSP_PATH%>';
	$(document).ready(
	   
		function(){		    
		    $('#ew_interfaceTypeId').val(interfaceTypeId);
		    $('#ew_jsppath').val(jsppath);
		    fillFields('fields_td',objtype,objid,'ew_parameters');
		    $('#ew_jspfile').attr("readonly","readonly");	    
		    var html = $('#jspfile_td').html();
		    $('#jspfile_td').html(html + '<a href=\'javascript:onEditJava()\'><img src="/light/images/edit_on.gif" alt="编辑"></a>');		    
		    if(id.length > 0){
		        var loadUrl = '/ServiceAction/com.eweaver.sysinterface.base.servlet.InterfaceConfigAction?action=load';		    
		        loadFromDb(loadUrl,'id='+id);		        
		    }		    
			$('#submit').click(function(){
				var checkfs = [{name:'name',text:'接口名称'},{name:'jspfile',text:'Jsp文件'}];
			    if(checkFields(checkfs)) {
			    	return;
			    }
			    var url = '/ServiceAction/com.eweaver.sysinterface.base.servlet.InterfaceConfigAction?action=save';
				saveToUrl('#EweaverForm',url,function(data){
					if(data && data.length == 32) {
					    $('#ew_id').val(data);
					    setSuccess('保存成功');
					    window.parent.onReload();
					}  else {
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
	
	function onEditJava() {
	    var filename = $('#ew_jspfile').val();
	    if(filename == '') {
	    	filename = '' + filename;
	    }
	    var ids=window.showModalDialog("/sysinterface/codeEdit.jsp?filetype=jsp&filename=" + filename,"","dialogHeight:600px;dialogWidth:900px;status:no;center:yes;resizable:yes");
	    if(ids=='-1') {
	    	$('#ew_jspfile').val('');
	    } else if(ids && ids!='') {
	    	$('#ew_jspfile').val(ids);
	    }
	    
	}
	</script>
</html> 