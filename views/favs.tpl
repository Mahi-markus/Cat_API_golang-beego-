<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Favorites</title>
</head>
<body>
    <h1>Favorites</h1>
    {{range .LovedImages}}
        <img src="{{.}}" alt="Loved Cat Image" style="width:300px;height:300px;">
    {{else}}
        <p>No loved images yet.</p>
    {{end}}
    <br>
    <a href="/">Back to Home</a>
</body>
</html>
