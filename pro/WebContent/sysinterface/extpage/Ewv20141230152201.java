package com.eweaver.sysinterface.extclass;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.eweaver.base.*;
import com.eweaver.base.security.service.acegi.EweaverUser;
import com.eweaver.base.security.util.PermissionTool;
import com.eweaver.base.util.DateHelper;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringHelper;
import com.eweaver.sysinterface.base.Param;
import com.eweaver.sysinterface.javacode.EweaverExecutorBase;
import com.eweaver.workflow.form.model.FormBase;
import com.eweaver.workflow.form.service.FormBaseService;

public class Ewv20141230152201 extends EweaverExecutorBase {

	@Override
	public void doExecute(Param params) {

		String requestid = this.requestid;// 当前流程requestid
		String userId = BaseContext.getRemoteUser().getId();

		BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
		//获取自动编号
   	 	String no = NumberHelper.getSequenceNo("40285a904a9a15d3014a9a6e9bcb3589", 4);
   	 	Date newdate = new Date();
   	 	no = "LZSQ"+new SimpleDateFormat("yyyymm").format(newdate)+no;
		
		StringBuffer buffer = new StringBuffer(1024);
		List list = baseJdbc.executeSqlForList("select ca.reqno,ca.totalamount,ca.deadline,ca.concode,ca.conname,ca.company,ca.factory "
						+" from uf_lo_checkaccount ca "
						+" where ca.requestid = '"+requestid+"'");
		Map m = (Map)list.get(0);
		// 判断是否已经存在数据 不存在才做 insert 如存在 另处理
			buffer.append("insert into uf_lo_transitinvo");
			buffer.append("(id,requestid,invoiceno,reconcileno,amount,deadline,concode," +
					"conname,company,factory,state,schedule,createman,createdate) values");
			buffer.append("('").append(IDGernerator.getUnquieID()).append("',");
			buffer.append("'").append("$ewrequestid$").append("',");
			buffer.append("'").append(no).append("',");
			buffer.append("'").append(StringHelper.null2String(m.get("reqno"))).append("',");
			buffer.append("'").append(StringHelper.null2String(m.get("totalamount"))).append("',");
			buffer.append("'").append(StringHelper.null2String(m.get("deadline"))).append("',");
			buffer.append("'").append(StringHelper.null2String(m.get("concode"))).append("',");
			buffer.append("'").append(StringHelper.null2String(m.get("conname"))).append("',");
			buffer.append("'").append(StringHelper.null2String(m.get("company"))).append("',");
			buffer.append("'").append(StringHelper.null2String(m.get("factory"))).append("',");
			buffer.append("'40285a904a89741a014a8efde23955c2',");
			buffer.append("'40285a904a89741a014a8efe5e9355c7',");
			buffer.append("'").append(userId).append("',");
			buffer.append("to_char(sysdate,'yyyy-MM-dd))");

			FormBase formBase = new FormBase();
			String categoryid = "40285a904a89741a014a93a3c5c465e9";
			// 创建formbase
			formBase.setCreatedate(DateHelper.getCurrentDate());
			formBase.setCreatetime(DateHelper.getCurrentTime());
			formBase.setCreator(StringHelper.null2String(userId));
			formBase.setCategoryid(categoryid);
			formBase.setIsdelete(0);
			FormBaseService formBaseService = (FormBaseService) BaseContext.getBean("formbaseService");
			formBaseService.createFormBase(formBase);
			String insertSql = buffer.toString();
			insertSql = insertSql.replace("$ewrequestid$", formBase.getId());
			baseJdbc.update(insertSql);
			PermissionTool permissionTool = new PermissionTool();
			permissionTool.addPermission(categoryid, formBase.getId(), "uf_lo_transitinvo");
			
			List details = baseJdbc.executeSqlForList("select cd.principle,sum(cd.amount) amount from uf_lo_checkzxzgdetail cd where cd.requestid = '"+requestid+"' group by cd.principle");
			for (int i = 0; i < details.size(); i++) {
				Map dm = (Map)details.get(i);
				buffer = new StringBuffer(1024);

				buffer.append("insert into uf_lo_reqinvoice values(");
				buffer.append("(id,requestid,rowindex,company,comname,principle,salecode,amount) values");
				buffer.append("('").append(IDGernerator.getUnquieID()).append("',");
				buffer.append("'").append(formBase.getId()).append("',");
				buffer.append("'").append(StringHelper.specifiedLengthForInt(i,3)).append("',");
				buffer.append("'").append(StringHelper.null2String(m.get("company"))).append("',");
				buffer.append("(select objname from orgunit where isdelete = 0 and objno = '").append(StringHelper.null2String(m.get("company"))).append("'),");
				buffer.append("'").append(StringHelper.null2String(dm.get("principle"))).append("',");
				buffer.append("'',");
				buffer.append("'").append(StringHelper.null2String(dm.get("amount"))).append("')");
				
				baseJdbc.update(buffer.toString());
			}
			
			
	}
}
