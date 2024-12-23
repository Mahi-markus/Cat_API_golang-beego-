package controllers

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"

	"github.com/beego/beego/v2/server/web"
	"github.com/joho/godotenv"
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

// Load API key from environment
func loadAPIKey() string {
	if err := godotenv.Load(); err != nil {
		fmt.Println("Warning: No .env file found, using default configuration.")
	}
	return os.Getenv("CAT_API_KEY")
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

func (c *CatController) Get() {
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
	c.TplName = "index1.tpl"
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

	c.Data["Breeds"] = breeds
	c.TplName = "breeds.tpl"
}



func (c *CatController) BreedImages() {
	apiKey := loadAPIKey()
	breedID := c.GetString("id")
	if breedID == "" {
		c.Ctx.WriteString("Invalid breed ID")
		return
	}

	breedsCh := make(chan []byte)
	imagesCh := make(chan []byte)

	// Concurrent API calls
	go fetchAPI("https://api.thecatapi.com/v1/breeds", apiKey, breedsCh)
	go fetchAPI(fmt.Sprintf("https://api.thecatapi.com/v1/images/search?breed_ids=%s&limit=5", breedID), apiKey, imagesCh)

	breedsBody := <-breedsCh
	imagesBody := <-imagesCh

	if breedsBody == nil || imagesBody == nil {
		c.Ctx.WriteString("Failed to fetch data")
		return
	}

	var breeds []CatBreed
	err := json.Unmarshal(breedsBody, &breeds)
	if err != nil {
		c.Ctx.WriteString("Failed to parse breed information")
		return
	}

	var selectedBreed *CatBreed
	for _, breed := range breeds {
		if breed.ID == breedID {
			selectedBreed = &breed
			break
		}
	}

	if selectedBreed == nil {
		c.Ctx.WriteString("Breed not found")
		return
	}

	var images []CatImage
	err = json.Unmarshal(imagesBody, &images)
	if err != nil {
		c.Ctx.WriteString("Failed to parse image data")
		return
	}

	c.Data["BreedName"] = selectedBreed.Name
	c.Data["Origin"] = selectedBreed.Origin
	c.Data["Description"] = selectedBreed.Description
	c.Data["WikipediaURL"] = selectedBreed.WikipediaURL
	c.Data["ID"] = selectedBreed.ID
	c.Data["Images"] = images
	c.TplName = "breed_images.tpl"
}
