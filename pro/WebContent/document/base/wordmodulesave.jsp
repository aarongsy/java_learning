<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%LabelService labelService = (LabelService)BaseContext.getBean("labelService");%>
<html>
<%
    String attachid = StringHelper.null2String(request.getParameter("attachid"));
%>
<body onload="initObject();">
<div style="POSITION: relative;width:100%;height:660;OVERFLOW:hidden;">
							<object id="WebOffice" style="POSITION: relative;top:-20" width=100% height=680 classid="clsid:23739A7E-5741-4D1C-88D5-D50B18F7C347" codebase="/oa/plugin/iWebOffice2003.ocx#version=6,6,0,0">
								<param name="WebUrl" value="http://localhost:8080/oa/ServiceAction/com.eweaver.document.base.servlet.OfficeServerAction?ATTACHID=<%=attachid%>">
								<param name="RecordID" value="">
								<param name="Template" value="">
								<param name="FileName" value="">
								<param name="FileType" value=".doc">
								<param name="UserName" value="4028804d1a7cad09011a7d4c56e5001d">
								<param name="EditType" value="-1,0,1,1,1,1,0">
								<param name="PenColor" value="#FF0000">
								<param name="PenWidth" value="1">
								<param name="Print" value="0">
								<param name="ShowToolBar" value="0">
								<param name="ShowMenu" value="0">
							</object>
							</div>
</body>
</html>
<script type="text/javascript">
function initObject(){
    document.WebOffice.WebOpen();
    var word=document.WebOffice.WebObject;
    var name=word.Bookmarks.Item(1).Name;
    var bookmark=word.Bookmarks.Item(1).Range;
//    bookmark.Text='zxf';
//    document.WebOffice.WebObject.Bookmarks.Add(name,bookmark);
    inlineShape=bookmark.InlineShapes.AddPicture('d:/test.gif');
    imgShape = inlineShape.ConvertToShape();
    imgShape.Select();
    imgShape.AlternativeText = "<%=labelService.getLabelNameByKeyId("40288035248eb3e801248ed18432000c")%>";//盖章
    imgShape.PictureFormat.TransparentBackground = true;
    imgShape.PictureFormat.TransparencyColor = 16777215;
    imgShape.Fill.Visible = false;
    imgShape.WrapFormat.Type = 3;
    imgShape.ZOrder(4);
   // word.Protect(2);
    //
    var myl = word.Shapes.AddLine(100, 60, 305, 60);
    myl.Line.ForeColor = 255;
    myl.Line.Weight = 2;
    var myl1 = word.Shapes.AddLine(326, 60, 520, 60);
    myl1.Line.ForeColor = 255;
    myl1.Line.Weight = 2;

    var myRange = word.Range(0, 0);
    myRange.Select();

    var mtext = "★";
    word.Application.Selection.Range.InsertAfter(mtext + "\n");
    var myRange = word.Paragraphs(1).Range;
    myRange.ParagraphFormat.LineSpacingRule = 1.5;
    myRange.font.ColorIndex = 6;
    myRange.ParagraphFormat.Alignment = 1;
    myRange = word.Range(0, 0);
    myRange.Select();
    mtext = "<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980037")%>";//泛微发01号
    word.Application.Selection.Range.InsertAfter(mtext + "\n");
    myRange = word.Paragraphs(1).Range;
    myRange.ParagraphFormat.LineSpacingRule = 1.5;
    myRange.ParagraphFormat.Alignment = 1;
    myRange.font.ColorIndex = 1;

    mtext = "<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980038")%>";//泛微电子政务文件
    word.Application.Selection.Range.InsertAfter(mtext + "\n");
    myRange = word.Paragraphs(1).Range;
    myRange.ParagraphFormat.LineSpacingRule = 1.5;

    //myRange.Select();
    myRange.Font.ColorIndex = 6;
    myRange.Font.Name = "<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980039")%>";//仿宋_GB2312
    myRange.font.Bold = true;
    myRange.Font.Size = 50;
    myRange.ParagraphFormat.Alignment = 1;

    word.PageSetup.LeftMargin = 70;
    word.PageSetup.RightMargin = 70;
    word.PageSetup.TopMargin = 70;
    word.PageSetup.BottomMargin = 70;
    word.Protect(2);
}
</script>