<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cat Gallery</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
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
        img {
            max-width: 100%;
            border-radius: 10px;
        }
        .nav {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
        }
        .nav a {
            text-decoration: none;
            color: #333;
            font-weight: bold;
            font-size: 16px;
        }
        .nav a.active {
            color: orange;
        }
        .footer-icons {
            margin-top: 10px;
        }
        .footer-icons button {
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            margin: 0 10px;
            color: #555;
        }
        .footer-icons button:hover {
            color: orange;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Navigation Buttons -->
        <div class="nav">
            <a href="/cat/voting" class="active">Voting</a>
            <a href="/cat/breeds">Breeds</a>
            <a href="/cat/favs">Favs</a>
        </div>

        <!-- Display Image -->
        <div>
            <img src="{{.ImageURL}}" alt="Cat Image">
        </div>

        <!-- Like/Dislike Icons -->
        <div class="footer-icons">
            <form action="/cat/vote" method="POST">
                <button type="submit" name="vote" value="up">👍</button>
                <button type="submit" name="vote" value="down">👎</button>
            </form>
        </div>
    </div>
</body>
</html>
