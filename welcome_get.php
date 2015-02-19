<html>
<body>

Welcome <?php echo $_GET["start"]; ?><br>
Your email address is: <?php echo $_GET["end"]; ?>

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
	
	$sql = "INSERT INTO Post_Table (start, end, day, driverEnum, time)
	VALUES ($_GET["start"], 'SFO', '2015-02-17', 'DRIVER', 'MORNING')";
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