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
					<div class="navbar-header">
					</div>
					<ul class="nav navbar-nav">
						<li><a href="stats.php">Users</a></li>
						<li class="active"><a href="pickups.php">Pickups</a></li>
						<li><a href="metrics.php">Metrics</a></li>
						<li><a href="cms.php">Content Management</a></li>
						<li><a href="logout.php">Logout</a></li>
					</ul>
			</nav>
			<div class="container-fluid">
				<nav class="navbar table-choice col-md-12" style="border-bottom-color: white;">
					<ul class="nav navbar-nav" style="border-bottom-color: white;">
						<li class="table-chooser" id="current"><a>Current</a></li>
						<li class="table-chooser" id="completed"><a>Completed</a></li>
					</ul>
				</nav>
				<div class="col-md-12" id="current-table" style="display:none;">
					<table id="hoverTable" class="table-striped col-md-12">
						<?php
							include "../dbconn.php"; 
							$stmt = $dbh->prepare('SELECT * FROM pickups');
							$stmt->execute();
							echo "<h2>Pickups, Total: ".$stmt->rowCount()."</h2>";
							echo "<thead>";
							echo "<tr>";
							echo "<th>User ID</th>";
							echo "<th>Driver ID</th>";
							echo "<th>Details</th>";
							echo "<th>Time Estimate</th>";
							echo "<th>Time Placed</th>";
							echo "</tr>";
							echo "</thead>";
							echo "<tbody>";
							foreach($stmt as $row){
								echo "<tr>";
								echo "<td>".$row['userID']."</td>";
								echo "<td>".$row['driverID']."</td>";
								echo "<td>".$row['details']."</td>";
								echo "<td>".$row['timeToPickup']."</td>";
								echo "<td>".$row['timeScheduled']."</td>";
								echo "</tr>";
							}	
							echo "</tbody>";
						?>
					</table>
				</div>
				<div class="col-md-12" id="completed-table" style="display:none;">
					<table id="hoverTable" class="table-striped col-md-12">
						<?php
							include "../dbconn.php"; 
							$stmt = $dbh->prepare('SELECT *, (TIMEDIFF(timeCollected,timeScheduled)) AS timeTaken FROM completedPickups');
							$stmt->execute();
							echo "<h2>Completed Pickups, Total: ".$stmt->rowCount()."</h2>";
							echo "<thead>";
							echo "<tr>";
							echo "<th>User ID</th>";
							echo "<th>Driver ID</th>";
							echo "<th>Details</th>";
							echo "<th>Comments</th>";
							echo "<th>Time Taken</th>";
							echo "</tr>";
							echo "</thead>";
							echo "<tbody>";
							foreach($stmt as $row){
								echo "<tr>";
								echo "<td>".$row['userID']."</td>";
								echo "<td>".$row['driverID']."</td>";
								echo "<td>".$row['details']."</td>";
								echo "<td>".$row['comments']."</td>";
								echo "<td>".($row['timeTaken'])."</td>";
								echo "</tr>";
							}	
							echo "</tbody>";
						?>
					</table>
				</div>
			</div>
		</div>
		<script>
			var $prev;
			var $prevTable;
			$( ".table-chooser" ).click(function() {
				$($prevTable).slideUp();
				$($prev).removeClass("active");
				$prev = $(this).attr('id');
				$prevTable = "#"+$prev+"-table"
				$($prevTable).delay(250).slideDown();
				$prev = "#"+$prev;
				$($prev).addClass("active");
			});
			$( document ).ready(function() {
				$prevTable = "#current-table";
				$prev = "#current";
				$("#current").addClass("active");
				$($prevTable).show();
			});
		</script>

</html>