/********************************************/
/* javascript Ajax Tree-Table v0.1 */
/********************************************/

/*定义Node类*/
function Node(){
	this.xmlhttp=null;
	this.rowId="";
	this.row = null;
	//this.gantt = null;
	this.img = null;
	this.objId = "";
	this.treeOrder = "0";
	this.treeLevel = "1";
	this.childrenNum = "0";
	this.nodeStatus = "-1";
	/*从后台调数据展开当前行的所有子节点*/
	//this.expandFromDB=function(){};
	return this;
}
Node.prototype.setData=function(rowId){
	this.xmlhttp=new Ajax();
	this.rowId=rowId;
	this.row = document.getElementById(rowId);
	//this.gantt = document.getElementById("gantt_"+rowId);
	this.img = document.getElementById("img_"+rowId);
	this.objId = this.row.objId;
	this.treeOrder = this.row.treeOrder;
	this.treeLevel = this.row.treeLevel;
	this.childrenNum = this.row.childrenNum;
	this.nodeStatus = this.row.nodeStatus;
}
Node.prototype.hide=function(){
	this.row.style.display = "none";
}
Node.prototype.show=function(){
	this.row.style.display = "";
}
/*收起当前行的所有子节点(若子节点也是展开状态，则将子节点也收起)*/
Node.prototype.collapse=function(){
	if(this.nodeStatus=="1"){
		//alert(this.childrenNum);
		for(var i=0;i<this.childrenNum;i++){
			var childNode=new Node();
			childNode.setData(this.rowId+"_"+i);
			childNode.hide();
			if(childNode.childrenNum>0){
				childNode.collapse();
			}
		}
		this.row.nodeStatus="0";
		
		this.img.src="/images/base/treetable/plus.gif";
	}
}
/*展开当前行的子节点(并展开以前展开的节点)*/
Node.prototype.expand=function(){
	if(this.nodeStatus=="0"){
		for(var i=0;i<this.childrenNum;i++){	
			var childNode=new Node();
			childNode.setData(this.rowId+"_"+i);
			childNode.show();
			childNode.expand();	
		}
		this.row.nodeStatus="1";
		this.img.src="/images/base/treetable/minus.gif";
	}
}

Node.prototype.nodeSelector=function(){

	if(this.nodeStatus==1){//节点处于展开状态	
		this.collapse();
	}
	if(this.nodeStatus==0){//节点处于收起状态
		this.expand();		
	}
	if(this.nodeStatus==-1){//节点处于未获取数据状态	
		this.expandFromDB();
	}
}
/*展开至指定层级的节点*/
Node.prototype.expandTo=function(level){
	if(this.treeLevel<level){
		if(this.childrenNum>0){
			this.expandFromDB();
			this.expand();
			for(var i=0;i<this.childrenNum;i++){		
				var childNode=new Node();
				childNode.setData(this.rowId+"_"+i);
				childNode.expandTo(level);				
			}
		}
	}else{
		this.collapse();
	}
}

