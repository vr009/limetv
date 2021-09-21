package middleware

import (
	"encoding/json"
	"github.com/go-park-mail-ru/2021_2_A06367/internal/models"
	"net/http"
)

func Response(w http.ResponseWriter, status models.StatusCode, body interface{}) {

	switch status {
	case models.Okey:
		w.WriteHeader(http.StatusOK)
	case models.NotFound:
		w.WriteHeader(http.StatusNotFound)
	case models.Conflict:
		w.WriteHeader(http.StatusUnprocessableEntity)
	case models.Unauthed:
		w.WriteHeader(http.StatusUnauthorized)
	default:
		w.WriteHeader(http.StatusInternalServerError)
	}
	if body != nil {
		w.Header().Set("Content-Type", "application/json")
		jsn, _ := json.Marshal(body)
		_, _ = w.Write(jsn)
	}
}
