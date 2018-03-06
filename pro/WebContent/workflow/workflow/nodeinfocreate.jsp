<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>

<%
  String workflowid = StringHelper.null2String(request.getParameter("workflowid"));
  WorkflowinfoService workflowinfoService = (WorkflowinfoService) BaseContext.getBean("workflowinfoService");
  NodeinfoService nodeinfoService = (NodeinfoService) BaseContext.getBean("nodeinfoService");
  FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
  Formfield formfield = new Formfield();
  Workflowinfo workflowinfo = workflowinfoService.get(workflowid);
  List filedList = formfieldService.getAllFieldByFormId(workflowinfo.getFormid());
  Nodeinfo tempNode = new Nodeinfo();
  SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
Selectitem selectitem = null;
List selectitemlist = selectitemService.getSelectitemList("4028819d0e521bf9010e5237454d000a",null);
%>


<html>
  <head> 

  </head>
  
  <body>
		<%pagemenustr += "{S," + labelService.getLabelName("402881e60aabb6f6010aabbda07e0009") + ",javascript:onSubmit()}";%>
		<div id="pagemenubar" style="z-index:100;"></div>
		<%@ include file="/base/pagemenu.jsp"%>
		<!--页面菜单结束-->
		<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.NodeinfoAction?action=create" name="EweaverForm" method="post">
			<table class=noborder>
				<colgroup>
					<col width="30%">
					<col width="70%">
				</colgroup>		
				<tr class=Title>
					<th colspan=2 nowrap>
						<%=labelService.getLabelName("402881ee0c715de3010c725ffd4b00ae")%><!-- 节点信息-->
					</th>
				<!-- 流程信息 -->
				</tr>
				<tr>
					<td class="Line" colspan=2 nowrap></td>
				</tr>		
				<tr><!--  节点名称 -->
					<td class="FieldName" nowrap>
                          <%=labelService.getLabelName("402881ee0c715de3010c7248aaad0072")%>
					</td>
					<td class="FieldValue">
					   <input type="text" class="InputStyle2" style="width=50%" name="objname" onChange="checkInput('objname','objnamespan')"/>
					   <span id="objnamespan"/><img src=<%=request.getContextPath()%>/images/base/checkinput.gif></span>
					</td>
				</tr>	
				<tr><!--  所属流程 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c7249ba5b0078")%>

					</td>
					<td class="FieldValue">
					   <input type="hidden"  name="workflowid" value="<%=workflowid%>"/>
					   <span id="workflowidspan"><%=StringHelper.null2String(workflowinfo.getObjname())%></span>					
					</td>
				</tr>		
				<tr><!--  节点类型 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c724923d40075")%>
					</td>
					<td class="FieldValue">
					   <select class="InputStyle2" name="nodetype" id="nodetype" onChange="javascript:nodeTypechange()">
					      <option value="1"><%=labelService.getLabelName("402881ee0c765f9b010c76779a340007")%></option> <!--  开始节点 -->
					      <option value="2" selected><%=labelService.getLabelName("402881ee0c765f9b010c7679ec06000a")%></option><!--  活动节点 --> 
					      <option value="3"><%=labelService.getLabelName("402881ee0c765f9b010c767a6e22000d")%></option><!--  子过程活动节点 --> 
					      <option value="4"><%=labelService.getLabelName("402881ee0c765f9b010c767adf440010")%></option> <!--  结束节点 -->
					   </select>
					</td>
				</tr>	
				<tr id = "isrejecttr"><!--  是否允许退回 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c72661f7b00b1")%>

					</td>
					<td class="FieldValue">
					   <input type='checkbox' name='isreject' value='1'  />
					</td>
				</tr>	
				<tr id="rejectnodetr" ><!--  退回节点 -->
					<td class="FieldName" nowrap>
                          <%=labelService.getLabelName("402881ee0c715de3010c726689d800b4")%>

					</td>
					<td class="FieldValue">
					    <% 
					      List nodelist = nodeinfoService.getNodelistByworkflowid(workflowid);
					      Iterator it = nodelist.iterator();
					    %>
						 <select class="inputstyle2"  name="rejectnode" id="rejectnode" onChange="">
					        <option value="" selected></option> 
					        <% 
					          while(it.hasNext()){
					             tempNode = (Nodeinfo) it.next();
					          %>
					        <option value="<%=StringHelper.null2String(tempNode.getId())%>"><%=StringHelper.null2String(tempNode.getObjname())%></option> 
			                <%
			                  }
			                %>
					      </select>								
					</td>
				</tr>				
				<tr id ="refworkflowidytr" style="display:none"><!--  相关流程 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c726721e600b7")%>
					</td>
					<td class="FieldValue">
					   <button  type="button" class=Browser onclick="javascript:getBrowser('/workflow/workflow/workflowinfobrowser.jsp','refworkflowid','refworkflowidspan','0');"></button>
					   <input type="hidden"  name="refworkflowid" />
					   <span id="refworkflowidspan"/></span>					
					</td>
				</tr>								
				<tr id="refnodeidtr"  style="display:none"><!--  相关节点 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c726d004b00ba")%>
					</td>
					<td class="FieldValue">
					   <button  type="button" class=Browser onclick="javascript:getBrowser('/workflow/workflow/nodeinfobrowser.jsp','refnodeid','refnodeidspan','0');"></button>
					   <input type="hidden"  name="refnodeid" />
					   <span id="refnodeidspan"/></span>					
					</td>
				</tr>				
				<tr id = "outmappingtr"  style="display:none"><!--输出参数列表关系   -->
					<td class="FieldName" nowrap>
                        <%=labelService.getLabelName("402881ee0c715de3010c726e131a00bd")%>  
					</td>
					<td class="FieldValue">
					<TEXTAREA STYLE="width=100%" class=InputStyle rows=5 name="outmapping"></TEXTAREA>					
					</td>
				</tr>							
				<tr  id="inmappingtr" style="display:none"><!--输入参数列表关系   -->
					<td class="FieldName" nowrap>
                        <%=labelService.getLabelName("402881ee0c715de3010c726e7f7600c0")%>
					</td>
					<td class="FieldValue">
					<TEXTAREA STYLE="width=100%" class=InputStyle rows=5 name="inmapping"></TEXTAREA>					
					</td>
				</tr>	
				<tr><!--前驱转移关系   -->
					<td class="FieldName" nowrap>
                           <%=labelService.getLabelName("402881ee0c715de3010c726f352b00c3")%> 
					</td>
					<td class="FieldValue">
						  <select class="inputstyle2"  name="jointype" id="jointype" onChange="">
					        <option value=""></option> 
					        <option value="1"><%=labelService.getLabelName("402881ee0c765f9b010c7680a68a0013")%></option> <!--同步聚合（AND）   -->
					        <option value="2"><%=labelService.getLabelName("402881ee0c765f9b010c768131e20016")%></option> <!--异或聚合（XOR）   -->
					      </select>
					</td>
				</tr>	
				<tr><!--后驱转移关系   -->
					<td class="FieldName" nowrap>
                           <%=labelService.getLabelName("402881ee0c715de3010c726ff28100c6")%> 
					</td>
					<td class="FieldValue">
						  <select class="inputstyle2"  name="splittype" id="splittype" onChange="">
					        <option value=""></option> 
					        <option value="1"> <%=labelService.getLabelName("402881ee0c765f9b010c76839db80019")%></option> <!--并行（AND）   -->
					        <option value="2"><%=labelService.getLabelName("402881ee0c765f9b010c7684248f001c")%></option>  <!--异或（XOR） -->
					      </select>
					</td>
				</tr>		
				<tr><!--  节点预处理页面 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c72730a8a00c9")%>

					</td>
					<td class="FieldValue">
						<button  type="button" class=Browser onclick="javascript:getJspBrowser('/workflow/workflow/extendjsp.jsp?type=pre&workflowid=<%=workflowid%>&filename='+document.all('perpage').value,'perpage','perpagespan','0')"></button>
						<input type="hidden" name="perpage" value=""/>
						<span id="perpagespan"/></span>
					</td>
				</tr>				
				<tr><!--  节点后处理页面 -->
					<td class="FieldName" nowrap>
                          <%=labelService.getLabelName("402881ee0c715de3010c72746e5300cc")%>

					</td>
					<td class="FieldValue">
						<button  type="button" class=Browser onclick="javascript:getJspBrowser('/workflow/workflow/extendjsp.jsp?type=aft&workflowid=<%=workflowid%>&filename='+document.all('afterpage').value,'afterpage','afterpagespan','0')"></button>
						<input type="hidden" name="afterpage" value=""/>
						<span id="afterpagespan"/></span>
					</td>
				</tr>	
				<tr><!-- 提醒类型 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("4028819d0e521bf9010e525d08b70010")%><!-- 提醒类型-->
					</td>
					<td  class="FieldValue">
                       <select  class="inputstyle"  name="remindtype" id="remindtype" onChange="javascript:changeType()"> 
                       <option value=""><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2b006a") %><!-- 流程提醒 --></option>
                       <%for(int i=0;i<selectitemlist.size();i++){
                       selectitem=(Selectitem)selectitemlist.get(i);
                       if(!selectitem.getId().equals("4028819d0e521bf9010e5238bec2000d")){
                       %>
					   <option value="<%=selectitem.getId()%>" >
						<%=selectitem.getObjname()%>
					   </option>
					   <%}}%>
                       </select>
					</td>
				</tr>	
				<tr id="ismail" style="display:none"><!--  是否邮件提醒 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c7274e72000cf")%>
					</td>
					<td class="FieldValue">
					   <input type='checkbox' name='isemail' value='1'  /><!-- onClick="javascript:onCheck('isemail')"-->
					</td>
				</tr>				
				<tr id="emailmodeltr"  style="display:none"><!--  邮件模板 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c727606f600d2")%>
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width=50%" name="emailmodel" />
					</td>
				</tr>											
				<tr id="isims" style="display:none"><!--  是否短消息提醒 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c72766b6b00d5")%>

					</td>
					<td class="FieldValue">
					   <input type='checkbox' name='issms' value='1'  /><!-- onClick="javascript:onCheck('issms')"-->
					</td>
				</tr>							
				<tr id="msgmodeltr"  style="display:none"><!--  消息模板 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c7276cf0e00d8")%>
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width=50%" name="msgmodel" />
					</td>
				</tr>				
				<tr id="isrtxtr" style="display:none"><!--  是否rtx提醒 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c727750bb00db")%>
					</td>
					<td class="FieldValue">
					   <input type='checkbox' name='isrtx' value='1' onClick="javascript:onCheck('isrtx')" />
					</td>
				</tr>
				<tr><!--  是否会签 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2b006b") %><!-- 是否会签 -->
					</td>
					<td class="FieldValue">
					   <input type='checkbox' name='huiqian' value='0' onClick="javascript:onCheck('huiqian')" />
					</td>
				</tr>	
				<tr><!--  是否自动流转 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2b006c") %><!-- 是否自动流转 -->
					</td>
					<td class="FieldValue">
					   <input type='checkbox' name='isautoflow' value="0" onClick="javascript:onCheck('isautoflow')"/>
					</td>
				</tr>	
				<tr><!--  表单扩展页面 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2b006d") %><!-- 扩展页面 -->
					</td>
					<td class="FieldValue">
					   <input type="text" class="InputStyle2" style="width=50%" name='nodeextpage' value=""/>
					</td>
				</tr>	
				<tr><!--  是否确定提醒 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2b006e") %><!-- 是否确定提醒 -->
					</td>
					<td class="FieldValue">
					   <input type='checkbox' name='ynawoke' value='1' onClick="javascript:onCheck('huiqian')" />
					</td>
				</tr>	
				<tr><!--  确定提醒信息 -->
					<td class="FieldName" nowrap>
                          <%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2b006f") %><!-- 确定提醒信息 -->
					</td>
					<td class="FieldValue">
					   <input type="text" class="InputStyle2" style="width=50%" name="awokeinfo"/>
					</td>
				</tr>	
				<tr><!--  保存按钮名称 -->
					<td class="FieldName" nowrap>
                          <%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2b0070") %><!-- 保存按钮名称 -->
					</td>
					<td class="FieldValue">
					   <input type="text" class="InputStyle2" style="width=50%" name="savebuttonname"/>
					</td>
				</tr>	
				<tr><!--  提交按钮名称 -->
					<td class="FieldName" nowrap>
                          <%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2b0071") %><!-- 提交按钮名称 -->
					</td>
					<td class="FieldValue">
					   <input type="text" class="InputStyle2" style="width=50%" name="submitbuttonname"/>
					</td>
				</tr>			
				<tr><!--  数据接口 -->
					<td class="FieldName" nowrap>
                          <%=labelService.getLabelName("402881e50cc049d2010cc04b80090006")%>
					</td>
					<td class="FieldValue">
					  <TEXTAREA STYLE="width=100%" class=InputStyle rows=5 name="datainterface"></TEXTAREA>
                      
					</td>
				</tr>
				<tr><!--  数据接口(退回调用) -->
					<td class="FieldName" nowrap>
                          <%=labelService.getLabelName("40288035251035db01251063ca760005")%>
					</td>
					<td class="FieldValue">
					  <TEXTAREA STYLE="width=100%" class=InputStyle rows=5 name="datainterface2"></TEXTAREA>

					</td>
				</tr>
				<tr><!--  是否允许打印 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2b0072") %><!-- 是否允许打印 -->
					</td>
					<td class="FieldValue">
					   <input type='checkbox' name='isprint'/>
					</td>
				</tr>
				<tr><!--  是否超时 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c7277d47200de")%>
					</td>
					<td class="FieldValue">
					   <input type='checkbox' name='istimeout' value='0' onClick="javascript:onCheck('istimeout')" />
					</td>
				</tr>				
			    <tr id="trisstamp"><!--  是否盖章 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2b0073") %><!-- 是否要盖章 -->
					</td>
					<td class="FieldValue">
					   <input type='checkbox' name='isstamp' value='0' onclick="onStampCheck()" />
					</td>
				</tr>
				<tr id="trisstamp"><!--  是否电子签章 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("402883e23c086242013c086248d90000") %><!-- 是否电子签章 -->
					</td>
					<td class="FieldValue">
					   <input type='checkbox' name='isISignatureHTML' value='1' />
					</td>
				</tr>
		  </table>	
	
                  <table id="timeouttable" style="display:none" class="noborder">
                  	<colgroup>
					   <col width="30%">
					   <col width="70%">
				    </colgroup>	
				      <tr><!--超时起始时间  -->
				    	<td class="FieldName" nowrap>
                              <%=labelService.getLabelName("402881ee0c715de3010c727914b600e4")%>
				    	</td>
					    <td class="FieldValue">
						  <select class="inputstyle2" name="timeoutstart"   id="timeoutstart" onChange="checkTime();">
					        <option value="0" selected><%=labelService.getLabelName("402881e70b65e2b3010b65e5e5fc0006")%></option> <!--提交时间  -->
					        <option value="1"><%=labelService.getLabelName("402881f00c7690cf010c7693133e0007")%></option> <!--接收时间  -->
					       <option value="2"> <%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2b0074") %></option> <!--指定时间  -->
					      </select>
					    </td>
				     </tr>	
  			    	<tr id ="timeoutunittr"><!--时间单位  -->
				    	<td class="FieldName" nowrap>
                              <%=labelService.getLabelName("402881ee0c715de3010c727854e900e1")%>
				    	</td>
					    <td class="FieldValue">
						  <select class="inputstyle2"  name="timeoutunit" id="timeoutunit" onChange="">
					        <option value="1"><%=labelService.getLabelName("402881ee0c765f9b010c76894378001f")%></option> <!--小时  --> 
					        <option value="2" selected><%=labelService.getLabelName("402881ee0c765f9b010c7689dac80022")%></option><!--天  -->  
					        <option value="3"><%=labelService.getLabelName("402881ee0c765f9b010c768a4f830025")%></option> <!--周  --> 
					        <option value="4"><%=labelService.getLabelName("402881ee0c765f9b010c768ac6960028")%></option> <!--月  --> 
					        <option value="5"><%=labelService.getLabelName("402881ee0c765f9b010c768b3338002b")%></option> <!--季度  --> 
					      </select>
					   </td>
				     </tr>	  

  			    	 <tr><!--超时时间类型  -->
				    	<td class="FieldName" nowrap>
                             <%=labelService.getLabelName("402881ee0c715de3010c727976fa00e7")%>
				    	</td>
					    <td class="FieldValue">
						  <select class="inputstyle2"  name="timeouttype" id="timeouttype" onChange="javascript:timeouttypeChange()">
					        <option value="0" selected><%=labelService.getLabelName("402881f00c7690cf010c76948617000a")%></option>  <!--常量  -->
					        <option value="1"><%=labelService.getLabelName("402881f00c7690cf010c7694fadc000d")%></option>  <!--变量  -->
					      </select>
					      <input type="text" style="display:''" class="InputStyle2" name="timeoutvalue" value=""/>
					    </td>
				     </tr>	
				     
				     <!--  字段？？？？？？？？？？ -->	
				     <tr id="timeoutfieldidtr" style="display:none"><!--超时变量 字段id  -->
				        <td class="FieldName" nowrap>
				             <%=labelService.getLabelName("402881ee0c715de3010c727bd46b00ea")%>
				        </td>
				        <td class="FieldValue">
				           <select class="inputstyle2"  name="timeoutfieldid"  id="timeoutfieldid" > 
				             <option value="" selected> </option> 
				             <%
				               Iterator fieldIt = filedList.iterator();
				               while(fieldIt.hasNext()){
				                 formfield = (Formfield)fieldIt.next();
				                 if (formfield!=null){
				             %>
				               <option value="<%=formfield.getId()%>"><%=StringHelper.null2String(formfield.getLabelname())%></option> 
				             
				             <%
				               }
				              }
				             %>
				             
				           </select> 
				        </td>
				     </tr>
  			    	 <tr><!--超时操作-->
				    	<td class="FieldName" nowrap>
                              <%=labelService.getLabelName("402881ee0c715de3010c727c31fd00ed")%>
				    	</td>
					    <td class="FieldValue">
						  <select class="inputstyle2"  name="timeoutopt"  id="timeoutopt" onChange="javascript:timeoutoptChange();">
					        <option value="0" selected><%=labelService.getLabelName("402881f00c7690cf010c7699453c0010")%></option> <!--忽略-->
					        <option value="1"><%=labelService.getLabelName("402881f00c7690cf010c7699c7e40013")%></option> <!--自动执行-->
					        <option value="2"><%=labelService.getLabelName("402881f00c7690cf010c769a2ba50016")%></option> <!--重定向-->
					       <option value="3"> <%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2b0075") %><!-- 忽略一次之后自动执行 --></option> <!--仅忽略一次-->					    
					      </select>
					      <span id="col2span" style="display:none" ><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2b0076") %><!-- 忽略和自动执行时间间隔(单位同上面的时间单位) -->				      
					      	<input type="text" class="InputStyle2" name="col2" id="col2" value=""/>					  
					    </span>
					    </td>
					 </tr>
				     <tr id="timeoutloadidtr" style="dispaly:none"><!--  重定向节点 -->
					  <td   class="FieldName" nowrap>
                             <%=labelService.getLabelName("402881ee0c715de3010c727cb58c00f0")%>

				      </td>
					  <td class="FieldValue">
					  	 <% 
					      List nodelist1 = nodeinfoService.getNodelistByworkflowid(workflowid);
					      Iterator it1 = nodelist.iterator();
					    %>
						 <select class="inputstyle2" style="dispaly:none" name="timeoutloadid" id="timeoutloadid" onChange="">
					        <option value="" selected></option> 
					        <% 
					          while(it1.hasNext()){
					             tempNode = (Nodeinfo) it1.next();
					          %>
					        <option value="<%=StringHelper.null2String(tempNode.getId())%>"><%=StringHelper.null2String(tempNode.getObjname())%></option> 
			                <%
			                  }
			                %>
					      </select>	
					  
					  </td>
				     </tr>					    		     		     			                   
                  </table>

          <table class="noborder">
            <colgroup>
               <col width="30%">
               <col width="70%">
            </colgroup>
				<tr><!--  是否超时 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2b0077") %><!-- 是否需要生成word文档 -->
					</td>
					<td class="FieldValue">
					   <input type='checkbox' name='hasworddoc' value="" onClick="javascript:onCheck('hasworddoc')" />
					</td>
				</tr>
		  </table>

                  <table id="worddoctable" style="display:none" class="noborder">
                  	<colgroup>
					   <col width="30%">
					   <col width="70%">
				    </colgroup>
				      <tr>
				    	<td class="FieldName" nowrap>
                             <%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b450000") %><!-- 流转公文word模板 -->
				    	</td>
					    <td class="FieldValue">
                            <button  type="button" class=Browser name="button_4028d80f19b18c860119b263878c0072" onclick="javascript:getBrowser('/document/base/wordmodulebrowser.jsp','wordmoduleid','wordmoduleidspan','1')"></button><input type="hidden" name="wordmoduleid" value=""  style='width: 288px; height: 17px'  ><span id="wordmoduleidspan" name="wordmoduleidspan" ></span>
                        </td>
                      </tr>
				      <tr>
				    	<td class="FieldName" nowrap>
                             <%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b450001") %><!-- 表单公文字段 -->
				    	</td>
					    <td class="FieldValue">
						<%
                          List list = formfieldService.getAllFieldByFormId(workflowinfo.getFormid());
					      Iterator itObj = list.iterator();
					    %>
						 <select class="inputstyle2" style="dispaly:none" name="wordmodulefield" id="wordmodulefield" onChange="">
					        <option value=""></option>
					        <%
					          while(itObj.hasNext()){
					             Formfield formfieldObj = (Formfield) itObj.next();
					          %>
					        <option value="<%=StringHelper.null2String(formfieldObj.getId())%>"><%=StringHelper.null2String(formfieldObj.getFieldname())%></option>
			                <%
			                  }
			                %>
					      </select>
                        </td>
				     </tr>
				      <tr>
				    	<td class="FieldName" nowrap>
                             <%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b450002") %><!-- 流转文档名称 -->
				    	</td>
					    <td class="FieldValue">
                            <input type="text" name="worddocname" value=""/>
					    </td>
				     </tr>
				      <tr>
				    	<td class="FieldName" nowrap>
                             <%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b450003") %><!-- 流转文档分类 -->
				    	</td>
					    <td class="FieldValue">
                        <button  type="button" class=Browser name="button_4028d80f19b18c860119b263878c0072" onclick="javascript:getBrowser('/base/category/categorybrowser.jsp','worddocurl','worddocurlspan','1')"></button><input type="hidden" name="worddocurl" value=""  style='width: 288px; height: 17px'  ><span id="worddocurlspan" name="worddocurlspan" ></span>
				     </tr>
                  </table>
		</form>
<script language="javascript">
function getBrowser(viewurl,inputname,inputspan,isneed){
    var id;
    try{
    id=openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
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
 }
function timeouttypeChange(){
  var timeouttype = document.all("timeouttype").value;
  var timeoutfieldidtr = document.getElementById("timeoutfieldidtr");//超时节点
  if (timeouttype=="0") {
    timeoutfieldidtr.style.display='none';
    document.all("timeoutfieldid").style.display='none'
    document.all("timeoutvalue").style.display='';
  }else if (timeouttype=="1") {
    timeoutfieldidtr.style.display='';
    document.all("timeoutfieldid").style.display=''
    document.all("timeoutvalue").style.display='none';
  }
}
function onStampCheck(){
   if(document.all("isstamp").checked){
      document.all("isstamp").value=1;
   }else{
      document.all("isstamp").value=0;
   }
}
function nodeTypechange(){
  var nodeType = document.all("nodetype").value;
  var isrejecttr = document.getElementById("isrejecttr");//是否允许回退
  var rejectnodetr = document.getElementById("rejectnodetr");//退回节点 
  var refworkflowidytr = document.getElementById("refworkflowidytr");//相关流程
  var refnodeidtr = document.getElementById("refnodeidtr");  //相关节点
  var outmappingtr = document.getElementById("outmappingtr"); //输出参数列表
  var inmappingtr = document.getElementById("inmappingtr"); //输入参数列表
  
  if (nodeType=="1") {  //开始节点
       document.all("trisstamp").style.display='none';
     isrejecttr.style.display='none';
     rejectnodetr.style.display='none';
     refworkflowidytr.style.display='none';
     refnodeidtr.style.display='none';
     outmappingtr.style.display='none';
     inmappingtr.style.display='none';
  }
  if (nodeType=="2") {
          document.all("trisstamp").style.display='block';
     isrejecttr.style.display='';
     rejectnodetr.style.display='';
     refworkflowidytr.style.display='none';
     refnodeidtr.style.display='none';
     outmappingtr.style.display='none';
     inmappingtr.style.display='none';  
  }
  if (nodeType=="3") {
        document.all("trisstamp").style.display='block';
     isrejecttr.style.display='none';
     rejectnodetr.style.display='none';
     refworkflowidytr.style.display='';
     refnodeidtr.style.display='';
     outmappingtr.style.display='';
     inmappingtr.style.display='';  
  }
  if (nodeType=="4") {
         document.all("trisstamp").style.display='block';
     isrejecttr.style.display='none';
     rejectnodetr.style.display='none';
     refworkflowidytr.style.display='none';
     refnodeidtr.style.display='none';
     outmappingtr.style.display='none';
     inmappingtr.style.display='none';  
  }  
 }
 
 //提醒类型
function changeType(){
	//var remindType = document.all("remindtype").value;
	//alert(remindType);
	var remindObj=document.getElementById("remindtype");
	var mailObj=document.getElementById("ismail");
	var imsObj=document.getElementById("isims");
	var rtxObj=document.getElementById("isrtxtr");
	mailObj.style.display ='none';
    imsObj.style.display ='none';
    rtxObj.style.display='none';
	if (remindObj.value=='4028819d0e521bf9010e5238bec2000e'){
    	mailObj.style.display ='';
    	imsObj.style.display ='';
    	rtxObj.style.display='';
  	}else{
    	document.all("isemail").checked = false;
    	document.all("issms").checked = false;
    	document.all("isrtx").checked = false;
  	}
}

function checkTime(){
	var timeoutstart =document.getElementById("timeoutstart");
	var timeoutunit  =  document.getElementById("timeoutunit");
	var timeoutunittr  =  document.getElementById("timeoutunittr");
    if (timeoutstart.value=="2"){
      timeoutunit.style.display ="none";
      timeoutunittr.style.display ="none";
    }else {
      timeoutunit.style.display ="";
      timeoutunittr.style.display ="";   
    }
}

function onCheck(checkName){ 

 //是否邮件
  if (checkName=="isemail") {
     var emailmodeltr = document.getElementById("emailmodeltr"); 
     if (document.all("isemail").checked){
       emailmodeltr.style.display='';
       document.all("isemail").value='1';
     }else{
       emailmodeltr.style.display='none';
       document.all("isemail").value='0';    
     } 
  }
//是否消息
  if (checkName=="issms"){
    var msgmodeltr = document.getElementById("msgmodeltr");
    if (document.all("issms").checked) {
       msgmodeltr.style.display='';
       document.all("issms").value='1';
    }else{
       msgmodeltr.style.display='none';
       document.all("issms").value='0';   
    }
    }
 //是否超时
  if (checkName=="istimeout"){
    var timeouttable = document.getElementById("timeouttable");
  var timeoutloadidtr = document.getElementById("timeoutloadidtr");
  var timeoutloadid = document.getElementById("timeoutloadid");
    if (document.all("istimeout").checked) {
       timeouttable.style.display = '';
       timeoutloadidtr.style.display ="none";
       timeoutloadid.style.display ="none";
       document.all("istimeout").value='1'; 
    }else{
       timeouttable.style.display = 'none';
       document.all("istimeout").value='0';       
    }  
  }
  //是否需要生成流转文档
  if (checkName=="hasworddoc"){
    var worddoctable = document.getElementById("worddoctable");
    if (document.all("hasworddoc").checked) {
       worddoctable.style.display = '';
       document.all("hasworddoc").value='1';
    }else{
       worddoctable.style.display = 'none';
       document.all("hasworddoc").value='0';
    }
  }
  if (checkName=="isrtx"){
   if (document.all("isrtx").checked) {
     document.all("isrtx").value='1';
    }else{
     document.all("isrtx").value='0';
    }
  }
  if (checkName=="huiqian"){
   if (document.all("huiqian").checked) {
     document.all("huiqian").value='1';
    }else{
     document.all("huiqian").value='0';
    }
  }
  if (checkName=="isautoflow"){
   if (document.all("isautoflow").checked) {
     document.all("isautoflow").value='1';
    }else{
     document.all("isautoflow").value='0';
    }
  }
} 
function timeoutoptChange(){
 var timeoutopt = document.all("timeoutopt").value;
  var timeoutloadidtr = document.getElementById("timeoutloadidtr");
  var timeoutloadid = document.getElementById("timeoutloadid");
   var col2span = document.getElementById("col2span");
  if (timeoutopt=="2"){
   // var timeoutloadidtr = document.getElementById("timeoutloadidtr");//重定向节点  
   timeoutloadidtr.style.display ="";
   timeoutloadid.style.display ="";
   col2span.style.display ="none";
  } else if(timeoutopt=="3"){
   timeoutloadidtr.style.display ="none";
   timeoutloadid.style.display ="none";
   col2span.style.display ="";
  } else {
  	 timeoutloadidtr.style.display ="none";
   	 timeoutloadid.style.display ="none";
   	 col2span.style.display ="none";
  }
}
function onSubmit(){
   	checkfields="objname";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
   	//	window.close();
   	}
}
</script>
  </body>
</html>
