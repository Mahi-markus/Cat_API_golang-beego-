package controllers

import (
	"encoding/json"
	"io"
	"net/http"

	"github.com/beego/beego/v2/server/web"
	"my-beego-app/utils"
)

type FavoritesController struct {
	web.Controller
}

type Favorite struct {
	ID        int    `json:"id"`
	UserID    string `json:"user_id"`
	ImageID   string `json:"image_id"`
	SubID     string `json:"sub_id"`
	CreatedAt string `json:"created_at"`
	Image     struct {
		ID  string `json:"id"`
		URL string `json:"url"`
	} `json:"image"`
}

func makeAPICalls(method, url, apiKey string) chan utils.APIResponse {
	responseChan := make(chan utils.APIResponse)

	go func() {
		client := &http.Client{}
		req, err := http.NewRequest(method, url, nil)
		if err != nil {
			responseChan <- utils.APIResponse{nil, err}
			return
		}

		req.Header.Add("x-api-key", apiKey)

		resp, err := client.Do(req)
		if err != nil {
			responseChan <- utils.APIResponse{nil, err}
			return
		}
		defer resp.Body.Close()

		body, err := io.ReadAll(resp.Body)
		responseChan <- utils.APIResponse{body, err}
	}()

	return responseChan
}

func (c *FavoritesController) GetFavorites() {
	apiKey, err := web.AppConfig.String("cat_api_key")
	if err != nil {
		c.Data["Error"] = "Failed to get API key"
		c.TplName = "favs.tpl"
		return
	}

	url := "https://api.thecatapi.com/v1/favourites"
	responseChan := makeAPICalls("GET", url, apiKey)

	response := <-responseChan
	if response.Error != nil {
		c.Data["Error"] = "Error fetching favorites"
		c.TplName = "favs.tpl"
		return
	}

	var favorites []Favorite
	err = json.Unmarshal(response.Body, &favorites)
	if err != nil {
		c.Data["Error"] = "Error decoding response: " + err.Error()
		c.TplName = "favs.tpl"
		return
	}

	// Extract image URLs from favorites
	var lovedImages []string
	for _, fav := range favorites {
		lovedImages = append(lovedImages, fav.Image.URL)
	}

	// Pass the image URLs to the template
	c.Data["LovedImages"] = lovedImages
	c.TplName = "favs.tpl"
}