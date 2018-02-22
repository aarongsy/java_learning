<?php
	include "dbconn.php";
	
	$fUsername = $_POST['username'];
	$stmt = $dbh->prepare('SELECT userID, emailAddress, firstName, lastName, password FROM userdata WHERE emailAddress = :fUsername');
	$stmt->bindParam(':fUsername', $fUsername);
	$stmt->execute();
	if($stmt->rowCount() == 0)
	{
		header('Location: login.php');
		exit();
	}
	$stmt = $stmt->fetch();
	if(password_verify($_POST['password'], $stmt['password']))
	{
		session_start();
		echo "Correct Password";
		$_SESSION['userID'] = $stmt['userID'];
		$_SESSION['firstName'] = $stmt['firstName'];
		$_SESSION['lastName'] = $stmt['lastName'];
		header('Location: user/index.php');
	}
	else
	{
		echo "Incorrect Password";
		header('Location: login.php?error=1');
	}
	echo "End of File";
?>