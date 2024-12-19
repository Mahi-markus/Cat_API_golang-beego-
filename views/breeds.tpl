<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Cat Breeds</title>

    <!-- Include Select2 CSS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/css/select2.min.css" rel="stylesheet" />

    <!-- Include jQuery (required for Select2) -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- Include Select2 JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/js/select2.min.js"></script>

    <script>
        $(document).ready(function() {
            // Initialize Select2 on the select element
            $('#breed').select2();
        });
    </script>
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
