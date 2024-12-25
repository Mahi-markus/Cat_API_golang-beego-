package controllers

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"

	"github.com/beego/beego/v2/server/web"
)

type CatController struct {
	web.Controller
}

// CatBreed represents a breed structure returned from the Cat API
type CatBreed struct {
	ID           string `json:"id"`
	Name         string `json:"name"`
	Origin       string `json:"origin"`
	Description  string `json:"description"`
	WikipediaURL string `json:"wikipedia_url"`
}

type CatImage struct {
	URL string `json:"url"`
}

// Load API key from AppConfig
func loadAPIKey() string {
	apiKey, err := web.AppConfig.String("cat_api_key")
	if err != nil || apiKey == "" {
		fmt.Println("Error: API key not found in app.conf")
	}
	return apiKey
}

// fetchAPI concurrently fetches data from a given URL and sends the response body to the provided channel.
func fetchAPI(url, apiKey string, ch chan<- []byte) {
	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		fmt.Println("Failed to create request:", err)
		ch <- nil
		return
	}
	req.Header.Add("x-api-key", apiKey)
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("Failed to fetch data:", err)
		ch <- nil
		return
	}
	defer resp.Body.Close()

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("Failed to read response:", err)
		ch <- nil
		return
	}

	ch <- body
}

func (c *CatController) Home() {
	apiKey := loadAPIKey()
	apiURL := "https://api.thecatapi.com/v1/images/search"
	ch := make(chan []byte)

	go fetchAPI(apiURL, apiKey, ch)
	body := <-ch
	if body == nil {
		c.Ctx.Abort(500, "Internal Server Error")
		return
	}

	var images []CatImage
	err := json.Unmarshal(body, &images)
	if err != nil || len(images) == 0 {
		c.Data["ImageURL"] = ""
	} else {
		c.Data["ImageURL"] = images[0].URL
	}
	c.TplName = "single_page.tpl"
}

func (c *CatController) Breeds() {
	apiKey := loadAPIKey()
	apiURL := "https://api.thecatapi.com/v1/breeds"
	ch := make(chan []byte)

	go fetchAPI(apiURL, apiKey, ch)
	body := <-ch
	if body == nil {
		c.Ctx.WriteString("Failed to fetch breeds")
		return
	}

	var breeds []CatBreed
	err := json.Unmarshal(body, &breeds)
	if err != nil {
		c.Ctx.WriteString("Failed to parse response")
		return
	}

	// Add some logging to verify data
	fmt.Printf("Fetched %d breeds\n", len(breeds))

	c.Data["Breeds"] = breeds
	c.TplName = "single_page.tpl"
}

func (c *CatController) BreedImages() {
	breedID := c.GetString("id")
	if breedID == "" {
		c.Data["json"] = map[string]interface{}{"error": "Invalid breed ID"}
		c.ServeJSON()
		return
	}

	apiKey := loadAPIKey()
	breedURL := fmt.Sprintf("https://api.thecatapi.com/v1/images/search?breed_ids=%s&limit=5", breedID)

	req, _ := http.NewRequest("GET", breedURL, nil)
	req.Header.Add("x-api-key", apiKey)

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		c.Data["json"] = map[string]interface{}{"error": "Failed to fetch images"}
		c.ServeJSON()
		return
	}
	defer resp.Body.Close()

	var images []CatImage
	if err := json.NewDecoder(resp.Body).Decode(&images); err != nil {
		c.Data["json"] = map[string]interface{}{"error": "Failed to parse images"}
		c.ServeJSON()
		return
	}

	// Fetch breed details
	breedResp, err := http.Get("https://api.thecatapi.com/v1/breeds/" + breedID)
	if err != nil {
		c.Data["json"] = map[string]interface{}{"error": "Failed to fetch breed info"}
		c.ServeJSON()
		return
	}
	defer breedResp.Body.Close()

	var breed CatBreed
	if err := json.NewDecoder(breedResp.Body).Decode(&breed); err != nil {
		c.Data["json"] = map[string]interface{}{"error": "Failed to parse breed info"}
		c.ServeJSON()
		return
	}

	response := map[string]interface{}{
		"BreedName":    breed.Name,
		"Description":  breed.Description,
		"Origin":       breed.Origin,
		"WikipediaURL": breed.WikipediaURL,
		"Images":       images,
	}

	c.Data["json"] = response
	c.ServeJSON()
}
