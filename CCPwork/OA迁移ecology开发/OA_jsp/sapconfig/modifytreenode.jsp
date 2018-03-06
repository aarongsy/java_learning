<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@page import="com.eweaver.app.configsap.*"%>
<%@page import="java.util.*"%>
<%@page import="com.eweaver.workflow.form.model.Formfield"%>
<!DOCTYPE html>
<%
String id = StringHelper.null2String(request.getParameter("id"));
SapConfigService scService = new  SapConfigService();
SapConfig sc = scService.findSapConfigById(id);
%>

<html>
<head>
	<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
	<script type="text/javascript" src="/js/jquery/plugins/complexify/jquery.complexify.js"></script>
	<script type="text/javascript" src="/js/jquery/plugins/complexify/jquery.complexify.wrap.js"></script>
	<link type="text/css" rel="stylesheet" href="/js/jquery/plugins/complexify/jquery.complexify.css"/> 
	<style>
		.topbar_login A.login {
			TEXT-ALIGN: center; LINE-HEIGHT: 23px; MARGIN-TOP: 4px; WIDTH: 53px; DISPLAY: block; FLOAT: left; HEIGHT: 23px; OVERFLOW: hidden; FONT-WEIGHT: bold
		}
		.topbar_login A.login:link {
			BACKGROUND: url(../../../images/common/topbar/topbar.png) no-repeat 0px -140px
		}
		.topbar_login A.login:visited {
			BACKGROUND: url(../../../images/common/topbar/topbar.png) no-repeat 0px -140px
		}
		.topbar_login A.login:hover {
			BACKGROUND: url(../../../images/common/topbar/topbar.png) no-repeat -60px -140px; TEXT-DECORATION: none
		}
		.cbox{
			height:13px; 
			vertical-align:text-top; 
			margin-top:1px;
		}
		.statusText{
			margin-left: 3px;
		}
		.statusText_enable{
			font-weight: bold;
		}
		.statusText_unEnable{
			color: #777;
		}
		.FieldName_unEnable{
			color: #777 !important;
		}
		.marsk{
			position: absolute;
			background-image: url("/images/base/loading.gif");
			background-repeat: no-repeat;
			background-color: #fff; 
			padding-left: 31px;
			font-family: Microsoft YaHei;
			z-index: 100;
		}
		.layouttable td{
			padding-top: 2px;
			padding-bottom: 2px;
		}
	</style>
	<script>
	
		function onSubmit(){
			try{
			       Ext.Ajax.request({
			    	    url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.configsap.SapConfigAction',
			    	    params: {
			    	     action : "modify",
			    	     id : "<%=id%>",
			    	     functionremark : $("#functionremark").val()
			    	    },
			    	    success: function(response){  //success中用response接受后台的数据
			    	    	var msg = response.responseText;
			    	    	$("#msg").html(msg);
			    	    },
			    	    failure: function(){
			    	     Ext.Msg.show({
			    	      title: '错误提示',
			    	      msg: '访问接口时发生错误!请联系管理员!',
			    	      buttons: Ext.Msg.OK,
			    	      icon: Ext.Msg.ERROR
			    	     });
			    	    }
			    	   }); 
				
			   }catch(e){
				   alert(e);
			   }
			}
		  
	</script>
</head>
<body>
<!--页面菜单开始-->
<%
pagemenustr += "{S,保存,javascript:onSubmit()}";
%>
<div id="pagemenubar" style="z-index:100;"></div>
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束-->
<form action="" name="EweaverForm" id="EweaverForm"  method="post">
	<table border=0 cellpadding=0 cellspacing=0 class="layouttable"> 
		<colgroup> 
			<col width="10%">
			<col width="20%">
			<col width="10%">
			<col width="60%">
		</colgroup>	
	<tr>
		<td  class="settingDataGroup" colspan="4">
			<b>SAP函数配置信息</b>
		</td>
	</tr>
	<tr>
		<TD class="FieldName">SAP函数名：</TD>
		<td class="FieldValue">
		<input type="hidden"  size=25 name="functionname" id="functionname" value="<%=sc.getName() %>" />
		<span ><%=sc.getName() %></span>	
		</td>
		<TD class="FieldName">SAP描述：</TD>
		<td class="FieldValue">
		<input type="text"  size=100 name="functionremark" id="functionremark" value="<%=sc.getRemark() %>" style="border: none;" />
		<span id="msg" style="color:red;"></span>
		</td>
	</tr>
	<tr>
		<TD class="FieldName">OA表单：</TD>
		<td class="FieldValue" colspan="3">
		<span id="formspan" ><%=sc.getOtabname() %></span>	
		</td>
	</tr>
	<tr>
		<TD class="FieldName" colspan="1">注释：</TD>
	
		<TD class="FieldValue" colspan="3">
			<span style="color: blue;">Java实例：</span><br>
			导入包： <span style="color: red;">import com.eweaver.app.configsap.SapSync;</span><br>
		 	SapSync s = new SapSync();<br>
			try {<br>
				s.syncSap("SAP配置单ID", "oa的uf表的requestid");<br>
			} catch (Exception e) {<br>
				e.printStackTrace();<br>
			}<br>
			
			<span style="color: blue;">JavaScript实例：</span><br>
			
function toSAP(){        <br> 
    var requestid = document.getElementsByName('requestid')[0].value;   <br>     
    if(requestid){   <br>
        var myMask = new Ext.LoadMask(Ext.getBody(), { <br> 
        msg: '正在抛SAP,请稍后...',  <br>
        removeMask: true   <br>
        });  <br>
        myMask.show();  <br>
        jQuery.ajax({   <br>
            async:true,  <br>
            url:'/app/sap/JsonSapAction.jsp?fresh=' + Math.random(),    <br>     
            data:{<br>
                     action:'tosap',<br>
                     id:'SAP配置单ID',<br>
                     requestid:requestid<br>
                    },  <br>
            dataType:'json',  <br>
            success: function(result) { <br>
                myMask.hide();  <br>
                if(result.msg && result.msg=='true'){    <br>                       
                    alert('抛SAP成功！');   <br>
                }  <br>
                else {  <br>
                    alert('抛SAP失败！');  <br>
                }                  <br>
                location.reload();  <br>
            },  <br>
            failure:function(result){  <br>
                myMask.hide();  <br>
                alert('抛SAP失败！');      <br>            
            }  <br>
        });        <br>
    }else alert('请先保存数据！');      <br>   
}         <br>
			
			
			<span style="color: blue;">sql 案例：</span> <br>
			如关联选择 人员<br>
			select <span style="color: red;" title="管理表单中存放和sap中所识别的的编号 如 humres表中 exttextfield5 是sap编号">exttextfield5</span> from humres where <span style="color: red;" title="OA中这个这个字段存的管理表单的字段名，如表中关联人员时 存的是humres表的id">id</span> = <span style="color: red;" title="固定模式，在后台会被原表单中的值替换">'currentFieldValue'</span><br>
			<span style="color: red;" title="管理表单中存放和sap中所识别的的编号 如 humres表中 exttextfield5 是sap编号">exttextfield5 : </span> 管理表单中存放和sap中所识别的的编号 如 humres表中 exttextfield5 是sap编号；<br>
			<span style="color: red;" title="OA中这个这个字段存的管理表单的字段名，如表中关联人员时 存的是humres表的id">id : </span>OA中这个这个字段存的管理表单的字段名，如表中关联人员时 存的是humres表的id<br>
			<span style="color: red;" title="固定模式，在后台会被原表单中的值替换">currentFieldValue : </span>固定模式，在后台会被原表单中的值替换<br>
		</TD>
	</tr>
	
	
</table>
</form> 
  </body>
</html>
