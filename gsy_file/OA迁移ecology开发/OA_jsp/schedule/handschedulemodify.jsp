<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.base.security.service.acegi.EweaverUser"%>
<%@page import="com.eweaver.base.DataService"%>
<%@page import="com.eweaver.base.IDGernerator"%>
<%@page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%
		String gettodaydate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
		EweaverUser newUser = BaseContext.getRemoteUser();
		String newuserid = newUser.getId();//当前登录用户
		OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
		
		DataService dataService = new DataService();
		
		String createdate = new Date().toLocaleString();
		String [] getarry = createdate.split(" ");
		String getdate = getarry[0].toString();
		String gettiem = getarry[1].toString();
		IDGernerator idGernerator = new IDGernerator();
		//String requid = idGernerator.getUnquieID();
		String richengren = StringHelper.null2String(request.getParameter("richengren"));//日程人
		//String tijiaoren = StringHelper.null2String(request.getParameter("field_4028818230686b49013069c812b800e0"));//提交人
		//String tijiaobumen = StringHelper.null2String(request.getParameter("field_4028818230686b49013068db5724001a"));//提交部门
		  String tijiaoren = newuserid;
		  String tijiaobumen = newUser.getOrgid();
		//String iseditorsave = StringHelper.null2String(request.getParameter("iseditorsave"));//1:save or 0:edit
		String requestid = StringHelper.null2String(request.getParameter("requestid")); //主表id
		
		String tijiaoriqi = StringHelper.null2String(request.getParameter("Fileddate"));//提交日期
		String richengleixing = StringHelper.null2String(request.getParameter("richengleixing"));//日程类型
		String isnewcreate = StringHelper.null2String(request.getParameter("tempvalue"));//判断是否新建
		String startdate = StringHelper.null2String(request.getParameter("startdate"));//开始时间
		String enddate = StringHelper.null2String(request.getParameter("enddate"));//结束时间
		String neirong = StringHelper.null2String(request.getParameter("neirong"));//工作内容
		String gsadress = StringHelper.null2String(request.getParameter("gsadress"));//公司地点
		//String isoldvalue = StringHelper.null2String(request.getParameter("richengold"));//是否是原来值
		String biaoti = StringHelper.null2String(request.getParameter("biaoti"));//标题
		String weekdate = StringHelper.null2String(request.getParameter("weekdate"));//日期
		
		/**关闭提醒***/
		String txid=StringHelper.null2String(request.getParameter("txid"));
		String txxsql = "update uf_configuration_xx t set t.TXIFOPER=1 where t.id='"
   						+ txid + "'";
   		int txi = dataService.executeSql(txxsql);
		String [] gettimeval = request.getParameterValues("FieldTime");//取得时间
		String [] getdidianarry = request.getParameterValues("idennumber");//地点
		String [] getworktext = request.getParameterValues("InputStyle2");//工作内容
		
		String [] getweek ={"星期一","星期二","星期三","星期四","星期五","星期六","星期日"};
		
		if(!"".equals(startdate)){
			gettodaydate = startdate;
		}
		if("40288182306cae59013072625b240703".equals(richengleixing)){
			richengren = "";
		}
		if(neirong.indexOf(" ")>0){
			neirong = neirong.replaceAll(" ","");
		}
		
		if(StringHelper.isEmpty(requestid)){
			requestid = idGernerator.getUnquieID();
			String formbasesql = "insert into formbase(id,creator,createdate,createtime,modifier,modifytime,isdelete,categoryid,col1,col2,col3) "+
			"values('"+requestid+"','"+newuserid+"','"+getdate+"','"+gettiem+"','','',0,'','','','')";
			dataService.executeSql(formbasesql);
			
			String schedulesql = "insert into uf_schedule(id,requestid,nodeid,rowindex,richengren,tijiaoren,tijiaobumen,tijiaoriqi,isdelete,richenshijian,richengleixing,jieshuriqi,gongzuoneirong,biaoti,weekdate,kaishiriqi,gsdidian) "+
			"values('"+idGernerator.getUnquieID()+"','"+requestid+"','','','"+richengren+"','"+tijiaoren+"','"+tijiaobumen+"','"+tijiaoriqi+"',0,'"+weekdate+"','"+richengleixing+"','"+enddate+"','"+neirong+"','"+biaoti+"','"+weekdate+"','"+startdate+"','"+gsadress+"')";	
			int mainreturnvalue = dataService.executeSql(schedulesql);
			int detailreturnvalue = 0;
			//System.out.println(schedulesql);
			if(!"40288182306cae59013072625b240703".equals(richengleixing)){
				for(int k=0;k<getweek.length;k++){
					String detailid = idGernerator.getUnquieID(); //明细表id
					String scheduledetailinsert = "insert into uf_scheduledetail(id,requestid,nodeid,rowindex,relations,didian,neirong,xingqi,shijian) "+
					"values('"+detailid+"','"+requestid+"','','','','"+getdidianarry[k]+"','"+getworktext[k]+"','"+getweek[k]+"','"+gettimeval[k]+"')";
					detailreturnvalue = dataService.executeSql(scheduledetailinsert);
				}
			}

			if(mainreturnvalue>0){
				
				out.print("<script>alert('保存成功!');window.top.close();</script>");
			}else{
				out.print("<script>alert('保存失败!');window.top.close();</script>");
			}

		}else{
			  String updateschedule = "";
			  if(!StringHelper.isEmpty(weekdate)){
				  updateschedule = "update uf_schedule set tijiaoren='"+tijiaoren+"',"+
				  "tijiaobumen='"+tijiaobumen+"',tijiaoriqi='"+tijiaoriqi+"',richengleixing='"+richengleixing+"',"+
				  "jieshuriqi='"+enddate+"',richenshijian='"+weekdate+"',gongzuoneirong='"+neirong+"',"+
				  "biaoti='"+biaoti+"',kaishiriqi='"+startdate+"',weekdate='"+weekdate+"',gsdidian='"+gsadress+"' where requestid='"+requestid+"'";
			  }else{
				  updateschedule = "update uf_schedule set tijiaoren='"+tijiaoren+"',"+
				  "tijiaobumen='"+tijiaobumen+"',tijiaoriqi='"+tijiaoriqi+"',richengleixing='"+richengleixing+"',"+
				  "jieshuriqi='"+enddate+"',gongzuoneirong='"+neirong+"',"+
				  "biaoti='"+biaoti+"',kaishiriqi='"+startdate+"',gsdidian='"+gsadress+"' where requestid='"+requestid+"'";
			  }
			  dataService.executeSql(updateschedule);
			 
			  
			   if(!"40288182306cae59013072625b240703".equals(richengleixing)){
				   String selectdetasqls = "select id from uf_scheduledetail where requestid='"+requestid+"' order by shijian asc";
				   List getdetaildetas = dataService.getValues(selectdetasqls); 
				   
				   Map getidmap = new HashMap();
					for(int k=0;k<getweek.length;k++){
						
						if(getdetaildetas.size()>0){
							getidmap = (Map)getdetaildetas.get(k);
						}
						String updatesql = "update uf_scheduledetail set didian='"+getdidianarry[k]+"',neirong='"+getworktext[k]+"' where id='"+StringHelper.null2String(getidmap.get("id"))+"'";
						dataService.executeSql(updatesql);
					} 
				   
			   }
		}

		response.sendRedirect("/schedule/companyshow.jsp?requestid="+requestid);

%>
