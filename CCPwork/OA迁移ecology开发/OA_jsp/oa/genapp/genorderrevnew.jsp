<%@ page contentType="text/html; charset=UTF-8"%>
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

<%
String sql = StringHelper.null2String(request.getParameter("sql"));
String requestid = StringHelper.null2String(request.getParameter("requestid"));
String senddate = StringHelper.null2String(request.getParameter("senddate"));
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
%>
<style type="text/css"> 


tr.tr1{     
    TEXT-INDENT: -1pt; 
    TEXT-ALIGN: left; 
    height: 22px; 
    background-color:#f8f8f0; 
} 
tr.title{ 
	font-size:12px; 
	font-weight:bold;
    TEXT-INDENT: -1pt; 
    TEXT-ALIGN: left; 
    height: 22px; 
    background-color:#f8f8f0; 
} 
tr.hj{     
    TEXT-INDENT: -1pt; 
    TEXT-ALIGN: left; 
    height: 22px; 
    background-color:#e46d0a; 
} 
td.td1{ 
    font-size:12px; 
    PADDING-RIGHT: 4px; 
    PADDING-LEFT: 4px;     
    TEXT-DECORATION: none 

} 
td.td2{ 
	height: 22px;
    font-size:12px; 
    PADDING-RIGHT: 4px; 
    PADDING-LEFT: 4px;     
    TEXT-DECORATION: none; 
    color:#000; 

} 


</style>
<script type='text/javascript' language="javascript" src='/js/main.js'></script>


<!--<div id="warpp" style="height:600px;overflow-y:auto">-->

 <DIV id="warpp">


<TABLE id=oTable40285a90490d16a3014921b08aa03d3e class=detailtable border=1>
<COLGROUP>
<COL width="6%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL width="8%">
<COL style="DISPLAY: none" width="8%"></COLGROUP>
<TBODY>
<TR class=Header>
<TD noWrap><INPUT id=check_node_all onclick="selectAll(this,'40285a90490d16a3014921b08aa03d3e')" value=-1 type=checkbox name=check_node_all>序号</TD>
<TD noWrap>申请单号</TD>
<TD noWrap>申请单行号</TD>
<TD noWrap>预计到货日期</TD>
<TD noWrap>申请人</TD>
<TD noWrap>申请单部门</TD>
<TD noWrap>物品编码</TD>
<TD noWrap>品名</TD>
<TD noWrap>规格</TD>
<TD noWrap>单位</TD>
<TD noWrap>供应商名称</TD>
<TD noWrap>供应商编码</TD>
<TD noWrap>总采购数量</TD>
<TD noWrap>已到货数量</TD>
<TD noWrap>未到货数量</TD>
<TD noWrap>到货数量</TD>
<TD noWrap>差异数量</TD></TR>
<%
 String delsql="delete uf_oa_receivedetail where requestid='"+requestid+"'";
 baseJdbc.update(delsql);
 System.out.println("到货验收------sql: "+sql);
 //,(select objname from humres where id=b.applyer) as applyername,(select objname from orgunit where id=b.dept) as applydept
       List sublist = baseJdbc.executeSqlForList(sql);
	   int num=0;
	   int sizek=sublist.size();
	   if(sublist.size()>=300)
	   {
	   //sizek=300;
	   }
	   else
	   {
	   //sizek=sublist.size();
	   }
	   System.out.println("------------------------------------"+sizek);
       if(sublist.size()>0){
		  for(int k=0;k<sizek;k++){
			  if(num<100)
			  {
				  Map mk = (Map)sublist.get(k);
				  String yjsenddate =StringHelper.null2String(mk.get("yjsenddate"));
				  String no=StringHelper.null2String(mk.get("no"));
				  String appnumber =StringHelper.null2String(mk.get("appnumber"));
				  String goodsno=StringHelper.null2String(mk.get("goodsno"));
				  String goodsname=StringHelper.null2String(mk.get("goodsname"));
				  String goodsid =StringHelper.null2String(mk.get("goodsid"));
				  String specify=StringHelper.null2String(mk.get("specify"));
				  String unit=StringHelper.null2String(mk.get("unit"));
				  String totalnum=StringHelper.null2String(mk.get("totalnum"));
				  String expnum=StringHelper.null2String(mk.get("expnum"));
				  String supplyname =StringHelper.null2String(mk.get("supplyname"));
				  String spna =StringHelper.null2String(mk.get("spna"));
				  String scode =StringHelper.null2String(mk.get("scode"));
				  String applyername =StringHelper.null2String(mk.get("applyername"));
				  String applydept =StringHelper.null2String(mk.get("applydept"));
				  String applyer=StringHelper.null2String(mk.get("applyer"));
				  String dept  =StringHelper.null2String(mk.get("dept"));
				 // System.out.println("appnumber: "+appnumber);
				 // System.out.println("goodsno: "+goodsno);
				 // System.out.println("goodsid: "+goodsid);
				  String receivenum="";
				  int norev=0;
				  List sublist1 =null;
				  Map mk1=null;
    
				String ssql="select nvl(sum(a.receivenum),0) as receivenum from uf_oa_receivedetail a,uf_oa_receiveaccept  t  where a.requestid=t.requestid and  a.goodsno='"+goodsno+"' and a.specify='"+specify+"' and a.unit='"+unit+"'   and a.appnumber='"+appnumber+"' and a.appno='"+no+"' and (a.ispass='40288098276fc2120127704884290210' or a.ispass is null) and 0=(select isdelete from requestbase where id=a.requestid)";                   
                    if(!spna.equals(""))                   
                      {      
                          ssql=ssql+" and a.suppliername= '"+spna+"' ";                   
                       }  
					    //System.out.println("ssql: "+ssql);
				sublist1 = baseJdbc.executeSqlForList(ssql);
				if(sublist1.size()>0)
				{
					mk1 = (Map)sublist1.get(0);
					receivenum=StringHelper.null2String(mk1.get("receivenum"));
				}
				else
				  {
					receivenum="0";
				  }
				  if(totalnum.equals(""))
				  {
					  totalnum="0";
				  }
				  if(receivenum.equals(""))
				  {
					  receivenum="0";
				  }
				  if(expnum.equals(""))
				  {
					  expnum="0";
				  }
				norev=Integer.parseInt(totalnum)-Integer.parseInt(receivenum)+Integer.parseInt(expnum);
				System.out.println("totalnum: "+totalnum);
				System.out.println("receivenum: "+receivenum);
				System.out.println("expnum: "+expnum);
				System.out.println("norev: "+norev);
				if(senddate.equals(""))
				  {
					//System.out.println("sssssssssssssssssssss");
				if(norev>0)
				  {
				    num++; 
					System.out.println(num);
					String insql="insert into uf_oa_receivedetail (id,requestid,no,appnumber,appno,goodsno,goodsname,specify,unit,suppliername,suppliercode,ordernum,allreceive,noreceive,receivenum,expnum,apply,dept,yjsenddate)  values ((select sys_guid() from dual),'"+requestid+"',"+num+",'"+appnumber+"',"+no+",'"+goodsno+"','"+goodsno+"','"+specify+"', '"+unit+"', '"+spna+"' ,'"+scode+"' ,"+totalnum+" , "+receivenum+","+norev+","+norev+","+expnum+",'"+applyer+"','"+dept+"','"+yjsenddate+"')";
					System.out.println(insql);
						 baseJdbc.update(insql);
			                 
                     
		%>
	<TR id=oTR40285a90490d16a3014921b08aa03d3e class=DataLight><!-- 明细表ID，请勿删除。-->
	<TD noWrap><span ><input type="checkbox" name="check_node_40285a90490d16a3014921b08aa03d3e" value="<%=k%>"><input type="hidden" name="<%="detailid_40285a90490d16a3014921b08aa03d3e_"+k%>" value="<%=k%>"></span>
	<input type="hidden" id="<%="field_40285a90490d16a3014921c3bae63f79_"+k%>" name="<%="field_40285a90490d16a3014921c3bae63f79_"+k%>" value="<%=num%>" maxlength=24  ><span style='width: 50%' id="<%="field_40285a90490d16a3014921c3bae63f79_"+k+"span"%>" name="<%="field_40285a90490d16a3014921c3bae63f79_"+k+"span"%>" ><%=num%></span></TD>

	<TD noWrap><input type="hidden" id="<%="field_40285a8d4ce422d6014d046a96642c6f_"+k%>" name="<%="field_40285a8d4ce422d6014d046a96642c6f_"+k%>"  value="<%=appnumber%>"  ><span style='width: 80%' id="<%="field_40285a8d4ce422d6014d046a96642c6f_"+k+"span"%>" name="<%="field_40285a8d4ce422d6014d046a96642c6f_"+k+"span"%>" ><%=appnumber%></span></TD>
	<TD noWrap><input type="hidden" id="<%="field_40285a8d4ce422d6014d046a96982c71_"+k%>" name="<%="field_40285a8d4ce422d6014d046a96982c71_"+k%>" value="<%=no%>" maxlength=24  ><span style='width: 80%' id="<%="field_40285a8d4ce422d6014d046a96982c71_"+k+"span"%>" name="<%="field_40285a8d4ce422d6014d046a96982c71_"+k+"span"%>" ><%=no%></span></TD>

	<TD noWrap><input type="hidden" id="<%="field_yjsenddate_"+k%>" name="<%="field_yjsenddate_"+k%>" value="<%=yjsenddate%>" maxlength=24  ><span style='width: 80%' id="<%="field_yjsenddate_"+k+"span"%>" name="<%="field_yjsenddate_"+k+"span"%>" ><%=yjsenddate%></span></TD>

	<TD noWrap><input type="hidden" id="<%="field_applyername_"+k%>" name="<%="field_applyername_"+k%>" value="<%=applyer%>" maxlength=24  ><span style='width: 80%' id="<%="field_applyername_"+k+"span"%>" name="<%="field_applyername_"+k+"span"%>" ><%=applyername%></span></TD>

	<TD noWrap><input type="hidden" id="<%="field_applydept_"+k%>" name="<%="field_applydept_"+k%>" value="<%=dept%>" maxlength=24  ><span style='width: 80%' id="<%="field_applydept_"+k+"span"%>" name="<%="field_applydept_"+k+"span"%>" ><%=applydept%></span></TD>

	<TD noWrap><input type="hidden" id="<%="field_40285a90490d16a3014921e6bd1242c2_"+k%>" name="<%="field_40285a90490d16a3014921e6bd1242c2_"+k%>" value="<%=goodsno%>" ><span   style='width: 80%' id="<%="field_40285a90490d16a3014921e6bd1242c2_"+k+"span"%>" name="<%="field_40285a90490d16a3014921e6bd1242c2_"+k+"span"%>" ><%=goodsid%></span></TD>
	<TD noWrap><input type="hidden" id="<%="field_40285a90490d16a3014921b4738a3dad_"+k%>" name="<%="field_40285a90490d16a3014921b4738a3dad_"+k%>" value="<%=goodsno%>" ><span   style='width: 80%' id="<%="field_40285a90490d16a3014921b4738a3dad_"+k+"span"%>" name="<%="field_40285a90490d16a3014921b4738a3dad_"+k+"span"%>" ><%=goodsname%></span></TD>
	<TD noWrap><input type="hidden" id="<%="field_40285a90490d16a3014921b473a33daf_"+k%>" name="<%="field_40285a90490d16a3014921b473a33daf_"+k%>"  value="<%=specify%>"  ><span style='width: 80%' id="<%="field_40285a90490d16a3014921b473a33daf_"+k+"span"%>" name="<%="field_40285a90490d16a3014921b473a33daf_"+k+"span"%>" ><%=specify%></span></TD>
	<TD noWrap><input type="hidden" id="<%="field_40285a90490d16a3014921b473c13db1_"+k%>" name="<%="field_40285a90490d16a3014921b473c13db1_"+k%>"  value="<%=unit%>"  ><span style='width: 80%' id="<%="field_40285a90490d16a3014921b473c13db1_"+k+"span"%>" name="<%="field_40285a90490d16a3014921b473c13db1_"+k+"span"%>" ><%=unit%></span></TD>
	<TD noWrap><input type="hidden" id="<%="field_40285a90490d16a3014921b473e23db3_"+k%>" name="<%="field_40285a90490d16a3014921b473e23db3_"+k%>" value="<%=spna%>" ><span   style='width: 80%' id="<%="field_40285a90490d16a3014921b473e23db3_"+k+"span"%>" name="<%="field_40285a90490d16a3014921b473e23db3_"+k+"span"%>" ><%=supplyname%></span></TD>
	<TD noWrap><input type="hidden" id="<%="field_40285a90490d16a3014921b474003db5_"+k%>" name="<%="field_40285a90490d16a3014921b474003db5_"+k%>"  value="<%=scode%>"  ><span style='width: 80%' id="<%="field_40285a90490d16a3014921b474003db5_"+k+"span"%>" name="<%="field_40285a90490d16a3014921b474003db5_"+k+"span"%>" ><%=scode%></span></TD>
	<TD noWrap><input type="hidden" id="<%="field_40285a90490d16a3014921b474193db7_"+k%>" name="<%="field_40285a90490d16a3014921b474193db7_"+k%>" value="<%=totalnum%>" maxlength=24  ><span style='width: 80%' id="<%="field_40285a90490d16a3014921b474193db7_"+k+"span"%>" name="<%="field_40285a90490d16a3014921b474193db7_"+k+"span"%>" ><%=totalnum%></span></TD>
	<TD noWrap><input type="hidden" id="<%="field_40285a8d4b246d79014b2a575f9606f8_"+k%>" name="<%="field_40285a8d4b246d79014b2a575f9606f8_"+k%>" value="<%=receivenum %>" maxlength=24  ><span style='width: 80%' id="<%="field_40285a8d4b246d79014b2a575f9606f8_"+k+"span"%>" name="<%="field_40285a8d4b246d79014b2a575f9606f8_"+k+"span"%>" ><%=receivenum %></span></TD>
	<TD noWrap><input type="hidden" id="<%="field_40285a8d4b246d79014b2a575faa06fa_"+k%>" name="<%="field_40285a8d4b246d79014b2a575faa06fa_"+k%>" value="<%=norev%>" maxlength=24  ><span style='width: 80%' id="<%="field_40285a8d4b246d79014b2a575faa06fa_"+k+"span"%>" name="<%="field_40285a8d4b246d79014b2a575faa06fa_"+k+"span"%>" ><%=norev%></span></TD>
	<TD noWrap><input type="text" class="InputStyle2" maxlength=24 name="<%="field_40285a90490d16a3014921b4742f3db9_0"+k%>"  id="<%="field_40285a90490d16a3014921b4742f3db9_"+k%>" value="<%=norev%>" style='width: 80%' ><span id="<%="field_40285a90490d16a3014921b4742f3db9_"+k+"span"%>" name="<%="field_40285a90490d16a3014921b4742f3db9_"+k+"span"%>" ><img src="/images/base/checkinput.gif" align=absMiddle></span></TD>
	<TD noWrap><input type="text" class="InputStyle2" maxlength=24 name="<%="field_40285a8d4ce422d6014ce4de728e0730_"+k%>"  id="<%="field_40285a8d4ce422d6014ce4de728e0730_"+k%>" value="<%=expnum%>" ></TD></TR>
		<%	
		}
	}
	else
				  {
					 if(norev>0&&senddate.equals(yjsenddate))
					  {
						 num++;
						 String insql="insert into uf_oa_receivedetail (id,requestid,no,appnumber,appno,goodsno,goodsname,specify,unit,suppliername,suppliercode,ordernum,allreceive,noreceive,receivenum,expnum,apply,dept,yjsenddate)  values ((select sys_guid() from dual),'"+requestid+"',"+num+",'"+appnumber+"',"+no+",'"+goodsno+"','"+goodsno+"','"+specify+"', '"+unit+"', '"+spna+"' ,'"+scode+"' ,"+totalnum+" , "+receivenum+","+norev+","+norev+","+expnum+",'"+applyer+"','"+dept+"','"+yjsenddate+"')";
						 System.out.println(insql);
						 baseJdbc.update(insql);
						 %>
	<TR id=oTR40285a90490d16a3014921b08aa03d3e class=DataLight><!-- 明细表ID，请勿删除。-->
	<TD noWrap><span ><input type="checkbox" name="check_node_40285a90490d16a3014921b08aa03d3e" value="<%=k%>"><input type="hidden" name="<%="detailid_40285a90490d16a3014921b08aa03d3e_"+k%>" value="<%=k%>"></span>
	<input type="hidden" id="<%="field_40285a90490d16a3014921c3bae63f79_"+k%>" name="<%="field_40285a90490d16a3014921c3bae63f79_"+k%>" value="<%=num%>" maxlength=24  ><span style='width: 50%' id="<%="field_40285a90490d16a3014921c3bae63f79_"+k+"span"%>" name="<%="field_40285a90490d16a3014921c3bae63f79_"+k+"span"%>" ><%=num%></span></TD>

	<TD noWrap><input type="hidden" id="<%="field_40285a8d4ce422d6014d046a96642c6f_"+k%>" name="<%="field_40285a8d4ce422d6014d046a96642c6f_"+k%>"  value="<%=appnumber%>"  ><span style='width: 80%' id="<%="field_40285a8d4ce422d6014d046a96642c6f_"+k+"span"%>" name="<%="field_40285a8d4ce422d6014d046a96642c6f_"+k+"span"%>" ><%=appnumber%></span></TD>
	<TD noWrap><input type="hidden" id="<%="field_40285a8d4ce422d6014d046a96982c71_"+k%>" name="<%="field_40285a8d4ce422d6014d046a96982c71_"+k%>" value="<%=no%>" maxlength=24  ><span style='width: 80%' id="<%="field_40285a8d4ce422d6014d046a96982c71_"+k+"span"%>" name="<%="field_40285a8d4ce422d6014d046a96982c71_"+k+"span"%>" ><%=no%></span></TD>

	<TD noWrap><input type="hidden" id="<%="field_yjsenddate_"+k%>" name="<%="field_yjsenddate_"+k%>" value="<%=yjsenddate%>" maxlength=24  ><span style='width: 80%' id="<%="field_yjsenddate_"+k+"span"%>" name="<%="field_yjsenddate_"+k+"span"%>" ><%=yjsenddate%></span></TD>

	<TD noWrap><input type="hidden" id="<%="field_applyername_"+k%>" name="<%="field_applyername_"+k%>" value="<%=applyer%>" maxlength=24  ><span style='width: 80%' id="<%="field_applyername_"+k+"span"%>" name="<%="field_applyername_"+k+"span"%>" ><%=applyername%></span></TD>

	<TD noWrap><input type="hidden" id="<%="field_applydept_"+k%>" name="<%="field_applydept_"+k%>" value="<%=dept%>" maxlength=24  ><span style='width: 80%' id="<%="field_applydept_"+k+"span"%>" name="<%="field_applydept_"+k+"span"%>" ><%=applydept%></span></TD>

	<TD noWrap><input type="hidden" id="<%="field_40285a90490d16a3014921e6bd1242c2_"+k%>" name="<%="field_40285a90490d16a3014921e6bd1242c2_"+k%>" value="<%=goodsno%>" ><span   style='width: 80%' id="<%="field_40285a90490d16a3014921e6bd1242c2_"+k+"span"%>" name="<%="field_40285a90490d16a3014921e6bd1242c2_"+k+"span"%>" ><%=goodsid%></span></TD>
	<TD noWrap><input type="hidden" id="<%="field_40285a90490d16a3014921b4738a3dad_"+k%>" name="<%="field_40285a90490d16a3014921b4738a3dad_"+k%>" value="<%=goodsno%>" ><span   style='width: 80%' id="<%="field_40285a90490d16a3014921b4738a3dad_"+k+"span"%>" name="<%="field_40285a90490d16a3014921b4738a3dad_"+k+"span"%>" ><%=goodsname%></span></TD>
	<TD noWrap><input type="hidden" id="<%="field_40285a90490d16a3014921b473a33daf_"+k%>" name="<%="field_40285a90490d16a3014921b473a33daf_"+k%>"  value="<%=specify%>"  ><span style='width: 80%' id="<%="field_40285a90490d16a3014921b473a33daf_"+k+"span"%>" name="<%="field_40285a90490d16a3014921b473a33daf_"+k+"span"%>" ><%=specify%></span></TD>
	<TD noWrap><input type="hidden" id="<%="field_40285a90490d16a3014921b473c13db1_"+k%>" name="<%="field_40285a90490d16a3014921b473c13db1_"+k%>"  value="<%=unit%>"  ><span style='width: 80%' id="<%="field_40285a90490d16a3014921b473c13db1_"+k+"span"%>" name="<%="field_40285a90490d16a3014921b473c13db1_"+k+"span"%>" ><%=unit%></span></TD>
	<TD noWrap><input type="hidden" id="<%="field_40285a90490d16a3014921b473e23db3_"+k%>" name="<%="field_40285a90490d16a3014921b473e23db3_"+k%>" value="<%=spna%>" ><span   style='width: 80%' id="<%="field_40285a90490d16a3014921b473e23db3_"+k+"span"%>" name="<%="field_40285a90490d16a3014921b473e23db3_"+k+"span"%>" ><%=supplyname%></span></TD>
	<TD noWrap><input type="hidden" id="<%="field_40285a90490d16a3014921b474003db5_"+k%>" name="<%="field_40285a90490d16a3014921b474003db5_"+k%>"  value="<%=scode%>"  ><span style='width: 80%' id="<%="field_40285a90490d16a3014921b474003db5_"+k+"span"%>" name="<%="field_40285a90490d16a3014921b474003db5_"+k+"span"%>" ><%=scode%></span></TD>
	<TD noWrap><input type="hidden" id="<%="field_40285a90490d16a3014921b474193db7_"+k%>" name="<%="field_40285a90490d16a3014921b474193db7_"+k%>" value="<%=totalnum%>" maxlength=24  ><span style='width: 80%' id="<%="field_40285a90490d16a3014921b474193db7_"+k+"span"%>" name="<%="field_40285a90490d16a3014921b474193db7_"+k+"span"%>" ><%=totalnum%></span></TD>
	<TD noWrap><input type="hidden" id="<%="field_40285a8d4b246d79014b2a575f9606f8_"+k%>" name="<%="field_40285a8d4b246d79014b2a575f9606f8_"+k%>" value="<%=receivenum %>" maxlength=24  ><span style='width: 80%' id="<%="field_40285a8d4b246d79014b2a575f9606f8_"+k+"span"%>" name="<%="field_40285a8d4b246d79014b2a575f9606f8_"+k+"span"%>" ><%=receivenum %></span></TD>
	<TD noWrap><input type="hidden" id="<%="field_40285a8d4b246d79014b2a575faa06fa_"+k%>" name="<%="field_40285a8d4b246d79014b2a575faa06fa_"+k%>" value="<%=norev%>" maxlength=24  ><span style='width: 80%' id="<%="field_40285a8d4b246d79014b2a575faa06fa_"+k+"span"%>" name="<%="field_40285a8d4b246d79014b2a575faa06fa_"+k+"span"%>" ><%=norev%></span></TD>
	<TD noWrap><input type="text" class="InputStyle2" maxlength=24 name="<%="field_40285a90490d16a3014921b4742f3db9_0"+k%>"  id="<%="field_40285a90490d16a3014921b4742f3db9_"+k%>" value="<%=norev%>" style='width: 80%' ><span id="<%="field_40285a90490d16a3014921b4742f3db9_"+k+"span"%>" name="<%="field_40285a90490d16a3014921b4742f3db9_"+k+"span"%>" ><img src="/images/base/checkinput.gif" align=absMiddle></span></TD>
	<TD noWrap><input type="text" class="InputStyle2" maxlength=24 name="<%="field_40285a8d4ce422d6014ce4de728e0730_"+k%>"  id="<%="field_40285a8d4ce422d6014ce4de728e0730_"+k%>" value="<%=expnum%>" ></TD></TR>
						 <%
					  }
				  }
				  }
				  else
				  {
					  break;
				  }
			  }
}else{%> 
	<TR id=oTR40285a90490d16a3014921b08aa03d3e class=DataLight><!-- 明细表ID，请勿删除。-->
	<TD noWrap><span ><input type="checkbox" name="check_node_40285a90490d16a3014921b08aa03d3e" value="0"><input type="hidden" name="detailid_40285a90490d16a3014921b08aa03d3e_0" value=""></span><input type="hidden" id="field_40285a90490d16a3014921c3bae63f79_0" name="field_40285a90490d16a3014921c3bae63f79_0" value="" maxlength=24  ><span style='width: 50%' id="field_40285a90490d16a3014921c3bae63f79_0span" name="field_40285a90490d16a3014921c3bae63f79_0span" ></span></TD>
	<TD noWrap><input type="hidden" id="field_40285a8d4ce422d6014d046a96642c6f_0" name="field_40285a8d4ce422d6014d046a96642c6f_0"  value=""  ><span style='width: 80%' id="field_40285a8d4ce422d6014d046a96642c6f_0span" name="field_40285a8d4ce422d6014d046a96642c6f_0span" ></span></TD>
	<TD noWrap><input type="hidden" id="field_40285a8d4ce422d6014d046a96982c71_0" name="field_40285a8d4ce422d6014d046a96982c71_0" value="" maxlength=24  ><span style='width: 80%' id="field_40285a8d4ce422d6014d046a96982c71_0span" name="field_40285a8d4ce422d6014d046a96982c71_0span" ></span></TD>
					<TD noWrap><input type="hidden" id="field_yjsenddate_0" name="field_yjsenddate_0" value="" maxlength=24  ><span style='width: 80%' id="field_yjsenddate_0span" name="field_yjsenddate_0span" ></span></TD>
	<TD noWrap><input type="hidden" id="field_applyername_0" name="field_applyername_0" value="" maxlength=24  ><span style='width: 80%' id="field_applyername_0span" name="field_applyername_0span" ></span></TD>

		<TD noWrap><input type="hidden" id="field_applydept_0" name="field_applydept_0" value="" maxlength=24  ><span style='width: 80%' id="field_applydept_0span" name="field_applydept_0span" ></span></TD>
	<TD noWrap><input type="hidden" id="field_40285a90490d16a3014921e6bd1242c2_0" name="field_40285a90490d16a3014921e6bd1242c2_0" value="" ><span   style='width: 80%' id="field_40285a90490d16a3014921e6bd1242c2_0span" name="field_40285a90490d16a3014921e6bd1242c2_0span" ></span></TD>
	<TD noWrap><input type="hidden" id="field_40285a90490d16a3014921b4738a3dad_0" name="field_40285a90490d16a3014921b4738a3dad_0" value="" ><span   style='width: 80%' id="field_40285a90490d16a3014921b4738a3dad_0span" name="field_40285a90490d16a3014921b4738a3dad_0span" ></span></TD>
	<TD noWrap><input type="hidden" id="field_40285a90490d16a3014921b473a33daf_0" name="field_40285a90490d16a3014921b473a33daf_0"  value=""  ><span style='width: 80%' id="field_40285a90490d16a3014921b473a33daf_0span" name="field_40285a90490d16a3014921b473a33daf_0span" ></span></TD>
	<TD noWrap><input type="hidden" id="field_40285a90490d16a3014921b473c13db1_0" name="field_40285a90490d16a3014921b473c13db1_0"  value=""  ><span style='width: 80%' id="field_40285a90490d16a3014921b473c13db1_0span" name="field_40285a90490d16a3014921b473c13db1_0span" ></span></TD>
	<TD noWrap><input type="hidden" id="field_40285a90490d16a3014921b473e23db3_0" name="field_40285a90490d16a3014921b473e23db3_0" value="" ><span   style='width: 80%' id="field_40285a90490d16a3014921b473e23db3_0span" name="field_40285a90490d16a3014921b473e23db3_0span" ></span></TD>
	<TD noWrap><input type="hidden" id="field_40285a90490d16a3014921b474003db5_0" name="field_40285a90490d16a3014921b474003db5_0"  value=""  ><span style='width: 80%' id="field_40285a90490d16a3014921b474003db5_0span" name="field_40285a90490d16a3014921b474003db5_0span" ></span></TD>
	<TD noWrap><input type="hidden" id="field_40285a90490d16a3014921b474193db7_0" name="field_40285a90490d16a3014921b474193db7_0" value="" maxlength=24  ><span style='width: 80%' id="field_40285a90490d16a3014921b474193db7_0span" name="field_40285a90490d16a3014921b474193db7_0span" ></span></TD>
	<TD noWrap><input type="hidden" id="field_40285a8d4b246d79014b2a575f9606f8_0" name="field_40285a8d4b246d79014b2a575f9606f8_0" value="" maxlength=24  ><span style='width: 80%' id="field_40285a8d4b246d79014b2a575f9606f8_0span" name="field_40285a8d4b246d79014b2a575f9606f8_0span" ></span></TD>
	<TD noWrap><input type="hidden" id="field_40285a8d4b246d79014b2a575faa06fa_0" name="field_40285a8d4b246d79014b2a575faa06fa_0" value="" maxlength=24  ><span style='width: 80%' id="field_40285a8d4b246d79014b2a575faa06fa_0span" name="field_40285a8d4b246d79014b2a575faa06fa_0span" ></span></TD>
	<TD noWrap><input type="text" class="InputStyle2" maxlength=24 name="field_40285a90490d16a3014921b4742f3db9_0"  id="field_40285a90490d16a3014921b4742f3db9_0" value="" style='width: 80%'   onblur="fieldcheck(this,'^-?\\d+$','到货数量')"  onChange="fieldcheck(this,'^-?\\d+$','到货数量');checkInput('field_40285a90490d16a3014921b4742f3db9_0','field_40285a90490d16a3014921b4742f3db9_0span')" ><span id="field_40285a90490d16a3014921b4742f3db9_0span" name="field_40285a90490d16a3014921b4742f3db9_0span" ><img src="/images/base/checkinput.gif" align=absMiddle></span></TD>
	<TD noWrap><input type="text" class="InputStyle2" maxlength=24 name="field_40285a8d4ce422d6014ce4de728e0730_0"  id="field_40285a8d4ce422d6014ce4de728e0730_0" value=""    onblur="fieldcheck(this,'^-?\\d+$','差异数量')"  ></TD></TR>
<%} %>
</TBODY>
</table>
</div>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 