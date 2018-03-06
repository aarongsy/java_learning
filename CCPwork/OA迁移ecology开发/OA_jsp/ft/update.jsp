<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser"%>
<%@ page import="com.eweaver.base.*"%>
<%@ page import="com.eweaver.base.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="com.eweaver.base.msg.*"%>
<%@ page import="org.springframework.jdbc.core.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%LabelService labelService = (LabelService)BaseContext.getBean("labelService");%>
<%
	//***********************************************************************************************************************************//
			Connection conn = null;
			ResultSet rs = null;
			PreparedStatement pstmt = null;
			//连接档案服务器信息
			String DRIVER = "oracle.jdbc.driver.OracleDriver";
			String URL = "jdbc:oracle:thin:@172.17.32.181:1521:orcl";
			String USERNAME = "thams_temp";
			String USERPASS = "ams2000";
			Class.forName(DRIVER);  //加载数据库驱动
			conn = DriverManager.getConnection(URL,USERNAME,USERPASS);
			if(conn!=null){
				out.println(labelService.getLabelNameByKeyId("402883de35273f910135273f955b0055"));//档案数据库连接已获取
			}
					
	//****************************************************************************************************************//
	//---------------------------------------
	String userId = BaseContext.getRemoteUser().getId();
	DataService dataService = new DataService();
	BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext
			.getBean("baseJdbcDao");
	String getIds = "select mainbodyattach from uf_doc_ratifymain ";
	List<Map> listIds = baseJdbc.executeSqlForList(getIds);
	String docid = "";
	int m=0;
	int n=0;
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
	Date date = new Date();
	String currenttime = sdf.format(date);
	if (listIds.size() > 0) {
		for (int i = 0; i < listIds.size(); i++) {
			Map map1 = (Map) listIds.get(i);
			docid = StringHelper
					.null2String(map1.get("mainbodyattach"));

			String sql1 = "select humres.objname as ZRZ,attach.id as did, uf.docno as JSH,attach.filedir as EFILENAME,"
					+ "uf.remark as BZ,"
					+ "nvl(uf.a3+uf.a4,0) as pages ,case when docbase.attachnum=0 then 0 else 1  end as ISCOVEREFILE, "
					+ "uf.docname as title,attach.objname as docstyle "
					+ "from uf_doc_ratifymain uf,docbase ,docattach  ,attach  ,humres   "
					+ "where uf.mainbodyattach=docbase.id  "
					+ "and docbase.id=docattach.objid  "
					+ "and docbase.creator=humres.id "
					+ "and attach.id=docattach.attachid "
					+ " and docbase.id='" + docid + "'";

			List<Map> list1 = (List<Map>)baseJdbc.executeSqlForList(sql1);
			if (list1.size() > 0) {
				//out.println(list1.size() );
				for(Map map:list1){
				//创建时间
				String CREATETIME = currenttime;
				//附件id--DID
				String id1 = StringHelper.null2String(map.get("did"));
				//文档编号
				String docno = StringHelper.null2String(map.get("JSH"));
				//正文附件名
				String title = StringHelper.null2String(map
						.get("title"));
				//备注
				String remark = StringHelper.null2String(map.get("BZ"));
				//页数
				int pages = Integer.parseInt(map.get("pages")
						.toString());
				//责任人
				String ZRZ = StringHelper.null2String(map.get("ZRZ"));
				//是否含有附件
				int ISCOVEREFILE = Integer.parseInt(map.get(
						"ISCOVEREFILE").toString());
				//扩展名
				String extall = StringHelper.null2String(map
						.get("docstyle"));
				String ext = "";
				String[] extArray = extall.split("\\.");
				if (extArray.length > 0) {
					ext = extArray[extArray.length - 1];
				}
				//服务器配置名
				String pzm = "ftpserver";
				String efilenameAll = StringHelper.null2String(map
						.get("efilename"));
				//电子文件路径
				String[] pathnameArray = efilenameAll.split("\\\\");
				String pathname1="";
				String pathname2="";
				String filenamemd5="";
				if(pathnameArray.length>2){
					pathname1 = pathnameArray[pathnameArray.length-3];
					pathname2 = pathnameArray[pathnameArray.length-2];
					filenamemd5= pathnameArray[pathnameArray.length-1];
				}
				String pathname=pathname1+"\\"+pathname2;
				//电子文件名称（加密后的名称.扩展名）
				String efilename =filenamemd5;
				
				String sql3="";		
				pstmt = conn.prepareStatement("select did from D_FILE9 where JSH='"+docno+"'");
				rs = pstmt.executeQuery();
				if(rs.next()){
					rs.close();
					pstmt.close();
			    }else{
					rs.close();
					 pstmt.close();
			   		m++;
			   		out.println("D_FILE9"+labelService.getLabelNameByKeyId("402883de35273f910135273f955b0056")+m+labelService.getLabelNameByKeyId("402883de35273f910135273f955b0057"));//已插入//条记录！
			   		out.println("<br>");
					sql3="insert into D_FILE9(DID,JSH,TITLE,Createtime,YS,ZRZ,ISCOVEREFILE,BZ,isConverted)"
					+" values('"+id1+"','"+docno+"','"+StringHelper.filterSqlChar(title)+"','"+CREATETIME+"',"+pages+",'"+ZRZ
					+"',"+ISCOVEREFILE+",'"+StringHelper.filterSqlChar(remark)+"',0)";
	             	pstmt = conn.prepareStatement(sql3);
	             	pstmt.executeUpdate();
					pstmt.close();
				}
			
	            pstmt = conn.prepareStatement("select did from E_FILE9 where DID='"+id1+"'");
	            rs = pstmt.executeQuery();
				
	            if(rs.next()){
					rs.close();
					pstmt.close();
			    } else{
					rs.close();
					 pstmt.close();
			    	n++;
			    	out.println("E_FILE9"+labelService.getLabelNameByKeyId("402883de35273f910135273f955b0056")+n+labelService.getLabelNameByKeyId("402883de35273f910135273f955b0057"));//已插入//条记录！
			    	out.println("<br>");
				    sql3="insert into E_FILE9(DID,PID,JSH,EFILENAME,TITLE,EXT,PZM,PATHNAME,isConverted)"
					+" values('"+id1+"','"+id1+"','"+docno+"','"+StringHelper.filterSqlChar(efilename)+"','"+StringHelper.filterSqlChar(title)+"','"+ext
					+"','"+pzm+"','"+StringHelper.filterSqlChar(pathname)+"',0)";
	               pstmt = conn.prepareStatement(sql3);
	               pstmt.executeUpdate();
				   pstmt.close();
				}
				}
				
			}
		}
	}
	out.print(labelService.getLabelNameByKeyId("402883de35273f910135273f955b0058")+m+labelService.getLabelNameByKeyId("402883de35273f910135273f955b0059"));//共向E_FILE9表中插入---//条数据！
	out.print("<br>");
	out.print(labelService.getLabelNameByKeyId("402883de35273f910135273f955b0058")+n+labelService.getLabelNameByKeyId("402883de35273f910135273f955b0059"));//共向E_FILE9表中插入---//条数据！
	out.print("<br>");
	out.println(labelService.getLabelNameByKeyId("402883de35273f910135273f955b005a"));//同步数据成功！
%>

