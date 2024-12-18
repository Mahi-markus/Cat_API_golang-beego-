<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Breed Images</title>
</head>
<body>
    <h1>Breed Images</h1>
    {{range .Images}}
        <img src="{{.URL}}" alt="Cat Image" style="width:300px;height:300px;">
    {{else}}
        <p>No images available for this breed.</p>
    {{end}}
    <br>
    <a href="/cat/breeds">Back to Breeds</a>
</body>
</html>
