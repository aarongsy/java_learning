<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.workflow.form.model.Formlink"%>
<%@ page import="com.eweaver.workflow.form.service.FormlinkService"%>
<%@ page import="com.eweaver.workflow.form.model.Formfield"%>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService"%>
<%@ page
	import="com.eweaver.base.selectitem.service.SelectitemtypeService"%>
<%@ page import="com.eweaver.workflow.report.model.Reportsearchfield"%>
<%@ page
	import="com.eweaver.workflow.report.service.ReportSearchfieldService"%>
<%@ page import="com.eweaver.base.util.NumberHelper"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.document.base.model.Attach"%>
<%@ page import="com.eweaver.document.base.service.AttachService"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>
<%@ page import="com.eweaver.base.category.model.Category" %>
<%@ page import="com.eweaver.task.service.WarnConfigService"%>
<%@ page import="com.eweaver.task.model.WarnConfig"%>
<html>
	<head>
		<script
			src='<%=request.getContextPath()%>/dwr/interface/DataService.js'></script>
		<script src='<%=request.getContextPath()%>/dwr/engine.js'></script>
		<script src='<%=request.getContextPath()%>/dwr/util.js'></script>
	</head>
	<body>
		<!-- 标题 -->
		<%
			titlename = labelService
					.getLabelName("402881540c9f83d6010c9f9e49aa0009");
		%>

		<!--页面菜单开始-->
		<%
			pagemenustr += "{S,"
					+ labelService
							.getLabelName("402881e60aabb6f6010aabbda07e0009")
					+ ",javascript:browser_onclick()}";
			pagemenustr += "{C," + labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf290042") + ",javascript:setCondition2()}";//生成条件
			pagemenustr += "{R,"
					+ labelService
							.getLabelName("402881e60aabb6f6010aabe32990000f")
					+ ",javascript:window.close()}";
		%>
		<div id="pagemenubar" style="z-index: 100;"></div>
		<%@ include file="/base/pagemenu.jsp"%>
		<!--页面菜单结束-->
		<%
			WarnConfigService wconfigService = (WarnConfigService)BaseContext.getBean("warnConfigService");
			String formid = request.getParameter("formid");
			String categoryid = request.getParameter("categoryid");
			String workflowid = request.getParameter("workflowid");
			String condition = request.getParameter("condition");//查询条件
			String conditionText = "";
			if(!StringHelper.isEmpty(condition)) {
				WarnConfig wconfig = wconfigService.get(condition);
				if(wconfig != null) {
					condition = wconfig.getConditionId();
					conditionText = wconfig.getConditionText();
				}				
			}
			//System.out.println("------formid:" + formid);
			Map conmap1 = new HashMap();
			Map conmap2 = new HashMap();
			
			ForminfoService forminfoService = (ForminfoService) BaseContext
					.getBean("forminfoService");
			FormfieldService formfieldService = (FormfieldService) BaseContext
					.getBean("formfieldService");
			WorkflowinfoService workflowService = (WorkflowinfoService) BaseContext
					.getBean("workflowinfoService");		
			DataService dataService = new DataService();
			CategoryService categoryService = (CategoryService) BaseContext.getBean("categoryService");		
			if(!StringHelper.isEmpty(workflowid)){
				Workflowinfo winfo = workflowService.get(workflowid);
				formid = winfo.getFormid();
			}
			if(!StringHelper.isEmpty(categoryid)){
				Category category = categoryService.getCategoryById(categoryid);
				formid = category.getFormid();
			}
			Forminfo forminfo1 = forminfoService.getForminfoById(formid);
			List forminfolists = new ArrayList();
			if(forminfo1.getObjtype() != null) {			
				if (forminfo1.getObjtype().toString().equals("0")) {//实际表单
					//formfieldlist = formfieldService.getAllFieldByFormId(formid);
					//String objtablename = forminfo.getObjtablename();
					forminfolists.add(forminfo1);
				} else if (forminfo1.getObjtype().toString().equals("1")) {//抽象表单
					//FormlinkService formlinkService = (FormlinkService) BaseContext.getBean("formlinkService");
					StringBuffer hql = new StringBuffer(
							"from Forminfo a  where a.id in (");
					hql
							.append(
									"select b.pid from Formlink b where  b.typeid=1 and b.oid='")
							.append(formid).append("')");
					forminfolists = forminfoService.getForminfoListByHql(hql
							.toString());
				}
			}
			String[] checkcons = request.getParameterValues("check_con");
			ArrayList ids = new ArrayList();
			ArrayList colnames = new ArrayList();
			ArrayList opts = new ArrayList();
			ArrayList values = new ArrayList();
			ArrayList names = new ArrayList();
			ArrayList opt1s = new ArrayList();
			ArrayList value1s = new ArrayList();
			ids.clear();
			colnames.clear();
			opt1s.clear();
			names.clear();
			value1s.clear();
			opts.clear();
			values.clear();
		%>
		<FORM NAME=EweaverForm STYLE="margin-bottom: 0"
			action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.task.servlet.ConditionsAction?action=modify"
			method="post">
			<input type=hidden id="conditiontext" name="conditiontext" value="<%=StringHelper.null2String(conditionText)%>">
			<input type=hidden name=objid value="<%=formid%>">

			<b><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be60065") %><!-- 原条件 -->： <TEXTAREA  ROWS="2" COLS="60"
				style="width: 100%" readonly><%=StringHelper.null2String(condition)%></TEXTAREA>
			
			</b>
			<br />
			<b> <%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be60066") %><!-- 新的条件 -->： </b>
			<br />
			<TEXTAREA NAME="conditions" id="conditions" ROWS="5" COLS="60"
				style="width: 100%"></TEXTAREA>
			<select class=inputstyle name="formname"
				onchange="onChangeShareType()" value="">
				<option value="0">
					<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003b") %><!-- 请选择表单名称 -->：
				</option>
				<%
					for (int k = 0; k < forminfolists.size(); k++) {
						Forminfo forminfo = (Forminfo) forminfolists.get(k);
						String formname1 = forminfo.getObjname();
						String objtablename1 = forminfo.getObjtablename();
				%>
				<option value="<%=objtablename1%>"><%=formname1%></option>
				<%
					}
				%>
			</select>
			<%
				for (int k = 0; k < forminfolists.size(); k++) {
					Forminfo forminfo = (Forminfo) forminfolists.get(k);
					//System.out.println("------formid:" +k+"  " + forminfo.getId());
					List formfieldlist = formfieldService
							.getAllFieldByFormIdExist(forminfo.getId());
					String formname = forminfo.getObjname();
					String objtablename = forminfo.getObjtablename();

					String mstyle = "";
					if (k != 0) {
						mstyle = "none";
					}
			%>

			<table width=100% class=viewform id="<%=objtablename%>"
				style="display:'<%=mstyle%>'">

				<B>
					<tr>
						<%=labelService.getLabelNameByKeyId("297ee7020b338edd010b3390af720002") %><!-- 表单名称 -->：<%=formname%>
					</tr> </B>

				<%
					int linecolor = 0;
						int tmpcount = 0;
						boolean showsep = true;
						String fieldname = "";
						//System.out.println("------formfieldlist.size():" + formfieldlist.size());
						Iterator fieldit = formfieldlist.iterator();
						while (fieldit.hasNext()) {
							Formfield formfield = (Formfield) fieldit.next();

							tmpcount += 1;
							String id = formfield.getId();

							String htmltype = String.valueOf(formfield.getHtmltype());
							String type = StringHelper.null2String(formfield
									.getFieldtype());

							String _fieldid = StringHelper.null2String(formfield
									.getId());
							String _formid = StringHelper.null2String(formfield
									.getFormid());
							String _fieldname = StringHelper.null2String(formfield
									.getFieldname());
							String _htmltype = StringHelper.null2String(formfield
									.getHtmltype());
							String _fieldtype = StringHelper.null2String(formfield
									.getFieldtype());
							String _fieldattr = StringHelper.null2String(formfield
									.getFieldattr());
							String _fieldcheck = StringHelper.null2String(formfield
									.getFieldcheck());
							String _style = "";
							String _value = "";

							fieldname = formfield.getFieldname();
							String label = formfield.getLabelname();
				%>
				<INPUT TYPE="hidden" name="con<%=id%>_value_fieldname"
					value="<%=fieldname%>">
				<INPUT TYPE="hidden" name="con<%=id%>_value_fieldid"
					value="<%=_fieldid%>">	
				<INPUT TYPE="hidden" name="con<%=id%>_value_objtablename"
					value="<%=objtablename%>">
				<INPUT TYPE="hidden" name="con<%=id%>_value1_fieldname"
					value="<%=fieldname%>">
				<INPUT TYPE="hidden" name="con<%=id%>_value1_objtablename"
					value="<%=objtablename%>">

				<tr class=title>
					<%
						if (!htmltype.equals("3") && !htmltype.equals("7")) {
					%>
					<td class="FieldName">
						<INPUT TYPE="checkbox" NAME="check_con<%=id%>"
							id="check_con<%=id%>" onclick="addfield2('con<%=id%>_value')">
					</td>
					<td class="FieldName"><span id="con<%=id%>_value_field"><%=StringHelper.null2String(label)%></span></td>

					<%
						}

								if (htmltype.equals("1")) {
									if (type.equals("1")) {//文本
					%>

					<td class="FieldValue">
						<select class=inputstyle name="con<%=id%>_value_opt">
							<option value="5">
								<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %><!-- 等于 -->
							</option>
							<option value="6">
								<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e") %><!-- 不等于 -->
							</option>
							<option value="7">
								<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002c") %><!-- 包含 -->
							</option>
							<option value="8">
								<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002f") %><!-- 不包含 -->
							</option>
						</select>
					</td>
					<td colspan=3 class="FieldValue">
						<input type=text class=inputstyle size=12 name="con<%=id%>_value"
							onchange="addfield('con<%=id%>_value')">
					</td>
					<%
						} else if (type.equals("2")) {//整数
					%>

					<td class="FieldValue">
						<select class=inputstyle name="con<%=id%>_value_opt">
							<option value="1">
								<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002f") %><!-- 大于 -->
							</option>
							<option value="2">
								<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003c") %><!-- 大于或等于 -->
							</option>
							<option value="3">
								<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002c") %><!-- 小于 -->
							</option>
							<option value="4">
								<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003d") %><!-- 小于或等于 -->
							</option>
							<option value="5">
								<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %><!-- 等于 -->
							</option>
							<option value="6">
								<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e") %><!-- 不等于 -->
							</option>
						</select>
					</td>
					<td class="FieldValue">
						<input type=text class=inputstyle size=12 name="con<%=id%>_value"
							onchange="addfield('con<%=id%>_value');">
					</td>
					<td class="FieldValue">
						<select class=inputstyle name="con<%=id%>_value1_opt"
							style="width: 100%">
							<option value="1">
								<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002f") %><!-- 大于 -->
							</option>
							<option value="2">
								<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003c") %><!-- 大于或等于 -->
							</option>
							<option value="3">
								<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002c") %><!-- 小于 -->
							</option>
							<option value="4">
								<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003d") %><!-- 小于或等于 -->
							</option>
							<option value="5">
								<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %><!-- 等于 -->
							</option>
							<option value="6">
								<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e") %><!-- 不等于 -->
							</option>
						</select>
					</td>
					<td class="FieldValue">
						<input type=text class=inputstyle size=12 name="con<%=id%>_value1"
							onchange="addfield('con<%=id%>_value1')">
					</td>
					<%
						} else if (type.equals("3")) {//浮点数
					%>
					<td class="FieldValue">
						<select class=inputstyle name="con<%=id%>_value_opt">
							<option value="1">
								<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002f") %><!-- 大于 -->
							</option>
							<option value="2">
								<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003c") %><!-- 大于或等于 -->
							</option>
							<option value="3">
								<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002c") %><!-- 小于 -->
							</option>
							<option value="4">
								<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003d") %><!-- 小于或等于 -->
							</option>
							<option value="5">
								<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %><!-- 等于 -->
							</option>
							<option value="6">
								<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e") %><!-- 不等于 -->
							</option>
						</select>
					</td>
					<td class="FieldValue">
						<input type=text class=inputstyle size=12 name="con<%=id%>_value"
							onchange="addfield('con<%=id%>_value')">
					</td>
					<td class="FieldValue">
						<select class=inputstyle name="con<%=id%>_value1_opt">
							<option value="1">
								<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002f") %><!-- 大于 -->
							</option>
							<option value="2">
								<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003c") %><!-- 大于或等于 -->
							</option>
							<option value="3">
								<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002c") %><!-- 小于 -->
							</option>
							<option value="4">
								<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003d") %><!-- 小于或等于 -->
							</option>
							<option value="5">
								<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %><!-- 等于 -->
							</option>
							<option value="6">
								<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e") %><!-- 不等于 -->
							</option>
						</select>
					</td>
					<td class="FieldValue">
						<input type=text class=inputstyle size=12 name="con<%=id%>_value1"
							onchange="addfield('con<%=id%>_value1')">
					</td>
					<%
						} else if (type.equals("4")) {//日期
					%>

					<td class="FieldValue">
						<select class=inputstyle name="con<%=id%>_value_opt">
							<option value="1">
								<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002f") %><!-- 大于 -->
							</option>
							<option value="2">
								<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003c") %><!-- 大于或等于 -->
							</option>
							<option value="3">
								<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002c") %><!-- 小于 -->
							</option>
							<option value="4">
								<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003d") %><!-- 小于或等于 -->
							</option>
							<option value="5">
								<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %><!-- 等于 -->
							</option>
							<option value="6">
								<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e") %><!-- 不等于 -->
							</option>
						</select>
					</td>
					<td class="FieldValue">
						<button type="button" class="Calendar" id=SelectDate2
							onclick="javascript:getdate('con<%=id%>_value','con<%=id%>_span1','0')"></button>
						&nbsp;
						<span id="con<%=id%>_span1"></span>
						<input type=hidden name="con<%=id%>_value" value="">
					</td>
					<td class="FieldValue" align=left>
						<select class=inputstyle name="con<%=id%>_value1_opt">
							<option value="1">
								<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002f") %><!-- 大于 -->
							</option>
							<option value="2">
								<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003c") %><!-- 大于或等于 -->
							</option>
							<option value="3">
								<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002c") %><!-- 小于 -->
							</option>
							<option value="4">
								<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003d") %><!-- 小于或等于 -->
							</option>
							<option value="5">
								<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %><!-- 等于 -->
							</option>
							<option value="6">
								<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e") %><!-- 不等于 -->
							</option>
						</select>
					</td>
					<td class="FieldValue">
						<button type="button" class="Calendar" id=SelectDate
							onclick="javascript:getdate('con<%=id%>_value1','con<%=id%>_span2','0')"></button>
						&nbsp;
						<span id="con<%=id%>_span2"></span>-&nbsp;&nbsp;
						<input type=hidden name="con<%=id%>_value1" value="">
					</td>

					<%
						} else if (type.equals("5")) {//时间
					%>
					<td class="FieldValue">
						<select class=inputstyle name="con<%=id%>_value_opt">
							<option value="1">
								<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002f") %><!-- 大于 -->
							</option>
							<option value="2">
								<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003c") %><!-- 大于或等于 -->
							</option>
							<option value="3">
								<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002c") %><!-- 小于 -->
							</option>
							<option value="4">
								<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003d") %><!-- 小于或等于 -->
							</option>
							<option value="5">
								<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %><!-- 等于 -->
							</option>
							<option value="6">
								<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e") %><!-- 不等于 -->
							</option>
						</select>
					</td>
					<%
						StringBuffer sb = new StringBuffer("");
										sb
												.append("<td class='FieldValue'>\n\r <button  type=button class=Calendar onclick=\"javascript:gettime('con"
														+ _fieldid
														+ "_value','con"
														+ _fieldid
														+ "span1','0');\"></button>");
										sb.append("\n\r<input type=\"hidden\" name=\"con"
												+ _fieldid + "_value\" value=\"" + _value
												+ "\"  " + _style + "  >");
										sb.append("\n\r<span id=\"con" + _fieldid
												+ "span1\" name=\"field_" + _fieldid
												+ "span\" >");
										sb.append(_value);
										sb.append("</span>\n\r</td>");
										out.print(sb.toString());
					%>
					<td class="FieldValue">
						<select class=inputstyle name="con<%=id%>_value1_opt">
							<option value="1">
								<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002f") %><!-- 大于 -->
							</option>
							<option value="2">
								<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003c") %><!-- 大于或等于 -->
							</option>
							<option value="3">
								<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002c") %><!-- 小于 -->
							</option>
							<option value="4">
								<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003d") %><!-- 小于或等于 -->
							</option>
							<option value="5">
								<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %><!-- 等于 -->
							</option>
							<option value="6">
								<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e") %><!-- 不等于 -->
							</option>
						</select>
					</td>

					<%
						StringBuffer sb1 = new StringBuffer("");
										sb1
												.append("<td class='FieldValue'>\n\r <button  type=button class=Calendar onclick=\"javascript:gettime('con"
														+ _fieldid
														+ "_value1','con"
														+ _fieldid
														+ "span2','0');\"></button>");
										sb1.append("\n\r<input type=\"hidden\" name=\"con"
												+ _fieldid + "_value1\" value=\"" + _value
												+ "\"  " + _style + "  >");
										sb1.append("\n\r<span id=\"con" + _fieldid
												+ "span2\" name=\"field_" + _fieldid
												+ "span\" >");
										sb1.append(_value);
										sb1.append("</span>\n\r</td>");
										out.print(sb1.toString());
									}
					%>
					<%
						} else if (htmltype.equals("2")) {//多行文本
					%>
					<td class="FieldValue">
						<select class=inputstyle name="con<%=id%>_value_opt"
							style="width: 100%">
							<option value="5">
								<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %><!-- 等于 -->
							</option>
							<option value="6">
								<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e") %><!-- 不等于 -->
							</option>
							<option value="7">
								<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002c") %><!-- 包含 -->
							</option>
							<option value="8">
								<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002f") %><!-- 不包含 -->
							</option>
						</select>
					</td>
					<td colspan=3 class="FieldValue">
						<TEXTAREA ROWS="" COLS="50" name="con<%=id%>_value"
							onchange="addfield('con<%=id%>_value')" style="width: 100%"></TEXTAREA>
					</td>
					<%
						} else if (htmltype.equals("4")) {//check框
					%>

					<td class="FieldValue">
						<INPUT TYPE="checkbox" NAME="con<%=id%>_value"
							onchange="addfield('con<%=id%>_value')" value="1"
							onclick="gray(this)">
					</td>
					<%
						} else if (htmltype.equals("5")) {//选择项

									SelectitemService selectitemService = (SelectitemService) BaseContext
											.getBean("selectitemService");
									List list = selectitemService.getSelectitemList(type,
											null);
									StringBuffer sb = new StringBuffer("");
									sb.append("<input type=\"hidden\" name=\"field_"
											+ _fieldid + "_fieldcheck\" value=\""
											+ _fieldcheck + "\" >");
									sb
											.append("<td class='FieldValue'>\n\r <select class=\"InputStyle2\" id=\"con"
													+ _fieldid
													+ "_value\"  name=\"con"
													+ _fieldid
													+ "_value\" "
													+ _style
													+ "  onchange=\"fillotherselect(this,'"
													+ _fieldid + "'," + "-1" + ")\"  >");
									String _isempty = "";
									if (StringHelper.isEmpty(_value))
										_isempty = " selected ";
									sb.append("\n\r<option value=\"\" " + _isempty
											+ " ></option>");
									for (int i = 0; i < list.size(); i++) {
										Selectitem _selectitem = (Selectitem) list.get(i);
										String _selectvalue = StringHelper
												.null2String(_selectitem.getId());
										String _selectname = StringHelper
												.null2String(_selectitem.getObjname());
										String selected = "";
										if (_selectvalue.equalsIgnoreCase(StringHelper
												.null2String(_value)))
											selected = " selected ";
										sb.append("\n\r<option value=\"" + _selectvalue
												+ "\" " + selected + " >" + _selectname
												+ "</option>");
									}
									sb.append("</select>\n\r</td> ");
									out.print(sb.toString());

								} else if (htmltype.equals("6")) { // 关联选择

									RefobjService refobjService = (RefobjService) BaseContext
											.getBean("refobjService");
									Refobj refobj = refobjService.getRefobj(type);
									if (type != null && refobj != null) {

										if (type.equals("402881e60bfee880010bff17101a000c")) {
					%>
					<td class="FieldValue">
						<select class=inputstyle name="con<%=id%>_value_opt">
							<option value="5">
								<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %><!-- 等于 -->
							</option>
							<option value="9">
								<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003e") %><!-- 从属于 -->
							</option>
							<option value="10">
								<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003f") %><!-- 不从属于 -->
							</option>
						</select>
					</td>
					<%
						}
										String _refid = StringHelper.null2String(refobj
												.getId());
										String _refurl = StringHelper.null2String(refobj
												.getRefurl());
										String _viewurl = StringHelper.null2String(refobj
												.getViewurl());
										String _reftable = StringHelper.null2String(refobj
												.getReftable());
										String _keyfield = StringHelper.null2String(refobj
												.getKeyfield());
										String _viewfield = StringHelper.null2String(refobj
												.getViewfield());
										Integer _multi = refobj.getIsmulti();		
										String showname = "";
										if(_multi == null || _multi == 0){
											String getMultiSql = "select id from refobj where isforwarn = 1 and reftable = '"+_reftable+"' and keyfield = '"+_keyfield+"' and viewfield = '"+_viewfield+"' and (isdelete is null or isdelete < 0) and ismulti = 1";
											List lsit = dataService.getValues(getMultiSql);
											if(!lsit.isEmpty() && lsit.size() == 1){
												Map refMap = (Map)lsit.get(0);
												_refid = (String)refMap.get("id");
											} else if(lsit.isEmpty()) {
												getMultiSql = "select id from refobj where reftable = '"+_reftable+"' and keyfield = '"+_keyfield+"' and viewfield = '"+_viewfield+"' and (isdelete is null or isdelete < 0) and ismulti = 1";
											    lsit = dataService.getValues(getMultiSql);
											    if(!lsit.isEmpty() && lsit.size() == 1){
													Map refMap = (Map)lsit.get(0);
													_refid = (String)refMap.get("id");
												}
											}
										}
										if (!StringHelper.isEmpty(_value)) {
											String sql = "select " + _keyfield
													+ " as objid," + _viewfield
													+ " as objname from " + _reftable
													+ " where " + _keyfield + " in("
													+ StringHelper.formatMutiIDs(_value)
													+ ")";
											
											List valuelist = dataService.getValues(sql);
											for (int i = 0; i < valuelist.size(); i++) {
												Map refmap = (Map) valuelist.get(i);
												String _objid = StringHelper
														.null2String((String) refmap
																.get("objid"));
												String _objname = StringHelper
														.null2String((String) refmap
																.get("objname"));
												if (!StringHelper.isEmpty(_viewurl))
													showname += "&nbsp;&nbsp;<a href=\""
															+ _viewurl + _objid
															+ "\" target=\"_blank\" >";
												showname += _objname;
												if (!StringHelper.isEmpty(_viewurl))
													showname += "</a>";
											}
										}

										StringBuffer sb = new StringBuffer("");
										sb
												.append("<td class='FieldValue'> \n\r<button  type=button class=Browser onclick=\"javascript:getrefobj('con"
														+ _fieldid
														+ "_value','field_"
														+ _fieldid
														+ "span','"
														+ _refid
														+ "','"
														+ _viewurl
														+ "','0');\"></button>");
										sb.append("\n\r<input isbrowser=\"1\" type=\"hidden\" name=\"con"
												+ _fieldid + "_value\" value=\""
												+ _value.trim() + "\"  " + _style + "  >");
										sb.append("\n\r<span id=\"field_" + _fieldid
												+ "span\" name=\"field_" + _fieldid
												+ "span\" >");
										sb.append(showname);
										sb.append("</span>\n\r</td> ");
										out.print(sb.toString());

									}
								}

							}
						}
					%>
				</tr>

			</table>



		</FORM>
		<SCRIPT LANGUAGE=VBS>
sub onShowMultiPropValue(objval,inputname)
	tmp = document.all(inputname&"_value").value
	fieldname = document.all(inputname+"_fieldname").value
	objtablename = document.all(inputname+"_objtablename").value
	id1 = window.showModalDialog("<%=request.getContextPath()%>/systeminfo/BrowserMain.jsp?url=<%=request.getContextPath()%>/props/data/PropValueBrowser.jsp?sqlwhere= where propid="&objval&"&resourceids="&tmp)
	if (Not IsEmpty(id1)) then
	if id1(0)<> "" then
		alert(inputname)
		propvalueids = id1(0)
		propvaluenames = id1(1)
		sHtml = propvaluenames
		document.all(inputname&"_value").value= propvalueids

		document.all(inputname&"_valuespan").innerHtml = sHtml
		document.all(inputname&"_name").value= sHtml
		addfield(inputname)	
	else 
		document.all(inputname&"_value").value= ""
		document.all(inputname&"_name").value= ""
		document.all(inputname&"_valuespan").innerHtml = ""
	end if
	end if
end sub

</script>

	</BODY>
</HTML>
<script language=vbs>


sub getdate(inputname,spanname,isneed)
	returnvalue = window.showModalDialog("<%=request.getContextPath()%>/plugin/calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	if (Not IsEmpty(returnvalue)) then
		document.all(inputname).value = returnvalue
		document.all(spanname).innerHtml = returnvalue
		if (returnvalue="" and isneed="1") then
			document.all(spanname).innerHtml = "<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>"
		end if
		addfield(inputname)	
	end if
end sub
sub gettime(inputname,spanname,isneed)
	returnvalue = window.showModalDialog("<%=request.getContextPath()%>/plugin/clock.jsp",,"dialogHeight:320px;dialogwidth:275px")

	if (Not IsEmpty(returnvalue)) then
		document.all(inputname).value = returnvalue
		document.all(spanname).innerHtml = returnvalue
		if (returnvalue="" and isneed="1") then
			document.all(spanname).innerHtml = "<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>"
		end if
	addfield(inputname)	
	end if
end sub
</script>


<SCRIPT language=VBS>

Sub oc_CurrentMenuOnMouseOut(icount)
    document.all("oc_divMenuDivision"&icount).style.visibility = "hidden"
End Sub

Sub oc_CurrentMenuOnClick(icount)
    document.all("oc_divMenuDivision"&icount).style.visibility = ""
End Sub
</SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
    function getrefobj(inputname,inputspan,refid,viewurl,isneed){
	var id;
    try{
    id=window.showModalDialog('<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+refid);
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
		document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }
<!--
function onSubmit(){
   	checkfields="";
   	checkmessage="<%=labelService
							.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
   	}
}

var allfield = new Array();
var allfieldStr="";
function addfield(input){
	document.all("check_" + input.substr(0,input.indexOf("_value"))).checked=true;
	
	var len = allfield.length;
	if(allfieldStr.indexOf(input)==-1){
		allfield[len]=input;
		allfieldStr+=input;
	}
}

function addfield2(input){
	if(document.all("check_" + input.substr(0,input.indexOf("_value"))).checked){
		var len = allfield.length;
		if(allfieldStr.indexOf(input)==-1){
			allfield[len]=input;
			allfieldStr+=input;
		}
	}
}
function setCondition2(){

	document.all("conditions").value="";
	var condition="";
	var conditiontext = "";
	for(var i=0; i<allfield.length; i++){
		var input = allfield[i];
		var fieldname = document.all(input + "_fieldname").value;
		var field = document.all(input + "_field");
		var objtable = document.all(input + "_objtablename");

		var fieldv = document.all(input + "_fieldid");
		var fieldid = "";
		if(fieldv){
			fieldid = fieldv.value
		};
		var fieldtext = "";
		if(field){
			fieldtext = field.innerText;
		}
		//var objtabletext = objtable.options[objtable.selectedIndex].text;
		var objtablename = document.all(input + "_objtablename").value;		
		if(document.all("check_" + input.substr(0,input.indexOf("_value"))).checked){
			fieldname = objtablename + '.' + fieldname;
			var opt="=";
			var ele = document.all(input);
			var isbrowser = ele.isbrowser;
			var spanele = document.getElementById('field_' + fieldid + 'span');
			var value= ele.value;
            var tagname = ele.tagName;
            var text = value;
            if(tagname == 'SELECT') {
            	text = ele.options[ele.selectedIndex].text
            } else if (spanele) {
            	text = spanele.innerText;
            }
			if(document.all(input+ "_opt")){
				if(document.all(input+ "_opt").value=="1"){
					opt=">";
                    condition =  fieldname + opt + " '" + Trim(value) + "' and ";
                   conditiontext =  fieldtext + "<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002f") %>" + " '" + Trim(text) + "' <%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be60067") %> ";//大于   且
				}else if(document.all(input+ "_opt").value=="2"){
					opt=">=";
                    condition =  fieldname + opt + " '" + Trim(value) + "' and ";
                    conditiontext =  fieldtext + "<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf280030") %>" + " '" + Trim(text) + "' <%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be60067") %> ";//大于等于   且
				}else if(document.all(input+ "_opt").value=="3"){
					opt="<";
                    condition =  fieldname + opt + " '" + Trim(value) + "' and ";
                    conditiontext =  fieldtext + "<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002c") %>" + " '" + Trim(text) + "' <%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be60067") %> ";//小于
				}else if(document.all(input+ "_opt").value=="4"){
					opt="<=";
                    condition =  fieldname + opt + " '" + Trim(value) + "' and ";
                    conditiontext =  fieldtext + "<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002d") %>" + " '" + Trim(text) + "' <%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be60067") %> ";//小于等于
				}else if(document.all(input+ "_opt").value=="5"){
					opt="=";
                    condition =  fieldname + opt + " '" + Trim(value) + "' and ";
                    conditiontext =  fieldtext + "<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %>" + " '" + Trim(text) + "' <%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be60067") %> ";//等于
				}else if(document.all(input+ "_opt").value=="6"){
					opt="<>";
                    condition =  fieldname + opt + " '" + Trim(value) + "' and ";
                    conditiontext =  fieldtext + "<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e") %>" + " '" + Trim(text) + "' <%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be60067") %> ";//不等于
				}else if(document.all(input+ "_opt").value=="7"){
					opt=" like ";
                    condition =  fieldname + opt + " '" + Trim(value) + "' and ";
                    conditiontext =  fieldtext + "<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002c") %>" + " '" + Trim(text) + "' <%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be60067") %> ";//包含
				}else if(document.all(input+ "_opt").value=="8"){
					opt=" not like ";
                    condition =  fieldname + opt + " '" + Trim(value) + "' and ";
                    conditiontext =  fieldtext + "<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002f") %>" + " '" + Trim(text) + "' <%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be60067") %> ";//不包含
				}else if(document.all(input+ "_opt").value=="9"){
					opt=" &&";
                    condition =  "["+fieldname + opt + " '" + Trim(value) + "'] and ";
				}else if(document.all(input+ "_opt").value=="10"){
					opt=" ##";
                    condition =  "["+fieldname + opt + " '" + Trim(value) + "'] and ";
				}
			}else{
			    if(isbrowser == 1){
			    	if(value) {
			    	    var tempconditon = "";
			    		var vs = value.split(',');
			    		for(var ii = 0; ii < vs.length; ii++){
			    			var v = vs[ii];
			    			if(ii == 0){
			    				tempconditon +="(";
			    			}
			    			tempconditon += fieldname + " like '%" + Trim(v) + "%'";
			    			if(ii < vs.length - 1){
			    				tempconditon +=" or "; 
			    			} else {
			    				tempconditon +=" ) ";
			    			}
			    			//alert(tempconditon);
			    		}
			    		condition = tempconditon + " and ";;
			    		conditiontext =  fieldtext + "<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %>" + " '" + Trim(text) + "' <%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be60067") %> ";//等于
			    	}
			    } else {
			    	condition =  fieldname + "='" + Trim(value) + "' and ";
			    	 conditiontext =  fieldtext + "<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %>" + " '" + Trim(text) + "' <%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be60067") %> ";//等于
			    }
				
				
			}
			//alert(condition);
			if(document.all("conditions").value.indexOf(objtablename)== -1){
				if(document.all("conditions").value.indexOf("and")!=-1){
					document.all("conditions").value = document.all("conditions").value.substr(0,document.all("conditions").value.lastIndexOf("and"));
				}
				document.all("conditions").value += ") and (";
			}
			document.all("conditions").value += condition;		
			document.all("conditiontext").value += conditiontext;	
			//alert('www : ' + document.all("conditions").value);			
		}
	}
	var conditions2 = document.all("conditions").value;
	var conditionstext2 = document.all("conditiontext").value;
	//galert(conditions2);
	if(conditions2.indexOf("and")== -1){
		document.all("conditions").value = conditions2;
	}else{
		document.all("conditiontext").value = conditionstext2.substr(0,conditionstext2.lastIndexOf("<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be60067") %>")-1) + "";//且
		document.all("conditions").value = conditions2.substr(1,conditions2.lastIndexOf("and")-1) + ")";
	}
}

function browser_onclick(){
	var conditions = document.all("conditions").value;
	var conditiontext = document.all("conditiontext").value;
	
	var rvalue = new Array(conditions,conditiontext);
	window.parent.returnValue = rvalue;
    window.parent.close();
}

function onChangeShareType(){
	var id = document.all("formname").value;
	var len=document.all("formname").length;
	for(var i=1; i<len; i++){
		var tempid = document.all("formname")[i].value;
		if(tempid==id){
			document.all(tempid).style.display = '';
		}else{
			document.all(tempid).style.display = 'none';
		}
	}	
}
function isDigit(s)
{
var patrn=/^[0-9]{1,20}$/;
if (!patrn.exec(s)) return false
return true
} 

function fillotherselect(elementobj,fieldid,rowindex){
	addfield("con" +fieldid + "_value");
	
	var elementvalue = Trim(getValidStr(elementobj.value));//选择项的值


	var objname = "field_"+fieldid+"_fieldcheck";
	
	var fieldcheck = Trim(getValidStr(document.all(objname).value));//用于保存选择项子项的值(formfieldid)
		
	if(fieldcheck=="")
		return;
		
//	DataService.getValues(createList(fieldcheck,rowindex),"select id,objname from selectitem where pid = '"+elementvalue+"'");
	var sql = "select ''  id,' '  objname union (select id,objname from selectitem where pid = '"+elementvalue+"')";
	<%if (dbtype.equals("2")) {%> sql = "select ''  id,' '  objname from dual union (select id,objname from selectitem where pid = '"+elementvalue+"')"; <%}%>

	DataService.getValues(sql,{          
      callback:function(dataFromServer) {
        createList(dataFromServer, fieldcheck,rowindex);
      }
   }
	);
   	
}
    function createList(data,fieldcheck,rowindex)
	{
		var select_array =fieldcheck.split(",");
		for(loop=0;loop<select_array.length;loop++){
			var objname = "con"+select_array[loop]+"_value";
			if(rowindex != -1)
				objname += "_"+rowindex;
			
			if(document.getElementById(objname) == null){
				return;
			}

			DWRUtil.removeAllOptions(objname);
		    DWRUtil.addOptions(objname, data,"id","objname");
		    fillotherselect(document.all(objname),select_array[loop],rowindex);
		}
	}
//-->
</SCRIPT>
<script type="text/javascript">
             function gray(obj)
{
switch(obj.flag)
{
//当flag为0时,为未选中状态(找出为空的数据)
case '0':obj.checked=true;obj.indeterminate=true;obj.flag='2';
      obj.value='2';
    break;
//当flag未1时,为白色选中状态
case '2':obj.checked=true;obj.indeterminate=false;obj.flag='1';
        obj.value='1';
    break;
//当flag为2时,为灰色选中状态  (找出所有的数据)
case '1':obj.checked=false;obj.indeterminate=false;obj.flag='0';
    obj.value='0';
    break;
}
}
</script>
