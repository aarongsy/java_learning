<html lang="en">
	<head>
		<title>NappyZap - Login</title>
		<link rel="shortcut icon" href="images/logo002.png">
		<!-- Latest compiled and minified CSS -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">

		<!-- jQuery library -->
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
		<!-- Latest compiled JavaScript -->
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
		
		<link rel="stylesheet" href="bootstrapTheme.css">
		<meta charset="utf-8"> 
		<meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
	<body>
	<?php 
	if(ISSET($_GET['error']))
	{
		echo '<div id="warning" class="alert alert-danger">Username or Password are incorrect.</div>';
	}
?>
	<div id="mainWrapper">
			<nav class="navbar navbar-default">
					<div class="navbar-header">
						<a class="navbar-brand" href="index.php"><span class="glyphicon glyphicon-home"></span></a>
					</div>
					<div>
						<ul class="nav navbar-nav">
							<li><a href="index.php">Home</a></li>
							<li><a href="signUp.php">Register</a></li>
							<li class="active"><a href="login.php">Login</a></li>
						</ul>
					</div>
			</nav>
			<div id="registerWrapper" class="container">
				<form role="form" id="registration" class="form-horizontal" action="checkLogin.php" method="POST">
					<h2>Login</h2>
					<div class="form-group">
						<label for="emailAddress" class="control-label col-sm-2">Email Address:</label>
						<div class="col-sm-10">
							<input type="email" class="form-control" name="username" maxlength="50" placeholder="Enter Email Address"></input>
						</div>
					</div>
					<div class="form-group">
						<label for="password" class="control-label col-sm-2">Password:</label>
						<div class="col-sm-10">
							<input type="password" class="form-control" name="password" maxlength="50" placeholder="Enter Password">
						</div>
					</div>
					<button type="submit" class="btn btn-primary col-sm-offset-2">Login</button>
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