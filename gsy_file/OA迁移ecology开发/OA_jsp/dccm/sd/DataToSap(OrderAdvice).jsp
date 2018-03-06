<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService"%>
<%@ page import="com.eweaver.base.util.DateHelper"%>
<%@ page import="com.sap.conn.jco.JCoTable" %>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.dccm.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.eweaver.app.configsap.SapSync"%>
<%@ page import="java.util.List" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.eweaver.sysinterface.base.Param"%>
<%@ page import="com.eweaver.sysinterface.javacode.EweaverExecutorBase"%>







<%
		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		String requestid = StringHelper.null2String(request.getParameter("requestid"));
		//以下为主表数据
		String telno = "";
		String factype = "";
		String company = "";
		String comcode = "";
		String depart = "";
		String reqdate = "";
		String jbman = "";
		String spztxt = "";
		String shipcom = "";
		String shipcomtxt = "";
		String qyg = "";
		String mdg = "";
		String mdgid = "";//目的港id
		String imtime = "";//导入日时间
		String idate = "";//导入日期
		String itime = "";//导入时间
		String direct = "";//是否直航
		String flexibag = "";//是否太空包
		String hydl = "";
		String hydltxt = "";
		String month = "";
		String feeder = "";
		String gx = "";
		String gs = "";
		String xyzno = "";
		String shipno = "";
		String isvalid = "";
		String tag1 = "";
		String tag2 = "";
		String tag3 = "";
		String tag4 = "";
		String jgdate = "";
		String khdate = "";
		String dgdate = "";
		String clostime = "";
		String canman = "";
		String cantime = "";
		String via = "";
		String shipremark = "";
		String status = "";
		String lcno = "";
		String issdate = "";
		String consign = "";
		String notify = "";
		String remark = "";
	
		String asql = "select fh.telno,(select objname from orgunittype where id=fh.area)factype,(select objname from orgunit where id=fh.comtype)company,fh.comcode,(select objname from orgunit where id=fh.psndept)depart,fh.reqdate,(select objname from humres where id=fh.psn)jbman,fh.spztxt,fh.shipcom,fh.shipcomtxt,fh.qyg,fh.mdg as mdgid,(select mdg from v_dmsd_hyotherfee where requestid=fh.mdg)mdg,fh.hydl,fh.hydltxt,fh.month,fh.feeder,(select cabtype from uf_dmdb_cabtype where requestid=fh.gx)gx,fh.gs,fh.xyzno,fh.shipno,(select objname from selectitem where id=fh.isvalid)isvalid,(select tagtype from uf_dmsd_tagtype where requestid=fh.tag1)tag1,(select tagtype from uf_dmsd_tagtype where requestid=fh.tag2)tag2,(select tagtype from uf_dmsd_tagtype where requestid=fh.tag3)tag3,(select tagtype from uf_dmsd_tagtype where requestid=fh.tag4)tag4,fh.jgdate,fh.khdate,fh.dgdate,(select objname from selectitem where id=fh.clostime)clostime,(select objname from humres where id=fh.canman)canman,fh.cantime,fh.via,fh.shipremark,(select objname from selectitem where id=fh.status)status,fh.lcno,fh.issdate,fh.consign,fh.notify,fh.remark from uf_dmsd_delnotes fh where fh.requestid='"+requestid+"'";

		List alist = baseJdbc.executeSqlForList(asql);
		if(alist.size()>0)
		{
			Map amap = (Map)alist.get(0);
			//以下为单行文本(抬头字段)
			telno = StringHelper.null2String(amap.get("telno"));//发货通知书编号 
			factype = StringHelper.null2String(amap.get("factype"));//厂区别 
			company = StringHelper.null2String(amap.get("company"));//公司别 
			comcode = StringHelper.null2String(amap.get("comcode"));//公司代码
			depart = StringHelper.null2String(amap.get("depart"));//经办部门
			reqdate = StringHelper.null2String(amap.get("reqdate"));//经办日期
			if(!reqdate.equals(""))
			{
				reqdate = reqdate.replaceAll("-","");
			}
			jbman = StringHelper.null2String(amap.get("jbman"));//经办人 
			spztxt = StringHelper.null2String(amap.get("spztxt"));//销售凭证文本 
			shipcom = StringHelper.null2String(amap.get("shipcom"));//船公司 
			shipcomtxt = StringHelper.null2String(amap.get("shipcomtxt"));//船公司名称 
			qyg = StringHelper.null2String(amap.get("qyg"));//启运港
			mdg = StringHelper.null2String(amap.get("mdg"));//目的港
			mdgid = StringHelper.null2String(amap.get("mdgid"));//目的港id
			
			//查询海运费中的Import Date,Flexibag,Direct Shipment
			String hyfsql = "select imtime,direct,flexibag from uf_dmsd_hyfeelist where requestid = '"+mdgid+"'";
			List hyflist = baseJdbc.executeSqlForList(hyfsql);
			if(hyflist.size()>0)
			{
				Map hyfmap = (Map)hyflist.get(0);
				imtime = StringHelper.null2String(hyfmap.get("imtime"));
				idate = imtime.split(" ")[0];
				if(!idate.equals(""))
				{
					idate = idate.replaceAll("-","");
				}
				itime = imtime.split(" ")[1];
				direct = StringHelper.null2String(hyfmap.get("direct"));
				if(direct.equals("40285a8d5763da3c0157646db1b4053a"))
				{
					direct = "YES";
				}
				else
				{
					direct = "NO";
				}
				flexibag = StringHelper.null2String(hyfmap.get("flexibag"));
				if(flexibag.equals("40285a8d5763da3c0157646db1b4053a"))
				{
					flexibag = "YES";
				}
				else
				{
					flexibag = "NO";
				}
			}

			
			hydl = StringHelper.null2String(amap.get("hydl"));//海运代理
			hydltxt = StringHelper.null2String(amap.get("hydltxt"));//海运代理名称
			month = StringHelper.null2String(amap.get("month"));//Mother船名
			feeder = StringHelper.null2String(amap.get("feeder"));//Feeder船名
			gx = StringHelper.null2String(amap.get("gx"));//柜型
			gs = StringHelper.null2String(amap.get("gs"));//柜数
			xyzno = StringHelper.null2String(amap.get("xyzno"));//信用证凭证号
			shipno = StringHelper.null2String(amap.get("shipno"));//订船编号
			isvalid = StringHelper.null2String(amap.get("isvalid"));//是否有效
			if(isvalid.equals("是"))
			{
				isvalid = "YES";
			}
			else
			{
				isvalid = "NO";
			}
			tag1 = StringHelper.null2String(amap.get("tag1"));//标签1
			tag2 = StringHelper.null2String(amap.get("tag2"));//标签2
			tag3 = StringHelper.null2String(amap.get("tag3"));//标签3
			tag4 = StringHelper.null2String(amap.get("tag4"));//标签4
			jgdate = StringHelper.null2String(amap.get("jgdate"));//结关日期
			if(!jgdate.equals(""))
			{
				jgdate = jgdate.replaceAll("-","");
			}
			khdate = StringHelper.null2String(amap.get("khdate"));//开航日期
			if(!khdate.equals(""))
			{
				khdate = khdate.replaceAll("-","");
			}
			dgdate = StringHelper.null2String(amap.get("dgdate"));//到港日期
			if(!dgdate.equals(""))
			{
				dgdate = dgdate.replaceAll("-","");
			}
			clostime = StringHelper.null2String(amap.get("clostime"));//预计结关时间点
			canman = StringHelper.null2String(amap.get("canman"));//作废人
			cantime = StringHelper.null2String(amap.get("cantime"));//作废时间
			via = StringHelper.null2String(amap.get("via"));//Via
			shipremark = StringHelper.null2String(amap.get("shipremark"));//Remark
			status = StringHelper.null2String(amap.get("status"));//外销状态
			lcno = StringHelper.null2String(amap.get("lcno"));//信用证编号
			issdate = StringHelper.null2String(amap.get("issdate"));//发行日期(信用证)
			if(!issdate.equals(""))
			{
				issdate = issdate.replaceAll("-","");
			}
			consign = StringHelper.null2String(amap.get("consign"));//Consign
			notify = StringHelper.null2String(amap.get("notify"));//Notify
			remark = StringHelper.null2String(amap.get("remark"));//Remark
			//System.out.println("haha1-----------------------------");
		}


		System.out.println("telno----------------------:"+telno);
		System.out.println("factype----------------------:"+factype);
		System.out.println("company---------------------:"+company);
		System.out.println("comcode-------------------:"+comcode);
		System.out.println("depart----------------------:"+depart);
		System.out.println("reqdate----------------------:"+reqdate);
		System.out.println("jbman---------------------:"+jbman);
		System.out.println("spztxt-------------------:"+spztxt);
		System.out.println("shipcom----------------------:"+shipcom);
		System.out.println("shipcomtxt----------------------:"+shipcomtxt);
		System.out.println("qyg---------------------:"+qyg);
		System.out.println("mdg-------------------:"+mdg);
		System.out.println("hydl----------------------:"+hydl);
		System.out.println("hydltxt----------------------:"+hydltxt);
		System.out.println("month---------------------:"+month);
		System.out.println("feeder-------------------:"+feeder);
		System.out.println("gx----------------------:"+gx);
		System.out.println("gs----------------------:"+gs);
		System.out.println("xyzno---------------------:"+xyzno);
		System.out.println("isvalid-------------------:"+isvalid);
		System.out.println("shipno---------------------:"+shipno);
		System.out.println("tag1-------------------:"+tag1);
		System.out.println("tag2----------------------:"+tag2);
		System.out.println("tag3----------------------:"+tag3);
		System.out.println("tag4---------------------:"+tag4);
		System.out.println("jgdate-------------------:"+jgdate);
		System.out.println("khdate---------------------:"+khdate);
		System.out.println("dgdate-------------------:"+dgdate);
		System.out.println("clostime----------------------:"+clostime);
		System.out.println("canman----------------------:"+canman);
		System.out.println("cantime---------------------:"+cantime);
		System.out.println("via-------------------:"+via);
		System.out.println("shipremark-------------------:"+shipremark);
		System.out.println("status----------------------:"+status);
		System.out.println("lcno----------------------:"+lcno);
		System.out.println("issdate---------------------:"+issdate);




		//创建SAP对象		
		SapConnector sapConnector = new SapConnector();
		String functionName = "ZMY_SAVE_FH";
		JCoFunction function = null;
		try {
			function = SapConnector.getRfcFunction(functionName);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		//将抬头数据插入SAP
		JCoTable retTable0 = function.getTableParameterList().getTable("HEAD");
		retTable0.appendRow();
		retTable0.setValue("ZZTELNO",telno);
		retTable0.setValue("ZZAREA",factype);
		retTable0.setValue("ZZCOMTYPE",company);
		retTable0.setValue("ZZCOMCODE",comcode);
		retTable0.setValue("ZZPSNDEPT",depart);
		retTable0.setValue("ZZREQDATE",reqdate);
		retTable0.setValue("ZZPSN",jbman);
		retTable0.setValue("ZZSPZTXT",spztxt);
		retTable0.setValue("ZZSHIPCOM",shipcom);
		retTable0.setValue("ZZSHIPCOMTXT",shipcomtxt);
		retTable0.setValue("ZZQYG",qyg);
		retTable0.setValue("ZZMDG",mdg);
		retTable0.setValue("ZZHYDL",hydl);
		retTable0.setValue("ZZHYDLTXT",hydltxt);
		retTable0.setValue("ZZMONTH",month);
		retTable0.setValue("ZZFEEDER",feeder);
		retTable0.setValue("ZZGX",gx);
		retTable0.setValue("ZZGS",gs);
		retTable0.setValue("ZZXYZNO",xyzno);
		retTable0.setValue("ZZISVALID",isvalid);
		retTable0.setValue("ZZSHIPNO",shipno);
		retTable0.setValue("ZZTAG1",tag1);
		retTable0.setValue("ZZTAG2",tag2);
		retTable0.setValue("ZZTAG3",tag3);
		retTable0.setValue("ZZTAG4",tag4);
		retTable0.setValue("ZZJGDATE",jgdate);
		retTable0.setValue("ZZKHDATE",khdate);
		retTable0.setValue("ZZDGDATE",dgdate);
		retTable0.setValue("ZZCLOSTIME",clostime);
		retTable0.setValue("ZZCANMAN",canman);
		retTable0.setValue("ZZCANTIME",cantime);
		retTable0.setValue("ZZVIA",via);
		retTable0.setValue("ZZSHIPREMARK",shipremark);
		retTable0.setValue("ZZSTATUS",status);
		retTable0.setValue("ZZLCNO",lcno);
		retTable0.setValue("ZZISSDATE",issdate);
		
		retTable0.setValue("ZDATE",idate);
		retTable0.setValue("ZTIME",itime);
		retTable0.setValue("ZDIRECT",direct);
		retTable0.setValue("ZFLEXIBAG",flexibag);

		
		//以下为多行文本(以回车符分割)
		//Consignee
		//System.out.println("Consignee-------------------------------------");
		if(!consign.equals(""))
		{
			if(consign.indexOf("\n")!=-1)//存在回车符
			{
				//System.out.println("consign has enter!");
				String[] arrlist1 = consign.split("\n");
				for(int a1=0;a1<arrlist1.length;a1++)
				{
					String tmpstr1 = "";
					int tmpa1 = a1+1;
					int len1 = arrlist1[a1].length();
					int row1 = 0;//行数
					if(len1%132==0)
					{
						//System.out.println("consign...1");
						row1 = len1/132;
						for(int j1=0;j1<row1;j1++)
						{
							tmpstr1 = tmpstr1 + arrlist1[a1].substring(j1*132,(j1+1)*132) + "^";
						}
						tmpstr1 = tmpstr1.substring(0,tmpstr1.length());
					}
					else
					{
						//System.out.println("consign...2");
						row1 = len1/132;
						if(row1==0)
						{
							tmpstr1 = arrlist1[a1];
						}
						else
						{
							for(int j2=0;j2<row1;j2++)
							{
								tmpstr1 = tmpstr1 + arrlist1[a1].substring(j2*132,(j2+1)*132) + "^";
							}
							tmpstr1 = tmpstr1 + arrlist1[a1].substring(row1*132,len1);
						}
					}
					JCoTable retTable1 = function.getTableParameterList().getTable("CONSIGN");
					if(tmpstr1.indexOf("^")!=-1)
					{
						//System.out.println("consign...3");
						String[] array1 = tmpstr1.split("\\^");
						for(int x=0;x<array1.length;x++)
						{
							//if(array1[x].endsWith("\n")==true)//判断字符串最后一位是否为回车符,若是则去掉
							//{
								//array1[x] = array1[x].substring(0,array1[x].length()-1);
							//}
							array1[x] = array1[x].replace("\n","");//去掉字符串中所有的回车符
							array1[x] = array1[x].replace("\r","");//去掉字符串中所有的换行符
							//System.out.println("array1[x]:"+array1[x]);
							retTable1.appendRow();
							if(x==0)
							{
								retTable1.setValue("TDFORMAT",String.valueOf(tmpa1));//当前行
								retTable1.setValue("TDLINE",array1[x]);//当前行内容
							}
							else
							{
								retTable1.setValue("TDFORMAT","");//当前行
								retTable1.setValue("TDLINE",array1[x]);//当前行内容
							}
						}
					}
					else
					{
						//System.out.println("consign...4");
						//if(tmpstr1.endsWith("\n")==true)//判断字符串最后一位是否为回车符,若是则去掉
						//{
							//tmpstr1 = tmpstr1.substring(0,tmpstr1.length()-1);
						//}
						tmpstr1 = tmpstr1.replace("\n","");//去掉字符串中所有的回车符
						tmpstr1 = tmpstr1.replace("\r","");//去掉字符串中所有的换行符
						//System.out.println("tmpstr1:"+tmpstr1);
						retTable1.appendRow();
						retTable1.setValue("TDFORMAT",String.valueOf(tmpa1));
						retTable1.setValue("TDLINE",tmpstr1);
					}
				}
			}
			else
			{
				//System.out.println("consign has not enter!");
				String tmpstr1 = "";
				int len1 = consign.length();
				int row1 = 0;//行数
				if(len1%132==0)
				{
					//System.out.println("consign...5");
					row1 = len1/132;
					for(int j1=0;j1<row1;j1++)
					{
						tmpstr1 = tmpstr1 + consign.substring(j1*132,(j1+1)*132) + "^";
					}
					tmpstr1 = tmpstr1.substring(0,tmpstr1.length());
				}
				else
				{
					//System.out.println("consign...6");
					row1 = len1/132;
					if(row1==0)
					{
						tmpstr1 = consign;
					}
					else
					{
						for(int j2=0;j2<row1;j2++)
						{
							tmpstr1 = tmpstr1 + consign.substring(j2*132,(j2+1)*132) + "^";
						}
						tmpstr1 = tmpstr1 + consign.substring(row1*132,len1);
					}
				}
				JCoTable retTable1 = function.getTableParameterList().getTable("CONSIGN");
				if(tmpstr1.indexOf("^")!=-1)
				{
					//System.out.println("consign...7");
					String[] array1 = tmpstr1.split("\\^");
					for(int x=0;x<array1.length;x++)
					{
						//if(array1[x].endsWith("\n")==true)//判断字符串最后一位是否为回车符,若是则去掉
						//{
							//array1[x] = array1[x].substring(0,array1[x].length()-1);
						//}
						array1[x] = array1[x].replace("\n","");//去掉字符串中所有的回车符
						array1[x] = array1[x].replace("\r","");//去掉字符串中所有的换行符
						//System.out.println("array1[x]:"+array1[x]);
						retTable1.appendRow();
						if(x==0)
						{
							retTable1.setValue("TDFORMAT","1");//当前行
							retTable1.setValue("TDLINE",array1[x]);//当前行内容
						}
						else
						{
							retTable1.setValue("TDFORMAT","");//当前行
							retTable1.setValue("TDLINE",array1[x]);//当前行内容
						}
					}
				}
				else
				{
					//System.out.println("consign...8");
					//if(tmpstr1.endsWith("\n")==true)//判断字符串最后一位是否为回车符,若是则去掉
					//{
						//tmpstr1 = tmpstr1.substring(0,tmpstr1.length()-1);
					//}
					tmpstr1 = tmpstr1.replace("\n","");//去掉字符串中所有的回车符
					tmpstr1 = tmpstr1.replace("\r","");//去掉字符串中所有的换行符
					//System.out.println("tmpstr1:"+tmpstr1);
					retTable1.appendRow();
					retTable1.setValue("TDFORMAT","1");
					retTable1.setValue("TDLINE",tmpstr1);
				}
			}
		}
		
		//Notify
		//System.out.println("Notify-------------------------------------");
		if(!notify.equals(""))
		{
			if(notify.indexOf("\n")!=-1)//存在回车符
			{
				//System.out.println("notify has enter!");
				String[] arrlist2 = notify.split("\n");
				for(int a2=0;a2<arrlist2.length;a2++)
				{
					String tmpstr2 = "";
					int tmpa2 = a2+1;
					int len2 = arrlist2[a2].length();
					int row2 = 0;//行数
					if(len2%132==0)
					{
						//System.out.println("notify...1");
						row2 = len2/132;
						for(int j3=0;j3<row2;j3++)
						{
							tmpstr2 = tmpstr2 + arrlist2[a2].substring(j3*132,(j3+1)*132) + "^";
						}
						tmpstr2 = tmpstr2.substring(0,tmpstr2.length());
					}
					else
					{
						//System.out.println("notify...2");
						row2 = len2/132;
						if(row2==0)
						{
							tmpstr2 = arrlist2[a2];
						}
						else
						{
							for(int j4=0;j4<row2;j4++)
							{
								tmpstr2 = tmpstr2 + arrlist2[a2].substring(j4*132,(j4+1)*132) + "^";
							}
							tmpstr2 = tmpstr2 + arrlist2[a2].substring(row2*132,len2);
						}
					}
					JCoTable retTable2 = function.getTableParameterList().getTable("NOTIFY");
					if(tmpstr2.indexOf("^")!=-1)
					{
						//System.out.println("notify...3");
						String[] array2 = tmpstr2.split("\\^");
						for(int y=0;y<array2.length;y++)
						{
							//if(array2[y].endsWith("\n")==true)//判断字符串最后一位是否为回车符,若是则去掉
							//{
								//array2[y] = array2[y].substring(0,array2[y].length()-1);
							//}
							array2[y] = array2[y].replace("\n","");//去掉字符串中所有的回车符
							array2[y] = array2[y].replace("\r","");//去掉字符串中所有的换行符
							//System.out.println("array2[y]:"+array2[y]);
							retTable2.appendRow();
							if(y==0)
							{
								retTable2.setValue("TDFORMAT",String.valueOf(tmpa2));//当前行
								retTable2.setValue("TDLINE",array2[y]);//当前行内容
							}
							else
							{
								retTable2.setValue("TDFORMAT","");//当前行
								retTable2.setValue("TDLINE",array2[y]);//当前行内容
							}
						}
					}
					else
					{
						//System.out.println("notify...4");
						//if(tmpstr2.endsWith("\n")==true)//判断字符串最后一位是否为回车符,若是则去掉
						//{
							//tmpstr2 = tmpstr2.substring(0,tmpstr2.length()-1);
						//}
						tmpstr2 = tmpstr2.replace("\n","");//去掉字符串中所有的回车符
						tmpstr2 = tmpstr2.replace("\r","");//去掉字符串中所有的换行符
						//System.out.println("tmpstr2:"+tmpstr2);
						retTable2.appendRow();
						retTable2.setValue("TDFORMAT",String.valueOf(tmpa2));
						retTable2.setValue("TDLINE",tmpstr2);
					}
				}
			}
			else
			{
				//System.out.println("notify has not enter!");
				String tmpstr2 = "";
				int len2 = notify.length();
				int row2 = 0;//行数
				if(len2%132==0)
				{
					//System.out.println("notify...5");
					row2 = len2/132;
					for(int j3=0;j3<row2;j3++)
					{
						tmpstr2 = tmpstr2 + notify.substring(j3*132,(j3+1)*132) + "^";
					}
					tmpstr2 = tmpstr2.substring(0,tmpstr2.length());
				}
				else
				{
					//System.out.println("notify...6");
					row2 = len2/132;
					if(row2==0)
					{
						tmpstr2 = notify;
					}
					else
					{
						for(int j4=0;j4<row2;j4++)
						{
							tmpstr2 = tmpstr2 + notify.substring(j4*132,(j4+1)*132) + "^";
						}
						tmpstr2 = tmpstr2 + notify.substring(row2*132,len2);
					}
				}
				JCoTable retTable2 = function.getTableParameterList().getTable("NOTIFY");
				if(tmpstr2.indexOf("^")!=-1)
				{
					//System.out.println("notify...7");
					String[] array2 = tmpstr2.split("\\^");
					for(int y=0;y<array2.length;y++)
					{
						//if(array2[y].endsWith("\n")==true)//判断字符串最后一位是否为回车符,若是则去掉
						//{
							//array2[y] = array2[y].substring(0,array2[y].length()-1);
						//}
						array2[y] = array2[y].replace("\n","");//去掉字符串中所有的回车符
						array2[y] = array2[y].replace("\r","");//去掉字符串中所有的换行符
						//System.out.println("array2[y]:"+array2[y]);
						retTable2.appendRow();
						if(y==0)
						{
							retTable2.setValue("TDFORMAT","1");//当前行
							retTable2.setValue("TDLINE",array2[y]);//当前行内容
						}
						else
						{
							retTable2.setValue("TDFORMAT","");//当前行
							retTable2.setValue("TDLINE",array2[y]);//当前行内容
						}
					}
				}
				else
				{
					//System.out.println("notify...8");
					//if(tmpstr2.endsWith("\n")==true)//判断字符串最后一位是否为回车符,若是则去掉
					//{
						//tmpstr2 = tmpstr2.substring(0,tmpstr2.length()-1);
					//}
					tmpstr2 = tmpstr2.replace("\n","");//去掉字符串中所有的回车符
					tmpstr2 = tmpstr2.replace("\r","");//去掉字符串中所有的换行符
					//System.out.println("tmpstr2:"+tmpstr2);
					retTable2.appendRow();
					retTable2.setValue("TDFORMAT","1");
					retTable2.setValue("TDLINE",tmpstr2);
				}
			}
		}
		
		//Remark
		//System.out.println("Remark-------------------------------------");
		if(!remark.equals(""))
		{
			if(remark.indexOf("\n")!=-1)//存在回车符
			{
				//System.out.println("remark has enter!");
				String[] arrlist3 = remark.split("\n");
				for(int a3=0;a3<arrlist3.length;a3++)
				{
					String tmpstr3 = "";
					int tmpa3 = a3+1;
					int len3 = arrlist3[a3].length();
					int row3 = 0;//行数
					if(len3%132==0)
					{
						//System.out.println("remark...1");
						row3 = len3/132;
						for(int j5=0;j5<row3;j5++)
						{
							tmpstr3 = tmpstr3 + arrlist3[a3].substring(j5*132,(j5+1)*132) + "^";
						}
						tmpstr3 = tmpstr3.substring(0,tmpstr3.length());
					}
					else
					{
						//System.out.println("remark...2");
						row3 = len3/132;
						if(row3==0)
						{
							//System.out.println("meichaoguo");
							tmpstr3 = arrlist3[a3];
						}
						else
						{
							//System.out.println("chaoguo");
							for(int j6=0;j6<row3;j6++)
							{
								tmpstr3 = tmpstr3 + arrlist3[a3].substring(j6*132,(j6+1)*132) + "^";
							}
							tmpstr3 = tmpstr3 + arrlist3[a3].substring(row3*132,len3);
						}
					}
					JCoTable retTable3 = function.getTableParameterList().getTable("REMARK");
					if(tmpstr3.indexOf("^")!=-1)
					{
						//System.out.println("remark...3");
						String[] array3 = tmpstr3.split("\\^");
						for(int z=0;z<array3.length;z++)
						{
							//if(array3[z].endsWith("\n")==true)//判断字符串最后一位是否为回车符,若是则去掉
							//{
								//array3[z] = array3[z].substring(0,array3[z].length()-1);
							//}
							array3[z] = array3[z].replace("\n","");//去掉字符串中所有的回车符
							array3[z] = array3[z].replace("\r","");//去掉字符串中所有的换行符
							//System.out.println("array3[z]:"+array3[z]);
							retTable3.appendRow();
							if(z==0)
							{
								retTable3.setValue("TDFORMAT",String.valueOf(tmpa3));//当前行
								retTable3.setValue("TDLINE",array3[z]);//当前行内容
							}
							else
							{
								retTable3.setValue("TDFORMAT","");//当前行
								retTable3.setValue("TDLINE",array3[z]);//当前行内容
							}
						}
					}
					else
					{
						//System.out.println("remark...4");
						//if(tmpstr3.endsWith("\n")==true)//判断字符串最后一位是否为回车符,若是则去掉
						//{
							//tmpstr3 = tmpstr3.substring(0,tmpstr3.length()-1);
						//}
						tmpstr3 = tmpstr3.replace("\n","");//去掉字符串中所有的回车符
						tmpstr3 = tmpstr3.replace("\r","");//去掉字符串中所有的换行符
						//System.out.println("tmpstr3:"+tmpstr3);
						retTable3.appendRow();
						retTable3.setValue("TDFORMAT",String.valueOf(tmpa3));
						retTable3.setValue("TDLINE",tmpstr3);
					}
				}
			}
			else
			{
				//System.out.println("remark has not enter!");
				String tmpstr3 = "";
				int len3 = remark.length();
				int row3 = 0;//行数
				if(len3%132==0)
				{
					//System.out.println("remark...5");
					row3 = len3/132;
					for(int j5=0;j5<row3;j5++)
					{
						tmpstr3 = tmpstr3 + remark.substring(j5*132,(j5+1)*132) + "^";
					}
					tmpstr3 = tmpstr3.substring(0,tmpstr3.length());
				}
				else
				{
					//System.out.println("remark...6");
					row3 = len3/132;
					if(row3==0)
					{
						tmpstr3 = remark;
					}
					else
					{
						for(int j6=0;j6<row3;j6++)
						{
							tmpstr3 = tmpstr3 + remark.substring(j6*132,(j6+1)*132) + "^";
						}
						tmpstr3 = tmpstr3 + remark.substring(row3*132,len3);
					}
				}
				JCoTable retTable3 = function.getTableParameterList().getTable("REMARK");
				if(tmpstr3.indexOf("^")!=-1)
				{
					//System.out.println("remark...7");
					String[] array3 = tmpstr3.split("\\^");
					for(int z=0;z<array3.length;z++)
					{
						//if(array3[z].endsWith("\n")==true)//判断字符串最后一位是否为回车符,若是则去掉
						//{
							//array3[z] = array3[z].substring(0,array3[z].length()-1);
						//}
						array3[z] = array3[z].replace("\n","");//去掉字符串中所有的回车符
						array3[z] = array3[z].replace("\r","");//去掉字符串中所有的换行符
						//System.out.println("array3[z]:"+array3[z]);
						retTable3.appendRow();
						if(z==0)
						{
							retTable3.setValue("TDFORMAT","1");//当前行
							retTable3.setValue("TDLINE",array3[z]);//当前行内容
						}
						else
						{
							retTable3.setValue("TDFORMAT","");//当前行
							retTable3.setValue("TDLINE",array3[z]);//当前行内容
						}
					}
				}
				else
				{
					//System.out.println("remark...8");
					//if(tmpstr3.endsWith("\n")==true)//判断字符串最后一位是否为回车符,若是则去掉
					//{
						//tmpstr3 = tmpstr3.substring(0,tmpstr3.length()-1);
					//}
					tmpstr3 = tmpstr3.replace("\n","");//去掉字符串中所有的回车符
					tmpstr3 = tmpstr3.replace("\r","");//去掉字符串中所有的换行符
					//System.out.println("tmpstr3:"+tmpstr3);
					retTable3.appendRow();
					retTable3.setValue("TDFORMAT","1");
					retTable3.setValue("TDLINE",tmpstr3);
				}
			}
		}

		
		//以下为子表数据
		String bsql = "select salno,num,shipm,specneed from uf_dmsd_deldetail where requestid='"+requestid+"'";
		List blist = baseJdbc.executeSqlForList(bsql);
		if(blist.size()>0)
		{
			for(int k=0;k<blist.size();k++)
			{
				int tmpk = k+1;
				Map bmap = (Map)blist.get(k);
				String salno = StringHelper.null2String(bmap.get("salno"));
				String item = StringHelper.null2String(bmap.get("num"));
				String shipm = StringHelper.null2String(bmap.get("shipm"));
				String spec = StringHelper.null2String(bmap.get("specneed"));
				
				JCoTable retTable6 = function.getTableParameterList().getTable("ITEM");
				retTable6.appendRow();
				retTable6.setValue("ZZTELNO",telno);
				retTable6.setValue("ZZNO",String.valueOf(tmpk));
				retTable6.setValue("ZZSALNO",salno);
				retTable6.setValue("ZZNUM",item);
				
				
				//Shipping Mark
				if(!shipm.equals(""))
				{
					if(shipm.indexOf("\n")!=-1)//存在回车符
					{
						//System.out.println("shipm has  enter!");
						String[] arrlist4 = shipm.split("\n");
						for(int a4=0;a4<arrlist4.length;a4++)
						{
							String tmpstr4 = "";
							int tmpa4 = a4+1;
							int len4 = arrlist4[a4].length();
							int row4 = 0;//行数
							if(len4%132==0)
							{
								//System.out.println("shipm...1");
								row4 = len4/132;
								for(int j7=0;j7<row4;j7++)
								{
									tmpstr4 = tmpstr4 + arrlist4[a4].substring(j7*132,(j7+1)*132) + "^";
								}
								tmpstr4 = tmpstr4.substring(0,tmpstr4.length());
							}
							else
							{
								//System.out.println("shipm...2");
								row4 = len4/132;
								if(row4==0)
								{
									tmpstr4 = arrlist4[a4];
								}
								else
								{
									for(int j8=0;j8<row4;j8++)
									{
										tmpstr4 = tmpstr4 + arrlist4[a4].substring(j8*132,(j8+1)*132) + "^";
									}
									tmpstr4 = tmpstr4 + arrlist4[a4].substring(row4*132,len4);
								}
							}
							JCoTable retTable4 = function.getTableParameterList().getTable("SHIPM");
							if(tmpstr4.indexOf("^")!=-1)
							{
								//System.out.println("shipm...3");
								String[] array4 = tmpstr4.split("\\^");
								for(int e=0;e<array4.length;e++)
								{
									//if(array4[e].endsWith("\n")==true)//判断字符串最后一位是否为回车符,若是则去掉
									//{
										//array4[e] = array4[e].substring(0,array4[e].length()-1);
									//}
									array4[e] = array4[e].replace("\n","");//去掉字符串中所有的回车符
									array4[e] = array4[e].replace("\r","");//去掉字符串中所有的换行符
									retTable4.appendRow();
									if(e==0)
									{
										retTable4.setValue("TDFORMAT",String.valueOf(tmpa4));//当前行
										retTable4.setValue("TDLINE",array4[e]);//当前行内容
									}
									else
									{
										retTable4.setValue("TDFORMAT","");//当前行
										retTable4.setValue("TDLINE",array4[e]);//当前行内容
									}
								}
							}
							else
							{
								//System.out.println("shipm...4");
								//if(tmpstr4.endsWith("\n")==true)//判断字符串最后一位是否为回车符,若是则去掉
								//{
									//tmpstr4 = tmpstr4.substring(0,tmpstr4.length()-1);
								//}
								tmpstr4 = tmpstr4.replace("\n","");//去掉字符串中所有的回车符
								tmpstr4 = tmpstr4.replace("\r","");//去掉字符串中所有的换行符
								retTable4.appendRow();
								retTable4.setValue("TDFORMAT",String.valueOf(tmpa4));
								retTable4.setValue("TDLINE",tmpstr4);
							}
						}
					}
					else
					{
						//System.out.println("shipm has not enter!");
						String tmpstr4 = "";
						int len4 = shipm.length();
						int row4 = 0;//行数
						if(len4%132==0)
						{
							//System.out.println("shipm...5");
							row4 = len4/132;
							for(int j7=0;j7<row4;j7++)
							{
								tmpstr4 = tmpstr4 + shipm.substring(j7*132,(j7+1)*132) + "^";
							}
							tmpstr4 = tmpstr4.substring(0,tmpstr4.length());
						}
						else
						{
							//System.out.println("shipm...6");
							row4 = len4/132;
							if(row4==0)
							{
								tmpstr4 = shipm;
							}
							else
							{
								for(int j8=0;j8<row4;j8++)
								{
									tmpstr4 = tmpstr4 + shipm.substring(j8*132,(j8+1)*132) + "^";
								}
								tmpstr4 = tmpstr4 + shipm.substring(row4*132,len4);
							}
						}
						JCoTable retTable4 = function.getTableParameterList().getTable("SHIPM");
						if(tmpstr4.indexOf("^")!=-1)
						{
							//System.out.println("shipm...7");
							String[] array4 = tmpstr4.split("\\^");
							for(int e=0;e<array4.length;e++)
							{
								//if(array4[e].endsWith("\n")==true)//判断字符串最后一位是否为回车符,若是则去掉
								//{
									//array4[e] = array4[e].substring(0,array4[e].length()-1);
								//}
								array4[e] = array4[e].replace("\n","");//去掉字符串中所有的回车符
								array4[e] = array4[e].replace("\r","");//去掉字符串中所有的换行符
								retTable4.appendRow();
								if(e==0)
								{
									retTable4.setValue("TDFORMAT","1");//当前行
									retTable4.setValue("TDLINE",array4[e]);//当前行内容
								}
								else
								{
									retTable4.setValue("TDFORMAT","");//当前行
									retTable4.setValue("TDLINE",array4[e]);//当前行内容
								}
							}
						}
						else
						{
							//System.out.println("shipm...8");
							//if(tmpstr4.endsWith("\n")==true)//判断字符串最后一位是否为回车符,若是则去掉
							//{
								//tmpstr4 = tmpstr4.substring(0,tmpstr4.length()-1);
							//}
							tmpstr4 = tmpstr4.replace("\n","");//去掉字符串中所有的回车符
							tmpstr4 = tmpstr4.replace("\r","");//去掉字符串中所有的换行符
							retTable4.appendRow();
							retTable4.setValue("TDFORMAT","1");
							retTable4.setValue("TDLINE",tmpstr4);
						}
					}
				}
				
				
				//特殊需求
				//Special Needs
				if(!spec.equals(""))
				{
					if(spec.indexOf("\n")!=-1)//存在回车符
					{
						//System.out.println("spec has enter!");
						String[] arrlist5 = spec.split("\n");
						for(int a5=0;a5<arrlist5.length;a5++)
						{
							String tmpstr5 = "";
							int tmpa5 = a5+1;
							int len5 = arrlist5[a5].length();
							int row5 = 0;//行数
							if(len5%132==0)
							{
								//System.out.println("spec...1");
								row5 = len5/132;
								for(int j9=0;j9<row5;j9++)
								{
									tmpstr5 = tmpstr5 + arrlist5[a5].substring(j9*132,(j9+1)*132) + "^";
								}
								tmpstr5 = tmpstr5.substring(0,tmpstr5.length());
							}
							else
							{
								//System.out.println("spec...2");
								row5 = len5/132;
								if(row5==0)
								{
									tmpstr5 = arrlist5[a5];
								}
								else
								{
									for(int j10=0;j10<row5;j10++)
									{
										tmpstr5 = tmpstr5 + arrlist5[a5].substring(j10*132,(j10+1)*132) + "^";
									}
									tmpstr5 = tmpstr5 + arrlist5[a5].substring(row5*132,len5);
								}
							}
							JCoTable retTable5 = function.getTableParameterList().getTable("SPECNEED");
							if(tmpstr5.indexOf("^")!=-1)
							{
								//System.out.println("spec...3");
								String[] array5 = tmpstr5.split("\\^");
								for(int f=0;f<array5.length;f++)
								{
									//if(array5[f].endsWith("\n")==true)//判断字符串最后一位是否为回车符,若是则去掉
									//{
										//array5[f] = array5[f].substring(0,array5[f].length()-1);
									//}
									array5[f] = array5[f].replace("\n","");//去掉字符串中所有的回车符
									array5[f] = array5[f].replace("\r","");//去掉字符串中所有的换行符
									retTable5.appendRow();
									if(f==0)
									{
										retTable5.setValue("TDFORMAT",String.valueOf(tmpa5));//当前行
										retTable5.setValue("TDLINE",array5[f]);//当前行内容
									}
									else
									{
										retTable5.setValue("TDFORMAT","");//当前行
										retTable5.setValue("TDLINE",array5[f]);//当前行内容
									}
								}
							}
							else
							{
								//System.out.println("spec...4");
								//if(tmpstr5.endsWith("\n")==true)//判断字符串最后一位是否为回车符,若是则去掉
								//{
									//tmpstr5 = tmpstr5.substring(0,tmpstr5.length()-1);
								//}
								tmpstr5 = tmpstr5.replace("\n","");//去掉字符串中所有的回车符
								tmpstr5 = tmpstr5.replace("\r","");//去掉字符串中所有的换行符
								retTable5.appendRow();
								retTable5.setValue("TDFORMAT",String.valueOf(tmpa5));
								retTable5.setValue("TDLINE",tmpstr5);
							}
						}
					}
					else
					{
						//System.out.println("spec has not enter!");
						String tmpstr5 = "";
						int len5 = spec.length();
						int row5 = 0;//行数
						if(len5%132==0)
						{
							//System.out.println("spec...5");
							row5 = len5/132;
							for(int j9=0;j9<row5;j9++)
							{
								tmpstr5 = tmpstr5 + spec.substring(j9*132,(j9+1)*132) + "^";
							}
							tmpstr5 = tmpstr5.substring(0,tmpstr5.length());
						}
						else
						{
							//System.out.println("spec...6");
							row5 = len5/132;
							if(row5==0)
							{
								tmpstr5 = spec;
							}
							else
							{
								for(int j10=0;j10<row5;j10++)
								{
									tmpstr5 = tmpstr5 + spec.substring(j10*132,(j10+1)*132) + "^";
								}
								tmpstr5 = tmpstr5 + spec.substring(row5*132,len5);
							}
						}
						JCoTable retTable5 = function.getTableParameterList().getTable("SPECNEED");
						if(tmpstr5.indexOf("^")!=-1)
						{
							//System.out.println("spec...7");
							String[] array5 = tmpstr5.split("\\^");
							for(int f=0;f<array5.length;f++)
							{
								//if(array5[f].endsWith("\n")==true)//判断字符串最后一位是否为回车符,若是则去掉
								//{
									//array5[f] = array5[f].substring(0,array5[f].length()-1);
								//}
								array5[f] = array5[f].replace("\n","");//去掉字符串中所有的回车符
								array5[f] = array5[f].replace("\r","");//去掉字符串中所有的换行符
								retTable5.appendRow();
								if(f==0)
								{
									retTable5.setValue("TDFORMAT","1");//当前行
									retTable5.setValue("TDLINE",array5[f]);//当前行内容
								}
								else
								{
									retTable5.setValue("TDFORMAT","");//当前行
									retTable5.setValue("TDLINE",array5[f]);//当前行内容
								}
							}
						}
						else
						{
							//System.out.println("spec...8");
							//if(tmpstr5.endsWith("\n")==true)//判断字符串最后一位是否为回车符,若是则去掉
							//{
								//tmpstr5 = tmpstr5.substring(0,tmpstr5.length()-1);
							//}
							tmpstr5 = tmpstr5.replace("\n","");//去掉字符串中所有的回车符
							tmpstr5 = tmpstr5.replace("\r","");//去掉字符串中所有的换行符
							retTable5.appendRow();
							retTable5.setValue("TDFORMAT","1");
							retTable5.setValue("TDLINE",tmpstr5);
						}
					}
				}
			}
		}


		try {
			function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
		} catch (JCoException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}


		JSONObject jo = new JSONObject();		
		jo.put("res", "true");
		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();
%>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  