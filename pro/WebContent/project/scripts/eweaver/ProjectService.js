//所有browser框的url保存在这里
var REQUESTID = {
		people: '402881e70bc70ed1010bc75e0361000f',
		department: '402881e60bfee880010bff17101a000c',
		mutualitypeople: '402881eb0bd30911010bd321d8600015',
		contractname: '2c91a0302aa21947012aa229396d0003'
};
//所有的下拉列表的ID保存在这里
var SELECTID = {
		model: '2c91a84e2aa7236b012aa73722720004',		//任务模式
		RiskLevel: '2c91a0302aa21947012aa236d030001c',	//风险等级
		Pri: '2c91a0302aa21947012aa22f5f760004',		//重要程度
		Status: '2c91a0302aa21947012aa2325769000e',		//任务状态
		zhurenwu: '2c91a84e2aa7236b012aa737d8930006',	//主任务
		jiedian: '2c91a84e2aa7236b012aa737d8930007',	//子节点
		zixiangmu: '2c91a84e2aa7236b012aa737d8930005',	//子项目
		subject: '2c91a0302aa6def0012aa8a11052074d'		//所属专业
}
//分解主任务的校验字段
var VALIDFIELDS_FENJIE_ZHU=[
        ['Name','名称'],
 		['Start','预计开始时间'],
 		['Finish','预计结束时间'],
 		['Subject','所属专业'],
 		['Pri','重要程度'],
 		['MasterType','任务类型']
];
//模板的校验字段
var VALIDFIELDS_MOBAN_ZHU=[
        ['Name','名称']
  		//['Subject','所属专业'],
  		//['Pri','重要程度'],
  		//['MasterType','任务类型']
 ];
var ProjectService = {
    dataUrl: '/ServiceAction/com.eweaver.ganttmap.action.GanttAction',
    get: function(params, successFn, failFn){
        
        Edo.util.Ajax.request({            
            url: this.dataUrl,
            params: params,
            onSuccess: function(text){   
        		var o = Edo.util.Json.decode(text);
                if(o.error == 0){
                    if(successFn) successFn(o.result);
                }else{
                    if(failFn) failFn(o.errormsg, o.error);    
                }                
            },
            onFail: function(err){
                if(failFn) failFn('网络错误', err);
            }
        });
    },
    set: function(params, successFn, failFn){
        
        Edo.util.Ajax.request({            
            url: this.dataUrl,
            type: 'post',
            params: params,
            onSuccess: function(text){
                var o = Edo.util.Json.decode(text);
                
                if(o.error == 0){
                    if(successFn) successFn(o.result);
                }else{
                    if(failFn) failFn(o.errormsg, o.error);    
                }     
            },
            onFail: function(err){
                if(failFn) failFn(err);
            }
        });
    }
};

/**
 * DataService，提供从后台数据提供的json数据
 * @param method 	需要后台提供获取数据的方法
 * @param nodeId	当前节点的ID，返回的数据既是当前节点下所有的数据条
 * @param isFindChild 是否遍历孩子节点的所有子节点
 * @param callback	回调函数，函数中参数一是 返回的数据
 * @return	不返回任何数据
 */
function loadNodes(method,nodeId, isFindChild, callback){
	if (isFindChild)
		Edo.MessageBox.loading("加载数据中");
    ProjectService.get(
        {
        	projectId: ProjectUID,
        	method: method,
            taskId: nodeId,
            isFindChild: isFindChild
        },  
        function(data){
        	if(callback) callback(data);
        	if(isFindChild)
        		Edo.MessageBox.hide();
        }, 
        function(msg, err){            
            alert(msg);
            if(isFindChild)
        		Edo.MessageBox.hide();
        }
    );
}

/**
 * 仅用作加载子节点
 * @param method	需要调用的action方法
 * @param subNodeId 任务类型的ID
 * @param callback	回调函数，参数中提供一个data的回参数
 * @return
 */
function loadSubNodes(params,callback){
	Edo.MessageBox.loading("正在加载节点中");
    Edo.util.Ajax.request({            
        url: '/ServiceAction/com.eweaver.ganttmap.action.SubNodeAction',
        params: params,
        onSuccess: function(text){   
    		var o = Edo.util.Json.decode(text);
            if(o.error == 0){
                if(callback) callback(o.result);
            }else{
            	alert(o.error);  
            }                
        },
        onFail: function(err){
        	alert('网络错误');
        }
    });
    Edo.MessageBox.hide();
}
/**
 * 获取项目下所有的数据,其实就是简化版本的loadNodes
 * @return
 * @deprecated
 */
function loadProject(){
    Edo.MessageBox.loading("加载项目数据");
    ProjectService.get(
        {
        	method: 'getProject',
            project: ProjectUID
        },  
        function(data){
            dataProject = new Edo.data.DataGantt(data);
            project.set('data', dataProject);   
            Edo.MessageBox.hide();
        }, 
        function(msg, err){            
            alert(msg);
            Edo.MessageBox.hide();
        }
    );
}
/**
 * 查找基础数据的信息
 * @param refid	基础对象的ID
 * @return	数组，第一个字段保存所选择数据的ID，第二个字段保存所选择数据的表现形式
 */
function getBaseInfo(refid,callback){
	var id=openDialog('/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='+refid);
	if(!id)	return;
	if(id[0]=='0'){
		//project.tree.cancelEdit();
		id[0]="";
		id[1]="";
	}
	var start=id[1].indexOf('>',0)+1;
	var end =id[1].indexOf('<',1);
	if (end>1){
		id[1]=id[1].substring(start,end);
	}
	if (callback){
		callback(id);
	}
	project.data.endChange(); 
	
}
function getOffice(key,callback){
	var sql ="select ID,OBJNAME from Orgunit where ID=(Select orgid From humres where ID='"+key+"')";
	Ext.Ajax.request({
	    url:"/ServiceAction/com.eweaver.base.DataAction?sql="+sql,
	    sync:true,                        
	    success: function(res) {
	        var doc=res.responseXML;
	        var root = doc.documentElement;
	        var pos = root.text.indexOf('_');
	        if(callback)
	        	callback([root.text.substring(0,pos),root.text.substring(pos+2)]);
	    }
	});
}
function getSubject(key,callback){
	var sql ="select extselectitemfield7 from humres where ID='"+key+"'";
	Ext.Ajax.request({
	    url:"/ServiceAction/com.eweaver.base.DataAction?sql="+sql,
	    sync:true,                        
	    success: function(res) {
	        var doc=res.responseXML;
	        var root = doc.documentElement;
	        if(callback)
	        	callback(root.text);
	    }
	});
}
/**
 * 通过javscript的闭包加载不同的select下拉框数据
 * @param key
 * @return
 */
function b(key){
	function result(){
		loadSubNodes({
			masterType: key,
			method: 'getSubNodes'
			},
			function(data){
				selectProject[key] = data;
			}
		);
	}
	return result;
}
/**
 * 获取有父ID的下拉选择框
 * @param key	父选择的KeyID
 * @return
 */
function c(key){
	function result(){
		loadSubNodes({
			masterType: SELECTID.model,
			pid: key,
			method: 'getSelectOperation'
			},
			function(data){
				data.unshift({ID:null,OBJNAME:''});
				selectProject[key] = data;
			}
		);
	}
	return result;
}
/**
 * 检测开始时间与结束时间的关系
 * @param startName
 * @param endName
 * @param isChangStart
 * @return
 */
function checkRelateTime(startName,endName,isChangStart){
	var start = new Date(Date.parse(get(startName).replace(/-/g, "/")));
	var finish = new Date(Date.parse(get(endName).replace(/-/g, "/")));
	if(start>finish){
		if(isChangStart){
			alert('开始时间不能大于结束时间');
			document.getElementById(startName).value = document.getElementById(endName).value;
		}else{
			alert('结束时间不能小于开始时间');
			document.getElementById(endName).value = document.getElementById(startName).value;
		}
	}
}

function validate(data,type){
	function validRecord(record,validfield){
		for(var j=0;j<validfield.length;j++){
			if(isEmpty(record[validfield[j][0]])){
				alert(validfield[j][1]+"不能为空！");
				return false;
			}
		}
		return true;
	}
	if(data){
		var validfields;
		switch(type){
			case 1: validfields=VALIDFIELDS_FENJIE_ZHU;break;
			case 2: validfields=VALIDFIELDS_MOBAN_ZHU;break;
		}
		for(var i=0;i<data.length;i++){
			if(data[i].Model == SELECTID.zhurenwu && !validRecord(data[i],validfields)){
				return false;
			}
			if(data[i].children && !validate(data[i].children,type)){
				return false;
			}
		}
		return true;
//		project.tree.data.iterateChildren(data, function(o){
//	    	if(o){
//	    		if(o.Model == SELECTID.zhurenwu){
//					validRecord(o);
//				}
//	    	}
//	    },project.tree);
	}
}
function isEmpty(str){
	str= str+"";
	if(str.trim()=="" || str=="undefined" || str=="null")
		return true;
	else
		return false;	
}
function loadXML(url, project, callback){
    Edo.MessageBox.loading('加载项目数据');
    Edo.util.Ajax.request({
        url: url,
        onSuccess: function(text){                                                    
            var data = Edo.util.XmlToJson(text);
            
            var dataProject = new Edo.data.DataProject(data);
            dataProject.set('plugins', [
                new Edo.project.EdoProject()                       
            ]);
            project.set('data', dataProject);
            
            Edo.MessageBox.hide();
            if(callback) callback();
        },
        onFail: function(err){
            alert("导入失败,错误码:"+err);
            Edo.MessageBox.hide();
        }
    });  
}
function checkSaveProject(dataProject, callback){
    if(!project.data.UID){
        if(confirm("当前项目未保存,是否保存到数据库?")){
            saveProject(project.data, function(){
                if(callback) callback();
            });
        }
    }else if(project.data.Tasks.changed){
        if(confirm("当前项目已被修改,是否保存到数据库?")){
            saveProject(project.data, function(){
                if(callback) callback();
            });
        } 
    }
    return true;
}