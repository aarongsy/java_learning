package weaver.interfaces.tw.xiyf.sap.twytjk.action;
 

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
 * @ClassName: YTFKExecuteBapi 
 * @Description: 盈通费用报销调用sap类
 * @author xiyufei
 * @date 2014-6-18 上午11:23:51 
 *
 */
public class YTJKExecuteBapi {

	
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
	public static String YtjkReturnSap(List list,String status){
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
						JKBean JKBean = (JKBean) list.get(i);
						JCoTable.appendRow();
						JCoTable.setRow(i);     
						JCoTable.setValue("BUKRS",  Util.null2String(JKBean.getJkrgsdm()));
						JCoTable.setValue("GJAHR",  Util.null2String(JKBean.getNf()));
						JCoTable.setValue("ERDAT",  Util.null2String(JKBean.getZdrq()));
						JCoTable.setValue("ZOABXD",  Util.null2String(JKBean.getJkdh()));  
						JCoTable.setValue("ZUSR_CREATE",Util.null2String(JKBean.getJkr()));
						JCoTable.setValue("WAERS",  Util.null2String(JKBean.getBzdm()));
						JCoTable.setValue("ZCHKSTAT",  Util.null2String(JKBean.getShhzt())); 
						JCoTable.setValue("ZEXPCLAIM",  Util.null2String(JKBean.getJkje()));  
						JCoTable.setValue("ZDJLX",  Util.null2String(JKBean.getDjlx())); 
						JCoTable.setValue("SGTXT1",  Util.null2String(JKBean.getBz()));
						JCoTable.setValue("ZYSBM_HEAD",  Util.null2String(JKBean.getBxrbm()));
						JCoTable.setValue("ZFKFS",  Util.null2String(JKBean.getFkfsdm()));
						JCoTable.setValue("BKTXT",  Util.null2String(JKBean.getJksy()));
						//
						bb.writeLog("报销公司代码:"+Util.null2String(JKBean.getJkrgsdm()));
						bb.writeLog("年份:"+Util.null2String(JKBean.getNf()));
						bb.writeLog("创建日期:"+Util.null2String(JKBean.getZdrq()));
						bb.writeLog("OA报销单号:"+Util.null2String(JKBean.getJkdh()));  
						bb.writeLog("费用产生人（借款人）:"+Util.null2String(JKBean.getJkr()));
						bb.writeLog("币种代码:"+Util.null2String(JKBean.getBzdm()));
						bb.writeLog("审核状态:"+Util.null2String(JKBean.getShhzt())); 
						bb.writeLog("借款金额合计:"+Util.null2String(JKBean.getJkje()));
						bb.writeLog("回传单据类型:"+Util.null2String(JKBean.getDjlx()));
						bb.writeLog("抬头文本:"+Util.null2String(JKBean.getJksy()));
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
			List.add(new JKBean());
			YtjkReturnSap(List, "");
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}
