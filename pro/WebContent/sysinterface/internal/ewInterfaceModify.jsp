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
			    fields="name,code,ewInterfaceType,typeid,creatorfield,fields,paramType,paramContent,description,interfaceTypeId,objid,objtype" 
			    tags="text,text,select,browser,text,select,select,textarea,textarea,hidden,hidden,hidden" 
			    subject="EWeaver内部接口配置" 
			    showtest="true"
			    contents="[{dsid:\"select id as objid,dsName as objname from dsentity \"},{paramType:\"0__JSON格式,1__SQL格式\"},
			    {ewInterfaceType:\"3__创建人事卡片,1__创建表单,2__创建流程\"},{typeid:\"#\"}]"
			    action="/ServiceAction/com.eweaver.sysinterface.base.servlet.InterfaceConfigAction?action=save" 
			    names="接口名称,接口编码,内部接口类型,目标类别,创建者字段,可选字段,参数类型,参数配置,接口描述,接口类型ID,关联对象ID,关联对象类型ID"
			>
			</ew:entity>
		</div>
	</body>
	<script>
	<%
	    String interfaceTypeId = request.getParameter("interfaceTypeId");
	%>
	var objid = '<%=StringHelper.null2String(request.getParameter("objid"))%>';
	var objtype = '<%=StringHelper.null2String(request.getParameter("objtype"))%>';
	var interfaceTypeId = '<%=interfaceTypeId%>';
	var id = '<%=request.getParameter("id")==null?"":request.getParameter("id")%>';
	$(document).ready(
	   
		function(){		    
		    $('#ew_interfaceTypeId').val(interfaceTypeId);
		    fillFields('fields_td',objtype,objid,'ew_paramContent');
		    var typehtml = $('#typeid_td').html();
		    var html = typehtml;
		    $('#ew_ewInterfaceType').change(
		    	function(){
		    		if(this.value == 1) {
		    			   //$('#typeid_td').html(html.replace('/workflow/workflow/workflowinfobrowser.jsp','/base/category/categorybrowser.jsp'));		    		     
		    		       $('#typeid_td').html(html.replace('#','/base/category/categorybrowser.jsp'));		    		     
		    		} else if(this.value == 2) {
		    			   //$('#typeid_td').html(html.replace('/base/category/categorybrowser.jsp','/workflow/workflow/workflowinfobrowser.jsp'));
		    		       $('#typeid_td').html(html.replace('#','/workflow/workflow/workflowinfobrowser.jsp'));
		    		} else {
		    		     $('#typeid_td').html('');
		    		}		    		
		    	}
		    );

		   	if(id.length > 0){
		        var loadUrl = '/ServiceAction/com.eweaver.sysinterface.base.servlet.InterfaceConfigAction?action=load';		    
		        loadFromDb(loadUrl,'id='+id,function(){
		        	html = $('#typeid_td').html();
		        	$('#ew_ewInterfaceType').trigger("change");		        
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
		}
	);
	
	</script>
	<script type="text/javascript">
	 function getBrowser(viewurl,inputid,inputname,inputnamespan,isneed){
          var id;
          try{
          id=window.showModalDialog('/base/popupmain.jsp?url='+viewurl);
          }catch(e){}
          if (id!=null) {
          if (id[0] != '0') {
          //alert(inputname);
              document.getElementById(inputid).value = id[0];
              document.getElementById(inputnamespan).innerHTML = id[1];
              document.getElementById(inputname).value = id[1];
              //alert(id[1]);
          }else{
              document.all(inputid).value = '';
              document.all(inputname).value = '';
              if (isneed=='0')
              document.all(inputnamespan).innerHTML = '';
              else
              document.all(inputnamespan).innerHTML = '<img src=/images/base/checkinput.gif>';

                  }
               }
          //onTrigger();     
       }
	
	</script>
</html> 