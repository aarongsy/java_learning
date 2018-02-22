<!DOCTYPE html>
<?php
	include "../dbconn.php";
	session_start();
	if(!isset($_SESSION['admin']))
	{
		header('Location: login.php');
	}
	
	if(ISSET($_GET['success']))
	{
		$errorcode = $_GET['success'];
		switch ($errorcode) 
		{
			case 1:
				echo '<div id="warning" class="alert alert-success">Opener Successfully Updated</div>';
				break;
			case 2:
				echo '<div id="warning" class="alert alert-success">News Story successfully deleted</div>';
				break;
			case 3:
				echo '<div id="warning" class="alert alert-success">News Story Successfully updated</div>';
				break;
			case 4:
				echo '<div id="warning" class="alert alert-success">News Story successfully created</div>';
				break;
		}
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
				<li><a href="pickups.php">Pickups</a></li>
				<li><a href="metrics.php">Metrics</a></li>
				<li class="active"><a href="cms.php">Content Management</a></li>
				<li><a href="logout.php">Logout</a></li>
			</ul>
		</nav>
		<div class="container-fluid">
			<nav class="navbar table-choice col-md-12" style="border-bottom-color: white;">
				<ul class="nav navbar-nav" style="border-bottom-color: white;">
					<li class="table-chooser" id="home"><a>Home</a></li>
				</ul>
			</nav>
			<!--Home CMS-->
			<div class="container-fluid" id="home-cms" style="display:none; border: 3px solid #f7f7f7;">
				<?php
					//News Stories
					$stmt = $dbh->prepare("SELECT contentID, content, title, date FROM homePage WHERE type=1 ORDER BY date DESC");
					$stmt->execute();
					//Opening Statement
					$stmt2 = $dbh->prepare("SELECT content FROM homePage WHERE type=0");
					$stmt2->execute();
					$stmt2 = $stmt2->fetch();
					$stmt2 = htmlspecialchars($stmt2['content']);
				?>
				<div class="edit">
					<div class="row">
						<form action="editHomePage.php" method="POST">
							<div class="form-group">
								<label for="opening" class="control-label col-sm-2">Opening Statement:</label>
								<div class="col-sm-9">
									<textarea type="text" class="form-control" rows="5" name="opening" placeholder="Opening Statement..."><?php echo $stmt2;?></textarea>
								</div>
							</div>
							<button type="submit" class="btn btn-primary col-sm-1">Save Opener</button>
						</form>
					</div>
					<div class="row" style="margin-top: 25px;">
						<h3 style="padding-left: 15px;">News Stories</h3>
					</div>
					<form class="row" action="editHomePage.php" method="POST">
						<div class='news-wrapper col-sm-12' style="padding: 10px;">
							<div class="form-group"> 						
								<label for="title" class="control-label col-sm-2">Title:</label>
								<div class="col-sm-9">
									<input type="text" class="form-control" name="title" maxlength="50" placeholder="Enter Title..."></input>
								</div>
							</div>
							<div class="form-group"> 
								<label for="content" class="control-label col-sm-2">Content:</label>
								<div class="col-sm-9">
									<textarea type="text" class="form-control" rows="5" name="content" placeholder="Story Content..."></textarea>
								</div>
								<input type='hidden' name='add' value='1'></input>
							</div>
							<button type="submit" class="btn btn-primary col-sm-1">Add New Story</button>
						</div>
					</form>
						<?php
							foreach($stmt as $row){
									echo "<div class='news-wrapper col-sm-12' style='padding: 10px;'>";
										echo "<p class='col-md-11'>".date('d-M-Y', strtotime($row['date']))."</p>";
										echo "<form action='editHomePage.php' method='POST'><input type='hidden' name='delete' value='".$row['contentID']."'> <input type='submit' value='Delete' class='col-md-1 glyphicon glyphicon-remove'></form>";
										echo "<form action='editHomePage.php' method='POST'>";
											echo "<input type='hidden' name='contentID' value='".$row['contentID']."'></input>";
											echo "<input type='text' class='form-control' name='title' maxlength='50' placeholder='Enter Title...' value='".$row['title']."'></input>";
											echo "<textarea type='text' class='form-control' rows='5' name='content' placeholder='Story Content...'>".$row['content']."</textarea>";
											echo "<button type='submit' class='btn btn-primary col-sm-1'>Edit Story</button>";
										echo "</form>";
									echo "</div>";
							}
						?>
				</div>
		</div>
	</body>
		<script>
			var $prev;
			var $prevTable;
			$( ".table-chooser" ).click(function() {
				$($prevTable).slideUp();
				$($prev).removeClass("active");
				$prev = $(this).attr('id');
				$prevTable = "#"+$prev+"-cms"
				$($prevTable).delay(250).slideDown();
				$prev = "#"+$prev;
				$($prev).addClass("active");
			});
			$( document ).ready(function() {
				$prevTable = "#home-cms";
				$prev = "#home";
				$("#home").addClass("active");
				$($prevTable).show();
				$("#warning").slideDown();
				$("#warning").delay(2000).slideUp();
			});
		</script>
</html>