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
	Origin      string `json:"origin"`
    Description string `json:"description"`
    WikipediaURL string `json:"wikipedia_url"`
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
	// apiKey := loadAPIKey()
	// apiURL := "https://api.thecatapi.com/v1/images/search"

	// req, err := http.NewRequest("GET", apiURL, nil)
	// if err != nil {
	// 	c.Ctx.Abort(500, "Internal Server Error")
	// 	return
	// }
	// req.Header.Add("x-api-key", apiKey)

	// client := &http.Client{}
	// resp, err := client.Do(req)
	// if err != nil {
	// 	c.Ctx.Abort(500, "Failed to fetch image")
	// 	return
	// }
	// defer resp.Body.Close()

	// body, _ := ioutil.ReadAll(resp.Body)
	// var images []CatImage
	// json.Unmarshal(body, &images)

	// if len(images) > 0 {
	// 	c.Data["ImageURL"] = images[0].URL
	// } else {
	// 	c.Data["ImageURL"] = ""
	// }
	// c.TplName = "index.tpl"


	c.Redirect("/", 302)
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

    // Fetch breed-specific information
    apiURL := "https://api.thecatapi.com/v1/breeds"
    response, err := http.Get(apiURL + "?api_key=" + apiKey)
    if err != nil {
        c.Ctx.WriteString("Failed to fetch breed information")
        return
    }
    defer response.Body.Close()

    body, err := ioutil.ReadAll(response.Body)
    if err != nil {
        c.Ctx.WriteString("Failed to read breed information")
        return
    }

    var breeds []CatBreed
    err = json.Unmarshal(body, &breeds)
    if err != nil {
        c.Ctx.WriteString("Failed to parse breed information")
        return
    }

    var selectedBreed *CatBreed
    // Find the breed that matches the provided breedID
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

    // Fetch breed images
    imageAPIURL := fmt.Sprintf("https://api.thecatapi.com/v1/images/search?breed_ids=%s&limit=5", breedID)
    imageResponse, err := http.Get(imageAPIURL + "&api_key=" + apiKey)
    if err != nil {
        c.Ctx.WriteString("Failed to fetch breed images")
        return
    }
    defer imageResponse.Body.Close()

    imageBody, err := ioutil.ReadAll(imageResponse.Body)
    if err != nil {
        c.Ctx.WriteString("Failed to read image data")
        return
    }

    var images []CatImage
    err = json.Unmarshal(imageBody, &images)
    if err != nil {
        c.Ctx.WriteString("Failed to parse image data")
        return
    }

    // Pass both breed info and images to the template
    c.Data["BreedName"] = selectedBreed.Name
    c.Data["Origin"] = selectedBreed.Origin
    c.Data["Description"] = selectedBreed.Description
    c.Data["WikipediaURL"] = selectedBreed.WikipediaURL
    c.Data["ID"] = selectedBreed.ID
    c.Data["Images"] = images
    c.TplName = "breed_images.tpl"
}


var lovedImages []string

func (c *CatController) Favs() {
	

	c.Data["LovedImages"] = lovedImages
    c.TplName = "favs.tpl"
}

func (c *CatController) Vote() {
	vote := c.GetString("vote")

	// Handle the vote action
	if vote == "up" {
		c.Redirect("/", 302)
	} else if vote == "down" {
		c.Redirect("/", 302)
	} else {
		c.Ctx.Abort(400, "Invalid vote")
		return
	}

	// // Fetch a new random cat image
	// apiKey := loadAPIKey()
	// apiURL := "https://api.thecatapi.com/v1/images/search"
	// req, err := http.NewRequest("GET", apiURL, nil)
	// if err != nil {
	// 	c.Ctx.Abort(500, "Internal Server Error")
	// 	return
	// }
	// req.Header.Add("x-api-key", apiKey)

	// client := &http.Client{}
	// resp, err := client.Do(req)
	// if err != nil {
	// 	c.Ctx.Abort(500, "Failed to fetch random image")
	// 	return
	// }
	// defer resp.Body.Close()

	// body, err := ioutil.ReadAll(resp.Body)
	// if err != nil {
	// 	c.Ctx.Abort(500, "Failed to read response")
	// 	return
	// }

	// var images []CatImage
	// json.Unmarshal(body, &images)

	// if len(images) > 0 {
	// 	// Send the new image URL as a response
	// 	newImageURL := images[0].URL
	// 	c.Data["json"] = map[string]interface{}{
	// 		"message":      fmt.Sprintf("You %s the cat!", vote),
	// 		"new_image_url": newImageURL,
	// 	}
	// 	c.ServeJSON()
	// } else {
	// 	c.Ctx.Abort(500, "Failed to retrieve new image")
	// }
}






func (c *CatController) Love() {
    imageURL := c.GetString("image_url")
    if imageURL != "" {
        lovedImages = append(lovedImages, imageURL)
        c.Redirect("/", 302)
    } else {
        c.Ctx.Abort(400, "Invalid image URL")
    }
}
