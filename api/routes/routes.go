package routes

import (
	"api/handlers"
	"github.com/gin-gonic/gin"
)

func SetupRoutes(r *gin.Engine) {
	r.GET("/users", handlers.GetUsers)
	r.POST("/login", handlers.Login)
}
