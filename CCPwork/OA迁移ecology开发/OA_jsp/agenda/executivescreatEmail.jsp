
<%@page import="com.eweaver.humres.base.service.HumresService"%>
<%@page import="com.eweaver.base.DataService"%>
<%@page import="java.util.Date"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@page import="com.eweaver.base.util.DateHelper"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page contentType="text/html; charset=UTF-8"%>

<head>
<!--<link href="/htfapp/web/css/common.css" rel="stylesheet" type="text/css" />-->
<!--<link href="/htfapp/web/css/oa.css" rel="stylesheet" type="text/css" />-->
<script src="/app/js/jquery.js" type="text/javascript" charset="utf-8"></script>
<!--<script src="/htfapp/web/js/jquery.easing.1.3.js" type="text/javascript" charset="utf-8"></script>-->
<link rel="stylesheet" href="/app/schedule/css/schedule.css" type="text/css"></link>
<!--<link rel="stylesheet" href="../culture/css/culture_association.css" type="text/css"></link>-->
<script type="text/javascript" src="/datapicker/WdatePicker.js"></script>

<script type="text/javascript" src="/app/schedule/js/schedule.js"></script>
<script type="text/javascript" src="/js/orgsubjectbudget.js"></script>
<style type="text/css">
	table td {
	font-size: 12px;
	font: 12px/1.2 '宋体', Verdana, Tahoma, Arial;
	font-family: simsun,Microsoft YaHei,Verdana,Tahoma,sans-serif;
}
</style>
</head>

<body>
            
           
<%
			String date = StringHelper.trimToNull(request.getParameter("date"));
            HumresService humresService =(HumresService)BaseContext.getBean("humresService");
			DataService dataService = new DataService();      
            Date currentDate = null;
            if (StringHelper.isEmpty(date)){
            	currentDate = new Date();
            }else{
            	currentDate = DateHelper.stringtoDate(date);
            }
            int dayOfWeek = DateHelper.getDayOfWeek(currentDate);  
                    
            String weekfirst = "";           
            String weeklast = "";
            if (dayOfWeek==1){
            
            	weekfirst = DateHelper.getShortDate(DateHelper.getDay(currentDate,(dayOfWeek-7)));
            	weeklast = DateHelper.getShortDate(DateHelper.getDay(currentDate,0));
            }else{
            	weekfirst = DateHelper.getShortDate(DateHelper.getDay(currentDate,2-dayOfWeek));
            	weeklast = DateHelper.getShortDate(DateHelper.getDay(currentDate,8-dayOfWeek));
            }
            
           
            List humreslist = new ArrayList();
            String sql = "select s.requestid,h.objname,s.richengren from uf_schedule s,humres h where h.id=s.richengren and "+
            "richenshijian <='"+weeklast+"' and richenshijian>='"+weekfirst+"' and s.isdelete=0 and richengleixing='4028813130b0a8340130b1252b5f0011' order by h.objno,h.dsporder asc,h.seclevel,h.id desc";
            humreslist = dataService.getValues(sql);
           String startdate = weekfirst.replace("-",".");
           String enddate = weeklast.replace("-",".");
            
           String getdates = DateHelper.getCurrentDate();
           if(!StringHelper.isEmpty(date)){
        	   getdates = date;
           }
%>
 <div align="center">
 	    <table  border="1px" style="border: thin;width: 97%;border-collapse: collapse;border-color: #b7b7b7;" bordercolor="#b7b7b7" cellpadding="0" cellspacing="0">
 	       <colgroup>
 	       <col width="12%"/>
 	       <col width="15%"/>
 	       <col width="15%"/>
 	       <col width="15%"/>
 	       <col width="15%"/>
 	       <col width="15%"/>
 	       <col width="13%"/>
 	       </colgroup>
 	    	<tbody>
 	    		<tr  style="height: 30px;">
 	    		<td colspan="7" class="manger" align="center" style="font-weight: bold;font-size: 13px;">公司高管层行程安排表(<%=startdate %>-<%=enddate %>)</td>
 	    		</tr>
 	    		<tr style="height: 30px;">                       
                     <td style="font-weight: bold;text-align: center;font-size: 13px;">公司领导</td>
                     <td style="font-weight: bold;text-align: center; font-size: 13px;">星期一 </br><%=weekfirst %></td>
                     <td style="font-weight: bold;text-align: center; font-size: 13px;">星期二</br><%=DateHelper.dayMove(weekfirst,1) %> </td>
                     <td style="font-weight: bold;text-align: center; font-size: 13px;">星期三</br><%=DateHelper.dayMove(weekfirst,2) %></td>
                     <td style="font-weight: bold;text-align: center; font-size: 13px;">星期四</br><%=DateHelper.dayMove(weekfirst,3) %> </td>
                     <td style="font-weight: bold;text-align: center; font-size: 13px;">星期五</br><%=DateHelper.dayMove(weekfirst,4) %> </td>
                     <td style="font-weight: bold;text-align: center; font-size: 13px;">备注</td>
 	    		</tr>
 	    		 <%
                          List tempList = new ArrayList();
                          
                          Map map1 = new HashMap();
                          for (int i = 0; i < humreslist.size(); i++) {
                        	  Map map = (Map)humreslist.get(i);
                        	  String objname = StringHelper.null2String(map.get("objname"));//
                        	  String richengren = StringHelper.null2String(map.get("richengren"));//
                        	  String requestid = StringHelper.null2String(map.get("requestid"));//
                        	  tempList = dataService.getValues("select * from uf_scheduledetail where requestid ='"+requestid+"'");
                        	  String xingqi = "";
                        	  String neirong = "";
                        	  String didian="";
                        	  String beizhu = "";
                        	  Map tempMap = new HashMap();
                        	  
                        	  for (int j=0;j<tempList.size();j++){
                        	  	 map1 = (Map)tempList.get(j);
                        	  	 xingqi = (String)map1.get("xingqi");
                        	  	 didian = (String)map1.get("didian");
                        	  	 neirong = didian+" "+(String)map1.get("neirong");
                        	  	 tempMap.put(xingqi,neirong);
                        	  	 
                        	  	 if ("星期六".equals(xingqi) || "星期日".equals(xingqi)){
                        	  	 	beizhu = beizhu + " " +didian+" "+(String)map1.get("neirong");
                        	  	 	if((!"".equals(didian)&& !StringHelper.isEmpty(didian)) || (!"".equals((String)map1.get("neirong"))&& !StringHelper.isEmpty((String)map1.get("neirong")))){
                        	  	 		beizhu+="("+xingqi+")";
                        	  	 	}
                        	  	 }
                        	  }
                        %>
 	    		 <tr  style="height: 30px;">
                  	  <td width="12%" align="left" style="padding-left: 4px;"><%=objname %></td>
                  	  <%
                  	  		
                  	  		
                  	  		List<String> listwookday=new ArrayList<String>();
                  	  		listwookday.add(StringHelper.null2String(tempMap.get("星期一")).replace("null",""));
                  	  		listwookday.add(StringHelper.null2String(tempMap.get("星期二")).replace("null",""));
                  	  		listwookday.add(StringHelper.null2String(tempMap.get("星期三")).replace("null",""));
                  	  		listwookday.add(StringHelper.null2String(tempMap.get("星期四")).replace("null",""));
                  	  		listwookday.add(StringHelper.null2String(tempMap.get("星期五")).replace("null",""));
                  	  		List<String> listcol=this.isxitong(listwookday);
                  	  		//System.out.println("---"+listcol.size());
                  	  		
                  	  		if(listcol !=null && listcol.size()>0){
                  	  			for( int ci=0;ci<listcol.size();ci++){
                  	  				String[] colzhi=listcol.get(ci).trim().split(",");
                  	  				String xqcont="";
                  	  				if(colzhi!=null &&  colzhi.length>1){
                  	  					xqcont=colzhi[1];
                  	  				}
                  	  				int col=Integer.valueOf(colzhi[0].trim());
                  	  			
                  	  	%>
                  	  		<td width="<%=col*15 %>%" align="left" colspan="<%=col %>" style="padding-left: 4px;"><%=StringHelper.null2String(xqcont) %></td>
                  	  	<%		
                  	  				
                  	  			}
                  	  		}
                  	   %>        
                  	                             
                      <td width="13%" align="left" style="padding-left: 4px;"><%=StringHelper.null2String(beizhu).replace("null","") %></td>
                </tr>
                <%} %>
 	    	</tbody>
 	    </table>
 	 </div>
 	 <%!
 	 public static List<String> isxitong(List<String> list){
		int j=1;
		List<String> listtemp=new ArrayList<String>();
		boolean bool=false;
		int k=0;
		for(int i=0;i<list.size();i++){
			if(k==list.size()){
				break;
			}
			for(k=(i+1);k<list.size();k++){
				
				//System.out.println("前："+i+"  值:"+list.get(i)+"    后："+k+"  值:"+list.get(k));
				
				if(StringHelper.trim(list.get(i)).equals(StringHelper.trim(list.get(k)))){
					if(i==0){
						j=1;
						i=1;
					}
					j++;
				}else{
					i=(k-1);
					break;
				}
			}
			String tempzhi=j+","+list.get(i);
			listtemp.add(tempzhi);
			j=1;
		}
		return listtemp;
	}
 	 		
 	  %>
</body>
</html>