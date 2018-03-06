<%@ page contentType="text/html; charset=UTF-8"%><%@ page import="com.eweaver.base.BaseContext" %><%@ page import="com.eweaver.base.BaseJdbcDao" %><%@ page import="com.eweaver.base.*" %><%@ page import="com.eweaver.base.util.*" %><%@ page import="java.util.*" %><%@ page import="java.text.SimpleDateFormat" %>
<%
	String uptype= request.getParameter("uptype");
	//var _url = contextPath+'/app/ft/submitCheck.jsp?uptype=contractno&typeid='+typeid+'&subtypeid='+subtypeid+'&dept='+dept+'&flowno='+flowno+'&xz='+xz;     
	if(uptype.equals("contractno"))
	{
		String typeid= request.getParameter("typeid");
		String subtypeid = request.getParameter("subtypeid");
		String dept = request.getParameter("dept");
		String flowno = request.getParameter("flowno");
		int maxlen=Integer.parseInt(StringHelper.null2String(request.getParameter("flowno"),"3"));
		if(dept!=null&&dept.indexOf(",")>-1)
			dept=dept.substring(0,dept.indexOf(","));
		String xz = request.getParameter("xz");
		if(xz==null)xz="";
		if(xz.length()>0&&xz.equals("2c91a0302b13190a012b1473429b02ab"))
			typeid="2c91a0302a8cef72012a8ea9390903c6";
		String sql = "";
		DataService ds= new DataService();
		List ls=null;
		if(typeid.equals("2c91a0302bbcd476012c0c0a2692359d"))
		{
			//sql1 = "select nvl(max(to_number(translate(substr(seq,3,length(seq)),'0123456789abcdefghigjmlnopqrstuvwxyz-ABCDEFGHIGJMLNOPQRSTUVWXYZ','0123456789')))+1,1) from (select substr(no,instr(no,'-',1,1)+1,instr(no,'-',1,2)-instr(no,'-',1,1)-1) seq from (select a.no,a.classes from uf_contract a union select b.flowno no,'2c91a0302a8cef72012a8ea9390903c7' classes from uf_ctr_income b) where no like  (select objdesc from selectitem where id='"+typeid+"')||(select objdesc from selectitem where id='"+subtypeid+"')||'%') where seq like '"+DateHelper.getCurrentDate().substring(2,4)+"%'";
			sql="select nvl(max(to_number(translate(substr(seq,3,length(seq)),'0123456789abcdefghigjmlnopqrstuvwxyz-ABCDEFGHIGJMLNOPQRSTUVWXYZ','0123456789')))+1,1) from (select substr(no,instr(no,'-',1,1)+1,instr(no,'-',1,2)-instr(no,'-',1,1)-1) seq from (select a.no,a.classes from uf_contract a union select b.flowno no,'2c91a0302a8cef72012a8ea9390903c7' classes from uf_ctr_income b)) where seq like '"+DateHelper.getCurrentDate().substring(2,4)+"%'";
		}
		else
		{
			sql = "select nvl(max(to_number(translate(substr(seq,3,length(seq)),'0123456789abcdefghigjmlnopqrstuvwxyz-ABCDEFGHIGJMLNOPQRSTUVWXYZ','0123456789')))+1,1) from (select substr(no,instr(no,'-',1,1)+1,instr(no,'-',1,2)-instr(no,'-',1,1)-1) seq from (select a.no,a.classes from uf_contract a union select b.flowno no,'2c91a0302a8cef72012a8ea9390903c6' classes from uf_ctr_income b) where substr(no,0,1)=(select objdesc from selectitem where id='"+typeid+"')) where seq like '"+DateHelper.getCurrentDate().substring(2,4)+"%'";
		}
		//	
		String seq = ds.getValue(sql);
		if(seq==null)seq="1";
		seq=add0(seq,maxlen);

		sql = "select (select objdesc from selectitem where id='"+typeid+"')||(select objdesc from selectitem where id='"+subtypeid+"')||'-'||'"+DateHelper.getCurrentDate().substring(2,4)+"'||'"+seq+"'||'-'|| objno objno from orgunit where id='"+dept+"'";
		ls = ds.getValues(sql);
		if(ls.size()>0)
		{
			Map m =(Map)ls.get(0);
			out.println("yes,"+StringHelper.null2String(m.get("objno")));
		}
		else
			out.println("no");
	}
	else if(uptype.equals("income"))
	{
		String requestid= request.getParameter("requestid");
		String month = request.getParameter("month");
		if(requestid==null||requestid.length()<1)requestid="0";
		String sql = "";
		DataService ds= new DataService();
		List ls=null;
		sql = "select  requestid from uf_income_monreportmain where requestid<>'"+requestid+"' and yearmonth='"+month+"'";
		ls = ds.getValues(sql);
		if(ls.size()>0)
		{
			out.println("yes");
		}
		else
			out.println("no");
	}
	else if(uptype.equals("seq"))
	{
		String tablename = request.getParameter("tablename");
		String nocolumn = request.getParameter("nocolumn");
		String seq = request.getParameter("seq");
		int len = Integer.parseInt(StringHelper.null2String(request.getParameter("len"),"3"));
		String sql = "";
		DataService ds= new DataService();
		sql = "select "+seq+" from dual";
		seq=formulaSeq(ds.getValue(sql));
		String qz=seq.substring(0,seq.indexOf("{"));
		String hz=(seq.length()>(seq.indexOf("}")+1))?seq.substring(seq.indexOf("}")+1,seq.length()):"";
		
		sql = "select nvl(max(to_number(translate(replace(replace("+nocolumn+",'"+qz+"',''),'"+hz+"',''),'0123456789abcdefghigjmlnopqrstuvwxyz-ABCDEFGHIGJMLNOPQRSTUVWXYZ','0123456789')))+1,1) from "+tablename+" where "+nocolumn+" like '"+qz+"%' and "+nocolumn+" like '%"+hz+"'";
		seq = ds.getValue(sql);
		if(seq!=null&&seq.length()>0)
		{
			seq=add0(seq,len);
			out.println("yes,"+qz+seq+hz);
		}
		else
		{
			out.println("no");
		}
	}
	else if(uptype.equals("bigseq"))
	{
		String seq = request.getParameter("seq");
		String sql = "";
		DataService ds= new DataService();
		sql = "select "+seq+" from dual";
		seq=ds.getValue(sql);
		if(seq!=null&&seq.length()>0)
		{
			out.println("yes,"+seq);
		}
		else
		{
			out.println("no");
		}
	}
	if(uptype.equals("autoseq"))
	{
		String formula = request.getParameter("formula");
		formula = StringHelper.replaceString(formula,"|","#");
		int len = Integer.parseInt(StringHelper.null2String(request.getParameter("len"),"3"));
		String seq = getAutoNo(formula,len);
		if(seq!=null&&seq.length()>0)
		{
			out.println("yes,"+seq);
		}
		else
		{
			out.println("no");
		}
	}
%><%!
	private String formulaSeq(String formula)
	{
	   if(formula==null) return "";
       Date newdate = new Date();
       formula = formula.replaceAll("YYYY", new SimpleDateFormat("yyyy").format(newdate));
       formula = formula.replaceAll("MM", new SimpleDateFormat("MM").format(newdate));
       formula = formula.replaceAll("DD", new SimpleDateFormat("dd").format(newdate));
       formula = formula.replaceAll("YY", new SimpleDateFormat("yy").format(newdate));
       return formula;
	}
	private String add0(String nums,int len)
	{
		String str= nums;
		for(int i=len,tlen=str.length();i>tlen;i--)
		{
			str="0"+str;
		}
		return str;
	}
	private String getAutoNo(String formula,int len)
	{
	   formula=formulaSeq(formula);
	   String id=formula.substring(formula.indexOf('#')+1,formula.lastIndexOf('#'));
       String no="";
       no = NumberHelper.getSequenceNo(id, len);
       formula = formula.replaceAll("#"+id+"#",no);
       return formula;
	}

%>