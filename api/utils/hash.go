package utils

import (
	"crypto/sha256"
	"fmt"
)

func HashPassword(password string) string {
	hash := sha256.Sum256([]byte(password))
	return fmt.Sprintf("%x", hash)
}
