package routers

import (
	"my-beego-app/controllers"

	"github.com/beego/beego/v2/server/web"
)

func init() {
	web.Router("/", &controllers.MainController{})
	web.Router("/cat1", &controllers.CatController{},"get:Home")
	//web.Router("/cat/voting", &controllers.VotingController{}, "get:Voting")
	web.Router("/cat/breeds", &controllers.CatController{}, "get:Breeds")
	//web.Router("/cat/favs", &controllers.FavoriteController{}, "get:Favs")
	web.Router("/cat/vote", &controllers.VotingController{}, "post:Vote")
	web.Router("/cat/breed_images", &controllers.CatController{}, "get:BreedImages")
	web.Router("/cat/love", &controllers.VotingController{}, "post:AddFavorite")
	web.Router("/cat/favs", &controllers.FavoritesController{}, "get:GetFavorites")
	//web.Router("/cat/unfavorite/:favoriteId", &controllers.VotingController{}, "delete:DeleteFavorite")

}