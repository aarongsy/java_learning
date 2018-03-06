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
			    fields="name,code,isSecurity,dsid,user,passwd,isNeedReturn,client,codepage,sysnr,ashost,funname,tablename,paramType,fields,itemsName,parameters,description,interfaceTypeId,objid,objtype" 
			    tags="text,text,select,select,text,text,select,text,text,text,text,text,text,select,select,text,textarea,textarea,hidden,hidden,hidden" 
			    subject="SAP接口配置" 
			    showtest="true"
			    contents="[{dsid:\"select id as objid,dsName as objname from dsentity where dstypeid = '4028825732056bd4013205703a020004' \"},
			    {isNeedReturn:\"1__是,0__否\"},{isSecurity:\"1__是,0__否\"},{paramType:\"0__JSON格式,1__SQL格式,2__文本格式\"}]"
			    action="/ServiceAction/com.eweaver.sysinterface.base.servlet.InterfaceConfigAction?action=save" 
			    names="接口名称,接口编码,是否需要安全访问,选择已有配置,用户名,密码,是否需要返回值,客户端编号,代码页,SYSNR,地址,方法名称,输出参数表名,参数类型,可选字段,输入参数表名,接口参数,接口描述,接口类型ID,关联对象ID,关联类型ID"
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
	var otherids = new Array('user_tr','passwd_tr','client_tr','codepage_tr','sysnr_tr','ashost_tr');
	$(document).ready(
	   
		function(){		    
		    $('#ew_interfaceTypeId').val(interfaceTypeId);	
		    fillFields('fields_td',objtype,objid,'ew_parameters');	
		    var html = $('#dsid_td').html();
		    $('#dsid_td').html(html + '<a href=\'javascript:onAddDs()\'><img src="/light/images/edit_on.gif" alt="新增"></a>');    
		    if(id.length > 0){
		        var loadUrl = '/ServiceAction/com.eweaver.sysinterface.base.servlet.InterfaceConfigAction?action=load';		    
		         loadFromDb(loadUrl,'id='+id,function() {
		            hideOther('ew_dsid',otherids);
		            $('#ew_dsid').trigger("change");
		        });	
		        
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
			hideOther('ew_dsid',otherids);
			hideOtherByIdValue('ew_dsid',otherids);
		}
	);
	function onAddDs() {
		window.showModalDialog("sapModify.jsp?dsTypeId=4028825732056bd4013205703a020004","","dialogHeight:600px;dialogWidth:900px;status:no;center:yes;resizable:yes");    
	}
	</script>
</html> 