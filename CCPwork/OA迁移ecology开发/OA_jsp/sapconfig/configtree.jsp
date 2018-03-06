<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.eweaver.app.configsap.*"%>
<%@page import="java.util.*"%>
<%@page import="com.eweaver.workflow.form.model.Formfield"%>

<%@ include file="/base/init.jsp"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";
    pagemenustr += "addBtn(tb,'重载','B','arrow_redo',function(){overload()});";
    pagemenustr += "addBtn(tb,'删除','D','arrow_redo',function(){onDelete()});";
String id = StringHelper.null2String(request.getParameter("id"));
SapConfigService scService = new  SapConfigService();
SapConfig sc = scService.findSapConfigById(id);


List<SapConfig> scList = scService.findSapConfigs(id);
List<SapConfig> inputList = scService.findInputSapConfigs(id);
List<SapConfig> outputList =scService.findOutputSapConfigs(id);
Map<SapConfig,List<SapConfig>> inTableMap = scService.findInTableSapConfigs(id);
Map<SapConfig,List<SapConfig>> outTableMap = scService.findOutTableSapConfigs(id);

if(sc == null){
	sc = new SapConfig();
}
List<Formfield> fieldList = scService.findFormfields(sc);
%>
<html>
  <head>
      <style type="text/css">
     .x-toolbar table {width:0}
     #pagemenubar table {width:0}
       .x-panel-btns-ct {
         padding: 0px;
     }
     .x-panel-btns-ct table {width:0}
    a:link{
    	color: red;
    }
	a:visited{
		color: red;
	} 
	a:hover{
		color: red;
	}
	a:active{
		color: red;
	}
   </style>
  <script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
<script type='text/javascript' src='<%=request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/tx/jquery.autocomplete.css" />
   <script type="text/javascript" src="/js/jquery/plugins/uploadify/jquery.uploadify-3.1.min.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
   <script type='text/javascript' src='<%=request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
   <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/tx/jquery.autocomplete.css"/>
     <script type="text/javascript">
       Ext.onReady(function() {
           Ext.QuickTips.init();
       <%if(!pagemenustr.equals("")){%>
           var tb = new Ext.Toolbar();
           tb.render('pagemenubar');
           <%=pagemenustr%>
       <%}%>
       });
   </script>
  </head> 
  <body>
  <div style="width: 1160px;">
  <div id="pagemenubar" style="z-index:100;"></div> 
  <form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.configsap.SapConfigAction?action=submit" name="EweaverForm" method="post">
  <div id="main" style="width: 1160px;height: 40px;" >
  	<table>	
				<!-- 列宽控制 -->		
				<colgroup>
					<col width="8%">
					<col width="25%">
					<col width="8%">
					<col width="25%">
					<col width="8%">
					<col width="25%">
				</colgroup>
				 <tbody>
				 <tr>
				 	<th colspan="6"  class="FieldName"><h1 style="font-size: 16px;">基本信息</h1></th>
				 </tr>
  				<tr>
          			<td class="FieldName">配置单ID</td>
          			<td class="FieldValue"><span id="<%=sc.getId() %>_id"><%=sc.getId() %><input type="hidden" id="rfcid" name="rfcid" value="<%=sc.getId() %>"></span></td>
          			<td class="FieldName">RFC 函数名称</td>
          			<td class="FieldValue"><span><%=sc.getName() %></span></td>
          			<td class="FieldName">对应表明</td>
          			<td class="FieldValue"><span id="<%=sc.getId() %>_otabname"><%=sc.getOtabname() %></span>
          			<input type="hidden" value="" id="<%=sc.getId() %>_otabid" name="<%=sc.getId() %>_otabid"/>
          			<button  type="button" class=Browser onclick="javascript:getBrowser('<%= request.getContextPath()%>/workflow/form/forminfobrowser.jsp?moduleid=','<%=sc.getId() %>_otabid','<%=sc.getId() %>_otabname','0');"></button>
          			<a href="javascript:reset('<%=sc.getId() %>');">重载</a>
          			</td>
        		</tr>
 				</tbody>
 	</table>
 	</div>
 	<div style="width: 1160px; height: 20px;" ></div>
 	<div id="input" style="width: 1160px; height: 20px;">
 	<table>	
				<!-- 列宽控制 -->		
				<colgroup>
					<col width="12%">
					<col width="20%">
					<col width="12%">
					<col width="20%">
					<col width="36%">
				</colgroup>
				 <tbody>
				 <tr>
				 	<th colspan="5"  class="FieldName"><h1 style="font-size: 16px;">INPUT信息</h1></th>
				 </tr>
				 <tr>
				 	<th colspan="5"  class="FieldName" style="color: red;">&nbsp;&nbsp;&nbsp;&nbsp;字段类型</th>
				 </tr>
  				<tr>
          			<td class="FieldName">SAPID</td>
          			<td class="FieldName">SAP描述</td>
          			<td class="FieldName">OAID</td>
          			<td class="FieldName">OA描述</td>
          			<td class="FieldName">SQL处理</td>
        		</tr>
        		<%
        			for(int i=0;i<inputList.size();i++){
        		%>
        		<tr>
          			<td class="FieldValue"><span><%=inputList.get(i).getName() %></span></td>
          			<td class="FieldValue"><span><%=inputList.get(i).getRemark() %></span></td>
          			<td class="FieldValue"><span id="<%=inputList.get(i).getId() %>_span" ><%=inputList.get(i).getOtabname() %></span></td>
          			<td class="FieldValue">
          				<select id="<%=inputList.get(i).getId() %>_select" name="<%=inputList.get(i).getId() %>_select" onchange="selectCol(this)">
          					<option value="">[选择]</option>
          					<%if(fieldList.size()>0){%>
          					<option value="id" <%if("id".equals(inputList.get(i).getOtabname())){%>selected="selected"<%} %> >ID</option>
          					<option value="requestid" <%if("requestid".equals(inputList.get(i).getOtabname())){%>selected="selected"<%} %> >RequestID</option>
          					<option value="curruser" <%if("curruser".equals(inputList.get(i).getOtabname())){%>selected="selected"<%} %> >当前用户SAPID</option>
          					<option value="currdate" <%if("currdate".equals(inputList.get(i).getOtabname())){%>selected="selected"<%} %> >当前日期</option>
          					<%}for(int f=0;f<fieldList.size();f++){ %>
          					<option value="<%=fieldList.get(f).getFieldname() %>" <%if(fieldList.get(f).getFieldname().equals(inputList.get(i).getOtabname())){%>selected="selected"<%} %>><%=fieldList.get(f).getLabelname() %></option>
          					<% }%>
          				</select>
          			</td>
          			<td class="FieldValue"><input type="text" id="<%=inputList.get(i).getId() %>_convert" name="<%=inputList.get(i).getId() %>_convert" value="<%=inputList.get(i).getOconvert() %>" style="width: 360px;"/></td>
        		</tr>
        		<%
        			}
        		%>
        		 <tr>
				 	<th colspan="5"  class="FieldName" style="color: red;">&nbsp;&nbsp;&nbsp;&nbsp;表</th>
				 </tr>
				 <% for(Map.Entry<SapConfig,List<SapConfig>> entry : inTableMap.entrySet()) {%>
				 <tr>
				 	<td class="FieldName">SAP表名</td>
				 	<td class="FieldValue"><span><%=entry.getKey().getName() %></span><a href="javascript:tooutput('<%=entry.getKey().getId()%>');">&nbsp;&nbsp;转为输出表</a></td>
          			<td class="FieldName">OA表名</td>
          			<td class="FieldValue"><span id="<%=entry.getKey().getId() %>_otabname" ><%=entry.getKey().getOtabname() %></span>
          			<input type="hidden" value="" id="<%=entry.getKey().getId() %>_otabid" name="<%=entry.getKey().getId() %>_otabid"/>
          			<button  type="button" class=Browser onclick="javascript:getBrowser('<%= request.getContextPath()%>/workflow/form/forminfobrowser.jsp?moduleid=','<%=entry.getKey().getId() %>_otabid','<%=entry.getKey().getId() %>_otabname','0');"></button>
          			<a href="javascript:reset('<%=entry.getKey().getId()%>');">重载</a>
          			</td>
          			<td class="FieldValue"><span><%=entry.getKey().getRemark() %></span></td>
				 </tr>
				 <tr>
          			<td class="FieldName">SAPID</td>
          			<td class="FieldName">SAP描述</td> 
          			<td class="FieldName">OAID</td>
          			<td class="FieldName">OA描述</td>
          			<td class="FieldName">SQL处理</td>
        		</tr>
				 	<% for(int c = 0;c<entry.getValue().size();c++){
				 		List<Formfield> tableFieldList = scService.findFormfields(entry.getKey());
				 	%>
				 <tr>
          			<td class="FieldValue"><span><%=entry.getValue().get(c).getName() %></span></td>
          			<td class="FieldValue"><span><%=entry.getValue().get(c).getRemark() %></span></td>
          			<td class="FieldValue"><span id="<%=entry.getValue().get(c).getId() %>_span" ><%=entry.getValue().get(c).getOtabname() %></span></td>
          			<td class="FieldValue">
          				<select id="<%=entry.getValue().get(c).getId() %>_select" name="<%=entry.getValue().get(c).getId() %>_select" onchange="selectCol(this)">
          					<option value="">[选择]</option>
          					<%if(tableFieldList.size()>0){%>
          					<option value="id" <%if("id".equals(entry.getValue().get(c).getOtabname())){%>selected="selected"<%} %> >ID</option>
          					<option value="requestid" <%if("requestid".equals(entry.getValue().get(c).getOtabname())){%>selected="selected"<%} %> >RequestID</option>
          					<option value="curruser" <%if("curruser".equals(entry.getValue().get(c).getOtabname())){%>selected="selected"<%} %> >当前用户SAPID</option>
          					<option value="currdate" <%if("currdate".equals(entry.getValue().get(c).getOtabname())){%>selected="selected"<%} %> >当前日期</option>
          					<%}for(int t=0;t<tableFieldList.size();t++){ %>
          					<option value="<%=tableFieldList.get(t).getFieldname() %>" <%if(tableFieldList.get(t).getFieldname().equals(entry.getValue().get(c).getOtabname())){%>selected="selected"<%} %> ><%=tableFieldList.get(t).getLabelname() %></option>
          					<% }%>
          				</select>
          			</td>
          			<td class="FieldValue"><input type="text" id="<%=entry.getValue().get(c).getId() %>_convert" name="<%=entry.getValue().get(c).getId() %>_convert" value="<%=entry.getValue().get(c).getOconvert() %>" style="width: 360px;"/></td>
        		</tr>
				 <% }}%>
				 
				 
 				</tbody>
 	</table>
 	<table>	
				<!-- 列宽控制 -->		
				<colgroup>
					<col width="12%">
					<col width="20%">
					<col width="12%">
					<col width="20%">
					<col width="36%">
				</colgroup>
				 <tbody>
				 <tr>
				 	<th colspan="5"  class="FieldName"><h1 style="font-size: 16px;">OUTPUT信息</h1></th>
				 </tr>
				  <tr>
				 	<th colspan="5"  class="FieldName" style="color: red;">&nbsp;&nbsp;&nbsp;&nbsp;字段类型</th>
				 </tr>
  				<tr>
          			<td class="FieldName">SAPID</td>
          			<td class="FieldName">SAP描述</td>
          			<td class="FieldName">OAID</td>
          			<td class="FieldName">OA描述</td>
          			<td class="FieldName">SQL处理</td>
        		</tr>
        		
        		<%
        			for(int o=0;o<outputList.size();o++){
        				
        			
        		%>
        		<tr>
          			<td class="FieldValue"><span><%=outputList.get(o).getName() %></span></td>
          			<td class="FieldValue"><span><%=outputList.get(o).getRemark() %></span></td>
          			<td class="FieldValue"><span id="<%=outputList.get(o).getId() %>_span" ><%=outputList.get(o).getOtabname() %></span></td>
          			<td class="FieldValue">
          				<select id="<%=outputList.get(o).getId() %>_select" name="<%=outputList.get(o).getId() %>_select" onchange="selectCol(this)">
          					<option value="">[选择]</option>
          					<%if(fieldList.size()>0){%>
          					<option value="id" <%if("id".equals(outputList.get(o).getOtabname())){%>selected="selected"<%} %> >ID</option>
          					<option value="requestid" <%if("requestid".equals(outputList.get(o).getOtabname())){%>selected="selected"<%} %> >RequestID</option>
          					<%}for(int f=0;f<fieldList.size();f++){ %>
          					<option value="<%=fieldList.get(f).getFieldname() %>" <%if(fieldList.get(f).getFieldname().equals(outputList.get(o).getOtabname())){%>selected="selected"<%} %> ><%=fieldList.get(f).getLabelname() %></option>
          					<% }%>
          				</select>
          			</td>
          			<td class="FieldValue"><input type="text" id="<%=outputList.get(o).getId() %>_convert" name="<%=outputList.get(o).getId() %>_convert" value="<%=outputList.get(o).getOconvert() %>" style="width: 360px;"/></td>
        		</tr>
        		
        		<%
        			}
        		%>
        		
        		<tr>
				 	<th colspan="5"  class="FieldName" style="color: red;">&nbsp;&nbsp;&nbsp;&nbsp;表</th>
				 </tr>
				 <% for(Map.Entry<SapConfig,List<SapConfig>> entry : outTableMap.entrySet()) {%>
				 <tr>
				 	<td class="FieldName">SAP表名</td>
				 	<td class="FieldValue"><span><%=entry.getKey().getName() %></span><a href="javascript:toinput('<%=entry.getKey().getId()%>');">&nbsp;&nbsp;转为输入表</a></td>
          			<td class="FieldName">OA表名</td>
          			<td class="FieldValue"><span id="<%=entry.getKey().getId() %>_otabname" ><%=entry.getKey().getOtabname() %></span>
          			<input type="hidden" value="" id="<%=entry.getKey().getId() %>_otabid" name="<%=entry.getKey().getId() %>_otabid"/>
          			<button  type="button" class=Browser onclick="javascript:getBrowser('<%= request.getContextPath()%>/workflow/form/forminfobrowser.jsp?moduleid=','<%=entry.getKey().getId() %>_otabid','<%=entry.getKey().getId() %>_otabname','0');"></button>
          			<a href="javascript:reset('<%=entry.getKey().getId()%>');">重载</a>
          			</td>
          			<td class="FieldValue"><span><%=entry.getKey().getRemark() %></span></td>
				 </tr>
				 <tr>
          			<td class="FieldName">SAPID</td>
          			<td class="FieldName">SAP描述</td> 
          			<td class="FieldName">OAID</td>
          			<td class="FieldName">OA描述</td>
          			<td class="FieldName">SQL处理</td>
        		</tr>
				 	<% for(int c = 0;c<entry.getValue().size();c++){
				 		List<Formfield> tableFieldList = scService.findFormfields(entry.getKey());
				 	%>
				 <tr>
          			<td class="FieldValue"><span><%=entry.getValue().get(c).getName() %></span></td>
          			<td class="FieldValue"><span><%=entry.getValue().get(c).getRemark() %></span></td>
          			<td class="FieldValue"><span id="<%=entry.getValue().get(c).getId() %>_span" ><%=entry.getValue().get(c).getOtabname() %></span></td>
          			<td class="FieldValue">
          				<select id="<%=entry.getValue().get(c).getId() %>_select" name="<%=entry.getValue().get(c).getId() %>_select" onchange="selectCol(this)">
          					<option value="">[选择]</option>
          					<%if(tableFieldList.size()>0){%>
          					<option value="id" <%if("id".equals(entry.getValue().get(c).getOtabname())){%>selected="selected"<%} %> >ID</option>
          					<option value="requestid" <%if("requestid".equals(entry.getValue().get(c).getOtabname())){%>selected="selected"<%} %> >RequestID</option>
          					<%}for(int t=0;t<tableFieldList.size();t++){ %>
          					<option value="<%=tableFieldList.get(t).getFieldname() %>" <%if(tableFieldList.get(t).getFieldname().equals(entry.getValue().get(c).getOtabname())){%>selected="selected"<%} %> ><%=tableFieldList.get(t).getLabelname() %></option>
          					<% }%>
          				</select>
          			</td>
          			<td class="FieldValue"><input type="text" id="<%=entry.getValue().get(c).getId() %>_convert" name="<%=entry.getValue().get(c).getId() %>_convert" value="<%=entry.getValue().get(c).getOconvert() %>" style="width: 360px;"/></td>
        		</tr>
				 <% }}%>
        		
 				</tbody>
 	</table>
  </div>		
</form>
</div>
<script language="javascript">
 function selectCol(obj){
	 var spanname = obj.name.replace("select","span");
	 $("#"+spanname).html(obj.value);
 }
 function onDelete(){
	if(confirm("是否确认删除该函数配置?")){
		location.href="<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.configsap.SapConfigAction?action=ondelete&rfcid=<%=id%>";
	}
 }
 
 function overload(){
	if(confirm("请确认SAP函数是否发生改变，如无变动，请勿重载！")){
		location.href="<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.configsap.SapConfigAction?action=overload&rfcid=<%=id%>";
	}
 }
 
   function onSubmit(){
   		document.EweaverForm.submit();
   }
   function reset(scid){
	   var otabid = $("#"+scid+"_otabid").val();
		if(otabid == ""){
			alert("未选择新的表单！");
		}else{
		try{
		       Ext.Ajax.request({
		    	    url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.configsap.SapConfigAction',
		    	    params: {
		    	     action : "reset",
		    	     scid : scid,
		    	     otabid : otabid
		    	    },
		    	    success: function(response){  //success中用response接受后台的数据
		    	    	location.reload();
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
	}
   function toinput(scid){
		try{
		       Ext.Ajax.request({
		    	    url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.configsap.SapConfigAction',
		    	    params: {
		    	     action : "toinput",
		    	     scid : scid
		    	    },
		    	    success: function(response){  //success中用response接受后台的数据
		    	    	location.reload();
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
   function tooutput(scid){
		try{
		       Ext.Ajax.request({
		    	    url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.configsap.SapConfigAction',
		    	    params: {
		    	     action : "tooutput",
		    	     scid : scid
		    	    },
		    	    success: function(response){  //success中用response接受后台的数据
		    	    	location.reload();
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
   
   
   
   var win;
	  function getBrowser(viewurl,inputname,inputspan,isneed){
	  	var id;
	  	if(!Ext.isSafari){
	      try{
	      id=openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url='+viewurl);
	      browserFlag = id;
	      }catch(e){}
	  	if (id!=null) {
	  	if (id[0] != '0') {
	  		document.all(inputname).value = id[0];
	  		document.all(inputspan).innerHTML = id[1];
	      }else{
	  		document.all(inputname).value = '';
	  		if (isneed=='0')
	  		document.all(inputspan).innerHTML = '';
	  		else
	  		document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';
	              }
	           }
	  	}else{
	  	    var callback = function() {
	  	            try {
	  	                id = dialog.getFrameWindow().dialogValue;
	  	            } catch(e) {
	  	            }
	  	            if (id!=null) {
	  	            	if (id[0] != '0') {
	  	            		document.all(inputname).value = id[0];
	  	            		document.all(inputspan).innerHTML = id[1];
	  	                }else{
	  	            		document.all(inputname).value = '';
	  	            		if (isneed=='0')
	  	            		document.all(inputspan).innerHTML = '';
	  	            		else
	  	            		document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';

	  	                  }
	  	             }
	  	        }
	  	        if (!win) {
	  	             win = new Ext.Window({
	  	                layout:'border',
	  	                width:Ext.getBody().getWidth()*0.8,
	  	                height:Ext.getBody().getHeight()*0.75,
	  	                plain: true,
	  	                modal:true,
	  	                items: {
	  	                    id:'dialog',
	  	                    region:'center',
	  	                    iconCls:'portalIcon',
	  	                    xtype     :'iframepanel',
	  	                    frameConfig: {
	  	                        autoCreate:{ id:'portal', name:'portal', frameborder:0 },
	  	                        eventsFollowFrameLinks : false
	  	                    },
	  	                    closable:false,
	  	                    autoScroll:true
	  	                }
	  	            });
	  	        }
	  	        win.close=function(){
	  	                    this.hide();
	  	                    win.getComponent('dialog').setSrc('about:blank');
	  	                    callback();
	  	                } ;
	  	        win.render(Ext.getBody());
	  	        var dialog = win.getComponent('dialog');
	  	        dialog.setSrc(viewurl);
	  	        win.show();
	  	    }
	   }
 </script>
  </body>
</html>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             