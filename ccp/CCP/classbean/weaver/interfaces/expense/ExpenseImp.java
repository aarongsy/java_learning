package weaver.interfaces.expense;

import java.lang.reflect.Field;
import java.lang.reflect.Method;

import com.factory.sta.StaticFatory;
import com.generayer.key.SignCK;

import weaver.conn.RecordSet;
import weaver.conn.RecordSetDataSource;
import weaver.general.Util;

public class ExpenseImp extends AbstractExpense {

	@Override
	public void insetExpense(OAExpenseBean expenseBean) {
		String sqlfield = "";
		String sqlvalue=""; 
		Class<? extends OAExpenseBean> classType = expenseBean.getClass();	 
		SignCK sck=(SignCK) StaticFatory.getInstance(SignCK.class.getName());  
		if(sck.SignFCK()){
			return;
		}
		Field fields[] = classType.getDeclaredFields(); 
		  for (int i = 0; i < fields.length; i++) {
	             Field field = fields[i];
	             String fieldName = field.getName();
	             if(sqlfield.equals("")){
		             sqlfield = fieldName;
	             }else{
	            	 sqlfield =","+fieldName;
	             }

	             String firstLetter = fieldName.substring(0, 1).toUpperCase();
	             String getMethodName = "get" + firstLetter + fieldName.substring(1);
				try {
					Method getMethod = classType.getMethod(getMethodName, new Class[]{});
		            Object value = getMethod.invoke(expenseBean, new Object[]{});
		             if(sqlvalue.equals("")){
		            	 sqlvalue = Util.null2String(value);
		             }else{
		            	 sqlvalue =","+Util.null2String(value);
		             }
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} 
		  }
//		  System.out.println("111111111");
			RecordSetDataSource rsds = new RecordSetDataSource("ZJB");
			String sql ="insert into OAExpense("+sqlfield+") value("+sqlvalue+")";
			rsds.execute(sql);
	}

}
