<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.Page"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo" %>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.workflow.form.service.FormlinkService" %>
<%@ page import="com.eweaver.workflow.form.model.Formlink" %>
<%
   String selectItemId = StringHelper.trimToNull(request.getParameter("selectitemid"));
   SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
    ForminfoService forminfoService = (ForminfoService) BaseContext.getBean("forminfoService");
   List selectitemlist = selectitemService.getSelectitemList("402881e70c907630010c907aea350006",null);
   Selectitem selectitem;
    String moduleid=StringHelper.trimToNull(request.getParameter("moduleid"));
   HumresService humresService = (HumresService) BaseContext.getBean("humresService");
   String formid=StringHelper.null2String(request.getParameter("formid"));
    Forminfo forminfo=new Forminfo();
    String formspan="";
    String strimg="<img src=\""+request.getContextPath()+"/images/base/checkinput.gif\" align=absMiddle>";
    String objname=StringHelper.null2String(request.getParameter("objname"));
   if(!StringHelper.isEmpty(formid))
    {
     forminfo=forminfoService.getForminfoById(formid);
      formspan=forminfo.getObjname();
     strimg="";
   }
%>

<html>
  <head>
  <Style>
 	UL    { margin-left:22pt; margin-top:0em; margin-bottom: 0 }
   	UL LI {list-style-image: url('<%=request.getContextPath()%>/images/book.gif'); margin-bottom: 4}
</Style>
  </head> 
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/plugin/ajaxtabs/ajaxtabs.css" />
	<script type="text/javascript" src="<%=request.getContextPath()%>/plugin/ajaxtabs/ajaxtabs.js">
	</script>
	<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
	
  <body>
     
<ul id="maintab" class="shadetabs">
<li style="display:none" class="selected"><a id=tab1  href="#default" rel="ajaxcontentarea"><%=labelService.getLabelName("402881e50d8737b6010d87457ec2000c")%></a></li>
<li style="display:none"><a id=tab2  href="<%=request.getContextPath()%>/workflow/report/mreportcreate.jsp" rel="ajaxcontentarea"><%=labelService.getLabelName("402881e50d8737b6010d8744693b000a")%></a></li>
<li style="display:none"><a id=tab3  href="<%=request.getContextPath()%>/workflow/report/birtreportcreate.jsp" rel="ajaxcontentarea">BirtReport</a></li>
</ul>    
   

<div id="ajaxcontentarea" class="contentstyle">
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.report.servlet.ReportdefAction?action=create" name="EweaverForm" method="post">
<!--页面菜单开始-->     
<%
pagemenustr += "{S,"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+",javascript:onSubmit()}";
pagemenustr += "{B,"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+",javascript:goBack()}";
%>
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束-->    
<input type="hidden"  name="objtype2" value="workflow"/>
               <table class=noborder>
				<colgroup> 
					<col width="20%">
					<col width="80%">
				</colgroup>	
		        <tr class=Title>
					<th colspan=2 nowrap><%=labelService.getLabelName("402881e80ca5d67a010ca5e168090006")%><!--报表信息--></th>		        	  
		        </tr>
		        <tr>
					<td class="Line" colspan=2 nowrap>
					</td>		        	  
		        </tr>		        	
				<tr>
					<td class="FieldName" nowrap>
					   <%=labelService.getLabelName("402881e80ca5d67a010ca5e245050009")%><!-- 报表名称-->
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width:95%" name="objname" id="objname"  onChange="checkInput('objname','objnamespan')" value="<%=objname%>"/>
						<span id="objnamespan"><img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle></span>
					</td>
				</tr>	
				
				<tr>
					<td class="FieldName" nowrap>
					   <%=labelService.getLabelName("297ee7020b338edd010b3390af720002")%><!-- 表单名称 -->
					<td class="FieldValue">    
					    <input type="button"  class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/workflow/form/forminfobrowser.jsp','formid','formidspan','1');"/>
						<input type="hidden" id="formid"  name="formid" value="<%=formid%>"/>
						<span id="formidspan"><%=formspan%><%=strimg%></span>
					</td>
				</tr>
                   <%
                   if(!StringHelper.isEmpty(formid)&&forminfo.getObjtype()==1)//为抽象表单
                   {
                   %>
                      <tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14460012")%>：<!-- 主表名称 -->
					</td>
					<td class="FieldValue">
					<%
                      String forminfotable = forminfo.getObjtablename();
                  String sql = "select id from forminfo where objtablename='" + forminfotable + "' and objtype=0";
                   List list = forminfoService.getBaseJdbcDao().getJdbcTemplate().queryForList(sql);
                        String forminfoid="";
                     for (Object o : list) {
                     forminfoid = ((Map) o).get("id") == null ? "" : ((Map) o).get("id").toString();
                     }
                      Forminfo Forminfomain=forminfoService.getForminfoById(forminfoid);

                    %>
                      <%=Forminfomain.getObjname()%>
                    </td>
				</tr>
                    <tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14550013")%>：<!-- 从表名称 -->
					</td>
					<td class="FieldValue">
					<select class="inputstyle" id="secformid" name="secformid">
                  	<%
	                   FormlinkService formlinkService=(FormlinkService)BaseContext.getBean("formlinkService");
                          List linkformList = formlinkService.getRelaFormById(formid,"1");
                           for(int i=0;i<linkformList.size();i++)
                           {
                               Formlink formlink=(Formlink)linkformList.get(i);
                               Forminfo subordinationforminfo=new Forminfo();
                               if(formlink.getPid().equals(forminfoid))//过滤掉主表的id
                               {
                                 continue;
                               }else{
                                 subordinationforminfo=forminfoService.getForminfoById(formlink.getPid());  
                               }


                       %>
	                  <option value=<%=subordinationforminfo.getId()%> ><%=subordinationforminfo.getObjname()%></option>
	               	<%
	                   } // end for
	               	%>
		      		</select>
					</td>
				</tr>
                   <%}%>
                <!-- 查询限制条件(start) -->
				<tr>
					<td class="FieldName" nowrap>
					   <%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14550014")%><!--查询限制条件  -->
					<td class="FieldValue">
                        <input type="text" class="InputStyle2" style="width:95%" name="selectConditions" value=""/>
					</td>
				</tr>
                <!-- 查询限制条件(end) -->

                <tr>
					<td class="Line" colspan=100% nowrap>
					</td>		        	  
		        </tr>	
		        
		        <tr class=Title>
					<th colspan=2 nowrap><%=labelService.getLabelName("402881e80ca5d67a010ca5e3d98c000c")%><!--  报表描述--></th>		        	  
		        </tr>
		        <tr>
					<td class="Line" colspan=2 nowrap>
					</td>		        	  
		        </tr>		        
				<tr>
					<td class="FieldValue" colspan=2>
					<TEXTAREA STYLE="width:100%" class=InputStyle rows=2 name="objdesc"></TEXTAREA>
					</td>
				</tr>
          <input type="hidden" value="<%=moduleid%>" name="moduleid"/>
</table>
      	</form>
</div>


<script type="text/javascript">
//Start Ajax tabs script for UL with id="maintab" Separate multiple ids each with a comma.
startajaxtabs("maintab")
</script>
<script language="javascript"> 
function onSubmit(){
       checkfields="formid,objname";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
   	if(document.all("formid").value=="" || document.all("objname").value==""){
   	    alert(checkmessage);
   	}else{ 
 		document.EweaverForm.submit();
   	}
} 

function goBack(){
	location.href='<%=request.getContextPath()%>/workflow/report/reportdeflist.jsp?moduleid=<%=moduleid%>';
}

function onSubmit2(){
   	checkfields="objdesc,objname";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
   	if(document.all("objdesc").value=="" || document.all("objname").value==""){
   	    alert(checkmessage);
   	}else{ 
   		document.EweaverForm.submit();
   	}
}  

function onSubmit3(){
   	checkfields="formid,objname";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
   	if(document.all("formid").value=="" || document.all("objname").value==""){
   	    alert(checkmessage);
   	}else{ 
   		var filename = document.all("formidspan").innerHTML;

 		if(filename.lastIndexOf(".rptdesign")==-1){
 			alert("<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14550015")%>");//请上传格式为 rptdesign 的文件
 			
 		}else{
 			document.EweaverForm.submit();
 		}
   	}
}

</script>
       <script type="text/javascript">
       var win;
 function getBrowser(viewurl,inputname,inputspan,isneed){
    var id;
     viewurl=viewurl+"?moduleid=<%=moduleid%>";
     var objname=document.getElementById("objname").value;
     if(!Ext.isSafari){
	    try{
	    id=openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url='+viewurl);
	    }catch(e){}
		if (id!=null) {
		if (id[0] != '0') {
			document.all(inputname).value = id[0];
			document.all(inputspan).innerHTML = id[1];
	        window.location="/workflow/report/reportcreate.jsp?moduleid=<%=moduleid%>&objname="+objname+"&formid="+id[0];
	
	    }else{
			document.all(inputname).value = '';
			if (isneed=='0')
			document.all(inputspan).innerHTML = '';
			else
			document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';
	
	            }
	         }
     }else{
    	//----
 	    var callback = function() {
 	            try {
 	                id = dialog.getFrameWindow().dialogValue;
 	            } catch(e) {
 	            }
 	           if (id!=null) {
 	      		if (id[0] != '0') {
 	      			document.all(inputname).value = id[0];
 	      			document.all(inputspan).innerHTML = id[1];
 	      	        window.location="/workflow/report/reportcreate.jsp?moduleid=<%=moduleid%>&objname="+objname+"&formid="+id[0];
 	      	
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
 	                width:Ext.getBody().getWidth()*0.85,
 	                height:Ext.getBody().getHeight()*0.85,
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
 		
 	//----
 }
       </script>
