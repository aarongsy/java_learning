package com.eweaver.app.autotask;

import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;

public class updategyszz {
	public void doAction(){

		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		System.out.println("auto start GYSZZ......");
        //供应商资质合格
		String sql = "update uf_oa_gyszz  set pdjg='40285a8d4fbaabf8014fbf02d88515c9'  " +
				"where zzyxrq<(select to_char(sysdate,'yyyy-mm-dd') from dual) " +
				"and pdjg='40285a8d4fbaabf8014fbf02d88515c8'";
		System.out.println(sql);
		baseJdbc.update(sql);
		
		
       	System.out.println("auto END GYSZZ......");
		
        
	}
}
