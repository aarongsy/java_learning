<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%@ page import="java.text.*" %>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.base.orgunit.service.*" %>

<%	
	String path = request.getContextPath();
	String taskId = request.getParameter("taskId");
	String projectId = request.getParameter("projectId");
	OrgunitService orgunitService =((OrgunitService) BaseContext.getBean("orgunitService"));
	DataService dataService = new DataService();
	List result;//下拉框
	if (StringHelper.isEmpty(projectId) || projectId.equals("undefined")) {
		return;
	}
%>


<html>
  <head>
	<meta content="0" http-equiv="Expires">
	<script type="text/javascript" src="/datapicker/WdatePicker.js"></script>
	<script type='text/javascript' src='/js/workflow.js'></script>
	<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
	<script type="text/javascript">
	    var win;
	    function getrefobj(inputname,inputspan,refid,param,viewurl,isneed){
	        if(document.getElementById(inputname.replace("field","input"))!=null)
	     		document.getElementById(inputname.replace("field","input")).value="";
	    	var fck=param.indexOf("function:");
	        if(fck>-1){}else{
	            var param = parserRefParam(inputname,param);
	        }
			var idsin = document.getElementsByName(inputname)[0].value;
			var id;
		    if(Ext.isIE){
			    try{
					var url ='<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param+'&idsin='+idsin
		            if (idsin.length > 900) {   //当idsin过长时，ie的url不支持过长的地址
		                url ='<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param;
		            }
			    	id=openDialog(url,idsin);
		    	}catch(e){return}
	    		if (id!=null) {
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
									document.all(inputspan).innerHTML = 'ababab';
								else
									document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';
				          	}
						}
						if(inputname=="Principal"){
							onPrincipalChange();
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
	                        if(inputname=="Principal"){
								onPrincipalChange();
							}
	                    }else{
	                        document.all(inputname).value = '';
	                        if (isneed == '0')
	                            document.all(inputspan).innerHTML = '';
	                        else
	                            document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';
	
	                    }
	                }
	            }//end of callback
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
	                    };
	            win.render(Ext.getBody());
	            var dialog = win.getComponent('dialog');
	            dialog.setSrc(url);
	            win.show();
	        }
	    }
	</script>
	</head>

	<body>
		<div id="banner"></div>
		<!-- 卡片内容开始 -->
		<DIV align=center>
			<form action="/ServiceAction/com.eweaver.ganttmap.action.GanttAction?method=savetask"
					name="TaskForm" id="TaskForm" method="post">
			<FIELDSET style="WIDTH: 98%">
					<input type="hidden" name="taskId" value="" />
					<input type="hidden" name="ParentTaskId" value=""/>
					<LEGEND>
						<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be5003e") %><!-- 任务信息 -->
					</LEGEND>
					<TABLE width="100%" class=noborder>
						<COLGROUP>
							<COL width="15%">
							<COL width="35%">
							<COL width="15%">
							<COL width="35%">
						</COLGROUP>
						<TBODY>
							<TR>
								<TD class=FieldName noWrap>
									<%=labelService.getLabelNameByKeyId("402881eb0c9fadb1010c9fce4cc10006") %><!-- 任务名称 -->
								</TD>
								<TD class=FieldValue>
									<INPUT style="WIDTH: 80%" id="Name" class="InputStyle2"
										value="" name="Name" type="text" onchange="checkInput('Name','Namespan')">
									<span id="Namespan" name="Namespan" ><img src=/images/base/checkinput.gif></span>
								</TD>
								<TD class=FieldName noWrap>
									<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b0048") %><!-- 实施部门 -->
								</TD>
								<TD class=FieldValue>
									<button type=button  class=Browser name="button_Office" onclick="javascript:getrefobj('Office','Officespan','402881e60bfee880010bff17101a000c','','/humres/base/humresview.jsp?id=','1');"></button>
									<input type="hidden" name="Office" id="Office" value="">
									<span id="Officespan" name="Officespan" ></span>
								</TD>
							</tr>
							<tr>
								<TD class=FieldName noWrap>
									<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70f001e") %><!-- 任务编号 -->
								</TD>
								<TD class=FieldValue>
									<input type="text" readOnly="true" class="InputStyle2" name="TaskNo" id="TaskNo" style="width: 80%" value=""><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be5003f") %><!-- 不必填 -->
								</TD>
								<TD class=FieldName noWrap>
									<%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150057") %><!-- 任务类型 -->
								</TD>
								<TD class=FieldValue>
									<input type="hidden" name="MasterTypeHide" id="MasterTypeHide" value=""/>
									<select class="InputStyle2" name="MasterType" id="MasterType" style="width: 80%" onchange="checkInput('MasterType','MasterTypespan')">
									</select>
									<span id="MasterTypespan" name="MasterTypespan" ><img src=/images/base/checkinput.gif></span>
								</TD>
							</TR><TR>
								<TD class=FieldName noWrap>
									<%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150058") %><!-- 下达产值数 -->
								</TD>
								<TD class=FieldValue colspan="3">
									<INPUT style="WIDTH: 92%" id="ProduceQty" class="InputStyle2"
										value="" name="ProduceQty" type="text" onchange="checkInput('ProduceQty','ProduceQtyspan');fieldcheck(this,'^\\d+$','<%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150058") %>')" ><!-- 下达产值数 -->
									<span id="ProduceQtyspan" name="ProduceQtyspan" >
									</span>
								</TD>
								</tr>
								<tr>
								<TD class=FieldName noWrap>
									<%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150059") %><!-- 要求开始 -->
								</TD>
								<TD class=FieldValue>
									<input type="text" id="HopeStartDate" name="HopeStartDate" value=""  style='width: 80%'
									class=inputstyle size=10 onchange="checkRelateTime('HopeStartDate','HopeFinishDate',true)" 
									onclick="WdatePicker()" onblur="fieldcheck(this,'(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)','<%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150059") %>')"><!-- 要求开始 -->
								</TD>
								<TD class=FieldName noWrap>
									<%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e15005a") %><!-- 要求完成 -->
								</TD>
								<TD class=FieldValue>
									<input type="text" id="HopeFinishDate" name="HopeFinishDate" value=""  style='width: 80%' 
									class=inputstyle size=10 onchange="checkRelateTime('HopeStartDate','HopeFinishDate',false)" onclick="WdatePicker()" onblur="fieldcheck(this,'(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)','<%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e15005a") %>')"><!-- 要求完成 -->
								</TD>
								</tr><TR>
								<TD class=FieldName noWrap>
									<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b004f") %><!-- 预计开始 -->
								</TD>
								<TD class=FieldValue>
									<input type="text" id="Start" name="Start" value=""  style='width: 80%' 
									class=inputstyle size=10 onchange="checkInput('Start','Startspan');checkRelateTime('Start','Finish',true)" onclick="WdatePicker()" onblur="fieldcheck(this,'(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)','<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b004f") %>')"><!-- 预计开始 -->
									<span id="Startspan" name="Startspan" ><img src=/images/base/checkinput.gif></span>
								</TD>
								<TD class=FieldName noWrap>
									<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b0046") %><!-- 预计完成 -->
								</TD>
								<TD class=FieldValue>
									<input type="text" id="Finish" name="Finish" value=""  style='width: 80%' 
									class=inputstyle size=10 onchange="checkInput('Finish','Finishspan');checkRelateTime('Start','Finish',false)"  onclick="WdatePicker()" onblur="fieldcheck(this,'(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)','<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b0046") %>')"><!-- 预计开始 -->
									<span id="Finishspan" name="Finishspan" ><img src=/images/base/checkinput.gif></span>
								</TD>
								</tr>
								<tr>
								<TD class=FieldName noWrap>
									<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be50040") %><!-- 任务要求 -->
								</TD>
								<TD class=FieldValue colspan="3">
									<textarea rows="0" cols="0" style="WIDTH: 92%;height: 40px" id="Require" name="Require" class="InputStyle2"></textarea>
								</TD>
								</tr>
						</TBODY>
					</TABLE>
				
			</FIELDSET>
			</form>
		</DIV>
	</body>
</html>
<style type="text/css">
.x-toolbar TABLE{
width:0px;
}
</style>
<!-- 数据初始化代码 -->
<script type="text/javascript">
var tb = new Ext.Toolbar();
tb.render('banner');
addBtn(tb,'<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbda07e0009") %>','S','accept',function(){onSubmit()});//提交
addBtn(tb,'<%=labelService.getLabelNameByKeyId("297eb4b8126b334801126b906528001d") %>','C','erase',function(){onClose(0)});//关闭
function checkRelateTime(startName,endName,isChangStart){
	var start = new Date(Date.parse(get(startName).replace(/-/g, "/")));
	var finish = new Date(Date.parse(get(endName).replace(/-/g, "/")));
	if(start>finish){
		if(isChangStart){
			alert('<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be50041") %>');//开始时间不能大于结束时间
			document.getElementById(startName).value = document.getElementById(endName).value;
		}else{
			alert('<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be50042") %>');//结束时间不能小于开始时间
			document.getElementById(endName).value = document.getElementById(startName).value;
		}
	}
}
function setSelect(DomID,ListID){
	var select = document.getElementById(DomID);
	for(var i=0;i<select.length;){
		select.remove(i);
	}
	//var op = document.createElement("option");
	//select.appendChild(op);
	//op.value        = '';
	//op.innerHTML    = '';
	var data = window.parent.selectProject[ListID];
	for(var i=0;i<data.length;i++){
		var op = document.createElement("option");
		select.appendChild(op);
		op.value        = data[i].ID;
		op.innerHTML    = data[i].OBJNAME;
	}
}
setSelect('MasterType','2c91a84e2aa7236b012aa737d8930005');//任务类型

//设置document元素中的值
function setValue(id,value,SpanValue){
	document.getElementById(id).value = value;
	if(SpanValue){
		document.getElementById(id+'span').innerHTML = SpanValue;
	}
}
var isEdit=<%=(!StringHelper.isEmpty(taskId) && !taskId.equals("undefined"))%>;
if(isEdit){
	var task = window.parent.project.tree.getSelected();
	setValue('taskId',task.UID?task.UID:"");
	setValue('Name',task.Name?task.Name:"",task.Name?" ":null);
	setValue('TaskNo',task.TaskNo?task.TaskNo:"");
	setValue('Office',task.Office?task.Office:"",task.OfficeName?task.OfficeName:"");
	setValue('MasterType',task.MasterType?task.MasterType:"",task.MasterType?" ":null);
	setValue('Require',task.Require?task.Require:"");
	setValue('ProduceQty',task.ProduceQty?task.ProduceQty:"",task.ProduceQty?" ":null);
	setValue('Start',task.Start?task.Start.format('Y-m-d'):"",task.Start?" ":null);
	setValue('Finish',task.Finish?task.Finish.format('Y-m-d'):"",task.Finish?" ":null);
	setValue('HopeStartDate',task.HopeStartDate?task.HopeStartDate.format('Y-m-d'):"");
	setValue('HopeFinishDate',task.HopeFinishDate?task.HopeFinishDate.format('Y-m-d'):"");
}

</script>
<!-- 提交与关闭代码 -->
<script type="text/javascript">
	var checkItems = "Name,Start,Finish,MasterType";
	function onSubmit() {
		if(checkForm(TaskForm,checkItems,"<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be50043") %>")){//必填字段不能为空!
			//先组织任务对象
			var project = window.parent.project;
       		var newTask ={};
			if (isEdit){
				newTask = project.tree.getSelected();
			}else{
				newTask.IndentStartDate= null;
				newTask.IndentFinishDate= null;
			}
			newTask.UID= get('taskId')=="undefined"?new Date().getTime():get('taskId');
			newTask.Owner= window.parent.Owner;
			newTask.ContractNo= window.parent.ProjectNo;
			newTask.ContractName= window.parent.ProjectName;
			newTask.Department= window.parent.Department;
			newTask.DepartmentName= window.parent.DepartmentName;
			newTask.Name= get('Name');
			newTask.TaskNo= get('TaskNo');
			newTask.PercentComplete= 0;
			newTask.CreateDate= null;
			newTask.Notes= "";
			newTask.Critical= 0;
			newTask.Principal= "";
			newTask.PrincipalName= "";
			newTask.Office= get('Office');
			newTask.OfficeName= getInner('Officespan');
			newTask.Subject= "";
			//newTask.MutualityPeople= "";
			newTask.RiskLevel= "";
			newTask.TaskSource= "";
			newTask.MasterType= get('MasterType');
			newTask.Model= window.parent.SELECTID.zixiangmu;
			newTask.Pri= "";
			newTask.Description= "";
			newTask.Require= get('Require');
			newTask.ProduceQty= get('ProduceQty')==""?null:get('ProduceQty');
			newTask.HopeStartDate= get('HopeStartDate')==""?null:new Date(Date.parse(get('HopeStartDate').replace(/-/g, "/")));
			newTask.HopeFinishDate= get('HopeFinishDate')==""?null:new Date(Date.parse(get('HopeFinishDate').replace(/-/g, "/")));
			newTask.Start= get('Start')==""?null:new Date(Date.parse(get('Start').replace(/-/g, "/")));
			newTask.Finish= get('Finish')==""?null:new Date(Date.parse(get('Finish').replace(/-/g, "/")));
			newTask.ReceiveDate= null;
			newTask.Status= null;
			newTask.Attachment= "";
			newTask.parenttaskUID= '-1';
			newTask.Checked= 1;
			newTask.IsTemplet= 0;

            var input = window.parent.document.getElementById("tempTask");
            input.value=Ext.util.JSON.encode(newTask);
       		if(!isEdit){//新增
        		onClose(1);
       		}else{//修改
       			onClose(2);
       		}
		}
	}
	function onClose(arg){
		window.parent.closepannel(arg);
	}
	function get(id){
		return document.getElementById(id).value.trim();
	}
	function getInner(id){
		var str = document.getElementById(id).innerHTML;
		var start=str.indexOf('>',0)+1;
		var end =str.indexOf('<',1);
		if (end>1){
			str=str.substring(start,end);
		}
		return str;
	}
</script>