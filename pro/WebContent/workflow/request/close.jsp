<%@ page import="com.eweaver.base.setitem.service.SetitemService" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/base/init.jsp"%>
<%
     setitemService0 = (SetitemService) BaseContext.getBean("setitemService");
     eweaveruser = BaseContext.getRemoteUser();
     currentuser = eweaveruser.getHumres();
     style=StringHelper.null2String(eweaveruser.getSysuser().getStyle());
    if(StringHelper.isEmpty(style)){
    	if (setitemService0.getSetitem("402880311baf53bc011bb048b4a90005") != null && !StringHelper.isEmpty(setitemService0.getSetitem("402880311baf53bc011bb048b4a90005").getItemvalue()))
            style = setitemService0.getSetitem("402880311baf53bc011bb048b4a90005").getItemvalue();
    }
	String requestname=StringHelper.getDecodeStr(StringHelper.trimToNull(request.getParameter("requestname")));
	if(!StringHelper.isEmpty(requestname))
		requestname="\""+requestname+"\"";
	requestname = requestname.replaceAll("'","&#39;");
	//获取对应的tabid
	String tabid= StringHelper.null2String(request.getParameter("tabid"));
	String reftabid = StringHelper.null2String(request.getParameter("reftabid"));
	String requestid= StringHelper.null2String(request.getParameter("requestid"));
	if(StringHelper.isEmpty(tabid))tabid=requestid;
	boolean inOpenedInWindow = StringHelper.null2String(request.getParameter("inOpenedInWindow")).trim().equalsIgnoreCase("true");
	
	String mode=StringHelper.null2String(StringHelper.trimToNull(request.getParameter("mode")));
	String modeStr=labelService.getLabelNameByKeyId("402881eb0c9fadb1010c9fd1a069000e");//操作
	if(mode.equals("submit"))
		modeStr=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbda07e0009");//提交
	else if(mode.equals("isreject"))
		modeStr=labelService.getLabelNameByKeyId("402881e50c7bd518010c7be0ab0e0007");	//退回
	else if(mode.equals("undo"))
		modeStr=labelService.getLabelNameByKeyId("4028690a0f60fbe6010f6124fcb40041");//撤回
	else if(mode.equals("ismeddle"))
		modeStr=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0043");//干预
	else if(mode.equals("forceFinish"))
		modeStr=labelService.getLabelNameByKeyId("4028832e3eef1b51013eef1b524c0277");//强制归档

%>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/ext/resources/css/ext-all.css" />
     <%if(!"".equals(style)&&!"default".equals(style)){%>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/ext/resources/css/xtheme-<%=style%>.css"/>
      <%}%>
    <style type="text/css">
      .x-panel-btns-ct {
          padding: 0px;
      }
  </style>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/main.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
    <script type="text/javascript">
        Ext.onReady(function() {

			if(typeof(pop)=='function'){//call js/main.js pop
				pop('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0044") %><%=requestname%><%=modeStr%><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0045") %>！');//流程   成功 
			}else {
				alert('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0044") %><%=requestname%><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0046") %>！');//流程   //提交成功
			}

            //刷新门户流程元素
            if(top.frames[1] && top.frames[1].name == 'leftFrame'){	//传统首页
				var obj=top.frames[1];
				if(typeof(obj)=='object'){
					obj=obj.frames[0];
					if(typeof(obj)=='object'){
						
						//刷新流程Tab元素.
						if(obj.TabPortlet){
							obj.TabPortlet.refreshRequestTab();
						}
						
						obj=obj.TodoWorkflowPortlet;
						if(typeof(obj)=='object') obj.refresh();
					}
				}//end if.
			}else if(top && typeof(top.refreshPortalWorkflowElement) == 'function'){	//新首页刷新
				top.refreshPortalWorkflowElement();
			}
            
            //刷新"待办事宜"菜单对应的列表页面
			if(top && typeof(top.refreshTabIfExisted) == 'function'){	//新首页
				top.refreshTabIfExisted('tab4028d80f1999187d01199d6464df0d0f');
			}else{	//传统首页
				publish('refreshtab','tab4028d80f1999187d01199d6464df0d0f');
			}

            //如果是从任务卡片建立的流程，在此刷新任务卡片
            var reftabid="<%=reftabid%>";
            if(reftabid){
            	if(top && typeof(top.refreshTab) == 'function'){
            	    top.refreshTab('tab'+reftabid);
            	    top.refreshTab('exec_'+reftabid);
            	    top.refreshTab('plan_'+reftabid);
            	} else{
            		var tabpanel=top.frames[1].contentPanel;
            		if(tabpanel.getItem('tab'+reftabid)){
            		    tabpanel.getItem('tab'+reftabid).getFrameWindow().location.reload();
            		}
            		if(tabpanel.getItem('exec_'+reftabid)){
            		    tabpanel.getItem('exec_'+reftabid).getFrameWindow().location.reload();
            		}
            		if(tabpanel.getItem('plan_'+reftabid)){
            		    tabpanel.getItem('plan_'+reftabid).getFrameWindow().location.reload();
            		}
            	}
            }
			
            var inOpenedInWindow = <%=inOpenedInWindow%>;
			if(inOpenedInWindow){	//关闭弹出窗体
				if(!top.isUseNewMainPage() && top.frames[1] && typeof(top.frames[1].closeWin)=='function'){	//传统首页
		    		top.frames[1].closeWin();
			    }else if(top.isUseNewMainPage() && typeof(top.closeWin) == 'function'){//新页面作为首页
			    	top.closeWin();
			    }
			}else{	//关闭标签页
				var tabid="<%=tabid%>";
				if(top && typeof(top.closeTab) == 'function'){	//新首页关闭标签页
					if(tabid && tabid.length == 32){	//关闭指定id的标签页
						tabid = "tab" + tabid;
					}
					top.closeTab(tabid);
				}else if(top.frames[1]){	//传统首页关闭标签页
					var tabpanel=top.frames[1].contentPanel;
					if(tabid&&tabid.length==32){
		                  if(tabpanel.getItem("tab"+tabid)){
		                       tabpanel.remove(tabpanel.getItem("tab"+tabid)); //根据指定的tabID关闭，并非关闭当前活动tab页
						  }else if(tabpanel.getItem(tabid)){
		                       tabpanel.remove(tabpanel.getItem(tabid)); //根据指定的tabID关闭，并非关闭当前活动tab页
						  }else{
		                       tabpanel.remove(tabpanel.getActiveTab());
						  }
		            }else{
		            	 tabpanel.remove(tabpanel.getActiveTab());
		            }
				}else{
					window.opener=null 
					window.open("","_self") 
					window.close(); 
				}
			}
        });
    </script>
</html>





			