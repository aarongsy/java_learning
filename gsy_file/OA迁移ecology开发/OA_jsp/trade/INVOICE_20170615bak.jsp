<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE>
<html>
<%@ include file="/base/init.jsp"%>
<%@ include file="/app/base/init.jsp"%>
<%@ page import="java.util.*,java.text.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.DataService"%>
<head>
<style type="text/css">
<!--
.STYLE1 {
	font-family: "微软雅黑";
	font-size: 32px;
	font-weight: bold;
}
.STYLE2 {font-family: "微软雅黑";font-size: 22px;}
.STYLE3 {font-family: "微软雅黑";font-size: 14px;}
.STYLE6 {font-family: "微软雅黑"; font-size: 24px; }
.STYLE8 {
	font-family: "微软雅黑";
	font-size: 26px;
	font-weight: bold;
}
.STYLE11 {font-family: "微软雅黑"; font-weight: bold; font-size: 18px;}
body {
	margin-left: 30px;
	margin-right: 30px;
}
.STYLE13 {
	font-family: "微软雅黑";
	font-size: 22px;
	font-weight: bold;
}
.STYLE14 {
	font-size: 18px;
	font-weight: bold;
}
table tr td{line-height: 40px;}
-->
</style>
</head>
<body>
<%! 
String[] to_19 = { "ZERO", "ONE", "TWO", "THREE", "FOUR", "FIVE","SIX", "SEVEN", "EIGHT", "NINE", "TEN", "ELEVEN", "TWELVE","THIRTEEN", "FOURTEEN", "FIFTEEN", "SIXTEEN", "SEVENTEEN","EIGHTEEN", "NINETEEN" };
String[] tens = { "TWENTY", "THIRTY", "FORTY", "FIFTY", "SIXTY","SEVENTY", "EIGHTY", "NINETY" };
String[] denom = { "", "THOUSAND", "MILLION", "BILLION", "TRILLION",
			"QUADRILLION", "QUINTILLION", "SEXTILLION", "SEPTILLION",
			"OCTILLION", "NONILLION", "DECILLION", "UNDECILLION",
			"DUODECILLION", "TREDECILLION", "QUATTUORDECILLION",
			"SEXDECILLION", "SEPTENDECILLION", "OCTODECILLION",
			"NOVEMDECILLION", "VIGINTILLION" };
/***
 * 方法应用为将传过来的金额计算为大写英文字母表示 例：系统要求将965.59转换为英文字母表示 调用后输出： NINE HUNDRED AND
 * SIXTY-FIVE POINT FIVE NINE ONLY author wangning time 2013年3月14日 11:18:59
 * 
 */
public String DataToMoney(String data) throws Exception {
	String fin = "";
	try{
		String first = "";
		String poin_first = "";
		String poin_second = "";
		String datah = data + "";
		String datas[] = datah.split("\\.");
		int c = Integer.valueOf(datas[0]);
		first = english_number(c);
		if(datas.length > 1){
			if(Integer.valueOf(datas[1]) > 0){
				System.out.println("datas[1]:"+datas[1]);
				int[] y = new int[datas[1].length()];
				System.out.println("datas[1].length():"+datas[1].length());
				for (int x = 0; x < datas[1].length(); x++) {
					y[x] = Integer.valueOf(datas[1].substring(x, x + 1));
					System.out.println("y["+x+"]="+Integer.valueOf(datas[1].substring(x, x + 1)));
				}
				poin_first = english_number(y[0]);
				if(datas[1].length()>1)
				{
					poin_second = english_number(y[1]);
				}
				else
				{
					poin_second="";
				}
				
				fin = first + " POINT " + poin_first + " " + poin_second;
			}else{
				fin = first;
			}
		}
	}catch(Exception e){
		System.out.println("外销联络单INVOICE打印布局数字金额转换为英文数字时出错："+e);
	}
	return fin;
}

private String convert_nn(int val) throws Exception {
	if (val < 20)
		return to_19[val];
	int flag = val / 10 - 2;
	if (val % 10 != 0)
		return tens[flag] + "-" + to_19[val % 10];
	else
		return tens[flag];
}

private String convert_nnn(int val) throws Exception {
	String word = "";
	int rem = val / 100;
	double remt = Double.valueOf(val) / 100;
	String br = remt + "";
	String ee[] = br.split("\\.");
	int brd = Integer.valueOf(ee[1]);
	int mod = val % 100;
	if (rem > 0) {
		if (brd == 0) {
			word = to_19[rem] + " HUNDRED ";
			if (mod > 0) {
				word = word + " ";
			}
		} else {
			word = to_19[rem] + " HUNDRED AND ";
			if (mod > 0) {
				word = word + " ";
			}
		}
	}
	if (mod > 0) {
		word = word + convert_nn(mod);
	}
	return word;
}

public String english_number(int val) throws Exception {

	if (val < 100) {
		return convert_nn(val);
	}
	if (val < 1000) {
		return convert_nnn(val);
	}
	for (int v = 0; v < denom.length; v++) {
		int didx = v - 1;
		int dval = new Double(Math.pow(1000, v)).intValue();
		if (dval > val) {
			int mod = new Double(Math.pow(1000, didx)).intValue();
			int l = val / mod;
			int r = val - (l * mod);
			String ret = convert_nnn(l) + " " + denom[didx];
			if (r > 0) {
				ret = ret + " " + english_number(r);
			}
			return ret;
		}
	}
	throw new Exception(
			"Should never get here, bottomed out in english_number");
}
 %>
<%
//根据requestid来获取外销联络单相关数据
BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
DataService ds = new DataService();
String requestid=StringHelper.null2String(request.getParameter("requestid"));
String sql = "select u1.*,u2.describe describe1,u3.describe describe2,u4.pcategory,u1.cocode,u1.boxtype from uf_tr_expboxmain u1 left join uf_tr_gkwhd u2 on u1.departure = u2.requestid left join uf_tr_gkwhd u3 on u1.destport = u3.requestid left join uf_tr_prodcate u4 on u4.requestid = u1.goodsgroup where u1.requestid = '"+requestid+"'";
List list = baseJdbcDao.getJdbcTemplate().queryForList(sql);
String expno = "";
String reqdate = "";
String soldname = "";
String soldaddr = "";
String linkphone = "";
String linkfax = "";
String shipping = "";
String vessel = "";
String vesselno = "";
String departure = "";
String destport = "";
String saildate = "";
String goodsgroup = "";
String icon1text = "";
String icon2text = "";
String currency = "";
String str1 = "";
String str2 = "";
String tel1 = "";
String fax1 = "";
String cocode = "";
String boxtype = "";
String ordertypedes = "";	
String netpricesum = "";
String custvalamount = "";
if (list.size() > 0) {
	Map map001 = (Map) list.get(0);
	expno = StringHelper.null2String(map001.get("expno"));//出口编号
	reqdate = StringHelper.null2String(map001.get("reqdate"));//经办日期
	soldname = StringHelper.null2String(map001.get("soldname"));//售达方名称
	soldaddr = StringHelper.null2String(map001.get("soldaddr"));//售达方地址
	linkphone = StringHelper.null2String(map001.get("linkphone"));//收货人电话
	linkfax = StringHelper.null2String(map001.get("linkfax"));//收货人传真
	shipping = StringHelper.null2String(map001.get("shipping"));//shipping marks
	if ("".equals(shipping)) {
		shipping = "N/M";
	}
	vessel = StringHelper.null2String(map001.get("vessel"));//船名
	vesselno = StringHelper.null2String(map001.get("vesselno"));//航次
	departure = StringHelper.null2String(map001.get("describe1"));//起运港
	destport = StringHelper.null2String(map001.get("describe2"));//目的港
	saildate = StringHelper.null2String(map001.get("saildate"));//实际开航日
	goodsgroup = StringHelper.null2String(map001.get("pcategory"));//产品大类
	icon1text = StringHelper.null2String(map001.get("icon1text"));//国贸条件1
	icon2text = StringHelper.null2String(map001.get("icon2text"));//国贸条件2
	cocode = StringHelper.null2String(map001.get("cocode"));//公司代码
	currency = StringHelper.null2String(map001.get("currency"));//币种
	boxtype = StringHelper.null2String(map001.get("boxtype"));//整箱拼箱
	ordertypedes = StringHelper.null2String(map001.get("ordertypedes"));//订单类型描述
	netpricesum = StringHelper.null2String(map001.get("netpricesum"));//净价值合计
	custvalamount = StringHelper.null2String(map001.get("custvalamount"));//报关总金额
	if(cocode.equals("1010")){
		str1 = "CHANG CHUN CHEMICAL (JIANGSU) CO.,LTD.";
		str2 = "Changchun Rd,Riverside Industrial Park,Changshu Econnmic Development Zone,"+"<BR>"+"Jiangsu Province,China 215537";
		tel1 = "86-512-52648000";
		fax1 = "86-512-52645556";
	}else if(cocode.equals("1030")){
		str1 = "ADEKA FINE CHEMICAL (CHANGSHU) CO.,LTD.";
		str2 = "Changchun Rd.,Riverside Industrial Park,Changshu Economic Development Zone,"+"<BR>"+"Jiangsu P.C.:215537";
		tel1 = "0512-52648000";
		fax1 = "0512-52649000";
	}else if(cocode.equals("1020")){
		str1 = "CHANG CHUN SB (CHANGSHU) CO.,LTD.";
		str2 = "Changchun Rd.,Riverside Industrial Park,Changshu Economic Development Zone,"+"<BR>"+"Jiangsu P.C.:215537";
		tel1 = "0512-52648000";
		fax1 = "0512-52649000";
	}else if(cocode.equals("1050")){
		str1 = "CHANG CHUN TOK (CHANGSHU) CO.,LTD.";
		str2 = "Changchun Rd.,Riverside Industrial Park,Changshu Economic Development Zone,"+"<BR>"+"Jiangsu P.C.:215537";
		tel1 = "0512-52648000";
		fax1 = "0512-52649000";
	}else if(cocode.equals("1060")){
		str1 = "U-PICA RESIN (CHANGSHU) CO.,LTD.";
		str2 = "Changchun Rd.,Riverside Industrial Park,Changshu Economic Development Zone,"+"<BR>"+"Jiangsu P.C.:215537";
		tel1 = "86-512-52648000";
		fax1 = "86-512-52642268";
	}else if(cocode.equals("2010")){
		str1 = "CHANG CHUN CHEMICAL (PANJIN) CO.,LTD.";
		str2 = "LiaoBin Coastal Economic Zoon,PanJin, Liaoning Province，China P.C.:124211";
		tel1 = "86-427-6775001";
		fax1 = "86-427-6775012";
	}else if(cocode.equals("7010")){
		str1 = "DAIREN CHEMICAL (JIANGSU) CO., LTD.";
		str2 = "No.1,Dalian Road. Yangzhou Chemical Industry Park, 211900"+"<BR>"+"Yizheng,Jiangsu, China";
		tel1 = "002-86-514-83268888";
		fax1 = "002-86-514-83298833";
	}
	
}
 %>
<object ID='WebBrowser' WIDTH=0 HEIGHT=0 CLASSID='CLSID:8856F961-340A-11D0-A96B-00C04FD705A2'></object> 
<table width="100%%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td colspan="6"><input id="print" type="button" value="打印" onclick="print();" /><input id="printforview" type="button" value="打印预览" onclick="printforview();" /></td>
    <td colspan="2" align="left"><span align="center" class="STYLE3"><font style="line-height:1.5;">编号：CQCB07517MK<BR>版本：1.0</font></span></td>
  </tr>
  <!--tr>
    <td colspan="5">&nbsp;</td>
    <td colspan="3" align="center"><span align="left" class="STYLE3">版本：1.0</span></td>
  </tr-->
  <tr>
    <td colspan="8" align="center"><span class="STYLE1"><%=str1 %></span></td>
  </tr>
  <tr>
    <td colspan="8" align="center"><span class="STYLE2"><%=str2 %></span></td>
  </tr>
  <tr>
    <td width="14%" align="right"><span class="STYLE6">TEL:</span></td>
    <td colspan="3" align="left"><span class="STYLE6"><%=tel1 %></span></td>
    <td colspan="1">&nbsp;</td>
    <td colspan="3" align="center"><span class="STYLE6">FAX:&nbsp;<%=fax1 %></span></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td width="13%">&nbsp;</td>
    <td width="17%">&nbsp;</td>
    <td colspan="2">&nbsp;</td>
    <td>&nbsp;</td>
    <td width="9%">&nbsp;</td>
    <td width="18%">&nbsp;</td>
  </tr>
  <tr>
    <!--td>&nbsp;</td>
    <td>&nbsp;</td-->
    <td colspan="8" align="center"><span class="STYLE8"><u>INVOICE</u> </span></td>
    <!--td>&nbsp;</td>
    <td>&nbsp;</td-->
  </tr>
    <tr>
    <td colspan="8" width="100px"></td>
  </tr>
  <tr>
    <td colspan="3" align="left"><span class="STYLE13">INVOICE NO.: </span>&nbsp;<span class="STYLE2"><%=expno %></span></td>
    <td colspan="2"></td>
    <!--td>&nbsp;</td-->
    <td colspan="3" align="right"><span class="STYLE13">DATE:</span>&nbsp;<span class="STYLE2"><%=reqdate %></span></td>
  </tr>
  <tr>
    <td colspan="4" align="left"><span class="STYLE13">CONSIGNED TO: </span> <span class="STYLE2">&nbsp;</span></td>
    <td colspan="4" align="left"><span class="STYLE13">SHIPPING MARKS&amp;NOS:</span></td>
  </tr>
  <tr>
    <td colspan="4" align="left" valign="top"><textarea class="input_txt" index="1" style="overflow-y:visible;width:600px;border: 0px;border-bottom: 1px solid;font-size:22px;font-family:微软雅黑;"><%=soldname %>  <%=soldaddr %></textarea></td>
    <td colspan="4" align="left" valign="top"><textarea class="input_txt" index="2" style="overflow-y:visible;width:500px;border: 0px;border-bottom: 1px solid;font-size:22px;font-family:微软雅黑;"><%=shipping %></textarea></td>
  </tr>
  <tr>
    <td colspan="8" align="left"><span class="STYLE13">TEL:&nbsp;</span><input class="input_txt" index="3" style="width:300px;border: 0px;border-bottom: 1px solid;font-size:22px;font-family:微软雅黑;" type="text" value="<%=linkphone %>"/></td>
  </tr>
  <tr>
    <td colspan="8" align="left"><span class="STYLE13">FAX:</span>&nbsp;<input class="input_txt" index="4" style="width:300px;border: 0px;border-bottom: 1px solid;font-size:22px;font-family:微软雅黑;" type="text" value="<%=linkfax %>"/></td>
  </tr>
  <tr>
    <td colspan="8" align="left"><span class="STYLE13">SHIPPED PER S.S: </span>&nbsp;<span class="STYLE2"><%=vessel %>&nbsp;&nbsp;<%=vesselno %></span></td>
  </tr>
  <tr>
    <td colspan="8" align="left"><span class="STYLE13">FROM:&nbsp;</span><input class="input_txt" index="5" style="width:500px;border: 0px;border-bottom: 1px solid;font-size:22px;font-family:微软雅黑;" type="text" value="<%=departure %>"/></td>
  </tr>
  <tr>
    <td colspan="8" align="left"><span class="STYLE13">TO:</span>&nbsp;<input class="input_txt" index="6" style="width:600px;border: 0px;border-bottom: 1px solid;font-size:22px;font-family:微软雅黑;" type="text" value="<%=destport %>"/></td>
  </tr>
  <tr>
    <td colspan="8" align="left"><span class="STYLE13">SAILING ON/ABOUT: </span>&nbsp;<span class="STYLE2"><%=saildate %></span></td>
  </tr>
  <tr>
    <td colspan="3" align="left" style="border-bottom:inset 2px #000000;border-top:inset 2px #000000;"><span class="STYLE13">DESCRIPTION</span></td>
    <td colspan="2" align="center" style="border-bottom:inset 2px #000000;border-top:inset 2px #000000;"><span class="STYLE13">QUANTITY</span></td>
    <td colspan="2" align="center" style="border-bottom:inset 2px #000000;border-top:inset 2px #000000;"><span class="STYLE13">UNIT&nbsp;&nbsp;PRICE</span></td>
    <td align="left" style="border-bottom:inset 2px #000000;border-top:inset 2px #000000;"><span class="STYLE13">AMOUNT</span></td>
  </tr>
  <tr><!-- 产品大类 -->
    <td colspan="5" align="left"><input class="input_txt" index="6" style="width:700px;border: 0px;border-bottom: 1px solid;font-size:22px;font-family:微软雅黑;" type="text" value="<%=goodsgroup %>"/><span class="STYLE2"></span></td>
    <!--td width="8%" align="right"><span class="STYLE2"></span></td-->
    <td colspan="3" align="left"><span class="STYLE2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=icon1text %>&nbsp;<%=icon2text %></span></td>
  </tr>
  <%
  String shipsql = "select distinct b.ccgjrate,b.ccgjcur,b.currency,b.netprice,b.netvalue from uf_tr_shipment b where b.currency!=NVL(b.ccgjcur,'') and b.ccgjcur is not null and b.requestid='"+requestid+"'";
  List shiplist = baseJdbcDao.getJdbcTemplate().queryForList(shipsql);
  String ccgjcur  = "";
  String rate = "1";
  if( shiplist.size()>0 ) {
	Map shipmap001 = (Map) shiplist.get(0);
	ccgjcur = StringHelper.null2String(shipmap001.get("ccgjcur"));//长春国际币种	
	rate = StringHelper.null2String(shipmap001.get("ccgjrate")); //长春国际币种兑订单币种汇率
	currency = ccgjcur;
  }
  %>  

  <tr><!-- currency 币种 -->
    <td colspan="3" align="left"><span class="STYLE2"></span></td>
    <td colspan="2" align="center"><span class="STYLE2"></span></td>
    <td align="center" colspan="2"><span class="STYLE2"><%=currency %></span></td>
    <td align="left"><span class="STYLE2"><%=currency %></span></td>
  </tr>
  <%
  String sql1 = "select * from uf_tr_declaration where requestid = '"+requestid+"'";
  List list1 = baseJdbcDao.getJdbcTemplate().queryForList(sql1);  
  Double traynums = 0.00;
  Double packsums = 0.00;
  Double quantitys = 0.00;
  Double unitvalues = 0.00; 
  String unit1 = "";
  DecimalFormat df = new DecimalFormat("0.00");
  for (int i = 0;i < list1.size();i++) {
  	Map map001 = (Map) list1.get(i);
	String stockno = StringHelper.null2String(map001.get("stockno"));//物料号
	if(cocode.equals("1010")){
		stockno = stockno.replace("_X", "");
		stockno = stockno.replace("_Y", "");
	}
	String quantity = StringHelper.null2String(map001.get("quantity"));//实际报关数量
	quantitys += NumberHelper.string2Double(quantity);
	String unit = StringHelper.null2String(map001.get("unit"));//基本单位
	unit1 = unit;
	String unitprice = StringHelper.null2String(map001.get("unitprice"));//报关单价
	String unitvalue = StringHelper.null2String(map001.get("unitvalue"));//报关价值
	unitvalues += NumberHelper.string2Double(unitvalue);
	//unitvalues +=NumberHelper.getIntegerValue(StringHelper.null2String(map001.get("unitvalue")));
	traynums += NumberHelper.string2Double(StringHelper.null2String(map001.get("traynum")));
	packsums += NumberHelper.string2Double(StringHelper.null2String(map001.get("packsum")));
  %>  
  <tr>
    <td colspan="3" align="left"><span class="STYLE2"><%=i+1%>)&nbsp;</span><input class="input_txt" index="6" style="width:300px;border: 0px;border-bottom: 1px solid;font-size:21px;font-family:微软雅黑;" type="text" value="<%=stockno %>"/></td>
    <td colspan="2" align="center"><span class="STYLE2"><%=quantity %>&nbsp;<%=unit %></span></td>
    <td colspan="2" align="center"><span class="STYLE2">&nbsp;&nbsp;<%=unitprice %></span></td>
    <td align="left"><span class="STYLE2"><%=unitvalue %></span></td>
  </tr>
  <%
  }
	
	String unitvaluesStr = df.format(unitvalues) + "";
	//System.out.println("unitvaluesStr:"+unitvaluesStr);
	String datas[] = unitvaluesStr.split("\\.");
	String str = "";
	if(datas.length > 1){
		if(Integer.valueOf(datas[1]) > 0){
			str = unitvaluesStr;
		}else{
			str = datas[0];
		}
	}
	String quantitysStr = df.format(quantitys) + "";
	String quantityss[] = quantitysStr.split("\\.");
	String quantitysstr = "";
	if(quantityss.length > 1){
		if(Integer.valueOf(quantityss[1]) > 0){
			quantitysstr = quantitysStr;
		}else{
			quantitysstr = quantityss[0];
		}
	}
  %>
  <tr>
    <td colspan="3" align="left"><span class="STYLE2"></span></td>
    <td colspan="2" align="center"><span class="STYLE2">▬▬▬▬</span></td>
    <td colspan="2" align="center"><span class="STYLE2"><U>PER&nbsp;&nbsp;<%=unit1 %></U></span></td>
    <td align="left"><span class="STYLE2">▬▬▬▬</span></td>
  </tr>
  <tr>
    <td colspan="3" align="left"><span class="STYLE2"></span></td>
    <td colspan="2" align="center"><span class="STYLE2"><%=quantitysstr%>&nbsp;<%=unit1 %></span></td>
    <td align="left"><span class="STYLE2"></span></td>
    <td align="left"><span class="STYLE2"></span></td>
    <td align="left"><span class="STYLE2"><%=str %></span></td>
  </tr>
  <tr>
    <td colspan="8" align="left" style="border-bottom:inset 2px #000000;"></td>
  </tr>
  <%
  
  String voucherno = "";
  String purcherno = "";
  String sql2 = "select voucherno,purcherno from uf_tr_shipment where requestid = '"+requestid+"'";
  List list2 = baseJdbcDao.getJdbcTemplate().queryForList(sql2);
  for(int j = 0;j < list2.size();j++){
  	Map map001 = (Map) list2.get(j);
  	//整箱 40285a90497eab1501498806ac4738c4
  	if(boxtype.equals("40285a90497eab1501498806ac4738c4")){
  		voucherno = StringHelper.null2String(map001.get("voucherno"));//销售订单号
		purcherno = StringHelper.null2String(map001.get("purcherno"));//采购订单编号
		break;
  	}else{
	  	if(list2.size() - j == 1){
			voucherno += StringHelper.null2String(map001.get("voucherno"));//销售订单号
			purcherno += StringHelper.null2String(map001.get("purcherno"));//采购订单编号
	  	}else{
			voucherno += StringHelper.null2String(map001.get("voucherno")) + ",";//销售订单号
			purcherno += StringHelper.null2String(map001.get("purcherno")) + ",";//采购订单编号
	  	}
  	}
  }
  String llshow = "none";
  Double ljfee = 0.00;  
  Double jgfee = 0.00;  
  String ljfeestr = "";
  String jgfeestr = "";
  //DecimalFormat df = new DecimalFormat("0.00");
  if ("来料加工订单(加工费)".equals(ordertypedes) ) {  
		llshow = "block";
		Integer shiprealnumnullcount = Integer.valueOf(ds.getSQLValue("select count(*) hasnum from uf_tr_shipment b where b.requestid='"+requestid+"' and b.realshipnum is null"));		
		if ( shiprealnumnullcount == 0 ) {
			String shipsql2 = "select sum(realshipnum*netprice) netvalue from uf_tr_shipment b where b.requestid='"+requestid+"'";
			List shiplist2 = baseJdbcDao.getJdbcTemplate().queryForList(shipsql2);
			if( shiplist2.size()>0 ) {
				Map shipmap002 = (Map) shiplist2.get(0);
				netpricesum = StringHelper.null2String(shipmap002.get("netvalue"));	//按实际出货数量
			}
		}
		jgfeestr = df.format(NumberHelper.string2Double(netpricesum)/NumberHelper.string2Double(rate));		
		ljfee =  NumberHelper.string2Double(unitvaluesStr)-(NumberHelper.string2Double(jgfeestr)) ;
		ljfeestr = df.format(ljfee);		
  }
   %>
  <tr>
	<td colspan="8"><span class="STYLE13">SAY&nbsp;<%=currency %>:&nbsp;</span><span class="STYLE2"><%=DataToMoney(unitvaluesStr)%></span></td>
  </tr>
  <tr>
    <td colspan="8"><span class="STYLE13">COUNTRY OF ORIGIN:&nbsp;</span><span class="STYLE2">CHINA</span></td>
  </tr>
  <tr style="display:<%=llshow %>">
	 <td colspan="8"><textarea class="input_txt" index="1" style="overflow-y:visible;width:1000px;border: 0px;border-bottom: 1px solid;font-size:22px;font-family:微软雅黑;font-weight: bold;">NO COMMERCLAL VALUE. THE VALUE IS FOR CUSTOM ONLY. </textarea><!--span class="STYLE13">NO COMMERCLAL VALUE. THE VALUE IS FOR CUSTOM ONLY. </span--></td>
  </tr>
  <tr>
    <td colspan="8" valign="bottom"><span class="STYLE13">SAP NO:</span>&nbsp;<textarea class="input_txt" index="1" style="overflow-y:visible;width:1000px;border: 0px;border-bottom: 1px solid;font-size:22px;font-family:微软雅黑;"><%=voucherno %></textarea><!--span class="STYLE2"><%=voucherno %></span--></td>
  </tr>
  <tr>
    <td colspan="8" valign="top"><span class="STYLE13">PO NO:</span>&nbsp;<textarea class="input_txt" index="1" style="overflow-y:visible;width:1000px;border: 0px;border-bottom: 1px solid;font-size:22px;font-family:微软雅黑;"><%=purcherno %></textarea><!--span class="STYLE2"><%=purcherno %></span--></td>
  </tr>
  <tr style="display:<%=llshow %>">
	<!--td colspan="8"><span class="STYLE13">料件费:</span><span class="STYLE2">&nbsp;<%=currency %>&nbsp;<%=ljfeestr %></span></td-->	
	<td colspan="8"><span class="STYLE13">料件费:</span><textarea class="input_txt" index="1" style="overflow-y:visible;width:1000px;border: 0px;border-bottom: 1px solid;font-size:22px;font-family:微软雅黑;">&nbsp;<%=currency %>&nbsp;<%=ljfeestr %></textarea></td>	
  </tr>
   <tr style="display:<%=llshow %>">	
	<!--td colspan="8"><span class="STYLE13">加工费:</span><span class="STYLE2">&nbsp;<%=currency %>&nbsp;<%=jgfeestr %></span></td-->
	<td colspan="8"><span class="STYLE13">加工费:</span><textarea class="input_txt" index="1" style="overflow-y:visible;width:1000px;border: 0px;border-bottom: 1px solid;font-size:22px;font-family:微软雅黑;">&nbsp;<%=currency %>&nbsp;<%=jgfeestr %></textarea></td>
  </tr>
  <tr>
    <td colspan="8" align="left" valign="top"><textarea class="input_txt" index="1" style="overflow-y:visible;width:100%;border: 0px;border-bottom: 1px solid;font-size:22px;font-family:微软雅黑;"></textarea></td>    
  </tr> 
  <tr>
    <td height="80" colspan="2" align="left" style="padding-left:50px;"><span class="STYLE7"></span></td>
  </tr>
  <tr>
    <td colspan="8" align="left" valign="bottom"><SPAN><BR><BR><BR><BR><BR></SPAN><textarea class="input_txt" index="1" style="overflow-y:visible;width:600px;border: 0px;border-bottom: 1px solid;font-size:25px;font-family:微软雅黑;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</textarea></td>    
  </tr>
  <tr>
  	<td colspan="4"></td>
    <td align="left" colspan="4"><span class="STYLE13"><%=str1 %></span></td>
  </tr>
  <tr>
    <td height="30" colspan="8"></td>
  </tr>
  <tr>
  	<td colspan="4"></td>
    <td align="left" colspan="4" style="border-bottom:inset 2px #000000;height:60px;"></td>
  </tr>
  <tr>
  	<td colspan="4"></td>
    <td align="left" colspan="4"><span class="STYLE13">(Authorized Signature)</span></td>
  </tr>
</table>
<script type="text/javascript" src="/app/js/jquery.js"></script>
<script type="text/javascript">
var HKEY_Root,HKEY_Path,HKEY_Key; 
HKEY_Root="HKEY_CURRENT_USER"; 
HKEY_Path="\\Software\\Microsoft\\Internet Explorer\\PageSetup\\"; 
//设置网页打印的页眉页脚为空 
function PageSetup_Null() { 
	try { 
		var Wsh=new ActiveXObject("WScript.Shell"); 
		HKEY_Key="header"; 
		Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,""); 
		HKEY_Key="footer"; 
		Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,""); 
		HKEY_Key="margin_left";
	    Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"0");
	    HKEY_Key="margin_right";
	    Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"0");
	    HKEY_Key="margin_top";
	    Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"0.19");
	    HKEY_Key="margin_bottom";
	    Wsh.RegWrite(HKEY_Root+HKEY_Path+HKEY_Key,"0.19");
	} catch(e) {} 
} 
//打印
function print(){
	hideInput();
	PageSetup_Null();
	//打印
	WebBrowser.ExecWB(6,1);

}
//打印预览
function printforview(){
	hideInput();
	PageSetup_Null();
	//打印
	WebBrowser.ExecWB(7,1);
}
//打印前先将输入框隐藏
function hideInput(){
	jQuery(".input_txt").each(function(){

		var index = jQuery(this).attr("index");
		jQuery(this).css("border","0");
		//隐藏打印按钮和打印预览按钮
		jQuery("#print").css("display","none");
		jQuery("#printforview").css("display","none");
	});

}
//修改时将输入框显示
function showInput(){
	jQuery(".input_txt").each(function(){
		var index = jQuery(this).attr("index");
		jQuery(this).css("border-bottom","1px solid");
		//jQuery("#input_txt"+index).css("display","block");
	});
}
</script>
</body>
</html>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            