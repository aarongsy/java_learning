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
	String requestid=StringHelper.null2String(request.getParameter("requestid"));
	String liquid=StringHelper.null2String(request.getParameter("liquid"));
	System.out.println("pureshare  action="+action+" requestid="+requestid+" liquid="+liquid);	
	
	String mainform = "uf_yz_pureshare "; //mainform
	String detailform = "uf_yz_puresharesub "; //detailform

	
	float C3=0;
	float D3=0;	
	float E3=0;	
	float F3=0;	
	float G3=0;	
	float H3=0;	
	float I3=0;	
	float J3=0;	
	float K3=0;	
	float M3=0;	
	
	float C4=0;
	float D4=0;
	float E4=0;
	float F4=0;
	float G4=0;
	float H4=0;
	float I4=0;
	float J4=0;
	float K4=0;
	
	float C5=0;
	float D5=0;	
	float E5=0;	
	float F5=0;	
	float G5=0;	
	float H5=0;	
	float I5=0;	
	float J5=0;	
	float K5=0;	
	float M5=0;	
	
	float C6=0;
	float D6=0;	
	float E6=0;	
	float F6=0;	
	float G6=0;	
	float H6=0;	
	float I6=0;	
	float J6=0;	
	float K6=0;	
	float L6=0;	
	float M6=0;
	float N6=0;	
	
	float C7=0;
	float D7=0;	
	float E7=0;	
	float F7=0;	
	float G7=0;	
	float H7=0;	
	float I7=0;	
	float J7=0;	
	float K7=0;	
	float M7=0;		
	
	float C8=0;
	float D8=0;	
	float E8=0;	
	float F8=0;	
	float G8=0;	
	float H8=0;	
	float I8=0;	
	float J8=0;	
	float K8=0;	
	float N8=0;	
	
	float M9=0;
	
	float L10=0;
	float O10=0;
	
	float C11=0;
	float D11=0;	
	float E11=0;	
	float F11=0;	
	float G11=0;	
	float H11=0;	
	float I11=0;	
	float J11=0;	
	float K11=0;	
	float M11=0;
	float N11=0;

	float C12=0;
	float D12=0;	
	float E12=0;	
	float F12=0;	
	float G12=0;	
	float H12=0;	
	float I12=0;	
	float J12=0;	
	float K12=0;	
	float M12=0;
	
	float C13=0;
	float D13=0;	
	float E13=0;	
	float F13=0;	
	float G13=0;	
	float H13=0;	
	float I13=0;	
	float J13=0;	
	float K13=0;	
	float N13=0;

	float C14=0;
	float D14=0;	
	float E14=0;	
	float F14=0;	
	float G14=0;	
	float H14=0;	
	float I14=0;	
	float J14=0;	
	float K14=0;	
	float O14=0;	
	
	float C15=0;
	float D15=0;	
	float E15=0;	
	float F15=0;	
	float G15=0;	
	float H15=0;	
	float I15=0;	
	float J15=0;	
	float K15=0;	
	float M15=0;
	
	String err="";	
	
	JSONObject jo = new JSONObject();
	
	if(action.equals("calvalue")){
		String getvalsql="select itemname,c,d,e,f,g,h,i,j,k,l,m,o from uf_yz_puresharesub where requestid='"+requestid+"'";
		String upsql = "";
		List list = baseJdbc.executeSqlForList(getvalsql);		
		if(list.size()==0){			
			err = "1";			
		}else if(list.size()<13){
			err = "2";			
		}else if(list.size()==13){
			for(int i=0;i<list.size();i++){
				Map map = (Map)list.get(i);
				String itemname = StringHelper.null2String(map.get("itemname"));
				String C = StringHelper.null2String(map.get("c"));
				String D = StringHelper.null2String(map.get("d"));
				String E = StringHelper.null2String(map.get("e"));
				String F = StringHelper.null2String(map.get("f"));
				String G = StringHelper.null2String(map.get("g"));
				String H = StringHelper.null2String(map.get("h"));
				String I = StringHelper.null2String(map.get("i"));
				String J = StringHelper.null2String(map.get("j"));
				String K = StringHelper.null2String(map.get("k"));
				String L = StringHelper.null2String(map.get("l"));
				String M = StringHelper.null2String(map.get("m"));
				String N = StringHelper.null2String(map.get("n"));
				String O = StringHelper.null2String(map.get("o"));
				if(itemname.equals("40285a904a055ae2014a09c89eb11e98")){ //3
				}else if(itemname.equals("40285a904a055ae2014a09c8ebd51e9c")){ //4 
				}else if(itemname.equals("40285a904a055ae2014a09ca6cc11eac")){ //5 
				}else if(itemname.equals("40285a904a055ae2014a09cf17f51f07")){ //6 
					C6=Float.parseFloat(C);
					D6=Float.parseFloat(D);	
					E6=Float.parseFloat(E);	
					F6=Float.parseFloat(F);	
					G6=Float.parseFloat(G);	
					H6=Float.parseFloat(H);	
					I6=Float.parseFloat(I);	
					J6=Float.parseFloat(J);	
					K6=Float.parseFloat(K);	
					L6=Float.parseFloat(L);	
					N6=Float.parseFloat(N);		
					
					M6=C6+D6+E6+F6+G6+H6+I6+J6+K6;
				}else if(itemname.equals("40285a904a055ae2014a09cf17f51f08")){ //7 
				}else if(itemname.equals("40285a904a055ae2014a09cf17f51f09")){ //8 
				}else if(itemname.equals("40285a904a055ae2014a09cfe0481f12")){ //9 
				}else if(itemname.equals("40285a904a055ae2014a09d1f0781f31")){ //10 
					L10=Float.parseFloat(L);
					O10=Float.parseFloat(O);
				}else if(itemname.equals("40285a904a055ae2014a09d1f0781f32")){ //11 
					C11=Float.parseFloat(C);
					D11=Float.parseFloat(D);	
					E11=Float.parseFloat(E);	
					F11=Float.parseFloat(F);	
					G11=Float.parseFloat(G);	
					H11=Float.parseFloat(H);	
					I11=Float.parseFloat(I);
					J11=Float.parseFloat(J);	
					K11=Float.parseFloat(K);	
					M11=Float.parseFloat(M);
					N11=Float.parseFloat(N);				
				}else if(itemname.equals("40285a904a055ae2014a09d1f0781f33")){ //12 
				}else if(itemname.equals("40285a904a055ae2014a09d1f0781f34")){ //13 
				}else if(itemname.equals("40285a904a055ae2014a09d1f0781f35")){ //14 
				}else if(itemname.equals("40285a904a055ae2014a09d1f0781f36")){ //15 
				}
			}
			C5 = C6-C11;
			D5 = D6-D11;
			E5 = E6-E11;
			F5 = F6-F11;
			G5 = G6-G11;
			H5 = H6-H11;
			I5 = I6-I11;
			J5 = J6-J11;
			K5 = K6-K11;
			M5 = C5+D5+E5+F5+G5+H5+I5+J5+K5;
			
			C3 = C5;
			D3 = D5;
			E3 = E5;
			F3 = F5;
			G3 = G5;
			H3 = H5;
			I3 = I5;
			J3 = J5;
			K3 = K5;
			
			M3 = C3+D3+E3+F3+G3+H3+I3+J3+K3;
			
			if(M3>0){
				C4 = (float)(C3/M3);
				D4 = (float)(D3/M3);
				E4 = (float)(E3/M3);
				F4 = (float)(F3/M3);
				G4 = (float)(G3/M3);
				H4 = (float)(H3/M3);
				I4 = (float)(I3/M3);
				J4 = (float)(J3/M3);
				K4 = (float)(1-C4-D4-E4-F4-G4-H4-I4-J4);
			}
			
			if(M6>0){
				C7 = (float)(C6/M6);
				D7 = (float)(D6/M6);
				E7 = (float)(E6/M6);
				F7 = (float)(F6/M6);
				G7 = (float)(G6/M6);
				H7 = (float)(H6/M6);
				I7 = (float)(I6/M6);
				J7 = (float)(J6/M6);
				K7 = (float)(1-C7-D7-E7-F7-G7-H7-I7-J7);
				M7 = 1;
			}
			
			C8 = (float)(C4*N6);
			D8 = (float)(D4*N6);
			E8 = (float)(E4*N6);
			F8 = (float)(F4*N6);
			G8 = (float)(G4*N6);
			H8 = (float)(H4*N6);
			I8 = (float)(I4*N6);
			J8 = (float)(J4*N6);
			K8 = (float)(N6-C8-D8-E8-G8-H8-I8-K8);
			N8 = C8+D8+E8+F8+G8+H8+I8+J8+K8;
			
			M9 =C7+E7+G7+H7+I7+J7+D7;
			
			if(M11>0){
				C12 = (float)(C11/M11);
				D12 = (float)(D11/M11);
				E12 = (float)(E11/M11);
				F12 = (float)(F11/M11);
				G12 = (float)(G11/M11);
				H12 = (float)(H11/M11);
				I12 = (float)(I11/M11);
				J12 = (float)(J11/M11);
				K12 = (float)(1-C12-D12-E12-F12-G12-H12-I12-J12);
				M12 = 1;
			}
			
			C13 = (float)(N11*C12);
			D13 = (float)(N11*D12);
			E13 = (float)(N11*E12);
			F13 = (float)(N11*F12);
			G13 = (float)(N11*G12);
			H13 = (float)(N11*H12);
			I13 = (float)(N11*I12);
			J13 = (float)(N11*J12);
			K13 = (float)(N11-C13-D13-E13-F13-G13-H13-I13-J13);
			N13 = C13+D13+E13+F13+G13+H13+I13+J13+K13;
			
			C14 = C8+C13;
			D14 = D8+D13;
			E14 = E8+E13;
			F14 = F8+F13;
			G14 = G8+G13;
			H14 = H8+H13;
			I14 = I8+I13;
			J14 = J8+J13;
			K14 = K8+K13;
			O14 = C14+D14+E14+F14+G14+H14+I14+J14+K14;
			
			if(O14>0){
				C15 = (float)(C14/O14);
				D15 = (float)(D14/O14);
				E15 = (float)(E14/O14);
				F15 = (float)(F14/O14);
				G15 = (float)(G14/O14);
				H15 = (float)(H14/O14);
				I15 = (float)(I14/O14);
				J15 = (float)(J14/O14);
				K15 = (float)(1-C15-D15-E15-F15-G15-H15-I15-J15);
				M15 = 1;
			}
			upsql = "update uf_yz_puresharesub set C="+C3+",D="+D3+",E="+E3+",F="+F3+",G="+G3+",H="+H3+",I="+I3+",J="+J3+",K="+K3+",M="+M3+" where requestid="+requestid+" and itemname='40285a904a055ae2014a09c89eb11e98'";
			baseJdbc.update(upsql);
			upsql = "update uf_yz_puresharesub set C="+C4+",D="+D4+",E="+E4+",F="+F4+",G="+G4+",H="+H4+",I="+I4+",J="+J4+",K="+K4+" where requestid="+requestid+" and itemname='40285a904a055ae2014a09c8ebd51e9c'";
			baseJdbc.update(upsql);
			upsql = "update uf_yz_puresharesub set C="+C5+",D="+D5+",E="+E5+",F="+F5+",G="+G5+",H="+H5+",I="+I5+",J="+J5+",K="+K5+",M="+M5+" where requestid="+requestid+" and itemname='40285a904a055ae2014a09ca6cc11eac'";
			baseJdbc.update(upsql);
			upsql = "update uf_yz_puresharesub set M="+M6+" where requestid="+requestid+" and itemname='40285a904a055ae2014a09cf17f51f07'";
			baseJdbc.update(upsql);
			upsql = "update uf_yz_puresharesub set C="+C7+",D="+D7+",E="+E7+",F="+F7+",G="+G7+",H="+H7+",I="+I7+",J="+J7+",K="+K7+",M="+M7+" where requestid="+requestid+" and itemname='40285a904a055ae2014a09cf17f51f08'";
			baseJdbc.update(upsql);
			upsql = "update uf_yz_puresharesub set C="+C8+",D="+D8+",E="+E8+",F="+F8+",G="+G8+",H="+H8+",I="+I8+",J="+J8+",K="+K8+",N="+N8+" where requestid="+requestid+" and itemname='40285a904a055ae2014a09cf17f51f09'";
			baseJdbc.update(upsql);
			upsql = "update uf_yz_puresharesub set M="+M9+" where requestid="+requestid+" and itemname='40285a904a055ae2014a09cfe0481f12'";
			baseJdbc.update(upsql);
			upsql = "update uf_yz_puresharesub set C="+C12+",D="+D12+",E="+E12+",F="+F12+",G="+G12+",H="+H12+",I="+I12+",J="+J12+",K="+K12+",M="+M12+" where requestid="+requestid+" and itemname='40285a904a055ae2014a09d1f0781f33'";
			baseJdbc.update(upsql);
			upsql = "update uf_yz_puresharesub set C="+C13+",D="+D13+",E="+E13+",F="+F13+",G="+G13+",H="+H13+",I="+I13+",J="+J13+",K="+K13+",N="+N13+" where requestid="+requestid+" and itemname='40285a904a055ae2014a09d1f0781f34'";
			baseJdbc.update(upsql);
			upsql = "update uf_yz_puresharesub set C="+C14+",D="+D14+",E="+E14+",F="+F14+",G="+G14+",H="+H14+",I="+I14+",J="+J14+",K="+K14+",O="+O14+" where requestid="+requestid+" and itemname='40285a904a055ae2014a09d1f0781f35'";
			baseJdbc.update(upsql);
			upsql = "update uf_yz_puresharesub set C="+C15+",D="+D15+",E="+E15+",F="+F15+",G="+G15+",H="+H15+",I="+I15+",J="+J15+",K="+K15+",M="+M15+" where requestid="+requestid+" and itemname='40285a904a055ae2014a09d1f0781f36'";
			
		}

	}else{
		err = "3";
	}
	
	if(err.equals("")){
		//	jo.put("D3",String.valueOf(AD3));			
		jo.put("msg","true");
	}else{
		jo.put("msg","false");
		jo.put("err",err);
	}	
	
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();	
%>
