<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Cat Gallery</title>
    <link
      href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/css/select2.min.css"
      rel="stylesheet"
    />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/js/select2.min.js"></script>

    <style>
      body {
        font-family: Arial, sans-serif;
        background-color: #f9f9f9;
        margin: 0;
        padding: 0;
      }

      .nav {
        display: flex;
        justify-content: space-around;
        margin-bottom: 20px;
        padding: 20px;
        background-color: white;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
      }

      .nav a {
        text-decoration: none;
        color: #333;
        font-weight: bold;
        font-size: 16px;
        padding: 10px 20px;
        transition: color 0.3s, background-color 0.3s;
        border-radius: 5px;
        cursor: pointer;
        display: flex;
        align-items: center;
        gap: 8px;
      }

      .nav a.active {
        background-color: #007bff;
        color: white;
      }

      .section {
        display: none;
        padding: 20px;
      }

      .section.active {
        display: block;
      }

      .container {
        display: flex;
        flex-direction: column;
        align-items: center;
        background-color: #fff;
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        padding: 20px;
        width: 600px;
        margin: 50px auto;
      }

      .cat-image {
        width: 500px;
        height: 300px;
        object-fit: cover;
        border-radius: 10px;
        margin-bottom: 20px;
      }

      .button-row {
        display: flex;
        justify-content: space-between;
        width: 100%;
        max-width: 300px;
        margin-top: 20px;
      }

      button {
        background-color: #f0f0f0;
        border: none;
        border-radius: 5px;
        padding: 10px 20px;
        cursor: pointer;
        transition: background-color 0.3s;
        font-size: 16px;
      }

      button:hover {
        background-color: #e0e0e0;
      }

      .breed-select {
        width: 80%;
        max-width: 600px;
        margin: 50px auto;
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
        padding: 20px;
        box-sizing: border-box;
      }

      .breed-select label {
        display: block;
        margin-bottom: 10px;
        font-size: 18px;
        color: #333;
        font-weight: bold;
      }

      .breed-select select {
        width: 100%;
        padding: 12px;
        border-radius: 4px;
        border: 1px solid #ddd;
      }

      .slideshow-container {
        position: relative;
        max-width: 600px;
        margin: 30px auto;
        background: #fff;
        border-radius: 10px;
        box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
        overflow: hidden;
      }

      .slide {
        display: none;
        text-align: center;
        padding: 20px;
      }

      .slide.active {
        display: block;
      }

      .slide img {
        width: 100%;
        max-height: 400px;
        object-fit: cover;
        border-radius: 8px;
      }

      .prev,
      .next {
        position: absolute;
        top: 50%;
        transform: translateY(-50%);
        padding: 16px;
        background: rgba(0, 0, 0, 0.6);
        color: white;
        cursor: pointer;
        font-weight: bold;
        font-size: 18px;
        transition: 0.3s ease;
        user-select: none;
        z-index: 1;
      }

      .prev {
        left: 0;
        border-radius: 0 3px 3px 0;
      }

      .next {
        right: 0;
        border-radius: 3px 0 0 3px;
      }

      .prev:hover,
      .next:hover {
        background: rgba(0, 0, 0, 0.8);
      }

      .breed-info {
        max-width: 600px;
        margin: 20px auto;
        padding: 20px;
        background: #fff;
        border-radius: 10px;
        box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
      }

      .breed-info h2 {
        color: #333;
        margin-bottom: 15px;
      }

      .breed-info p {
        color: #666;
        line-height: 1.6;
        margin-bottom: 15px;
      }

      .breed-info a {
        display: inline-block;
        padding: 8px 15px;
        background: #007bff;
        color: white;
        text-decoration: none;
        border-radius: 5px;
        transition: background 0.3s;
      }

      .breed-info a:hover {
        background: #0056b3;
      }

      .gallery {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
        gap: 20px;
        padding: 20px;
        max-width: 1200px;
        margin: 0 auto;
      }

      .gallery img {
        width: 100%;
        height: 300px;
        object-fit: cover;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        transition: transform 0.3s;
      }

      .gallery img:hover {
        transform: scale(1.03);
      }

      .error {
        color: red;
        padding: 20px;
        text-align: center;
        background: #fff;
        border-radius: 8px;
        margin: 20px auto;
        max-width: 600px;
      }

      @media (max-width: 768px) {
        .container {
          width: 90%;
          padding: 15px;
        }

        .cat-image {
          width: 100%;
          height: 250px;
        }

        .button-row {
          max-width: 100%;
        }

        .breed-select,
        .breed-info {
          width: 90%;
        }
      }
    </style>
  </head>
  <body>
    <div class="nav">
      <a href="#" data-section="voting" class="active">
        <svg
          width="24"
          height="24"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
        >
          <path d="M12 20V4M4 12l8-8 8 8" />
        </svg>
        Voting
      </a>
      <a href="#" data-section="breeds">
        <svg
          width="24"
          height="24"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
        >
          <circle cx="11" cy="11" r="8" />
          <path d="M21 21l-4.35-4.35" />
        </svg>
        Breeds
      </a>
      <a href="#" data-section="favorites">
        <svg
          width="24"
          height="24"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
        >
          <path
            d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 0 0 0-7.78z"
          />
        </svg>
        Favorites
      </a>
    </div>

    <div id="voting-section" class="section active">
      <div class="container">
        <img
          id="catImage"
          src="{{.ImageURL}}"
          alt="Cat Image"
          class="cat-image"
        />
        <div class="button-row">
          <button id="love-button" title="Love">❤️</button>
          <div>
            <button onclick="vote(1)" title="Like">👍</button>
            <button onclick="vote(-1)" title="Dislike">👎</button>
          </div>
        </div>
      </div>
    </div>

    <div id="breeds-section" class="section">
      <div class="breed-select">
        <label for="breed">Choose a Breed:</label>
        <select name="id" id="breed" required>
          <option value="">-- Select Breed --</option>
          {{
            range.Breeds
          }}
          <option value="{{.ID}}">{{.Name}}</option>
          {{
            end
          }}
        </select>
      </div>
      <div id="breed-details" style="display: none">
        <div class="slideshow-container">
          <div id="breed-slides"></div>
          <a class="prev" onclick="changeSlide(-1)">&#10094;</a>
          <a class="next" onclick="changeSlide(1)">&#10095;</a>
        </div>
        <div class="breed-info">
          <h2 id="breed-name"></h2>
          <p id="breed-description"></p>
          <p><strong>Origin:</strong> <span id="breed-origin"></span></p>
          <a id="breed-wiki" href="" target="_blank">Learn More on Wikipedia</a>
        </div>
      </div>
    </div>

    <div id="favorites-section" class="section">
      <div id="favorites-gallery" class="gallery">
        {{ range.LovedImages }}
        <img src="{{.}}" alt="Loved Cat Image" />
        {{else}}
        <p>No loved images yet.</p>
        {{ end }}
      </div>
    </div>

    <script>
      let currentImageId = null;
      let slideIndex = 0;

      document.querySelectorAll(".nav a").forEach((link) => {
        link.addEventListener("click", function (e) {
          e.preventDefault();
          document
            .querySelectorAll(".nav a")
            .forEach((a) => a.classList.remove("active"));
          this.classList.add("active");

          const section = this.dataset.section;
          document
            .querySelectorAll(".section")
            .forEach((s) => s.classList.remove("active"));
          document.getElementById(`${section}-section`).classList.add("active");

          if (section === "voting") loadRandomCat();
          if (section === "breeds") loadBreeds();
          if (section === "favorites") loadFavorites();
        });
      });

      $(document).ready(function () {
        try {
          $("#breed").select2();

          $("#breed").on("change", function () {
            const breedId = this.value;
            if (breedId) {
              loadBreedImages(breedId);
            } else {
              document.getElementById("breed-details").style.display = "none";
            }
          });

          loadRandomCat();
        } catch (error) {
          console.error("Error initializing Select2:", error);
        }
      });

      function loadRandomCat() {
        fetch("/cat1")
          .then((response) => {
            if (!response.ok) throw new Error("Failed to load random cat");
            return response.text();
          })
          .then((html) => {
            const parser = new DOMParser();
            const doc = parser.parseFromString(html, "text/html");
            const imgUrl = doc.querySelector("#catImage").src;
            document.querySelector("#catImage").src = imgUrl;
            currentImageId = getImageIdFromUrl(imgUrl);
          })
          .catch((error) => {
            console.error("Error loading random cat:", error);
            alert("Failed to load new cat image. Please try again.");
          });
      }

      function getImageIdFromUrl(url) {
        const parts = url.split("/");
        return parts[parts.length - 1].split(".")[0];
      }

      function vote(value) {
        if (!currentImageId) return;

        fetch("/cat/vote", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            image_id: currentImageId,
            sub_id: "user-123",
            value: value,
          }),
        })
          .then((response) => {
            if (!response.ok) throw new Error("Failed to submit vote");
            loadRandomCat();
            return response.json();
          })
          .catch((error) => {
            console.error("Error voting:", error);
            alert("Failed to submit vote. Please try again.");
          });
      }

      function loadBreedImages(breedId) {
        fetch(`/cat/breed_images?id=${breedId}`)
          .then((response) => {
            if (!response.ok) {
              throw new Error(`HTTP error! status: ${response.status}`);
            }
            return response.json();
          })
          .then((data) => {
            // Debug the response
            console.log("Breed data received:", data);

            if (!data) {
              throw new Error("No data received");
            }

            // Update breed information
            document.getElementById("breed-name").textContent =
              data.BreedName || "";
            document.getElementById("breed-description").textContent =
              data.Description || "";
            document.getElementById("breed-origin").textContent =
              data.Origin || "";
            document.getElementById("breed-wiki").href =
              data.WikipediaURL || "#";

            // Check if Images exists and has items
            if (data.Images && data.Images.length > 0) {
              const slidesHTML = data.Images.map(
                (image, index) => `
          <div class="slide ${index === 0 ? "active" : ""}">
            <img src="${image.url}" alt="${data.BreedName || "Cat"} image">
          </div>
        `
              ).join("");

              document.getElementById("breed-slides").innerHTML = slidesHTML;
              document.getElementById("breed-details").style.display = "block";
              slideIndex = 0;
              showSlides(0);
            } else {
              throw new Error("No images found for this breed");
            }
          })
          .catch((error) => {
            console.error("Error details:", error);
            document.getElementById("breed-details").style.display = "none";
            alert("Failed to load breed information. Please try again.");
          });
      }

      function changeSlide(n) {
        showSlides(slideIndex + n);
      }

      function showSlides(n) {
        const slides = document.getElementsByClassName("slide");
        if (!slides.length) return;

        slideIndex = n;
        if (slideIndex >= slides.length) slideIndex = 0;
        if (slideIndex < 0) slideIndex = slides.length - 1;

        Array.from(slides).forEach((slide) => {
          slide.style.display = "none";
          slide.classList.remove("active");
        });

        slides[slideIndex].style.display = "block";
        slides[slideIndex].classList.add("active");
      }

      document
        .getElementById("love-button")
        .addEventListener("click", function () {
          if (!currentImageId) return;

          fetch("/cat/love", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
              image_id: currentImageId,
              sub_id: "user-123",
            }),
          })
            .then((response) => {
              if (!response.ok) throw new Error("Failed to add to favorites");
              this.style.backgroundColor = "#ffecec";
              return response.json();
            })
            .then(() => {
              const message = document.createElement("div");
              message.textContent = "Added to favorites!";
              message.style.cssText =
                "position: fixed; top: 20px; right: 20px; background: #4CAF50; color: white; padding: 10px 20px; border-radius: 5px; animation: fadeOut 2s forwards;";
              document.body.appendChild(message);
              setTimeout(() => message.remove(), 2000);
            })
            .catch((error) => {
              console.error("Error adding to favorites:", error);
              alert("Failed to add to favorites. Please try again.");
            });
        });

      function loadBreeds() {
        fetch("/cat/breeds")
          .then((response) => response.text())
          .then((html) => {
            const parser = new DOMParser();
            const doc = parser.parseFromString(html, "text/html");
            const breedSelect = doc.querySelector("#breed");
            if (breedSelect) {
              document.querySelector("#breed").innerHTML =
                breedSelect.innerHTML;
              $("#breed").trigger("change.select2");
            }
          })
          .catch((error) => {
            console.error("Error loading breeds:", error);
            alert("Failed to load breeds. Please try again.");
          });
      }

      function loadFavorites() {
        fetch("/cat/favs")
          .then((response) => {
            if (!response.ok) throw new Error("Failed to load favorites");
            return response.text();
          })
          .then((html) => {
            const parser = new DOMParser();
            const doc = parser.parseFromString(html, "text/html");
            const gallery = doc.querySelector(".gallery");
            if (gallery) {
              document.getElementById("favorites-gallery").innerHTML =
                gallery.innerHTML;
            }
          })
          .catch((error) => {
            console.error("Error loading favorites:", error);
            document.getElementById("favorites-gallery").innerHTML =
              '<p class="error">Failed to load favorites. Please try again later.</p>';
          });
      }

      document.addEventListener("keydown", function (e) {
        if (
          document.getElementById("breeds-section").classList.contains("active")
        ) {
          if (e.key === "ArrowLeft") {
            changeSlide(-1);
          } else if (e.key === "ArrowRight") {
            changeSlide(1);
          }
        }
      });
    </script>
  </body>
</html>
