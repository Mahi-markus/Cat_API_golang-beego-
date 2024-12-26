package tests

import (
	"bytes"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/beego/beego/v2/server/web"
	"github.com/stretchr/testify/assert"
	"my-beego-app/controllers"
)

// Define a mock API key for the tests
const mockAPIKey = "mock-api-key"

// setupTestApp initializes the Beego application with fake API handlers for testing.
func setupTestApp() {
	web.Router("/", &controllers.MainController{})
	web.Router("/cat1", &controllers.CatController{}, "get:Home")
	web.Router("/cat/breeds", &controllers.CatController{}, "get:Breeds")
	web.Router("/cat/vote", &controllers.VotingController{}, "post:Vote")
	web.Router("/cat/breed_images", &controllers.CatController{}, "get:BreedImages")
	web.Router("/cat/love", &controllers.VotingController{}, "post:AddFavorite")
	web.Router("/cat/favs", &controllers.FavoritesController{}, "get:GetFavorites")
}

// Function to add the mock API key to the request header
func addMockAPIKey(req *http.Request) {
	req.Header.Set("X-API-Key", mockAPIKey)
}

func TestMainControllerRoute(t *testing.T) {
	setupTestApp()

	req, _ := http.NewRequest("GET", "/", nil)
	addMockAPIKey(req)  // Set mock API key
	w := httptest.NewRecorder()
	web.BeeApp.Handlers.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Contains(t, w.Body.String(), "Welcome") // Assuming "Welcome" is part of the MainController response.
}

func TestCatHomeRoute(t *testing.T) {
	setupTestApp()

	req, _ := http.NewRequest("GET", "/cat1", nil)
	addMockAPIKey(req)  // Set mock API key
	w := httptest.NewRecorder()
	web.BeeApp.Handlers.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Contains(t, w.Body.String(), "Cat Home Page") // Update the assertion based on your actual response.
}

func TestCatBreedsRoute(t *testing.T) {
	setupTestApp()

	req, _ := http.NewRequest("GET", "/cat/breeds", nil)
	addMockAPIKey(req)  // Set mock API key
	w := httptest.NewRecorder()
	web.BeeApp.Handlers.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Contains(t, w.Body.String(), "Breeds List") // Update based on actual response.
}

func TestVoteRoute(t *testing.T) {
	setupTestApp()

	// Test with valid data
	body := []byte(`{"image_id":"test-id","value":1}`)
	req, _ := http.NewRequest("POST", "/cat/vote", bytes.NewReader(body))
	req.Header.Set("Content-Type", "application/json")
	addMockAPIKey(req)  // Set mock API key
	w := httptest.NewRecorder()
	web.BeeApp.Handlers.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Contains(t, w.Body.String(), "Vote Recorded") // Update based on actual response.

	// Test with empty data
	body = []byte(`{}`)
	req, _ = http.NewRequest("POST", "/cat/vote", bytes.NewReader(body))
	req.Header.Set("Content-Type", "application/json")
	addMockAPIKey(req)
	w = httptest.NewRecorder()
	web.BeeApp.Handlers.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)
	assert.Contains(t, w.Body.String(), "Missing required field")

	// Test with invalid data (e.g., missing value)
	body = []byte(`{"image_id":"test-id"}`)
	req, _ = http.NewRequest("POST", "/cat/vote", bytes.NewReader(body))
	req.Header.Set("Content-Type", "application/json")
	addMockAPIKey(req)
	w = httptest.NewRecorder()
	web.BeeApp.Handlers.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)
	assert.Contains(t, w.Body.String(), "Missing required field")

	// Test with invalid JSON
	body = []byte(`{"image_id":"test-id", "value":}`)
	req, _ = http.NewRequest("POST", "/cat/vote", bytes.NewReader(body))
	req.Header.Set("Content-Type", "application/json")
	addMockAPIKey(req)
	w = httptest.NewRecorder()
	web.BeeApp.Handlers.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)
	assert.Contains(t, w.Body.String(), "Invalid JSON")
}

func TestAddFavoriteRoute(t *testing.T) {
	setupTestApp()

	// Valid data
	body := []byte(`{"image_id":"test-id","sub_id":"test-sub"}`)
	req, _ := http.NewRequest("POST", "/cat/love", bytes.NewReader(body))
	req.Header.Set("Content-Type", "application/json")
	addMockAPIKey(req)  // Set mock API key
	w := httptest.NewRecorder()
	web.BeeApp.Handlers.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Contains(t, w.Body.String(), "Favorite Added") // Update based on actual response.

	// Test with missing "sub_id"
	body = []byte(`{"image_id":"test-id"}`)
	req, _ = http.NewRequest("POST", "/cat/love", bytes.NewReader(body))
	req.Header.Set("Content-Type", "application/json")
	addMockAPIKey(req)
	w = httptest.NewRecorder()
	web.BeeApp.Handlers.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)
	assert.Contains(t, w.Body.String(), "Missing required field")

	// Test with empty data
	body = []byte(`{}`)
	req, _ = http.NewRequest("POST", "/cat/love", bytes.NewReader(body))
	req.Header.Set("Content-Type", "application/json")
	addMockAPIKey(req)
	w = httptest.NewRecorder()
	web.BeeApp.Handlers.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)
	assert.Contains(t, w.Body.String(), "Missing required field")
}

func TestGetFavoritesRoute(t *testing.T) {
	setupTestApp()

	req, _ := http.NewRequest("GET", "/cat/favs", nil)
	addMockAPIKey(req)  // Set mock API key
	w := httptest.NewRecorder()
	web.BeeApp.Handlers.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Contains(t, w.Body.String(), "Favorites List") // Update based on actual response.

	// Test with incorrect method (POST instead of GET)
	req, _ = http.NewRequest("POST", "/cat/favs", nil)
	addMockAPIKey(req)
	w = httptest.NewRecorder()
	web.BeeApp.Handlers.ServeHTTP(w, req)

	assert.Equal(t, http.StatusMethodNotAllowed, w.Code)
}

func TestBreedImagesRoute(t *testing.T) {
	setupTestApp()

	req, _ := http.NewRequest("GET", "/cat/breed_images", nil)
	addMockAPIKey(req)  // Set mock API key
	w := httptest.NewRecorder()
	web.BeeApp.Handlers.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Contains(t, w.Body.String(), "Breed Images") // Update based on actual response.

	// Test with incorrect method (POST instead of GET)
	req, _ = http.NewRequest("POST", "/cat/breed_images", nil)
	addMockAPIKey(req)
	w = httptest.NewRecorder()
	web.BeeApp.Handlers.ServeHTTP(w, req)

	assert.Equal(t, http.StatusMethodNotAllowed, w.Code)
}

func TestInvalidRoute(t *testing.T) {
	setupTestApp()

	// Testing a route that doesn't exist, expecting a 404 response
	req, _ := http.NewRequest("GET", "/nonexistent", nil)
	addMockAPIKey(req)  // Set mock API key
	w := httptest.NewRecorder()
	web.BeeApp.Handlers.ServeHTTP(w, req)

	assert.Equal(t, http.StatusNotFound, w.Code)
}

func TestCatHomeRouteInvalidMethod(t *testing.T) {
	setupTestApp()

	// Testing an incorrect HTTP method for /cat1 (which expects GET)
	req, _ := http.NewRequest("POST", "/cat1", nil)
	addMockAPIKey(req)  // Set mock API key
	w := httptest.NewRecorder()
	web.BeeApp.Handlers.ServeHTTP(w, req)

	assert.Equal(t, http.StatusMethodNotAllowed, w.Code)
}
