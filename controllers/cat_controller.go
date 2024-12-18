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
	ID   string `json:"id"`
	Name string `json:"name"`
}

type CatImage struct {
	URL string `json:"url"`
}

// Load API key from environment
func loadAPIKey() string {
	// Load .env file (only once during app startup)
	if err := godotenv.Load(); err != nil {
		fmt.Println("Warning: No .env file found, using default configuration.")
	}
	return os.Getenv("CAT_API_KEY")
}

func (c *CatController) Get() {
	apiKey := loadAPIKey()
	apiURL := "https://api.thecatapi.com/v1/images/search"

	req, err := http.NewRequest("GET", apiURL, nil)
	if err != nil {
		fmt.Println("Failed to create request:", err)
		c.Ctx.Abort(500, "Internal Server Error")
		return
	}
	req.Header.Add("x-api-key", apiKey)

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("Failed to fetch data:", err)
		c.Ctx.Abort(500, "Internal Server Error")
		return
	}
	defer resp.Body.Close()

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		c.Ctx.Abort(500, "Failed to read response")
		return
	}

	var images []CatImage
	json.Unmarshal(body, &images)

	if len(images) > 0 {
		c.Data["ImageURL"] = images[0].URL
	} else {
		c.Data["ImageURL"] = ""
	}
	c.TplName = "index.tpl"
}

func (c *CatController) Voting() {
	apiKey := loadAPIKey()
	apiURL := "https://api.thecatapi.com/v1/images/search"

	req, err := http.NewRequest("GET", apiURL, nil)
	if err != nil {
		c.Ctx.Abort(500, "Internal Server Error")
		return
	}
	req.Header.Add("x-api-key", apiKey)

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		c.Ctx.Abort(500, "Failed to fetch image")
		return
	}
	defer resp.Body.Close()

	body, _ := ioutil.ReadAll(resp.Body)
	var images []CatImage
	json.Unmarshal(body, &images)

	if len(images) > 0 {
		c.Data["ImageURL"] = images[0].URL
	} else {
		c.Data["ImageURL"] = ""
	}
	c.TplName = "index.tpl"
}

func (c *CatController) Breeds() {
	apiKey := loadAPIKey()
	apiURL := "https://api.thecatapi.com/v1/breeds"

	response, err := http.Get(apiURL + "?api_key=" + apiKey)
	if err != nil {
		c.Ctx.WriteString("Failed to fetch breeds")
		return
	}
	defer response.Body.Close()

	body, err := ioutil.ReadAll(response.Body)
	if err != nil {
		c.Ctx.WriteString("Failed to read response")
		return
	}

	var breeds []CatBreed
	err = json.Unmarshal(body, &breeds)
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

	apiURL := fmt.Sprintf("https://api.thecatapi.com/v1/images/search?breed_ids=%s&limit=5", breedID)
	response, err := http.Get(apiURL + "&api_key=" + apiKey)
	if err != nil {
		c.Ctx.WriteString("Failed to fetch breed images")
		return
	}
	defer response.Body.Close()

	body, err := ioutil.ReadAll(response.Body)
	if err != nil {
		c.Ctx.WriteString("Failed to read response")
		return
	}

	var images []CatImage
	err = json.Unmarshal(body, &images)
	if err != nil {
		c.Ctx.WriteString("Failed to parse response")
		return
	}

	c.Data["Images"] = images
	c.TplName = "breed_images.tpl"
}

func (c *CatController) Favs() {
	c.Ctx.WriteString("Favorites Page - Work in Progress")
}

func (c *CatController) Vote() {
	vote := c.GetString("vote")
	if vote == "up" {
		c.Ctx.WriteString("You liked the cat! 😺")
	} else if vote == "down" {
		c.Ctx.WriteString("You disliked the cat! 😿")
	} else {
		c.Ctx.Abort(400, "Invalid vote")
	}
}
