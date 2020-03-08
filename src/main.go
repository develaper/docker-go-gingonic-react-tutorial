package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/gin-gonic/contrib/static"
)

func main() {

	router := gin.Default()

	router.Use(static.Serve("/home", static.LocalFile("./views", true)))

	// Setup route group for the API
  api := router.Group("/api")
  {
    api.GET("/", func(c *gin.Context) {
      c.JSON(http.StatusOK, gin.H {
        "message": "pong",
      })
    })
  }

	router.Run() // listen and serve on 0.0.0.0:8080
}
