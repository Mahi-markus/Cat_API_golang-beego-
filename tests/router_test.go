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

func TestMainControllerRoute(t *testing.T) {
	setupTestApp()

	req, _ := http.NewRequest("GET", "/", nil)
	w := httptest.NewRecorder()
	web.BeeApp.Handlers.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Contains(t, w.Body.String(), "Welcome") // Assuming "Welcome" is part of the MainController response.
}

func TestCatHomeRoute(t *testing.T) {
	setupTestApp()

	req, _ := http.NewRequest("GET", "/cat1", nil)
	w := httptest.NewRecorder()
	web.BeeApp.Handlers.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Contains(t, w.Body.String(), "Cat Home Page") // Update the assertion based on your actual response.
}

func TestCatBreedsRoute(t *testing.T) {
	setupTestApp()

	req, _ := http.NewRequest("GET", "/cat/breeds", nil)
	w := httptest.NewRecorder()
	web.BeeApp.Handlers.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Contains(t, w.Body.String(), "Breeds List") // Update based on actual response.
}

func TestVoteRoute(t *testing.T) {
	setupTestApp()

	body := []byte(`{"image_id":"test-id","value":1}`)
	req, _ := http.NewRequest("POST", "/cat/vote", bytes.NewReader(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	web.BeeApp.Handlers.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Contains(t, w.Body.String(), "Vote Recorded") // Update based on actual response.
}

func TestAddFavoriteRoute(t *testing.T) {
	setupTestApp()

	body := []byte(`{"image_id":"test-id","sub_id":"test-sub"}`)
	req, _ := http.NewRequest("POST", "/cat/love", bytes.NewReader(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	web.BeeApp.Handlers.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Contains(t, w.Body.String(), "Favorite Added") // Update based on actual response.
}

func TestGetFavoritesRoute(t *testing.T) {
	setupTestApp()

	req, _ := http.NewRequest("GET", "/cat/favs", nil)
	w := httptest.NewRecorder()
	web.BeeApp.Handlers.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Contains(t, w.Body.String(), "Favorites List") // Update based on actual response.
}

func TestBreedImagesRoute(t *testing.T) {
	setupTestApp()

	req, _ := http.NewRequest("GET", "/cat/breed_images", nil)
	w := httptest.NewRecorder()
	web.BeeApp.Handlers.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Contains(t, w.Body.String(), "Breed Images") // Update based on actual response.
}
