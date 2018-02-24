1：此方法使用java自带wsimport工具生成webservice客户端代码

2：命令写法wsimport -s F:\test -p com.service http://localhost:8080/sms/services/sendMsg?wsdl

3：命令参数
	F:\test 					指定本地目标文件的生成路径
	com.service					指定生成的java文件的包结构
	http://localhost:8080/sms/services/sendMsg?wsdl	要解析的WS地址

4：将生成的java包直接引入工程或者打成jar包引入工程进行调用