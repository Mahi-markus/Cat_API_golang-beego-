<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cat Gallery</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/css/select2.min.css" rel="stylesheet" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/js/select2.min.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 20px;
        }

        .nav {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-bottom: 30px;
            background: white;
            padding: 15px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .nav-item {
            display: flex;
            align-items: center;
            gap: 5px;
            padding: 10px 20px;
            cursor: pointer;
            border-radius: 5px;
            transition: all 0.3s;
        }

        .nav-item:hover {
            background: #f0f0f0;
            color: orange;
        }

        .nav-item.active {
            color: orange;
            background: #f0f0f0;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
        }

        .section {
            display: none;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .section.active {
            display: block;
        }

        .cat-image-container {
            position: relative;
            width: 100%;
            height: 400px;
            margin-bottom: 20px;
        }

        .cat-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 10px;
        }

        .button-row {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 20px;
        }

        button {
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            transition: transform 0.2s;
            padding: 10px;
        }

        button:hover {
            transform: scale(1.2);
        }

        .breed-select {
            width: 100%;
            margin-bottom: 30px;
        }

        .breed-info {
            margin-top: 20px;
            padding: 20px;
            border-radius: 10px;
            background: #f8f8f8;
        }

        .slideshow-container {
            position: relative;
            height: 400px;
            margin: 20px 0;
        }

        .slide {
            display: none;
            height: 100%;
        }

        .slide.active {
            display: block;
        }

        .slide img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 10px;
        }

        .prev, .next {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            padding: 16px;
            color: white;
            background: rgba(0,0,0,0.5);
            cursor: pointer;
            border-radius: 5px;
            z-index: 1;
        }

        .prev { left: 10px; }
        .next { right: 10px; }

        .favorites-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 20px;
            padding: 20px;
        }

        .favorite-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 10px;
        }

        .wiki-link {
            display: inline-block;
            margin-top: 10px;
            color: #007bff;
            text-decoration: none;
        }

        .wiki-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <nav class="nav">
            <div class="nav-item active" data-section="home">Home</div>
            <div class="nav-item" data-section="breeds">Breeds</div>
            <div class="nav-item" data-section="favorites">Favorites</div>
        </nav>

        <div id="home" class="section active">
            <div class="cat-image-container">
                <img class="cat-image" src="" alt="Random Cat">
            </div>
            <div class="button-row">
                <button type="button" class="love-button" title="Love">❤️</button>
                <button type="button" class="vote-button" data-vote="up" title="Like">👍</button>
                <button type="button" class="vote-button" data-vote="down" title="Dislike">👎</button>
            </div>
        </div>

        <div id="breeds" class="section">
            <select id="breed-select" class="breed-select">
                <option value="">-- Select Breed --</option>
            </select>
            <div id="breed-content"></div>
        </div>

        <div id="favorites" class="section">
            <div class="favorites-grid"></div>
        </div>
    </div>

    <script>
        let currentSlide = 0;
        let currentImageUrl = '';
        const breedsData = [
            { id: 1, name: 'Persian', images: ['https://placekitten.com/800/600', 'https://placekitten.com/801/601'], description: 'Persian cats are known for their long fur and sweet disposition.', origin: 'Iran', wikipedia_url: 'https://en.wikipedia.org/wiki/Persian_cat' },
            { id: 2, name: 'Siamese', images: ['https://placekitten.com/802/602', 'https://placekitten.com/803/603'], description: 'Siamese cats are vocal, affectionate, and friendly.', origin: 'Thailand', wikipedia_url: 'https://en.wikipedia.org/wiki/Siamese_cat' }
        ];
        const favoriteImages = ['https://placekitten.com/804/604', 'https://placekitten.com/805/605'];

        // Load random cat image (simulated static URL)
        function loadRandomCat() {
            const randomCatUrl = 'https://placekitten.com/600/400'; // Simulated static URL
            document.querySelector('.cat-image').src = randomCatUrl;
            currentImageUrl = randomCatUrl;
        }

        // Load breeds
        function loadBreeds() {
            const select = document.getElementById('breed-select');
            breedsData.forEach(breed => {
                const option = document.createElement('option');
                option.value = breed.id;
                option.textContent = breed.name;
                select.appendChild(option);
            });
        }

        // Load breed images and info
        function loadBreedInfo(breedId) {
            const breed = breedsData.find(b => b.id == breedId);
            if (breed) {
                const content = document.getElementById('breed-content');
                content.innerHTML = `
                    <div class="slideshow-container">
                        ${breed.images.map(img => `
                            <div class="slide">
                                <img src="${img}" alt="Cat Image">
                            </div>
                        `).join('')}
                        <a class="prev">❮</a>
                        <a class="next">❯</a>
                    </div>
                    <div class="breed-info">
                        <h2>${breed.name} (${breed.origin})</h2>
                        <p>${breed.description}</p>
                        <a href="${breed.wikipedia_url}" target="_blank" class="wiki-link">Learn more on Wikipedia</a>
                    </div>
                `;
                currentSlide = 0;
                initializeSlideshow();
            }
        }

        // Load favorites
        function loadFavorites() {
            const grid = document.querySelector('.favorites-grid');
            if (favoriteImages.length > 0) {
                grid.innerHTML = favoriteImages
                    .map(url => `<img class="favorite-image" src="${url}" alt="Favorite Cat">`)
                    .join('');
            } else {
                grid.innerHTML = '<p>No favorite cats yet!</p>';
            }
        }

        // Initialize slideshow controls
        function initializeSlideshow() {
            const slides = document.querySelectorAll('.slide');
            if (slides.length === 0) return;

            function showSlides() {
                slides.forEach(slide => slide.style.display = 'none');
                slides[currentSlide].style.display = 'block';
            }

            document.querySelector('.prev').addEventListener('click', () => {
                currentSlide = (currentSlide - 1 + slides.length) % slides.length;
                showSlides();
            });

            document.querySelector('.next').addEventListener('click', () => {
                currentSlide = (currentSlide + 1) % slides.length;
                showSlides();
            });

            showSlides();
        }

        // Event Listeners
        document.addEventListener('DOMContentLoaded', () => {
            $('#breed-select').select2();

            loadRandomCat(); // Load initial random cat
            loadBreeds(); // Load breeds on page load

            document.querySelectorAll('.nav-item').forEach(item => {
                item.addEventListener('click', () => {
                    const section = item.dataset.section;
                    
                    document.querySelectorAll('.nav-item').forEach(nav => nav.classList.remove('active'));
                    document.querySelectorAll('.section').forEach(section => section.classList.remove('active'));
                    
                    item.classList.add('active');
                    document.getElementById(section).classList.add('active');

                    if (section === 'home') {
                        loadRandomCat();
                    } else if (section === 'breeds') {
                        loadBreeds();
                    } else if (section === 'favorites') {
                        loadFavorites();
                    }
                });
            });

            document.getElementById('breed-select').addEventListener('change', function() {
                const breedId = this.value;
                if (breedId) {
                    loadBreedInfo(breedId);
                }
            });

            document.querySelector('.love-button').addEventListener('click', () => {
                if (currentImageUrl) {
                    favoriteImages.push(currentImageUrl);
                    alert('Added to favorites!');
                }
            });

            document.querySelectorAll('.vote-button').forEach(button => {
                button.addEventListener('click', () => {
                    loadRandomCat();
                });
            });
        });
    </script>
</body>
</html>
