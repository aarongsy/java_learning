<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="java.util.*" %>
<%@page import="javax.sql.DataSource"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.eweaver.base.workflow.dao.WorkFlowsync"%>
<%@ page import="org.hibernate.SessionFactory" %>
<%@page import="java.io.PrintWriter"%>
<%
		//获得workflowid
		String workflowids = StringHelper.null2String(request.getParameter("workflow"));
		String reports = StringHelper.null2String(request.getParameter("report"));
		String formids = StringHelper.null2String(request.getParameter("formid"));
		String browsers = StringHelper.null2String(request.getParameter("browser"));
		String selectitems = StringHelper.null2String(request.getParameter("selectitem"));
		String treeviewers = StringHelper.null2String(request.getParameter("treeviewer"));
		String categorys = StringHelper.null2String(request.getParameter("category"));
		String wordmodules = StringHelper.null2String(request.getParameter("wordmodule"));
		String temps = StringHelper.null2String(request.getParameter("temp"));
		String roles = StringHelper.null2String(request.getParameter("role"));
		DataService dataservices = new DataService();
		String datasource = StringHelper.null2String(request.getParameter("vdatasource"));
		String datasource2 = StringHelper.null2String(request.getParameter("vdatasource2"));
		DataService otherdataservices = new DataService();
		DataService otherdataservices2 = new DataService();
		List dsList = new ArrayList();
		if(datasource.length()>0)dsList.add(datasource);
		//if(datasource2.length()>0)dsList.add(datasource2);
		String throwstr="";
		Connection conn = null;
		PrintWriter pout = response.getWriter();


		try {
			for(int x=0;x<dsList.size();x++)
			{
				datasource=dsList.get(x).toString();
				otherdataservices._setJdbcTemplate(BaseContext.getJdbcTemp(datasource));
				//流程操作
				String[] workflowidsarr = workflowids.split(",");
				if(workflowids.length()>0)
				{

					for(int i=0,len=workflowidsarr.length;i<len;i++)
					{
						String id=workflowidsarr[i];
						//1,根据workflowid来查询对应的数据
						String sql="select * from workflowinfo w where w.id='"+id+"'";
						List<Map> list = dataservices.getValues(sql);//1,执行查询
						if(list==null||list.isEmpty()){
							pout.println("未找到"+id+"流程！！！<br/>");
							return;
						}
						String workflowname = list.get(0).get("objname").toString();
						WorkFlowsync flow = new WorkFlowsync();
						//插入到别的数据源
						List<Map> workflowlist1 = otherdataservices.getValues(sql);
						flow.changeDataSource(list,workflowlist1,"workflowinfo","id,objname,objtype,formid,isactive,isapprovable,approveobj,approveobjtype,istrigger,triggercycle,triggerdate,triggertime,helpdoc,deftitle,objdesc,col1,col2,col3,remindtype,isemail,issms,isrtx,emailmodel,msgmodel,isdelete,dsporder,ispopup,moduleid,graph,isdoc,doctemplate",datasource);
						//导入标签
						sql="select * from labelcustom where labeltype='Workflowinfo' and keyword='"+id+"' ";
						List<Map> labelcustom = dataservices.getValues(sql);//查出来的是抽象表 
						List<Map> labelcustom1 = otherdataservices.getValues(sql);//查出来的是抽象表 
						flow.changeDataSource(labelcustom,labelcustom1,"labelcustom","id",datasource);
						
						if(list!=null&&list.size()>0){
							Map map= list.get(0);
							//去把map的数据导入到另外一个数据源
							sql="select * from forminfo f where f.id='"+map.get("formid")+"' union select * from forminfo where id in (select pid from formlink where oid='"+map.get("formid")+"')";//查询出forminfo的信息。
							List<Map> forminfo = dataservices.getValues(sql);//查出来的是抽象表 
							List<Map> forminfo1 = otherdataservices.getValues(sql);//查出来的是抽象表 
			
							String formname = forminfo.get(0).get("objname").toString();
							flow.changeDataSource(forminfo,forminfo1,"forminfo","id",datasource);

							sql="select * from formfield f where f.formid='"+map.get("formid")+"' union select * from formfield where formid in (select pid from formlink where oid='"+map.get("formid")+"')";//查询出forminfo的信息。
							List<Map> formfield = dataservices.getValues(sql);//查出来的是抽象表 
							List<Map> formfield1 = otherdataservices.getValues(sql);//查出来的是抽象表 

							flow.changeDataSource(formfield,formfield1,"formfield","id",datasource);
							//导入form标签
							sql="select * from labelcustom where labeltype='FormField' and keyword in  (select id from formfield f where f.formid='"+map.get("formid")+"' union select id from formfield where formid in (select pid from formlink where oid='"+map.get("formid")+"'))";//查询出forminfo的信息。
							labelcustom = dataservices.getValues(sql);//查出来的是抽象表 
							labelcustom1 = otherdataservices.getValues(sql);//查出来的是抽象表 

							flow.changeDataSource(labelcustom,labelcustom1,"labelcustom","id",datasource);
							
							

							//导入formlink
							sql="select * from formlink f where f.oid='"+map.get("formid")+"' union select * from formlink where oid in (select pid from formlink f where f.oid='"+map.get("formid")+"') ";
							List<Map> formlink = dataservices.getValues(sql);
							List<Map> formlink1 = otherdataservices.getValues(sql);
							flow.changeDataSource(formlink,formlink1,"formlink","id",datasource);
							

							System.out.println("表"+formname+"导入成功<br/>");
							//根据workflowinfo来查询出对应的主表信息
							if(forminfo!=null&&forminfo.size()>0){
								String objtype = ((Map)forminfo.get(0)).get("objtype").toString();
								//抽象表的id到formlayout查询出相应的查出布局
								sql="select * from formlayout l where l.formid in (select id from forminfo f where f.id='"+map.get("formid")+"' union select id from forminfo where id in (select pid from formlink where oid='"+map.get("formid")+"'))";//根据主表(抽象表或者总表)来查询出对应的布局信息
								List<Map> formlayout = dataservices.getValues(sql);//查出来的是具体的布局信息
								List<Map> formlayout1 = otherdataservices.getValues(sql);//查出来的是具体的布局信息

								//插入布局的字段信息
								flow.changeDataSource(formlayout,formlayout1,"formlayout","id",datasource);
				
								//flow.InsertOtherSource(formlayout,"formlayout",otherconn,otherdataservices);
								System.out.println("布局导入成功<br/>");
								//根据布局的编号  来查询出布局中的字段信息
								if(formlayout!=null&& formlayout.size()>0){
									for (Map map2 : formlayout) {
										sql="select * from formlayoutfield l where l.layoutid='"+map2.get("id")+"'";//根据布局的编号查询出具体的字段信息
										List<Map> formlayoutfield = dataservices.getValues(sql);//查出来的是具体的布局字段信息
										List<Map> formlayoutfield1 = otherdataservices.getValues(sql);//查出来的是具体的布局字段信息
		
										//插入每个布局的具体字段信息
										flow.changeDataSource(formlayoutfield,formlayoutfield1,"formlayoutfield","id",datasource);
		
										System.out.println("布局中的详细信息成功<br/>");
									}
								}
							}
						}
						//节点间的关系
						sql="select * from export w where w.workflowid='"+id+"'";
						List<Map> export = dataservices.getValues(sql);//1,执行查询
						List<Map> export1 = otherdataservices.getValues(sql);

						flow.changeDataSource(export,export1,"export","id",datasource);
			


						sql="select * from exportdetail w where w.exportid in (select id from export where workflowid='"+id+"')";
						List<Map> exportdetail = dataservices.getValues(sql);//1,执行查询
						List<Map> exportdetail1 = otherdataservices.getValues(sql);
						flow.changeDataSource(exportdetail,exportdetail1,"exportdetail","id",datasource);
						System.out.println("export导入成功<br/>");
						
						//子节点操作
						sql="select * from subprocessset w where w.workflow1 in (select id from nodeinfo where workflowid='"+id+"')";
						List<Map> subprocessset = dataservices.getValues(sql);//1,执行查询
						List<Map> subprocessset1 = otherdataservices.getValues(sql);

						flow.changeDataSource(subprocessset,subprocessset1,"subprocessset","id",datasource);

						sql="select * from subprocesssetdetail w where w.setid in (select id from subprocessset where workflow1 in (select id from nodeinfo where workflowid='"+id+"'))";
						List<Map> subprocesssetdetail = dataservices.getValues(sql);//1,执行查询
						List<Map> subprocesssetdetail1 = otherdataservices.getValues(sql);
						flow.changeDataSource(subprocesssetdetail,subprocesssetdetail1,"subprocesssetdetail","id",datasource);
						System.out.println("subprocessset导入成功<br/>");

						//关联授权表
						sql="select * from workflowdoctype w where w.workflowid='"+id+"'";
						List<Map> workflowdoctype = dataservices.getValues(sql);//1,执行查询
						List<Map> workflowdoctype1 = otherdataservices.getValues(sql);


						flow.changeDataSource(workflowdoctype,workflowdoctype1,"workflowdoctype","id",datasource);

						System.out.println("workflowdoctype导入成功<br/>");


						//节点间的关系
						sql="select * from workflowacting w where w.workflowid='"+id+"'";
						List<Map> workflowacting = dataservices.getValues(sql);//1,执行查询
						List<Map> workflowacting1 = otherdataservices.getValues(sql);

						flow.changeDataSource(workflowacting,workflowacting1,"workflowacting","id",datasource);

						System.out.println("workflowacting导入成功<br/>");
						
	
						//根据workflowid来查询出对应的节点信息
						sql="select * from nodeinfo n where n.workflowid='"+id+"'";//根据workflowid来查询节点
						List<Map> nodes = dataservices.getValues(sql);//具体的节点信息
						List<Map> nodes1 = otherdataservices.getValues(sql);
		
						//插入这个流程的节点信息
						flow.changeDataSource(nodes,nodes1,"nodeinfo","id",datasource);
						
						
						//导入标签
						sql="select * from labelcustom where labeltype='Nodeinfo' and keyword in  (select id from nodeinfo n where n.workflowid='"+id+"')";
						labelcustom = dataservices.getValues(sql);//查出来的是抽象表 
						labelcustom1 = otherdataservices.getValues(sql);//查出来的是抽象表 
						flow.changeDataSource(labelcustom,labelcustom1,"labelcustom","id",datasource);
						System.out.println("流程节点导入成功<br/>");
						//根据节点的编号来进行查询具体的权限规则

						sql="select * from permissionrule p where p.objid in (select id from nodeinfo where workflowid='"+id+"') union  all select * from permissionrule p where p.objid='"+id+"'";//查询出具体的权限规则
						List<Map> permissionrule = dataservices.getValues(sql);//具体的权限规则
						List<Map> permissionrule1 = otherdataservices.getValues(sql);//具体的权限规则

						//插入当前节点的权限规则信息
						flow.changeDataSource(permissionrule,permissionrule1,"permissionrule","id",datasource);

						sql="select * from permissiondetail p where p.objid in (select id from nodeinfo where workflowid='"+id+"') union all select * from permissiondetail p where p.objid='"+id+"' ";
						List<Map> permissiondetail = dataservices.getValues(sql);//具体的权限规则
						List<Map> permissiondetail1 = otherdataservices.getValues(sql);//具体的权限规则

						//插入当前节点的权限的具体规则信息
						flow.changeDataSource(permissiondetail,permissiondetail1,"permissiondetail","id",datasource);

	
						throwstr=throwstr+"流程资源["+workflowname+"]导入成功！！！<br/>";

					}
				}
				//报表操作
				if(reports.length()>0)
				{
					String[] reportsarr = reports.split(",");
					for(int i=0,len=reportsarr.length;i<len;i++)
					{
						String id=reportsarr[i];
						//1,查询报表对应的数据
						String sql="select * from reportdef w where w.id='"+id+"'";
						List<Map> list = dataservices.getValues(sql);//1,执行查询
						if(list==null||list.isEmpty()){
							pout.println("未找到报表"+id+"资源<br/>");
							return;
						}
						String tempname = list.get(0).get("objname").toString();
						WorkFlowsync flow = new WorkFlowsync();
						//插入到别的数据源
						List<Map> workflowlist1 = otherdataservices.getValues(sql);
						flow.changeDataSource(list,workflowlist1,"reportdef","id",datasource);
						
						
						//报表字段
						sql="select * from reportfield w where w.reportid='"+id+"'";
						List<Map> export = dataservices.getValues(sql);//1,执行查询
						List<Map> export1 = otherdataservices.getValues(sql);
						flow.changeDataSource(export,export1,"reportfield","id",datasource);
				
						//导入标签
						sql="select * from labelcustom where labeltype='ReportField' and keyword in  (select id from reportfield w where w.reportid='"+id+"')";
						List<Map> labelcustom = dataservices.getValues(sql);//查出来的是抽象表 
						List<Map> labelcustom1 = otherdataservices.getValues(sql);//查出来的是抽象表 
						flow.changeDataSource(labelcustom,labelcustom1,"labelcustom","id",datasource);
						//报表条件
						sql="select * from reportsearchfield w where w.reportid='"+id+"'";
						export = dataservices.getValues(sql);//1,执行查询
						export1 = otherdataservices.getValues(sql);

						flow.changeDataSource(export,export1,"reportsearchfield","id",datasource);
		
						System.out.println("reportsearchfield导入成功<br/>");

						sql="select * from permissionrule p where p.objid='"+id+"'";//查询出具体的权限规则
						List<Map> permissionrule = dataservices.getValues(sql);//具体的权限规则
						List<Map> permissionrule1 = otherdataservices.getValues(sql);//具体的权限规则

						//插入当前节点的权限规则信息
						flow.changeDataSource(permissionrule,permissionrule1,"permissionrule","id",datasource);

						System.out.println("权限规则导入成功<br/>");
						sql="select * from permissiondetail p where p.objid='"+id+"'";
						List<Map> permissiondetail = dataservices.getValues(sql);//具体的权限规则
						List<Map> permissiondetail1 = otherdataservices.getValues(sql);//具体的权限规则
		
						//插入当前节点的权限的具体规则信息
						flow.changeDataSource(permissiondetail,permissiondetail1,"permissiondetail","id",datasource);
						
						System.out.println("权限规则的具体细节导入成功<br/>");
						

						throwstr=throwstr+"报表资源["+tempname+"]导入成功！！！<br/>";
					}

				}
					
				//表单操作
				if(formids.length()>0)
				{
					String[] formidsarr = formids.split(",");
					for(int i=0,len=formidsarr.length;i<len;i++)
					{
						String id=formidsarr[i];
						WorkFlowsync flow = new WorkFlowsync();
						//去把map的数据导入到另外一个数据源
						String sql="select * from forminfo f where f.id='"+id+"' union select * from forminfo where id in (select pid from formlink where oid='"+id+"')";//查询出forminfo的信息。
						List<Map> forminfo = dataservices.getValues(sql);//查出来的是抽象表 
						List<Map> forminfo1 = otherdataservices.getValues(sql);//查出来的是抽象表 

						String tempname = forminfo.get(0).get("objname").toString();
						flow.changeDataSource(forminfo,forminfo1,"forminfo","id",datasource);

						sql="select * from formfield f where f.formid='"+id+"' union select * from formfield where formid in (select pid from formlink where oid='"+id+"')";//查询出forminfo的信息。
						List<Map> formfield = dataservices.getValues(sql);//查出来的是抽象表 
						List<Map> formfield1 = otherdataservices.getValues(sql);//查出来的是抽象表 

						flow.changeDataSource(formfield,formfield1,"formfield","id",datasource);
						//导入标签
						sql="select * from labelcustom where labeltype='FormField' and keyword in  (select id from forminfo f where f.id='"+id+"' union select id from forminfo where id in (select pid from formlink where oid='"+id+"'))";//查询出forminfo的信息。
						List<Map> labelcustom = dataservices.getValues(sql);//查出来的是抽象表 
						List<Map> labelcustom1 = otherdataservices.getValues(sql);//查出来的是抽象表 
						flow.changeDataSource(labelcustom,labelcustom1,"labelcustom","id",datasource);
						

						//导入formlink
						sql="select * from formlink f where f.oid='"+id+"' union select * from formlink where oid in (select pid from formlink f where f.oid='"+id+"') ";
						List<Map> formlink = dataservices.getValues(sql);
						List<Map> formlink1 = otherdataservices.getValues(sql);
						flow.changeDataSource(formlink,formlink1,"formlink","id",datasource);
						

						System.out.println("表"+tempname+"导入成功<br/>");
						//根据workflowinfo来查询出对应的主表信息
						if(forminfo!=null&&forminfo.size()>0){
							String objtype = ((Map)forminfo.get(0)).get("objtype").toString();
							//抽象表的id到formlayout查询出相应的查出布局
							sql="select * from formlayout l where l.formid in (select id from forminfo f where f.id='"+id+"' union select id from forminfo where id in (select pid from formlink where oid='"+id+"'))";//根据主表(抽象表或者总表)来查询出对应的布局信息
							List<Map> formlayout = dataservices.getValues(sql);//查出来的是具体的布局信息
							List<Map> formlayout1 = otherdataservices.getValues(sql);//查出来的是具体的布局信息

							//插入布局的字段信息
							flow.changeDataSource(formlayout,formlayout1,"formlayout","id",datasource);
			
							//flow.InsertOtherSource(formlayout,"formlayout",otherconn,otherdataservices);
							System.out.println("布局导入成功<br/>");
							//根据布局的编号  来查询出布局中的字段信息
							if(formlayout!=null&& formlayout.size()>0){
								for (Map map2 : formlayout) {
									sql="select * from formlayoutfield l where l.layoutid='"+map2.get("id")+"'";//根据布局的编号查询出具体的字段信息
									List<Map> formlayoutfield = dataservices.getValues(sql);//查出来的是具体的布局字段信息
									List<Map> formlayoutfield1 = otherdataservices.getValues(sql);//查出来的是具体的布局字段信息
	
									//插入每个布局的具体字段信息
									flow.changeDataSource(formlayoutfield,formlayoutfield1,"formlayoutfield","id",datasource);
	
									System.out.println("布局中的详细信息成功<br/>");
								}
							}
						}
						throwstr=throwstr+"表单资源["+tempname+"]导入成功！！！<br/>";
					}
				}
				if(browsers.length()>0)
				{
					
					//broser导出
					String[] browsersarr = browsers.split(",");
					for(int i=0,len=browsersarr.length;i<len;i++)
					{
						String id=browsersarr[i];
						//1,查询报表对应的数据
						String sql="select * from refobj w where w.id='"+id+"'";
						List<Map> list = dataservices.getValues(sql);//1,执行查询
						if(list==null||list.isEmpty()){
							pout.println("未找到browser"+id+"资源<br/>");
							return;
						}
						String tempname = list.get(0).get("objname").toString();
						WorkFlowsync flow = new WorkFlowsync();
						//插入到别的数据源
						List<Map> workflowlist1 = otherdataservices.getValues(sql);
						flow.changeDataSource(list,workflowlist1,"refobj","id",datasource);

						
						throwstr=throwstr+"Browser框资源["+tempname+"]导入成功！！！<br/>";
					}
				}
					
				//select字段导出
				if(selectitems.length()>0)
				{
					String[] selectitemsarr = selectitems.split(",");
					for(int i=0,len=selectitemsarr.length;i<len;i++)
					{
						String id=selectitemsarr[i];
						//1,查询报表对应的数据
						String sql="select * from selectitemtype w where w.id='"+id+"'";
						List<Map> list = dataservices.getValues(sql);//1,执行查询
						if(list==null||list.isEmpty()){
							System.out.println("未找到"+id+"select资源<br/>");
							return;
						}
						String tempname = list.get(0).get("objname").toString();
						WorkFlowsync flow = new WorkFlowsync();
						//插入到别的数据源
						List<Map> workflowlist1 = otherdataservices.getValues(sql);
			
						flow.changeDataSource(list,workflowlist1,"selectitemtype","id",datasource);
		
						
						
						//报表字段
						sql="select * from selectitem w where w.typeid='"+id+"'";
						List<Map> export = dataservices.getValues(sql);//1,执行查询
						List<Map> export1 = otherdataservices.getValues(sql);
						flow.changeDataSource(export,export1,"selectitem","id",datasource);
			
						//导入标签
						sql="select * from labelcustom where labeltype='Selectitem' and keyword in  (select id from selectitem w where w.typeid='"+id+"')";
						List<Map> labelcustom = dataservices.getValues(sql);//查出来的是抽象表 
						List<Map> labelcustom1 = otherdataservices.getValues(sql);//查出来的是抽象表 

						flow.changeDataSource(labelcustom,labelcustom1,"labelcustom","id",datasource);
						
						
						System.out.println("selectitem导入成功<br/>");
						throwstr=throwstr+"Select字段资源["+tempname+"]导入成功！！！<br/>";
			
					}
				}

				//树型导出
				if(treeviewers.length()>0)
				{
					String[] treeviewersarr = treeviewers.split(",");
					for(int i=0,len=treeviewersarr.length;i<len;i++)
					{
						String id=treeviewersarr[i];
						//1,查询报表对应的数据
						String sql="select * from treeviewerinfo w where w.id='"+id+"'";
						List<Map> list = dataservices.getValues(sql);//1,执行查询
						if(list==null||list.isEmpty()){
							System.out.println("未找到"+id+"树型资源<br/>");
							return;
						}
						String tempname = list.get(0).get("title").toString();
						WorkFlowsync flow = new WorkFlowsync();
						//插入到别的数据源
						List<Map> workflowlist1 = otherdataservices.getValues(sql);

						flow.changeDataSource(list,workflowlist1,"treeviewerinfo","id",datasource);
						throwstr=throwstr+"树型资源["+tempname+"]导入成功！！！<br/>";
					}
				}



				//分类导出
				if(categorys.length()>0)
				{
					String[] categorysarr = categorys.split(",");
					for(int i=0,len=categorysarr.length;i<len;i++)
					{
						String id=categorysarr[i];
						//1,查询报表对应的数据
						String sql="select * from category w where w.id in (select a.id from category a,category b where a.id=b.id connect by prior  a.id=b.pid  start with a.id='"+id+"')";
						List<Map> list = dataservices.getValues(sql);//1,执行查询
						if(list==null||list.isEmpty()){
							System.out.println("未找到"+id+"分类资源<br/>");
							return;
						}
						String tempname = list.get(0).get("objname").toString();
						WorkFlowsync flow = new WorkFlowsync();
						//插入到别的数据源
						List<Map> workflowlist1 = otherdataservices.getValues(sql);

						flow.changeDataSource(list,workflowlist1,"category","id",datasource);
						
						
						//导入标签
						sql="select * from labelcustom where labeltype='Category' and keyword in  (select id from category w where w.id in (select a.id from category a,category b where a.id=b.id connect by prior  a.id=b.pid  start with a.id='"+id+"'))";
						List<Map> labelcustom = dataservices.getValues(sql);//查出来的是抽象表 
						List<Map> labelcustom1 = otherdataservices.getValues(sql);//查出来的是抽象表 
						flow.changeDataSource(labelcustom,labelcustom1,"labelcustom","id",datasource);
						
						sql="select * from categorylink w where w.categoryid in (select a.id  from category a,category b where a.id=b.id connect by prior  a.id=b.pid  start with a.id='"+id+"')";
						List<Map> export = dataservices.getValues(sql);//1,执行查询
						List<Map> export1 = otherdataservices.getValues(sql);
					
						flow.changeDataSource(export,export1,"categorylink","id,objid,objtype,categoryid,ptype,col1,col2,col3,isdelete",datasource);
					
						System.out.println("categorylink导入成功<br/>");
						sql="select * from permissionrule p where p.objid in (select a.id  from category a,category b where a.id=b.id connect by prior  a.id=b.pid  start with a.id='"+id+"')";//查询出具体的权限规则
						List<Map> permissionrule = dataservices.getValues(sql);//具体的权限规则
						List<Map> permissionrule1 = otherdataservices.getValues(sql);//具体的权限规则
			
						//插入当前节点的权限规则信息
						flow.changeDataSource(permissionrule,permissionrule1,"permissionrule","id",datasource);

						System.out.println("权限规则导入成功<br/>");
						sql="select * from permissiondetail p where p.objid in (select a.id  from category a,category b where a.id=b.id connect by prior  a.id=b.pid  start with a.id='"+id+"')";
						List<Map> permissiondetail = dataservices.getValues(sql);//具体的权限规则
						List<Map> permissiondetail1 = otherdataservices.getValues(sql);//具体的权限规则
			
						//插入当前节点的权限的具体规则信息
						flow.changeDataSource(permissiondetail,permissiondetail1,"permissiondetail","id",datasource);

						System.out.println("权限规则的具体细节导入成功<br/>");

					
						throwstr=throwstr+"分类资源["+tempname+"]导入成功！！！<br/>";
					}
				}
				//角色操作
				if(roles.length()>0)
				{
					String[] rolesarr = roles.split(",");
					for(int i=0,len=rolesarr.length;i<len;i++)
					{
						String id=rolesarr[i];
						//1,查询报表对应的数据
						String sql="select * from sysrole w where w.id='"+id+"'";
						List<Map> list = dataservices.getValues(sql);//1,执行查询
						if(list==null||list.isEmpty()){
							System.out.println("未找到"+id+"角色资源<br/>");
							return;
						}
						String tempname = list.get(0).get("rolename").toString();
						WorkFlowsync flow = new WorkFlowsync();
						//插入到别的数据源
						List<Map> workflowlist1 = otherdataservices.getValues(sql);
		
						flow.changeDataSource(list,workflowlist1,"sysrole","id",datasource);
						
						
						
						
						sql="select * from sysuserrolelink w where w.ROLEID='"+id+"'";
						List<Map> export = dataservices.getValues(sql);//1,执行查询
						List<Map> export1 = otherdataservices.getValues(sql);
			
						flow.changeDataSource(export,export1,"sysuserrolelink","id",datasource);
			
						System.out.println("sysuserrolelink导入成功<br/>");
						

						//
						sql="select * from sysrolepermlink w where w.ROLEID='"+id+"'";
						export = dataservices.getValues(sql);//1,执行查询
						export1 = otherdataservices.getValues(sql);
		
						flow.changeDataSource(export,export1,"sysrolepermlink","id",datasource);

						System.out.println("sysrolepermlink导入成功<br/>");

						sql="select * from sysperms where id in (select permid from sysrolepermlink where roleid='"+id+"')";
						export = dataservices.getValues(sql);//1,执行查询
						export1 = otherdataservices.getValues(sql);
						
						flow.changeDataSource(export,export1,"sysperms","id",datasource);
						
						System.out.println("syspermsk导入成功<br/>");
						
							

						sql="select * from syspermreslink where PERMID in (select id from sysperms where id in (select permid from sysrolepermlink where roleid='"+id+"'))";
						export = dataservices.getValues(sql);//1,执行查询
						export1 = otherdataservices.getValues(sql);
						
						flow.changeDataSource(export,export1,"syspermreslink","id",datasource);
						
						System.out.println("syspermreslink导入成功<br/>");

						
						sql="select * from sysresource where id in (select RESID from syspermreslink where PERMID in (select id from sysperms where id in (select permid from sysrolepermlink where roleid='"+id+"')))";
						export = dataservices.getValues(sql);//1,执行查询
						export1 = otherdataservices.getValues(sql);
						
						flow.changeDataSource(export,export1,"sysresource","id",datasource);
						
						System.out.println("sysrolepermlink导入成功<br/>");

	
						throwstr=throwstr+"角色资源["+tempname+"]导入成功！！！<br/>";
					
					}
				}
				//word模板
				if(temps.length()>0)
				{
					String[] tempssarr = temps.split(",");
					for(int i=0,len=tempssarr.length;i<len;i++)
					{
						String id=tempssarr[i];
						//1,查询报表对应的数据
						String sql="select * from templateviewer w where w.id='"+id+"'";
						
						List<Map> list = dataservices.getValues(sql);//1,执行查询
						if(list==null||list.isEmpty()){
							pout.println("未找到"+id+"模板资源<br/>");
							return;
						}
						String tempname = list.get(0).get("title").toString();
						WorkFlowsync flow = new WorkFlowsync();
						//插入到别的数据源
						List<Map> workflowlist1 = otherdataservices.getValues(sql);
						
						flow.changeDataSource(list,workflowlist1,"templateviewer","id",datasource);
						throwstr=throwstr+"Temp模板资源["+tempname+"]导入成功！！！<br/>";
					}
				}
				//word模板
				if(wordmodules.length()>0)
				{
					String[] wordmodulesarr = wordmodules.split(",");
					for(int i=0,len=wordmodulesarr.length;i<len;i++)
					{
						String id=wordmodulesarr[i];
						//1,查询报表对应的数据
						String sql="select * from wordmodule w where w.id='"+id+"'";
						
						List<Map> list = dataservices.getValues(sql);//1,执行查询
						if(list==null||list.isEmpty()){
							System.out.println("未找到"+id+"word模板资源<br/>");
							return;
						}
						String tempname = list.get(0).get("objname").toString();
						WorkFlowsync flow = new WorkFlowsync();
						//插入到别的数据源
						List<Map> workflowlist1 = otherdataservices.getValues(sql);
						
						flow.changeDataSource(list,workflowlist1,"wordmodule","id",datasource);
				
					
						throwstr=throwstr+"Word模板资源["+tempname+"]导入成功！！！<br/>";
					}
				}
				throwstr=throwstr+"导入数据源["+datasource+"]完成！！！<br/>";
			}

			/*//导入系统2
			if(!"".equals(datasource2))
			{
				otherdataservices2._setJdbcTemplate(BaseContext.getJdbcTemp(datasource2));
				//流程操作
				if(workflowids.length()>0)
				{
					String[] workflowidsarr = workflowids.split(",");
					for(int i=0,len=workflowidsarr.length;i<len;i++)
					{
						String id=workflowidsarr[i];
						//1,根据workflowid来查询对应的数据
						String sql="select * from workflowinfo w where w.id='"+id+"'";
						List<Map> list = dataservices.getValues(sql);//1,执行查询
						if(list==null||list.isEmpty()){
							System.out.println("未找到"+id+"流程<br/>");
							return;
						}
						String tempname = list.get(0).get("objname").toString();
						WorkFlowsync flow = new WorkFlowsync();
						//插入到别的数据源
						//List<Map> workflowlist1 = otherdataservices.getValues(sql);
						List<Map> workflowlist2 = otherdataservices2.getValues(sql);
						//flow.changeDataSource(list,workflowlist1,"workflowinfo","id,objname,objtype,formid,isactive,isapprovable,approveobj,approveobjtype,istrigger,triggercycle,triggerdate,triggertime,helpdoc,deftitle,objdesc,col1,col2,col3,remindtype,isemail,issms,isrtx,emailmodel,msgmodel,isdelete,dsporder,ispopup,moduleid,graph,isdoc,doctemplate",datasource);
						flow.changeDataSource(list,workflowlist2,"workflowinfo","id,objname,objtype,formid,isactive,isapprovable,approveobj,approveobjtype,istrigger,triggercycle,triggerdate,triggertime,helpdoc,deftitle,objdesc,col1,col2,col3,remindtype,isemail,issms,isrtx,emailmodel,msgmodel,isdelete,dsporder,ispopup,moduleid,graph,isdoc,doctemplate",datasource2);
						
						
						if(list!=null&&list.size()>0){
							Map map= list.get(0);
							//去把map的数据导入到另外一个数据源
							sql="select * from forminfo f where f.id='"+map.get("formid")+"'";//查询出forminfo的信息。
							List<Map> forminfo = dataservices.getValues(sql);//查出来的是抽象表 
							//List<Map> forminfo1 = otherdataservices.getValues(sql);//查出来的是抽象表 
							List<Map> forminfo2 = otherdataservices2.getValues(sql);//查出来的是抽象表 
							String formname = forminfo.get(0).get("objname").toString();
							//flow.changeDataSource(forminfo,forminfo1,"forminfo","id,selectitemid,objname,objdesc,objtablename,objtype,col1,col2,col3,isdelete,moduleid,formkey",datasource);
							flow.changeDataSource(forminfo,forminfo2,"forminfo","id,selectitemid,objname,objdesc,objtablename,objtype,col1,col2,col3,isdelete,moduleid,formkey",datasource2);
							System.out.println("表"+formname+"导入成功<br/>");
							//根据workflowinfo来查询出对应的主表信息
							if(forminfo!=null&&forminfo.size()>0){
								String objtype = ((Map)forminfo.get(0)).get("objtype").toString();
								//抽象表的id到formlayout查询出相应的查出布局
								sql="select * from formlayout l where l.formid='"+forminfo.get(0).get("id")+"'";//根据主表(抽象表或者总表)来查询出对应的布局信息
								List<Map> formlayout = dataservices.getValues(sql);//查出来的是具体的布局信息
								//List<Map> formlayout1 = otherdataservices.getValues(sql);//查出来的是具体的布局信息
								List<Map> formlayout2 = otherdataservices2.getValues(sql);//查出来的是具体的布局信息
								//插入布局的字段信息
								//flow.changeDataSource(formlayout,formlayout1,"formlayout","id,formid,nodeid,typeid,layoutinfo,layoutformatted,layoutname,isdefault,isdelete",datasource);
								flow.changeDataSource(formlayout,formlayout2,"formlayout","id,formid,nodeid,typeid,layoutinfo,layoutformatted,layoutname,isdefault,isdelete",datasource2);
								//flow.InsertOtherSource(formlayout,"formlayout",otherconn,otherdataservices);
								System.out.println("布局导入成功<br/>");
								//根据布局的编号  来查询出布局中的字段信息
								if(formlayout!=null&& formlayout.size()>0){
									for (Map map2 : formlayout) {
										sql="select * from formlayoutfield l where l.layoutid='"+map2.get("id")+"'";//根据布局的编号查询出具体的字段信息
										List<Map> formlayoutfield = dataservices.getValues(sql);//查出来的是具体的布局字段信息
										//List<Map> formlayoutfield1 = otherdataservices.getValues(sql);//查出来的是具体的布局字段信息
										List<Map> formlayoutfield2 = otherdataservices2.getValues(sql);//查出来的是具体的布局字段信息
										//插入每个布局的具体字段信息
										//flow.changeDataSource(formlayoutfield,formlayoutfield1,"formlayoutfield","id,layoutid,formid,fieldname,style,formula,defaultvalue,showstyle,col1,col2,col3,isdelete",datasource);
										flow.changeDataSource(formlayoutfield,formlayoutfield2,"formlayoutfield","id,layoutid,formid,fieldname,style,formula,defaultvalue,showstyle,col1,col2,col3,isdelete",datasource2);
										System.out.println("布局中的详细信息成功<br/>");
									}
								}
							}
						}
						//节点间的关系
						sql="select * from export w where w.workflowid='"+id+"'";
						List<Map> export = dataservices.getValues(sql);//1,执行查询
						//List<Map> export1 = otherdataservices.getValues(sql);
						List<Map> export2 = otherdataservices2.getValues(sql);
						//flow.changeDataSource(export,export1,"export","id,startnodeid,endnodeid,condition,linkname,btnname,workflowid,linkfrom,linkto,x1,x2,x3,x4,x5,y1,y2,y3,y4,y5,col1,col2,col3,isdelete",datasource);
						flow.changeDataSource(export,export2,"export","id,startnodeid,endnodeid,condition,linkname,btnname,workflowid,linkfrom,linkto,x1,x2,x3,x4,x5,y1,y2,y3,y4,y5,col1,col2,col3,isdelete",datasource2);
						System.out.println("export导入成功<br/>");
						
						PreparedStatement ps  = null;
						
						if(list!=null&&list.size()>0){
							Map map= list.get(0);
							//根据workflowid来查询出对应的节点信息
							sql="select * from nodeinfo n where n.workflowid='"+id+"'";//根据workflowid来查询节点
							List<Map> nodes = dataservices.getValues(sql);//具体的节点信息
							//List<Map> nodes1 = otherdataservices.getValues(sql);
							List<Map> nodes2 = otherdataservices2.getValues(sql);
							//插入这个流程的节点信息
							//flow.changeDataSource(nodes,nodes1,"nodeinfo","id,objname,workflowid,nodetype,isreject,rejectnode,refworkflowid,refnodeid,outmapping,inmapping,jointype,splittype,nodeoperaters,perpage,afterpage,isemail,issms,isrtx,emailmodel,msgmodel,istimeout,timeoutunit,timeoutstart,timeouttype,timeoutfieldid,timeoutvalue,timeoutopt,timeoutloadid,datainterface,drawxpos,drawypos,col1,col2,col3,huiqian,remindtype,savebuttonname,submitbuttonname,ynawoke,awokeinfo,nodeextpage,isautoflow,isdelete,ispopup,wordmoduleid,worddocname,wordmodulefield,worddocurl,worddochead,isstamp,isprint,istemporary,doccanedit,isdocvestige,wfredtemplate,wordredtemplate,stampfield,flowchartmethod,pflowmethod,isforward,plistmethod,sharepmethod,isrexpand,importdetail,remarkrequired,datainterface2,istemporary2,istemporary3,istemporarytext,istemporarytext2,istemporarytext3,customaction,nodestatus,ishtmldoc,htmldoclayout,htmldoccat,htmldoctitle",datasource);
							flow.changeDataSource(nodes,nodes2,"nodeinfo","id,objname,workflowid,nodetype,isreject,rejectnode,refworkflowid,refnodeid,outmapping,inmapping,jointype,splittype,nodeoperaters,perpage,afterpage,isemail,issms,isrtx,emailmodel,msgmodel,istimeout,timeoutunit,timeoutstart,timeouttype,timeoutfieldid,timeoutvalue,timeoutopt,timeoutloadid,datainterface,drawxpos,drawypos,col1,col2,col3,huiqian,remindtype,savebuttonname,submitbuttonname,ynawoke,awokeinfo,nodeextpage,isautoflow,isdelete,ispopup,wordmoduleid,worddocname,wordmodulefield,worddocurl,worddochead,isstamp,isprint,istemporary,doccanedit,isdocvestige,wfredtemplate,wordredtemplate,stampfield,flowchartmethod,pflowmethod,isforward,plistmethod,sharepmethod,isrexpand,importdetail,remarkrequired,datainterface2,istemporary2,istemporary3,istemporarytext,istemporarytext2,istemporarytext3,customaction,nodestatus,ishtmldoc,htmldoclayout,htmldoccat,htmldoctitle",datasource2);
							System.out.println("流程节点导入成功<br/>");
							//根据节点的编号来进行查询具体的权限规则
							if(nodes!=null&&nodes.size()>0){
								for (int j = 0; j < nodes.size(); j++) {
									Map nodemap = nodes.get(j);
									sql="select * from permissionrule p where p.nodeid='"+nodemap.get("id")+"'";//查询出具体的权限规则
									List<Map> permissionrule = dataservices.getValues(sql);//具体的权限规则
									//List<Map> permissionrule1 = otherdataservices.getValues(sql);//具体的权限规则
									List<Map> permissionrule2 = otherdataservices2.getValues(sql);//具体的权限规则
									//插入当前节点的权限规则信息
									//flow.changeDataSource(permissionrule,permissionrule1,"permissionrule","id,objid,istype,objtable,objfield,sharetype,roletype,orgobjtype,orgsharetype,formfieldid,roleobjid,usersharetype,orgunittype,orgmanager,userobjtype,orgobjid,userids,minseclevel,wfoperatornodeid,maxseclevel,opttype,docattopttype,wfopttype,stationobjtype,stationid,orgreftype,layoutid,layoutid1,priority,detailfilter,isdefault,isdelete,restrictionsfield,fieldof,nodeid,notifydefineid,condition",datasource);
									flow.changeDataSource(permissionrule,permissionrule2,"permissionrule","id,objid,istype,objtable,objfield,sharetype,roletype,orgobjtype,orgsharetype,formfieldid,roleobjid,usersharetype,orgunittype,orgmanager,userobjtype,orgobjid,userids,minseclevel,wfoperatornodeid,maxseclevel,opttype,docattopttype,wfopttype,stationobjtype,stationid,orgreftype,layoutid,layoutid1,priority,detailfilter,isdefault,isdelete,restrictionsfield,fieldof,nodeid,notifydefineid,condition",datasource2);
									System.out.println("流程节点的规则导入成功<br/>");
									if(permissionrule!=null&&permissionrule.size()>0){
										//循环查询出对应的具体明细规则
										for (Map map3 : permissionrule) {
											sql="select * from permissiondetail p where p.objid='"+map3.get("objid")+"'";
											List<Map> permissiondetail = dataservices.getValues(sql);//具体的权限规则
											//List<Map> permissiondetail1 = otherdataservices.getValues(sql);//具体的权限规则
											List<Map> permissiondetail2 = otherdataservices2.getValues(sql);//具体的权限规则
											//插入当前节点的权限的具体规则信息
											//flow.changeDataSource(permissiondetail,permissiondetail1,"permissiondetail","id,ruleid,objid,objtable,objfield,orgid,userid,isalluser,minseclevel,maxseclevel,opttype,docattopttype,wfopttype,stationid,isdelete",datasource);
											flow.changeDataSource(permissiondetail,permissiondetail2,"permissiondetail","id,ruleid,objid,objtable,objfield,orgid,userid,isalluser,minseclevel,maxseclevel,opttype,docattopttype,wfopttype,stationid,isdelete",datasource2);
											System.out.println("流程节点的规则的具体细节导入成功<br/>");
										}
									}
								}
							}
							
						}
				
						throwstr=throwstr+"流程资源["+tempname+"]导入成功！！！<br/>";
					}
				}
				//报表操作
				if(reports.length()>0)
				{
					String[] reportsarr = reports.split(",");
					for(int i=0,len=reportsarr.length;i<len;i++)
					{
						String id=reportsarr[i];
						//1,查询报表对应的数据
						String sql="select * from reportdef w where w.id='"+id+"'";
						List<Map> list = dataservices.getValues(sql);//1,执行查询
						if(list==null||list.isEmpty()){
							System.out.println("未找到"+id+"资源<br/>");
							return;
						}
						String tempname = list.get(0).get("objname").toString();
						WorkFlowsync flow = new WorkFlowsync();
						//插入到别的数据源
						//List<Map> workflowlist1 = otherdataservices.getValues(sql);
						List<Map> workflowlist2 = otherdataservices2.getValues(sql);
						//flow.changeDataSource(list,workflowlist1,"reportdef","id,formid,objname,objtype,objdesc,col1,col2,col3,objopts,objmodelname,objsavepath,objtype2,viewtype,groupby,isdelete,selectconditions,treeby,groupbytree,,secformid,isformbase,reportusage,moduleid,isrefresh,isexpexcel,defaulttime,isbatchupdate,groupby1,groupby2,jscontent",datasource);
						flow.changeDataSource(list,workflowlist2,"reportdef","id,formid,objname,objtype,objdesc,col1,col2,col3,objopts,objmodelname,objsavepath,objtype2,viewtype,groupby,isdelete,selectconditions,treeby,groupbytree,,secformid,isformbase,reportusage,moduleid,isrefresh,isexpexcel,defaulttime,isbatchupdate,groupby1,groupby2,jscontent",datasource2);
						
						
						//报表字段
						sql="select * from reportfield w where w.reportid='"+id+"'";
						List<Map> export = dataservices.getValues(sql);//1,执行查询
						//List<Map> export1 = otherdataservices.getValues(sql);
						List<Map> export2 = otherdataservices2.getValues(sql);
						//flow.changeDataSource(export,export1,"reportfield","id,reportid,formfieldid,dsporder,isorderfield,issum,hreflink,showname,alertcond,col1,col2,col3,showwidth,isbrowser,isdelete,showmethod,priorder,ishreffield",datasource);
						flow.changeDataSource(export,export2,"reportfield","id,reportid,formfieldid,dsporder,isorderfield,issum,hreflink,showname,alertcond,col1,col2,col3,showwidth,isbrowser,isdelete,showmethod,priorder,ishreffield",datasource2);
						System.out.println("reportfield导入成功<br/>");
			
						//报表条件
						sql="select * from reportsearchfield w where w.reportid='"+id+"'";
						export = dataservices.getValues(sql);//1,执行查询
						//export1 = otherdataservices.getValues(sql);
						export2 = otherdataservices2.getValues(sql);
						//flow.changeDataSource(export,export1,"reportsearchfield","id,reportid,formfieldid,col1,col2,col3,isquestsearch,dsporder,isdelete,isfillin",datasource);
						flow.changeDataSource(export,export2,"reportsearchfield","id,reportid,formfieldid,col1,col2,col3,isquestsearch,dsporder,isdelete,isfillin",datasource2);
						System.out.println("reportsearchfield导入成功<br/>");

						sql="select * from permissionrule p where p.objid='"+id+"'";//查询出具体的权限规则
						List<Map> permissionrule = dataservices.getValues(sql);//具体的权限规则
						//List<Map> permissionrule1 = otherdataservices.getValues(sql);//具体的权限规则
						List<Map> permissionrule2 = otherdataservices2.getValues(sql);//具体的权限规则
						//插入当前节点的权限规则信息
						//flow.changeDataSource(permissionrule,permissionrule1,"permissionrule","id,objid,istype,objtable,objfield,sharetype,roletype,orgobjtype,orgsharetype,formfieldid,roleobjid,usersharetype,orgunittype,orgmanager,userobjtype,orgobjid,userids,minseclevel,wfoperatornodeid,maxseclevel,opttype,docattopttype,wfopttype,stationobjtype,stationid,orgreftype,layoutid,layoutid1,priority,detailfilter,isdefault,isdelete,restrictionsfield,fieldof,nodeid,notifydefineid,condition",datasource);
						flow.changeDataSource(permissionrule,permissionrule2,"permissionrule","id,objid,istype,objtable,objfield,sharetype,roletype,orgobjtype,orgsharetype,formfieldid,roleobjid,usersharetype,orgunittype,orgmanager,userobjtype,orgobjid,userids,minseclevel,wfoperatornodeid,maxseclevel,opttype,docattopttype,wfopttype,stationobjtype,stationid,orgreftype,layoutid,layoutid1,priority,detailfilter,isdefault,isdelete,restrictionsfield,fieldof,nodeid,notifydefineid,condition",datasource2);
						System.out.println("权限规则导入成功<br/>");
						sql="select * from permissiondetail p where p.objid='"+id+"'";
						List<Map> permissiondetail = dataservices.getValues(sql);//具体的权限规则
						//List<Map> permissiondetail1 = otherdataservices.getValues(sql);//具体的权限规则
						List<Map> permissiondetail2 = otherdataservices2.getValues(sql);//具体的权限规则
						//插入当前节点的权限的具体规则信息
						//flow.changeDataSource(permissiondetail,permissiondetail1,"permissiondetail","id,ruleid,objid,objtable,objfield,orgid,userid,isalluser,minseclevel,maxseclevel,opttype,docattopttype,wfopttype,stationid,isdelete",datasource);
						flow.changeDataSource(permissiondetail,permissiondetail2,"permissiondetail","id,ruleid,objid,objtable,objfield,orgid,userid,isalluser,minseclevel,maxseclevel,opttype,docattopttype,wfopttype,stationid,isdelete",datasource2);
						System.out.println("权限规则的具体细节导入成功<br/>");

		
						throwstr=throwstr+"报表资源["+tempname+"]导入成功！！！<br/>";
					}
				}
					
				//表单操作
				if(formids.length()>0)
				{
					String[] formidsarr = formids.split(",");
					for(int i=0,len=formidsarr.length;i<len;i++)
					{
						String id=formidsarr[i];
						WorkFlowsync flow = new WorkFlowsync();
						//去把map的数据导入到另外一个数据源
						String sql="select * from forminfo f where f.id='"+id+"'";//查询出forminfo的信息。
						List<Map> forminfo = dataservices.getValues(sql);//查出来的是抽象表 
						//List<Map> forminfo1 = otherdataservices.getValues(sql);//查出来的是抽象表 
						List<Map> forminfo2 = otherdataservices2.getValues(sql);//查出来的是抽象表 
						String tempname = forminfo.get(0).get("objname").toString();
						//flow.changeDataSource(forminfo,forminfo1,"forminfo","id,selectitemid,objname,objdesc,objtablename,objtype,col1,col2,col3,isdelete,moduleid,formkey",datasource);
						flow.changeDataSource(forminfo,forminfo2,"forminfo","id,selectitemid,objname,objdesc,objtablename,objtype,col1,col2,col3,isdelete,moduleid,formkey",datasource2);
						System.out.println("表"+tempname+"导入成功<br/>");
						//根据workflowinfo来查询出对应的主表信息
						if(forminfo!=null&&forminfo.size()>0){
							String objtype = ((Map)forminfo.get(0)).get("objtype").toString();
							//抽象表的id到formlayout查询出相应的查出布局
							sql="select * from formlayout l where l.formid='"+forminfo.get(0).get("id")+"'";//根据主表(抽象表或者总表)来查询出对应的布局信息
							List<Map> formlayout = dataservices.getValues(sql);//查出来的是具体的布局信息
							//List<Map> formlayout1 = otherdataservices.getValues(sql);//查出来的是具体的布局信息
							List<Map> formlayout2 = otherdataservices2.getValues(sql);//查出来的是具体的布局信息
							//插入布局的字段信息
							//flow.changeDataSource(formlayout,formlayout1,"formlayout","id,formid,nodeid,typeid,layoutinfo,layoutformatted,layoutname,isdefault,isdelete",datasource);
							flow.changeDataSource(formlayout,formlayout2,"formlayout","id,formid,nodeid,typeid,layoutinfo,layoutformatted,layoutname,isdefault,isdelete",datasource2);
							//flow.InsertOtherSource(formlayout,"formlayout",otherconn,otherdataservices);
							System.out.println("布局导入成功<br/>");
							//根据布局的编号  来查询出布局中的字段信息
							if(formlayout!=null&& formlayout.size()>0){
								for (Map map2 : formlayout) {
									sql="select * from formlayoutfield l where l.layoutid='"+map2.get("id")+"'";//根据布局的编号查询出具体的字段信息
									List<Map> formlayoutfield = dataservices.getValues(sql);//查出来的是具体的布局字段信息
									//List<Map> formlayoutfield1 = otherdataservices.getValues(sql);//查出来的是具体的布局字段信息
									List<Map> formlayoutfield2 = otherdataservices2.getValues(sql);//查出来的是具体的布局字段信息
									//插入每个布局的具体字段信息
									//flow.changeDataSource(formlayoutfield,formlayoutfield1,"formlayoutfield","id,layoutid,formid,fieldname,style,formula,defaultvalue,showstyle,col1,col2,col3,isdelete",datasource);
									flow.changeDataSource(formlayoutfield,formlayoutfield2,"formlayoutfield","id,layoutid,formid,fieldname,style,formula,defaultvalue,showstyle,col1,col2,col3,isdelete",datasource2);
									System.out.println("布局中的详细信息成功<br/>");
								}
							}
						}
						throwstr=throwstr+"表单资源["+tempname+"]导入成功！！！<br/>";
					}
					
				}
					
				//broser导出
				if(browsers.length()>0)
				{
					String[] browsersarr = browsers.split(",");
					for(int i=0,len=browsersarr.length;i<len;i++)
					{
						String id=browsersarr[i];
						//1,查询报表对应的数据
						String sql="select * from refobj w where w.id='"+id+"'";
						List<Map> list = dataservices.getValues(sql);//1,执行查询
						if(list==null||list.isEmpty()){
							System.out.println("未找到"+id+"资源<br/>");
							return;
						}
						String tempname = list.get(0).get("objname").toString();
						WorkFlowsync flow = new WorkFlowsync();
						//插入到别的数据源
						//List<Map> workflowlist1 = otherdataservices.getValues(sql);
						List<Map> workflowlist2 = otherdataservices2.getValues(sql);
						//flow.changeDataSource(list,workflowlist1,"refobj","id,objname,refurl,reftable,keyfield,viewfield,viewurl,filter,isrefobjlink,col1,col2,col3,ismulti,ispermobj,isdelete,selfield,isdirectinput,moduleid,mgid",datasource);
						flow.changeDataSource(list,workflowlist2,"refobj","id,objname,refurl,reftable,keyfield,viewfield,viewurl,filter,isrefobjlink,col1,col2,col3,ismulti,ispermobj,isdelete,selfield,isdirectinput,moduleid,mgid",datasource2);
						throwstr=throwstr+"Browser框资源["+tempname+"]导入成功！！！<br/>";
						
					}
					
				}
					
				//select字段导出
				if(selectitems.length()>0)
				{
					String[] selectitemsarr = selectitems.split(",");
					for(int i=0,len=selectitemsarr.length;i<len;i++)
					{
						String id=selectitemsarr[i];
						//1,查询报表对应的数据
						String sql="select * from selectitemtype w where w.id='"+id+"'";
						List<Map> list = dataservices.getValues(sql);//1,执行查询
						if(list==null||list.isEmpty()){
							System.out.println("未找到"+id+"资源<br/>");
							return;
						}
						String tempname = list.get(0).get("objname").toString();
						WorkFlowsync flow = new WorkFlowsync();
						//插入到别的数据源
						//List<Map> workflowlist1 = otherdataservices.getValues(sql);
						List<Map> workflowlist2 = otherdataservices2.getValues(sql);
						//flow.changeDataSource(list,workflowlist1,"selectitemtype","id,objname,pid,dsporder,col3,col2,col1,isdelete,moduleid",datasource);
						flow.changeDataSource(list,workflowlist2,"selectitemtype","id,objname,pid,dsporder,col3,col2,col1,isdelete,moduleid",datasource2);
						
						
						//报表字段
						sql="select * from selectitem w where w.typeid='"+id+"'";
						List<Map> export = dataservices.getValues(sql);//1,执行查询
						//List<Map> export1 = otherdataservices.getValues(sql);
						List<Map> export2 = otherdataservices2.getValues(sql);
						//flow.changeDataSource(export,export1,"selectitem","id,objname,objdesc,pid,typeid,dsporder,col1,col2,col3,isdelete,imagefield",datasource);
						flow.changeDataSource(export,export2,"selectitem","id,objname,objdesc,pid,typeid,dsporder,col1,col2,col3,isdelete,imagefield",datasource2);
						throwstr=throwstr+"Selectitem字段资源["+tempname+"]导入成功！！！<br/>";

					}
					
				}
				if(treeviewers.length()>0)
				{

					//树型导出
					String[] treeviewersarr = treeviewers.split(",");
					for(int i=0,len=treeviewersarr.length;i<len;i++)
					{
						String id=treeviewersarr[i];
						//1,查询报表对应的数据
						String sql="select * from treeviewerinfo w where w.id='"+id+"'";
						List<Map> list = dataservices.getValues(sql);//1,执行查询
						if(list==null||list.isEmpty()){
							System.out.println("未找到"+id+"资源<br/>");
							return;
						}
						String tempname = list.get(0).get("title").toString();
						WorkFlowsync flow = new WorkFlowsync();
						//插入到别的数据源
						//List<Map> workflowlist1 = otherdataservices.getValues(sql);
						List<Map> workflowlist2 = otherdataservices2.getValues(sql);
						//flow.changeDataSource(list,workflowlist1,"treeviewerinfo","id,treetype,treeformid,treefieldname,dataformid,datakeyfield,datawhere,dataviewtext,treefieldkey,treefieldid,title,isdelete,treewhere,viewtype,subtree,menuinfo,menufun,options,moduleid,userfun",datasource);
						flow.changeDataSource(list,workflowlist2,"treeviewerinfo","id,treetype,treeformid,treefieldname,dataformid,datakeyfield,datawhere,dataviewtext,treefieldkey,treefieldid,title,isdelete,treewhere,viewtype,subtree,menuinfo,menufun,options,moduleid,userfun",datasource2);
						throwstr=throwstr+"树型资源["+tempname+"]导入成功！！！<br/>";
					}
					
				}



				//分类导出
				if(categorys.length()>0)
				{
					String[] categorysarr = categorys.split(",");
					for(int i=0,len=categorysarr.length;i<len;i++)
					{
						String id=categorysarr[i];
						//1,查询报表对应的数据
						String sql="select * from category w where w.id='"+id+"'";
						List<Map> list = dataservices.getValues(sql);//1,执行查询
						if(list==null||list.isEmpty()){
							System.out.println("未找到"+id+"资源<br/>");
							return;
						}
						String tempname = list.get(0).get("objname").toString();
						WorkFlowsync flow = new WorkFlowsync();
						//插入到别的数据源
						//List<Map> workflowlist1 = otherdataservices.getValues(sql);
						List<Map> workflowlist2 = otherdataservices2.getValues(sql);
						//flow.changeDataSource(list,workflowlist1,"category","id,pid,objname,dsporder,otype,mtype,isdelete,col1,col2,col3,workflowid,humresid,createlayoutid,viewlayoutid,editlayoutid,reflayoutid,formid,objdesc,reporid,isfastnew,moduleid,uniquefliter,isapprove,docfield,importdetail,actionclazz,istonbu,iscrossds,datasource,doctourl,datasource2,doctourl2",datasource);
						flow.changeDataSource(list,workflowlist2,"category","id,pid,objname,dsporder,otype,mtype,isdelete,col1,col2,col3,workflowid,humresid,createlayoutid,viewlayoutid,editlayoutid,reflayoutid,formid,objdesc,reporid,isfastnew,moduleid,uniquefliter,isapprove,docfield,importdetail,actionclazz,istonbu,iscrossds,datasource,doctourl,datasource2,doctourl2",datasource2);
						
						
						sql="select * from categorylink w where w.categoryid='"+id+"'";
						List<Map> export = dataservices.getValues(sql);//1,执行查询
						//List<Map> export1 = otherdataservices.getValues(sql);
						List<Map> export2 = otherdataservices2.getValues(sql);
						//flow.changeDataSource(export,export1,"categorylink","id,objid,objtype,categoryid,ptype,col1,col2,col3,isdelete",datasource);
						flow.changeDataSource(export,export2,"categorylink","id,objid,objtype,categoryid,ptype,col1,col2,col3,isdelete",datasource2);
						System.out.println("categorylink导入成功<br/>");
						sql="select * from permissionrule p where p.objid='"+id+"'";//查询出具体的权限规则
						List<Map> permissionrule = dataservices.getValues(sql);//具体的权限规则
						//List<Map> permissionrule1 = otherdataservices.getValues(sql);//具体的权限规则
						List<Map> permissionrule2 = otherdataservices2.getValues(sql);//具体的权限规则
						//插入当前节点的权限规则信息
						//flow.changeDataSource(permissionrule,permissionrule1,"permissionrule","id,objid,istype,objtable,objfield,sharetype,roletype,orgobjtype,orgsharetype,formfieldid,roleobjid,usersharetype,orgunittype,orgmanager,userobjtype,orgobjid,userids,minseclevel,wfoperatornodeid,maxseclevel,opttype,docattopttype,wfopttype,stationobjtype,stationid,orgreftype,layoutid,layoutid1,priority,detailfilter,isdefault,isdelete,restrictionsfield,fieldof,nodeid,notifydefineid,condition",datasource);
						flow.changeDataSource(permissionrule,permissionrule2,"permissionrule","id,objid,istype,objtable,objfield,sharetype,roletype,orgobjtype,orgsharetype,formfieldid,roleobjid,usersharetype,orgunittype,orgmanager,userobjtype,orgobjid,userids,minseclevel,wfoperatornodeid,maxseclevel,opttype,docattopttype,wfopttype,stationobjtype,stationid,orgreftype,layoutid,layoutid1,priority,detailfilter,isdefault,isdelete,restrictionsfield,fieldof,nodeid,notifydefineid,condition",datasource2);
						System.out.println("权限规则导入成功<br/>");
						sql="select * from permissiondetail p where p.objid='"+id+"'";
						List<Map> permissiondetail = dataservices.getValues(sql);//具体的权限规则
						//List<Map> permissiondetail1 = otherdataservices.getValues(sql);//具体的权限规则
						List<Map> permissiondetail2 = otherdataservices2.getValues(sql);//具体的权限规则
						//插入当前节点的权限的具体规则信息
						//flow.changeDataSource(permissiondetail,permissiondetail1,"permissiondetail","id,ruleid,objid,objtable,objfield,orgid,userid,isalluser,minseclevel,maxseclevel,opttype,docattopttype,wfopttype,stationid,isdelete",datasource);
						flow.changeDataSource(permissiondetail,permissiondetail2,"permissiondetail","id,ruleid,objid,objtable,objfield,orgid,userid,isalluser,minseclevel,maxseclevel,opttype,docattopttype,wfopttype,stationid,isdelete",datasource2);
						System.out.println("权限规则的具体细节导入成功<br/>");

						throwstr=throwstr+"分类资源["+tempname+"]导入成功！！！<br/>";
			
					}
					
				}
				//角色操作
				if(roles.length()>0)
				{
					String[] rolesarr = roles.split(",");
					for(int i=0,len=rolesarr.length;i<len;i++)
					{
						String id=rolesarr[i];
						//1,查询报表对应的数据
						String sql="select * from sysrole w where w.id='"+id+"'";
						List<Map> list = dataservices.getValues(sql);//1,执行查询
						if(list==null||list.isEmpty()){
							System.out.println("未找到"+id+"资源<br/>");
							return;
						}
						String tempname = list.get(0).get("rolename").toString();
						WorkFlowsync flow = new WorkFlowsync();
						//插入到别的数据源
						//List<Map> workflowlist1 = otherdataservices.getValues(sql);
						List<Map> workflowlist2 = otherdataservices2.getValues(sql);
						//flow.changeDataSource(list,workflowlist1,"sysrole","id,rolename,roledesc,roletype,isdelete",datasource);
						flow.changeDataSource(list,workflowlist2,"sysrole","id,rolename,roledesc,roletype,isdelete",datasource2);
						
						
						
						sql="select * from sysuserrolelink w where w.ROLEID='"+id+"'";
						List<Map> export = dataservices.getValues(sql);//1,执行查询
						//List<Map> export1 = otherdataservices.getValues(sql);
						List<Map> export2 = otherdataservices2.getValues(sql);
						//flow.changeDataSource(export,export1,"sysuserrolelink","id,userid,roleid,rolelevel,isdelete",datasource);
						flow.changeDataSource(export,export2,"sysuserrolelink","id,userid,roleid,rolelevel,isdelete",datasource2);
						System.out.println("sysuserrolelink导入成功<br/>");
						

						//
						sql="select * from sysrolepermlink w where w.ROLEID='"+id+"'";
						export = dataservices.getValues(sql);//1,执行查询
						//export1 = otherdataservices.getValues(sql);
						export2 = otherdataservices2.getValues(sql);
						//flow.changeDataSource(export,export1,"sysrolepermlink","roleid,permid",datasource);
						flow.changeDataSource(export,export2,"sysrolepermlink","roleid,permid",datasource2);
						System.out.println("sysrolepermlink导入成功<br/>");

						sql="select * from sysperms where id in (select permid from sysrolepermlink where roleid='"+id+"')";
						export = dataservices.getValues(sql);//1,执行查询
						//export1 = otherdataservices.getValues(sql);
						export2 = otherdataservices2.getValues(sql);
						//flow.changeDataSource(export,export1,"sysperms","id,permname,operation,permdesc,objtype,isdelete,syspermreslink,permid",datasource);
						flow.changeDataSource(export,export2,"sysperms","id,permname,operation,permdesc,objtype,isdelete,syspermreslink,permid",datasource2);
						System.out.println("syspermsk导入成功<br/>");
						
							

						sql="select * from syspermreslink where PERMID in (select id from sysperms where id in (select permid from sysrolepermlink where roleid='"+id+"'))";
						export = dataservices.getValues(sql);//1,执行查询
						//export1 = otherdataservices.getValues(sql);
						export2 = otherdataservices2.getValues(sql);
						//flow.changeDataSource(export,export1,"syspermreslink","permid,resid",datasource);
						flow.changeDataSource(export,export2,"syspermreslink","permid,resid",datasource2);
						System.out.println("syspermreslink导入成功<br/>");

						
						sql="select * from sysresource where id in (select RESID from syspermreslink where PERMID in (select id from sysperms where id in (select permid from sysrolepermlink where roleid='"+id+"')))";
						export = dataservices.getValues(sql);//1,执行查询
						//export1 = otherdataservices.getValues(sql);
						export2 = otherdataservices2.getValues(sql);
						//flow.changeDataSource(export,export1,"sysresource","id,resname,restype,resstring,pid,objtype,resdesc,logtype,islog,col1,col2,col3,isdelete",datasource);
						flow.changeDataSource(export,export2,"sysresource","id,resname,restype,resstring,pid,objtype,resdesc,logtype,islog,col1,col2,col3,isdelete",datasource2);
						System.out.println("sysrolepermlink导入成功<br/>");

						throwstr=throwstr+"角色资源["+tempname+"]导入成功！！！<br/>";
					
					}
					
				}

				//word模板
				if(wordmodules.length()>0)
				{
					String[] wordmodulesarr = wordmodules.split(",");
					for(int i=0,len=wordmodulesarr.length;i<len;i++)
					{
						String id=wordmodulesarr[i];
						//1,查询报表对应的数据
						String sql="select * from wordmodule w where w.id='"+id+"'";
						List<Map> list = dataservices.getValues(sql);//1,执行查询
						if(list==null||list.isEmpty()){
							System.out.println("未找到"+id+"资源<br/>");
							return;
						}
						String tempname = list.get(0).get("objname").toString();
						WorkFlowsync flow = new WorkFlowsync();
						//插入到别的数据源
						//List<Map> workflowlist1 = otherdataservices.getValues(sql);
						List<Map> workflowlist2 = otherdataservices2.getValues(sql);
						//flow.changeDataSource(list,workflowlist1,"wordmodule","id,objname,objdesc,attachid,isdelete",datasource);
						flow.changeDataSource(list,workflowlist2,"wordmodule","id,objname,objdesc,attachid,isdelete",datasource2);
						System.out.println("1、"+tempname+"导入成功<br/>");
						throwstr=throwstr+"word模板资源["+tempname+"]导入成功！！！<br/>";
					}
					
				}
				throwstr=throwstr+"导入数据源["+datasource2+"]完成！！！<br/>";
			}*/
			SessionFactory sessionFactory = (SessionFactory)BaseContext.getBean("sessionFactory");
			sessionFactory.evict( com.eweaver.base.orgunit.model.Orgunit.class);
			sessionFactory.evict( com.eweaver.humres.base.model.Humres.class);
			sessionFactory.evict( com.eweaver.humres.base.model.Stationinfo.class);
			sessionFactory.evict( com.eweaver.humres.base.model.Stationlink.class);
			sessionFactory.evict( com.eweaver.base.orgunit.model.Orgunitlink.class);
            sessionFactory.evictQueries();

		} catch (Exception e) {
			// TODO: handle exception
			throwstr=throwstr+e.getMessage();
		}
		String url=request.getContextPath()+"/app/manager/inputOutWorkFlow.jsp?throwstr="+throwstr;
    	request.getRequestDispatcher(url).forward(request, response);
%>