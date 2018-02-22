<!DOCTYPE html>
<?php
	session_start();
	if(!isset($_SESSION['userID']))
	{
		header('Location: ../login.php');
	}
	$userID = $_SESSION['userID'];
	$firstName = $_SESSION['firstName'];
	$lastName = $_SESSION['lastName'];
?>
<html lang="en">
	<head>
		<title>NappyZap - Edit Profile</title>
		<link rel="shortcut icon" href="../images/logo002.png">
		<!-- Latest compiled and minified CSS -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
		<link rel="stylesheet" href="fixedHeightFooter.css">

		<!-- jQuery library -->
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>

		<!-- Latest compiled JavaScript -->
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
		
		<link rel="stylesheet" href="../bootstrapTheme.css">
		<meta charset="utf-8"> 
		<meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
	<body style="margin-bottom:175px;>
		<div id="mainWrapper">
		<!--Error Check-->
	<?php 
	if(ISSET($_GET['confirm']))
	{
		$errorcode = $_GET['confirm'];
		switch ($errorcode) 
		{
			case 1:
				echo '<div id="warning" class="alert alert-success">Information successfully updated!</div>';
				break;
			case 2:
				echo '<div id="warning" class="alert alert-danger">All fields were not filled, please make sure all fields are filled before submitting.</div>';
				break;
		}
	}
	?>
			<nav class="navbar navbar-default">
					<div class="navbar-header">
						<a class="navbar-brand" href="index.php"><span class="glyphicon glyphicon-home"></span></a>
					</div>
					<div>
						<ul class="nav navbar-nav">
							<li><a href="pickups.php">Pickups</a></li>
							<li class="active"><a href="editProfile.php">Edit Profile</a></li>
							<li><a href="logout.php">Logout</a></li>
						</ul>
					</div>
					<div class="container-fluid col-md-offset-10">
						<?php
							echo "<p style='color: white; text-align: center; margin-top: 10px;'>Logged In As: ".$firstName." ".$lastName."</p>";
						?>
					</div>
			</nav>
			<div id="mainWrapper" class="container">
				<form role="form" id="registration" class="form-horizontal" action="updateUser.php" method="POST">
					<p>For the purposes of this pilot, we will only be allowing contact information to be changed.</p>
					<?php
					include '../dbconn.php';
					$stmt = $dbh->prepare("SELECT phoneNo, houseNo, city, street, postcode, binLocation FROM userdata WHERE userID = :userID");
					$stmt->bindParam(":userID", $userID);
					$stmt->execute();
					$stmt = $stmt->fetch();
					echo '
					<div class="form-group">
						<label for="phoneNo" class="control-label col-sm-2">Phone Number:</label>
						<div class="col-sm-10">
							<input type="text" name="phoneNo" class="form-control" maxlength="20" placeholder="Enter Contact Number" value="'.$stmt['phoneNo'].'">
						</div>
					</div>
					<div class="form-group">
						<label for="houseNo" class="control-label col-sm-2">House Number/Name:</label>
						<div class="col-sm-10">
							<input type="text" name="houseNo" class="form-control" maxlength="20" placeholder="Enter House name or Number" value="'.$stmt['houseNo'].'">
						</div>
					</div>
					<div class="form-group">
						<label for="street" class="control-label col-sm-2">Street:*</label>
						<div class="col-sm-10">
							<input type="text" name="street" class="form-control maxlength="20" placeholder="Enter Street Name" value="'.$stmt['street'].'">
						</div>
					</div>
					<div class="form-group">
						<label for="postcode" class="control-label col-sm-2">Postcode:*</label>
						<div class="col-sm-10">
							<input type="text" name="postcode" class="form-control" maxlength="15" placeholder="Enter Postcode" value="'.$stmt['postcode'].'">
						</div>
					</div>'?>
					<div class="form-group">
						<label for="binLocation" class="control-label col-sm-2">Where will your Bin be located?*:</label>
						<div class="col-sm-10">
							<select name="binLocation" class="form-control">
								<option <?php if (strcmp($stmt['binLocation'], "FrontGarden") == 0) {echo 'selected';} ?> value="FrontGarden">Front Garden</option>
								<option <?php if (strcmp($stmt['binLocation'], "SideOfHouse") == 0) {echo 'selected';} ?> value="SideOfHouse">Side of House</option>
								<option <?php if (strcmp($stmt['binLocation'], "InFrontBuilding") == 0) {echo 'selected';} ?>value="InFrontBuilding">In front of the building</option>
								<option <?php if (strcmp($stmt['binLocation'], "phone") == 0) {echo 'selected';} ?>value="phone">Phone on collection, bin kept inside</option>
								<option <?php if (strcmp($stmt['binLocation'], "other") == 0) {echo 'selected';} ?>value="other">Other</option>
							</select>
						</div>
					</div>
					<button type="submit" class="btn btn-primary col-sm-offset-2">Update Information</button>
				</form>
			</div>
		</div>
	</body>
</html>
<script>
	$( document ).ready(function() {
		$("#warning").slideDown();
		$("#warning").delay(2000).slideUp();
	});
</script>