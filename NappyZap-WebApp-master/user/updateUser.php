<?php
	session_start();
	if(!isset($_SESSION['userID']))
	{
		header('Location: ../login.php');
	}
	//Check if any fields are blank
	$required = array('street', 'postcode', 'binLocation');
	foreach($required as $field)
	{			
		echo $field." is not empty</br>";
		if(empty($_POST[$field]))
		{
			header('location: editProfile.php?confirm=2');
			exit();
		}
	}
	$userID = $_SESSION['userID'];
	$phoneNo = $_POST['phoneNo'];
	$houseNo = $_POST['houseNo'];
	$street = $_POST['street'];
	$postcode = $_POST['postcode'];
	$binLocation = $_POST['binLocation'];
	$address = $houseNo." ".$street."Camden, London, ".$postcode;
	$address = urlencode($address);
	$request_url = "https://maps.googleapis.com/maps/api/geocode/json?address=".$address."&key=".$googleApiKey;
	$json = file_get_contents($request_url);
	$result = json_decode($json, true);
	$lat = $result['results'][0]['geometry']['location']['lat'];
	$lng = $result['results'][0]['geometry']['location']['lng'];
	include '../dbconn.php';
	//Prepares update statement
	$stmt = $dbh->prepare("UPDATE userdata SET lat = :lat, lng = :lng, phoneNo = :phoneNo, houseNo = :houseNo, street = :street, postcode = :postcode, binLocation = :binLocation WHERE userID = :userID");
	$stmt->bindParam(":phoneNo", $phoneNo);
	$stmt->bindParam(":houseNo", $houseNo);
	$stmt->bindParam("street", $street);
	$stmt->bindParam(":postcode", $postcode);
	$stmt->bindParam(":binLocation", $binLocation);
	$stmt->bindParam(":userID", $userID);
	$stmt->bindParam(":lat", $lat);
	$stmt->bindParam(":lng", $lng);
	$stmt->execute();
	header("Location: editProfile.php?confirm=1");
?>