<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.eweaver.base.label.model.Label"%>
<%@page import="com.eweaver.base.label.service.LabelCustomService"%>
<%@page import="com.eweaver.workflow.request.dao.RequeststepDaoHB"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.request.service.RequestbaseService"%>
<%@ page import="com.eweaver.workflow.request.service.RequestlogService"%>
<%@ page import="com.eweaver.workflow.request.model.*"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>
<%@ page import="com.eweaver.workflow.workflow.model.Workflowinfo"%>
<%@ page import="com.eweaver.workflow.request.model.Requestbase"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.category.model.Category"%>
<%@ page import="com.eweaver.base.category.model.Categorylink"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.Page"%>
<%@ page import="com.eweaver.base.searchcustomize.service.SearchcustomizeService"%>
<%@ page import="com.eweaver.base.searchcustomize.model.*"%>
<%@ page import="com.eweaver.humres.base.model.Humres"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>
<%@ page import="org.json.simple.JSONArray" %>
<%
    response.setHeader("cache-control", "no-cache");
    response.setHeader("pragma", "no-cache");
    response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
	LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");
	RequeststepDaoHB requeststepDaoHB = (RequeststepDaoHB) BaseContext.getBean("requeststepDao");
  Selectitem selectitem;
  CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
  RequestbaseService requestbaseService = (RequestbaseService) BaseContext.getBean("requestbaseService");
  RequestlogService requestlogService = (RequestlogService) BaseContext.getBean("requestlogService");
  NodeinfoService nodeinfoService = (NodeinfoService) BaseContext.getBean("nodeinfoService");
    BaseJdbcDao baseJdbcDao = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
    DataService dataService = new DataService();
  WorkflowinfoService workflowinfoService = (WorkflowinfoService) BaseContext.getBean("workflowinfoService");
  PagemenuService _pagemenuService2 =(PagemenuService)BaseContext.getBean("pagemenuService");    
  String action = request.getParameter("action");
  String waitoperate = StringHelper.null2String(request.getParameter("waitoperate"));
  String userid = eweaveruser.getId();
  String secsql = "select seclevel from humres where id='"+userid+"'";
  double seclevel = 0.0;
	List listsec = dataService.getValues(secsql);
	if(listsec.size()>0){//不管查询到几个 取第一个
		Map mapsec  = (Map)listsec.get(0);
		seclevel = Double.parseDouble(StringHelper.null2String(mapsec.get("seclevel")));
	}
  HumresService humresService = (HumresService) BaseContext.getBean("humresService");
  String tablename = "requestbase";
  SearchcustomizeService searchcustomizeService = (SearchcustomizeService) BaseContext.getBean("searchcustomizeService");
  List resultOptions = searchcustomizeService.getSearchResult(userid,tablename);
  Page pageObject = (Page) request.getAttribute("pageObject");
  String undostr=StringHelper.null2String(request.getParameter("undostr"));

  String targeturl = URLEncoder.encode(request.getContextPath()+"/base/blank.jsp?isclose=1","UTF-8");
  %>
<%

String clear="";
clear=StringHelper.null2String(request.getParameter("clear"));
String objno="";
String flowno="";
String requestname="";
String workflowid="";
String moduleid="";
String isfinished="";
String isdelete="";
String creator="";
String createdatefrom="";
String createdateto="";
String requestlevel="";
String updatetime="";
if(clear.equals("true")){
     request.getSession().setAttribute("requestbaseFilter",null);
}
Map requestbaseFilter = (Map)request.getSession().getAttribute("requestbaseFilter");
if(requestbaseFilter!=null){
    if (requestbaseFilter.get("objno")!=null) objno = (String)requestbaseFilter.get("objno");
    if (requestbaseFilter.get("flowno")!=null) flowno = (String)requestbaseFilter.get("flowno");
	if (requestbaseFilter.get("requestname")!=null) requestname = (String)requestbaseFilter.get("requestname");
	if (requestbaseFilter.get("workflowid")!=null) workflowid = (String)requestbaseFilter.get("workflowid");
	if (requestbaseFilter.get("moduleid")!=null) moduleid = (String)requestbaseFilter.get("moduleid");
	if (requestbaseFilter.get("isfinished")!=null) isfinished = ""+requestbaseFilter.get("isfinished");
	if (requestbaseFilter.get("isdelete")!=null) isdelete = ""+requestbaseFilter.get("isdelete");
	if (requestbaseFilter.get("creater")!=null) creator = (String)requestbaseFilter.get("creater");
	if (requestbaseFilter.get("createdatefrom")!=null) createdatefrom = (String)requestbaseFilter.get("createdatefrom");
	if (requestbaseFilter.get("createdateto")!=null) createdateto = (String)requestbaseFilter.get("createdateto");
	if (requestbaseFilter.get("requestlevel")!=null) requestlevel = (String)requestbaseFilter.get("requestlevel");
	if (requestbaseFilter.get("updatetime")!=null) updatetime = (String)requestbaseFilter.get("updatetime");
}
%>

<%   //grid 表头 
				String readerStr="{name:'requestid'},{name: 'isbatchapproval'}";
				String colStr="";
				if(resultOptions==null){
					resultOptions = new ArrayList();
				}
				Iterator it = resultOptions.iterator();
				String showname = "";
				while(it.hasNext()){
					Searchcustomizeoption searchcustomizeoption = (Searchcustomizeoption) it.next();
					int fieldid = searchcustomizeoption.getFieldid().intValue();
					showname = StringHelper.null2String(searchcustomizeoption.getShowname());
					if(searchcustomizeoption.getLabelid() != null)
					   	showname = labelService.getLabelName(searchcustomizeoption.getLabelid());
					
						
						String sql = "select id,col1 from label where labelname ='"+showname+"'";
						List list = dataService.getValues(sql);
						if(list.size()>=1){//不管查询到几个 取第一个
							Map map  = (Map)list.get(0);
							String col1 = (String)map.get("col1");
							showname = labelService.getLabelNameByKeyId(col1);
						}
//					if(readerStr.equals("")){
//					readerStr+="{name:'"+fieldid+"'}";
//					colStr+="{header:'"+showname+"',sortable: true,dataIndex:'"+fieldid+"'}";
//					}
//					else{
                    readerStr+=",{name:'"+fieldid+"'}";
                    if (StringHelper.isEmpty(colStr)) {
                        colStr += "{header:'" + showname + "',sortable: true,dataIndex:'" + fieldid + "'}";

                    } else {
                        colStr += ",{header:'" + showname + "',sortable: true,dataIndex:'" + fieldid + "'}";

                    }
//					}
				
				}
%>

<%            //grid data

                     JSONArray jsondata=new JSONArray();
                     if(pageObject.getTotalSize()!=0){
                     Requestbase requestbase = null;
                     List list = (List) pageObject.getResult();
                     for (int i = 0; i <list.size(); i++) {
                          Map map = (Map)list.get(i);

                          Iterator Options = resultOptions.iterator();
                          String fieldvalue="";
                          JSONArray jsonArray=new JSONArray();
                          jsonArray.add(StringHelper.null2String(map.get("id")));
                             //************************撤回的流程不能显示在已办事宜中（start） ********************************//
                              if(!StringHelper.isEmpty(undostr)){
                            //撤回的流程在Requestoperators表中 ruleid为空并且userid为当前用户 如果再提及的话 Requestoperators表中的
                            //ruleid和userid会改变成下一个节点的规则和操作者
                              String sqlundo="select rl.logtype,ro.stepid from requestlog rl,Requestoperators ro "
                              +" where rl.requestid=ro.requestid and ro.ruleid='' and ro.userid='"+userid+"'"
                              +" and rl.requestid='"+map.get("id")+"'";
			               List listundo=baseJdbcDao.getJdbcTemplate().queryForList(sqlundo);
			               if(listundo.size()>0){
			    	           continue;
			                    }
                              }
                            //************************撤回的流程不能显示在已办事宜中(end)*******************************//
//                           List nodelist = requestlogService.getCurrentNodeIds(map.get("id")==null?null:map.get("id").toString()); 
//                           Nodeinfo nodeinfo = new Nodeinfo();
//                           if (nodelist.size() > 0)
//                               nodeinfo = nodeinfoService.get((String) nodelist.get(0));
                               
                          Nodeinfo nodeinfo = new Nodeinfo();
                          String isUseNodeidCol = StringHelper.null2String(request.getAttribute("isUseNodeidCol"));
                          if(isUseNodeidCol.equals("1")){
                        	  nodeinfo=nodeinfoService.get(StringHelper.null2String(map.get("nodeid")));    
                          }else{
                        	  Requeststep rs=requeststepDaoHB.get(StringHelper.null2String(map.get("stepid")==null?null:map.get("stepid").toString()));
    			              nodeinfo=nodeinfoService.get(StringHelper.null2String(rs.getNodeid()));                    	  
                          }
                          if(nodeinfo==null||nodeinfo.getId() == null){
                        	 nodeinfo.setId(dataService.getValue("select b.id from REQUESTINFO a,nodeinfo b where a.CURRENTNODEID=b.id and a.requestid='"+map.get("id")+"'"));
                          }
                          jsonArray.add(StringHelper.null2String(nodeinfo.getIsBatchApproval()));

                          while (Options.hasNext()) {
                                Searchcustomizeoption searchoption = (Searchcustomizeoption) Options.next();
                                  String curusertel="";

                                int fieldid = searchoption.getFieldid().intValue();

                               switch(fieldid){
                                case 1999:
					       			    fieldvalue=StringHelper.null2String(map.get("flowno"));

					       		break;
                                case 2000:
					       			    fieldvalue=StringHelper.null2String(map.get("objno"));

					       		break;

                                case 2001:
                                	String showName = StringHelper.filterJString2(StringHelper.null2String(map.get("requestname")));
                     			   if(!StringHelper.isEmpty(showName)){
                     			   	   showName = StringHelper.convertToUnicode(showName);
                         			   //if(showName.indexOf("&#39;")>=0){
                         				//   showName = showName.replaceAll("&#39;","");
                         			   //}
                         			   //if(showName.indexOf("'")>=0){
                         				//   showName = showName.replaceAll("'","");
                         			   //}
                     			   }
                                    fieldvalue="<a href=\"javascript:onUrl('/workflow/request/workflow.jsp?targeturl=" + targeturl +"&requestid=" + map.get("id") +"&nodeid="+nodeinfo.getId()+"','"+showName+ "','tab"+map.get("id") +"')\" >"+StringHelper.null2String(map.get("requestname"))+"</a>";

                                       break;
                                   case 2002:
                                            //Workflowinfo workflowinfo = workflowinfoService.get(map.get("workflowid")==null?null:map.get("workflowid").toString());
                                            //String workflowinfoname = workflowinfoService.getWorkflowNames(StringHelper.null2String(map.get("workflowid")));
                                            Workflowinfo workflowinfo = workflowinfoService.get(StringHelper.null2String(map.get("workflowid")));
                                            String workflowinfoname = labelCustomService.getLabelNameByWorkflowinfoForCurrentLanguage(workflowinfo);
                                            /*if(workflowinfo != null){
                                                workflowinfoname = workflowinfo.getObjname();
                                            }*/
                                               fieldvalue=StringHelper.null2String(workflowinfoname);
                                           break;
                                   case 2003:
                                               selectitem = selectitemService.getSelectitemById(map.get("requestlevel")==null?null:map.get("requestlevel").toString());
                                               fieldvalue=StringHelper.null2String(selectitem.getObjname());
                                           break;
                                   case 2004:
                                               //String creater = humresService.getHumresById(requestbase.getCreater()).getObjname();
                                       fieldvalue="<a href=\"javascript:onUrl('/humres/base/humresview.jsp?id=" + humresService.getHumresById(map.get("creater")==null?null:map.get("creater").toString()).getId()+"','"+humresService.getHumresById(map.get("creater")==null?null:map.get("creater").toString()).getObjname()+ "','tab"+humresService.getHumresById(map.get("creater")==null?null:map.get("creater").toString()).getId()+"')\" >"+humresService.getHumresById(map.get("creater")==null?null:map.get("creater").toString()).getObjname()+"</a>";
                                           break;

                                   case 2005:
                                               String createdatatime = map.get("createdate") + "&nbsp;" + map.get("createtime");
                                               fieldvalue=StringHelper.null2String(createdatatime);
                                       break;
                                case 2006:
                                            String isfinish = labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c");//是
                                            if((map.get("isfinished")==null?"":map.get("isfinished").toString()).toString().equals("0")){
                                                isfinish = labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d");//否
                                            }
                                             fieldvalue=StringHelper.null2String(isfinish);
                                       break;
                                case 2007:
                                		if(nodeinfo.getId()==null){
	                                  	  List nodelist = requestlogService.getCurrentNodeIds(map.get("id") == null ? null : map
	          										.get("id").toString());
	          								if (nodelist.size() > 0)
	          									nodeinfo = nodeinfoService.get((String) nodelist.get(0));
	                                    }
                                       fieldvalue ="<a href=\"javascript:showoperator('"+request.getContextPath()+"/workflow/request/requestoperators.jsp?requestid="+map.get("id")+"&nodeid="+nodeinfo.getId()+"')\" id=\""+map.get("id")+"\">"+labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0062")+"</a>";//操作者列表

                                       break;
                                case 2008:	
		                                	if(nodeinfo.getId()==null){
		                                  	  List nodelist = requestlogService.getCurrentNodeIds(map.get("id") == null ? null : map
		          										.get("id").toString());
		          								if (nodelist.size() > 0)
		          									nodeinfo = nodeinfoService.get((String) nodelist.get(0));
		                                    }
                                			String nodename = labelCustomService.getLabelNameByNodeinfoForCurrentLanguage(nodeinfo);
                                			nodename = nodename.replaceAll("\\\\n", " ");
                                            fieldvalue=StringHelper.null2String(nodename);
                                           
                                       break;
                                case 2009:

                                            List userlist = requestlogService.getCurrentNodeUsers(map.get("id")==null?null:map.get("id").toString());
                                            Humres humres = new Humres();
                                            if (userlist.size() > 0)
                                                humres = humresService.getHumresById((String) userlist.get(0));

                                            fieldvalue=StringHelper.null2String(humres.getObjname());
                                            curusertel = labelService.getLabelNameByKeyId("402881e70b7728ca010b7746fc6a0015")+"："+ StringHelper.null2String(humres.getTel1()) + "\n"+labelService.getLabelNameByKeyId("402881e70b7728ca010b7747b30f0016")+"：" + StringHelper.null2String(humres.getTel2());//办公室电话  移动电话
                                       break;
                                case 2010:	
                                	fieldvalue=StringHelper.null2String(map.get("updatetime"));
                                break;            
                                
                                default:
                                       break;


                                }	//end switch
                                jsonArray.add(fieldvalue);


                          }  //end while
                          jsondata.add(jsonArray);
                          }
                     }
                        %>

<!--页面菜单开始-->
               <%

               if(!"".equals(waitoperate) && seclevel>=60){
                   pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0063")+"','P','zoom',function(){operationAll()});";//待办批量处理
               }
               pagemenustr +="addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+"','S','zoom',function(){onSearch2()});";
               pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("40288035248eb3e801248f6fb6da0042")+"','R','erase',function(){reset()});";//清空条件
               //pagemenustr +="addBtn(tb,'"+labelService.getLabelName("40288184119b6f4601119c3cdd77002d")+"','A','zoom_in',function(){onSearch3()});";
               %>
<html>
  <head>
      <style type="text/css">
          .x-toolbar table {
              width: 0
          }

          #pagemenubar table {
              width: 0
          }

          .x-panel-btns-ct {
              padding: 0px;
          }

          .x-panel-btns-ct table {
              width: 0
          }
      </style>
                        <script src='/dwr/interface/RequestbaseService.js'></script>
                        <script src='/dwr/engine.js'></script>
                        <script src='/dwr/util.js'></script>
                        <script language="JScript.Encode" src="/js/rtxint.js"></script>
                        <script language="JScript.Encode" src="/js/browinfo.js"></script>
                        <script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
                        <script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
                        <script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
                        <script type="text/javascript">
                            var showOperatorsDiloge;
                            var selected=new Array();
							var tb=null;
                            Ext.onReady(function(){

                       Ext.QuickTips.init();
                            <%if(!pagemenustr.equals("")){%>
                                tb= new Ext.Toolbar();
                                tb.render('pagemenubar');
                            <%=pagemenustr%>
                            <%}%>
                       var xg = Ext.grid;

                       // shared reader
                       var reader = new Ext.data.ArrayReader({}, [
                          <%=readerStr%>
                       ]);

                       var sm=new Ext.grid.CheckboxSelectionModel({
                    	   renderer:function(v,c,r){
				             // if(r.data.isbatchapproval != '1'){
				             //      	  return "<div><input type='checkbox' style='margin-left:-2px;'/></div>";
				             // }else{
				                	  return "<div class=\"x-grid3-row-checker\"></div>";   
				             // }
			               }
                       });
                       /*
                        sm.on('beforerowselect',function( SelectionModel, rowIndex, keepExisting,record ) {
                        	alert(record.data.isbatchapproval);
		                   if(record.data.isbatchapproval != '1'){
		                   	  return false;
		                   }
            			});
                        */
                        store = new Ext.data.GroupingStore({
                               reader: reader,
                               data: xg.dummyData,
                               sortInfo:{field: '2010', direction: "desc"},
                               groupField:'2002'
                           });

                       var grid = new xg.GridPanel({
                           region: 'center',
                           store: store,
                           columns: [sm,
                               <%=colStr%>
                           ],
                           sm:sm ,
                           view: new Ext.grid.GroupingView({
                               forceFit:true,
                               startCollapsed:true,
							   sortAscText:'<%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000") %>',//升序
                           		sortDescText:'<%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000") %>',//降序
							   groupByText:'<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0064") %>',//按此列分组
							   showGroupsText:'<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0065") %>',//分组显示
                               columnsText:'<%=labelService.getLabelNameByKeyId("402883d934c0f6b10134c0f6b1eb0000") %>',//列定义
                               groupTextTpl: '{text} ({[values.rs.length]})'
                           }),
                           frame:true,
                           collapsible: false,
                           animCollapse: true,
                           //title: '列表',
                           iconCls: 'icon-grid'
                       });
                           //Viewport
                           //ie6 bug                                                                     

                        store.on('load',function(st,recs){
                            for(var i=0;i<recs.length;i++){
                                var reqid=recs[i].get('requestid');
                                for(var j=0;j<selected.length;j++){
                                            if(reqid ==selected[j]){
                                                 sm.selectRecords([recs[i]],true);
                                             }
                                         }
                                    }
                                }
                            );

                            sm.on('rowselect',function(selMdl,rowIndex,rec ){
                                var reqid=rec.get('requestid');
                                for(var i=0;i<selected.length;i++){
                                            if(reqid ==selected[i]){
                                                 return;
                                             }
                                }
                                selected.push(reqid);
                            });
                            sm.on('rowdeselect',function(selMdl,rowIndex,rec){
                                var reqid=rec.get('requestid');
                                for(var i=0;i<selected.length;i++){
                                            if(reqid ==selected[i]){
                                                selected.remove(reqid)
                                                 return;
                                             }
                                         }

                            });
                           Ext.get('divSearch').setVisible(true);
	                       var viewport = new Ext.Viewport({
                           layout: 'border',
                           items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
	                       });
                            showOperatorsDiloge = new Ext.Window({
                               layout:'border',
                               closeAction:'hide',
                               plain: true,
                               modal :true,
                               width:viewport.getSize().width * 0.8,
                               height:viewport.getSize().height * 0.8,
                               buttons: [{
                                   text     : '<%=labelService.getLabelNameByKeyId("297eb4b8126b334801126b906528001d") %>',//关闭
                                   handler  : function() {
                                       showOperatorsDiloge.hide();
                                       showOperatorsDiloge.getComponent('dlgpanel').setSrc('about:blank');
                                   }

                               }],
                               items:[{
                                   id:'dlgpanel',
                                   region:'center',
                                   xtype     :'iframepanel',
                                   frameConfig: {
                                       autoCreate:{id:'dlgframe', name:'dlgframe', frameborder:0} ,
                                       eventsFollowFrameLinks : false
                                   },
                                   autoScroll:true
                               }]
                           });
                           showOperatorsDiloge.render(Ext.getBody());
                   });
              // Array data for the grids
                   Ext.grid.dummyData = <%=jsondata.toString()%>;
                        </script>
                                  </head>
                                  <body>
                                       

<div id="divSearch" style="display:none;" >
               <div id="pagemenubar">
			   </div>
         <!--页面菜单结束-->
              <form action="/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=<%=action%>&from=list" id="EweaverForm" name="EweaverForm" method="post">
		<input name="moduleid" type="hidden" value="">
         <table id="myTableObj" class=viewform>
              <tr>
                <td class="FieldName" width=10% nowrap><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f005f") %><!-- 流程编号 --></td>
                <td class="FieldValue" width=23% nowrap><input name="objno" value="<%=objno%>" class="InputStyle2" style="width:95%" ></td>
                <td class="FieldName" width=10% nowrap><%=labelService.getLabelName("402881f00c7690cf010c76a942a9002b")%></td>
                <td class="FieldValue" width=23%><input name="requestname" value="<%=requestname%>" class="InputStyle2" style="width:95%" ></td>
                 <td class="FieldName" width=10%><%=labelService.getLabelName("402881e50c6d5390010c6d5d5d220007")%></td><!--流程类型 -->
         <%
         String workflowname="";
         String wfname="";
         if(!StringHelper.isEmpty(workflowid)){
             workflowname=workflowinfoService.getWorkflowNames(workflowid);// StringHelper.null2String(workflowinfoService.get(workflowid).getObjname());
         	if(workflowname.length()>18){
	          wfname=workflowname.substring(0,15)+"......";
	             }else{
	              wfname=workflowname;
	          }
         }
         %>
                <td class="FieldValue" width=23%>
                        <input type="hidden" name="workflowid" value="<%=workflowid%>"/>
                       <button type="button"  class=Browser onclick="javascript:getBrowser('/base/refobj/baseobjbrowser.jsp?id=40288032239dd0ca0123a2273d270006','workflowid','workflowidspan','0');"></button>
                     <span id="workflowidspan" ext:qtip='<%= workflowname%>'><%=wfname%></span>
                </td>
              </tr>
              <tr>
         <%
                     Humres humres=null;
                     String humresname="";
                     if(!StringHelper.isEmpty(creator)){
                         humres=humresService.getHumresById(creator);
                     }else{
                            creator=StringHelper.null2String(request.getAttribute("creator"));
                            if(!StringHelper.isEmpty(creator)){
                                humres=humresService.getHumresById(creator);
                            }
                        }
                        if(humres!=null){
                            creator = humres.getId();
                            humresname=StringHelper.null2String(humres.getObjname());
                        }
         %>
                    <td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bd712c6010bd7215e7b000a")%></td>
                   <td class="FieldValue">
                        <button type="button" class=Browser onclick="javascript:getBrowser('/humres/base/humresbrowser.jsp','creator','creatorspan','0');"></button>
                        <span id=creatorspan><%=humresname%></span>
                        <input type=hidden id="creator" name=creator value="<%=creator%>">
                 </td>
                        <td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bd712c6010bd72253df000c")%></td>
                        <td class="FieldValue" align=left>
                            <input type=text class=inputstyle size=10 name="createdatefrom" value="<%=createdatefrom%>" onclick="WdatePicker()">-
                            <input type=text class=inputstyle size=10 name="createdateto" value="<%=createdateto%>" onclick="WdatePicker()">
                        </td>
                    <td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bd712c6010bd71e4c130007")%></td>
                   <td class="FieldValue">
                            <select name=isfinished disabled="true"><!-- isfinished-->
                                <option value="-1" <%if(isfinished.equals("-1")){%> selected <%}%> ></option>
                                <option value="1" <%if(isfinished.equals("1")||StringHelper.isEmpty(isfinished)){%> selected <%}%> ><%=labelService.getLabelName("402881ef0c768f6b010c76a2fc5a000b")%></option>
                                <option value="0" <%if(isfinished.equals("0")){%> selected <%}%> ><%=labelService.getLabelName("402881ef0c768f6b010c76a47202000e")%></option>
                            </select>
                        </td>
                </tr>
        <tr>
        <td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0060") %><!-- 流程单号 --></td>
        <td class="FieldValue" nowrap><input name="flowno" value="<%=flowno%>" class="InputStyle2" style="width:95%" ></td>
			<td class="FieldName" colspan=4 nowrap>

			</td>
        </tr>
             </table>
        <div id="divObj" style="display:none">
            <table id="displayTable">
                <thead>
                <tr><th colspan="8" style="background-color:#f7f7f7;height:20"><b><a href="javascript:void(0)" style="color:green"><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0061") %><!-- 当前节点操作者列表 -->:</a></b></th></tr>
                <tr style="background-color:#f7f7f7;height:20">
                <!--<th align="center"><b>ObjId</b></th>-->
                <th align="center"><b><%=labelService.getLabelNameByKeyId("402881e80c194e0a010c1a2abc860026") %><!-- 类型 --></b></th>
                <th align="center"><b><%=labelService.getLabelNameByKeyId("402881f00c7690cf010c76b1476b0034") %><!-- 操作者 --></b></th>
                </tr>
                </thead>
                <tbody id="mytbody" name="mytbody"><!-- 在这刷新 -->
                </tbody>
            </table>
        </div>
             </form>
</div>
         <script language="javascript" type="text/javascript">


        function showoperator(url){
        this.showOperatorsDiloge.getComponent('dlgpanel').setSrc(url);

        this.showOperatorsDiloge.show()

        }

//***********************DWR取得当前节点操作者列表***************************//
//         function showoperator(requestid,nodeid){
//
//            var obj=document.getElementById(requestid);
//            var rect = GetAbsoluteLocation(obj);
//            var top = rect.absoluteTop;
//            var left = rect.absoluteLeft;
//
//            var divObj=document.getElementById("divObj");
//
//            divObj.style.position="absolute";
//            divObj.style.top="0";
//            divObj.style.background="#777";
//            divObj.style.filter="progid:DXImageTransform.Microsoft.Alpha(style=3,opacity=25,finishOpacity=75";
//            divObj.style.opacity="0.6";
//            divObj.style.left="0";
//            divObj.style.width=140 + "px";
//            divObj.style.height=200 + "px";
//
//            divObj.style.display="block";
//            divObj.style.top=top+20;
//            divObj.style.left=left-100;
//            DWREngine.setAsync(false);
//            RequestbaseService.getCurrentNodeOperators(requestid,nodeid,showtable);
//            DWREngine.setAsync(true);
//         }

//         function showtable(data){
//
//                 DWRUtil.removeAllRows("mytbody");//删除table的更新元素
//                 DWRUtil.addRows("mytbody", data, [ opttype,operator ],//getCheck,getAllUnit是表的对应的列,
//                {
//                 rowCreator:function(options) {//创建行，对其进行增添颜色
//                 var row = document.createElement("tr");
//                 var index = options.rowIndex * 50;
//                 row.style.color = "#999999";
//                 row.style.height = 20;
//                 return row;
//                 },
//                 cellCreator:function(options) {//创建单元格，对其进行增添颜色
//                 var td = document.createElement("td");
//                 var index = 255 - (options.rowIndex * 50);
//                 td.style.backgroundColor = "#f7f7f7";
//                 td.style.fontWeight = "bold";
//                 return td;
//                 }
//              });
//         }
//***********************DWR取得当前节点操作者列表***************************//

    var opttype = function(data) { return data.type};

    var operator = function(data) { return '<a href="javascript:onUrl(\"/humres/base/humresview.jsp?id='+data.objid+'\",\"'+data.name+'\",\"tab'+data.objid+'\")">'+data.name+'</a>'};

         function onSearch(pageno){
             document.EweaverForm.pageno.value=pageno;
             document.EweaverForm.submit();
         }

         function onSearch2(){
             document.all('EweaverForm').action="/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=<%=action%>&isfinished=0";
             document.all('EweaverForm').submit();

         }

         function onSearch3(){

             document.all('EweaverForm').action="/workflow/request/requestbasesearch.jsp";
             document.all('EweaverForm').submit();
         }
         function reset(){
             document.forms[0].objno.value="";
             document.forms[0].requestname.value="";
             document.forms[0].workflowid.value="";
             document.getElementById("workflowidspan").innerText="";
             document.getElementById("creator").value="";
             document.getElementById("creatorspan").innerText="";
             document.forms[0].createdatefrom.value="";
             document.forms[0].createdateto.value="";
             document.forms[0].flowno.value="";
   }
   
         
         var win;
function getBrowser(viewurl,inputname,inputspan,isneed){
	var id;
	if(!Ext.isSafari){
	    try{
	    id=openDialog('/base/popupmain.jsp?url='+viewurl);
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
		document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';

            }
         }
	}else{
		   	 var callback = function() {
         try {
             id = dialog.getFrameWindow().dialogValue;
         } catch(e) {
         }
    	if (id!=null) {
			if (id[0] != '0') {
				document.all(inputname).value = id[0];
				document.all(inputspan).innerHTML = id[1];
		    }else{
				document.all(inputname).value = '';
				if (isneed=='0')
				document.all(inputspan).innerHTML = '';
				else
				document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
		
		            }
		    }
     }
	    var winHeight = Ext.getBody().getHeight() * 0.95;
	    var winWidth = Ext.getBody().getWidth() * 0.95;
	    if(winHeight>500){//最大高度500
	    	winHeight = 500;
	    }
	    if(winWidth>880){//最大宽度800
	    	winWidth = 880;
	    }
     if (!win) {
          win = new Ext.Window({
             layout:'border',
             width:winWidth,
             height:winHeight,
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
 }

	//批量审批
   function operationAll(){
		//alert(selected);
   	 if(selected.length==0){
	     Ext.Msg.buttonText={ok:'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022") %>'};//确定
	     Ext.MessageBox.alert('', '<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0066") %>');//请选择要处理的的卡片！
	     return;
     }
     Ext.Msg.buttonText={yes:'<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c") %>',no:'<%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d") %>'};//是   否   
     Ext.MessageBox.confirm('', '<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0067") %>', function (btn, text) {//您确定要处理所有选择的卡片吗?
         if (btn == 'yes') {
        	 tb.items.get("P").disable();
        	 var myMask = new Ext.LoadMask(Ext.getBody(), {
			    msg: '正在处理，请稍后...',
			    removeMask: true //完成后移除
			 });
			 myMask.show();
             Ext.Ajax.request({
            	 //timeout:100000000,
                 url: '/ServiceAction/com.eweaver.workflow.request.servlet.WorkflowAction?action=batchoperate',
                 params:{ids:selected.toString()},
                 success: function(returnstr) {
                	 	myMask.hide();
                        window.location.href=window.location.href + "&random="+Math.random();
                 }
             });
         } else {
        	 
         }
     });
   }
//*********************************得到网页中元素的绝对位置(start)*********************************//
    function GetAbsoluteLocation(element)
    {
        if ( arguments.length != 1 || element == null )
        {
            return null;
        }
        var offsetTop = element.offsetTop;
        var offsetLeft = element.offsetLeft;
        var offsetWidth = element.offsetWidth;
        var offsetHeight = element.offsetHeight;
        while( element = element.offsetParent )
        {
            offsetTop += element.offsetTop;
            offsetLeft += element.offsetLeft;
        }
        return { absoluteTop: offsetTop, absoluteLeft: offsetLeft,
            offsetWidth: offsetWidth, offsetHeight: offsetHeight };
    }
//*********************************得到网页中元素的绝对位置(end)*********************************//
     
 </script>
<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js"></script>
     </body>
   </html>
