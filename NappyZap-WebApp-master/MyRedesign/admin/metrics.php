<!DOCTYPE html>
<?php
	session_start();
	if(!isset($_SESSION['admin']))
	{
		header('Location: login.php');
	}
?>
<html lang="en">
	<head>
		<style style="text/css">
			#hoverTable td{ 
			padding:7px; border:#4e95f4 1px solid;
			}
			
			#hoverTable tbody tr:hover {
				background-color: #323299;
				color: #ffffff;
			}
		</style>
		<link rel="shortcut icon" href="../images/logo002.png">
		<title>NappyZap - Admin Statistics</title>
		<!-- Latest compiled and minified CSS -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">

		<!-- jQuery library -->
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>

		<!-- Latest compiled JavaScript -->
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
		
		<link rel="stylesheet" href="../bootstrapTheme.css">
		<meta charset="utf-8"> 
		<meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
	<body>
			<nav class="navbar navbar-default">
					<ul class="nav navbar-nav">
						<li><a href="stats.php">Users</a></li>
						<li><a href="pickups.php">Pickups</a></li>
						<li class="active"><a href="metrics.php">Metrics</a></li>
						<li><a href="logout.php">Logout</a></li>
					</ul>
			</nav>
			<div class="container-fluid">
				<table id="hoverTable" class="table-striped col-md-5">
					<?php
						include "../dbconn.php"; 
						echo "<h2>Metrics</h2>";
						//Reads Total Pickups
						$stmt = $dbh->prepare('SELECT COUNT(*) AS totalPickups FROM completedPickups');
						$stmt->execute();
						$result = $stmt->fetch();
						echo "<h3>Total Orders: ".$result['totalPickups']."</h3>";
						
						//Gets Average Time to Pickup
						$stmt = $dbh->prepare('SELECT DATE_FORMAT(SEC_TO_TIME((AVG(TIME_TO_SEC(TIMEDIFF(timeCollected,timeScheduled))))),"%H:%i:%s") AS averageTime FROM completedPickups');
						$stmt->execute();
						$result = $stmt->fetch();
						echo "<h3>Average Time to Pickup: ".$result['averageTime']." (HH:MM:SS)</h3>";
						
						//Reads Metric Data into Table
						$stmt = $dbh->prepare('SELECT * FROM metrics ORDER BY date DESC LIMIT 30');
						$stmt->execute();
						echo "<thead>";
						echo "<tr>";
						echo "<th>Date</th>";
						echo "<th>Orders Placed</th>";
						echo "<th>Total Users</th>";
						echo "</tr>";
						echo "</thead>";
						echo "<tbody>";
						foreach($stmt as $row){
							echo "<tr>";
							echo "<td>".$row['date']."</td>";
							echo "<td>".$row['orders']."</td>";
							echo "<td>".$row['totalUsers']."</td>";
							echo "</tr>";
						}	
						echo "</tbody>";
					?>
				</table>
				<table id="hoverTable" class="table-striped col-md-6 col-md-offset-1">
					<?php
						//Reads User Orders Data into Table
						$stmt = $dbh->prepare('SELECT userdata.*, (SELECT COUNT(*) FROM completedPickups WHERE completedPickups.userID = userdata.userID) AS totalOrders FROM userdata INNER JOIN completedPickups ON userdata.userID = completedPickups.userID GROUP BY userdata.userID');
						$stmt->execute();
						echo "<thead>";
						echo "<tr>";
						echo "<th>Name</th>";
						echo "<th>Orders Placed</th>";
						echo "<th>Lat/Lng</th>";
						echo "</tr>";
						echo "</thead>";
						echo "<tbody>";
						foreach($stmt as $row){
							echo "<tr>";
							echo "<td>".$row['title']." ".$row['firstName']." ".$row['lastName']."</td>";
							echo "<td>".$row['totalOrders']."</td>";
							echo "<td>".$row['lat'].", ".$row['lng']."</td>";
							echo "</tr>";
						}	
						echo "</tbody>";
					?>
				</table>
			</div>
		</div>
		<script>
			jQuery(document).ready(function($) {
				$(".clickable-row").click(function() {
					$(this).data("href").modal();
				});
			});
		</script>

</html>