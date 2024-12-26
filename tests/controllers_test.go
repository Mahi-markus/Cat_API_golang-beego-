package tests

import (
	"bytes"
	"fmt"
	"io"
	"net/http"
	"net/http/httptest"
	"os"
	"testing"

	"github.com/beego/beego/v2/server/web"
	"github.com/beego/beego/v2/server/web/context"
	"github.com/stretchr/testify/assert"
	"my-beego-app/controllers"
)

// MockTransport to intercept all HTTP calls
type MockTransport struct {
	// Map of URL patterns to their responses
	MockResponses map[string]struct {
		Response   string
		StatusCode int
		Error      error
	}
}

func NewMockTransport() *MockTransport {
	return &MockTransport{
		MockResponses: make(map[string]struct {
			Response   string
			StatusCode int
			Error      error
		}),
	}
}

func (m *MockTransport) RoundTrip(req *http.Request) (*http.Response, error) {
	// Log the attempted API call for debugging
	fmt.Printf("Mock intercepted request to: %s\n", req.URL.String())

	// Find matching mock response
	for urlPattern, mockResp := range m.MockResponses {
		if req.URL.String() == urlPattern {
			if mockResp.Error != nil {
				return nil, mockResp.Error
			}

			return &http.Response{
				StatusCode: mockResp.StatusCode,
				Body:       io.NopCloser(bytes.NewBufferString(mockResp.Response)),
				Header:     make(http.Header),
			}, nil
		}
	}

	// If no mock found, return a default 404 response
	return &http.Response{
		StatusCode: http.StatusNotFound,
		Body:       io.NopCloser(bytes.NewBufferString(`{"error": "not found"}`)),
		Header:     make(http.Header),
	}, nil
}

// Helper to setup mock responses
func (m *MockTransport) AddMockResponse(url string, response string, statusCode int, err error) {
	m.MockResponses[url] = struct {
		Response   string
		StatusCode int
		Error      error
	}{
		Response:   response,
		StatusCode: statusCode,
		Error:      err,
	}
}

// Helper function to create test context
func createTestContext(method, url string, body []byte) (*web.Controller, *httptest.ResponseRecorder) {
	r := httptest.NewRequest(method, url, bytes.NewReader(body))
	w := httptest.NewRecorder()
	
	ctx := context.NewContext()
	ctx.Reset(w, r)
	ctx.Request = r
	ctx.ResponseWriter = &context.Response{
		ResponseWriter: w,
	}
	
	controller := &web.Controller{}
	controller.Init(ctx, "", "", nil)
	
	return controller, w
}

func TestMain(m *testing.M) {
	// Setup test environment
	if err := os.MkdirAll("conf", 0755); err != nil {
		panic(err)
	}
	if err := os.WriteFile("conf/app.conf", []byte("cat_api_key=test_key"), 0644); err != nil {
		panic(err)
	}
	if err := os.MkdirAll("views", 0755); err != nil {
		panic(err)
	}
	if err := os.WriteFile("views/single_page.tpl", []byte("<html><body>{{.}}</body></html>"), 0644); err != nil {
		panic(err)
	}

	web.BConfig.WebConfig.ViewsPath = "views"
	
	// Run tests
	code := m.Run()
	
	// Cleanup
	os.RemoveAll("conf")
	os.RemoveAll("views")
	os.Exit(code)
}

func TestAddFavorite(t *testing.T) {
	tests := []struct {
		name           string
		requestBody    string
		mockResponse   string
		mockStatusCode int
		expectedStatus int
	}{
		{
			name:           "Success",
			requestBody:    `{"image_id":"test-image","sub_id":"test-sub"}`,
			mockResponse:   `{"id": 123, "message": "SUCCESS"}`,
			mockStatusCode: http.StatusOK,
			expectedStatus: http.StatusOK,
		},
		{
			name:           "Invalid Request Body",
			requestBody:    `invalid json`,
			expectedStatus: http.StatusBadRequest,
		},
		{
			name:           "Missing Image ID",
			requestBody:    `{"sub_id":"test-sub"}`,
			expectedStatus: http.StatusBadRequest,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			mockTransport := NewMockTransport()
			mockTransport.AddMockResponse(
				"https://api.thecatapi.com/v1/favourites",
				tt.mockResponse,
				tt.mockStatusCode,
				nil,
			)
			http.DefaultClient.Transport = mockTransport

			controller := &controllers.VotingController{}
			baseCtrl, w := createTestContext("POST", "/v1/favorites", []byte(tt.requestBody))
			controller.Controller = *baseCtrl
			
			controller.AddFavorite()

			assert.Equal(t, tt.expectedStatus, w.Code)
		})
	}
}

func TestGetFavorites(t *testing.T) {
	mockTransport := NewMockTransport()
	mockTransport.AddMockResponse(
		"https://api.thecatapi.com/v1/favourites",
		`[{"id": 1, "image": {"url": "http://example.com/cat.jpg"}}]`,
		http.StatusOK,
		nil,
	)
	http.DefaultClient.Transport = mockTransport

	controller := &controllers.FavoritesController{}
	baseCtrl, _ := createTestContext("GET", "/v1/favorites", nil)
	controller.Controller = *baseCtrl
	
	controller.GetFavorites()
	
	assert.Equal(t, "single_page.tpl", controller.TplName)
}

func TestHome(t *testing.T) {
	mockTransport := NewMockTransport()
	mockTransport.AddMockResponse(
		"https://api.thecatapi.com/v1/images/search",
		`[{"url": "http://example.com/cat.jpg"}]`,
		http.StatusOK,
		nil,
	)
	http.DefaultClient.Transport = mockTransport

	controller := &controllers.CatController{}
	baseCtrl, _ := createTestContext("GET", "/", nil)
	controller.Controller = *baseCtrl
	
	controller.Home()
	
	assert.Equal(t, "single_page.tpl", controller.TplName)
}

func TestBreeds(t *testing.T) {
	mockTransport := NewMockTransport()
	mockTransport.AddMockResponse(
		"https://api.thecatapi.com/v1/breeds",
		`[{"id": "abys", "name": "Abyssinian", "origin": "Egypt", "description": "Active cat"}]`,
		http.StatusOK,
		nil,
	)
	http.DefaultClient.Transport = mockTransport

	controller := &controllers.CatController{}
	baseCtrl, _ := createTestContext("GET", "/breeds", nil)
	controller.Controller = *baseCtrl
	
	controller.Breeds()
	
	assert.Equal(t, "single_page.tpl", controller.TplName)
}

func TestBreedImages(t *testing.T) {
	mockTransport := NewMockTransport()
	// Mock both required endpoints
	mockTransport.AddMockResponse(
		"https://api.thecatapi.com/v1/images/search?breed_ids=abys&limit=5",
		`[{"url": "http://example.com/cat.jpg"}]`,
		http.StatusOK,
		nil,
	)
	mockTransport.AddMockResponse(
		"https://api.thecatapi.com/v1/breeds/abys",
		`{"name": "Abyssinian", "description": "Active", "origin": "Egypt"}`,
		http.StatusOK,
		nil,
	)
	http.DefaultClient.Transport = mockTransport

	controller := &controllers.CatController{}
	baseCtrl, w := createTestContext("GET", "/breed-images?id=abys", nil)
	controller.Controller = *baseCtrl
	
	controller.BreedImages()
	
	assert.Equal(t, http.StatusOK, w.Code)
}

func TestMainController(t *testing.T) {
	controller := &controllers.MainController{}
	baseCtrl, _ := createTestContext("GET", "/", nil)
	controller.Controller = *baseCtrl
	
	controller.Get()

	assert.Equal(t, "beego.vip", controller.Data["Website"])
	assert.Equal(t, "astaxie@gmail.com", controller.Data["Email"])
	assert.Equal(t, "single_page.tpl", controller.TplName)
}