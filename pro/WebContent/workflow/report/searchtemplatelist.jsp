<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.Page"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.workflow.report.model.Contemplate"%>
<%@ page import="com.eweaver.humres.base.model.Humres"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>

<%
List contemplatelist = (List)request.getAttribute("contemplatelist");
String reportid = StringHelper.null2String(request.getParameter("reportid"));
String isformbase = StringHelper.null2String(request.getParameter("isformbase"));
String ispublic = StringHelper.null2String(request.getParameter("ispublic"));
String selectItemId = StringHelper.trimToNull(request.getParameter("selectitemid"));

SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
DataService dataService = new DataService();
List selectitemlist = selectitemService.getSelectitemList("402881ec0c68ca65010c68d4d68b000a",null);
Selectitem selectitem;
EweaverUser eweaveruser1 = BaseContext.getRemoteUser();
String curuserid=StringHelper.null2String(eweaveruser1.getId()).trim();
 //String curuserid = eweaveruser.getId();
String highsearch=StringHelper.null2String(request.getParameter("highsearch"));
%>

<!--页面菜单开始-->
<%
String sysmodel = request.getParameter("sysmodel");
String action = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction";
if(!StringHelper.isEmpty(sysmodel)){
	action = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction";
}
pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc7bf4cc0028")+"','N','add',function(){savecondition('','','','')});";//新建
  if(!StringHelper.isEmpty(highsearch)&&highsearch.equals("1")){      //返回按钮高级搜索页面点模板管理出现
pagemenustr +=  "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+"','R','arrow_redo',function(){javascript:back('"+ reportid +"')});";
  }
%>
    <html>
	<head>
    <style type="text/css">
     #pagemenubar table {width:0}
</style>
    <script src='<%=request.getContextPath()%>/dwr/interface/ContemplateService.js'></script>
    <script src='<%=request.getContextPath()%>/dwr/interface/DataService.js'></script>
    <script src='<%=request.getContextPath()%>/dwr/engine.js'></script>
    <script src='<%=request.getContextPath()%>/dwr/util.js'></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
    
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
		
<div id="pagemenubar"></div>
<!--页面菜单结束-->

		<form action="<%=action %>?action=searchtemplate&reportid=<%=reportid%>" name="EweaverForm" method="post">
		   <table id=searchTable>
       <tr>
		 <td class="FieldName" width=10% nowrap>
			 <%=labelService.getLabelName("402881e90bcbc9cc010bcbcb1aab0008")%>
		 </td>                  
         <td class="FieldValue">
		     <select class="inputstyle" id="ispublic" name="ispublic" onChange="javascript:onSubmit();">
					<option value="" ></option>
                   	<option value="False" <%if(StringHelper.null2String(ispublic).equalsIgnoreCase("false")){%> selected <%}%>><%=labelService.getLabelNameByKeyId("40288035248fd7a801248ff679c1026e")%></option><!-- 私人 -->
					<option value="True" <%if(StringHelper.null2String(ispublic).equalsIgnoreCase("true")){%> selected <%}%>>Public</option>
		       </select>
		      
          </td>
	    </tr>        
             
   </table>
			<table>
				<colgroup>
					<col width="">
					<col width="">
					<col width="">
                    <col width="">
					<col width="10%">
                    <col width="10%">
                    <col width="10%">
				</colgroup>
				<tr class="Header">
					<td>
						<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e1446000a")%><!--模板  -->
					</td>
					<td>
						<%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd7215e7b000a")%><!-- 创建人 -->
					</td>
					<td>
						<%=labelService.getLabelNameByKeyId("402881eb0bd74dcf010bd753e2b50008")%><!-- 创建时间 -->
					</td>
					<td>
                      <%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a001a")%><!-- 是否默认 -->
					</td>
					<td>

					</td>
                    <td>
						
					</td>
					<td>

					</td>                    
                    <td>
						
					</td>
					
				</tr>
				<%
				
			boolean isLight=false;
			String trclassname="";
				int listsize = contemplatelist.size();
				for (int i = 0; i < listsize; i++) {
					Contemplate contemplate = (Contemplate) contemplatelist.get(i);
					isLight=!isLight;
					if(isLight) trclassname="DataLight";
					else trclassname="DataDark";
					String searchdefaultsql = "select cs.isdefault from Contemplate cp,ContemplateState cs "+ 
            		" where cp.id=cs.contemplateid and cs.contemplateid='"+contemplate.getId()+"' "+
            		" and cs.userid='"+eweaveruser.getId()+"' ";
            		String isdefault = dataService.getValue(searchdefaultsql);
%>
				<tr class="<%=trclassname%>">
					<td class="FieldValue">
                        <%if(curuserid.equals(contemplate.getUserid())){%>
                        <a href="javascript:savecondition('<%=contemplate.getId()%>','<%=contemplate.getObjname()%>','<%=contemplate.getIspublic()%>','<%=contemplate.getObjdesc()%>','<%=isdefault%>')"><%=contemplate.getObjname()%>(<%if("False".equals(contemplate.getIspublic())){%><%=labelService.getLabelNameByKeyId("40288035248fd7a801248ff679c1026e")%><%}else{%><%=labelService.getLabelNameByKeyId("40288035248fd7a801248ff7c9720270")%><%}%>)</a><!-- 私人   公共 -->
					    <%}else{%>
                        <span><%=contemplate.getObjname()%>(<%if("False".equals(contemplate.getIspublic())){%><%=labelService.getLabelNameByKeyId("40288035248fd7a801248ff679c1026e")%><%}else{%><%=labelService.getLabelNameByKeyId("40288035248fd7a801248ff7c9720270")%><%}%>)</span><!-- 私人   公共 -->
                        <%}%>
                    </td>
					<td class="FieldValue">
					<%
					HumresService humresService = (HumresService) BaseContext.getBean("humresService");
					
					Humres humres = humresService.getHumresById(StringHelper.null2String(contemplate.getUserid()));
					String optidname = humres.getObjname();
					%>
						<%=optidname%>
					</td>
					<td class="FieldValue">
							<%=StringHelper.null2String(contemplate.getCreatetime())%>
					</td>
                    <td class="FieldValue">
                    	<select name="isdefaults" id="isdefaults" style="width:50px;" onchange="changestate(this,'<%=contemplate.getId()%>','<%=contemplate.getIspublic()%>')">
                                <option value="0" <%if("0".equals(isdefault)){%>selected<%}%>><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%></option><!-- 否 -->
                                <option value="1" <%if("1".equals(isdefault)){%>selected<%}%>><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c")%></option><!-- 是 -->
                        </select>
                    </td>
                    <td class="FieldValue">
						<%if(curuserid.equals(contemplate.getUserid())){%>
                        <a href="javascript:location.href='<%=request.getContextPath()%>/workflow/report/reportsearch.jsp?reportid=<%=reportid%>&sysmodel=<%=sysmodel%>&isformbase=<%=isformbase%>&contemplateid=<%=contemplate.getId()%>'"><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220003")%></a><!-- 查询条件定义 -->
                        <%}else{%>
                        <span><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220003")%></span><!-- 查询条件定义 -->
                        <%}%>
                    </td>
                    <td class="FieldValue">
                        <%if(curuserid.equals(contemplate.getUserid())){%>
                        <a href="javascript:location.href='<%=request.getContextPath()%>/base/searchcustomize/searchcustomize.jsp?reportid=<%=reportid%>&contemplateid=<%=contemplate.getId()%>&sysmodel=<%=sysmodel%>&isformbase=<%=isformbase%>'"><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522003e")%></a><!-- 显示列定义 -->
					    <%}else{%>
                        <span><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522003e")%></span><!-- 显示列定义 -->
                        <%}%>
                    </td>
                    <td class="FieldValue">
						<a href='javascript:top.leftFrame.onUrl("<%=action %>?action=search&contemplateid=<%=contemplate.getId()%>&reportid=<%=reportid%>&sysmodel=<%=sysmodel%>&isformbase=<%=isformbase%>","<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220040")%>","<%=reportid%>")'><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522003f")%></a><!-- 模板查询结果 查询结果 -->
					</td>
					<td class="FieldValue">
						<%if(curuserid.equals(contemplate.getUserid())){%><a href="<%=action %>?action=deletesearchtemplate&contempid=<%=contemplate.getId()%>&reportid=<%=reportid%>&sysmodel=<%=sysmodel%>&isformbase=<%=isformbase%>"><%=labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003")%></a><%}%><!-- 删除 -->
					</td>

				</tr>
				<%
				}
			%>
			</table>
        <div id="divObj" style="display:none">
            <input type="hidden" name="contemplateid" id="contemplateid"/>
            <table id="displayTable">
                <tr><th colspan="2" style="background-color:#f7f7f7;height:22"><b><span style="color:green" id="showSpan"></span>,<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220041")%>:</b></th></tr><!-- 请认真填写模板相关信息 -->
                    <tr>
                        <td width="120">&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td align="right"><%=labelService.getLabelNameByKeyId("40288035248fd7a801248ff9588e0272")%></td><!-- 模板名称 -->
                        <td align="center"><input type="text" size="30" maxlength="60" name="objname" id="objname" style="width:180px"></td>
                    </tr>
                    <tr>
                        <td align="right"><%=labelService.getLabelNameByKeyId("402881eb0ca0bb62010ca0e4f8f40006")%></td><!-- 模板类型 -->
                        <td align="center">
                            <select name="myPublic" id="myPublic" style="width:180px">
                                <option value="False"><%=labelService.getLabelNameByKeyId("40288035248fd7a80124902ca3a90414")%></option><!-- 私人模板 -->
                                <%
                            		if("402881e70be6d209010be75668750014".equalsIgnoreCase(curuserid)){
                            	%>
                                <option value="True"><%=labelService.getLabelNameByKeyId("40288035248fd7a80124902e1f2d0416")%></option><!-- 公共模板 -->
                                <%}%>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td align="right"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6cd1b580008")%></td><!-- 排序 -->
                        <td align="center"><input type="text" size="30" maxlength="60" name="objdesc" id="objdesc" style="width:180px"></td>
                    </tr>
                    <tr>
                        <td align="right"><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a001a")%></td><!-- 是否默认 -->
                        <td align="center">
                            <select name="isdefault" id="isdefault" style="width:180px">
                                <option value="0"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%></option><!-- 否 -->
                                <option value="1"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c")%></option><!-- 是 -->
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center">
                                    <button  type="button" accessKey="S" onclick="toSubmit()">
                                        <U>S</U>--<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")%><!-- 确定 -->
                                    </button>
                                    &nbsp;&nbsp;&nbsp;
                                    <button  type="button" accessKey="C" onclick="Cancel_onclick()">
                                        <U>C</U>--<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6f1e6e0023")%><!-- 取消 -->
                                    </button>
                        </td>
                    </tr>
            </table>
        </div>
        </form>
<script language="javascript" type="text/javascript">
    function onSearch(){
	document.EweaverForm.submit();
   }    
   
    function onSubmit(){
        document.EweaverForm.submit();
    }
    
    function back(reportid){
  		location.href="<%=request.getContextPath()%>/workflow/report/reportsearch.jsp?sysmodel=<%=sysmodel%>&isformbase=<%=isformbase%>&reportid="+reportid;
    }

    function savecondition(contemplateid,objname,ispublic,objdesc,isdefault){
        if(contemplateid!=null&&contemplateid!=""){
            if(objname==null||objname==""){
                objname="";
            }
            if(objdesc=="null"||objdesc==""||objdesc==null){
                objdesc="";
            }
            document.getElementById("showSpan").innerText="<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220042")%>";//修改模板
            document.forms[0].contemplateid.value=contemplateid;
            document.forms[0].objname.value=objname;
            var myPublic=document.forms[0].myPublic;
            for(i=0;i<myPublic.length;i++){
                if(myPublic[i].value==ispublic){
                    myPublic[i].selected=true; 
                }
            }
            var isdefaulttd=document.forms[0].isdefault;
            for(i=0;i<isdefaulttd.length;i++){
                if(isdefaulttd[i].value==isdefault){
                    isdefaulttd[i].selected=true;
                }
            }
            document.forms[0].objdesc.value=objdesc;
        }else{
            document.getElementById("showSpan").innerText="<%=labelService.getLabelNameByKeyId("40288035248fd7a801248ff15fd80268")%>";//新建模板
            document.forms[0].contemplateid.value="";
            document.forms[0].objname.value="";
            var myPublic=document.forms[0].myPublic;
            myPublic[0].selected=true;
            var isdefaulttd=document.forms[0].isdefault;
            isdefaulttd[0].selected=true;
            document.forms[0].objdesc.value="";
        }
        sAlert();
    }

    function toSubmit(){
        if(document.getElementById("objname").value==null||document.getElementById("objname").value==""){
            alert("<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a003c")%>");//请输入模板名称
            return;
        }
        var strcontemplateid = document.getElementsByName("contemplateid")[0].value;
        if(document.getElementsByName("isdefault")[0].value=="1"){
        	var sqlwhere ="";
        	if(strcontemplateid!=""){
				sqlwhere=" and cp.id!='"+strcontemplateid+"'";        		
        	}
        	var ispublic  = document.getElementsByName("myPublic")[0].value;
        	DWREngine.setAsync(false);
        	var defaultcount = 0;
        	//var sql="select count(*) as a from contemplate where reportid='<%=reportid%>' and ISDELETE=0 and ISDEFAULT=1 and (ispublic='"+ispublic+"' and userid='<%=curuserid%>') "+sqlwhere;
        	var sql="select count(*) as a from contemplate cp,contemplatestate cs where cp.id=cs.contemplateid "+
        	" and cp.reportid='<%=reportid%>' and cp.isdelete=0 and cs.isdefault=1 and "+ 
        	" (cp.ispublic='"+ispublic+"' and cs.userid='<%=curuserid%>') "+sqlwhere;
        	DataService.getValues(sql,{
	          callback: function(data){
	              if(data && data.length>0){
	            	  defaultcount = data[0].a;
	              }
	          }
	        });
        	DWREngine.setAsync(true);
        	if(defaultcount>0){
        		if(ispublic=='True'){
        			ispublic = "<%=labelService.getLabelNameByKeyId("40288035248fd7a80124902e1f2d0416")%>";//公模板
        		}else{
        			ispublic = "<%=labelService.getLabelNameByKeyId("40288035248fd7a80124902ca3a90414")%>";//私人模板
        		}
        		alert(ispublic+"<%=labelService.getLabelNameByKeyId("10B0716AFAF8432984204F677E8C4100")%>");//中已经有一个默认模板，请重新设置
        		return false;
        	}
        }
        ContemplateService.saveContemplate("<%=reportid%>","<%=curuserid%>",document.getElementById("objname").value,document.getElementById("myPublic").value,document.getElementById("objdesc").value,document.getElementById("isdefault").value,document.getElementById("contemplateid").value,callback);

    }
    
    function checkisexists(comtemplateid,ispublic){
       	var defaultcount = 0;
       	var sql="select count(*) as a from contemplate cp,contemplatestate cs where cp.id=cs.contemplateid "+
       	" and cp.reportid='<%=reportid%>' and cp.isdelete=0 and cs.isdefault=1 and "+ 
       	" (cp.ispublic='"+ispublic+"' and cs.userid='<%=curuserid%>') and cp.id!='"+comtemplateid+"' ";
       	DWREngine.setAsync(false);
       	DataService.getValues(sql,{
          callback: function(data){
              if(data && data.length>0){
            	  defaultcount = data[0].a;
              }
          }
        });
       	DWREngine.setAsync(true);
       	if(defaultcount>0){
       		if(ispublic=='True'){
       			ispublic = "<%=labelService.getLabelNameByKeyId("40288035248fd7a80124902e1f2d0416")%>";//公模板
       		}else{
       			ispublic = "<%=labelService.getLabelNameByKeyId("40288035248fd7a80124902ca3a90414")%>";//私人模板
       		}
       		alert(ispublic+"<%=labelService.getLabelNameByKeyId("10B0716AFAF8432984204F677E8C4100")%>");//中已经有一个默认模板，请重新设置
       		return false;
       	}
       	return true;
    }

    function callback(data){
        if(data=="ok"){
            alert("<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a003d")%>");//操作成功!
        }else{
            alert("<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a003e")%>");//操作失败!
        }
        Cancel_onclick();
        window.location.reload();
    }

    function Cancel_onclick(){
        var mychoose=document.getElementById("divObj");
        var mytable=document.getElementById("displayTable");
        var bgObj=document.getElementById("bgDiv");
        var msgObj=document.getElementById("msgDiv");
        var title=document.getElementById("msgTitle");
        mychoose.appendChild(mytable);
        document.body.removeChild(bgObj);
        document.getElementById("msgDiv").removeChild(title);
        document.body.removeChild(msgObj);
    }
    
    function changestate(obj,comtemplateid,ispublic){
    	if(checkisexists(comtemplateid,ispublic)){
			ContemplateService.updateState(comtemplateid,"<%=curuserid%>",obj.value);   
			alert("<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a003d")%>");//操作成功!
    	}
    	setTimeout(loadyc,200);
    }

    function loadyc() {
    	window.location.reload();
    }

//*********************************模式对话框特效(start)*********************************//
    function sAlert(){
    var msgw,msgh,bordercolor;
    msgw=460;//提示窗口的宽度
    msgh=280;//提示窗口的高度
    bordercolor="#336699";//提示窗口的边框颜色

    var sWidth,sHeight;
    sWidth=document.body.offsetWidth;
    sHeight=document.body.offsetHeight;

    var bgObj=document.createElement("div");
    bgObj.setAttribute('id','bgDiv');
    bgObj.style.position="absolute";
    bgObj.style.top="0";
    bgObj.style.background="#777";
    bgObj.style.filter="progid:DXImageTransform.Microsoft.Alpha(style=3,opacity=25,finishOpacity=75";
    bgObj.style.opacity="0.6";
    bgObj.style.left="0";
    bgObj.style.width=sWidth + "px";
    bgObj.style.height=sHeight + "px";
    document.body.appendChild(bgObj);
    var msgObj=document.createElement("div")
    msgObj.setAttribute("id","msgDiv");
    msgObj.setAttribute("align","center");
    msgObj.style.position="absolute";
    msgObj.style.background="white";
    msgObj.style.font="12px/1.6em Verdana, Geneva, Arial, Helvetica, sans-serif";
    msgObj.style.border="1px solid " + bordercolor;
    msgObj.style.width=msgw + "px";
    msgObj.style.height=msgh + "px";
  msgObj.style.top=(document.documentElement.scrollTop + (sHeight-msgh)/2) + "px";
  msgObj.style.left=(sWidth-msgw)/2 + "px";

  var title=document.createElement("h4");
  title.setAttribute("id","msgTitle");
  title.setAttribute("align","right");
  title.style.margin="0";
  title.style.padding="3px";
  title.style.background=bordercolor;
  title.style.filter="progid:DXImageTransform.Microsoft.Alpha(startX=20, startY=20, finishX=100, finishY=100,style=1,opacity=75,finishOpacity=100);";
  title.style.opacity="0.75";
  title.style.border="1px solid " + bordercolor;
  title.style.height="18px";
  title.style.font="12px Verdana, Geneva, Arial, Helvetica, sans-serif";
  title.style.color="white";
  title.style.cursor="pointer";
  title.innerHTML="关闭";
  title.onclick=function(){
    var mychoose=document.getElementById("divObj");
    var mytable=document.getElementById("displayTable");
    mychoose.appendChild(mytable);
    document.body.removeChild(bgObj);
    document.getElementById("msgDiv").removeChild(title);
    document.body.removeChild(msgObj);
  }
  document.body.appendChild(msgObj);
  document.getElementById("msgDiv").appendChild(title);
  var mytable=document.getElementById("displayTable");
  document.getElementById("msgDiv").appendChild(mytable);
  }
//*********************************模式对话框特效(end)*********************************//

 </script>

    </body>
</html>

