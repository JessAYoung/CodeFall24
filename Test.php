<?php
// Connect to the MySQL database
$host = 'localhost';
$dbname = 'pal_world_tracker';
$username = 'root';
$password = '';

$conn = new mysqli($host, $username, $password, $dbname);

// Check the connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Retrieve form data
$parent1_id = $_POST['parent1'];
$parent2_id = $_POST['parent2'];

// Query the breeding table for offspring
$sql = "SELECT p1.name AS parent1, p2.name AS parent2, po.name AS offspring
        FROM breeding b
        JOIN pals p1 ON b.parent_1_id = p1.pal_id
        JOIN pals p2 ON b.parent_2_id = p2.pal_id
        JOIN pals po ON b.offspring_id = po.pal_id
        WHERE (b.parent_1_id = ? AND b.parent_2_id = ?)
           OR (b.parent_1_id = ? AND b.parent_2_id = ?)";

$stmt = $conn->prepare($sql);
$stmt->bind_param('iiii', $parent1_id, $parent2_id, $parent2_id, $parent1_id);
$stmt->execute();
$result = $stmt->get_result();

// Display results
if ($result->num_rows > 0) {
    echo "<table>";
    echo "<tr><th>Parent 1</th><th>Parent 2</th><th>Offspring</th></tr>";
    while ($row = $result->fetch_assoc()) {
        echo "<tr><td>" . $row['parent1'] . "</td><td>" . $row['parent2'] . "</td><td>" . $row['offspring'] . "</td></tr>";
    }
    echo "</table>";
} else {
    echo "<p>No breeding result found for the selected parents.</p>";
}

// Close connection
$conn->close();
?>
