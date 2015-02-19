<html>
<body>

Start Point: <?php echo $_GET["start"]; ?><br>
End Point: <?php echo $_GET["end"]; ?>
Day: <?php echo $_GET["day"]; ?>


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
	VALUES ('$start', '$end', '$date', '$driverEnum', '$time')";
	if ($conn->query($sql) === TRUE) 
	{
		echo "New record created successfully";
	} 
	else {
		echo "Error: " . $sql . "<br>" . $conn->error;
	}

	$conn->close();
?>

</body>
</html>