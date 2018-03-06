<%@ page import="com.eweaver.indagate.service.IndagatecontentService" %>
<%@ page import="com.eweaver.indagate.model.Indagatecontent" %>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<%
 pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";
    String requestid=StringHelper.null2String(request.getParameter("requestid"));
    String contentid=StringHelper.null2String(request.getParameter("contentid"));
    IndagatecontentService indagatecontentService =(IndagatecontentService)BaseContext.getBean("indagatecontentService");
    Indagatecontent indagatecontent=new Indagatecontent();
    if(!StringHelper.isEmpty(contentid)){
        indagatecontent=indagatecontentService.getIndagatecontent(contentid);
    }

%>
  <head>

   <script type="text/javascript" src="<%= request.getContextPath()%>/js/jquery-latest.pack.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
   <script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>
      <script type="text/javascript">
            Ext.onReady(function(){
            Ext.QuickTips.init();
        <%if(!pagemenustr.equals("")){%>
            var tb = new Ext.Toolbar();
            tb.render('pagemenubar');
        <%=pagemenustr%>
        <%}%>
            });
      </script>
  </head>
  <body>
  <div id="pagemenubar" style="z-index:100;"></div>
	<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.indagate.servlet.IndagateAction?action=addcontent" name="EweaverForm" method="post">
    <table width="98%" border="0" align="center" cellpadding="5" cellspacing="1" bgcolor="#5C99DC">
    <input type="hidden" id="isubjectid" name="isubjectid" value="<%=requestid%>" >
    <input type="hidden" id="contentid" name="contentid" value="<%=contentid%>" >
       <tr bgcolor="#FFFFFF">
         <td class="Info_Title" width="18%" align="center">调查主题: </td>
         <td class="Info_Title" width="82%">
           <input name="objsubject" type="text" size="90" maxlength="100" value="<%=StringHelper.null2String(indagatecontent.getObjsubject())%>">
         </td>
       </tr>
       <tr bgcolor="#FFFFFF">
         <td align="center">选项类型:</td>
         <td>
              <%
                 int type=indagatecontent.getOptiontype().intValue();
                 int max = NumberHelper.string2Int(indagatecontent.getMaxoption(),0);
                 int min = NumberHelper.string2Int(indagatecontent.getMinoption(),0);
                  String checked1="";
                  String checked2="";
                  if(type==2){
                      checked2="checked";
                  }else{
                       checked1="checked";
                  }
              %>
             <input name="optiontype" type="radio" value="1"  <%=checked1%> onclick="javascript:changdiv('0');">
           单选　
             <input type="radio" name="optiontype" value="2" <%=checked2%> onclick="javascript:changdiv('1');"> 多选　
    </td>
       </tr>
       <tr bgcolor="#FFFFFF">
             <td width="18%" align="center"> </td>
            <td width="82%"  >
                <% int count=indagatecontent.getOptioncount().intValue();%>
           调查选项数：
                <%
                if(StringHelper.isEmpty(contentid)){
                %>
                <select name="optioncount" id="optioncount">

             <option value="1">1</option>

             <option value="2">2</option>

             <option value="3">3</option>

             <option value="4">4</option>

             <option value="5">5</option>

             <option value="6">6</option>

             <option value="7">7</option>

             <option value="8">8</option>

             <option value="9">9</option>

             <option value="10">10</option>

             <option value="11">11</option>

             <option value="12">12</option>

             <option value="13">13</option>

             <option value="14">14</option>

             <option value="15">15</option>

             <option value="16">16</option>

             <option value="17">17</option>

             <option value="18">18</option>

             <option value="19">19</option>

             <option value="20">20</option>

             <option value="21">21</option>

             <option value="22">22</option>

             <option value="23">23</option>

             <option value="24">24</option>

             <option value="25">25</option>

             <option value="26">26</option>

             <option value="27">27</option>

             <option value="28">28</option>

             <option value="29">29</option>

             <option value="30">30</option>

             <option value="31">31</option>

             <option value="32">32</option>

             <option value="33">33</option>

             <option value="34">34</option>

             <option value="35">35</option>

             <option value="36">36</option>

             <option value="37">37</option>

             <option value="38">38</option>

             <option value="39">39</option>

             <option value="40">40</option>

             <option value="41">41</option>

             <option value="42">42</option>

             <option value="43">43</option>

             <option value="44">44</option>

             <option value="45">45</option>

             <option value="46">46</option>

             <option value="47">47</option>

             <option value="48">48</option>

             <option value="49">49</option>

             <option value="50">50</option>

           </select>
           <div id="optiondiv" <%if(type!=2){ %>style="display:none;"<%}else{%>style="display:block;"<%} %>>
            选择区间数：<input type="text" name="minoption" value="<%=min==0?"":""+min %>" id="minoption" size="5" onblur="javascript:checkNumber(this,'min');"/> -
            <input type="text" name="maxoption" value="<%=max==0?"":""+max %>" id="maxoption" size="5" onblur="javascript:checkNumber(this,'max');"/> 
           </div>
           <%}else{%>
                  <input id="optioncount" name="optioncount" value="<%=count%>"  class="InputStyle2" readonly="true">
                   <div id="optiondiv" <%if(type!=2){ %>style="display:none;"<%}else{%>style="display:block;"<%} %>>
		            选择区间数：<input type="text" name="minoption" value="<%=min==0?"":""+min %>" id="minoption" size="5" onblur="javascript:checkNumber(this,'min');"/> -
		            <input type="text" name="maxoption" value="<%=max==0?"":""+max %>" id="maxoption" size="5" onblur="javascript:checkNumber(this,'max');"/> 
		           </div>
                <%}%>
          </td>
       </tr>
         <tr bgcolor="#FFFFFF">
                 <td width="18%" align="center"> </td>
                <td width="82%"  >

                    <input type="checkbox" id="isotherinput" name="isotherinput" onclick="CheckOther(this)"<%if(indagatecontent.getIsotherinput().intValue()==1){%> checked="true" value="1" <%}%>>其他输入
              </td>
             </tr>
     </table>
     </form>
     <br> <br><br>

</form>
<script language="javascript">
    function onSubmit(){
        document.EweaverForm.submit();

    }
    function CheckOther(obj){
     if(obj.checked){
         document.all('isotherinput').value="1";
     }else{
         document.all('isotherinput').value="0";

     }
    }
    
    function changdiv(temp){
    	if(temp=='0'){
    		document.getElementById("optiondiv").style.display="none";
    	}else{
    		document.getElementById("optiondiv").style.display="block";
    	}
    }
    
    function checkNumber(num,tag){  
    	var number =  num.value+"";
    	if(number!=""){
    	    if(num.value==0){
    	       alert("区间范围不能为0！请重新输入！");
        	   num.value="";
        	   return;
    	    }else{
		        if(!(/^(([1-9]\d*)|\d)(\d{1,2})?$/).test(number.toString())){
		        	 alert("输入了非法数字！请重新输入！");
		        	 num.value="";
		        	 return;
		        }else{
		            var optioncount = parseInt(document.getElementById("optioncount").value);
		        	var parem_num = parseInt(number);
		        	if(tag=='min'){
		        		var maxnum = parseInt(document.getElementById("maxoption").value);
		        		if(optioncount<parem_num){
		        		    alert("最小区间数不能大于选项总数！");
		        		    num.value="";
		        			return;
		        		}
		        		if(maxnum && maxnum!="" && parem_num>maxnum){
		        			alert("最小区间数不能大于最大区间数！");
		        			num.value="";
		        			return;
		        		}
		        	}
		        	if(tag=='max'){
		        		var minnum=parseInt(document.getElementById("minoption").value);
		        		if(optioncount<parem_num){
		        		    alert("最大区间数不能大于选项总数！");
		        		    num.value="";
		        			return;
		        		}
		        		if(minnum && minnum!="" && parem_num<minnum){
		        			alert("最大区间数不能小于最小区间数！");
		        			num.value="";
		        			return;
		        		}
		        	}
		        }
	        }
        }
    }
</script>
  </body>
</html>
