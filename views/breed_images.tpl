<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
            
        }
        h1 {
            margin: 20px 0;
            margin-up: 20px
        }
        .slideshow-container {
            position: relative;
            max-width: 600px;
            margin: 50px auto;
        }
        .slide {
            display: none;
            text-align: center;
        }
        .slide img {
            width: 100%;
            max-height: 400px;
            object-fit: cover;
            border-radius: 10px;
        }
        .prev, .next {
            cursor: pointer;
            position: absolute;
            top: 50%;
            width: auto;
            margin-top: -22px;
            padding: 16px;
            color: white;
            font-weight: bold;
            font-size: 18px;
            transition: 0.6s ease;
            border-radius: 0 3px 3px 0;
            user-select: none;
        }
        .next {
            right: 0;
            border-radius: 3px 0 0 3px;
        }
        .prev {
            left: 0;
        }
        .prev:hover, .next:hover {
            background-color: rgba(0,0,0,0.8);
        }
        .breed-info {
            margin-top: 20px;
            padding: 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            text-align: left;
            max-width: 600px;
            margin: 20px auto;
        }
        .breed-info h2 {
            margin: 0;
            color: orange;
        }
        .breed-info p {
            margin: 10px 0;
            color: #555;
            font-size: 17px
        }
        .breed-info a {
            text-decoration: none;
            color: #007BFF;
        }
        .back-link {
            display: block;
            margin-top: 20px;
            text-decoration: none;
            color: #333;
            font-weight: bold;
        }
        .back-link:hover {
            color: orange;
        }
    </style>
</head>
<body>
    
    <div class="slideshow-container">
    <!-- Include Navbar -->
     {{template "breeds.tpl"}}

     
        {{range .Images}}
        <div class="slide">
            <img src="{{.URL}}" alt="Cat Image">
        </div>
        {{else}}
        <p>No images available for this breed.</p>
        {{end}}

        <!-- Next and Previous buttons -->
        <a class="prev" onclick="changeSlide(-1)">&#10094;</a>
        <a class="next" onclick="changeSlide(1)">&#10095;</a>
    </div>

    <!-- Breed Information -->
    <div class="breed-info">
        <h2>{{.BreedName}} ({{.Origin}}) - {{.ID}}</h2>
        <p>{{.Description}}</p>
        <a href="{{.WikipediaURL}}" target="_blank">WIKIPEDIA</a>
    </div>

    <a href="/cat/breeds" class="back-link">Back to Breeds</a>
    <a href="/" class="back-link">Back to Home</a>

    <script>
        let slideIndex = 0;
        showSlides(slideIndex);

        function changeSlide(n) {
            showSlides(slideIndex += n);
        }

        function showSlides(n) {
            const slides = document.getElementsByClassName("slide");
            if (n >= slides.length) slideIndex = 0;
            if (n < 0) slideIndex = slides.length - 1;
            for (let i = 0; i < slides.length; i++) {
                slides[i].style.display = "none";
            }
            slides[slideIndex].style.display = "block";
        }

        // Auto slide functionality
        setInterval(() => {
            changeSlide(1);
        }, 5000); // Change slide every 5 seconds
    </script>
</body>
</html>
