<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cat Gallery</title>
    <style>
/* General Reset */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

/* Navigation Styles */
.nav {
    display: flex;
    justify-content: space-around;
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
    cursor: pointer;
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

.voting .nav-text {
    color: #666;
}

.breeds .nav-text {
    color: #666;
}

.favs .nav-text {
    color: #ff6b6b;
}

.voting-icon,
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

/* Content Styles */
body {
    font-family: Arial, sans-serif;
    background-color: #f9f9f9;
    margin: 0;
    padding: 0;
}

#spa-content {
    min-height: 100vh;
}

.container {
    text-align: center;
    margin: 50px auto;
    width: 600px;
    background-color: #fff;
    border-radius: 10px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    padding: 20px;
}

.container img {
    width: 500px; /* Set the fixed width */
    height: 300px; /* Set the fixed height */
    object-fit: cover; /* Maintain aspect ratio while covering the given dimensions */
    display: block;
    margin: 0 auto;
    border-radius: 10px;
}

/* Button Row Styles */
.button-row {
    position: relative;
    margin-top: 20px;
}

.love-button {
    position: absolute;
    bottom: 0;
    left: 0;
    transform: translate(10%, 100%);
}

.like-dislike-buttons {
    position: absolute;
    bottom: 0;
    right: 0;
    transform: translate(-10%, 100%);
}

.button-row button {
    background-color: #f0f0f0;
    border: none;
    border-radius: 5px;
    padding: 10px;
    cursor: pointer;
    transition: background-color 0.3s;
    font-size: 16px;
}

.button-row button:hover {
    background-color: #e0e0e0;
}

.button-row button[title="Love"] {
    color: #ff6b6b;
    font-size: 20px;
}

/* Loading and Error Message */
.loading {
    text-align: center;
    padding: 2rem;
    font-size: 1.2rem;
    color: #666;
}


    </style>
    
    <!-- Include jQuery and Select2 -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/css/select2.min.css" rel="stylesheet" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/js/select2.min.js"></script>
    
    <!-- Include SPA JavaScript -->
    <script src="/static/js/spa.js"></script>
</head>
<body>
    <!-- Tab Navigation -->
    <div class="nav">
        <a data-tab="voting" class="voting active">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M12 20V4M4 12l8-8 8 8"/>
            </svg>
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M12 4v16M4 12l8 8 8-8"/>
            </svg>
            Voting
        </a>
        <a data-tab="breeds" class="breeds">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="11" cy="11" r="8"/>
                <path d="M21 21l-4.35-4.35"/>
            </svg>
            Breeds
        </a>
        <a data-tab="favs" class="favs">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 0 0 0-7.78z"/>
            </svg>
            Favs
        </a>
    </div>
    
    <!-- Main content area -->
    <div id="spa-content">
        <!-- Initial content -->
        <div class="container">
            <img src="{{.ImageURL}}" alt="Cat Image">
            <div class="button-row">
                <div class="love-button">
                    <form action="/cat/love" method="POST">
                        <input type="hidden" name="image_url" value="{{.ImageURL}}">
                        <button type="submit" title="Love">❤️</button>
                    </form>
                </div>
                <div class="like-dislike-buttons">
                    <form action="/cat/vote" method="POST">
                        <button type="submit" name="vote" value="up" title="Like">👍</button>
                        <button type="submit" name="vote" value="down" title="Dislike">👎</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>