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
