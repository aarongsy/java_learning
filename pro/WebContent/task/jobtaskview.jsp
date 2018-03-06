<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.task.service.WarnConfigService"%>
<%@ page import="com.eweaver.task.model.WarnConfig"%>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>
<%@ page import="com.eweaver.workflow.workflow.service.WorkflowinfoService" %>
<%@ page import="com.eweaver.base.category.model.Category" %>
<%@ page import="com.eweaver.workflow.workflow.model.Workflowinfo" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<%@ page import="com.eweaver.workflow.subprocess.service.SubprocesssetService" %>
<%@ page import="com.eweaver.workflow.subprocess.model.Subprocessset" %>
<jsp:directive.page import="javax.sql.DataSource"/>
<html>  
<%
 	String action = request.getContextPath()+"/ServiceAction/com.eweaver.task.servlet.WarnConfigAction?action=modify";
	WarnConfigService wconfigService = (WarnConfigService)BaseContext.getBean("warnConfigService");
	CategoryService categoryService = (CategoryService) BaseContext.getBean("categoryService");
    WorkflowinfoService workflowinfoService = (WorkflowinfoService) BaseContext.getBean("workflowinfoService");
	HumresService humresService = (HumresService)BaseContext.getBean("humresService");
    PermissiondetailService permissiondetailService = (PermissiondetailService) BaseContext.getBean("permissiondetailService");
	   SubprocesssetService subprocesssetService=(SubprocesssetService)BaseContext.getBean("subprocesssetService");
    String categoryid="";
    String workflowid="";
    String categoryName="";
    String workflowName="";
	String id = request.getParameter("id");
	String requestid = request.getParameter("requestid");
	//String typeid = request.getParameter("warnType")==null?"0":request.getParameter("warnType");
	int warnedOpteratorType = 1;
	String warnedOptType = "0";
	int startDateType = 0;
	WarnConfig wconfig = null;
	String weeks = "";
	String months = "";
	String monthday = "";
	String sql = null;
	String humresObjNames="";
	String humresObjNames2 = "";
	int warnType = 0;
	String dataSource = "";
	String sqlcondition = "";
	String subname="";
	DataService dataService = new DataService();
	id = dataService.getValue("select taskid from uf_warntask where requestid = '"+requestid+"'");
	
	if(id == null) {
		wconfig = new WarnConfig();
		wconfig.setWarnType(0);
		wconfig.setWarnOptType("0");
		wconfig.setWarnedOperatorType(1);
		wconfig.setStartDateType(0);
	} else {
	
	    if(!StringHelper.isEmpty(requestid)) {
	    	boolean isauth = permissiondetailService.checkOpttype(requestid, OptType.VIEW);
	        if(!isauth){
	        	response.sendRedirect(request.getContextPath()+"/nopermit.jsp");
	        } else {
	        	 isauth = permissiondetailService.checkOpttype(requestid, OptType.MODIFY);
		        if(isauth){
					response.sendRedirect(request.getContextPath()+"/task/jobtaskmodify.jsp?id="+id);
				}
	        }
	    }
	    
		wconfig = wconfigService.get(id);
		String objid = wconfig.getObjid();
		categoryid = objid;
		workflowid = objid;
		warnType = wconfig.getWarnType();
		if(WarnConfig.WARNTYPE_WORKFLOW == warnType) {
			Workflowinfo winfo = workflowinfoService.get(objid);
			workflowName = winfo.getObjname();
		} else if (WarnConfig.WARNTYPE_FORM == warnType) {
			Category category = categoryService.getCategoryById(objid);
			categoryName = category.getObjname();
		}
		dataSource = wconfig.getDataSource();
		sqlcondition = wconfig.getSqlcondition();
		warnedOpteratorType = wconfig.getWarnedOperatorType();
		warnedOptType = StringHelper.null2String(wconfig.getWarnOptType());
		startDateType = wconfig.getStartDateType();
		if(WarnConfig.WARNEDOPERATORTYPE_SPECIFY == warnedOpteratorType) {
			humresObjNames = humresService.getHrmresNameById(wconfig.getWarnedOperator());
		}
		if(!StringHelper.isEmpty(wconfig.getOtherWarnedOperator())){
			humresObjNames2 = humresService.getHrmresNameById(wconfig.getOtherWarnedOperator());
		}
		List list = subprocesssetService.find("from Subprocessset where workflow1 = '"+id+"'");
    	if(!list.isEmpty()) {
    		Subprocessset subprocesset = (Subprocessset)list.get(0);
    		subname = subprocesset.getName();
    	}
	}

 %>
<head>  
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />  
	<script type="text/javascript" language="javascript" src="<%=request.getContextPath()%>/datapicker/WdatePicker.js"></script>
	<script type="text/javascript" language="javascript" src="<%=request.getContextPath()%>/js/workflow.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/dwr/interface/FormfieldService.js"></script>
	  <script type="text/javascript" src="<%=request.getContextPath()%>/dwr/engine.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/dwr/util.js"></script>
	<script type="text/javascript">
	var warnedOpteratorType = '<%=warnedOpteratorType%>';
	var warnedOptType = '<%=warnedOptType%>';
	var startDateType = '<%=startDateType%>';
	var dateField = '<%=wconfig.getDatefield()%>'
	var warnedOperator = '<%=wconfig.getWarnedOperator()%>'
		function onSubmit() {
		/**
			if( trigtype == 3) {
				get('timespot').value=week.getValue();
			} else if (trigtype == 4) {
				get('timespot').value=monthday.getValue();
				get('month').value=month.getValue();
			}
			if(get('taskName').value == '') {
				alert('任务名称必须填写!');
				return;
			}
			if(get('startDate').value == '' || get('startTime').value == '') {
				alert('开始时间必须填写!');
				return;
			}			
			if(get('sql').value == '' && get('eventAction').value == '') {
				alert('程序或sql内容必须填写!');
				return;
			}
			**/
			EweaverForm.submit();
		}
	</script>
<script type="text/javascript">

       Ext.onReady(function(){
        var tb = new Ext.Toolbar();
			tb.render('pagemenubar');	
            getOptions(startDateType);
            getHumresFields(warnedOpteratorType);
            getOperatorFields(warnedOpteratorType);
            onTrigger();
       });
		function hide(id) {
			document.getElementById(id).style.display='none';
		}
		function setValue(id,value) {
			var obj = document.getElementById(id);
			if(obj) {
				obj.value = value;
			}
		}
		function get(id) {
			return document.getElementById(id);
		}
		function getValue(id){
			var obj = document.getElementById(id);
			if(obj) {
				return obj.value;
			} else {
				return '';
			}
		}
		function show(id) {
			document.getElementById(id).style.display='';
		}
		function insert(id,content) {
			document.getElementById(id).innerHTML=content;
			show(id);
		}
      function getBrowser(viewurl,inputname,inputspan,isneed){
          var id;
          try{
          id=window.showModalDialog('<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
          }catch(e){}
          if (id!=null) {
          if (id[0] != '0') {
              setValue('objid',id[0]);
              document.all(inputname).value = id[0];
              document.all(inputspan).innerHTML = id[1];
          }else{
              document.all(inputname).value = '';
              if (isneed=='0')
              document.all(inputspan).innerHTML = '';
              else
              document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

                  }
               }
          onTrigger();     
       }

 	function getBrowser1(viewurl,inputname,inputspan,isneed){
 	     viewurl = viewurl + getparamobjid();
          var id;
          try{
          id=window.showModalDialog('<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
         // alert(id);
          
          }catch(e){}
          if (id!=null) {
          //alert(id[0]+':'+id[1]);
          if (id[0] != '0') {
              document.all(inputname).value = id[0];
              document.all(inputspan).innerHTML = id[1];
              document.getElementById('conditiontext').value = document.getElementById('conditionIdspan').innerHTML;
          }else{
              document.all(inputname).value = '';
              if (isneed=='0')
              document.all(inputspan).innerHTML = '';
              else
              document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

                  }
               }
               onTrigger();
       }

        function tosave(){
            document.forms[0].action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.excel.servlet.ExceloptAction?action=save";
            document.forms[0].submit();
        }
		function getobjid() {
			var type=document.getElementById("warnType").value;

            if(type==0){
                return document.getElementById("category").value;               
            }else if(type==1){
               return  document.getElementById("workflow").value;              
            }else{
               return  false;
              
            }
		}
		function getparamobjid() {
			var type=document.getElementById("warnType").value;

            if(type==0){
                return '&categoryid='+document.getElementById("category").value;               
            }else if(type==1){
               return  '&workflowid='+document.getElementById("workflow").value;              
            }else{
               return  false;
              
            }
		}
        function myChange(){
            var type=document.getElementById("warnType").value;
            if(type==0){
                show("categorydiv");
                hide("workflowdiv");     
                hide("sqldiv");
                hide("scondition");  
                show("cwcondition");                              
            }else if(type==1){
             	hide("categorydiv");
                show("workflowdiv");  
                hide("sqldiv");   
                hide("scondition"); 
                show("cwcondition");     
            }else{
                hide("categorydiv");
                hide("workflowdiv");    
                show("sqldiv");
                show("scondition");
                hide("cwcondition");     
            }
        }       
function getOptions(value){
    if(value == 0) {
          show('startdatefieldspan1');
          hide('startdatefieldspan');
    }
    if(value == 1) {
        hide('startdatefieldspan1');
        hide('startdatefieldspan');
    }
    if(value == 2){
        show('startdatefieldspan');
        hide('startdatefieldspan1');
	    var objid = getobjid();//document.getElementById('category').value;
	    var objtype = document.getElementById('warnType').value;
	    Ext.Ajax.request({    
	                   url : contextPath+'/task/getDateFields.jsp',    
	                   timeout:240000,
	                   params : {    
	                          objid:objid,
	                          objtype:objtype,
	                          valueid:dateField
	                    },    
	                   success : function(response) {                       
	                        var respText = response.responseText;  
	                        document.getElementById('startdatefieldspan').innerHTML =respText;  
	                    },    
	                    failure : function(response) {    
	                                Ext.Msg.alert('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f005c") %>');//错误, 无法访问后台
	                                myMask.hide();
	                    }    
			})
		}
}
function onTrigger(){
	var trigconf = Ext.getDom('triggerconf');
	if(!trigconf) {
	return;
	}
	var objid = getobjid();
	var type=document.getElementById("warnType").value;
	trigconf.innerHTML ="<a href='/task/subprocess.jsp?objtype="+type+"&objid="+objid+"&nodeid=<%=id%>' target='_blank'><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be60069") %></a>";//触发配置
	//trigconf.innerHTML ="<a href='javascript:onPopup(\"/task/subprocess.jsp?objtype="+type+"&objid="+objid+"\")'>触发配置</a>";// "<a href='javascript:onPopup('/task/subprocess.jsp?objtype="+type+"&objid="+objid+"')>触发配置</a>";
}
function getHumresFields(value){
    if(value == 0) {
       hide('humresfieldspan1');   
       show('humresfieldspan');  	 
	    var objid = getobjid();//document.getElementById('category').value;
	    var objtype = document.getElementById('warnType').value;
	    Ext.Ajax.request({    
	                   url : contextPath+'/task/getHumresFields.jsp',    
	                   timeout:240000,
	                   params : {    
	                          objid:objid,
	                          objtype:objtype,
	                          valueid:warnedOperator
	                    },    
	                   success : function(response) {                       
	                        var respText = response.responseText;  
	                        document.getElementById('humresfieldspan').innerHTML =respText;  
	                    },    
	                    failure : function(response) {    
	                                Ext.Msg.alert('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f005c") %>');//错误, 无法访问后台
	                                myMask.hide();
	                    }    
			})
	} 
	if(value == 2){
	    hide('humresfieldspan1'); 
	    show('humresfieldspan');
		getOperatorFields(value);
	}
	if(value == 1) {
		show('humresfieldspan1');
		hide('humresfieldspan'); 
	}
}

function getOperatorFields(value){
    if(value == 2) {
    	
    
    var objid = getobjid();//document.getElementById('category').value;
    var objtype = document.getElementById('warnType').value;
    Ext.Ajax.request({    
                   url : contextPath+'/task/getNodeFields.jsp',    
                   timeout:240000,
                   params : {    
                          objid:objid,
                          objtype:objtype,
                          valueid:warnedOperator
                    },    
                   success : function(response) {                       
                        var respText = response.responseText;  
                        document.getElementById('humresfieldspan').innerHTML =respText;  
                    },    
                    failure : function(response) {    
                                Ext.Msg.alert('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f005c") %>');//错误, 无法访问后台
                                myMask.hide();
                    }    
		})
		}
}
  function getrefobj(inputname,inputspan,refid,param,viewurl,isneed){
        if(document.getElementById(inputname.replace("field","input"))!=null)
     document.getElementById(inputname.replace("field","input")).value="";
//alert(param);

    var fck=param.indexOf("function:");
        if(fck>-1){}else{
            var param = parserRefParam(inputname,param);
        }
	var idsin = document.getElementsByName(inputname)[0].value;
        var url='<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param+'&idsin='+idsin;
        if(idsin.length>900){   //当idsin过长时，ie的url不支持过长的地址
           url='<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param;
        }
        //alert(url);
	var id;
    if(Ext.isIE){
    try{
	//alert(url)
    id=window.showModalDialog(url);
    }catch(e){return}
    if (id!=null) {
		//alert(id[0]);
    if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(inputspan).innerHTML = id[1];
  if(fck>-1){
          funcname=param.substring(9);
      scripts="valid="+funcname+"('"+id[0]+"');";
        eval(scripts) ;
        if(!valid){  //valid默认的返回true;
         document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';
          }
          }
    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
    }else{
    url='<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param+'&idsin='+idsin;
    var callback = function() {
            try {
                id = dialog.getFrameWindow().dialogValue;
            } catch(e) {
            }
            if (id != null) {
                if (id[0] != '0') {
                    document.all(inputname).value = id[0];
                    document.all(inputspan).innerHTML = id[1];
                     if (fck > -1) {
                        funcname = param.substring(9);
                        scripts = "valid=" + funcname + "('" + id[0] + "');";
                        eval(scripts);
                        if (!valid) {  //valid默认的返回true;
                            document.all(inputname).value = '';
                            if (isneed == '0')
                                document.all(inputspan).innerHTML = '';
                            else
                                document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';
                        }
                    }
                } else {
                    document.all(inputname).value = '';
                    if (isneed == '0')
                        document.all(inputspan).innerHTML = '';
                    else
                        document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

                }
            }
        }
        if (!win) {
             win = new Ext.Window({
                layout:'border',
                width:Ext.getBody().getWidth()*0.8,
                height:Ext.getBody().getHeight()*0.8,
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
                }
        win.render(Ext.getBody());
        var dialog = win.getComponent('dialog');
        dialog.setSrc(url);
        win.show();
    }
    }
    
    var DS={
getTables:function(obj){
	var val=obj.value;
	Ext.getDom('vtableName').innerHTML='';
	Ext.getDom('vdstable').style.display = '';
	if(val!='0'){
		var opt=document.createElement('option');
		Ext.getDom('vtableName').add(opt);
		opt.value='0';opt.text=' ';
		FormfieldService.getTablesByDS(val,function(l){
			for(var i=0;i<l.length;i++){
				var opt=document.createElement('option');
				Ext.getDom('vtableName').add(opt);
				opt.value=l[i];opt.text=l[i];
			}
		});
	}
},
getFields:function(obj){
	var val=obj.value;
	Ext.getDom('vfieldName').innerHTML='';
	if(val!='0'){
		var opt=document.createElement('option');
		Ext.getDom('vfieldName').add(opt);
		opt.value='0';opt.text=' ';
		FormfieldService.getFieldsByTable(Ext.getDom('datasource').value,val,function(l){
			for(var i=0;i<l.length;i++){
			   var opt=document.createElement('option');
				Ext.getDom('vfieldName').add(opt);
				opt.value=l[i];opt.text=l[i];
			}
		});
	}
}
};

   function onPopup(url){
     var id=window.showModalDialog(url);
     alert(id);
	 Ext.getDom('triggerid').value = id;
   }
    </script>
</head>   
 <body>
		<div>
				<div id="divSearch">
      <div id="pagemenubar" style="z-index:100;"></div>
  </div> 
			<!--页面菜单结束-->
			<form action="<%=action %>" id="EweaverForm" name="EweaverForm" method="post">
				<input type="hidden" name="id"
					value="<%=StringHelper.null2String(wconfig.getId()) %>" />
				<input type="hidden" name="typeid" id="typeid"
					value="<%=StringHelper.null2String(wconfig.getWarnType()) %>" />
				<input type="hidden" name="objid" id="objid"
					value="<%=StringHelper.null2String(wconfig.getObjid()) %>" />
				<input type="hidden" name="conditiontext" id="conditiontext"
					value="<%=StringHelper.null2String(wconfig.getConditionText()) %>" />
				<table id="myTable" class=viewform width=50%>
					<tr>
						<td class="FieldValue" nowrap colspan="2" align="center">
							<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be6006a") %><!-- 任务设置 -->
						</td>
					</tr>
					<tr>
						<td class="FieldName" nowrap>
							<%=labelService.getLabelNameByKeyId("402881eb0c9fadb1010c9fce4cc10006") %><!-- 任务名称 -->
						</td>
						<td class="FieldValue" nowrap>
							<input type="text" name="objname" value="<%=StringHelper.null2String(wconfig.getObjname()) %>">
						</td>
					</tr>
					<TR>
						<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f004e") %><!-- 类型选择 --></TD>
						<TD class=FieldValue >
						    <select id="warnType" name="warnType" onchange="myChange()">
						    <option value="0" <%if(warnType == 0){%> selected="selected"<%}%>><%=labelService.getLabelNameByKeyId("402881e90bcbc9cc010bcbcb1aab0008") %><!-- 分类 --></option>
						    <option value="1" <%if(warnType == 1){%> selected="selected"<%}%>><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0044") %><!-- 流程 --></option>
						    <option value="2" <%if(warnType == 2){%> selected="selected"<%}%>>SQL</option>
						    </select>
						</TD>
					</TR>

<TR id=categorydiv  <%if(warnType == 0){%> style="display:block"<%}else{%>style="display:none"<%}%>>
<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402881e90bcbc9cc010bcbcb1aab0008") %><!-- 分类 --></TD>
<TD class=FieldValue ><button  type="button" class=Browser name="button_4028d80f19b18c860119b263878c0072" 
onclick="javascript:getBrowser('/base/category/categorybrowser.jsp','category','categoryspan','1')">
</button><input type="hidden" name="category" value="<%=categoryid%>"  style='width: 288px; height: 17px'  >
<span id="categoryspan" name="categoryspan" ><%=categoryName%></span>
</TD>
</TR>

<TR id=workflowdiv  <%if(warnType == 1){%> style="display:block"<%}else{%>style="display:none"<%}%>>
<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0044") %><!-- 流程 --></TD>
<TD class=FieldValue >
<button  type="button" class=Browser name="button_4028d80f19b18c860119b263878c0072" onclick="javascript:getBrowser('/workflow/workflow/workflowinfobrowser.jsp','workflow','workflowspan','1')"></button>
<input type="hidden" name="workflow" value="<%=workflowid%>"  style='width: 288px; height: 17px'  >
<span id="workflowspan" name="workflowspan" ><%=workflowName%></span>
</TD></TR>

<TR id=sqldiv  <%if(warnType == 2){%> style="display:block"<%}else{%>style="display:none"<%}%>>
<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be6006b") %><!-- 数据源选择 --></TD>
<%String[] names=BaseContext.getBeanNames(DataSource.class); %>
					<td class="FieldValue">
						<select  id="datasource" name="datasource" onchange="DS.getTables(this);" >
						<option value="">&nbsp;</option>
						<%for(String n:names){
						String selected = n.equals(dataSource)?"selected":"";
						out.println("<option "+selected+" value=\""+n+"\" >"+n+"</option>");} %>
						</select> <span id="vdstable" style="display:none">
						<select id="vtableName" name="vtableName" onchange="DS.getFields(this);"></select>
						<select id="vfieldName" name="vfieldName"></select></span>
					</td>
</TR>

					<TR>
						<td class="FieldName" nowrap>
							<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be7006c") %><!-- 预警条件 -->
						</td>
						<td id="cwcondition" class="FieldValue" nowrap <%if(warnType < 2){%> style="display:block"<%}else{%>style="display:none"<%}%>>
						<button  type="button" class=Browser name="button_4028d80f19b18c860119b263878c0072" onclick="javascript:getBrowser1('/task/sqlbrowser.jsp?i=1&condition=<%=StringHelper.null2String(wconfig.getId()) %>','conditionid','conditionidspan','1')"></button>
						<input type="hidden" name="conditionId" value="<%=StringHelper.null2String(wconfig.getConditionId())%>"  style='width: 288px; height: 17px'  >
						<span id="conditionIdspan" name="conditionIdspan" ><%=StringHelper.null2String(wconfig.getConditionText())%></span>
						</td>
						<td id="scondition" class="FieldValue" nowrap <%if(warnType == 2){%> style="display:block"<%}else{%>style="display:none"<%}%>>
							<textarea rows="5" cols="50" name="sqlcondition"><%=StringHelper.null2String(sqlcondition) %></textarea>
						</td>	
					</TR>

<tr>
						<td class="FieldName" nowrap>
							<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be7006d") %><!-- 提前天数 -->
						</td>
						<td class="FieldValue" nowrap>
							<input type="text" name="beforeDay" value="<%=wconfig.getBeforeDay() %>">
						</td>
					</tr>
<TR>
						<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be7006e") %><!-- 起始时间 --></TD>
						<TD class=FieldValue >
						    <select id="type" name="startDateType" onchange="getOptions(this.value)">
						     <option value="-1"  selected="selected"></option>
						    <option value="0" <%if(startDateType == 0){%> selected="selected"<%}%>><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2b0074") %><!-- 指定时间 --></option>
						    <option value="1" <%if(startDateType == 1){%> selected="selected"<%}%>><%=labelService.getLabelNameByKeyId("402881eb0bd74dcf010bd753e2b50008") %><!-- 创建时间 --></option>
						    <option value="2" <%if(startDateType == 2){%> selected="selected"<%}%>><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be7006f") %><!-- 时间字段 --></option>
						    </select>
						    <span id="startdatefieldspan" name="startdatefieldspan"></span>						    
						    <span id="startdatefieldspan1" name="startdatefieldspan1">
						    	<input onclick="WdatePicker()" type="text" name="datefield1" <%if(startDateType == 0){%>
						    	 value="<%=StringHelper.null2String(wconfig.getDatefield()) %>">
						    	 <%} else {%> value=""><%}%>
						    </span>
						</TD>
					</TR>	
					<tr>
						<td class="FieldName" nowrap>
							<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be70070") %><!-- 最大预警次数 -->
						</td>
						<td class="FieldValue" nowrap>
							<input type="text" name="maxremindtimes" value="<%=wconfig.getMaxremindtimes() %>">
						</td>
					</tr>				
					<tr>
						<td class="FieldName" nowrap>
							<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be70072") %><!-- 预警操作 -->
						</td>
						<td class="FieldValue" nowrap>
							<INPUT type=checkbox name="warnOptType" value="0"  <%=warnedOptType.indexOf("0") != -1?"checked":"" %>><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be70073") %><!-- 弹出框 -->
							<INPUT type=checkbox name="warnOptType" value="1"   <%=warnedOptType.indexOf("1") != -1?"checked":"" %>><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be70075") %><!-- 短信 -->
							<INPUT type=checkbox name="warnOptType" value="2"  <%=warnedOptType.indexOf("2") != -1?"checked":"" %>><%=labelService.getLabelNameByKeyId("402883d934c1d57a0134c1d57b100000") %><!-- 邮件 -->		
							<INPUT type=checkbox name="warnOptType" value="3"  <%=warnedOptType.indexOf("3") != -1?"checked":"" %>><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0044") %><!-- 流程 -->
							<INPUT type=checkbox name="warnOptType" value="4"  <%=warnedOptType.indexOf("4") != -1?"checked":"" %>><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a004a") %><!-- 表单 -->		
							<INPUT type=checkbox name="warnOptType" value="5"  <%=warnedOptType.indexOf("5") != -1?"checked":"" %>><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be70076") %><!-- 网页 -->		
						</td>
					</tr>
					<%if(!StringHelper.isEmpty(id)){ %>
					<tr>
						<td class="FieldName" nowrap>
							<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be70077") %><!-- 流程表单触发 -->
						</td>
						<td class="FieldValue" nowrap>
							<span id='triggerconf'><a href="/task/subprocess.jsp?nodeid=<%=id %>"><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be60069") %><!-- 触发配置 --></a></span>(<%=StringHelper.null2String(subname)%>) 
						</td>
					</tr>
					<%} %>
					<tr>
						<td class="FieldName" nowrap>
							<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be70074") %><!-- 预警内容 -->
						</td>
						<td class="FieldValue" nowrap>
							<textarea rows="5" cols="50" id="warnedContent" name="warnedContent"><%=StringHelper.null2String(wconfig.getWarnedContent()) %></textarea>
							<button  type="button" class=Browser name="button_4028d80f19b18c860119b263878c0072" onclick="javascript:getBrowser1('/task/fieldbrowser.jsp?i=1&condition=<%=wconfig.getId() %>','warnedContent','warnedContentspan','1')"></button>							
							<span id="warnedContentspan" name="warnedContentspan" ></span> 
						</td>
					</tr>
					<tr id="warnsql" >
						<td class="FieldName" nowrap>
							<%=labelService.getLabelNameByKeyId("4028834035424d660135424d67110000") %><!-- 预警SQL -->
						</td>
						<td class="FieldValue" nowrap>
							<textarea rows="2" cols="50" id="warnedContentSql" name="warnedContentSql"><%=StringHelper.null2String(wconfig.getWarnedContentSql()) %></textarea>							
						</td>
					</tr>
					<tr id="warnpro">
						<td class="FieldName" nowrap>
							<%=labelService.getLabelNameByKeyId("4028834035424d660135424d67120001") %><!-- 预警程序 -->
						</td>
						<td class="FieldValue" nowrap>
							<textarea rows="2" cols="50" id="warnedContentPro" name="warnedContentPro"><%=StringHelper.null2String(wconfig.getWarnedContentPro()) %></textarea>							
						</td>
					</tr>
					<tr>
						<td class="FieldName" nowrap>
							<%=labelService.getLabelNameByKeyId("4028834035424d660135424d67120002") %><!-- 预警级别提升周期 -->
						</td>
						<td class="FieldValue" nowrap>
							<input type="text" name="levelcycle" value="<%=wconfig.getLevelcycle() %>">
						</td>
					</tr>
					<tr>
						<td class="FieldName" nowrap>
							<%=labelService.getLabelNameByKeyId("4028834035424d660135424d67120003") %><!-- 被预警人 -->
						</td>
						<td class="FieldValue" nowrap>
						 <select id="warnedOperatorType" name="warnedOperatorType" onchange="getHumresFields(this.value)">
						    <option value="-1"  selected="selected"></option>
						    <option value="0" <%if(warnedOpteratorType == 0){%> selected="selected"<%}%>><%=labelService.getLabelNameByKeyId("4028834035424d660135424d67120004") %><!-- 人力资源字段 --></option>
						    <option value="1" <%if(warnedOpteratorType == 1){%> selected="selected"<%}%>><%=labelService.getLabelNameByKeyId("4028834035424d660135424d67120005") %><!-- 固定人员 --></option>
						    <option value="2" <%if(warnedOpteratorType == 2){%> selected="selected"<%}%>><%=labelService.getLabelNameByKeyId("4028834035424d660135424d67120006") %><!-- 相关操作者 --></option>
						    </select>	
						    <span id="humresfieldspan" name="humresfieldspan" ></span>
						    <span id="humresfieldspan1" name="humresfieldspan1" >						    	
							    <button type=button class=Browser name="button_402880b223ffb124012408ec1126093e"
							     onclick="javascript:getrefobj('warnedOperator1','warnedOperator1span','402881eb0bd30911010bd321d8600015','','/humres/base/humresview.jsp?id=','1');"></button>
								<input type="hidden" name="warnedOperator1" value="<%=wconfig.getWarnedOperator()%>"  style='width: 288px; height: 17px'  >
								<span id="warnedOperator1span" name="warnedOperator1span" ><%=StringHelper.null2String(humresObjNames)%></span>
						    </span>		
						    <%if(warnType == 2){%>
							<%=labelService.getLabelNameByKeyId("4028834035424d660135424d67120007") %><!-- 自定义人员字段 --><input type="text" name="defineRemind" value="<%=StringHelper.null2String(wconfig.getDefineRemind()) %>">	
							<%} %>					    				  											
						</td>
					</tr>
					<tr>
						<td class="FieldName" nowrap>
							 <%=labelService.getLabelNameByKeyId("4028834035424d660135424d67120009") %><!-- 其他预警人 -->
						</td>
						<td class="FieldValue" nowrap>							    	
							    <button type=button class=Browser name="button_402880b223ffb124012408ec1126093e"
							     onclick="javascript:getrefobj('otherWarnedOperator','otherWarnedOperatorspan','402881eb0bd30911010bd321d8600015','','/humres/base/humresview.jsp?id=','1');"></button>
								<input type="hidden" name="otherWarnedOperator" value="<%=wconfig.getOtherWarnedOperator()%>"  style='width: 288px; height: 17px'  >
								<span id="otherWarnedOperatorspan" name="otherWarnedOperatorspan" ><%=StringHelper.null2String(humresObjNames2)%></span>
						    </span>						    				  											
						</td>
					</tr>
</table>
			</form>
</body>   
</html> 