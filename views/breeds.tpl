<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Cat Breeds</title>
</head>
<body>
    <h1>Cat Breeds</h1>

    <!-- Dropdown Form -->
    <form method="get" action="/cat/breed_images">
        <label for="breed">Choose a Breed:</label>
        <select name="id" id="breed" required>
            <option value="">-- Select Breed --</option>
            {{range .Breeds}}
                <option value="{{.ID}}">{{.Name}}</option>
            {{end}}
        </select>
        <button type="submit">Show Images</button>
    </form>
</body>
</html>
