<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Favorites</title>
    <style>
        .gallery {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            padding: 20px;
        }
        .gallery img {
            width: 100%;
            height: 300px;
            object-fit: cover;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .error {
            color: red;
            padding: 20px;
        }
    </style>
</head>
<body>
    <h1>Favorites</h1>
    {{if .Error}}
        <p class="error">{{.Error}}</p>
    {{else}}
        <div class="gallery">
            {{range .LovedImages}}
                <img src="{{.}}" alt="Loved Cat Image">
            {{else}}
                <p>No loved images yet.</p>
            {{end}}
        </div>
    {{end}}
    <br>
    <a href="/">Back to Home</a>
</body>
</html>