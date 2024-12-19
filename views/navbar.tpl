<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cat Gallery</title>
    <style>
    .nav {
        display: flex;
        justify-content: space-around; /* Distribute links evenly */
        margin-bottom: 20px;
    }
    .nav a {
        text-decoration: none;
        color: #333;
        font-weight: bold;
        font-size: 16px;
        padding: 10px 20px;
        transition: color 0.3s, background-color 0.3s;
        border-radius: 5px;
    }
    .nav a.active {
        color: orange;
        background-color: #f0f0f0;
    }
    .nav a:hover {
        color: orange;
        background-color: #f0f0f0;
    }
</style>

</head>
<body>
    <!-- Navbar -->
    <div class="nav">
        <a href="/cat/voting" >Voting</a>
        <a href="/cat/breeds">Breeds</a>
        <a href="/cat/favs">Favs</a>
    </div>

    <!-- Content here -->
</body>
</html>
