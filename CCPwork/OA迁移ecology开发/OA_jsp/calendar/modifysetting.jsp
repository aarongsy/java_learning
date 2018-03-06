<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.calendar.base.model.CalendarSetting"  %>
<%@ page import="com.eweaver.calendar.base.service.CalendarSettingService"  %>
<%@ page import="com.eweaver.calendar.base.service.SchedulesetService" %>
<%@ page import="com.eweaver.calendar.base.model.Scheduleset" %>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService" %>
<%@ page import="com.eweaver.workflow.form.model.Formfield" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService" %>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<script type="text/javascript"
			src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
		<title>共享日程设置</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
	</head>
	<%
	     
		CalendarSettingService calendarSettingService = (CalendarSettingService)BaseContext.getBean("calendarSettingService");
		CalendarSetting settingobj = null;
		String id = request.getParameter("id");
		if (id == null) {
			id = "";
			settingobj = new CalendarSetting();
		} else {
			 settingobj = calendarSettingService.getObjById(id);
		}
		
		String formid = request.getParameter("formid");
		String hsql="from Scheduleset where formid='"+formid+"'";
		SchedulesetService schedulesetService = (SchedulesetService)BaseContext.getBean("schedulesetService");
		FormfieldService formfieldService = (FormfieldService)BaseContext.getBean("formfieldService");
		SelectitemService selectitemService = (SelectitemService)BaseContext.getBean("selectitemService");
		List list = schedulesetService.searchBy(hsql);
		List<Selectitem> selectitems = null;
		if(list.isEmpty()) {
			out.println("附加资源中的日程表单没有配置");
			return;
		} else {
			Scheduleset scheduleset = (Scheduleset)list.get(0);
			String type = scheduleset.getType();
			if(StringHelper.isEmpty(type)) {
				out.println("附加资源中的日程表单中的类型字段没有配置");
				return;
			} else {
				Formfield formfield = formfieldService.getFormfieldById(type);
				if(formfield == null) {
					out.println("附加资源中的日程表单中的类型字段配置无效");
					return;
				} else {
					selectitems = selectitemService.getSelectitemList(formfield.getFieldtype(),null);
				}				 
			} 
		}
		
	 %>
	<body>
		<div>
			<div id="pagemenubar"></div>&nbsp; 
			<!--页面菜单结束-->
			<form
				action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.calendar.base.servlet.CalendarAction?action=savesharesetting"
				id="EweaverForm" name="EweaverForm" method="post">
				<input type="hidden" name="id" value="<%=StringHelper.null2String(id) %>" />
				<input type="hidden" name="formid" value="<%=StringHelper.null2String(formid) %>" />
				<table id="myTable" class=viewform width=100%>
					<tr class=title>
						<td class="FieldName" width=15% nowrap>
							日程类型
						</td>
						<td class="FieldValue" width=20% nowrap>
							<select class="inputstyle2"
								name="calendartype">
								<%
								for(Selectitem item : selectitems){
									String itemid =item.getId();
									String itemobjname = item.getObjname();							
								 %>
								<option value="<%=itemid %>"  <%=StringHelper.null2String(settingobj.getCalendartype()).equals(itemid)?"selected":"" %>>
									<%=itemobjname %>
								</option>
								<%} %>
								<option value="all"  <%=StringHelper.null2String(settingobj.getCalendartype()).equals("all")?"selected":"" %>>
									全部日程
								</option>
							</select>
						</td>
					</tr>
					<tr class=title>
						<td class="FieldName" width=15% nowrap>
							共享对象
						</td>
						<td width=20% class='FieldValue'>
							<select class="inputstyle2"
								name="shareobj"
								onchange="changebtn(this.value)">
								<option value="1" <%=StringHelper.null2String(settingobj.getShareobj()).equals("1")?"selected":"" %>>
									个人
								</option>
								<option value="2" <%=StringHelper.null2String(settingobj.getShareobj()).equals("2")?"selected":"" %>>
									岗位
								</option>
								<option value="3" <%=StringHelper.null2String(settingobj.getShareobj()).equals("3")?"selected":"" %>>
									部门
								</option>							
								<option value="4" <%=StringHelper.null2String(settingobj.getShareobj()).equals("4")?"selected":"" %>>
									所有人
								</option>
							</select>
							<button id="shareobjbtn1" class=Browser type=button
								onclick="getrefobj('shareobjid','shareobjidspan','402881eb0bd30911010bd321d8600015','/humres/base/humresview.jsp?id=', '0');"></button>							
										<button id="shareobjbtn2" class=Browser type=button
								onclick="getrefobj('shareobjid','shareobjidspan','40288041120a675e01120a7ce31a0019','/humres/base/stationinfo/stationbrowser.jsp?id=', '0');"></button>							
										<button id="shareobjbtn3" class=Browser type=button
								onclick="getrefobj('shareobjid','shareobjidspan','40287e8e12066bba0112068b730f0e9c','/base/orgunit/orgunitbrowserm.jsp?id=', '0');"></button>							
							<input type="hidden"
								id="shareobjid"
								name="shareobjid" value="<%=StringHelper.null2String(settingobj.getShareobjid()) %>">
							<span id="shareobjidspan" name="shareobjidspan"><%=StringHelper.null2String(settingobj.getShareobjnames()) %></span>											
						</td>
						<td class="FieldName" width=15% nowrap>
							安全级别
						</td>
						<td>
							<input id="securitylevel" name="securitylevel" value="<%=StringHelper.null2String(settingobj.getSecuritylevel()) %>">
						</td>
					</tr>
					<tr class=title>
						<td class="FieldName" width=15% nowrap>
							共享级别
							<td width=15% class='FieldValue'>
								<select class="inputstyle2"
									id="sharelevel"
									name="sharelevel">
									<option value="1" <%=StringHelper.null2String(settingobj.getSharelevel()).equals("1")?"selected":"" %>>
										查看
									</option>
									<option value="2" <%=StringHelper.null2String(settingobj.getSharelevel()).equals("2")?"selected":"" %>>
										编辑
									</option>
								</select>
							</td>
						</td>
					</tr>
				</table>
			</form>
		</div>
	<div id = "divSearch"></div>
	</body>
	<script type="text/javascript">
	
   	var selected = new Array();
	Ext.onReady(function() {
		Ext.QuickTips.init();
		var shareobj = '<%=StringHelper.null2String(settingobj.getShareobj())%>';
		var tb = new Ext.Toolbar();
		tb.render('pagemenubar');
		addBtn(tb, '提交', 'S', 'zoom', function() {
			onSubmit()});	
		var btn1 = document.getElementById('shareobjbtn1');
		var btn2 = document.getElementById('shareobjbtn2');
		var btn3 = document.getElementById('shareobjbtn3');
		btn1.style.display='none';
		btn2.style.display='none';
		btn3.style.display='none';
		<%if(!StringHelper.isEmpty(settingobj.getShareobj())) {%>
			btn<%=StringHelper.null2String(settingobj.getShareobj())%>.style.display='';
		<%} else {%>
			btn1.style.display='';
		<%}%>
		}
	)
	function onSubmit() {
		EweaverForm.submit();
	}
	function changebtn(value) {
		var btn1 = document.getElementById('shareobjbtn1');
		var btn2 = document.getElementById('shareobjbtn2');
		var btn3 = document.getElementById('shareobjbtn3');
		var shareobjid = document.getElementById('shareobjid');
		var shareobjidspan = document.getElementById('shareobjidspan');
		if(value == 1) {
			btn1.style.display='';
			btn2.style.display='none';
			btn3.style.display='none';
		}
		if(value == 2) {
			btn1.style.display='none';
			btn2.style.display='';
			btn3.style.display='none';
		}
		if(value == 3) {
			btn1.style.display='none';
			btn2.style.display='none';
			btn3.style.display='';
		}
		if(value == 4) {
			btn1.style.display='none';
			btn2.style.display='none';
			btn3.style.display='none';
		}
		shareobjid.value='';
		shareobjidspan.innerHTML='';
	}
	  function getrefobj(inputname,inputspan,refid,viewurl,isneed){
     /* if(inputname.substring(3,(inputname.length-6))){
            if(document.getElementById(inputname.substring(3,(inputname.length-6))))
     document.getElementById(inputname.substring(3,(inputname.length-6))).value="";
        }
        if(document.getElementById(inputname.replace("field","input"))!=null)
     document.getElementById(inputname.replace("field","input")).value="";*/
        // 先暂时把这段代码   给注释掉 因为此代码影响了 EWTS-000790 bug  by肖肖
	var idsin = document.getElementsByName(inputname)[0].value;
	var id;
    if(Ext.isIE){
    try{
         var url ='<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+refid+'&idsin='+idsin;
            if (idsin.length > 900) {   //当idsin过长时，ie的url不支持过长的地址
                url ='<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+refid;
            }
    id=openDialog(url);
    }catch(e){return}
    if (id!=null) {

    if (id[0] != '0') {
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
    }else{
    url='<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+refid+'&idsin='+idsin;
    var callback = function() {
            try {
                id = dialog.getFrameWindow().dialogValue;
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
                    defaultSrc:url,
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
        dialog.setSrc(url);
        win.show();
    }
    }
</script>
</html>
