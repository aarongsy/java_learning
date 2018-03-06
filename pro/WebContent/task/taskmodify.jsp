<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.task.service.TaskModelService"%>
<%@ page import="com.eweaver.task.model.TaskModel"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<html>  
<%
 	String action = request.getContextPath()+"/ServiceAction/com.eweaver.task.servlet.TaskModelAction?action=modify";
	TaskModelService taskModelService = (TaskModelService)BaseContext.getBean("taskModelService");
	PermissiondetailService permissiondetailService = (PermissiondetailService) BaseContext.getBean("permissiondetailService");
	String id = request.getParameter("id");
	TaskModel taskModel = null;
	String weeks = "";
	String months = "";
	String monthday = "";
	String sql = null;
	String comment ="";
	int triggerType = 2;
	if(id == null) {
		taskModel = new TaskModel();
		taskModel.setTriggerType(2);
		taskModel.setIntervalTime(1);
		taskModel.setStartModel(1);
		taskModel.setTaskType(0);
	} else {	    
		taskModel = taskModelService.get(id);
		triggerType = taskModel.getTriggerType();
		if(taskModel.getTaskType() == 0) {
			sql = taskModel.getEventAction();
			taskModel.setEventAction("");
		} 
		if(triggerType == 3) {
			weeks = StringHelper.null2String(taskModel.getTimespot());
		} else if( taskModel.getTriggerType() == 4 ) {
			months = StringHelper.null2String(taskModel.getMonths());
			monthday = StringHelper.null2String(taskModel.getTimespot());
		}
		comment = taskModel.getTips();

	}
   String jobtasknames = StringHelper.null2String(taskModel.getJobtasknames()).replaceAll("[\"]","\\\\\"");
 %>
<head>  
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />  
	<link rel="stylesheet" type="text/css" href="../js/ext/lovCombo/css/Ext.ux.form.LovCombo.css">
	<link rel="stylesheet" type="text/css" href="../js/ext/lovCombo/css/webpage.css">
	<link rel="stylesheet" type="text/css" href="../js/ext/lovCombo/css/lovcombo.css">
	<script type="text/javascript" language="javascript" src="<%=request.getContextPath()%>/js/workflow.js"></script>
	<script type="text/javascript" src="../js/ext/adapter/ext/ext-base.js"></script>
	<script type="text/javascript" src="../js/ext/lovCombo/ext-all.js"></script>

	<script type="text/javascript" src="../js/ext/lovCombo/Ext.ux.util.js"></script>
	<script type="text/javascript" src="../js/ext/lovCombo/Ext.ux.form.LovCombo.js"></script>
	<script type="text/javascript" src="../js/ext/lovCombo/Ext.ux.form.ThemeCombo.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
	<script type="text/javascript" language="javascript" src="<%=request.getContextPath()%>/datapicker/WdatePicker.js"></script>
	<script type="text/javascript">
		Ext.BLANK_IMAGE_URL = '../js/ext/resources/images/default/s.gif';
		
		Ext.override(Ext.ux.form.LovCombo, {
			beforeBlur: Ext.emptyFn
		});
		var week; 
		var month;
		var monthday;
		var trigtype = '<%=triggerType%>';
		Ext.onReady(function() {
		    var tb = new Ext.Toolbar();
			tb.render('pagemenubar');
			addBtn(tb, '<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbda07e0009") %>', 'S', 'zoom', function() {//提交
					onSubmit()});	
			document.getElementById("jobtasknames").value = "<%=jobtasknames%>";		
			week = new Ext.ux.form.LovCombo({
				 id:'lovcombo_week'
				,renderTo:'weekdiv'
				,width:200
				,hideOnSelect:false
				,maxHeight:200
				,store:[
					 [7, '<%=labelService.getLabelNameByKeyId("4028834035424d660135424d6713001a") %>']//星期日
					,[1, '<%=labelService.getLabelNameByKeyId("4028834035424d660135424d6713001b") %>']//星期一
					,[2, '<%=labelService.getLabelNameByKeyId("4028834035424d660135424d6713001c") %>']//星期二
					,[3, '<%=labelService.getLabelNameByKeyId("4028834035424d660135424d6713001d") %>']//星期三
					,[4, '<%=labelService.getLabelNameByKeyId("4028834035424d660135424d6713001e") %>']//星期四
					,[5, '<%=labelService.getLabelNameByKeyId("4028834035424d660135424d6713001f") %>']//星期五
					,[6, '<%=labelService.getLabelNameByKeyId("4028834035424d660135424d67140020") %>']//星期六
				]
				,triggerAction:'all'
				,mode:'local'
			});
			week.setValue('<%=weeks%>');
			
			month = new Ext.ux.form.LovCombo({
				 id:'lovcombo_month'
				,renderTo:'monthdiv'
				,width:200
				,hideOnSelect:false
				,maxHeight:200
				,store:[
					 [1, '<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c0028") %>']//一月
					,[2, '<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c0029") %>']//二月
					,[3, '<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c002a") %>']//三月
					,[4, '<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c002b") %>']//四月
					,[5, '<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c002c") %>']//五月
					,[6, '<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c002d") %>']//六月
					,[7, '<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e002e") %>']//七月
					,[8, '<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e002f") %>']//八月
					,[9, '<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e0030") %>']//九月
					,[10, '<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e0031") %>']//十月
					,[11, '<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e0032") %>']//十一月
					,[12, '<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e0033") %>']//十二月
				]
				,triggerAction:'all'
				,mode:'local'
			});
			month.setValue('<%=months%>');
			
			monthday = new Ext.ux.form.LovCombo({
				 id:'lovcombo_day'
				,renderTo:'daydiv'
				,width:200
				,hideOnSelect:false
				,maxHeight:200
				,store:[
					 [1, '1'],[2, '2'],[3, '3'],[4, '4'],[5, '5'],[6, '6'],[7, '7'],[8, '8'],[9, '9']
					,[10, '10'],[11, '11'],[12, '12'],[13, '13'],[14, '14'],[15, '15'],[16, '16'],[17, '17']
					,[18, '18'],[19, '19'],[20, '20'],[21, '21'],[22, '22'],[23, '23'],[24, '24'],[25, '25']
					,[26, '26'],[27, '27'],[28, '28'],[29, '29'],[30, '30'],[31, '31'],[0, '<%=labelService.getLabelNameByKeyId("4028834035424d660135424d67140021") %>']//最后一天
				]
				,triggerAction:'all'
				,mode:'local'
			});
			monthday.setValue('<%=monthday%>');
			trigger('<%=triggerType%>');
			triggtasktype('<%=taskModel.getTaskType()%>');
		});
		
		function triggtasktype(value) {
			if('0' == value) {
				hide('protask');
				hide('wformtask');
				show('sqltask');
			}
			if('1' == value) {
				hide('sqltask');
				hide('wformtask')
				show('protask');
			}
			if('2' == value) {
				hide('sqltask');
				hide('protask')
				show('wformtask');
			}
		}
		
		function selectAllWeek(obj) {
			if(obj.checked) {
				week.setValue('0,1,2,3,4,5,6');
			} else {
				week.setValue('');
			}
		}
		
		function selectAllMonth(obj) {
			if(obj.checked) {
				month.setValue('1,2,3,4,5,6,7,8,9,10,11,12');
			} else {
				month.setValue('');
			}
		}
		
		function selectAllMonthday(obj) {
			if(obj.checked) {
				monthday.setValue('0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22.23,24,25,26,27,28,29,30,31');
			} else {
				monthday.setValue('');
			}
		}
		
		function hide(id) {
			document.getElementById(id).style.display='none';
		}
		
		function get(id) {
			return document.getElementById(id);
		}
		
		function show(id) {
			document.getElementById(id).style.display='';
		}
		function insert(id,content) {
			document.getElementById(id).innerHTML=content;
			show(id);
		}
		function trigger(obj) {
			var value = obj;
			trigtype = value;
			if('0' == value) {
				insert('intervalspan','<%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150041") %>');//分钟
				hide('weektr');
				hide('monthtr');
				show('cycletr');
			} 
			if('1' == value) {
				insert('intervalspan','<%=labelService.getLabelNameByKeyId("402881ee0c765f9b010c76894378001f") %>');//小时
				hide('weektr');
				hide('monthtr');
				show('cycletr');
			} 
			if('2' == value) {
				insert('intervalspan','<%=labelService.getLabelNameByKeyId("402881ee0c765f9b010c7689dac80022") %>');//天
				hide('weektr');
				hide('monthtr');
				show('cycletr');
			} 
			if('3' == value) {
				//insert('intervalspan','<%=labelService.getLabelNameByKeyId("402881ee0c765f9b010c768a4f830025") %>');//周
				hide('cycletr');
				show('weektr');
				hide('monthtr');
			}
			if('4' == value) {
				hide('cycletr');
				show('monthtr');
				hide('weektr');
			}
			if('5' == value) {
				hide('intervalspan');
				hide('weektr');
				hide('monthtr');
				hide('cycletr');
			}
		}
		
		function taskSelect(obj) {
			var value = obj.value;
			if('0' == value) {
				hide('protask');
				hide('wformtask');
				show('sqltask');
			}
			if('1' == value) {
				hide('sqltask');
				hide('wformtask')
				show('protask');
			}
			if('2' == value) {
				hide('sqltask');
				hide('protask')
				show('wformtask');
			}
		}
		function onSubmit() {
			if( trigtype == 3) {
				get('timespot').value=week.getValue();
				if(get('timespot').value == '') {
				    alert('<%=labelService.getLabelNameByKeyId("4028836b382c636301382c6368f70000") %>');//星期必须填写
				    return;
				}
			} else if (trigtype == 4) {
				get('timespot').value=monthday.getValue();
				get('month').value=month.getValue();
				if(get('timespot').value == '' || get('month').value == '') {
				    alert('<%=labelService.getLabelNameByKeyId("4028836b382c636301382c6368f80001") %>');//月份或天必须填写
				    return;
				}
			}
			if(get('taskName').value == '') {
				alert('<%=labelService.getLabelNameByKeyId("4028834035424d660135424d67140022") %>');//任务名称必须填写!
				return;
			}
			if(get('startDate').value == '' || get('startTime').value == '') {
				alert('<%=labelService.getLabelNameByKeyId("4028834035424d660135424d67140023") %>');//开始时间必须填写!
				return;
			}
			if(get('startDate').value +' '+ get('startTime').value > get('endDate').value +' '+ get('endTime').value) {
				alert('<%=labelService.getLabelNameByKeyId("4028836b382c636301382c6368f80002") %>');//开始时间必须小于结束时间
				return;
			}			
			if(get('sql').value == '' && get('eventAction').value == '' && get('jobtaskids').value == '') {
				alert('<%=labelService.getLabelNameByKeyId("4028834035424d660135424d67140024") %>');//程序或sql内容必须填写!
				return;
			}
			EweaverForm.submit();
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
		document.getElementById('jobtasknames').value = id[1];
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
    
    function getBrowser(viewurl, inputname, inputspan, isneed) {
          var id;
          try {
              id = openDialog('<%=request.getContextPath()%>/base/popupmain.jsp?url=' + viewurl);
          } catch(e) {
          }
          if (id != null) {
              if (id[0] != '0') {
                  document.all(inputname).value = id[0];
                  document.all(inputspan).innerHTML = id[1];
              } else {
                  document.all(inputname).value = '';
                  if (isneed == '0')
                      document.all(inputspan).innerHTML = '';
                  else
                      document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

              }
          }
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
					value="<%=StringHelper.null2String(taskModel.getId()) %>" />
				<input type="hidden" name="timespot" id="timespot"
					value="<%=StringHelper.null2String(taskModel.getTimespot()) %>" />
				<input type="hidden" name="month" id="month"
					value="<%=StringHelper.null2String(taskModel.getMonths()) %>" />
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
							<input type="text" name="taskName" value="<%=StringHelper.null2String(taskModel.getTaskName()) %>">
						</td>
					</tr>
					<tr>
						<td class="FieldName" nowrap>
							<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522004e") %><!-- 触发类型 -->
						</td>
						<td class="FieldValue" nowrap>
							<INPUT type=radio name="triggerType" value="0" onclick="trigger(this.value)" <%=triggerType==0?"checked":"" %>><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150041") %><!-- 分钟 -->
							<INPUT type=radio name="triggerType" value="1" onclick="trigger(this.value)"  <%=triggerType==1?"checked":"" %>><%=labelService.getLabelNameByKeyId("402881ee0c765f9b010c76894378001f") %><!-- 小时 -->
							<INPUT type=radio name="triggerType" value="2" onclick="trigger(this.value)"  <%=triggerType==2?"checked":"" %>><%=labelService.getLabelNameByKeyId("402881ee0c765f9b010c7689dac80022") %><!-- 天 -->
							<INPUT type=radio name="triggerType"  value="3" onclick="trigger(this.value)"  <%=triggerType==3?"checked":"" %>><%=labelService.getLabelNameByKeyId("402881ee0c765f9b010c768a4f830025") %><!-- 周 -->
							<INPUT type=radio name="triggerType"  value="4" onclick="trigger(this.value)"  <%=triggerType==4?"checked":"" %>><%=labelService.getLabelNameByKeyId("402881ee0c765f9b010c768ac6960028") %><!-- 月 -->
							<INPUT type=radio name="triggerType"  value="5" onclick="trigger(this.value)"  <%=triggerType==5?"checked":"" %>><%=labelService.getLabelNameByKeyId("4028834035424d660135424d67140025") %><!-- 仅一次 -->
						</td>
					</tr>
					<tr>
						<td class="FieldName" nowrap>
							<%=labelService.getLabelNameByKeyId("402881820d4598fb010d45b1f3dc000f") %><!-- 开始时间 -->
						</td>
						<%
						String startTime = taskModel.getStartTime();
						String startDate = "";
						if(startTime != null) {
							String[] temp = startTime.split(" ");
							if(temp.length >= 2) {
								startDate = temp[0];
								startTime = temp[1];
							}
						}
						 %>
						<td class='FieldValue'>
							<input type="text" name="startDate" size=10
								onclick="WdatePicker()"
								value="<%=startDate%>" />
							-
							<input type="text" name="startTime" size=10
								onclick="WdatePicker({startDate:'%H:00:00',dateFmt:'H:mm:ss'})"
								value="<%=StringHelper.null2String(startTime) %>" />
						</td>
					</tr>
					<tr>
						<td class="FieldName" nowrap>
							<%=labelService.getLabelNameByKeyId("402881820d4598fb010d45b24e600012") %><!-- 结束时间 -->
						</td>
						<%
						String endTime = taskModel.getEndTime();
						String endDate = "";
						if(endTime != null) {
							String[] temp = endTime.split(" ");
							if(temp.length >= 2) {
								endDate = temp[0];
								endTime = temp[1];
							}
						}
						 %>
						<td class='FieldValue'>
							<input type="text" name="endDate" size=10
								onclick="WdatePicker()"
								value="<%=endDate%>" />
							-
							<input type="text" name="endTime" size=10
								onclick="WdatePicker({startDate:'%H:00:00',dateFmt:'H:mm:ss'})"
								value="<%=StringHelper.null2String(endTime) %>" />
						</td>
					</tr>
					<tr id="cycletr">
						<td class="FieldName"  nowrap>
							<%=labelService.getLabelNameByKeyId("4028834035424d660135424d67140026") %><!-- 循环周期 -->
						</td>
						
						<td class='FieldValue'>
							<%=labelService.getLabelNameByKeyId("4028834035424d660135424d67140027") %><!-- 每隔 -->
							<input type="text" name="intervaltime" value="<%=taskModel.getIntervalTime() %>" size=3>
							<span id="intervalspan"><%=labelService.getLabelNameByKeyId("402881ee0c765f9b010c7689dac80022") %><!-- 天 --></span>							
						</td>

					</tr>

					<tr id=weektr style="display:none">
						<td class="FieldName"  nowrap><%=labelService.getLabelNameByKeyId("4028834035424d660135424d67140028") %><!-- 星期选择 --></td>
						<td class="FieldValue" nowrap>
							<span id=weekdiv></span>
							<span><input type="checkbox" onclick="selectAllWeek(this)"/><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0062") %><!-- 全选 --></span></td>					
					</tr>
					<tr id=monthtr style="display:none">
						<td class="FieldName"  nowrap><%=labelService.getLabelNameByKeyId("4028834035424d660135424d67140029") %><!-- 月份选择 --></td>
						<td class="FieldValue" nowrap>
						<table>
							<tr>
								<td width="20%" class="FieldValue" nowrap><span id="monthdiv">
									<%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150016") %><!-- 月份 --><input type="checkbox" onclick="selectAllMonth(this)"/><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0062") %><!-- 全选 --></td>
							</tr>
							<tr>
								<td width="20%" class="FieldValue" nowrap><span id=daydiv >
									<%=labelService.getLabelNameByKeyId("4028834734b27dbd0134b27dbe7e0000") %><!-- 日期 --><input type="checkbox" onclick="selectAllMonthday(this)" /><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2a0062") %><!-- 全选 --></span></td>
							</tr>
						</table>
						</td>					
					</tr>
					<tr id=triggertask>
						<td class="FieldName"  nowrap><%=labelService.getLabelNameByKeyId("4028834035424d660135424d6714002a") %><!-- 触发任务 --></td>
						<td class="FieldValue" nowrap>
							<INPUT type=radio name="taskType" value="0" onclick="taskSelect(this)" <%=taskModel.getTaskType()==0?"checked":"" %>><%=labelService.getLabelNameByKeyId("4028834035424d660135424d6714002b") %><!-- sql任务 -->
							<INPUT type=radio name="taskType"  value="1" onclick="taskSelect(this)" <%=taskModel.getTaskType()==1?"checked":"" %>><%=labelService.getLabelNameByKeyId("4028834035424d660135424d6714002c") %><!-- 程序任务 -->
							<INPUT type=radio name="taskType"  value="2" onclick="taskSelect(this)" <%=taskModel.getTaskType()==2?"checked":"" %>><%=labelService.getLabelNameByKeyId("4028834035424d660135424d6714002d") %><!-- 分类、流程任务 -->
						    
						</td>					
					</tr>
					<tr id="sqltask">
					<td class="FieldName"  nowrap><%=labelService.getLabelNameByKeyId("4028834035424d660135424d6714002e") %><!-- SQL内容 --></td>
						<td class="FieldValue" nowrap>
							<textarea rows="5" cols="50" name="sql"><%=StringHelper.null2String(sql) %></textarea>
						</td>		
					</tr>
					<tr id="protask" style="display:none">
					<td class="FieldName"  nowrap><%=labelService.getLabelNameByKeyId("4028834035424d660135424d6714002f") %><!-- 程序 --></td>
						<td class="FieldValue" nowrap>
							<input type="text" name="eventAction" size="50" value="<%=StringHelper.null2String(taskModel.getEventAction()) %>">
						</td>		
					</tr>
					<tr id="wformtask" style="display:none">
					<td class="FieldName"  nowrap><%=labelService.getLabelNameByKeyId("402881e90bcbc9cc010bcbcb1aab0008") %><!-- 分类 -->、<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0044") %><!-- 流程 --></td>
						<td class="FieldValue" nowrap>
							 <button type=button class=Browser name="button_402880b223ffb124012408ec1126093e"
							 onclick="javascript:getBrowser('<%=request.getContextPath()%>/task/warnconfigbrowser.jsp','jobtaskids','jobtaskidspan','0');"
						     ></button>
							<input type="hidden" id="jobtaskids" name="jobtaskids" value="<%=StringHelper.null2String(taskModel.getJobtaskids()) %>"  style='width: 288px; height: 17px'  >
							<input type="hidden" id="jobtasknames" name="jobtasknames" value="">
							<span id="jobtaskidspan" name="jobtaskidspan" ><a href="/task/jobtaskmodify.jsp?id=<%=StringHelper.null2String(taskModel.getJobtaskids()) %>"><%=StringHelper.null2String(taskModel.getJobtasknames()) %></a></span>
						</td>		
					</tr>	
					<tr>
					<td class="FieldName"  nowrap><%=labelService.getLabelNameByKeyId("402881e70b774c35010b774dffcf000a") %><!-- 备注 --></td>
						<td class="FieldValue" nowrap>
							<textarea rows="2" cols="50" name="comment"><%=StringHelper.null2String(comment) %></textarea>
						</td>		
					</tr>
					<tr>			
					<td class="FieldName"  nowrap><%=labelService.getLabelNameByKeyId("4028834035424d660135424d67140030") %><!-- 启动模式 --></td>
						<td class="FieldValue" nowrap>
							<INPUT type=radio name="startModel" value="0" <%=taskModel.getStartModel()==0?"checked":"" %>><%=labelService.getLabelNameByKeyId("4028834035424d660135424d67140031") %><!-- 立即启动 -->
							<INPUT type=radio name="startModel"  value="1" <%=taskModel.getStartModel()==1?"checked":"" %>><%=labelService.getLabelNameByKeyId("4028834035424d660135424d67140032") %><!-- 稍后手动启动 -->
						</td>		
					</tr>
				</table>
			</form>
		</div>
	</body>
</html> 