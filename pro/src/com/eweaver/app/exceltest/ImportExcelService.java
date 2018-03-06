package com.eweaver.app.exceltest;

import com.eweaver.base.DataService;
import com.eweaver.base.util.StringHelper;


import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
public class ImportExcelService {
	public String insertDate(List<String>[] dataArray,String requestid)
	  {
	    String throwstr = "";

	    if (dataArray == null) {
	    	System.out.println("ִ未读取到excel的内容");
	      return throwstr = "ִ未读取到excel的内容";
	    }
	    System.out.println("ִ行数"+dataArray[0].size());
	    System.out.println("ִ列数"+dataArray.length);
	    int realSize = -1;
	    if (dataArray.length > 0) {
	      List list = dataArray[0];
	      for (int i = 0; i < list.size(); i++) {
	        String str = StringHelper.null2String((String)list.get(i));
	        if (!str.trim().equals("")) {
	          realSize = i;
	        }
	      }
	    }

	    int rows = dataArray[0].size();

	    DataService dataService = new DataService();
	    String delsql="delete uf_tr_xunjiasub where requestid='"+requestid+"'";
	    dataService.executeSql(delsql);
	    String sql="";
	    for (int i = 1; i < rows; i++)
	    {
	      String cabtype = StringHelper.null2String((String)dataArray[0].get(i));//柜型
	      String isdanger = StringHelper.null2String((String)dataArray[1].get(i));//危普区分
	      String dangelv = StringHelper.null2String((String)dataArray[2].get(i));//危化等级
	      String hxarea = StringHelper.null2String((String)dataArray[3].get(i));//航线区域
	      String hx = StringHelper.null2String((String)dataArray[4].get(i));//航线
	      String startport = StringHelper.null2String((String)dataArray[5].get(i));//启运港
	      String endport = StringHelper.null2String((String)dataArray[6].get(i));//目的港
	      String require = StringHelper.null2String((String)dataArray[7].get(i));//要求
	      String goods = StringHelper.null2String((String)dataArray[8].get(i));//产品
	      String cabnum = StringHelper.null2String((String)dataArray[9].get(i));//报价年月
	      //String comtype = StringHelper.null2String((String)dataArray[10].get(i));//厂区别
	      //String imexp = StringHelper.null2String((String)dataArray[11].get(i));//进出口类型
	      String gxty="";
	      if(cabtype.indexOf("GP")!=-1)
	      {
	    	  gxty="GP"+isdanger;
	      }
	      else if(cabtype.indexOf("TK")!=-1||cabtype.indexOf("TANK")!=-1)
	      {
	    	  gxty="TK";
	      }
	      else {
	    	  gxty=cabtype;
	      }
	      sql="insert into uf_tr_xunjiasub(id,requestid,sno,cabtype,isdanger,dangelv,hxarea,line,startport,endport,require,goods,cabnum,gxty)values(";
	      sql=sql+"(select sys_guid() from dual),'"+requestid+"',"+i+",'"+cabtype+"','"+isdanger+"','"+dangelv+"','"+hxarea+"','"+hx+"','"+startport+"','"+endport+"','"+require+"','"+goods+"','"+cabnum+"','"+gxty+"')";
	      dataService.executeSql(sql);

	    }
	    throwstr="success";
		return throwstr;
	  }
}
