package weaver.interfaces.tw.xiyf.sap.twytcc.action;
 

import java.util.ArrayList;
import java.util.List;
 
import weaver.general.BaseBean;
import weaver.general.Util; 
import weaver.interfaces.tw.xiyf.sap.SAPConn;  
 

import com.sap.conn.jco.JCoDestination; 
import com.sap.conn.jco.JCoException;
import com.sap.conn.jco.JCoField;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoRecordFieldIterator; 
import com.sap.conn.jco.JCoTable;
/**
 * 
 * @ClassName: YTCLFBXExecuteBapi 
 * @Description: 盈通差路费报销调用sap类
 * @author xiyufei
 * @date 2014-6-18 上午11:23:51 
 *
 */
public class YTCLFBXExecuteBapi {

	
	private JCoRecordFieldIterator JCoRecordFieldIterator = null;
	private JCoField JCoField = null;
	private static JCoDestination destination = SAPConn.getJCoDestination();

/**
 * 
 * @Title: YtfkReturnSap 
 * @Description:  盈通付款(fk) 返回sap
 * @param @param workflowId
 * @param @param requestId
 * @param @param status
 * @param @return    设定文件 
 * @return String    返回类型 
 * @throws
 */
	public static String YtclfReturnSap(List list,String status){
		BaseBean bb = new BaseBean();
		String result = "";
		try {
			JCoFunction function = destination.getRepository().getFunction("ZFI_OA2SAP_BXD_YT");
 
			
				//if(SAPConstant.S_STATU_L.equals(status)){//status为L时返回合同信息
					JCoTable  JCoTable  = null;
//					RecordSet rs = new RecordSet();
//					rs.execute("select tablename from workflow_base a,workflow_bill b where a.formid=b.id and a.id="+workflowId);
//					rs.next();
//					String maintable = Util.null2String(rs.getString("tablename"));
//					rs.execute("select a.* from "+ maintable+" a,workflow_requestbase b where a.requestid=b.requestid and b.workflowid="+workflowId+" and a.requestid="+requestId+"");
//					rs.next();IT_OA_BXD  ZSOA_EXP_TRANSFER
	
					JCoTable  = function.getTableParameterList().getTable("IT_OA_BXD");
					for (int i = 0; i < list.size(); i++) {
						CLFBean CLFBean = (CLFBean) list.get(i);
						JCoTable.appendRow();
						JCoTable.setRow(i);     
						JCoTable.setValue("BUKRS",  Util.null2String(CLFBean.getGsdm()));
						JCoTable.setValue("GJAHR",  Util.null2String(CLFBean.getNf()));
						JCoTable.setValue("ERDAT",  Util.null2String(CLFBean.getZdrq()));
						JCoTable.setValue("ZOABXD",  Util.null2String(CLFBean.getBxdh()));  
						JCoTable.setValue("ZJHLX",  Util.null2String(CLFBean.getJhlx()));  
						JCoTable.setValue("ZFJZS",  Util.null2String(CLFBean.getFjzs()));
						JCoTable.setValue("ZUSR_CREATE",Util.null2String(CLFBean.getFycsr()));
						JCoTable.setValue("WAERS",  Util.null2String(CLFBean.getBzdm()));
						JCoTable.setValue("ZCHKSTAT",  Util.null2String(CLFBean.getShhzt())); 
						JCoTable.setValue("ZUSR_LINKUAN",  Util.null2String(CLFBean.getLkr())); 
						JCoTable.setValue("ZEXPCLAIM",  Util.null2String(CLFBean.getJehj()));  
						JCoTable.setValue("ZDJLX",  Util.null2String(CLFBean.getDjlx())); 
						JCoTable.setValue("ZYSBM", Util.null2String(CLFBean.getBmdm()));
						JCoTable.setValue("ZFYYSXM",  Util.null2String(CLFBean.getXmdm()));
						JCoTable.setValue("SGTXT1",  Util.null2String(CLFBean.getXm()));
						JCoTable.setValue("ZWRBTR",  Util.null2String(CLFBean.getJe()));
						JCoTable.setValue("BKTXT",  Util.null2String(CLFBean.getCcsy()));

						JCoTable.setValue("ZUSR_CREATE_ITEM",  Util.null2String(CLFBean.getBxr()));
						//
						bb.writeLog("报销公司代码:"+Util.null2String(CLFBean.getGsdm()));
						bb.writeLog("年份:"+Util.null2String(CLFBean.getNf()));
						bb.writeLog("创建日期:"+Util.null2String(CLFBean.getZdrq()));
						bb.writeLog("OA报销单号:"+Util.null2String(CLFBean.getBxdh()));  
						bb.writeLog("计划类型:"+Util.null2String(CLFBean.getJhlx()));  
						bb.writeLog("附件张数:"+Util.null2String(CLFBean.getFjzs()));  
						bb.writeLog("费用产生人（借款人）:"+Util.null2String(CLFBean.getFycsr()));
						bb.writeLog("币种代码:"+Util.null2String(CLFBean.getBzdm()));
						bb.writeLog("审核状态:"+Util.null2String(CLFBean.getShhzt())); 
						bb.writeLog("领款人:"+Util.null2String(CLFBean.getLkr()));
						bb.writeLog("金额合计:"+Util.null2String(CLFBean.getJehj()));
						bb.writeLog("单据类型:"+Util.null2String(CLFBean.getDjlx()));
						bb.writeLog("报销部门代码:"+Util.null2String(CLFBean.getBmdm()));
						bb.writeLog("费用报销类别代码:"+Util.null2String(CLFBean.getXmdm()));
						bb.writeLog("回传单据类型:"+Util.null2String(CLFBean.getDjlx()));
						bb.writeLog("项目:"+Util.null2String(CLFBean.getXm()));
						bb.writeLog("金额:"+Util.null2String(CLFBean.getJe()));
						bb.writeLog("报销人:"+Util.null2String(CLFBean.getBxr()));
						bb.writeLog("抬头:"+Util.null2String(CLFBean.getCcsy()));
					}
				 
					function.execute(destination);
					result =  function.getExportParameterList().getValue("EV_STATUS").toString(); 
					System.out.println("result="+result);
		} catch (JCoException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} // ZRFC_GET_CUSTDATA
		return result;
		
	}

	 

	public static void main(String[] a) {
		try{
			List  List = new ArrayList();
			List.add(new CLFBean());
			YtclfReturnSap(List, "");
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}
