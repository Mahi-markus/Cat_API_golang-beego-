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
      document.getElementById("breed-name").textContent = data.BreedName || "";
      document.getElementById("breed-description").textContent =
        data.Description || "";
      document.getElementById("breed-origin").textContent = data.Origin || "";
      document.getElementById("breed-wiki").href = data.WikipediaURL || "#";

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

document.getElementById("love-button").addEventListener("click", function () {
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
        document.querySelector("#breed").innerHTML = breedSelect.innerHTML;
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
  if (document.getElementById("breeds-section").classList.contains("active")) {
    if (e.key === "ArrowLeft") {
      changeSlide(-1);
    } else if (e.key === "ArrowRight") {
      changeSlide(1);
    }
  }
});
