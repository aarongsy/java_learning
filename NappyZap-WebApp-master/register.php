<?php
	include "dbconn.php";
	//Registration of Email List
	$emailAddress = $_POST['emailAddress'];
	$stmt =  $dbh->prepare("INSERT INTO mailing emailAddress VALUES :emailAddress");
	$stmt->bindParam(":emailAddress", $emailAddress);
	$stmt->execute();
	Location("Header: index.php?success=1");
	//Registration of Users
	/*if(!$_POST['terms'])
	{
		header('location: signUp.php?error=6');
		exit();
	}
	$googleApiKey = "AIzaSyCidELs983Rk6lnhtGhPM9FnNp5UijlTA0";
	
	$required = array('emailAddress', 'password', 'title', 'firstName', 'lastName', 'street', 'postcode', 'binLocation');

	$email = $_POST['emailAddress'];
	$password = $_POST['password'];
	$conPassword = $_POST['conPassword'];
	$firstName = $_POST['firstName'];
	$lastName = $_POST['lastName'];
	$phoneNo = $_POST['phoneNo'];
	$childAge = $_POST['childAge'];
	$houseNo = $_POST['houseNo'];
	$street = $_POST['street'];
	$city = "London";
	$county = "Camden";
	$postcode = $_POST['postcode'];
	$binLocation= $_POST['binLocation'];
	$title = $_POST['title'];
	
	$address = $houseNo." ".$street.", ".$city.", ".$county.", ".$postcode;
	
	$address = urlencode($address);
	$request_url = "https://maps.googleapis.com/maps/api/geocode/json?address=".$address."&key=".$googleApiKey;
	$json = file_get_contents($request_url);
	$result = json_decode($json, true);
	$lat = $result['results'][0]['geometry']['location']['lat'];
	$lng = $result['results'][0]['geometry']['location']['lng'];
	foreach($required as $field)
	{			
		echo $field." is not empty</br>";
		if(empty($_POST[$field]))
		{
			header('location: signUp.php?error=2');
			exit();
		}
	}
	if($password != $conPassword)
	{
		header('location: signUp.php?error=4');
		exit();
	}
	echo "Passwords Match</br>";
	if (!filter_var($email, FILTER_VALIDATE_EMAIL)) 
	{
		header('location: signUp.php?error=5');
		exit();
	}
	echo 'Email valid</br>';
	$stmt = $dbh->prepare('SELECT * FROM userdata WHERE emailAddress=:email');
	$stmt->bindParam(':email', $email);
	$stmt->execute();
	echo 'Username check<br>';
	echo $stmt->rowCount();
	if($stmt->rowCount() > 0)
	{
		header('Location: signUp.php?error=1');
		exit();
	}
	else
	{
		try{
		$password = password_hash($password, PASSWORD_DEFAULT);
		$stmt2 = $dbh->prepare('INSERT INTO userdata (emailAddress, password, title, firstName, lastName, phoneNo, ageOfChild, houseNo, street, city, county, postcode, lat, lng, binLocation) VALUES (:emailAddress, :password, :title, :firstName, :lastName, :phoneNo, :ageOfChild, :houseNo, :street, :city, :county, :postcode, :lat, :lng, :binLocation)');
		$stmt2->bindParam(':emailAddress', $email);
		$stmt2->bindParam(':password', $password);
		$stmt2->bindParam(':title', $title);
		$stmt2->bindParam(':firstName', $firstName);
		$stmt2->bindParam(':lastName', $lastName);
		$stmt2->bindParam(':phoneNo', $phoneNo);
		$stmt2->bindParam(':ageOfChild', $childAge);
		$stmt2->bindParam(':houseNo', $houseNo);
		$stmt2->bindParam(':street', $street);
		$stmt2->bindParam(':city', $city);
		$stmt2->bindParam(':county', $county);
		$stmt2->bindParam(':postcode', $postcode);
		$stmt2->bindParam(':binLocation', $binLocation);
		$stmt2->bindParam(':lat', $lat);
		$stmt2->bindParam(':lng', $lng);
		$stmt2->execute();
		echo "Insertion successful";
		header("location: thankyou.html");
		}
		catch(PDOException $e)
		{
			print "Error: " . $e->getMessage() . "<br/>";
    		die();
		}
	}*/
?>