package http

import (
	"github.com/go-park-mail-ru/2021_2_A06367/internal/pkg/films"
	"github.com/go-park-mail-ru/2021_2_A06367/internal/pkg/middleware"
	"github.com/gorilla/mux"
	"go.uber.org/zap"
	"net/http"
)

type FilmsHandler struct {
	uc films.FilmsUsecase
	logger *zap.SugaredLogger
}

func NewFilmsHandler(uc films.FilmsUsecase) *FilmsHandler {
	return &FilmsHandler{uc: uc}
}

func (h FilmsHandler) FilmByGenre(w http.ResponseWriter, r *http.Request)  {
	vars := mux.Vars(r)
	genres, _ := vars["genres"]

	films, status := h.uc.GetCompilation(genres)
	middleware.Response(w, status, films)
}
