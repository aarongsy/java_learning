<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.*"%>
<%@page import="java.util.HashMap"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.eweaver.blog.AppDao"%>
<%@page import="com.eweaver.blog.BlogDao"%>
<%@page import="com.eweaver.blog.BlogManager"%>
<%@page import="java.util.List"%>
<%@page import="com.eweaver.blog.BlogDiscessVo"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@page import="com.eweaver.base.util.NumberHelper"%>
<%@page import="com.eweaver.base.BaseJdbcDao"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.humres.base.model.Humres"%>

<%
	BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao"); 
    HashMap result=new HashMap();
	//User user = HrmUserVarify.getUser (request , response) ;
	Humres user = BaseContext.getRemoteUser().getHumres();
    if(user==null){
    	result.put("status","2"); //超时
    	JSONObject json=JSONObject.fromObject(result);
		out.println(json);
    }else {
	request.setCharacterEncoding("UTF-8");
	Date today=new Date();
	String userid=""+user.getId();
	String curDate=new SimpleDateFormat("yyyy-MM-dd").format(today);//当前日期
	String curTime=new SimpleDateFormat("HH:mm:ss").format(today);//当前时间
	SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat dateFormat3=new SimpleDateFormat("yyyy年M月d日 HH:mm");
	
	String content=StringHelper.null2String(request.getParameter("content"));//日志内容
	String forDate=StringHelper.null2String(request.getParameter("forDate"));
	String appType=StringHelper.null2String(request.getParameter("type"));
	String appItemId=StringHelper.null2String(request.getParameter("appItemId"));
	int discussid=NumberHelper.getIntegerValue(request.getParameter("discussid")).intValue();
	
	//防止数据传输缺失
	if(content.equals("")||forDate.equals("")||appItemId.equals("0")){
		result.put("status","3");
		JSONObject json=JSONObject.fromObject(result);
		out.println(json);
	}else{
		appItemId=appItemId.equals("2")?appItemId:"1"; //处理心情丢失情况	
		String score="0";
		String comefrom="0";
		
		BlogDao blogDao=new BlogDao();
		String isManagerScore=blogDao.getSysSetting("isManagerScore");  //启用上级评分
		
  		boolean isEdit=discussid==0?false:true;  //是否是编辑
		
		String lastUpdateTime=""+today.getTime();
		String sql="";
		AppDao appDao=new AppDao();
		boolean isAppend=false;
		try{
			Object[] objects = null;
		if(!isEdit){ //如果微博记录id=0 则表示为创建
			BlogDiscessVo discessVo=blogDao.getDiscussVoByDate(userid,forDate);
			if(discessVo!=null){
				isAppend=true;
				content=discessVo.getContent()+content;
				sql="update blog_discuss set lastUpdatetime=?,content=? where id=?";
				/*
				cs.setStatementSql(sql);
				cs.setString(1,lastUpdateTime);
				cs.setString(2,content);
				cs.setString(3,discessVo.getId());
				*/
				objects = new Object[3];
				objects[0]=lastUpdateTime;
				objects[1]=content;
				objects[2]=discessVo.getId();
			}else{
				sql="insert into blog_discuss (userid, createdate, createtime,content,lastUpdatetime,isReplenish,workdate,score,comefrom)"+
					"values (?,?,?,?,?,?,?,?,?)";
				/*
				cs.setStatementSql(sql);
				cs.setString(1,""+userid);
				cs.setString(2,""+curDate);
				cs.setString(3,""+curTime);
				cs.setString(4,""+content);
				cs.setString(5,""+lastUpdateTime);
				cs.setString(6,""+(forDate.equals(curDate)?"0":"1"));
				cs.setString(7,""+forDate);
				cs.setString(8,"0");
				cs.setString(9,"0");
				*/
				objects = new Object[9];
				objects[0]=userid;
				objects[1]=curDate;
				objects[2]=curTime;
				objects[3]=content;
				objects[4]=lastUpdateTime;
				objects[5]=(forDate.equals(curDate)?"0":"1");
				objects[6]=forDate;
				objects[7]=0;
				objects[8]=0;
			}
		
		}else{            //更新
			sql="update blog_discuss set lastUpdatetime=?,content=? where id=?";
			/*
			cs.setStatementSql(sql);
			cs.setString(1,""+lastUpdateTime);
			cs.setString(2,""+content);
			cs.setString(3,""+discussid);
			*/
			objects = new Object[3];
			objects[0]=lastUpdateTime;
			objects[1]=content;
			objects[2]=discussid;
		}
		int updateCount = baseJdbcDao.update(sql,objects);
		HashMap backData=new HashMap();
		if(updateCount>0){
			//如果是编辑，则取创建时的时间
			if(isEdit){
				BlogDiscessVo discessVo=blogDao.getDiscussVo(discussid+"");
				curDate=discessVo.getCreatedate();
				curTime=discessVo.getCreatetime();
				score=discessVo.getScore();
				comefrom=discessVo.getComefrom();
			}
			//discuss=0表示新建
			if(!isEdit){
				sql="select max(id) as maxid  from blog_discuss where userid='"+userid+"'";
				/*
				rs.executeSql(sql);
				if(rs.next()){
					discussid=rs.getInt("maxid");
				}*/
				List list = baseJdbcDao.executeSqlForList(sql);
				if(list.size()>0){
					Map tempMap = (Map)list.get(0);
					discussid = NumberHelper.getIntegerValue(tempMap.get("maxid")).intValue();
				}
			}
			
			backData.put("id",discussid);
			backData.put("curDate",curDate);
			backData.put("curTime",curTime);
			backData.put("forDate",forDate);
			
			String createdatetime=dateFormat3.format(dateFormat.parse(curDate+" "+curTime));
			backData.put("createdatetime",createdatetime);
			backData.put("score",score);
			backData.put("isManagerScore",isManagerScore);
			
			backData.put("comefrom",comefrom);
			
			backData.put("userName",user.getObjname());
			backData.put("userid",""+user.getId());
			
			String type=(!forDate.equals(curDate))?"1":"0"; //是否为补交  1补交 0正常提交
			backData.put("type",type);
			
			result.put("status","1");  //保存是否成功
			
			if(appDao.getAppVoByType("mood").isActive()){
				if(!isEdit&&!isAppend){
					sql="INSERT INTO blog_appDatas(userid,workDate,createDate,createTime,discussid,appitemId)"+
						 "VALUES('"+user.getId()+"','"+forDate+"','"+curDate+"','"+curTime+"','"+discussid+"','"+appItemId+"')";
				}else{
					sql="update blog_appDatas set  appitemId='"+appItemId+"' where discussid='"+discussid+"'";
				}
				//rs.executeSql(sql);
				baseJdbcDao.update(sql);
				sql="SELECT * FROM blog_appDatas LEFT JOIN blog_AppItem ON blog_appDatas.appItemId=blog_AppItem.id WHERE discussid='"+discussid+"'";
				//rs.executeSql(sql);
				List list = baseJdbcDao.executeSqlForList(sql);
				if(list.size()>0){
					Map tempMap = (Map)list.get(0);
					backData.put("appItemId",appItemId);
					backData.put("faceImg",StringHelper.null2String(tempMap.get("face")));
					int itemNameIndex = NumberHelper.getIntegerValue(tempMap.get("itemName"),0).intValue();
					if(itemNameIndex==26917){
						backData.put("itemName","高兴");
					}else{
						backData.put("itemName","不高兴");
					}
				}
			}
			//提交新的微博时给予提醒
			if(!isEdit&&!isAppend){
				//删除阅读记录
				sql="DELETE FROM blog_read WHERE blogid='"+user.getId()+"'";
				baseJdbcDao.update(sql);
				
				//给关注我的人发送微博提交提醒
				List attentionMeList=blogDao.getAttentionMe(userid);
				for(int i=0;i<attentionMeList.size();i++){
					blogDao.addRemind((String)attentionMeList.get(i),userid,"6",""+discussid,"0");
				}
			}
			
			result.put("backdata",backData);
			JSONObject json=JSONObject.fromObject(result);
			out.println(json);
			
		}else{
			result.put("status","0");
			JSONObject json=JSONObject.fromObject(result);
			out.println(json);
		}
		}catch(Exception e){
			e.printStackTrace();
		}
		finally{
		}
	    }
    }
%>