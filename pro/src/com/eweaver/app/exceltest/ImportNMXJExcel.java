package com.eweaver.app.exceltest;

import java.util.List;

import com.eweaver.base.DataService;
import com.eweaver.base.util.StringHelper;

public class ImportNMXJExcel {
	public String insertDate(List<String>[] dataArray,String requestid)
	  {
	    String throwstr = "";

	    if (dataArray == null) {
	    	System.out.println("ִ未读取到excel的内容");
	      return throwstr = "ִ未读取到excel的内容";
	    }
	    System.out.println("ִ行数"+dataArray[0].size());
	    System.out.println("ִ列数"+dataArray.length);
	    int rows = dataArray[0].size();

	    DataService dataService = new DataService();
	    String delsql="delete uf_lo_xunjiasub where requestid='"+requestid+"'";
	    dataService.executeSql(delsql);
	    String sql="";
	    for (int i = 1; i < rows; i++)
	    {
	    	 /* String sno = StringHelper.null2String((String)dataArray[0].get(i));
	    	  String lineno = StringHelper.null2String((String)dataArray[1].get(i));
		      String linename = StringHelper.null2String((String)dataArray[2].get(i));
		      String linetype = StringHelper.null2String((String)dataArray[3].get(i));
		      String trantype = StringHelper.null2String((String)dataArray[4].get(i));
		      String hxarea = StringHelper.null2String((String)dataArray[5].get(i));
		      String qygang = StringHelper.null2String((String)dataArray[6].get(i));
		      String qycity = StringHelper.null2String((String)dataArray[7].get(i));
		      String mdgang = StringHelper.null2String((String)dataArray[8].get(i));
		      String mdcity = StringHelper.null2String((String)dataArray[9].get(i));
		      String tranvech = StringHelper.null2String((String)dataArray[10].get(i));
		      String gx = StringHelper.null2String((String)dataArray[11].get(i));
		      String danger = StringHelper.null2String((String)dataArray[12].get(i));
		      String dangerlv = StringHelper.null2String((String)dataArray[13].get(i));
		      String pricetype = StringHelper.null2String((String)dataArray[14].get(i));
		      String stone = StringHelper.null2String((String)dataArray[15].get(i));
		      String etone = StringHelper.null2String((String)dataArray[16].get(i));
		      String require = StringHelper.null2String((String)dataArray[17].get(i));
		      String pro = StringHelper.null2String((String)dataArray[18].get(i));
		      String gl = StringHelper.null2String((String)dataArray[19].get(i));*/
		      
		      String sno = StringHelper.null2String((String)dataArray[0].get(i));
		      String lineno = StringHelper.null2String((String)dataArray[1].get(i));
		      String linename = StringHelper.null2String((String)dataArray[2].get(i));
		      String trantype = StringHelper.null2String((String)dataArray[3].get(i));
		      String qycity = StringHelper.null2String((String)dataArray[4].get(i));
		      String qygang = StringHelper.null2String((String)dataArray[5].get(i));
		      String mdgang = StringHelper.null2String((String)dataArray[6].get(i));
		      String mdcity = StringHelper.null2String((String)dataArray[7].get(i));
		      String gx = StringHelper.null2String((String)dataArray[8].get(i));
		      String danger = StringHelper.null2String((String)dataArray[9].get(i));
		      String dangerlv = StringHelper.null2String((String)dataArray[10].get(i));
		      String require = StringHelper.null2String((String)dataArray[11].get(i));
		      String gl = StringHelper.null2String((String)dataArray[12].get(i));

		      //sql="insert into uf_lo_xunjiasub(id,requestid,sno,lineno,linename,linetype,trantype,hxarea,qygang,qycity,mdgang,mdcity,tranvech,gx,danger,dangerlv,pricetype,stone,etone,require,pro,gl)values(";
		      //sql=sql+"(select sys_guid() from dual),'"+requestid+"',"+sno+",'"+lineno+"','"+linename+"','"+linetype+"','"+trantype+"','"+hxarea+"','"+qygang+"','"+qycity+"','"+mdgang+"','"+mdcity+"','"
		      //+tranvech+"','"+gx+"','"+danger+"','"+dangerlv+"','"+pricetype+"','"+stone+"','"+etone+"','"+require+"','"+pro+"',"+gl+")";
		      String gxty="";
		      if(gx.indexOf("GP")!=-1)
		      {
		    	  gxty="GP"+danger;
		      }
		      else if(gx.indexOf("TK")!=-1||gx.indexOf("TANK")!=-1)
		      {
		    	  gxty="TK";
		      }
		      else {
		    	  gxty=gx;
			}
		      
		      
		      sql="insert into uf_lo_xunjiasub(id,requestid,sno,lineno,linename,trantype,qycity,qygang,mdgang,mdcity,gx,danger,dangerlv,require,gl,gxty)values(";
		      sql=sql+"(select sys_guid() from dual),'"+requestid+"',"+sno+",'"+lineno+"','"+linename+"','"+trantype+"','"+qycity+"','"+qygang+"','"+mdgang+"','"+mdcity+"','"+gx+"','"+danger+"','"+dangerlv+"','"+require+"',"+gl+",'"+gxty+"')";
		      dataService.executeSql(sql);

	    }
	    throwstr="success";
		return throwstr;
	  }
}
