<!DOCTYPE html>
<?php
	session_start();
	if(isset($_SESSION['admin']))
	{
		header('Location: stats.php');
	}
?>
<html lang="en">
	<head>
		<title>NappyZap - Admin Login</title>
		<link rel="shortcut icon" href="images/logo002.png">
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
					</div>
				</div>
			</nav>
			<div id="mainWrapper" class="container">
				<div class="jumbotron">
					<h1 style="color: #000099;" >Admin Panel Login</h1>
					<form role="form" id="login" class="form-horizontal" action="verifyLogin.php" method="POST">
						<div class="form-group">
							<label for="username" class="control-label col-sm-2">Login:</label>
							<div class="col-sm-10">
								<input type="text" class="form-control" name="username" maxlength="50" placeholder="Enter Username"></input>
							</div>
						</div>
						<div class="form-group">
							<label for="password" class="control-label col-sm-2">Password:</label>
							<div class="col-sm-10">
								<input type="password" class="form-control" name="password" maxlength="50" placeholder="Enter Password">
							</div>
						</div>
						<button type="submit" class="btn btn-default">Login</button>
					</form>
				</div>
			</div>
		</div>
	</body>
</html>