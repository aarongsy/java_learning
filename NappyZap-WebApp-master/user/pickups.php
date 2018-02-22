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
		<style style="text/css">
			#hoverTable td{ 
			padding:7px; border:#4e95f4 1px solid;
			}
		</style>
		<title>NappyZap - Pickups</title>
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
			<?php 
				if(ISSET($_GET['confirm']))
				{
					$errorcode = $_GET['confirm'];
					switch ($errorcode) 
					{
						case 1:
							echo '<div id="warning" class="alert alert-success">Pickup Successfully Requested!</div>';
							break;
						case 2:
							echo '<div id="warning" class="alert alert-danger">Please ensure that you put a pickup size.</div>';
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
							<li class="active"><a href="pickups.php">Pickups</a></li>
							<li><a href="editProfile.php">Edit Profile</a></li>
							<li><a href="logout.php">Logout</a></li>
						</ul>
					</div>
					<div class="container-fluid col-md-offset-10">
						<?php
							echo "<p style='color: white; text-align: center; margin-top: 10px;'>Logged In As:"." ".$firstName." ".$lastName."</p>";
						?>
					</div>
			</nav>
			<div id="mainWrapper" class="container-fluid col-md-10 col-md-offset-1">
			<p>You may schedule 1 pickup per day. Pickup hours are between 9am and 9pm with last pickups being accepted at 7pm. Any pickups scheduled after 7pm will be first the following morning</p>
					<?php
						include "../dbconn.php"; 
						//Gets current pickup
						$stmt = $dbh->prepare('SELECT pickups.details, pickups.timeToPickup, pickups.timeScheduled, drivers.firstName, drivers.lastName FROM pickups LEFT JOIN drivers ON pickups.driverID = drivers.driverID WHERE pickups.userID = :userID');
						$stmt->bindParam(":userID", $userID);
						$stmt->execute();
						$stmt2 = $dbh->prepare('SELECT pickupID FROM completedPickups WHERE userID = :userID AND date(timeScheduled) = CURDATE() AND HOUR(timeScheduled) < 19');
						$stmt2->bindParam(":userID", $userID);
						$stmt2->execute();
						if($stmt2->rowCount() == 0){
							if($stmt->rowCount() != 0){
								echo "<h3>Your Current Pickup</h3>";
								foreach($stmt as $row){
									if(!is_null($row['firstName']))
									{
										echo "<p>Your collection will be made by ".$row['firstName']." ".$row['lastName']."</p><br>";
										echo "<p>Details: ".$row['details']."</p><br>";
										echo "<p>Our closest driver was ".gmdate("H:i:s", $row['timeToPickup'])." away from you, your pickup is en-route!</p><br>";
										echo "<p>Time Scheduled: ".$row['timeScheduled']."</p><br>";
									}
									else{
										echo "<p>Your collection hasn't been assigned a driver yet</p><br>";
										echo "<p>Details: ".$row['details']."</p><br>";
										echo "<p>Estimated Wait: You'll get a time estimate when we've assigned you a driver</p><br>";
										echo "<p>Time Scheduled: ".$row['timeScheduled']."</p><br>";
									}
									
								}
							}
							else{
								echo '<form role="form" id="login" class="form-horizontal" action="addPickup.php" method="POST">
									<div class="form-group">
										<label for="Details" class="control-label col-sm-2">Details: </label>
										<div class="col-sm-10">
											<input type="text" class="form-control" name="details" maxlength="50" placeholder="Any special instructions for the driver?"></input>
										</div>
									</div>
									<button type="submit" class="btn btn-primary col-sm-offset-2">Schedule New Pickup</button>
								</form>';
							}
						}
						else{
							echo "<h2 style='color: red;'>You've already had your pickup for today, check back tomorrow to schedule a new one.</h2>";
						}
						//Gets previous pickups
						$stmt = $dbh->prepare('SELECT completedPickups.details, completedPickups.comments, completedPickups.timeCollected, completedPickups.failed, drivers.firstName, drivers.lastName, (TIMEDIFF(timeCollected,timeScheduled)) AS timeTaken FROM completedPickups INNER JOIN drivers ON completedPickups.driverID = drivers.driverID WHERE completedPickups.userID = :userID ORDER BY timeScheduled DESC');
						$stmt->bindParam(":userID", $userID);
						$stmt->execute();
						echo "<table id='hoverTable' class='table-striped col-md-12 col-xs-12'>";
						echo "<h2>Most Recent Pickups</h2>";
						echo "<thead>";
						echo "<tr>";
						echo "<th>Driver</th>";
						echo "<th class='hidden-xs'>Details</th>";
						echo "<th class='hidden-xs'>Comments</th>";
						echo "<th class='hidden-xs'>Time Taken</th>";
						echo "<th>Time Collected</th>";
						echo "<th>Success</th>";
						echo "</tr>";
						echo "</thead>";
						echo "<tbody>";
						foreach($stmt as $row){
								echo "<tr>";
								echo "<td>".$row['firstName']." ".$row['lastName']."</td>";
								echo "<td class='hidden-xs'>".$row['details']."</td>";
								echo "<td class='hidden-xs'>".$row['comments']."</td>";
								echo "<td class='hidden-xs'>".($row['timeTaken'])."</td>";
								echo "<td>".$row['timeCollected']."</td>";
								if($row['failed'] == 0){
									echo "<td class='col-sm-1'><span class='glyphicon glyphicon-ok' style='color: #33cc33; text-align: center;'></span></td>";
								}
								else{
									echo "<td class='col-sm-1'><span class='glyphicon glyphicon-remove' style='color: #cc0000; text-align: center;'></span></td>";
								}
								echo "</tr>";
						}	
						echo "</tbody>";
						echo "</table>";
					?>
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