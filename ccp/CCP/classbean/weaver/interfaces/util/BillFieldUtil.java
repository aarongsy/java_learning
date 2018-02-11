package weaver.interfaces.util;

import java.util.HashMap;
import java.util.Map;

import weaver.conn.RecordSet;
import weaver.general.Util;
import weaver.general.BaseBean;

/**
 * 
 * 类描述：字段名称工具类 创建者： 项目名称： ecologyTest 创建时间： 2013-9-14 下午3:13:07 版本号： v1.0
 */
public class BillFieldUtil {

	public static String getResourceLevelName(String paramString1,
			String paramString2) {
		String[] array = Util.TokenizerString2(paramString2, "+");

		return "<a target='_self' href='/interface/htd/jzq/htd_cwgx_info.jsp?id="
				+ array[0] + "'>" + array[1] + "</a>";
	}

	/**
	 * 
	 * 方法描述 : 获取字段的ID 创建者：ocean 项目名称： ecologyTest 类名： CwUtil.java 版本： v1.0 创建时间：
	 * 2013-9-14 下午3:05:53
	 * 
	 * @param workFlowId
	 *            流程id
	 * @param num
	 *            明细表
	 * @return Map
	 */
	public static Map getFieldId(int formid, String num) {

		formid = Math.abs(formid);
		String sql = "";
		if ("0".equals(num)) {
			sql = "select b.id,fieldname,detailtable from workflow_billfield b ,workflow_base a where b.billid=-"
					+ formid
					+ " and a.formid=b.billid and  (detailtable is null or detailtable = '') ";
		} else {
			sql = "select b.id,fieldname,detailtable from workflow_billfield b ,workflow_base a where b.billid=-"
					+ formid
					+ " and a.formid=b.billid and detailtable='formtable_main_"
					+ formid + "_dt" + num + "'";
		}

		RecordSet rs = new RecordSet();
		rs.execute(sql);
		Map array = new HashMap();
		while (rs.next()) {
			array.put(
					Util.null2String(rs.getString("fieldname")).toLowerCase(),
					Util.null2String(rs.getString("id")));
		}
		return array;
	}

	/**
	 * 
	 * 方法描述 : 获取表单建模字段的ID 创建者：ocean 项目名称： ecologyTest 类名： CwUtil.java 版本： v1.0
	 * 创建时间： 2013-10-31 下午3:05:53
	 * 
	 * @param formid
	 *            表单id
	 * @param num
	 *            明细表
	 * @return Map
	 */
	public static Map getModeFieldId(int formid, String num) {

		formid = Math.abs(formid);
		String sql = "";
		if ("0".equals(num)) {
			sql = "select b.id,fieldname,detailtable from workflow_billfield b ,modeinfo a where b.billid=-"
					+ formid
					+ " and a.formid=b.billid and (detailtable is null or detailtable = '') ";
		} else {
			sql = "select b.id,fieldname,detailtable from workflow_billfield b ,modeinfo a where b.billid=-"
					+ formid
					+ " and a.formid=b.billid and detailtable='formtable_main_"
					+ formid + "_dt" + num + "'";
		}

		RecordSet rs = new RecordSet();
		rs.execute(sql);
		Map array = new HashMap();
		while (rs.next()) {
			array.put(
					Util.null2String(rs.getString("fieldname")).toLowerCase(),
					Util.null2String(rs.getString("id")));
		}
		return array;
	}

	/**
	 * 
	 * @Title: getlabelId
	 * @Description: TODO
	 * @param @param name 数据库字段名称
	 * @param @param formid 表单ID
	 * @param @param ismain 是否主表 0:主表 1：明细表
	 * @param @param num 明细表序号
	 * @param @return
	 * @return String
	 * @throws
	 */
	public static String getlabelId(String name, String formid, String ismain,
			String num) {
		String id = "";
		String sql = "";
		if ("0".equals(ismain)) {
			sql = "select b.id,fieldname,detailtable from workflow_billfield b ,workflow_base a where b.billid=-"
					+ formid
					+ " and a.formid=b.billid and lower(fieldname)='"
					+ name + "'";
		} else {
			sql = "select b.id,fieldname,detailtable from workflow_billfield b ,workflow_base a where b.billid=-"
					+ formid
					+ " and a.formid=b.billid and detailtable='formtable_main_"
					+ formid
					+ "_dt"
					+ num
					+ "' and lower(fieldname)='"
					+ name
					+ "'";
		}
		// System.out.println(sql);
		RecordSet rs = new RecordSet();
		rs.execute(sql);
		rs.next();
		id = Util.null2String(rs.getString("id"));
		return id;

	}

	public static String getLendMoney(String paramString1, String paramString2) {
		String[] array = Util.TokenizerString2(paramString2, "+");

		return "<a href='/workflow/request/ViewRequest.jsp?requestid="
				+ array[0] + "&isovertime=0'," + array[0]
				+ ")' target='_blank'>" + array[1] + "</a>";
	}
	
	public static String getFormtableFromReq(String requestid) {
		RecordSet rs = new RecordSet();
		String sql = "select b.formid from workflow_requestbase a,workflow_base b where a.workflowid = b.id and requestid = "
				+ requestid;
		rs.executeSql(sql);
		rs.next();
		String formTable = "formtable_main_" + Math.abs(rs.getInt("formid"));// 流程表名
		return formTable;
	}
	
	public static String getFormtableFromWfid(String workflowid) {
		RecordSet rs = new RecordSet();
		String sql = "select formid from workflow_base  where id="+ workflowid;
		rs.executeSql(sql);
		rs.next();
		String formTable = "formtable_main_" + Math.abs(rs.getInt("formid"));// 流程表名
		return formTable;
	}
}
