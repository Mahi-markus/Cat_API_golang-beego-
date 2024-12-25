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

    <link href="/static/css/style.css" rel="stylesheet" />
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
        <p>No image voted</p>
        {{ end }}
      </div>
    </div>

    <script src="/static/js/script.js"></script>
  </body>
</html>
