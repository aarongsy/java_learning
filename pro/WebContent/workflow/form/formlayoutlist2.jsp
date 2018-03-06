<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.form.model.Formlayout"%>
<%@ page import="com.eweaver.workflow.form.service.FormlayoutService"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.workflow.util.FormLayoutTranslate"%>
<%@ page import="com.eweaver.base.Page"%>
<%@ page import="com.eweaver.workflow.workflow.model.Workflowinfo"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.workflow.workflow.service.WorkflowinfoService"%>
<%@ page import="com.eweaver.workflow.workflow.service.NodeinfoService"%>
<%@ page import="com.eweaver.workflow.workflow.model.Nodeinfo"%>
<%@ page import="com.eweaver.base.util.StringHelper"%>


<%//mjb********************************
		WorkflowinfoService workflowinfoService = (WorkflowinfoService) BaseContext.getBean("workflowinfoService");
		NodeinfoService nodeinfoService = (NodeinfoService) BaseContext.getBean("nodeinfoService");
		
		String workflowid = StringHelper.null2String(request.getParameter("workflowid"));
		Workflowinfo workflowinfo = workflowinfoService.get(workflowid);
		//获得一个流程的的所有节点



		List nodelist = nodeinfoService.getNodelistByworkflowid(workflowid);
		int rowsum=0; 
		

	//mjb********************************	

//String id=request.getParameter("forminfoid");
String id = workflowinfo.getFormid();

boolean bShowEditlayout = true;
boolean bShowViewlayout = true;
boolean bShowEditMobilelayout = true;
boolean bShowViewMobilelayout = true;
String strDefHql="from Formlayout where formid='"+id+"' and (nodeid is null or nodeid='" + workflowid + "') order by id desc";
List listdef = ((FormlayoutService)BaseContext.getBean("formlayoutService")).findFormlayout(strDefHql);
List list = new ArrayList();
list.addAll(listdef);
nodelist=nodeinfoService.findAll("from Nodeinfo where workflowid='" + workflowid + "'");
if(nodelist.size()>0){
    String listids = "";
    for (Object node : nodelist) {
        if (listids.equals(""))
            listids += "'" + ((Nodeinfo) node).getId() + "'";
        else
            listids += ",'" + ((Nodeinfo) node).getId() + "'";
    }
    if(!listids.equals("")) {
        String strHql = "from Formlayout  where formid='" + id + "' and nodeid in(" + listids + ") order by nodeid";
        List list2 = ((FormlayoutService) BaseContext.getBean("formlayoutService")).findFormlayout(strHql);
        list.addAll(list2);
    }

 }




//for(int i=0;i<list.size();i++)
//{
//    Formlayout formlayout=(Formlayout)list.get(i);
//	if(formlayout.getNodeid() == null && formlayout.getTypeid().intValue() == 2)
//		bShowEditlayout = false;
//	if(formlayout.getNodeid() == null && formlayout.getTypeid().intValue() == 1)
//		bShowViewlayout = false;
//}
%>

<html>
  <head>
  </head> 
  <body>
  
	<form action="" target="_self" name="layoutform"  method="post">
		<div id="menubar">
		
		<select class=inputstyle  name="curnode" id="curnode">
<option class=Inputstyle value="-1"><STRONG>************<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0016") %><!-- 请选择当前节点 -->**************</STRONG>


<%
							
						   Iterator nodeit= nodelist.iterator();
						   while (nodeit.hasNext()){
							  Nodeinfo nodeinfo =  (Nodeinfo)nodeit.next();
             
						%>
						   <option value=<%=nodeinfo.getId()%> ><%=nodeinfo.getObjname()%></option>	                   
						<%
						   } // end while
						%>

</select>

		<!-- 新增按钮 -->
		<% if(bShowEditlayout){ %>
		    <button type="button" class='btn' accessKey="E" onclick="{javascript:oncreateformlayout('/workflow/form/formlayoutinfo.jsp?layouttype=2&forminfoid=<%=id%>&workflowid=<%=workflowid%>');}">
				<U>E</U>--<%=labelService.getLabelNameByKeyId("402881ee0c715de3010c71e26c980030") %><!-- 编辑布局 --> 
		    </button>
		 <% }
		   if(bShowViewlayout){ %>
		    <button type="button" class='btn' accessKey="V" onclick="{javascript:oncreateformlayout('/workflow/form/formlayoutinfo.jsp?layouttype=1&forminfoid=<%=id%>&workflowid=<%=workflowid%>');}">
				<U>V</U>--<%=labelService.getLabelNameByKeyId("402881ee0c715de3010c71e2c1720033") %><!-- 显示布局 -->
		    </button>
		 <% }
		   if(bShowViewlayout){ %>
		    <button type="button" class='btn' accessKey="T" onclick="{javascript:oncreateformlayout('/workflow/form/formlayoutinfo.jsp?layouttype=3&forminfoid=<%=id%>&workflowid=<%=workflowid%>');}">
				<U>T</U>--<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0017") %><!-- 打印布局 -->
		    </button>
		 <%}
		 if(bShowEditMobilelayout){ %>
		    <button type="button" class='btn' accessKey="M" onclick="{javascript:oncreateformlayout('/workflow/form/mobileformlayoutinfo.jsp?layouttype=2&forminfoid=<%=id%>&workflowid=<%=workflowid%>');}">
				<U>M</U>--<%=labelService.getLabelNameByKeyId("4028833e3cebdc8b013cebdc8d370249") %><!-- 手机编辑布局 -->
		    </button>
		 <%}
		  if(bShowViewMobilelayout){ %>
		    <button type="button" class='btn' accessKey="N" onclick="{javascript:oncreateformlayout('/workflow/form/mobileformlayoutinfo.jsp?layouttype=1&forminfoid=<%=id%>&workflowid=<%=workflowid%>');}">
				<U>N</U>--<%=labelService.getLabelNameByKeyId("4028833e3cebdc8b013cebdc8d28020c") %><!-- 手机显示布局 -->
		    </button>
		 <%}%>
        </div>
			<table id="layoutTb">	
				<!-- 列宽控制 -->		
				<colgroup>
					<col width="35%">
					<col width="15%">
                    <col width="15%">
                    <col width="10%">
					<col width="10%">
					<col width="15%">
				</colgroup>
				<tr class="Header">
					<td><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0018") %><!-- 布局名称 --></td><!--应用对象 -->
                    <td><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0019") %><!-- 对应节点 --></td><!--节点名称 -->
                    <td><%=labelService.getLabelNameByKeyId("4028833e3cf159b9013cf159bbbc0230") %><!-- 支持客户端--></td><!--支持客户端 -->
					<td><%=labelService.getLabelName("402881ec0bdbf198010bdbf3ae300003")%></td><!--布局类型 -->
					<td><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a001a") %><!-- 是否默认 --></td>
                    <td><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0010") %><!-- 字段属性设置 --></td>
					<td style="text-align: center"><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39380074") %><!-- 动作 --></td>
				</tr>
				<%
			
					
					boolean isLight=false;
					String trclassname="";
				    for(int i=0;i<list.size();i++)
				    {
				        Formlayout formlayout=(Formlayout)list.get(i);
				        
						isLight=!isLight;
						if(isLight) trclassname="DataLight";
						else trclassname="DataDark";
				%>
				<tr class="<%=trclassname%>">
					<td  nowrap>
						<%if(formlayout.getLayoutname()!=null)%>
                            <%=formlayout.getLayoutname()%>
                    </td>
                    <td>
						<%
							String _outvalue = "";
							String nodeid = StringHelper.null2String(formlayout.getNodeid());
							if(!nodeid.equals("")){
								Nodeinfo nodeinfo = nodeinfoService.get(nodeid);
								String nodename = nodeinfo.getObjname();
								_outvalue = StringHelper.null2String(nodename);								
						
							}					
								//todo...显示相关的工作流和节点信息

						%>
                        <%=_outvalue%>
						<INPUT TYPE="hidden" id="nodetemp<%=i+1%>" value="<%=nodeid%>"/>
						<INPUT TYPE="hidden" id="nodetempvalue<%=i+1%>" value="<%=_outvalue%>"/>
						<INPUT TYPE="hidden" id="workflowtempvalue<%=i+1%>" value="<%=workflowinfo.getObjname() %>"/>
					</td>
					<td>
                        <%if(formlayout.getSupportedclient() == null || formlayout.getSupportedclient()==0){%>
                            <%=labelService.getLabelNameByKeyId("4028833e3cf15dbe013cf15dbe9d0257") %><!-- PC客户端-->
                        <%}else{%>
                            <%=labelService.getLabelNameByKeyId("4028833e3cf15dbe013cf15dbe9a01ee") %><!-- 手机客户端 -->
                        <%}%>
                    </td>
					<td nowrap>
						<%=FormLayoutTranslate.getLayoutById(formlayout.getTypeid().intValue())%>
						<INPUT TYPE="hidden" id="layouttemp<%=i+1%>" value="<%=FormLayoutTranslate.getLayoutById(formlayout.getTypeid().intValue())%>"/>
					</td>
                    <td>
                        <%if(formlayout.getIsdefault()!=null && formlayout.getIsdefault().intValue()>0){%>
                            <%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a000b") %><!-- 默认 -->
                        <%}else{%>
                            <%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a000c") %><!-- 非默认 -->
                        <%}%>
                    </td>
					<td><a href="javascript:onsetfieldstyle('/workflow/workflow/modifyfieldattribute.jsp?layoutid=<%=formlayout.getId()%>');"><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a001b") %><!-- 设置 --></a></td>
					<td nowrap>
						<%if(formlayout.getSupportedclient() == null || formlayout.getSupportedclient()==0){
						%>
							<a href="javascript:onmodifyformlayout('<%=request.getContextPath()%>/workflow/form/formlayoutinfo.jsp?forminfoid=<%=id%>&layoutid=<%=formlayout.getId()%>&nodeid=<%=formlayout.getNodeid()%>&workflowid=<%=workflowid%>','<%=StringHelper.filterJString2(formlayout.getLayoutname())%>');"><%=labelService.getLabelName("402881e60aa85b6e010aa85f6f3d0002")%></a>
						<%
						}else{
						%>
							<a href="javascript:onmodifyformlayout('<%=request.getContextPath()%>/workflow/form/mobileformlayoutinfo.jsp?forminfoid=<%=id%>&layoutid=<%=formlayout.getId()%>&nodeid=<%=formlayout.getNodeid()%>&workflowid=<%=workflowid%>','<%=StringHelper.filterJString2(formlayout.getLayoutname())%>');"><%=labelService.getLabelName("402881e60aa85b6e010aa85f6f3d0002")%></a>
						<%
						}%>
						&nbsp;&nbsp;
						<a href="javascript:onCloneFormlayout('<%=id%>','<%=formlayout.getId()%>');"><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a001c") %><!-- 复制 --></a>&nbsp;&nbsp;
						<a href="javascript:onDeleteFormlayout('<%=formlayout.getId()%>');"><%=labelService.getLabelName("402881e60aa85b6e010aa8624c070003")%></a>
					</td>
				</tr>
				<%
				}
				%>
			</table>
	</form>
  </body>
</html>

<script language="javascript">
 <!--
   function onSubmit(){
   	checkfields="tbname";
   	checkmessage='<%=labelService.getLabelName("297ee7020b338edd010b3390af720002")%>:<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>';
   	if(!checkForm(EweaverForm,checkfields,checkmessage)){
   		return false;
   	}
   	
   	document.EweaverForm.submit();
   }	
   
   function onsubmitLayout(url){
     document.location.href="<%=request.getContextPath()%>"+url;
   }
   
   function oncreateformfield(url){
   	var id=openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>"+url);
   	tab2.fireEvent("onclick");
   }
   	
   function oncreateformlink(url){
   	var id=openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>"+url);
   	tab3.fireEvent("onclick");
   }
   	
	function onmodifyformlayout(url,layoutName){
   		var getLayoutId=function(){
			return url.substring(url.indexOf('&layoutid=')+'&layoutid='.length,url.indexOf('&nodeid='));
		};
		url=contextPath+url;
		layoutName='<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a000e") %>'+(Ext.isEmpty(layoutName)?'':'['+layoutName+']');//修改布局
		//	top.onUrl(contextPath+url,layoutName,'modifyLayout_'+getLayoutId());
		window.open(url,'modifyLayout_'+getLayoutId());
	}

	function onCloneFormlayout(layoutid){
		var thisUrl = '<%=request.getContextPath()%>/workflow/form/formlayoutClone.jsp?forminfoid=<%=id%>&layoutid='+layoutid+'&nodeid=';
		if(document.getElementById('curnode').value=='-1'){
			if(!confirm('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a001d") %>')){//还没有选择复制布局所在的节点，是否继续？
				return;
			}
		}
		thisUrl +=document.getElementById('curnode').value;
		url=contextPath+thisUrl;
		window.open(url,'modifyLayout_'+layoutid);
	}
	   
	function onsetfieldstyle(url){
	 	var id=openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>"+ url,window,
				"dialogHeight: "+screen.availHeight+"; dialogWidth: "+screen.availWidth+"; center: Yes; help: No; resizable: yes; status: No");
	   	tab4.fireEvent("onclick");
	   	//document.location.href=url;
	}

   function oncreateformlayout(url){
   	var id=openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>"+ url + "&&nodeid=" + document.layoutform.curnode.value,window,
			"dialogHeight: "+screen.availHeight+"; dialogWidth: "+screen.availWidth+"; center: Yes; help: No; resizable: yes; status: No");
   	tab4.fireEvent("onclick");
   	
   }
	function checkselect(btname){
//		if(document.layoutform.curnode.value == -1){
//			alert("请选择一个节点...")
//			return false;
//		}else{
			var len = layoutTb.rows.length;
			var selectid = document.all("curnode").value;
			var i;
			for(i=1; i<len; i++){
			
				var nodeid = document.all("nodetemp" + i).value;
				var layoutname = document.all("layouttemp" + i).value;
				
				if(btname == layoutname && selectid == nodeid){
					alert("<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a001e") %>");//此节点的表单布局已经存在.....
					return false;
				}
			}
//		}
		return true;
	}
   
    function onDeleteFormfield(id){
	    if( confirm('<%=labelService.getLabelName("402881e90aac1cd3010aac1d97730001")%>')){
	    	
		var param=new Object();
		param.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.FormfieldAction?action=delete&id="+id;
		param.updatestring=id;		
		param.sourceurl=window.location.pathname;
		var result=showModalDialog("<%=request.getContextPath()%>/base/updatedialog.html", param,
			"dialogHeight: 80px; dialogWidth: 220px; center: Yes; help: No; resizable: yes; status: No");
			
	   	}
	   	
   		tab2.fireEvent("onclick");
   	}
    function onDeleteFormlink(id){
	    if( confirm('<%=labelService.getLabelName("402881e90aac1cd3010aac1d97730001")%>')){
	    	
		var param=new Object();
		param.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.FormlinkAction?action=delete&id="+id;
		param.updatestring=id;		
		param.sourceurl=window.location.pathname;
		var result=showModalDialog("<%=request.getContextPath()%>/base/updatedialog.html", param,
			"dialogHeight: 80px; dialogWidth: 220px; center: Yes; help: No; resizable: yes; status: No");
			
	   	}
	   	
   		tab3.fireEvent("onclick");
   	}

   	

 -->
 </script>
