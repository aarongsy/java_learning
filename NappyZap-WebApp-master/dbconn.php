<?php
	$user = "root";
	$pass = "magicmountain738818";
	try
	{
		$dbh = new PDO('mysql:host=localhost;dbname=nappyzaptest', $user);
	}
	catch(PDOException $e)
	{
		print "Error: " . $e->getMessage() . "<br/>";
    		die();
	}
?>