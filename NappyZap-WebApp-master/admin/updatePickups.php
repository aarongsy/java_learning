<?php
	include "/var/www/html/dbconn.php";
	$stmt = $dbh->prepare('INSERT INTO metrics (orders, totalUsers) VALUES ((SELECT COUNT(*) FROM completedPickups WHERE date(timeScheduled) = CURDATE()), (SELECT COUNT(*) FROM userdata))');
	$stmt->execute();
?>