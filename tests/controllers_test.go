package tests

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"net/http/httptest"
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/beego/beego/v2/server/web"
	"github.com/beego/beego/v2/server/web/context"
	"github.com/stretchr/testify/assert"
	"my-beego-app/controllers"
)

func init() {
	// Create test config file
	err := os.MkdirAll("conf", 0755)
	if err != nil {
		fmt.Printf("Error creating conf directory: %v\n", err)
		return
	}

	configContent := `appname = testapp
httpport = 8080
runmode = test
cat_api_key = test_api_key`

	err = os.WriteFile("conf/app.conf", []byte(configContent), 0644)
	if err != nil {
		fmt.Printf("Error writing config file: %v\n", err)
		return
	}

	// Set up view path for templates
	web.BConfig.WebConfig.ViewsPath = "views"
	
	// Create test template
	err = os.MkdirAll("views", 0755)
	if err != nil {
		fmt.Printf("Error creating views directory: %v\n", err)
		return
	}

	templateContent := `<!DOCTYPE html>
<html>
<body>
	<h1>Test Template</h1>
</body>
</html>`

	err = os.WriteFile("views/single_page.tpl", []byte(templateContent), 0644)
	if err != nil {
		fmt.Printf("Error writing template file: %v\n", err)
		return
	}
}

func cleanup() {
	os.RemoveAll("conf")
	os.RemoveAll("views")
}

// Mock HTTP client
type mockHTTPClient struct {
	response string
	err      error
}

func (m *mockHTTPClient) RoundTrip(req *http.Request) (*http.Response, error) {
	if m.err != nil {
		return nil, m.err
	}
	return &http.Response{
		StatusCode: http.StatusOK,
		Body:       io.NopCloser(strings.NewReader(m.response)),
		Header:     make(http.Header),
	}, nil
}

// Helper function to create test context
func createTestContext(w http.ResponseWriter, r *http.Request) *context.Context {
	ctx := context.NewContext()
	ctx.Reset(w, r)
	ctx.Request = r
	ctx.ResponseWriter = &context.Response{
		ResponseWriter: w,
	}
	return ctx
}

// Test VotingController
func TestAddFavorite(t *testing.T) {
	// Set up mock transport
	mockResp := `{"id": 123, "message": "SUCCESS"}`
	mock := &mockHTTPClient{response: mockResp}
	http.DefaultClient.Transport = mock

	controller := &controllers.VotingController{}
	
	reqBody := controllers.FavoriteRequest{
		ImageID: "test-image",
		SubID:   "test-sub",
	}
	bodyBytes, _ := json.Marshal(reqBody)
	
	r := httptest.NewRequest("POST", "/v1/favorites", bytes.NewReader(bodyBytes))
	w := httptest.NewRecorder()
	
	ctx := createTestContext(w, r)
	controller.Ctx = ctx
	controller.Init(ctx, "", "", nil)
	
	controller.AddFavorite()
	
	assert.Equal(t, http.StatusOK, w.Code)
	
	var response map[string]interface{}
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.Contains(t, response, "id")
}

// Test FavoritesController
func TestGetFavorites(t *testing.T) {
	// Set up mock transport
	mockResp := `[{"id": 1, "image": {"url": "http://example.com/cat.jpg"}}]`
	mock := &mockHTTPClient{response: mockResp}
	http.DefaultClient.Transport = mock

	controller := &controllers.FavoritesController{}
	
	r := httptest.NewRequest("GET", "/v1/favorites", nil)
	w := httptest.NewRecorder()
	
	ctx := createTestContext(w, r)
	controller.Ctx = ctx
	controller.Init(ctx, "", "", nil)
	
	controller.GetFavorites()
	
	assert.Equal(t, http.StatusOK, w.Code)
}

// Test CatController
func TestHome(t *testing.T) {
	// Set up mock transport
	mockResp := `[{"url": "http://example.com/cat.jpg"}]`
	mock := &mockHTTPClient{response: mockResp}
	http.DefaultClient.Transport = mock

	controller := &controllers.CatController{}
	
	r := httptest.NewRequest("GET", "/", nil)
	w := httptest.NewRecorder()
	
	ctx := createTestContext(w, r)
	controller.Ctx = ctx
	controller.Init(ctx, "", "", nil)
	
	controller.Home()
	
	assert.Equal(t, http.StatusOK, w.Code)
}

func TestBreeds(t *testing.T) {
	// Set up mock transport
	mockResp := `[{"id": "abys", "name": "Abyssinian"}]`
	mock := &mockHTTPClient{response: mockResp}
	http.DefaultClient.Transport = mock

	controller := &controllers.CatController{}
	
	r := httptest.NewRequest("GET", "/breeds", nil)
	w := httptest.NewRecorder()
	
	ctx := createTestContext(w, r)
	controller.Ctx = ctx
	controller.Init(ctx, "", "", nil)
	
	controller.Breeds()
	
	assert.Equal(t, http.StatusOK, w.Code)
}

func TestBreedImages(t *testing.T) {
	// Set up mock transport
	mockResp := `[{"url": "http://example.com/cat.jpg"}]`
	mock := &mockHTTPClient{response: mockResp}
	http.DefaultClient.Transport = mock

	controller := &controllers.CatController{}
	
	r := httptest.NewRequest("GET", "/breed-images", nil)
	w := httptest.NewRecorder()
	
	ctx := createTestContext(w, r)
	ctx.Input.SetParam(":id", "abys")
	controller.Ctx = ctx
	controller.Init(ctx, "", "", nil)
	
	controller.BreedImages()
	
	assert.Equal(t, http.StatusOK, w.Code)
	
	var response map[string]interface{}
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
}

func TestMain(m *testing.M) {
	// Set up before running tests
	setUp()
	
	// Run tests
	code := m.Run()
	
	// Clean up after running tests
	cleanup()
	
	os.Exit(code)
}

func setUp() {
	// Create necessary directories and files
	if err := os.MkdirAll("conf", 0755); err != nil {
		fmt.Printf("Error creating conf directory: %v\n", err)
		return
	}
	
	if err := os.MkdirAll("views", 0755); err != nil {
		fmt.Printf("Error creating views directory: %v\n", err)
		return
	}
	
	// Create mock template file
	templatePath := filepath.Join("views", "single_page.tpl")
	if err := os.WriteFile(templatePath, []byte("<html><body>Test</body></html>"), 0644); err != nil {
		fmt.Printf("Error writing template file: %v\n", err)
		return
	}
	
	// Set template path in Beego config
	web.BConfig.WebConfig.ViewsPath = "views"
}