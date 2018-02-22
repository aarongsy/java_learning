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
						<li class="active"><a href="stats.php">Users</a></li>
						<li><a href="pickups.php">Pickups</a></li>
						<li><a href="metrics.php">Metrics</a></li>
						<li><a href="logout.php">Logout</a></li>
					</ul>
			</nav>
			<div class="container-fluid">
				<table id="hoverTable" class="table-striped  col-md-12">
					<?php
						include "../dbconn.php"; 
						$stmt = $dbh->prepare('SELECT * FROM userdata');
						$stmt->execute();
						echo "<h2>Users, Total: ".$stmt->rowCount()."</h2>";
						echo "<thead>";
						echo "<tr>";
						echo "<th>Title</th>";
						echo "<th>First Name</th>";
						echo "<th>Last Name</th>";
						echo "<th>Email Address</th>";
						echo "</tr>";
						echo "</thead>";
						echo "<tbody>";
						foreach($stmt as $row){
							echo '<div id="modal-'.$row["userID"].'" class="modal fade" role="dialog">
								<div class="modal-dialog">
								<!-- Modal content-->
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal">&times;</button>
											<h4 class="modal-title">'.$row["title"].' '.$row["firstName"].' '.$row["lastName"].'</h4>
										</div>
										<div class="modal-body">
											<p>'.$row["houseNo"].', '.$row["street"].', '.$row["city"].', '.$row["county"].', '.$row["postcode"].'</p>
											<p>Lat/Lng = ( '.$row["lat"].', '.$row["lng"].')</p>
										</div>
										<div class="modal-footer">
											<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
										</div>
									</div>
								</div>
							</div>';
							echo "<tr class='clickable-row' data-toggle='modal' data-target='#modal-".$row["userID"]."'>";
							echo "<td>".$row['title']."</td>";
							echo "<td>".$row['firstName']."</td>";
							echo "<td>".$row['lastName']."</td>";
							echo "<td>".$row['emailAddress']."</td>";
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