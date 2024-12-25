package controllers

import (
	"bytes"
	"encoding/json"
	"io"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/beego/beego/v2/server/web"
	"github.com/stretchr/testify/assert"
)

// Define necessary request structures
type VoteRequest struct {
	ImageID string `json:"image_id"`
	SubID   string `json:"sub_id"`
	Value   int    `json:"value"`
}

type FavoriteRequest struct {
	ImageID string `json:"image_id"`
	SubID   string `json:"sub_id"`
}

func TestCatController(t *testing.T) {
	controller := &CatController{}

	t.Run("Home", func(t *testing.T) {
		r := httptest.NewRequest("GET", "/", nil)
		w := httptest.NewRecorder()

		controller.Ctx = web.NewContext()
		controller.Ctx.Reset(w, r)

		controller.Home()

		assert.Contains(t, controller.Data, "ImageURL")
		assert.Equal(t, "single_page.tpl", controller.TplName)
	})

	t.Run("Breeds", func(t *testing.T) {
		r := httptest.NewRequest("GET", "/breeds", nil)
		w := httptest.NewRecorder()

		controller.Ctx = web.NewContext()
		controller.Ctx.Reset(w, r)

		controller.Breeds()

		assert.Contains(t, controller.Data, "Breeds")
		assert.Equal(t, "single_page.tpl", controller.TplName)
	})
}

func TestVotingController(t *testing.T) {
	controller := &VotingController{}

	t.Run("Vote_ValidRequest", func(t *testing.T) {
		voteReq := VoteRequest{
			ImageID: "test123",
			SubID:   "user123",
			Value:   1,
		}
		reqBody, _ := json.Marshal(voteReq)

		r := httptest.NewRequest("POST", "/vote", bytes.NewBuffer(reqBody))
		w := httptest.NewRecorder()

		controller.Ctx = web.NewContext()
		controller.Ctx.Reset(w, r)
		controller.Ctx.Input.RequestBody = reqBody

		controller.Vote()

		var resp map[string]interface{}
		json.NewDecoder(w.Body).Decode(&resp)

		assert.Contains(t, resp, "message")
		assert.Equal(t, http.StatusOK, w.Code)
	})

	t.Run("AddFavorite_ValidRequest", func(t *testing.T) {
		favReq := FavoriteRequest{
			ImageID: "test123",
			SubID:   "user123",
		}
		reqBody, _ := json.Marshal(favReq)

		r := httptest.NewRequest("POST", "/favorite", bytes.NewBuffer(reqBody))
		w := httptest.NewRecorder()

		controller.Ctx = web.NewContext()
		controller.Ctx.Reset(w, r)
		controller.Ctx.Request.Body = io.NopCloser(bytes.NewBuffer(reqBody))

		controller.AddFavorite()

		assert.Equal(t, http.StatusOK, w.Code)
	})

	t.Run("AddFavorite_InvalidRequest", func(t *testing.T) {
		reqBody := []byte(`{"invalid":"json"}`)

		r := httptest.NewRequest("POST", "/favorite", bytes.NewBuffer(reqBody))
		w := httptest.NewRecorder()

		controller.Ctx = web.NewContext()
		controller.Ctx.Reset(w, r)
		controller.Ctx.Request.Body = io.NopCloser(bytes.NewBuffer(reqBody))

		controller.AddFavorite()

		assert.Equal(t, http.StatusBadRequest, w.Code)
	})
}

func TestFavoritesController(t *testing.T) {
	controller := &FavoritesController{}

	t.Run("GetFavorites", func(t *testing.T) {
		mockResp := `[{"image":{"url":"test.jpg"}}]`
		r := httptest.NewRequest("GET", "/favorites", nil)
		w := httptest.NewRecorder()

		controller.Ctx = web.NewContext()
		controller.Ctx.Reset(w, r)

		// Mock API response
		client := &mockHTTPClient{
			DoFunc: func(req *http.Request) (*http.Response, error) {
				return &http.Response{
					Body: io.NopCloser(bytes.NewBufferString(mockResp)),
				}, nil
			},
		}

		controller.GetFavorites()

		assert.Contains(t, controller.Data, "LovedImages")
		assert.Equal(t, "single_page.tpl", controller.TplName)
	})
}
