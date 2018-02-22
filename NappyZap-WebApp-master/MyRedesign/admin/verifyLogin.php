<?php
	include "dbconn.php";
	$username = "NicHamilton";
	$password = "magicmountain";
	$fUsername = $_POST['username'];
	$fPassword = $_POST['password'];
	if((strcmp($username, $fUsername) == 0)&&(strcmp($password, $fPassword) == 0))
	{
		session_start();
		$_SESSION["admin"] = 1;
		header('Location: stats.php');
	}
	else
	{
		header('Location: login.php');
	}
?>