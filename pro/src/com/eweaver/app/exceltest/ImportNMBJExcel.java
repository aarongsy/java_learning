package com.eweaver.app.exceltest;

import java.util.List;

import com.eweaver.base.DataService;
import com.eweaver.base.util.StringHelper;

public class ImportNMBJExcel {
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
	    String sql="";
	    for (int i = 1; i < rows; i++)
	    {
	      String sno = StringHelper.null2String((String)dataArray[0].get(i));
	     // String sl = StringHelper.null2String((String)dataArray[20].get(i));
	     // String timee = StringHelper.null2String((String)dataArray[21].get(i));
	      String price = StringHelper.null2String((String)dataArray[11].get(i));
	      String baojia = StringHelper.null2String((String)dataArray[12].get(i));
	      String requir = StringHelper.null2String((String)dataArray[13].get(i));
	      //String gxfee = StringHelper.null2String((String)dataArray[12].get(i));
	      String remark = StringHelper.null2String((String)dataArray[15].get(i));

	      if(price.equals(""))
	    	  price="NULL";
	      if(baojia.equals(""))
	    	  baojia="NULL";

	      //sql="update uf_lo_baojiachild  set sl="+sl+",timee='"+timee+"',price="+price+",baojia="+baojia+",curr='"+curr+"',boat='"+boat+"',remark='"+remark+"' where requestid='"+requestid+"' and sno="+sno;
	      sql="update uf_lo_baojiachild  set price="+price+",baojia="+baojia+",remark='"+remark+"',requir='"+requir+"' where requestid='"+requestid+"' and sno="+sno;
	      dataService.executeSql(sql);

	    }
	    throwstr="success";
		return throwstr;
	  }
}
