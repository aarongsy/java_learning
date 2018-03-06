package com.eweaver.app.exceltest;

import java.util.List;

import com.eweaver.base.DataService;
import com.eweaver.base.util.StringHelper;

public class ImportBJExcel {
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
	      String qygang = StringHelper.null2String((String)dataArray[6].get(i));
	      String equair = StringHelper.null2String((String)dataArray[8].get(i));
	      String hyfee = StringHelper.null2String((String)dataArray[10].get(i));
	      String gxfee = StringHelper.null2String((String)dataArray[11].get(i));
	      String baf = StringHelper.null2String((String)dataArray[12].get(i));
	      String yas = StringHelper.null2String((String)dataArray[13].get(i));
	      String gbf = StringHelper.null2String((String)dataArray[14].get(i));
	      String caf = StringHelper.null2String((String)dataArray[15].get(i));
	      String ebs = StringHelper.null2String((String)dataArray[16].get(i));
	      String cic = StringHelper.null2String((String)dataArray[17].get(i));
	      String ens = StringHelper.null2String((String)dataArray[18].get(i));
	      String ams = StringHelper.null2String((String)dataArray[19].get(i));
	      String rcs = StringHelper.null2String((String)dataArray[20].get(i));
	      String pss = StringHelper.null2String((String)dataArray[21].get(i));

	      //String shipcom = StringHelper.null2String((String)dataArray[22].get(i));
	      //String shipdate = StringHelper.null2String((String)dataArray[23].get(i));
	      String remark = StringHelper.null2String((String)dataArray[22].get(i));
	      if(hyfee.equals(""))
	    	  hyfee="null";
	      if(gxfee.equals(""))
	    	  gxfee="null";
	      if(baf.equals(""))
	    	  baf="null";
	      if(yas.equals(""))
	    	  yas="null";
	      if(gbf.equals(""))
	    	  gbf="null";
	      if(caf.equals(""))
	    	  caf="null";
	      if(ebs.equals(""))
	    	  ebs="null";
	      if(cic.equals(""))
	    	  cic="null";
	      if(ens.equals(""))
	    	  ens="null";
	      if(ams.equals(""))
	    	  ams="null";
	      if(rcs.equals(""))
	    	  rcs="null";
	      if(pss.equals(""))
	    	  pss="null";

	      sql="update uf_tr_baojiachild set qygang='" + qygang + "',hyfee="+hyfee+",gxfee="+gxfee+",baf="+baf+",yas="+yas
	      +",gbf="+gbf+",caf="+caf+",ebs="+ebs+",cic="+cic+",ens="+ens+",ams="+
	      ams+",rcs="+rcs+",pss="+pss+",remark='"+remark+"' where requestid='"+requestid+"' and sno="+sno;
	      dataService.executeSql(sql);

	    }
	    throwstr="success";
		return throwstr;
	  }
}
