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
String requestid = StringHelper.null2String(request.getParameter("id"));

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
<COL width="8%"></COLGROUP>
<TBODY>
<TR class=Header>
<TD noWrap><INPUT id=check_node_all onclick="selectAll(this,'40285a90490d16a3014921b08aa03d3e')" value=-1 type=checkbox name=check_node_all>序号</TD>
<TD noWrap>申请单号</TD>
<TD noWrap>申请单行号</TD>
<TD noWrap>申请人</TD>
<TD noWrap>申请部门</TD>
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
<TD noWrap>品质检验&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD></TR>

<%
	String sql="select a.no as no1,a.appnumber,a.appno,(select goodsid from  uf_oa_goodsmaintain  where requestid=a.goodsno) as goodsid,a.goodsno,(select goodsname from  uf_oa_goodsmaintain  where requestid=a.goodsname) as goodsname,a.specify,a.unit,a.suppliername,(select supplyname from uf_oa_supplyinfo where requestid=a.suppliername) as supplyname ,a.suppliercode as scode,a.ordernum,a.allreceive,a.noreceive,a.receivenum,a.expnum,a.apply,b.objname applyname,a.dept,(select objname from orgunit where id=a.dept) as deptname,ispass from uf_oa_receivedetail  a  left join humres b on b.id=a.apply where requestid='"+requestid+"' order by nlssort(b.objname, 'NLS_SORT=SCHINESE_PINYIN_M')";

       List sublist = baseJdbc.executeSqlForList(sql);
       if(sublist.size()>0){
	          for(int k=0,sizek=sublist.size();k<sizek;k++){
		      Map mk = (Map)sublist.get(k);
			  String no1=StringHelper.null2String(mk.get("no1"));
			  String goodsno=StringHelper.null2String(mk.get("goodsno"));
			  String goodsid=StringHelper.null2String(mk.get("goodsid"));
			  String goodsname=StringHelper.null2String(mk.get("goodsname"));
			  String appnumber=StringHelper.null2String(mk.get("appnumber"));
			  String appno=StringHelper.null2String(mk.get("appno"));;
			  String specify=StringHelper.null2String(mk.get("specify"));
			  String unit=StringHelper.null2String(mk.get("unit"));
			  String suppliername=StringHelper.null2String(mk.get("suppliername"));
			  String supplyname=StringHelper.null2String(mk.get("supplyname"));
			  String scode=StringHelper.null2String(mk.get("scode"));
			  String ordernum=StringHelper.null2String(mk.get("ordernum"));
			  String allreceive=StringHelper.null2String(mk.get("allreceive"));
			  String noreceive=StringHelper.null2String(mk.get("noreceive"));
			  String receivenum=StringHelper.null2String(mk.get("receivenum"));
			  String expnum=StringHelper.null2String(mk.get("expnum"));
			String apply=StringHelper.null2String(mk.get("apply"));
			  String applyname=StringHelper.null2String(mk.get("applyname"));
			  String dept=StringHelper.null2String(mk.get("dept"));
			  String deptname=StringHelper.null2String(mk.get("deptname"));
			String ispass=StringHelper.null2String(mk.get("ispass"));
			String selected1="";
			if(ispass.equals(""))
			{
				selected1="";
			}
			else if(ispass.equals("40288098276fc2120127704884290210"))
			{
				selected1="通过";
			}
			else
			{
				selected1="不通过";
			}
			  
                
                     
		%>
<TR id=oTR40285a90490d16a3014921b08aa03d3e class=DataLight><!-- 明细表ID，请勿删除。-->
<TD noWrap><span ><input type="checkbox" name="check_node_40285a90490d16a3014921b08aa03d3e" value="<%=k%>"><input type=hidden name=<%="detailid_40285a90490d16a3014921b08aa03d3e_"+k%> value="<%=k%>"></span>
<input type="hidden" id=<%="field_40285a90490d16a3014921c3bae63f79_"+k%> name=<%="field_40285a90490d16a3014921c3bae63f79_"+k%> value="<%=k+1%>" maxlength=24  ><span style='width: 50%' id=<%="field_40285a90490d16a3014921c3bae63f79_"+k+"span"%> name=<%="field_40285a90490d16a3014921c3bae63f79_"+k+"span"%> ><%=k+1%></span></TD>
<TD noWrap><input type="hidden" id=<%="field_40285a8d4ce422d6014d046a96642c6f_"+k%> name=<%="field_40285a8d4ce422d6014d046a96642c6f_"+k%>  value="<%=appnumber%>"  ><span style='width: 80%' id=<%="field_40285a8d4ce422d6014d046a96642c6f_"+k+"span"%> name=<%="field_40285a8d4ce422d6014d046a96642c6f_"+k+"span"%> ><%=appnumber%></span></TD>
<TD noWrap><input type="hidden" id=<%="field_40285a8d4ce422d6014d046a96982c71_"+k%> name=<%="field_40285a8d4ce422d6014d046a96982c71_"+k%> value="<%=appno%>" maxlength=24  ><span style='width: 80%' id=<%="field_40285a8d4ce422d6014d046a96982c71_"+k+"span"%> name=<%="field_40285a8d4ce422d6014d046a96982c71_"+k+"span"%> ><%=appno%></span></TD>
	<TD noWrap><input type="hidden" id=<%="field_applyername_"+k%> name=<%="field_applyername_"+k%> value="<%=apply%>" maxlength=24  ><span style='width: 80%' id=<%="field_applyername_"+k+"span"%> name=<%="field_applyername_"+k+"span"%> ><%=applyname%></span></TD>

		<TD noWrap><input type="hidden" id=<%="field_applydept_"+k%> name=<%="field_applydept_"+k%> value="<%=dept%>" maxlength=24  ><span style='width: 80%' id=<%="field_applydept_"+k+"span"%> name=<%="field_applydept_"+k+"span"%> ><%=deptname%></span></TD>
<TD noWrap><input type="hidden" id=<%="field_40285a90490d16a3014921e6bd1242c2_"+k%> name=<%="field_40285a90490d16a3014921e6bd1242c2_"+k%> value="<%=goodsno%>" ><span   style='width: 80%' id=<%="field_40285a90490d16a3014921e6bd1242c2_"+k+"span"%> name=<%="field_40285a90490d16a3014921e6bd1242c2_"+k+"span"%> ><%=goodsid%></span></TD>
<TD noWrap><input type="hidden" id=<%="field_40285a90490d16a3014921b4738a3dad_"+k%> name=<%="field_40285a90490d16a3014921b4738a3dad_"+k%> value="<%=goodsno%>" ><span   style='width: 80%' id=<%="field_40285a90490d16a3014921b4738a3dad_"+k+"span"%> name=<%="field_40285a90490d16a3014921b4738a3dad_"+k+"span"%> ><%=goodsname%></span></TD>
<TD noWrap><input type="hidden" id=<%="field_40285a90490d16a3014921b473a33daf_"+k%> name=<%="field_40285a90490d16a3014921b473a33daf_"+k%>  value="<%=specify%>"  ><span style='width: 80%' id=<%="field_40285a90490d16a3014921b473a33daf_"+k+"span"%> name=<%="field_40285a90490d16a3014921b473a33daf_"+k+"span"%> ><%=specify%></span></TD>
<TD noWrap><input type="hidden" id=<%="field_40285a90490d16a3014921b473c13db1_"+k%> name=<%="field_40285a90490d16a3014921b473c13db1_"+k%>  value="<%=unit%>"  ><span style='width: 80%' id=<%="field_40285a90490d16a3014921b473c13db1_"+k+"span"%> name=<%="field_40285a90490d16a3014921b473c13db1_"+k+"span"%> ><%=unit%></span></TD>
<TD noWrap><input type="hidden" id=<%="field_40285a90490d16a3014921b473e23db3_"+k%> name=<%="field_40285a90490d16a3014921b473e23db3_"+k%> value="<%=suppliername%>" ><span   style='width: 80%' id=<%="field_40285a90490d16a3014921b473e23db3_"+k+"span"%> name=<%="field_40285a90490d16a3014921b473e23db3_"+k+"span"%> ><%=supplyname%></span></TD>
<TD noWrap><input type="hidden" id=<%="field_40285a90490d16a3014921b474003db5_"+k%> name=<%="field_40285a90490d16a3014921b474003db5_"+k%>  value="<%=scode%>"  ><span style='width: 80%' id=<%="field_40285a90490d16a3014921b474003db5_"+k+"span"%> name=<%="field_40285a90490d16a3014921b474003db5_"+k+"span"%> ><%=scode%></span></TD>
<TD noWrap><input type="hidden" id=<%="field_40285a90490d16a3014921b474193db7_"+k%> name=<%="field_40285a90490d16a3014921b474193db7_"+k%> value="<%=ordernum%>" maxlength=24  ><span style='width: 80%' id=<%="field_40285a90490d16a3014921b474193db7_"+k+"span"%> name=<%="field_40285a90490d16a3014921b474193db7_"+k+"span"%> ><%=ordernum%></span></TD>
<TD noWrap><input type="hidden" id=<%="field_40285a8d4b246d79014b2a575f9606f8_"+k%> name=<%="field_40285a8d4b246d79014b2a575f9606f8_"+k%> value="<%=allreceive%>" maxlength=24  ><span style='width: 80%' id=<%="field_40285a8d4b246d79014b2a575f9606f8_"+k+"span"%> name=<%="field_40285a8d4b246d79014b2a575f9606f8_"+k+"span"%> ><%=allreceive%></span></TD>
<TD noWrap><input type="hidden" id=<%="field_40285a8d4b246d79014b2a575faa06fa_"+k%> name=<%="field_40285a8d4b246d79014b2a575faa06fa_"+k%> value="<%=noreceive%>" maxlength=24  ><span style='width: 80%' id=<%="field_40285a8d4b246d79014b2a575faa06fa_"+k+"span"%> name=<%="field_40285a8d4b246d79014b2a575faa06fa_"+k+"span"%> ><%=noreceive%></span></TD>
<TD noWrap><input type="hidden" class="InputStyle2" maxlength=24 name=<%="field_40285a90490d16a3014921b4742f3db9_0"+k%>  id=<%="field_40285a90490d16a3014921b4742f3db9_"+k%> value="<%=receivenum%>" style='width: 80%' ><span id=<%="field_40285a90490d16a3014921b4742f3db9_"+k+"span"%> name=<%="field_40285a90490d16a3014921b4742f3db9_"+k+"span"%> ><%=receivenum%></span></TD>
<TD noWrap><input type="hidden" class="InputStyle2" maxlength=24 name=<%="field_40285a8d55141d0a01552eeafbf702b3_"+k%>  id=<%="field_40285a8d55141d0a01552eeafbf702b3_"+k%> value="<%=selected1%>" style='width: 80%' ><span id=<%="field_40285a8d55141d0a01552eeafbf702b3_"+k+"span"%> name=<%="field_40285a8d55141d0a01552eeafbf702b3_"+k+"span"%> ><%=selected1%></span></TD>
</TR>
		<%		
	}
}else{%> 
<TR id=oTR40285a90490d16a3014921b08aa03d3e class=DataLight><!-- 明细表ID，请勿删除。-->
<TD noWrap><span ><input type="checkbox" name="check_node_40285a90490d16a3014921b08aa03d3e" value="0"><input type=hidden name="detailid_40285a90490d16a3014921b08aa03d3e_0" value=""></span><input type="hidden" id="field_40285a90490d16a3014921c3bae63f79_0" name="field_40285a90490d16a3014921c3bae63f79_0" value="" maxlength=24  ><span style='width: 50%' id="field_40285a90490d16a3014921c3bae63f79_0span" name="field_40285a90490d16a3014921c3bae63f79_0span" ></span></TD>
<TD noWrap><input type="hidden" id="field_40285a8d4ce422d6014d046a96642c6f_0" name="field_40285a8d4ce422d6014d046a96642c6f_0"  value=""  ><span style='width: 80%' id="field_40285a8d4ce422d6014d046a96642c6f_0span" name="field_40285a8d4ce422d6014d046a96642c6f_0span" ></span></TD>
<TD noWrap><input type="hidden" id="field_40285a8d4ce422d6014d046a96982c71_0" name="field_40285a8d4ce422d6014d046a96982c71_0" value="" maxlength=24  ><span style='width: 80%' id="field_40285a8d4ce422d6014d046a96982c71_0span" name="field_40285a8d4ce422d6014d046a96982c71_0span" ></span></TD>
<TD noWrap><input type="hidden" id="field_40285a90490d16a3014921e6bd1242c2_0" name="field_40285a90490d16a3014921e6bd1242c2_0" value="" ><span   style='width: 80%' id="field_40285a90490d16a3014921e6bd1242c2_0span" name="field_40285a90490d16a3014921e6bd1242c2_0span" ></span></TD>
<TD noWrap><input type="hidden" id="field_40285a90490d16a3014921b4738a3dad_0" name="field_40285a90490d16a3014921b4738a3dad_0" value="" ><span   style='width: 80%' id="field_40285a90490d16a3014921b4738a3dad_0span" name="field_40285a90490d16a3014921b4738a3dad_0span" ></span></TD>
<TD noWrap><input type="hidden" id="field_40285a90490d16a3014921b473a33daf_0" name="field_40285a90490d16a3014921b473a33daf_0"  value=""  ><span style='width: 80%' id="field_40285a90490d16a3014921b473a33daf_0span" name="field_40285a90490d16a3014921b473a33daf_0span" ></span></TD>
<TD noWrap><input type="hidden" id="field_40285a90490d16a3014921b473c13db1_0" name="field_40285a90490d16a3014921b473c13db1_0"  value=""  ><span style='width: 80%' id="field_40285a90490d16a3014921b473c13db1_0span" name="field_40285a90490d16a3014921b473c13db1_0span" ></span></TD>
<TD noWrap><input type="hidden" id="field_40285a90490d16a3014921b473e23db3_0" name="field_40285a90490d16a3014921b473e23db3_0" value="" ><span   style='width: 80%' id="field_40285a90490d16a3014921b473e23db3_0span" name="field_40285a90490d16a3014921b473e23db3_0span" ></span></TD>
<TD noWrap><input type="hidden" id="field_40285a90490d16a3014921b474003db5_0" name="field_40285a90490d16a3014921b474003db5_0"  value=""  ><span style='width: 80%' id="field_40285a90490d16a3014921b474003db5_0span" name="field_40285a90490d16a3014921b474003db5_0span" ></span></TD>
<TD noWrap><input type="hidden" id="field_40285a90490d16a3014921b474193db7_0" name="field_40285a90490d16a3014921b474193db7_0" value="" maxlength=24  ><span style='width: 80%' id="field_40285a90490d16a3014921b474193db7_0span" name="field_40285a90490d16a3014921b474193db7_0span" ></span></TD>
<TD noWrap><input type="hidden" id="field_40285a8d4b246d79014b2a575f9606f8_0" name="field_40285a8d4b246d79014b2a575f9606f8_0" value="" maxlength=24  ><span style='width: 80%' id="field_40285a8d4b246d79014b2a575f9606f8_0span" name="field_40285a8d4b246d79014b2a575f9606f8_0span" ></span></TD>
<TD noWrap><input type="hidden" id="field_40285a8d4b246d79014b2a575faa06fa_0" name="field_40285a8d4b246d79014b2a575faa06fa_0" value="" maxlength=24  ><span style='width: 80%' id="field_40285a8d4b246d79014b2a575faa06fa_0span" name="field_40285a8d4b246d79014b2a575faa06fa_0span" ></span></TD>
<TD noWrap><input type="hidden" class="InputStyle2" maxlength=24 name="field_40285a90490d16a3014921b4742f3db9_0"  id="field_40285a90490d16a3014921b4742f3db9_0" value="" style='width: 80%' ><span id="field_40285a90490d16a3014921b4742f3db9_0span" name="field_40285a90490d16a3014921b4742f3db9_0span" ></span></TD>
<TD noWrap><input type="text" class="InputStyle2" maxlength=24 name="field_40285a8d4ce422d6014ce4de728e0730_0"  id="field_40285a8d4ce422d6014ce4de728e0730_0" value=""    ></TD></TR>
<%} %>
</TBODY>
</table>
</div>
