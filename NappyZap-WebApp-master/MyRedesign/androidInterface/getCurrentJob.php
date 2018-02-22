<?php
	header('Content-type: application/json');
	include "../dbconn.php";
	$apiKey = "AIzaSyCidELs983Rk6lnhtGhPM9FnNp5UijlTA0";
	$body = file_get_contents('php://input');
	$postVars = json_decode($body, true);
	//if(isset($postVars['driverID']){
		$driverID = $postVars['driverID'];
		$curLat = $postVars['lat'];
		$curLng = $postVars['lng'];
		$ids = array();
		//Searches database in intervals of 2 hours, so the older orders are attended first.
		$maxTime = 6*60; 				//Maximum cut off point for delivery. 
		$searchInterval = 2*60; 			//Interval for time categories
		$stmt;
		do{
			$stmt = $dbh->prepare('SELECT pickups.pickupID, userdata.lat, userdata.lng FROM pickups INNER JOIN userdata ON pickups.userID = userdata.userID WHERE pickups.driverID IS NULL AND TIMESTAMPDIFF(MINUTE, pickups.timeScheduled, NOW()) >'.$maxTime.';');
			$stmt->execute();
			$maxTime = $maxTime - $searchInterval;
		}while(($stmt->rowCount() == 0) && ($maxTime >= 0));

		//Uses the Google Maps Distance Matrix API to get distances from Driver to pickups
		$request_url = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=".$curLat.",".$curLng."&destinations=";
		$trigger = 0;
		foreach($stmt as $row){
			if($trigger==1){
				$request_url = $request_url."|";	
			}
			$trigger = 1;
			$request_url = $request_url.$row['lat'].",".$row['lng'];
			array_push($ids, $row['pickupID']);
		}
		$request_url = $request_url."&units=imperial&key=".$apiKey;
		$json = file_get_contents($request_url);
		$result = json_decode($json, true);
		
		//Gets the shortest distance from driver to pickup.
		$shortestID;
		$shortestDist = 9999999999999;
		for($i = 0; $i<sizeOf($ids); $i++)
		{
			$dist = $result['rows'][0]['elements'][$i]['duration']['value'];
			if($shortestDist > $dist)
			{
				$shortestDist = $dist;
				$shortestID = $ids[$i];
			}
		}	
		//Assigns the closest pickup to the driver.
		$stmt = $dbh->prepare('UPDATE pickups SET driverID = :driverID WHERE pickupID=:pickupID');
		$stmt->bindParam(':driverID', $driverID);
		$stmt->bindParam(':pickupID', $shortestID);
		$stmt->execute();
		
		//Gets all data regarding pickups and user whom requested it, package it to JSON object, returns it to android device.
		$stmt = $dbh->prepare('SELECT userdata.title, userdata.firstName, userdata.lastName, userdata.phoneNo, userdata.lat, userdata.lng, userdata.binLocation, userdata.houseNo, userdata.street, userdata.city, userdata.county, userdata.postcode, pickups.pickupID, pickups.details, pickups.sizeOfPickup FROM userdata INNER JOIN pickups ON userdata.userID = pickups.userID WHERE pickupID=:pickupID;');
		$stmt->bindParam(':pickupID', $shortestID);
		$stmt->execute();
		$results = $stmt->fetch();
		echo json_encode($results);
	//}
?>