package weaver.interfaces.util;
/**
 * 
 * @ClassName: ExpenseUtil 
 * @Description: TODO
 * @author xiyufei
 * @date 2017-3-16 上午11:20:36 
 *
 */
public abstract  class  ExpenseUtil {
 /**
  * 
  * @Title: inExpense 
  * @Description: 预算持久化
  * @param @param requestid
  * @param @param workflowid
  * @param @return    设定文件 
  * @return boolean    返回类型 
  * @throws
  */
	public  abstract boolean inExpense(int requestid,String workflowid);
	/**
	 * 
	 * @Title: compareExpense 
	 * @Description: 验证预算超支
	 * @param @param workflowid
	 * @param @param ccode
	 * @param @param cexpenseitemcode
	 * @param @return    设定文件 
	 * @return boolean    返回类型 
	 * @throws
	 */
	public abstract boolean compareExpense(String workflowid,String ccode,String cexpenseitemcode,String ly,double fyje,String iyear);

}
