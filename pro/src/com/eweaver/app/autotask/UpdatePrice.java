package com.eweaver.app.autotask;
import com.eweaver.base.*;
import com.eweaver.base.util.*;
import java.util.*;
import com.eweaver.interfaces.model.Dataset;
import com.eweaver.interfaces.workflow.RequestInfo;
import com.eweaver.interfaces.workflow.WorkflowServiceImpl;
import com.eweaver.interfaces.model.Cell;
public class UpdatePrice {

	public void doAction(){

		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		System.out.println("auto start JGZD......");
        //价格主档申请
		String sql = "update uf_oa_pricefileapps set vailideflag='40285a8f489c17ce01489c7f3d940189'  where effectivestart<=(select to_char(sysdate,'yyyy-mm-dd') from dual)";
		System.out.println(sql);
		baseJdbc.update(sql);
		sql="update uf_oa_pricefileapps set vailideflag='40285a8f489c17ce01489c7f5236018b'  where effectiveend is not null and effectiveend<(select to_char(sysdate,'yyyy-mm-dd') from dual)";
		System.out.println(sql);
		baseJdbc.update(sql);
		//未来生效
		sql="update uf_oa_pricefileapps set vailideflag=''  where effectivestart>(select to_char(sysdate,'yyyy-mm-dd') from dual)";
		System.out.println(sql);
		baseJdbc.update(sql);

		//价格主档汇总
		sql="update uf_oa_pricesummary set vailideflag='40285a8f489c17ce01489c7f3d940189' where effectivestart<=(select to_char(sysdate,'yyyy-mm-dd') from dual) and (isvalid='40285a8f489c17ce01489c7f3d940189' or isvalid is null)";
		System.out.println(sql);
		baseJdbc.update(sql);
		sql="update uf_oa_pricesummary set vailideflag='40285a8f489c17ce01489c7f5236018b' where effectiveend is not null and effectiveend<(select to_char(sysdate,'yyyy-mm-dd') from dual) and (isvalid='40285a8f489c17ce01489c7f3d940189' or isvalid is null)";
		System.out.println(sql);
		baseJdbc.update(sql);
		sql="update uf_oa_pricesummary set vailideflag='' where effectivestart>(select to_char(sysdate,'yyyy-mm-dd') from dual) and (isvalid='40285a8f489c17ce01489c7f3d940189' or isvalid is null)";
		System.out.println(sql);
		baseJdbc.update(sql);
			
       	System.out.println("auto END JGZD......");
		
        
	}


}
