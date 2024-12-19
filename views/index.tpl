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
            width: 100%;
            height: 400px;
            object-fit: cover;
            border-radius: 5px;
        }
        .button-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 10px;
        }
        .love-button, .like-dislike-buttons {
            display: flex;
            align-items: center;
        }
        .love-button form, .like-dislike-buttons form {
            margin: 0;
        }
        .love-button {
            margin-right: auto;
        }
        .like-dislike-buttons {
            margin-left: auto;
        }
        button {
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            color: #555;
            margin: 0 5px;
            transition: transform 0.2s ease, color 0.2s ease;
        }
        button:hover {
            color: orange;
            transform: scale(1.2); /* Slightly enlarges the button */
        }
        button:active {
            transform: scale(1); /* Resets the size when the button is clicked */
        }
    </style>
</head>
<body>

    <div class="container">
        <!-- Include Navbar -->
        {{template "navbar.tpl"}}
        
        <!-- Display Image -->
        <div>
            <img src="{{.ImageURL}}" alt="Cat Image">
        </div>

        <!-- Buttons Row -->
        <div class="button-row">
            <!-- Love Button -->
            <div class="love-button">
                <form action="/cat/love" method="POST">
                    <input type="hidden" name="image_url" value="{{.ImageURL}}">
                    <button type="submit" title="Love">❤️</button>
                </form>
            </div>

            <!-- Like/Dislike Buttons -->
            <div class="like-dislike-buttons">
                <form action="/cat/vote" method="POST">
                    <button type="submit" name="vote" value="up" title="Like">👍</button>
                    <button type="submit" name="vote" value="down" title="Dislike">👎</button>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
