<?php
	session_start();
	if(!isset($_SESSION['userID']))
	{
		header('Location: ../login.php');
		exit();
	}
	//Check if any fields are blank
	include "../dbconn.php";
	$userID = $_SESSION['userID'];
	$details = $_POST['details'];
	if (date('H') >= 19) { 
		$stmt =  $dbh->prepare("INSERT INTO pickups (userID, details, timeScheduled) VALUES (:userID, :details, TIMESTAMPADD(HOUR, 9, TIMESTAMPADD(DAY, 1, CURDATE())))");
		$stmt->bindParam(":userID", $userID);
		$stmt->bindParam(":details", $details);
		$stmt->execute();
		header('Location: pickups.php?confirm=1');
	}
	elseif(date('H') < 9){
		$stmt =  $dbh->prepare("INSERT INTO pickups (userID, details, timeScheduled) VALUES (:userID, :details, TIMESTAMPADD(HOUR, 9, DATE(CURDATE())))");
		$stmt->bindParam(":userID", $userID);
		$stmt->bindParam(":details", $details);
		$stmt->execute();
		header('Location: pickups.php?confirm=1');
	}
	else{
		$stmt =  $dbh->prepare("INSERT INTO pickups (userID, details) VALUES (:userID, :details)");
		$stmt->bindParam(":userID", $userID);
		$stmt->bindParam(":details", $details);
		$stmt->execute();
		header('Location: pickups.php?confirm=1');
	}
?>