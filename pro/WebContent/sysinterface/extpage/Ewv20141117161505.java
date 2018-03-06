/*
**用车申请开始提交后生成预定行程并生成用车明细单
*/
package com.eweaver.sysinterface.extclass; 
 
 import java.util.List;
import java.util.Map;
import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.util.StringHelper;

 import com.eweaver.base.security.service.acegi.EweaverUser; 
 import com.eweaver.sysinterface.base.Param; 
 import com.eweaver.sysinterface.javacode.EweaverExecutorBase; 
 public class Ewv20141117161505 extends EweaverExecutorBase{ 

 
 @Override 
 public void doExecute (Param params) {
  
    String requestid = this.requestid;//当前流程requestid 
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String approute ="";
    String sql = "select city,town,address,visitobj,sitetype from uf_oa_carroutedetail where requestid = '"+requestid+"' and   sitetype='40285a90490d16a301492b0c06af49bd'";
	List tlist = baseJdbc.executeSqlForList(sql);
	if(tlist.size()>0){
		for(int i=0;i<tlist.size();i++){
			Map map = (Map)tlist.get(i);
			String city = StringHelper.null2String(map.get("city"));//市
			String town = StringHelper.null2String(map.get("town"));//镇
			String address = StringHelper.null2String(map.get("address"));//地址
			String visitobj = StringHelper.null2String(map.get("visitobj"));//拜访对象
			//String sitetype = StringHelper.null2String(map.get("sitetype"));//站点类型
			String sql1 = "select objname from selectitem where id ='"+city+"'";
			List list =  baseJdbc.executeSqlForList(sql1);
			if(list.size()>0){
				Map m = (Map)list.get(0);
				city =  StringHelper.null2String(m.get("objname"));//市
			}
			sql1 = "select cityname,postcode,requestid from uf_lo_city  where postcode=\'"+ town +"\'";
			list =  baseJdbc.executeSqlForList(sql1);
			if(list.size()>0){
				Map m = (Map)list.get(0);
				town =  StringHelper.null2String(m.get("cityname"));//镇
			}
			approute =approute+"-"+ town +""+address+"("+visitobj+")";
		}
		System.out.println("approute="+approute); 	
	}
	sql = "select city,town,address,visitobj,sitetype from uf_oa_carroutedetail where requestid = '"+requestid+"' and   sitetype='40285a90490d16a301492b0c06af49be'";
	tlist = baseJdbc.executeSqlForList(sql);
	if(tlist.size()>0){
		for(int i=0;i<tlist.size();i++){
			Map map = (Map)tlist.get(i);
			String city = StringHelper.null2String(map.get("city"));//市
			String town = StringHelper.null2String(map.get("town"));//镇
			String address = StringHelper.null2String(map.get("address"));//地址
			String visitobj = StringHelper.null2String(map.get("visitobj"));//拜访对象
			//String sitetype = StringHelper.null2String(map.get("sitetype"));//站点类型
			String sql1 = "select objname from selectitem where id ='"+city+"'";
			List list =  baseJdbc.executeSqlForList(sql1);
			if(list.size()>0){
				Map m = (Map)list.get(0);
				city =  StringHelper.null2String(m.get("objname"));//市
			}
			sql1 = "select cityname,postcode,requestid from uf_lo_city  where postcode=\'"+ town +"\'";
			list =  baseJdbc.executeSqlForList(sql1);
			if(list.size()>0){
				Map m = (Map)list.get(0);
				town =  StringHelper.null2String(m.get("cityname"));//镇
			}			
			approute =approute+"-"+ town +""+address+"("+visitobj+")";
		}
		System.out.println("approute="+approute); 	
	} 
	sql = "select city,town,address,visitobj,sitetype from uf_oa_carroutedetail where requestid = '"+requestid+"' and   sitetype='40285a90490d16a301492b0c06af49bf'";
	tlist = baseJdbc.executeSqlForList(sql);
	if(tlist.size()>0){
		for(int i=0;i<tlist.size();i++){
			Map map = (Map)tlist.get(i);
			String city = StringHelper.null2String(map.get("city"));//市
			String town = StringHelper.null2String(map.get("town"));//镇
			String address = StringHelper.null2String(map.get("address"));//地址
			String visitobj = StringHelper.null2String(map.get("visitobj"));//拜访对象
			//String sitetype = StringHelper.null2String(map.get("sitetype"));//站点类型
			String sql1 = "select objname from selectitem where id ='"+city+"'";
			List list =  baseJdbc.executeSqlForList(sql1);
			if(list.size()>0){
				Map m = (Map)list.get(0);
				city =  StringHelper.null2String(m.get("objname"));//市
			}
			sql1 = "select cityname,postcode,requestid from uf_lo_city  where postcode=\'"+ town +"\'";
			list =  baseJdbc.executeSqlForList(sql1);
			if(list.size()>0){
				Map m = (Map)list.get(0);
				town =  StringHelper.null2String(m.get("cityname"));//镇
			}			
			approute =approute+"-"+ town +""+address+"("+visitobj+")";
		}
		System.out.println("approute="+approute); 	
	}
	approute = approute.replaceAll("^(-+)", "");
	System.out.println("approute="+approute); 	
//40285a90490d16a301492b0c06af49bd  出发地点
//40285a90490d16a301492b0c06af49bf 	返回地点
//40285a90490d16a301492b0c06af49be	中途站点
	if(approute.equals("")){
	}else{
		String upsql = "update uf_oa_carapp set planroute ='"+approute+"',stateflag='1' where requestid ='"+requestid+"'";
		baseJdbc.update(upsql);			
	}
 } 

 }




