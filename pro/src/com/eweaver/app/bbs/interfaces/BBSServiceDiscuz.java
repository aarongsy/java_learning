package com.eweaver.app.bbs.interfaces;

import com.eweaver.app.bbs.dao.BBSConnection;
import com.eweaver.base.BaseContext;
import com.eweaver.base.security.model.Sysuser;
import com.eweaver.base.security.service.logic.SysuserService;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringHelper;
import com.eweaver.humres.base.model.Humres;
import com.eweaver.humres.base.service.HumresService;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BBSServiceDiscuz
  implements BBSService
{
  private SysuserService sysuserService = (SysuserService)BaseContext.getBean("sysuserService");
  private HumresService humresService = (HumresService)BaseContext.getBean("humresService");

  public int addBbsUser(String username) throws ClassNotFoundException, SQLException
  {
    Sysuser sysuser = this.sysuserService.getSysuserByLongonname(username);
    Humres humres = this.humresService.getHumresById(sysuser.getObjid());
    if (sysuser == null) {
      return 0;
    }
    String isql = "insert into cdb_members(uid         ,username                     ,password                    ,secques,gender,adminid,groupid,groupexpiry,extgroupids,regip       ,regdate,lastip,lastvisit,lastactivity,lastpost,posts,digestposts,oltime,pageviews,credits,extcredits1,extcredits2,extcredits3,extcredits4,extcredits5,extcredits6,extcredits7,extcredits8,email                  ,bday        ,sigstatus,tpp,ppp,styleid,dateformat,timeformat,pmsound,showemail,newsletter,invisible,timeoffset,newpm,accessmasks,editormode,customshow,xspacestatus)                         values(max(uid)+1 ,'" + sysuser.getLongonname() + "','" + sysuser.getLogonpass() + "',''     ,0     ,0      ,10     ,0          ,''         ,'127.0.0.1' ,''     ,''    ,''       ,''          ,''      ,1    ,0          ,0     ,0        ,0      ,0          ,0          ,0          ,0          ,0          ,0          ,0          ,0          ,'" + humres.getEmail() + "','0000-00-00',0        ,0  ,0  ,0      ,''        ,0         ,1      ,1        ,1         ,0        ,9999      ,0    ,0          ,2         ,26        ,0)";

    return BBSConnection.executeUpdate(isql);
  }

  public int deleteBbsUser(String username) throws ClassNotFoundException, SQLException
  {
    String dsql = "delete cdb_members where username='" + username + "'";
    return BBSConnection.executeUpdate(dsql);
  }

  public int initBbsUser() throws ClassNotFoundException, SQLException
  {
    List userList = this.humresService.getAllHumres();
    List list = new ArrayList();
    for (int i = 0; (userList != null) && (i < userList.size()); i++) {
      Map map = new HashMap();
      Humres humres = (Humres)userList.get(i);
      Sysuser sysuser = this.sysuserService.getSysuserByObjid(humres.getId());
      String maxid = BBSConnection.executeQueryMaxId("select id from cdb_member", "id");
      map.put("id", StringHelper.null2String(Integer.valueOf(NumberHelper.string2Int(maxid) + i)));
      map.put("username", sysuser.getLongonname());
      map.put("password", sysuser.getLogonpass());
      map.put("groupid", "10");
      map.put("regip", "127.0.0.1");
      map.put("email", humres.getEmail());
      map.put("bday", "0000-00-00");
      map.put("timeoffset", "9999");
      map.put("editormode", "2");
      map.put("customshow", "26");
      list.add(map);
    }
    String initsql = "insert into cdb_member(id,username,password,groupid,regip,email,bday,timeoffset,editormode,customshow) values(?,?,?,?,?,?,?,?,?,?)";
    return BBSConnection.execute(initsql, list);
  }

  public int updateBbsUserPass(String username) throws ClassNotFoundException, SQLException
  {
    Sysuser sysuser = this.sysuserService.getSysuserByLongonname(username);
    if (sysuser == null) {
      return 0;
    }
    String usql = "update cdb_members set password='" + sysuser.getLogonpass() + "' where usernmae='" + username + "'";
    return BBSConnection.executeUpdate(usql);
  }

  public List findBbsThreadinfo() throws ClassNotFoundException, SQLException {
    return BBSConnection.executeQuery("select t.tid,t.fid,t.author,FROM_UNIXTIME(t.dateline) dateline,t.subject,t.lastposter,FROM_UNIXTIME(t.lastpost) lastpost,f.name from pre_forum_thread t,pre_forum_forum f where t.fid=f.fid and t.displayorder not in ('-1','-2','-4') order by lastpost desc limit 5");
  }
}