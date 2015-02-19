<html>
<body>

Start Point: <?php echo $_GET["start"]; ?><br>
End Point: <?php echo $_GET["end"]; ?><br>
Day: <?php echo $_GET["day"]; ?><br>
Time: <?php echo $_GET["time"]; ?><br>
Driver/Rider: <?php echo $_GET["driverEnum"]; ?><br><br>


<?php
	$servername = "aaiblrud1k2f1u.c8ktrid1mjul.us-west-2.rds.amazonaws.com";
	$username = "php";
	$password = "pixiedust";
	$dbname = "innodb";

	// Create connection
	$conn = new mysqli($servername, $username, $password, $dbname);
	// Check connection
	if ($conn->connect_error) {
		die("Connection failed: " . $conn->connect_error);
	}
	
	$start = $_GET["start"];
	$end = $_GET["end"];
	$day = $_GET["day"];
	$driverEnum = $_GET["driverEnum"];
	$time = $_GET["time"];

	$sql = "INSERT INTO Post_Table (start, end, day, driverEnum, time)
	VALUES ('$start', '$end', '$day', '$driverEnum', '$time')";
	if ($conn->query($sql) === TRUE) 
	{
		echo "New record created successfully in DBS!!!!";
	} 
	else {
		echo "MySQL Error: " . $sql . "<br>" . $conn->error;
	}

	$conn->close();
?>

<br>
To observe populated database...<br>
hostname = aaiblrud1k2f1u.c8ktrid1mjul.us-west-2.rds.amazonaws.com<br>
username = php<br>
password = pixiedust<br>
dbname = innodb<br>

</body>
</html>