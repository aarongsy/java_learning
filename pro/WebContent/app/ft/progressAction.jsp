<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService" %>
<%
	EweaverUser eweaveruser = BaseContext.getRemoteUser();
	String action=StringHelper.null2String(request.getParameter("action"));
	String isonlytree=StringHelper.null2String(request.getParameter("isonlytree"));
	String nodeid = StringHelper.null2String(request.getParameter("node"));
	DataService ds = new DataService();
	if(action.equals("finish"))
	{
		String processid = StringHelper.null2String(request.getParameter("processid"));
		String finishdate = StringHelper.null2String(request.getParameter("finishdate"));
		StringBuffer buf = new StringBuffer();
		ds.executeSql("update uf_income_pcprocess set finishdate='"+finishdate+"',status=1 where requestid='"+processid+"'");
		buf.append("ok");
		response.getWriter().print(buf.toString());
		return;
	}
	else if(action.equals("finishcancel"))
	{
		String processid = StringHelper.null2String(request.getParameter("processid"));

		StringBuffer buf = new StringBuffer();
		ds.executeSql("update uf_income_pcprocess set finishdate=null,status=0 where requestid='"+processid+"'");
		buf.append("ok");
		response.getWriter().print(buf.toString());
		return;
	}	
	
%><%!
	//字符串加1,整数最大9
	public  String StringAdd(String str){
		//取字符串长度
		String rstr="";
		int n=0;
		char[] ch=str.toCharArray();
		boolean bool=false;
		for(int i=ch.length-1;i>=0;i--){
			if(ch[i]==122||ch[i]==90||ch[i]==57){
				ch[i]=48;
			}
			else{
				int k =(int) ch[i];
				if((int) ch[i]>=48&& (int) ch[i]<57){
					ch[i]=(char) (k+1);
					bool=true;
				}
				if( (int) ch[i]>=65&& (int) ch[i]<90){
					ch[i]=(char) (k+1);
					bool=true;
				}
				if( (int) ch[i]>=97&& (int) ch[i]<122){
					ch[i]=(char) (k+1);
					bool=true;
				}
			}
			n=n+1;
			rstr=String.valueOf(ch[i])+rstr;
			if(bool) break;
		}
		rstr=str.substring(0,str.length()-n)+rstr;
		return rstr;
	}
	private String add0(String str,int len)
	{
		for(int i=len,tlen=str.length();i>tlen;i--)
		{
			str="0"+str;
		}
		return str;
	}
%>