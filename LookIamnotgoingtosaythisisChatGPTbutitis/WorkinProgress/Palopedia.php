<?php include 'db.php'; ?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pokedex - Pal World Tracker</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>

    <header>
        <h1>Pal World Pokedex</h1>
    </header>

    <section class="pokedex">
        <?php
        // Query to get all Pals
        $query = "SELECT name, element, max_level, is_legendary FROM pals";
        $stmt = $conn->prepare($query);
        $stmt->execute();

        // Fetch and display each Pal
        while ($pal = $stmt->fetch(PDO::FETCH_ASSOC)) {
            echo '<div class="pokedex-card">';
            echo '<h2>' . htmlspecialchars($pal['name']) . '</h2>';
            echo '<p>Element: ' . htmlspecialchars($pal['element']) . '</p>';
            echo '<p>Max Level: ' . htmlspecialchars($pal['max_level']) . '</p>';
            echo '<p>' . ($pal['is_legendary'] ? 'Legendary' : 'Normal') . '</p>';
            echo '</div>';
        }
        ?>
    </section>

</body>
</html>
