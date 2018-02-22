<?php
	include "/var/www/html/dbconn.php";
	$body = file_get_contents('php://input');
	$postVars = json_decode($body, true);
	$comments = $postVars['comments'];
	$pickupID = $postVars['pickupID'];
	$fail = $postVars['fail'];
	$stmt = $dbh->prepare('INSERT INTO completedPickups SELECT *, current_timestamp AS timeCollected, :comments AS comments, :fail AS failed FROM pickups WHERE pickupID = :pickupID');
	$stmt->bindParam(':pickupID', $pickupID);
	$stmt->bindParam(':comments', $comments);
	$stmt->bindParam(':fail', $fail);
	$stmt->execute();
	$stmt = $dbh->prepare('DELETE FROM pickups WHERE pickupID = :pickupID');
	$stmt->bindParam(':pickupID', $pickupID);
	$stmt->execute();
?>