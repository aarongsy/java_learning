
<html lang="en">
	<head>
		<title>NappyZap - Sign Up</title>
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
		<!--Error Check-->
	<?php 
	if(ISSET($_GET['error']))
	{
		$errorcode = $_GET['error'];
		switch ($errorcode) 
		{
			case 1:
				echo '<div id="warning" class="alert alert-danger">Email Address is already in use. Please enter a unique Email Address.</div>';
				break;
			case 2:
				echo '<div id="warning" class="alert alert-danger">All fields were not filled, please make sure all fields are filled before submitting.</div>';
				break;
			case 3:
				echo '<div id="warning" class="alert alert-danger">Database Error: Apologies for any inconvenience. Please contact customer service on xx@xx.com</div>';
				break;
			case 4:
				echo '<div id="warning" class="alert alert-danger">Passwords didn\'t match!</div>';
				break;
			case 5:
				echo '<div id="warning" class="alert alert-danger">Email in wrong format. Please ensure it meets the format xxxx@xxxx.xxx</div>';
				break;
			case 6:
				echo '<div id="warning" class="alert alert-danger">Please ensure you\'ve checked and agreed with our terms and conditions.</div>';
				break;
		}
	}
?>
		<nav class="navbar navbar-default col-xs-12">
			<div class="navbar-header">
				<a class="navbar-brand hidden-xs" href="index.php"><span class="glyphicon glyphicon-home"></span></a>
				<a class="navbar-brand hidden-sm hidden-md hidden-lg" href="index.php">NappyZap</a>
			</div>
			<ul class="nav navbar-nav">
				<li><a href="index.php">Home</a></li>
				<li class="active"><a href="signUp.php">Register</a></li>
			</ul>
		</nav>
		<div class="container-fluid">
			<div id="registerWrapper" class="container">
				<form role="form" id="registration" class="form-horizontal" action="register.php" method="POST">
					<p>Please note the pilot is available to residents living in the London borough of Camden or near to Camden. Your sign up may be rejected if you fall outside of this zone.</p>
					<div class="form-group">
						<label for="emailAddress" class="control-label col-sm-2">Email Address:</label>
						<div class="col-sm-10">
							<input type="email" class="form-control" name="emailAddress" maxlength="50" placeholder="Enter Email Address"></input>
						</div>
					</div>
					<div class="form-group">
						<label for="password" class="control-label col-sm-2">Password:</label>
						<div class="col-sm-10">
							<input type="password" class="form-control" name="password" maxlength="50" placeholder="Enter Password">
						</div>
					</div>
					<div class="form-group">
						<label for="conPassword" class="control-label col-sm-2">Confirm Password:</label>
						<div class="col-sm-10">
							<input type="password" name="conPassword" class="form-control" maxlength="50" placeholder="Re-enter Password">
						</div>
					</div>
					<div class="form-group">
						<label for="firstName" class="control-label col-sm-2">First Name:</label>
						<div class="col-sm-10">
							<input type="text" name="firstName" class="form-control" maxlength="20" placeholder="Enter First Name">
						</div>
					</div>
					<div class="form-group">
						<label for="lastName" class="control-label col-sm-2">Last Name:</label>
						<div class="col-sm-10">
							<input type="text" name="lastName" class="form-control" maxlength="20" placeholder="Enter Last Name">
						</div>
					</div>
					<div class="form-group">
						<label for="title" class="control-label col-sm-2">Title:</label>
						<div class="col-sm-10">
							<select name="title" class="form-control" placeholder="Choose your title...">
								<option value="" disabled selected>Select your option</option>
								<option value="Mr">Mr.</option>
								<option value="Mrs">Mrs.</option>
								<option value="Miss">Miss.</option>
								<option value="Ms">Ms.</option>
								<option value="Dr">Dr.</option>
								<option value="Prof">Prof.</option>
								<option value="Sir">Sir.</option>
								<option value="other">Other</option>
							</select>
						</div>
					</div>
					<div class="form-group">
						<label for="phoneNo" class="control-label col-sm-2">Phone Number:</label>
						<div class="col-sm-10">
							<input type="text" name="phoneNo" class="form-control" maxlength="20" placeholder="Enter Contact Number">
						</div>
					</div>
					<div class="form-group">
						<label for="childAge" class="control-label col-sm-2">Age of child (Months):</label>
						<div class="col-sm-10">
							<input type="text" name="childAge" class="form-control" maxlength="11" placeholder="Enter Age of your Child">
						</div>
					</div>
					<div class="form-group">
						<label for="houseNo" class="control-label col-sm-2">House Number/Name:</label>
						<div class="col-sm-10">
							<input type="text" name="houseNo" class="form-control" maxlength="20" placeholder="Enter House name or Number">
						</div>
					</div>
					<div class="form-group">
						<label for="street" class="control-label col-sm-2">Street:</label>
						<div class="col-sm-10">
							<input type="text" name="street" class="form-control maxlength="20" placeholder="Enter Street Name">
						</div>
					</div>
					<div class="form-group">
						<label for="postcode" class="control-label col-sm-2">Postcode:</label>
						<div class="col-sm-10">
							<input type="text" name="postcode" class="form-control" maxlength="15" placeholder="Enter Postcode">
						</div>
					</div>
					<div class="form-group">
						<label for="binLocation" class="control-label col-sm-2">Where will your Bin be located?:</label>
						<div class="col-sm-10">
							<select name="binLocation" class="form-control" placeholder="Choose the location of your bin...">
								<option value="" disabled selected>Select your option</option>
								<option value="FrontGarden">Front Garden</option>
								<option value="SideOfHouse">Side of House</option>
								<option value="InFrontBuilding">In front of the building</option>
								<option value="phone">Phone on collection, bin kept inside</option>
								<option value="other">Other</option>
							</select>
						</div>
					</div>
					<div class="form-group"> 
						<div class="col-sm-offset-2 col-sm-10">
							<div class="checkbox">
								<label><input name="terms" type="checkbox"><a href="terms.html" target="_blank">I agree to the Terms and Conditions</a></label>
							</div>
						</div>
					</div>
					<button type="submit" class="btn btn-primary col-sm-offset-2">Register</button>
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