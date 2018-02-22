<?php
	session_start();
	if(!isset($_SESSION['userID']))
	{
		header('Location: ../login.php');
	}
	//Check if any fields are blank
	$required = array('sizeOfPickup');
	foreach($required as $field)
	{			
		echo $field." is not empty</br>";
		if(empty($_POST[$field]))
		{
			header('location: pickups.php?confirm=2');
			exit();
		}
	}
	include "../dbconn.php";
	$userID = $_SESSION['userID'];
	$details = $_POST['details'];
	$sizeOfPickup = $_POST['sizeOfPickup'];
	if (date('H') >= 19) { 
		$stmt =  $dbh->prepare("INSERT INTO pickups (userID, details, sizeOfPickup, timeScheduled) VALUES (:userID, :details, :sizeOfPickup, TIMESTAMPADD(HOUR, 9, TIMESTAMPADD(DAY, 1, CURDATE())))");
		$stmt->bindParam(":userID", $userID);
		$stmt->bindParam(":details", $details);
		$stmt->bindParam("sizeOfPickup", $sizeOfPickup);
		$stmt->execute();
		header('Location: pickups.php?confirm=1');
	}
	elseif(date('H') < 7){
		$stmt =  $dbh->prepare("INSERT INTO pickups (userID, details, sizeOfPickup, timeScheduled) VALUES (:userID, :details, :sizeOfPickup, TIMESTAMPADD(HOUR, 9, DATE(CURDATE())))");
		$stmt->bindParam(":userID", $userID);
		$stmt->bindParam(":details", $details);
		$stmt->bindParam("sizeOfPickup", $sizeOfPickup);
		$stmt->execute();
		header('Location: pickups.php?confirm=1');
	}
	else{
		$stmt =  $dbh->prepare("INSERT INTO pickups (userID, details, sizeOfPickup) VALUES (:userID, :details, :sizeOfPickup)");
		$stmt->bindParam(":userID", $userID);
		$stmt->bindParam(":details", $details);
		$stmt->bindParam("sizeOfPickup", $sizeOfPickup);
		$stmt->execute();
		header('Location: pickups.php?confirm=1');
	}
?>