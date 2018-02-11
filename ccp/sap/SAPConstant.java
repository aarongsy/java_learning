package weaver.interfaces.tw.xiyf.sap;
/**
 * 
 * @ClassName: SAPConstant 
 * @Description: sap常量类
 * @author xiyufei
 * @date 2014-6-17 上午11:01:53 
 *
 */
public class SAPConstant {
	public static  final String  S_STATU_T = "T";//sap驳回
	public static final String  S_STATU_L = "L";//sap通过
	
	public static  final String  ZDN_STATUS_F = "42";//开票sap驳回
	public static final String  ZDN_STATUS_P = "";//开票sap通过
	
	public static  final String  JS_STATUS_T = "E0005";//结算sap驳回
	public static final String  JS_STATUS_L = "E0003";//结算sap通过
	
	public static  final String  JS_RECALL_STATUS_T = "E0003";//结算撤回sap驳回
	public static final String  JS_RECALL_STATUS_L = "E0004";//结算撤回sap通过
}
