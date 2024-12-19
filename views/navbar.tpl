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


          .nav-text {
            font-size: 14px;
        }

        /* Text colors */
        .voting .nav-text {
            color: #666;
        }

        .breeds .nav-text {
            color: #666;
        }

        .favs .nav-text {
            color: #ff6b6b;
        }

        /* Icon colors */
        .voting-icon {
            stroke: #666;
            fill: none;
            stroke-width: 2;
        }

        .search-icon {
            stroke: #666;
            fill: none;
            stroke-width: 2;
        }

        .heart-icon {
            stroke: #ff6b6b;
            fill: none;
            stroke-width: 2;
        }
</style>

</head>
<body>
     <div class="nav">
        <a href="/cat/voting" class="voting">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M12 20V4M4 12l8-8 8 8"/> <!-- Upward arrow -->
        </svg>
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M12 4v16M4 12l8 8 8-8"/> <!-- Downward arrow -->
        </svg>
            Voting
        </a>
        <a href="/cat/breeds" class="breeds">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <circle cx="11" cy="11" r="8"/>
            <path d="M21 21l-4.35-4.35"/>
        </svg>
            Breeds
        </a>
        <a href="/cat/favs" class="favs">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 0 0 0-7.78z"/>
        </svg>
            Favs
        </a>
    </div>
</body>
</html>
