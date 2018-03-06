package com.eweaver.sysinterface.extclass;

import java.util.List;
import java.util.Map;

import com.eweaver.base.*; 
import com.eweaver.base.security.service.acegi.EweaverUser; 
import com.eweaver.base.util.DateHelper;
import com.eweaver.base.util.StringHelper;
import com.eweaver.sysinterface.base.Param; 
import com.eweaver.sysinterface.javacode.EweaverExecutorBase; 
import com.eweaver.humres.base.service.HumresService;
import com.eweaver.workflow.form.service.FormBaseService;
import com.eweaver.workflow.form.model.FormBase;
import com.eweaver.humres.base.model.Humres;

public class Ewv20141016141138 extends EweaverExecutorBase {

	@Override
	public void doExecute(Param params) {
		// TODO Auto-generated method stub
	     String requestid = this.requestid;//当前流程requestid 
	     EweaverUser currentuser = BaseContext.getRemoteUser();//获取当前用户对象 
	     String nodeid = params.getParamValueStr("nodeid");//流程当前节点 
	     String issave = params.getParamValueStr("issave");//是否保存 
	     String isundo = params.getParamValueStr("isundo");//是否撤回 
	     String formid = params.getParamValueStr("formid");//流程关联表单ID 
	     String editmode = params.getParamValueStr("editmode");//编辑模式 
	     String maintablename = params.getParamValueStr("maintablename");//关联流程的主表 
	     String args = params.getParamValueStr("arg");//获取接口中传入的文本参数 
	     String field1 = params.getParamValueStr("FIELD1");//获取表单中的字段值,字段名参数要大写 		
	     	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	     	//取得询价主表信息,价格汇总表 uf_lo_trackprice 分类ID40285a9048f924a70148fdb0609b05ff
	     	String inqsql = "select * from uf_lo_inquiry where requestid ='"+requestid+"'";
	        List list = baseJdbc.executeSqlForList(inqsql);
	        if(list.size()>0){
		        Map inmap = (Map) list.get(0);
		        String linecode = StringHelper.null2String(inmap.get("linecode"));//线路编号	     	
		        String linetype = StringHelper.null2String(inmap.get("linetype"));//线路类型
		        String transittype = StringHelper.null2String(inmap.get("transittype"));//运输类型
		        String cartype = StringHelper.null2String(inmap.get("cartype"));//运输车型
		        String pricetype = StringHelper.null2String(inmap.get("pricetype"));//价格类型
		        String company = StringHelper.null2String(inmap.get("company"));//厂区别     	
		        String tstart = StringHelper.null2String(inmap.get("tstart"));//吨位起
		        String tend = StringHelper.null2String(inmap.get("tend"));//吨位（止）
		    	String valid = StringHelper.null2String(inmap.get("valid")); //有效期始
		    	String validutil = StringHelper.null2String(inmap.get("validutil"));//有效期止
		    	String state = StringHelper.null2String(inmap.get("state"));//状态
		    	String createman = StringHelper.null2String(inmap.get("createman"));//询价人
		    	String createdate = StringHelper.null2String(inmap.get("createdate"));//询价日期
		    	String linename = StringHelper.null2String(inmap.get("linename"));//线路名称
		    	String seqno = StringHelper.null2String(inmap.get("seqno"));//询价单号
		    	seqno = "询价单号："+seqno;	    	
		    	String dsql = "select a.recept,b.concode,b.conname,a.dprice,a.deliverycycle,a.cityadd,a.currency,a.taxrate from uf_lo_inqirydetail a,uf_lo_loginmatch b where a.concode = b.requestid and a.requestid='"+requestid+"'";
		        List dlist = baseJdbc.executeSqlForList(dsql);
			    if(dlist.size() > 0){
				    for (int j = 0; j < dlist.size(); j++) {
					    Map dmap = (Map) dlist.get(j);
					    String recept = StringHelper.null2String(dmap.get("recept"));//是否接受
					    String concode = StringHelper.null2String(dmap.get("concode"));//承运商编号
					    String conname = StringHelper.null2String(dmap.get("conname"));//承运商名称 32ID
					    String dprice = StringHelper.null2String(dmap.get("dprice"));//运输报价
					    String deliverycycle = StringHelper.null2String(dmap.get("deliverycycle"));//送货周期（天）
					    String cityadd = StringHelper.null2String(dmap.get("cityadd"));//同城加价
					    String currency = StringHelper.null2String(dmap.get("currency"));//货币
					    String taxrate = StringHelper.null2String(dmap.get("taxrate"));//税率（%）
					    String insql = ""; 
					    //如果是按受，则看价格类型是包车、配载、计件，然后组合生成分类  	
					    if("40288098276fc2120127704884290210".equalsIgnoreCase(recept)){//下拉框是32ID
					    	if(pricetype.equals("40285a9048f924a70148fd0d027f0524")){//包车，  40285a9048f924a70148fd0d027f0525配截，40285a9048f924a70148fd0d027f0526计件
						     	//创建价格汇总分类
						     	FormBaseService formBaseService = (FormBaseService)BaseContext.getBean("formbaseService");
							    String categoryid = "40285a9048f924a70148fdb0609b05ff";//分类id	
							    FormBase formBase = new FormBase();
							    String creator = "402881e70be6d209010be75668750014";//sysadmin
							    //创建formbase
							    formBase.setCreatedate(DateHelper.getCurrentDate());
							    formBase.setCreatetime(DateHelper.getCurrentTime());
							    formBase.setCreator(StringHelper.null2String(creator));
							    formBase.setCategoryid(categoryid);
							    formBase.setIsdelete(0);
							    formBaseService.createFormBase(formBase);
							    HumresService humresService = (HumresService) BaseContext.getBean("humresService");
							    Humres humres = humresService.getHumresById(creator);	
							    baseJdbc.update("insert into uf_lo_trackprice(id,requestid,linecode,linetype,transittype,pricetype,company,consolidator,tstart,tend,lineprice,valid,validutil,state,createman,createdate,remark,cartype,cityprice,concode)" + 
							    " values('"+IDGernerator.getUnquieID()+"','"+formBase.getId()+"','"+linecode+"','"+linetype+"','"+transittype+"','"+pricetype+"','"+company+"','"+conname+"','"+tstart+"','','"+dprice+"','"+valid+"','"+validutil+"','40288098276fc2120127704884290210','"+createman+"','"+createdate+"','"+seqno+"','"+cartype+"','"+cityadd+"','"+concode+"')");
					    	}
					    	
					    	if(pricetype.equalsIgnoreCase("40285a9048f924a70148fd0d027f0525")){//配截，40285a9048f924a70148fd0d027f0526计件
						     	//创建价格汇总分类
						     	FormBaseService formBaseService = (FormBaseService)BaseContext.getBean("formbaseService");
							    String categoryid = "40285a9048f924a70148fdb0609b05ff";//分类id	
							    FormBase formBase = new FormBase();
							    String creator = "402881e70be6d209010be75668750014";//sysadmin
							    //创建formbase
							    formBase.setCreatedate(DateHelper.getCurrentDate());
							    formBase.setCreatetime(DateHelper.getCurrentTime());
							    formBase.setCreator(StringHelper.null2String(creator));
							    formBase.setCategoryid(categoryid);
							    formBase.setIsdelete(0);
							    formBaseService.createFormBase(formBase);
							    HumresService humresService = (HumresService) BaseContext.getBean("humresService");
							    Humres humres = humresService.getHumresById(creator);	
							    baseJdbc.update("insert into uf_lo_trackprice(id,requestid,linecode,linetype,transittype,pricetype,company,consolidator,tstart,tend,lineprice,valid,validutil,state,createman,createdate,remark,cartype,cityprice,concode)" + 
							    " values('"+IDGernerator.getUnquieID()+"','"+formBase.getId()+"','"+linecode+"','"+linetype+"','"+transittype+"','"+pricetype+"','"+company+"','"+conname+"','"+tstart+"','"+tend+"','"+dprice+"','"+valid+"','"+validutil+"','40288098276fc2120127704884290210','"+createman+"','"+createdate+"','"+seqno+"','"+cartype+"','"+cityadd+"','"+concode+"')");
					    	}	
					    	if(pricetype.equalsIgnoreCase("40285a9048f924a70148fd0d027f0526")){//40285a9048f924a70148fd0d027f0526计件
						     	//创建价格汇总分类
						     	FormBaseService formBaseService = (FormBaseService)BaseContext.getBean("formbaseService");
							    String categoryid = "40285a9048f924a70148fdb0609b05ff";//分类id	
							    FormBase formBase = new FormBase();
							    String creator = "402881e70be6d209010be75668750014";//sysadmin
							    //创建formbase
							    formBase.setCreatedate(DateHelper.getCurrentDate());
							    formBase.setCreatetime(DateHelper.getCurrentTime());
							    formBase.setCreator(StringHelper.null2String(creator));
							    formBase.setCategoryid(categoryid);
							    formBase.setIsdelete(0);
							    formBaseService.createFormBase(formBase);
							    HumresService humresService = (HumresService) BaseContext.getBean("humresService");
							    Humres humres = humresService.getHumresById(creator);				    		
							    baseJdbc.update("insert into uf_lo_trackprice(id,requestid,linecode,linetype,transittype,pricetype,company,consolidator,tstart,tend,lineprice,valid,validutil,state,createman,createdate,remark,cartype,cityprice,cityprice,concode)" + 
							    " values('"+IDGernerator.getUnquieID()+"','"+formBase.getId()+"','"+linecode+"','"+linetype+"','"+transittype+"','"+pricetype+"','"+company+"','"+conname+"','','','"+dprice+"','"+valid+"','"+validutil+"','40288098276fc2120127704884290210','"+createman+"','"+createdate+"','"+seqno+"','"+cartype+"','"+cityadd+"','"+concode+"')");
					    	}					    	
					    }
				    }
			    }	        	
	        }    
	}

}
