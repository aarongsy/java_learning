package com.eweaver.app.autotask;


import java.util.ArrayList;

import java.util.List;
import java.util.Map;


import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;

import com.eweaver.base.util.StringHelper;



public class gewaipin {
	public void doAction()
	{
	    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");

		List<String> requestid1 = new ArrayList();  //所有
		List<String> flowno1 = new ArrayList();
		List<Integer> no1 = new ArrayList<Integer>();
		List<Double> chujia1 = new ArrayList();
		//List<int> mingc1 = new ArrayList();


		List<String> requestid2 = new ArrayList();    //相同单号
		List flowno2 = new ArrayList();
		List<Integer> no2 = new ArrayList();
		List<Double> chujia2 = new ArrayList();
		//List<int> mingc2 = new ArrayList();

		
		List<String> requestid3 = new ArrayList(); //相同单号相同序号
		List<Integer> no3 = new ArrayList();   
		List<Double> chujia3 = new ArrayList();
		//List<int> mingc3 = new ArrayList();


	    String sql = "select a.requestid,a.flowno,a.starttime,a.endtime,b.no,b.chujia,b.mingc from uf_tr_jjtbpx b  left join uf_tr_jingjia a on b.requestid=a.requestid  where  0=(select isdelete from requestbase where id=a.requestid);";	
	    List list = baseJdbc.executeSqlForList(sql);
	    if (list.size() > 0)
	    {
	      for (int i = 0; i < list.size(); i++) {
	        Map map = (Map)list.get(i);
			
	        String requestid = StringHelper.null2String(map.get("requestid"));
			String flowno = StringHelper.null2String(map.get("flowno"));
			String starttime = StringHelper.null2String(map.get("starttime"));
			String endtime = StringHelper.null2String(map.get("endtime"));
			String no = StringHelper.null2String(map.get("no"));
			String chujia = StringHelper.null2String(map.get("chujia"));
			String mingc = StringHelper.null2String(map.get("mingc"));

			requestid1.add(requestid);
			flowno1.add(flowno);
			no1.add(Integer.parseInt(no));
			chujia1.add(Double.parseDouble(chujia));
			//mingc1.add(Integer.parseInt(mingc));

		  }
		}
		
		//过滤相同单号 flowno2
		for ( String flowno:flowno1 )
		{
			if (!flowno2.contains(flowno))
			{
				flowno2.add(flowno);
			}
		}

		if (flowno2.size() > 0 )
		{
			for ( int a = 0 ; a < flowno2.size() ; a++ )
			{
				for ( int b = 0 ; b < flowno1.size() ; b++ )
				{
					if (flowno1.get(b).equals(flowno2.get(a)))   //相同单号
					{

						requestid2.add(requestid1.get(b));
						no2.add(no1.get(b));
						chujia2.add(chujia1.get(b));
						//mingc2.add(mingc1.get(b));

					}
				}

				for ( int no:no2 )   
				{
					if (!no3.contains(no))
					{
						no3.add(no);
					}
				}

				for ( int c = 0 ; c < no3.size() ; c++ )
				{

					for ( int d = 0 ; d < no2.size() ; d++ )
					{
						if (no2.get(d).equals(no3.get(c)))    //相同单号相同序号
						{
							requestid3.add(requestid2.get(d));
							chujia3.add(chujia2.get(d));
							//mingc3.add(mingc2.get(d));
						}
					}

					String requestid = requestid3.get(0);
					Double chujia =  chujia3.get(0);
					//int mingc = mingc3.get(0); 

					for ( int i = 0 ; i < requestid3.size() - 1 ; i++)   //冒泡法排序 出价从大到小
					{
						for ( int j = 1 ; j < requestid3.size() - i ; j++ )
						{
							if ( chujia3.get(j-1).compareTo(chujia3.get(j)) < 0 )
							{
								requestid = requestid3.get(j);
								requestid3.set( ( j - 1 ), requestid3.get(j) );
								requestid3.set( j , requestid );
								chujia = chujia3.get(j);
								chujia3.set( ( j - 1 ), chujia3.get(j) );
								chujia3.set( j , chujia );
							}
						}
					}

					for ( int e = 0 ; e < requestid3.size() ; e++ )   //得出名次
					{

						String upsql="update uf_tr_jjtbpx set mingc='"+(e+1)+"' where requestid='"+requestid3.get(e)+"' and no='"+no3.get(c)+"'";	
						baseJdbc.update(upsql);
					}
				}

			}
		}


	}
}
