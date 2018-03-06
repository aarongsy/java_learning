<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.webservice.MpluginServiceImpl" %>
<%@ page import="com.eweaver.mobile.plugin.mode.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>


<%
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String action=StringHelper.null2String(request.getParameter("action"));
	String caldate=StringHelper.null2String(request.getParameter("caldate"));	
	String liquid=StringHelper.null2String(request.getParameter("liquid"));
	String beparm=StringHelper.null2String(request.getParameter("beparm"));
	//String isfirst=StringHelper.null2String(request.getParameter("isfirst"));	
	String area=StringHelper.null2String(request.getParameter("area"));	
	
	String d12=StringHelper.null2String(request.getParameter("d12"));
	String d13=StringHelper.null2String(request.getParameter("d13"));
	String did=StringHelper.null2String(request.getParameter("did"));
	

	String datform = "uf_yz_liqusepure"; 
	String qcform = "uf_yz_liqbeginread"; //ÆÚ³õ±í
	String readform = "uf_yz_liqreading"; //uf_yz_liqreadingsub
	System.out.println("puredailyusecal  action="+action+" caldate="+caldate+" liquid="+liquid+" area="+area + " beparm="+beparm + 
			"d12="+d12+" d13="+d13+" did="+did);


	float C3=0;
	float C4=0;
	float C5=0;
	float C6=0;
	float C7=0;
	float C8=0;
	float C9=0;
	float C10=0;
	float C11=0;
	float C12=0;
	float C13=0;
	float C14=0;
	float C15=0;
	float C16=0;

	float C18=0;
	float C19=0;

	float D3=0;
	float D4=0;
	float D5=0;
	float D6=0;
	float D7=0;
	float D8=0;
	float D9=0;
	float D10=0;
	float D11=0;
	float D12=0;
	float D13=0;
	float D14=0;
	float D15=0;
	float D16=0;

	float D18=0;
	float D19=0;	
	
	float AC24 = 0;
	
	//output
	float AD32 =0;
	float AD3 =0;
	float AD4 =0;	
	float AD5 =0;
	float AD6 =0;	
	
	float AD8 = 0;
	float AD9 = 0;
	float AD10 =0;
	float AD11 =0;	
	float AD12 =0;
	float AD13 =0;
	float AD14 =0;
	float AD15 =0;
	float AD16 =0;
	float AD17 =0;
	float AD18 =0;
	float AD19 =0;
	float AD20 =0;	
	float AD21 =0;	
	float AD22 =0;
	float AD23 =0;
	float AD24 =0;	
	float AD25 =0;
	float AD26 =0;				
	float AD27 =0;
	float AD28 =0;	
	float AD29 =0;
	float AD30 =0;
	float AD31 =0;
	
	JSONObject jo = new JSONObject();
	
	if(action.equals("getvalue")  || action.equals("calvalue")  ){
	
		
		String getvalsql="";
		String err="";
		

        /*
		if(isfirst.equals("1")){
			getvalsql ="select BQDS.liqitemid itemid,BQDS.liqitemname itemname,BQDS.readdate caldate,BQDS.readval val,SQDR.yearmon lastdate,SQDR.readval lastval from ( select a.stateflag sflag,a.reading readval,a.readdate readdate,b.liqitem liqitemname,a.liqitem liqitemid from uf_yz_liqreading a,uf_yz_liquiditem b where a.liqitem=b.requestid and a.liquid ='"+liquid+"' and to_date(a.readdate,'yyyy-mm-dd')=(to_date('"+caldate+"','yyyy-mm-dd') ) and a.stateflag='40285a9049d58e9e0149ea20d3cf6c79' ) BQDS left join ( select a.stateflag sflag,a.beginread readval,a.yearmon yearmon,a.liqitem liqitemid from uf_yz_liqbeginread a  ) SQDR on BQDS.liqitemid=SQDR.liqitemid and to_char(to_date(BQDS.readdate,'yyyy-mm-dd'),'yyyy-mm')=SQDR.yearmon  and BQDS.sflag=SQDR.sflag ";
		}else if(isfirst.equals("0")){
			getvalsql ="select BQDS.liqitemid itemid,BQDS.liqitemname itemname,BQDS.readdate caldate,BQDS.readval val,SQDR.readdate lastdate,SQDR.readval lastval from ( select a.stateflag sflag,a.reading readval,a.readdate readdate,b.liqitem liqitemname,a.liqitem liqitemid from uf_yz_liqreading a,uf_yz_liquiditem b where a.liqitem=b.requestid and a.liquid ='"+liquid+"' and to_date(a.readdate,'yyyy-mm-dd')=(to_date('"+caldate+"','yyyy-mm-dd') ) and a.stateflag='40285a9049d58e9e0149ea20d3cf6c79' ) BQDS left join ( select a.stateflag sflag,a.reading readval,a.readdate readdate,a.liqitem liqitemid from uf_yz_liqreading a  ) SQDR on BQDS.liqitemid=SQDR.liqitemid and (to_date(BQDS.readdate,'yyyy-mm-dd')=to_date(SQDR.readdate,'yyyy-mm-dd')+1 ) and BQDS.sflag=SQDR.sflag ";	
		}
        */		
		getvalsql ="select BQDS.liqitemid itemid,BQDS.liqitemname itemname,BQDS.readdate caldate,BQDS.readval val,SQDR.readdate lastdate,SQDR.readval lastval from ( select a.comtype area,a.stateflag sflag,b.reading readval,a.readdate readdate, b.liqitem liqitemname,b.liqitemid liqitemid from uf_yz_liqreading a,uf_yz_liqreadingsub b where a.requestid=b.requestid and a.liquid ='"+liquid+"' and to_date(a.readdate,'yyyy-mm-dd')=(to_date('"+caldate+"','yyyy-mm-dd') ) and a.stateflag='40285a9049d58e9e0149ea20d3cf6c79' and a.comtype='"+area+"' ) BQDS left join ( select a.comtype area,a.stateflag sflag,b.reading readval,a.readdate readdate,b.liqitemid liqitemid from uf_yz_liqreading a,uf_yz_liqreadingsub b where a.requestid=b.requestid ) SQDR on BQDS.liqitemid=SQDR.liqitemid and  (to_date(BQDS.readdate,'yyyy-mm-dd')=to_date(SQDR.readdate,'yyyy-mm-dd')+1 ) and BQDS.sflag=SQDR.sflag and BQDS.area=SQDR.area order by itemid asc";
		List list = baseJdbc.executeSqlForList(getvalsql);		
		if(list.size()==0){			
			err = "1";			
		}else if(list.size()<16){
			err = "2";			
		}else if(list.size()==16){
			for(int i=0;i<list.size();i++){
				Map map = (Map)list.get(i);
				String itemname = StringHelper.null2String(map.get("itemname"));
				String itemid = StringHelper.null2String(map.get("itemid"));				
				String val = StringHelper.null2String(map.get("val"));				
				String lastdate = StringHelper.null2String(map.get("lastdate"));
				String lastval = StringHelper.null2String(map.get("lastval"));
				//System.out.println("itemid:"+itemid+" " +itemname + " "+caldate+"reading:" +val+" "+lastdate+"reading:" +lastval);
				if(val.equals("") || val.equals("null") || val.equals(null) || lastval.equals("") || lastval.equals("null") || lastval.equals(null) ){					
					err = "3";					
					break;
				}else{
					if(itemid.equals("CS001")){
						C3 = Float.parseFloat(lastval);
						D3 = Float.parseFloat(val);						
					}else if(itemid.equals("CS002")){
						C4 = Float.parseFloat(lastval);
						D4 = Float.parseFloat(val);							
					}else if(itemid.equals("CS003")){
						C5 = Float.parseFloat(lastval);
						D5 = Float.parseFloat(val);							
					}else if(itemid.equals("CS004")){
						C6 = Float.parseFloat(lastval);
						D6 = Float.parseFloat(val);						
					}else if(itemid.equals("CS005")){
						C7 = Float.parseFloat(lastval);
						D7 = Float.parseFloat(val);							
					}else if(itemid.equals("CS006")){
						C8 = Float.parseFloat(lastval);						
						D8 = Float.parseFloat(val);							
					}else if(itemid.equals("CS007")){
						C9 = Float.parseFloat(lastval);
						D9 = Float.parseFloat(val);						
					}else if(itemid.equals("CS008")){
						C10 = Float.parseFloat(lastval);
						D10 = Float.parseFloat(val);							
					}else if(itemid.equals("CS009")){
						C11 = Float.parseFloat(lastval);
						D11 = Float.parseFloat(val);						
					}else if(itemid.equals("CS010")){
						C12 = Float.parseFloat(lastval);
						D12 = Float.parseFloat(val);						
					}else if(itemid.equals("CS011")){
						C13 = Float.parseFloat(lastval);
						D13 = Float.parseFloat(val);						
					}else if(itemid.equals("CS012")){
						C14 = Float.parseFloat(lastval);
						D14 = Float.parseFloat(val);						
					}else if(itemid.equals("CS013")){
						C15 = Float.parseFloat(lastval);
						D15 = Float.parseFloat(val);						
					}else if(itemid.equals("CS014")){
						C16 = Float.parseFloat(lastval);
						D16 = Float.parseFloat(val);						
					}else if(itemid.equals("CS015")){
						C18 = Float.parseFloat(lastval);
						D18 = Float.parseFloat(val);						
					}else if(itemid.equals("CS016")){
						C19 = Float.parseFloat(lastval);
						D19 = Float.parseFloat(val);						
					}else{
						err = "4";						
						break;					
					}					
				}
			}
			
			String sql = " select a.D24 d24 from uf_yz_liqusepure a where a.liquid = '"+liquid+"' and to_date(a.usedate,'yyyy-mm-dd') = (to_date('"+caldate+"','yyyy-mm-dd')-1 ) and a.stateflag='40285a9049d58e9e0149ea20d3cf6c79'";
			List list1 = baseJdbc.executeSqlForList(sql);				
			if(list1.size()==0){	
				//err = "5";				
				//System.out.println("err="+err);		
				AC24 = 0;
			}else{
				Map m = (Map)list1.get(0);
				String d24 = StringHelper.null2String(m.get("d24"));
				if(d24.equals("") || d24.equals("null") || d24.equals(null)){
					AC24 = 0;
					//err = "6";
					//System.out.println("err="+err);					
				}else{
					AC24 = Float.parseFloat(d24);
				}
			}					
		}
				
		if(err.equals("")){
		    if(action.equals("getvalue")){
				AD32 = Float.parseFloat(beparm);
				AD3 = (float)((D3-C3-D4-C4)*AD32);
				AD5 = (float)((D4-C4)*AD32);
				
				AD8 = (float)((D8-C8)*AD32);
				AD9 = (float)((D5-C5)*AD32);
				AD10 = D6-C6;
				
				AD12 = D9-C9;
				AD13 = D9-C9-AD12;
				AD14 = (float)((D9-C9)*AD32);
				AD15 = D18-C18+D19-C19-AD12;
				AD16 = (float)((D10-C10)*AD32);
				AD17 = (float)((D11-C11)*AD32);
				AD18 = (float)((D12-C12)*AD32);
				AD19 = AD17+AD18;
				AD20 = (float)((D13-C13)*AD32);	
				AD21 = (float)((D14-C14)*AD32);	
				AD22 = (float)(D15*20.302*100); //fomual err? B15*20.302*100
				AD23 = (float)(D16*591.82); //fomual err? B16*591.82
				AD24 = AD22+AD23;
				
				AD25 = AD24-AC24; //fomual err? AC24 from SQUSE
							
				AD27 = D7-C7;	
				
				AD29 = D19-C19;	
				
				AD4 = AD3+AD16;
				AD6 = AD15-D19-C19+AD12;
				AD11 = (float)(AD27+AD6);
				AD26 = -AD25+AD11;
				AD28 = (D19-C19)+AD13+AD4+AD5+AD19+AD20+AD9+AD21+AD8;	
				AD30 = AD28-AD26;
				AD31 = (float)(AD26/AD28); //afterparm
				
				jo.put("D3",String.valueOf(AD3));
				jo.put("D4",String.valueOf(AD4));
				jo.put("D5",String.valueOf(AD5));
				jo.put("D6",String.valueOf(AD6));
				
				jo.put("D8",String.valueOf(AD8));
				jo.put("D9",String.valueOf(AD9));
				jo.put("D10",String.valueOf(AD10));
				jo.put("D11",String.valueOf(AD11));
				jo.put("D12",String.valueOf(AD12));
				jo.put("D13",String.valueOf(AD13));
				jo.put("D14",String.valueOf(AD14));
				jo.put("D15",String.valueOf(AD15));
				jo.put("D16",String.valueOf(AD16));
				jo.put("D17",String.valueOf(AD17));
				jo.put("D18",String.valueOf(AD18));
				jo.put("D19",String.valueOf(AD19));
				jo.put("D20",String.valueOf(AD20));
				jo.put("D21",String.valueOf(AD21));
				jo.put("D22",String.valueOf(AD22));
				jo.put("D23",String.valueOf(AD23));
				jo.put("D24",String.valueOf(AD24));
				jo.put("D25",String.valueOf(AD25));
				jo.put("D26",String.valueOf(AD26));
				jo.put("D27",String.valueOf(AD27));
				jo.put("D28",String.valueOf(AD28));
				jo.put("D29",String.valueOf(AD29));
				jo.put("D30",String.valueOf(AD30));
				jo.put("afterparm",String.valueOf(AD31));
				
				jo.put("msg","true");	
			}else if(action.equals("calvalue")){

				System.out.println("action="+action+" d12="+d12+" d13="+d13+" did="+did);	
				if(did.equals("12")){				
					AD12 = Float.parseFloat(d12);
					
					AD13 = D9-C9-AD12;
					AD15 = D18-C18+D19-C19-AD12;
					AD6 = AD15-D19-C19+AD12;	
					AD28 = (D19-C19);	 //this fomula =AD28 = (D19-C19)+AD13+AD4+AD5+AD19+AD20+AD9+AD21+AD8 £¬only retrun D19-C19
					//AD11 = (float)(AD27+AD6);
					//AD26 = -AD25+AD11;			
					//AD30 = AD28-AD26;
					//AD31 = (float)(AD26/AD28); //afterparm
						

					jo.put("D13",String.valueOf(AD13));
					jo.put("D15",String.valueOf(AD15));
					jo.put("D6",String.valueOf(AD6));
					jo.put("D28",String.valueOf(AD28));
					//jo.put("D11",String.valueOf(AD11));	
					//jo.put("D26",String.valueOf(AD26));					
					//jo.put("D30",String.valueOf(AD30));
					//jo.put("afterparm",String.valueOf(AD31));
					jo.put("msg","true");	
					
				}else if(did.equals("13")){				
					AD13 = Float.parseFloat(d13);
					//AD26 = Float.parseFloat(d26);
					AD28 = (D19-C19); //this fomula =AD28 = (D19-C19)+AD13+AD4+AD5+AD19+AD20+AD9+AD21+AD8 £¬only retrun D19-C19
					//AD30 = AD28-AD26;
					//AD31 = (float)(AD26/AD28); //afterparm		

					jo.put("D28",String.valueOf(AD28));
					//jo.put("D30",String.valueOf(AD30));
					//jo.put("afterparm",String.valueOf(AD31));
					jo.put("msg","true");						
				}else{
					err = "7";
					jo.put("msg","false");
					jo.put("err",err);	
				}				
			 }
		}else{
			jo.put("msg","false");
			jo.put("err",err);		
		}
	}	
	
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();	
%>
