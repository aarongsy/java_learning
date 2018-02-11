package weaver.interfaces.util;

import weaver.conn.RecordSetDataSource;
import weaver.general.Util;

public class ExpenseCompare extends ExpenseUtil{


	@Override
	public boolean compareExpense(String workflowid, String ccode,String cexpenseitemcode,String ly,double fyje,String iyear) {
		RecordSetDataSource rsds = new RecordSetDataSource("ZJK");
		rsds.execute("select centitycode from EF_EP_V_DEPT where ccode='"+ccode+"'");
		rsds.next();
		String centitycode  = Util.null2String(rsds.getString("centitycode"));
		rsds.execute("select dcurrentamount from EF_EP_V_EPBudget where iyear='"+iyear+"' and centitycode='"+centitycode+"' and cexpenseitemcode='"+cexpenseitemcode+"'");
		rsds.next();
		double dcurrentamount = Util.getDoubleValue(rsds.getString("dcurrentamount"),0);
		double amount = getExpenseAmount(ccode, cexpenseitemcode,ly);
		String amountA = BigDecimalCalculate.floatAdd(amount+"", fyje+"");
		
		if(BigDecimalCalculate.floatCompare(amountA, dcurrentamount+"")>0){
			return false;
		}else{
			return true;
		} 
	}

	
	@Override
	public boolean inExpense(int requestid, String workflowid) {
		// TODO Auto-generated method stub
		return false;
	}

	public double getExpenseAmount(String ccode,String cexpenseitemcode,String ly){
		RecordSetDataSource rsds = new RecordSetDataSource("ZJK");
		rsds.execute("select sum(amount) as amount from OAExpense where ccode='"+ccode+"' and cexpenseitemcode='"+cexpenseitemcode+"' and ly='"+ly+"'");
		rsds.next();
		double amount = Util.getDoubleValue(rsds.getString("amount"),0);
		return amount; 
	}
}
