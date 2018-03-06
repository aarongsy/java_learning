var data={
	'name':'测试项目',
	'tasks':[{
		'id':'1',
		'wbs':'1',
		'name':'<a href=#>测试任务1</a>',
		'percent':'100',
		'manager':'项目经理',
		'start':'2011-02-08',
		'finish':'2011-02-10'
	},
	{
		'id':'2',
		'wbs':'2',
		'name':'测试任务2',
		'percent':'50',
		'manager':'项目经理',
		'start':'2011-02-11',
		'finish':'2011-02-18',
		'children':[{
			'id':'2.1',
			'wbs':'2.1',
			'name':'测试任务2.1',
			'percent':'100',
			'manager':'项目经理',
			'start':'2011-02-11',
			'finish':'2011-02-15'
		},
		{
			'id':'2.2',
			'wbs':'2.2',
			'name':'测试任务2.2',
			'percent':'0',
			'manager':'项目经理',
			'start':'2011-02-16',
			'finish':'2011-02-18',
			'children':[{
				'id':'2.2.1',
				'wbs':'2.2.1',
				'name':'测试任务2.2.1',
				'percent':'0',
				'manager':'项目经理',
				'start':'2011-02-16',
				'finish':'2011-02-17'
			},
			{
				'id':'2.2.2',
				'wbs':'2.2.2',
				'name':'测试任务2.2.2',
				'percent':'0',
				'manager':'项目经理',
				'start':'2011-02-17',
				'finish':'2011-02-18'
			}]
		}]
	},
	{
		'id':'3',
		'wbs':'3',
		'name':'测试任务3',
		'percent':'0',
		'manager':'项目经理',
		'start':'2011-02-18',
		'finish':'2011-02-20'
	}]
};
var project,treetable;
function $(id){
	return document.getElementById(id);
}
function initWBS(name){
	treetable = new TreeTable(name);
	project = new Project(data);
	treetable.loadTask(project.tasks,1);
}
