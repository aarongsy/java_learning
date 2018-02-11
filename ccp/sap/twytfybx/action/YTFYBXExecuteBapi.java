package weaver.interfaces.tw.xiyf.sap.twytfybx.action;
 

import java.util.ArrayList;
import java.util.List;

import weaver.conn.RecordSet;
import weaver.general.BaseBean;
import weaver.general.Util;
import weaver.hrm.resource.ResourceComInfo;
import weaver.interfaces.tw.xiyf.sap.SAPConn; 
 

import com.sap.conn.jco.JCoDestination; 
import com.sap.conn.jco.JCoException;
import com.sap.conn.jco.JCoField;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoRecordFieldIterator;
import com.sap.conn.jco.JCoStructure; 
import com.sap.conn.jco.JCoTable;
/**
 * 
 * @ClassName: YTFKExecuteBapi 
 * @Description: 盈通费用报销调用sap类
 * @author xiyufei
 * @date 2014-6-18 上午11:23:51 
 *
 */
public class YTFYBXExecuteBapi {

	
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
	public static String YtfybxReturnSap(List list,String status){
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
						FYBXBean FYBXBean = (FYBXBean) list.get(i);
						JCoTable.appendRow();
						JCoTable.setRow(i);     
						JCoTable.setValue("BUKRS",  Util.null2String(FYBXBean.getBxgsdm()));
						JCoTable.setValue("GJAHR",  Util.null2String(FYBXBean.getNf()));
						JCoTable.setValue("ERDAT",  Util.null2String(FYBXBean.getZdrq()));
						JCoTable.setValue("ZOABXD",  Util.null2String(FYBXBean.getBxdh()));
						JCoTable.setValue("ZJHLX",  Util.null2String(FYBXBean.getJhlx()));
						JCoTable.setValue("ZFJZS",  Util.null2String(FYBXBean.getFjzs()));
						JCoTable.setValue("ZUSR_CREATE",Util.null2String(FYBXBean.getBxr()));
						JCoTable.setValue("WAERS",  Util.null2String(FYBXBean.getBzdm()));
						JCoTable.setValue("ZCHKSTAT",  Util.null2String(FYBXBean.getShhzt()));
						JCoTable.setValue("ZUSR_LINKUAN",  Util.null2String(FYBXBean.getLkr())); 
						JCoTable.setValue("ZEXPCLAIM",  Util.null2String(FYBXBean.getJehj()));  
						JCoTable.setValue("ZDJLX",  Util.null2String(FYBXBean.getDjlx()));
						JCoTable.setValue("ZYSBM",  Util.null2String(FYBXBean.getBmdm()));
						JCoTable.setValue("ZFYYSXM",  Util.null2String(FYBXBean.getXmdm()));
						JCoTable.setValue("ZWRBTR",  Util.null2String(FYBXBean.getBxje()));
						JCoTable.setValue("SGTXT1",  Util.null2String(FYBXBean.getBz()));
						JCoTable.setValue("Z_SJ",  Util.null2String(FYBXBean.getZ_SJ()));
						JCoTable.setValue("BKTXT",  Util.null2String(FYBXBean.getSysm()));
						JCoTable.setValue("ZFKFS",  Util.null2String(FYBXBean.getZFKFS()));
						
						//
						bb.writeLog("报销公司代码:"+Util.null2String(FYBXBean.getBxgsdm()));
						bb.writeLog("年份:"+Util.null2String(FYBXBean.getNf()));
						bb.writeLog("创建日期:"+Util.null2String(FYBXBean.getZdrq()));
						bb.writeLog("OA报销单号:"+Util.null2String(FYBXBean.getBxdh()));
						bb.writeLog("计划类型:"+Util.null2String(FYBXBean.getJhlx()));
						bb.writeLog("附件张数:"+Util.null2String(FYBXBean.getFjzs()));
						bb.writeLog("费用产生人（报销人）:"+Util.null2String(FYBXBean.getBxr()));
						bb.writeLog("币种代码:"+Util.null2String(FYBXBean.getBzdm()));
						bb.writeLog("报销单审核状态:"+Util.null2String(FYBXBean.getShhzt()));
						bb.writeLog("领款人:"+Util.null2String(FYBXBean.getLkr()));
						bb.writeLog("报销金额合计:"+Util.null2String(FYBXBean.getJehj()));
						bb.writeLog("回传预算部门据类型:"+Util.null2String(FYBXBean.getBmdm()));
						bb.writeLog("费用报销类别代码:"+Util.null2String(FYBXBean.getXmdm()));
						bb.writeLog("报销金额:"+Util.null2String(FYBXBean.getBxje()));
						bb.writeLog("项目文本:"+Util.null2String(FYBXBean.getBz()));
						bb.writeLog("是否税金:"+Util.null2String(FYBXBean.getZ_SJ()));
						bb.writeLog("抬头:"+Util.null2String(FYBXBean.getSysm()));
						bb.writeLog("付款方式:"+Util.null2String(FYBXBean.getZFKFS()));
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
			List.add(new FYBXBean());
			YtfybxReturnSap(List, "");
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}
