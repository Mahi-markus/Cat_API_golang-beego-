package routers

import (
	"my-beego-app/controllers"

	"github.com/beego/beego/v2/server/web"
)

func init() {
	web.Router("/", &controllers.CatController{})
	web.Router("/cat/voting", &controllers.CatController{}, "get:Voting")
	web.Router("/cat/breeds", &controllers.CatController{}, "get:Breeds")
	web.Router("/cat/favs", &controllers.CatController{}, "get:Favs")
	web.Router("/cat/vote", &controllers.CatController{}, "post:Vote")
	web.Router("/cat/breed_images", &controllers.CatController{}, "get:BreedImages")
	web.Router("/cat/love", &controllers.CatController{}, "post:Love")

}
