<?php
	session_start();
	if(!isset($_SESSION['admin']))
	{
		header('Location: login.php');
		exit();
	}
	include "../dbconn.php";
	if(isset($_POST['contentID'])){
		$id = $_POST['contentID'];
		$title = $_POST['title'];
		$content = $_POST['content'];
		$stmt = $dbh->prepare("UPDATE homePage SET title=:title, content=:content WHERE contentID = :contentID");
		$stmt->bindParam(":title", $title);
		$stmt->bindParam(":content", $content);
		$stmt->bindParam(":contentID", $id);
		$stmt->execute();
		header('Location: cms.php?success=1');
	}
	elseif(isset($_POST['delete'])){
		$id = $_POST['delete'];
		$stmt = $dbh->prepare("DELETE FROM homePage WHERE contentID=:contentID");
		$stmt->bindParam(":contentID", $id);
		$stmt->execute();
		header('Location: cms.php?success=2');
	}
	elseif(isset($_POST['opening'])){
		$content = $_POST['opening'];
		$stmt = $dbh->prepare("UPDATE homePage SET content=:content WHERE type = 0");
		$stmt->bindParam(":content", $content);
		$stmt->execute();
		header('Location: cms.php?success=3');
	}
	elseif(isset($_POST['add'])){
		$title = $_POST['title'];
		$content = $_POST['content'];
		$stmt = $dbh->prepare("INSERT INTO homePage (title, content, type) VALUES (:title, :content, 1)");
		$stmt->bindParam(":title", $title);
		$stmt->bindParam(":content", $content);
		$stmt->execute();
		header('Location: cms.php?success=4');
	}
?>