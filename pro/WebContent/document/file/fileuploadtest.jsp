<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<html>
  <head>
  </head>
  <body>
	<form name="EweaverForm" method="post">
		<table class=noborder>
			<!-- 列宽控制 -->
			<colgroup>
        		<col width="15%">
        		<col width="35%">
        		<col width="15%">
        		<col width="35%">
        	</colgroup>
        	<tbody>       	
        	<tr>
          		<td class="FieldName" nowrap><%=labelService.getLabelName("402881ec0bdc2afd010bdc60ae910011")%></td>
          		<td class="FieldValue">
          			<button type="button" class=Browser onclick="javascript:getBrowser('/document/file/fileuploadbrowser.jsp?mode=2','attach','attachspan','0');"></button>
             		<span id="attachspan"></span><br>
             		<input type="text" style="WIDTH: 99%;" name="attach" value=""/>
          			
          		</td>
        	</tr>
        </tbody>
      </table>
   </form>
 <!--调用browser -->
 <script>
function getBrowser(viewurl,inputname,inputspan,isneed){
    var id;
    try{
    id=openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(inputspan).innerHTML = id[1];
    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }
</script>	
	</body>
</html>
