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
        }
        button:hover {
            color: orange;
        }
    </style>
</head>
<body>
  

    <div class="container">
        <!-- Display Image -->
      <!-- Include Navbar -->
    {{template "navbar.tpl"}}
        <div>
            <img src="{{.ImageURL}}" alt="Cat Image">
        </div>

        <!-- Buttons Row -->
        <div class="button-row">
            <!-- Love Button -->
            <div class="love-button">
                <form action="/cat/love" method="POST">
                    <input type="hidden" name="image_url" value="{{.ImageURL}}">
                    <button type="submit">❤️</button>
                </form>
            </div>

            <!-- Like/Dislike Buttons -->
            <div class="like-dislike-buttons">
                <form action="/cat/vote" method="POST">
                    <button type="submit" name="vote" value="up">👍</button>
                    <button type="submit" name="vote" value="down">👎</button>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
