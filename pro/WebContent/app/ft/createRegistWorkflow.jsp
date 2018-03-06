<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.URLEncoder"%>
<%!
	public void connection(){
		try { 
			Class.forName("oracle.jdbc.driver.OracleDriver"); 
			String url = "jdbc:oracle:thin:@localhost:1521:orcl"; 
			Connection conn = DriverManager.getConnection(url, "xsht_dj", "xsht_dj");
			Statement stmt = conn.createStatement(); 
			ResultSet rs = stmt.executeQuery("select * from xsht_dj where A1 not like 'D%' and A4<>'电力通信'"); 
			int i=0;
			BaseJdbcDao baseJdbcDao=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
			while (rs.next()) {
				Object[] realvalues=new Object[50];
				realvalues[0]=rs.getString("A1");
				realvalues[1]=rs.getString("A2");
				realvalues[2]=rs.getString("A3");
				realvalues[3]=rs.getString("A4");
				realvalues[4]=rs.getString("A5");
				realvalues[5]=rs.getDate("A6");
				realvalues[6]=rs.getString("A7");
				realvalues[7]=rs.getString("A8");
				realvalues[8]=rs.getString("A9");
				realvalues[9]=rs.getString("A10");
				realvalues[10]=rs.getDate("A11");
				realvalues[11]=rs.getDate("A12");
				realvalues[12]=rs.getString("A13");
				realvalues[13]=rs.getDate("A14");
				realvalues[14]=rs.getString("A15");
				realvalues[15]=rs.getString("A16");
				realvalues[16]=rs.getString("A17");
				realvalues[17]=rs.getString("A18");
				realvalues[18]=rs.getString("A19");
				realvalues[19]=rs.getString("A20");
				realvalues[20]=rs.getString("BZ");
				realvalues[21]=rs.getString("RECNAME");
				realvalues[22]=rs.getString("UPDATENAME");
				realvalues[23]=rs.getString("A21");
				realvalues[24]=rs.getString("A22");
				realvalues[25]=rs.getString("A23");
				realvalues[26]=rs.getString("A24");
				realvalues[27]=rs.getString("A25");
				realvalues[28]=rs.getString("A26");
				realvalues[29]=rs.getDate("A27");
				realvalues[30]=rs.getString("A28");
				realvalues[31]=rs.getDate("A29");
				realvalues[32]=rs.getString("A30");
				realvalues[33]=rs.getDate("A31");
				realvalues[34]=rs.getString("A32");
				realvalues[35]=rs.getDate("A33");
				realvalues[36]=rs.getString("A34");
				realvalues[37]=rs.getDate("A35");
				realvalues[38]=rs.getString("A36");
				realvalues[39]=rs.getDate("A37");
				realvalues[40]=rs.getString("A38");
				realvalues[41]=rs.getDate("A39");
				realvalues[42]=rs.getString("A40");
				realvalues[43]=rs.getDate("A41");
				realvalues[44]=rs.getString("A42");
				realvalues[45]=rs.getString("A43");
				realvalues[46]=rs.getString("CS");
				realvalues[47]=rs.getString("AXQ1");
				realvalues[48]=rs.getString("AXQ2");
				realvalues[49]=rs.getString("AXQ3");
				String sql="insert into xsht_dj(A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,A15,A16,A17,A18,A19,A20,"
					+"BZ,RECNAME,UPDATENAME,A21,A22,A23,A24,A25,A26,A27,A28,A29,A30,A31,A32,A33,A34,A35,A36,A37,A38,A39,A40,"
					+"A41,A42,A43,CS,AXQ1,AXQ2,AXQ3) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,"
					+"?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
				baseJdbcDao.update(sql,realvalues);
				i++;
			} 
			System.out.println(i);
			conn.close();
		} catch (SQLException e) { 
			e.printStackTrace(); 
		} catch (ClassNotFoundException e) { 
			e.printStackTrace(); 
		} 
	}
%>
<%
	connection();
%>