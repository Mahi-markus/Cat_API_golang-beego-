package routers

import (
	"my-beego-app/controllers"
	beego "github.com/beego/beego/v2/server/web"
)

func init() {
	beego.Router("/", &controllers.CatController{})
	beego.Router("/cat/voting", &controllers.CatController{}, "get:Voting")
	beego.Router("/cat/breeds", &controllers.CatController{}, "get:Breeds")
	beego.Router("/cat/favs", &controllers.CatController{}, "get:Favs")
	beego.Router("/cat/vote", &controllers.CatController{}, "post:Vote")
	beego.Router("/cat/breed_images", &controllers.CatController{}, "get:BreedImages")
	beego.Router("/cat/love", &controllers.CatController{}, "post:Love")

}
