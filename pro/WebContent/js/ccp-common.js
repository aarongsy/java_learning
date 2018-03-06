	/* 
        * 获得时间差,时间格式为 年-月-日 小时:分钟:秒 或者 年/月/日 小时：分钟：秒 
        * 其中，年月日为全格式，例如 ： 2010-10-12 01:00:00 
        * 返回精度为：秒，分，小时，天
        */

        function GetDateDiff(startTime, endTime, diffType) {
            //将xxxx-xx-xx的时间格式，转换为 xxxx/xx/xx的格式 
            startTime = startTime.replace(/\-/g, "/");
            endTime = endTime.replace(/\-/g, "/");

            //将计算间隔类性字符转换为小写
            diffType = diffType.toLowerCase();
            var sTime = new Date(startTime);      //开始时间
            var eTime = new Date(endTime);  //结束时间
            //作为除数的数字
            var divNum = 1;
            switch (diffType) {
                case "second":
                    divNum = 1000;
                    break;
                case "minute":
                    divNum = 1000 * 60;
                    break;
                case "hour":
                    divNum = 1000 * 3600;
                    break;
                case "day":
                    divNum = 1000 * 3600 * 24;
                    break;
                default:
                    break;
            }
            return parseInt((eTime.getTime() - sTime.getTime()) / parseInt(divNum));
        }

		Number.prototype.add = function(arg){   
    var r1,r2,m;   
    try{r1=this.toString().split(".")[1].length}catch(e){r1=0}   
    try{r2=arg.toString().split(".")[1].length}catch(e){r2=0}   
    m=Math.pow(10,Math.max(r1,r2))   
    return (this*m+arg*m)/m   
}   
 
//减法   
Number.prototype.sub = function (arg){   
    return this.add(-arg);   
}   
 
//乘法   
Number.prototype.mul = function (arg)   
{   
    var m=0,s1=this.toString(),s2=arg.toString();   
    try{m+=s1.split(".")[1].length}catch(e){}   
    try{m+=s2.split(".")[1].length}catch(e){}   
    return Number(s1.replace(".",""))*Number(s2.replace(".",""))/Math.pow(10,m)   
}   
 
//除法   
Number.prototype.div = function (arg){   
    var t1=0,t2=0,r1,r2;   
    try{t1=this.toString().split(".")[1].length}catch(e){}   
    try{t2=arg.toString().split(".")[1].length}catch(e){}   
    with(Math){   
        r1=Number(this.toString().replace(".",""))   
        r2=Number(arg.toString().replace(".",""))   
        return (r1/r2)*pow(10,t2-t1);   
    }   
}  