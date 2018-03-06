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
			    fields="name,code,isNeedReturn,javapath,paramType,fields,parameters,description,interfaceTypeId,objid,objtype" 
			    tags="text,text,select,text,select,select,textarea,textarea,hidden,hidden,hidden" 
			    subject="Java接口配置" 
			    showtest="true"
			    contents="[{paramType:\"2__文本格式\"},{isNeedReturn:\"1__是,0__否\"}]"
			    action="/ServiceAction/com.eweaver.sysinterface.base.servlet.InterfaceConfigAction?action=save" 
			    names="接口名称,接口编码,是否需要返回值,Java代码,参数类型,可选字段,接口参数,接口描述,接口类型ID,关联对象ID,关联对象类型"
			>
			</ew:entity>
		</div>
	</body>
	<script>
	<%
	    String interfaceTypeId = request.getParameter("interfaceTypeId");
	%>
	var interfaceTypeId = '<%=interfaceTypeId%>';
	var id = '<%=request.getParameter("id")==null?"":request.getParameter("id")%>';
	 var objid = '<%=StringHelper.null2String(request.getParameter("objid"))%>';
	var objtype = '<%=StringHelper.null2String(request.getParameter("objtype"))%>';
	function onEditJava() {
	    var filename = $('#ew_javapath').val(); 
	    var ids=window.showModalDialog("/sysinterface/codeEdit.jsp?filename="+filename+"&filetype=java","","dialogHeight:600px;dialogWidth:900px;status:no;center:yes;resizable:yes");
	    if(ids=='-1') {
	    	$('#ew_javapath').val('');
	    } else if(ids && ids!='') {
	    	$('#ew_javapath').val(ids);
	    }
	}
	
	$(document).ready(	   
		function(){		    
		    $('#ew_interfaceTypeId').val(interfaceTypeId);	
		    $('#ew_javapath').attr("readonly","readonly");	    
		    var html = $('#javapath_td').html();	
		    fillFields('fields_td',objtype,objid,'ew_parameters');
		    $('#javapath_td').html(html + '<a href=\'javascript:onEditJava()\'><img src="/light/images/edit_on.gif" alt="编辑"></a>');
		    if(id.length > 0){
		        var loadUrl = '/ServiceAction/com.eweaver.sysinterface.base.servlet.InterfaceConfigAction?action=load';		    
		        loadFromDb(loadUrl,'id='+id);		        
		    }
			$('#submit').click(function(){
			    var checkfs = [{name:'name',text:'接口名称'},{name:'javapath',text:'Java代码'}];
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
			    if(id == '') {
			        alert('测试之前,请保存数据');
			        return;
			    }
				postToUrl('id='+id,url,function(data){
				if(data ) {					   
				    alert(data);
				}
				});			
			});
		}
	);
	</script>
</html> 