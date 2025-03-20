mkdir -p api/{handlers,models,routes,services,utils} && \
cat > api/main.go << 'EOF'
package main

import (
	"log"
	"api/routes"
	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()
	routes.SetupRoutes(r)
	err := r.Run(":8080")
	if err != nil {
		log.Fatal("Failed to start server:", err)
	}
}
EOF

cat > api/routes/routes.go << 'EOF'
package routes

import (
	"api/handlers"
	"github.com/gin-gonic/gin"
)

func SetupRoutes(r *gin.Engine) {
	r.GET("/users", handlers.GetUsers)
	r.POST("/login", handlers.Login)
}
EOF

cat > api/handlers/user.go << 'EOF'
package handlers

import (
	"api/models"
	"github.com/gin-gonic/gin"
	"net/http"
)

func GetUsers(c *gin.Context) {
	users := models.GetAllUsers()
	c.JSON(http.StatusOK, users)
}
EOF

cat > api/handlers/auth.go << 'EOF'
package handlers

import (
	"net/http"
	"github.com/gin-gonic/gin"
)

func Login(c *gin.Context) {
	var req struct {
		Username string `json:"username"`
		Password string `json:"password"`
	}

	if err := c.BindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	if req.Username == "admin" && req.Password == "password" {
		c.JSON(http.StatusOK, gin.H{"message": "Login successful"})
		return
	}

	c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
}
EOF

cat > api/models/user.go << 'EOF'
package models

type User struct {
	ID       int    `json:"id"`
	Username string `json:"username"`
	Email    string `json:"email"`
}

func GetAllUsers() []User {
	return []User{
		{ID: 1, Username: "user1", Email: "user1@example.com"},
		{ID: 2, Username: "user2", Email: "user2@example.com"},
	}
}
EOF

cat > api/services/user_service.go << 'EOF'
package services

import "api/models"

func GetUserByID(id int) *models.User {
	users := models.GetAllUsers()
	for _, user := range users {
		if user.ID == id {
			return &user
		}
	}
	return nil
}
EOF

cat > api/utils/hash.go << 'EOF'
package utils

import (
	"crypto/sha256"
	"fmt"
)

func HashPassword(password string) string {
	hash := sha256.Sum256([]byte(password))
	return fmt.Sprintf("%x", hash)
}
EOF

cd api && go mod init api && go mod tidy

