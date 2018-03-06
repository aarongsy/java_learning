package com.eweaver.sysinterface.extclass;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.eweaver.base.*; 
import com.eweaver.base.security.service.acegi.EweaverUser; 
import com.eweaver.base.security.util.PermissionTool;
import com.eweaver.base.util.DateHelper;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringHelper;
import com.eweaver.sysinterface.base.Param; 
import com.eweaver.sysinterface.javacode.EweaverExecutorBase; 
import com.eweaver.humres.base.service.HumresService;
import com.eweaver.workflow.form.service.FormBaseService;
import com.eweaver.workflow.form.model.FormBase;
import com.eweaver.humres.base.model.Humres;
import com.eweaver.interfaces.form.Formdata;
import com.eweaver.interfaces.form.FormdataServiceImpl;
import com.eweaver.interfaces.model.Cell;
import com.eweaver.interfaces.model.Dataset;

public class Ewv20141205094526 extends EweaverExecutorBase {

	@Override
	public void doExecute(Param params) {
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
	     	List<String> sqlList =new ArrayList<String>();
	     	List<String> requestList =new ArrayList<String>();
			/**
			 * 自提装卸计划流程审批结束时生成提入单
			 * 1、明细表中按送达方个数，生成对应送达方的提入单。
			 * 2、主表为运出则生成：提单，否则则生成物品入厂单
			 * 3、回写装卸计划明细中对应的提入单号
			 *
			 */
	     	//统一查询主表值
	     	String msql = "select * from uf_lo_loadplan where requestid ='"+requestid+"'";
	     	List mlist = baseJdbc.executeSqlForList(msql);
	     	if(mlist.size()>0){
	     		//此处取得主表数据值
	     		Map mmap = (Map)mlist.get(0);
	     		/**
	     		 * 定义主表值
	     		 */
	     		String reqno = StringHelper.null2String(mmap.get("reqno"));
	     		String preplan = StringHelper.null2String(mmap.get("preplan"));
	     		String carno = StringHelper.null2String(mmap.get("carno"));	     		
	     		String figuredate = StringHelper.null2String(mmap.get("figuredate"));
	     		String assistprice = StringHelper.null2String(mmap.get("assistprice"));
	     		String returnbill = StringHelper.null2String(mmap.get("returnbill"));
	     		String arrivecity = StringHelper.null2String(mmap.get("arrivecity"));	     		
	     		String nosap = StringHelper.null2String(mmap.get("nosap"));
	     		String transitton = StringHelper.null2String(mmap.get("transitton"));
	     		String concode = StringHelper.null2String(mmap.get("concode"));
	     		String linecode = StringHelper.null2String(mmap.get("linecode"));	     		
	     		String reqman = StringHelper.null2String(mmap.get("reqman"));
	     		String subsection = StringHelper.null2String(mmap.get("subsection"));
	     		String trailerno = StringHelper.null2String(mmap.get("trailerno"));
	     		String offdate = StringHelper.null2String(mmap.get("offdate"));	     		
	     		String remark = StringHelper.null2String(mmap.get("remark"));
	     		String createtype = StringHelper.null2String(mmap.get("createtype"));
	     		String conname = StringHelper.null2String(mmap.get("conname"));
	     		String rconcode = StringHelper.null2String(mmap.get("rconcode"));	     		
	     		String chgreason = StringHelper.null2String(mmap.get("chgreason"));
	     		String pickupdate = StringHelper.null2String(mmap.get("pickupdate"));	     		
	     		String startcity = StringHelper.null2String(mmap.get("startcity"));
	     		String reqdept = StringHelper.null2String(mmap.get("reqdept"));
	     		String shipout = StringHelper.null2String(mmap.get("shipout"));
	     		String loanno = StringHelper.null2String(mmap.get("loanno"));	     		
	     		String company = StringHelper.null2String(mmap.get("company"));
	     		String linetype = StringHelper.null2String(mmap.get("linetype"));
	     		String servicetype = StringHelper.null2String(mmap.get("servicetype"));
	     		String transittype = StringHelper.null2String(mmap.get("transittype"));	     		
	     		String costcentre = StringHelper.null2String(mmap.get("costcentre"));
	     		String runingno = StringHelper.null2String(mmap.get("runingno"));
	     		String isself = StringHelper.null2String(mmap.get("isself"));
	     		String reqdate = StringHelper.null2String(mmap.get("reqdate"));	     		
	     		String ispond = StringHelper.null2String(mmap.get("ispond"));
	     		String signno = StringHelper.null2String(mmap.get("signno"));
	     		String factory = StringHelper.null2String(mmap.get("factory"));
	     		String drivername = StringHelper.null2String(mmap.get("drivername"));	     		
	     		String arrivedate = StringHelper.null2String(mmap.get("arrivedate"));
	     		String isacceptflag = StringHelper.null2String(mmap.get("isacceptflag"));	 
	     		String cartype = StringHelper.null2String(mmap.get("cartype"));
	     		String cellphone = StringHelper.null2String(mmap.get("cellphone"));
	     		String rcolddate = StringHelper.null2String(mmap.get("rcolddate"));
	     		String goodsgroup = StringHelper.null2String(mmap.get("goodsgroup"));	     		
	     		String rconname = StringHelper.null2String(mmap.get("rconname"));
	     		String isaccept = StringHelper.null2String(mmap.get("isaccept"));
	     		
	     		/**
	     		 * 创建提入单
	     		 * 1、有几个送达方、供应商分组记录则创建几个提入单；按运出运入标识创建为提货单或物品入厂单
	     		 */
//		     	String inqsql = "select shipto，vendorno from uf_lo_loaddetail where requestid ='"+requestid+"'";
		     	String inqsql = "select soldto,shipto,vendorno,sum(deliverdnum) deliverdnum from uf_lo_loaddetail where requestid ='"+requestid+"' group by soldto,shipto,vendorno";		     	
		        List list = baseJdbc.executeSqlForList(inqsql);
		        if(list.size()>0){
		        	for(int i=0;i<list.size();i++){
		        		/**
		        		 * 创建提入单主表明细
		        		 */
		        		Map map = (Map)list.get(i);
		        		String soldto = StringHelper.null2String(map.get("soldto"));
		        		String shipto = StringHelper.null2String(map.get("shipto"));
		        		String vendorno = StringHelper.null2String(map.get("vendorno"));
		        		Float deliverdnum = Float.parseFloat(StringHelper.null2String(map.get("deliverdnum")));
		        		/**
		        		 * 取得soldtoname,shiptoname,vendorname的中文名称
		        		 */
		        		String soldtoname = "";
		        		String shiptoname = "";
		        		String vendorname = "";		
		        		String shiptoaddress = "";
		        		String addressdesc = "";
		        		String cardetailid = "";
		        		//soldtoname,shiptoname,vendorname,shiptoaddress,addressdesc,shiptoaddress,addressdesc,cardetailid		        		
		        		String namesql = "select id,requestid,runningno,ordertype,goodsgroup,isself,materialno,materialdesc,deliverdnum,yetloadnum,leftloadnum,salesunit,divvyfee,divvyexpfee,soldto,soldtoname,shipto,shiptoname,vendorno,vendorname,shiptoaddress,addressdesc,cardetailid from uf_lo_loaddetail where requestid ='"+requestid+"' and soldto ? and shipto ? and vendorno ?";
		        		String soldtos = "='"+soldto+"'";
		        		if(soldto.equals("")){
		        			soldtos = "is null";
		        		}
		        		String shiptos = "='"+shipto+"'";
		        		if(shipto.equals("")){
		        			shiptos = "is null";
		        		}
		        		String vendornos = "='"+vendorno+"'";
		        		if(vendorno.equals("")){
		        			vendornos = "is null";
		        		}
		        		namesql = namesql.replaceFirst("[?]",soldtos);
		        		namesql = namesql.replaceFirst("[?]",shiptos);
		        		namesql = namesql.replaceFirst("[?]",vendornos);
//		        		System.out.println(namesql);
		        		List listn = baseJdbc.executeSqlForList(namesql);
		        		if(listn.size()>0){
		        			Map mapn = (Map)listn.get(0);
			        		soldtoname = StringHelper.null2String(mapn.get("soldtoname"));
			        		shiptoname = StringHelper.null2String(mapn.get("shiptoname"));
			        		vendorname = StringHelper.null2String(mapn.get("vendorname"));
			        		shiptoaddress = StringHelper.null2String(mapn.get("shiptoaddress"));	
			        		addressdesc = StringHelper.null2String(mapn.get("addressdesc"));	
			        		cardetailid = StringHelper.null2String(mapn.get("cardetailid"));				        		
		        		}
		        		
				     	FormBaseService formBaseService = (FormBaseService)BaseContext.getBean("formbaseService");
					    String categoryid = "402865fa4945073e0149454e9ea000ae";//分类id	
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
					    /*
					     * 提入单号取值
					     */
					    String ladingno = getNo(company+"W","40285a904a17fd75014a196e0e9a4219",9);//"1010W000000001"
					    String newstrid = formBase.getId();
					    baseJdbc.update("insert into uf_lo_ladingmain(id,requestid,ladingno,loadingno,createman,createtime,state)" + 
					    " values('"+IDGernerator.getUnquieID()+"','"+newstrid+"','"+ladingno+"','"+reqno+"','"+creator+"','"+DateHelper.getCurDateTime()+"','402864d14940d265014941e9d82900da')");
					    PermissionTool permissionTool = new PermissionTool();
					    permissionTool.addPermission(categoryid,newstrid,"uf_lo_ladingmain");
					    String upsql = "update uf_lo_ladingmain set ";
					    String upsql1 = "";
					    if(concode.equals("")){
					    	concode = rconcode;
					    	conname = rconname;
					    }					    
					    String upsql2 = " where requestid = '"+newstrid+"'";
					    String upstr[] = new String[33];
					    upstr[0]="servicetype='"+servicetype+"',";//业务类型
					    upstr[1]="createtype='"+createtype+"',";//制单类型
					    upstr[2]="isurgent='',";//紧急出货
					    upstr[3]="shipout='"+shipout+"',";//运出标记
					    upstr[4]="ispond='"+ispond+"',";//是否过磅
					    upstr[5]="cartype='"+cartype+"',";//车辆车型
					    upstr[6]="transittype='"+transittype+"',";//运输类型
					    upstr[7]="transitton='"+transitton+"',";//运输吨位
					    upstr[8]="concode='"+concode+"',";//承运商编码
					    upstr[9]="conname='"+conname+"',";//承运商名称
					    upstr[10]="isaccept='"+isaccept+"',";//接受委托
					    upstr[11]="drivername='"+drivername+"',";//司机姓名
					    upstr[12]="cellphone='"+cellphone+"',";//联系电话
					    upstr[13]="carno='"+carno+"',";//车牌号
					    upstr[14]="trailerno='"+trailerno+"',";//挂车号
					    upstr[15]="loanno='"+loanno+"',";//货柜号
					    upstr[16]="signno='"+signno+"',";//封签号
					    upstr[17]="company='"+company+"',";//公司代码
					    upstr[18]="factory='"+factory+"',";//厂区别
					    upstr[19]="grosswt='',";//计划毛重 可不录
					    upstr[20]="totalnum="+deliverdnum+",";//计划总量 数量总计
					    upstr[21]="pickupdate='"+pickupdate+"',";//提贷开始
					    upstr[22]="soldto='"+soldto+"',";//售达方
					    upstr[23]="soldtoname='"+soldtoname+"',";//售达方名称
					    upstr[24]="shipto='"+shipto+"',";//送达方
					    upstr[25]="shiptoname='"+shiptoname+"',";//送达方名称					    
					    upstr[26]="goodsgroup='"+goodsgroup+"',";//产品组
					    upstr[27]="shiptoaddress='"+shiptoaddress+"',";//送达城市
					    upstr[28]="addressdesc='"+addressdesc+"',";//详细地址
					    String descofloc = "空";
					    List loclist = baseJdbc.executeSqlForList("select descofloc from uf_lo_dgcardetail where id='"+cardetailid+"'");
					    if(loclist.size()>0){
					    	Map maploc = (Map)loclist.get(0);
					    	descofloc = StringHelper.null2String(maploc.get("descofloc"));
					    }
					    upstr[29]="descofloc='"+descofloc+"',";//主仓库名称
					    String printtype = "402864d14a1d679c014a1d8cf7b50005";//提入单
					    if(shipout.equals("40285a904a17fd75014a18e6bd85267c")){//当为运入标识时
					    	printtype = "402864d14a1d679c014a1d8cf7b50006";//物品入厂单
					    }
					    upstr[30]="printtype='"+printtype+"',";//打印单据类型
					    upstr[31]="vendorno='"+vendorno+"',";//供应商代码
					    upstr[32]="vendorname='"+vendorname+"' ";//供应商名称
					    //主表字段写入完成
					    for(int j=0;j<33;j++){
					    	upsql1 = upsql1 + upstr[j];
					    }
					    upsql = upsql + upsql1 + upsql2;
					    baseJdbc.update(upsql);
					    /**
					     * 更新装卸计划明细中提入单号pondno
					     */
					    if(listn.size()>0){
					    	for(int k=0;k<listn.size();k++){
					    		Map mapn = (Map)listn.get(k);
					    		String idstr = StringHelper.null2String(mapn.get("id"));	
							    String upsqlno = "update uf_lo_loaddetail set pondno='"+ladingno+"' where id='"+idstr+"'";
							    baseJdbc.update(upsqlno);					    		
					    	}
					    }
		        		//提入单 主表结束
					    /**
					     * 插入明细
					     */
					    String indsql = "insert into uf_lo_ladingdetail(id,requestid,runningno,ordertype,goodsgroup,isself,materialno,materialdesc,deliverdnum,yetloadnum,leftloadnum,salesunit,divvyfee,divvyexpfee,soldto,soldtoname,shipto,shiptoname,vendorno,vendorname,shiptoaddress,addressdesc,cardetailid) "+namesql;
//					    System.out.println(indsql);
					    baseJdbc.update(indsql);
					    String sqle = "select id,requestid from uf_lo_ladingdetail where requestid ='"+requestid+"'";
					    List liste = baseJdbc.executeSqlForList(sqle);
					    if(liste.size()>0){
					    	for(int m=0;m<liste.size();m++){
					    		Map mapm = (Map)liste.get(m);
							    String upindsql = "update uf_lo_ladingdetail set id='"+IDGernerator.getUnquieID()+"',requestid='"+newstrid+"' where id='"+StringHelper.null2String(mapm.get("id"))+"'";
							    baseJdbc.update(upindsql);					    		
					    	}
					    }

					    
		        	}
		        }	     		 
	     	}
	}

/**
 * 取得字段自动编号
 * @param formula
 * @param id
 * @param len
 * @return
 */
	private String  getNo(String formula,String id,int len)
	{
            //if(fieldvalue!=null&&!fieldvalue.equals("")&&!fieldvalue.equals(formula))
            //return;
            Date newdate = new Date();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
            SimpleDateFormat sdf1 = new SimpleDateFormat("MM");
            SimpleDateFormat sdf2 = new SimpleDateFormat("dd");

            formula = formula.replaceAll("YYYY", new SimpleDateFormat("yyyy").format(newdate));
            formula = formula.replaceAll("MM", new SimpleDateFormat("MM").format(newdate));
            formula = formula.replaceAll("DD", new SimpleDateFormat("dd").format(newdate));
            formula = formula.replaceAll("YY", new SimpleDateFormat("yy").format(newdate));

           String o = NumberHelper.getSequenceNo(id, len);
                    
        return formula+o;
	}

}
