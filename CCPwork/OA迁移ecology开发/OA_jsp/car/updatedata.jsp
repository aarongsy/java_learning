<%@page import="org.springframework.jdbc.core.JdbcTemplate"%>
<%@ page contentType="text/plain; charset=UTF-8"%>
<%
if(BaseContext.getRemoteUser()==null){
	response.encodeRedirectURL("/main/login.jsp");
}
String editmode = StringHelper.null2String(request.getParameter("editmode"));
BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
%>
<%@ include file="/base/initnoscript.jsp"%>
<%
/**
editemode=3   审核
editemode=4   撤销
**/
    response.setHeader("cache-control", "no-cache");
    response.setHeader("pragma", "no-cache");
    response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	
	String id = StringHelper.null2String(request.getParameter("requestid")).trim();
	String selectrunningno="select runningno,deliverdnum from uf_lo_dgcardetail where requestid='"+id+"'";
	String sql="select needtype from uf_lo_dgcar   where requestid='"+id+"' ";//单据类型
	String needtype=(String)baseJdbcDao.getJdbcTemplate().queryForObject(sql, String.class);
	String  tablename="uf_lo_delivery";  
	String filedname="yetnum";
  

    List list=baseJdbcDao.getJdbcTemplate().queryForList(selectrunningno );
   
    String updatesql="";
    for(int i=0;i<list.size();i++){
    	
    	   if(editmode.equals("3")){//回写需求数,并改为已审核
    		 	   updatesql="update uf_lo_delivery set yetnum=(select nvl(yetnum,0)+?  yetnum from uf_lo_delivery where requestid=?) where requestid=?";
    		    if(needtype.equals("402864d14931fb79014932928fae0027")){ //采购订单   
    		 	   tablename="uf_lo_purchase";   
    		 	   updatesql=" update uf_lo_purchase set openquantity=(select (openquantity-?) openquantity from uf_lo_purchase where requestid=?) where requestid=?";
    		    }  
    		    if(needtype.equals("402864d14931fb79014932928fae0028")){ //销售订单   
    		   		 tablename="uf_lo_salesorder";    
    		    	filedname="";
    		    	out.println("false");
    		    return ;
    		    }  
    		 if(needtype.equals("402864d14931fb79014932928fae0029")){  //非SAP   
    		   			 tablename="uf_lo_salesorder";      
    		   			out.println("false");
    		   			 return ;
    		     }    
    		 String updatedgcar="update uf_lo_dgcar set state='402864d14931fb790149328a92bd0016' where requestid='"+id+"'";
    	    	baseJdbcDao.getJdbcTemplate().execute(updatedgcar);
    }
    	   if(editmode.equals("4")){//撤销
    		   updatesql= "update uf_lo_delivery set yetnum=(select nvl(yetnum,0)-?  yetnum from uf_lo_delivery where requestid=?) where requestid=?";
   		    if(needtype.equals("402864d14931fb79014932928fae0027")){ //采购订单   
   		 	   tablename="uf_lo_purchase";   
   		 	   updatesql=" update uf_lo_purchase set openquantity=(select (openquantity+?) openquantity from uf_lo_purchase where requestid=?) where requestid=?";
   		    }  
   		    if(needtype.equals("402864d14931fb79014932928fae0028")){ //销售订单   
   		   		tablename="uf_lo_salesorder";    
   		    	filedname="";
   		    	out.println("false");
   		    return ;
   		    }  
   		 if(needtype.equals("402864d14931fb79014932928fae0029")){  //非SAP   
   		   			 tablename="uf_lo_salesorder";      
   		   			out.println("false");
   		   			 return ;
   		     }    
   		 
    	String updatedgcar="update uf_lo_dgcar set state='402864d14931fb790149328a92bd0015' where requestid='"+id+"'";
    	//System.out.println(updatedgcar);
    	baseJdbcDao.getJdbcTemplate().execute(updatedgcar);
    	   }
    	   
    	String runningno=  ((Map) list.get(i)).get("runningno") == null ? "" : ((Map)  list.get(i)).get("runningno").toString(); 
       	Float deliverdnum=  ((Map) list.get(i)).get("deliverdnum") == null ? 0 :Float.parseFloat( ((Map)  list.get(i)).get("deliverdnum").toString()); 
       	//System.out.println(deliverdnum+"  "+runningno);
       	//System.out.println(updatesql);
       	updatesql=updatesql.replaceFirst("[?]", deliverdnum+"");
       	updatesql=updatesql.replaceFirst("[?]","'"+runningno+"'");
       	updatesql=updatesql.replaceFirst("[?]", "'"+runningno+"'");
       	//System.out.println(updatesql);
       	baseJdbcDao.getJdbcTemplate().execute(updatesql);
    }
    out.println("true");
	return ;
%>