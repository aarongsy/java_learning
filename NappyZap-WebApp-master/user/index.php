<!DOCTYPE html>
<?php
	session_start();
	header('Location: pickups.php');
	$userID = $_SESSION['userID'];
	$firstName = $_SESSION['firstName'];
	$lastName = $_SESSION['lastName'];
?>
<html lang="en">
	<head>
		<title>NappyZap - My Profile</title>
		<link rel="shortcut icon" href="../images/logo002.png">
		<!-- Latest compiled and minified CSS -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
		<link rel="stylesheet" href="fixedHeightFooter.css">

		<!-- jQuery library -->
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>

		<!-- Latest compiled JavaScript -->
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
		<meta charset="utf-8"> 
		<meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
	<body style="margin-bottom:175px;>
		<div id="mainWrapper">
			<nav class="navbar navbar-default">
				<div class="container-fluid">
					<div class="navbar-header">
						<a class="navbar-brand" href="index.php"><img src="../images/logo002.png" style="max-width:40px; margin-top:-10px;"></a>
					</div>
					<div>
						<ul class="nav navbar-nav">
							<li class="active"><a href="index.php">Home</a></li>
							<li><a href="pickups.php">Pickups</a></li>
							<li><a href="editProfile.php">Edit Profile</a></li>
							<li><a href="logout.php">Logout</a></li>
						</ul>
					</div>
					<div class="container-fluid col-md-offset-10">
						<?php
							echo "<p stlye='text-align: center; margin-top: 10px;'>Logged In As: ".$firstName." ".$lastName."</p>";
						?>
					</div>
				</div>
			</nav>
			<div id="mainWrapper" class="container">
				
			</div>
		</div>
	</body>
</html>