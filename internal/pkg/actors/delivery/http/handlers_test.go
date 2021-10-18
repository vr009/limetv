package http

import (
	"fmt"
	"github.com/go-park-mail-ru/2021_2_A06367/internal/models"
	"github.com/go-park-mail-ru/2021_2_A06367/internal/pkg/actors"
	"github.com/golang/mock/gomock"
	"github.com/gorilla/mux"
	"github.com/stretchr/testify/require"
	"go.uber.org/zap"
	"log"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

func TestActorById(t *testing.T) {
	ctl := gomock.NewController(t)
	defer ctl.Finish()

	usecase := actors.NewMockActorsUsecase(ctl)
	usecase.EXPECT().GetById("768eb570-2e0e-11ec-8d3d-0242ac130003").Times(1).Return(models.Actors{}, models.Okey)

	logger, err := zap.NewProduction()
	if err != nil {
		panic(err)
	}
	defer logger.Sync()
	zapSugar := logger.Sugar()
	handler := NewActorsHandler(usecase, zapSugar)

	r := httptest.NewRequest("GET", "/actor/id", strings.NewReader(fmt.Sprint()))
	r = mux.SetURLVars(r, map[string]string{
		"id": "768eb570-2e0e-11ec-8d3d-0242ac130003",
	})
	w := httptest.NewRecorder()

	handler.ActorsById(w, r)
	require.Equal(t, w.Code, http.StatusOK)
	log.Print(w.Body.String())
}

func TestActorByIdNotFound(t *testing.T) {
	ctl := gomock.NewController(t)
	defer ctl.Finish()

	usecase := actors.NewMockActorsUsecase(ctl)
	usecase.EXPECT().GetById("768eb570-2e0e-11ec-8d3d-0242ac130003").Times(1).Return(models.Actors{}, models.NotFound)

	logger, err := zap.NewProduction()
	if err != nil {
		t.Error(err.Error())
	}
	defer logger.Sync()
	zapSugar := logger.Sugar()
	handler := NewActorsHandler(usecase, zapSugar)

	r := httptest.NewRequest("GET", "/actor/id", strings.NewReader(fmt.Sprint()))
	r = mux.SetURLVars(r, map[string]string{
		"id": "768eb570-2e0e-11ec-8d3d-0242ac130003",
	})
	w := httptest.NewRecorder()

	handler.ActorsById(w, r)
	require.Equal(t, w.Code, http.StatusNotFound)
	log.Print(w.Body.String())
}