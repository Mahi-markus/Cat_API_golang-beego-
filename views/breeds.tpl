<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    

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

            // Auto-submit form when the breed is selected
            $('#breed').on('change', function() {
                $(this).closest('form').submit();
            });
        });
    </script>

    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }

        h1 {
            text-align: center;
            margin-top: 30px;
            color: #333;
        }

        .breed-select {
            width: 80%;
            max-width: 600px;
            margin: 50px auto; /* Apply the margin rule here */
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
            padding: 20px;
            box-sizing: border-box;
        }

        label {
            font-size: 18px;
            margin-right: 10px;
            color: #333;
            font-weight: bold;
        }

        select {
            width: 100%;
            padding: 12px 15px;
            font-size: 16px;
            margin-bottom: 20px;
            border-radius: 5px;
            border: 1px solid #ccc;
            background-color: #fff;
            box-sizing: border-box;
        }

        select:focus {
            outline: none;
            border-color: #345335;
        }
    </style>
</head>
<body>

    <div class="breed-select">
        <!-- Include Navbar -->
        {{template "navbar.tpl"}}
        
        
        <!-- Dropdown Form -->
        <form method="get" action="/cat/breed_images">
            <label for="breed">Choose a Breed:</label>
            <select name="id" id="breed" required>
                <option value="">-- Select Breed --</option>
                {{range .Breeds}}
                    <option value="{{.ID}}">{{.Name}}</option>
                {{end}}
            </select>
        </form>
    </div>

</body>
</html>

