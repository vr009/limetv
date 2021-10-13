package http

import (
	"github.com/go-park-mail-ru/2021_2_A06367/internal/models"
	"github.com/go-park-mail-ru/2021_2_A06367/internal/pkg/films"
	http2 "github.com/go-park-mail-ru/2021_2_A06367/internal/pkg/utils"
	"github.com/gorilla/mux"
	"go.uber.org/zap"
	"net/http"
)

type FilmsHandler struct {
	uc     films.FilmsUsecase
	logger *zap.SugaredLogger
}

func NewFilmsHandler(uc films.FilmsUsecase) *FilmsHandler {
	return &FilmsHandler{uc: uc}
}

func (h FilmsHandler) FilmByGenre(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	genres, found := vars["genre"]
	if !found {
		http2.Response(w, models.NotFound, nil)
	}

	films, status := h.uc.GetCompilation(genres)
	http2.Response(w, status, films)
}

func (h FilmsHandler) FilmBySelection(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	selection, found := vars["selection"]
	if !found {
		http2.Response(w, models.NotFound, nil)
	}

	films, status := h.uc.GetSelection(selection)
	http2.Response(w, status, films)
}
