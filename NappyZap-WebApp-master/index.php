
<!DOCTYPE html>
<?php
	include "dbconn.php";
	$stmt2 = $dbh->prepare("SELECT content FROM homePage WHERE type=0");
	$stmt2->execute();
	$stmt2 = $stmt2->fetch();
	$stmt2 = htmlspecialchars($stmt2['content']);
?>
<html lang="en">
	<head>
		<title>NappyZap - About Us</title>
		<link rel="shortcut icon" href="images/logo002.png">
		<!-- Latest compiled and minified CSS -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">

		<!-- jQuery library -->
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>

		<!-- Latest compiled JavaScript -->
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
		
		<!--Custom CSS-->
		<link rel="stylesheet" href="fixedHeightFooter.css">
		<link rel="stylesheet" href="bootstrapTheme.css">
		
		<meta charset="utf-8"> 
		<meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
	<body>
	<?php
		if(ISSET($_GET['success'])){
			echo '<div id="warning" class="alert alert-success">Successfully signed up to our mailing list!</div>';
		}
	?>
		<nav class="navbar navbar-default col-md-12 col-xs-12">
			<div class="col-sm-10">
				<div class="navbar-header">
					<a class="navbar-brand hidden-xs" href="index.php"><span class="glyphicon glyphicon-home"></span></a>
				</div>
				<ul class="nav navbar-nav">
					<li class="active"><a href="index.php">Home</a></li>
					<li><a href="signUp.php">Sign-Up</a></li>
				</ul>
			</div>
			<div class="hidden-xs navbar-social col-sm-2">
				<a target="_blank" href="https://www.facebook.com/nappyzap?_rdr=p"><img class="social-icon" src="images/social/facebook.png"></a>
				<a target="_blank" href="https://twitter.com/nappyzap"><img class="social-icon" src="images/social/twitter.png"></a>
			</div>
			<div class="hidden-sm hidden-md hidden-lg navbar-social col-xd-12">
				<a target="_blank" href="https://www.facebook.com/nappyzap?_rdr=p"><img class="col-xs-offset-2 col-xs-4" src="images/social/facebook.png"></a>
				<a target="_blank" href="https://twitter.com/nappyzap"><img class="col-xs-4" src="images/social/twitter.png"></a>
			</div>
		</nav>	
		<div class="col-sm-12">
			<!--Main Sizes-->
			<div class="hidden-xs col-sm-offset-1 col-sm-10">
				<img src="images/baby-background.png" class="background-img img-responsive">
			</div>
			<div class="hidden-xs logo">
				<div class="col-sm-offset-6 col-sm-6">
					<div class="row">
						<img style="max-width: 100%;" src="images/logo002.png" class="col-sm-offset-3 col-sm-4 col-xs-offset-3">
					</div>
					<div class="row" style="text-align:center; margin: 20px;">
						<h4 class="col-sm-8 col-sm-offset-1"><?php echo $stmt2; ?></h4>
					</div>
					<div class="row">
						<a class="btn btn-primary col-sm-offset-3 col-sm-4" href="signUp.php">Join our Newsletter!</a>
					</div>
				</div>
			</div>
			<!--Mobile-->
			<div class="col-xs-12">
					<div class="row">
						<img style="max-width: 100%; margin-top: 20px;" src="images/logo002.png" class="col-sm-offset-3 col-sm-4 col-xs-offset-2 col-xs-8">
					</div>
					<div class="row" style="text-align:center; margin: 20px;">
						<h4 class="col-sm-8 col-sm-offset-1"><?php echo $stmt2; ?></h4>
					</div>
					<div class="row">
						<a class="btn btn-primary col-sm-offset-3 col-sm-4 col-xs-offset-3 col-xs-6" href="signUp.php">Join our Newsletter!</a>
					</div>
			</div>
		</div>
		<div class="picsntwit col-sm-offset-1 col-sm-10 col-xs-12">
			<div class="col-sm-8">
				<div class="row">
					<img class="picsntwit-pic col-md-4 hidden-xs" src="images/nappies.jpg">
					<img class="picsntwit-pic col-md-4 hidden-xs" src="images/nappies2.jpg">
					<img class="picsntwit-pic col-md-4 hidden-xs" src="images/vehicle.png">
				</div>
				<div class="row news">
				<?php
					$stmt = $dbh->prepare("SELECT content, title, date FROM homePage WHERE type=1 ORDER BY date DESC");
					$stmt->execute();
					if($stmt->rowCount() == 0){
						echo "<div class='news-wrapper' style='padding: 5px;'>";
							echo "<div class='news-title'><h4>No Current News</h4><h4 class='timestamp'></h4></div>";
							echo "<div class='news-body'><p></p></div>";
						echo "</div>";
					}
					else{
						foreach($stmt as $row){
							echo "<div class='news-wrapper col-sm-12' style='padding: 5px;'>";
								echo "<div class='row news-title'><h4 class='col-sm-10 '>".htmlspecialchars($row['title'])."</h4><p class='timestamp col-sm-2'>".date('d-M-Y', strtotime($row['date']))."</p></div>";
								echo "<div class='row news-body'>".htmlspecialchars($row['content'])."</div>";
							echo "</div>";
						}
					}
				?>
				</div>
			</div>
			<div class="col-sm-4">
				<a class="twitter-timeline" href="https://twitter.com/nappyzap" data-widget-id="698276131875766272">Tweets by @nappyzap</a>
				<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+"://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
			</div>
		</div>
		<footer class="footer col-sm-12 col-xs-12">
			<div class="col-sm-8 col-xs-12">
				<h3 class="hidden-xs">Interested in knowing more about NappyZap? <br>Email or give us a call. </h3>
				<p>Tel:       07825 832 596</p>
				<p>Email:  nic@nappyzap.com</p>
			</div>
			<div class="col-sm-4 col-xs-12" >
				<div class="col-sm-6 col-xs-12">
					<p>In partnership with:</p>
					<img class="col-xs-6 col-sm-12" src="images/camden.png" style="max-width:125px;"><br>
					<img class="col-xs-6 col-sm-12"src="images/greenCamden.png" style="padding-top: 25px; max-width: 100px;">
				</div>
				<div class="col-sm-6 col-xs-12">
					<p>In association with:</p>
					<img class="col-xs-12" src="images/uclComp.png" style="padding-top: 20px; max-width: 100px;">
				</div>
			</div>
		</footer>
	</body>
</html>