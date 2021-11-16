package repo

import (
	"context"
	"github.com/go-park-mail-ru/2021_2_A06367/internal/models"
	"github.com/jackc/pgtype/pgxtype"
	"go.uber.org/zap"
)

const (
	SElECT_FILM_BY_TOPIC = "SELECT id, genres, title, year, director, " +
		"authors, actors, release, duration, language, pic, src " +
		"FROM films " +
		"WHERE $1 = ANY(genres)"

	SELECT_FILM_BY_RATING = "SELECT id, genres, title, year, director, authors, actors, release, duration, language, pic, src " +
		" FROM films JOIN rating ON films.id = rating.film_id ORDER BY rating DESC LIMIT 10"

	SELECT_FILM_BY_DATE = "SELECT id, genres, title, year, director, authors, actors, release, duration, language, pic, src " +
		"FROM films  ORDER BY release DESC LIMIT 10"

	SELECT_FILM_BY_KEYWORD = "SELECT id, genres, title, year, director, " +
		"authors, actors, release, duration, language, pic, src " +
		"FROM films " +
		"WHERE make_tsvector(title) @@ to_tsquery($1) LIMIT 10"

	SELECT_FILM_BY_ID = "SELECT id, genres, title, year, director, " +
		"authors, actors, release, duration, language, pic, src " +
		"FROM films " +
		"WHERE id=$1"

	SELECT_FILM_BY_USER = "SELECT f.id, f.genres, f.title, f.year, f.director, " +
		"f.authors, f.actors , f.release, f.duration, f.language, f.pic, f.src " +
		"FROM films f INNER JOIN watchlist w ON f.id=w.film_id " +
		"WHERE w.id=$1"

	SELECT_FILM_BY_ACTOR = "SELECT id, genres, title, year, director, " +
		"authors, actors, release, duration, language, pic, src " +
		"FROM films " +
		"WHERE $1=ANY(actors)"

	INSERT_FILM_TO_STARRED = "INSERT INTO starred_films (film_id, user_id) VALUES($1, $2);"

	DELETE_FILM_FROM_STARRED = "DELETE FROM starred_films WHERE film_id=$1 AND user_id=$2;"

	GET_STARRED_FILMS = "SELECT id, genres, title, year, director, authors, actors, release, duration, language, pic, src " +
		"FROM films f JOIN starred_films sf ON f.id  = sf.film_id " +
		"WHERE sf.user_id=$1"

	INSERT_FILM_TO_WATCHLIST = "INSERT INTO watchlist (id, film_id) VALUES($1, $2);"

	DELETE_FILM_FROM_WATCHLIST = "DELETE FROM watchlist WHERE film_id=$1 AND id=$2;"

	GET_WATCHLIST_FILMS = "SELECT f.id, genres, title, year, director, authors, actors, release, duration, language, pic, src " +
		"FROM films f JOIN watchlist w ON f.id  = w.film_id " +
		"WHERE w.id=$1"
)

type FilmsRepo struct {
	pool   pgxtype.Querier
	logger *zap.SugaredLogger
}

func NewFilmsRepo(pool pgxtype.Querier, logger *zap.SugaredLogger) *FilmsRepo {
	return &FilmsRepo{
		pool:   pool,
		logger: logger,
	}
}

func (r *FilmsRepo) GetFilmsByTopic(topic string) ([]models.Film, models.StatusCode) {

	rows, err := r.pool.Query(context.Background(), SElECT_FILM_BY_TOPIC,
		topic)
	if err != nil {
		return nil, models.InternalError
	}
	defer rows.Close()
	films := make([]models.Film, 0)

	for rows.Next() {
		var film models.Film
		err = rows.Scan(&film.Id, &film.Genres, &film.Title,
			&film.Year, &film.Director, &film.Authors, &film.Actors, &film.Release, &film.Duration,
			&film.Language, &film.Pic, &film.Src)
		if err != nil {
			return nil, models.InternalError
		}
		films = append(films, film)
	}

	return films, models.Okey
}

func (r *FilmsRepo) GetHottestFilms() ([]models.Film, models.StatusCode) {

	rows, err := r.pool.Query(context.Background(), SELECT_FILM_BY_RATING)
	if err != nil {
		return nil, models.InternalError
	}
	defer rows.Close()

	films := make([]models.Film, 0)

	for rows.Next() {
		var film models.Film
		err = rows.Scan(&film.Id, &film.Genres, &film.Title,
			&film.Year, &film.Director, &film.Authors, &film.Actors, &film.Release, &film.Duration,
			&film.Language, &film.Pic, &film.Src)
		if err != nil {
			return nil, models.InternalError
		}
		films = append(films, film)
	}

	return films, models.Okey
}

func (r *FilmsRepo) GetNewestFilms() ([]models.Film, models.StatusCode) {

	rows, err := r.pool.Query(context.Background(), SELECT_FILM_BY_DATE)
	if err != nil {
		return nil, models.InternalError
	}
	defer rows.Close()

	films := make([]models.Film, 0)

	for rows.Next() {
		var film models.Film
		err = rows.Scan(&film.Id, &film.Genres, &film.Title,
			&film.Year, &film.Director, &film.Authors, &film.Actors, &film.Release, &film.Duration,
			&film.Language, &film.Pic, &film.Src)
		if err != nil {
			return nil, models.InternalError
		}
		films = append(films, film)
	}

	return films, models.Okey
}

func (r *FilmsRepo) GetFilmsByKeyword(keyword string) ([]models.Film, models.StatusCode) {
	rows, err := r.pool.Query(context.Background(), SELECT_FILM_BY_KEYWORD, keyword)
	if err != nil {
		return nil, models.InternalError
	}
	defer rows.Close()

	films := make([]models.Film, 0, 10)

	for rows.Next() {
		var film models.Film
		err = rows.Scan(&film.Id, &film.Genres, &film.Title,
			&film.Year, &film.Director, &film.Authors, &film.Actors, &film.Release, &film.Duration,
			&film.Language, &film.Pic, &film.Src)
		if err != nil {
			return nil, models.InternalError
		}
		films = append(films, film)
	}

	return films, models.Okey
}

func (r *FilmsRepo) GetFilmsByActor(actor models.Actors) ([]models.Film, models.StatusCode) {
	rows, err := r.pool.Query(context.Background(), SELECT_FILM_BY_ACTOR, actor.Id)
	if err != nil {
		return nil, models.InternalError
	}
	defer rows.Close()

	films := make([]models.Film, 0)

	for rows.Next() {
		var film models.Film
		err = rows.Scan(&film.Id, &film.Genres, &film.Title,
			&film.Year, &film.Director, &film.Authors, &film.Actors, &film.Release, &film.Duration,
			&film.Language, &film.Pic, &film.Src)
		if err != nil {
			return nil, models.InternalError
		}
		films = append(films, film)
	}
	return films, models.Okey
}

func (r *FilmsRepo) GetFilmById(film models.Film) (models.Film, models.StatusCode) {
	row := r.pool.QueryRow(context.Background(), SELECT_FILM_BY_ID, film.Id)

	err := row.Scan(&film.Id, &film.Genres, &film.Title,
		&film.Year, &film.Director, &film.Authors, &film.Actors, &film.Release, &film.Duration,
		&film.Language, &film.Pic, &film.Src)

	if err != nil {
		return models.Film{}, models.InternalError
	}
	return film, models.Okey
}

func (r *FilmsRepo) GetFilmsByUser(user models.User) ([]models.Film, models.StatusCode) {
	rows, err := r.pool.Query(context.Background(), SELECT_FILM_BY_USER, user.Id)
	if err != nil {
		return nil, models.InternalError
	}
	defer rows.Close()
	films := make([]models.Film, 0)

	for rows.Next() {
		var film models.Film
		err = rows.Scan(&film.Id, &film.Genres, &film.Title,
			&film.Year, &film.Director, &film.Authors, &film.Actors, &film.Release, &film.Duration,
			&film.Language, &film.Pic, &film.Src)
		if err != nil {
			return nil, models.InternalError
		}
		films = append(films, film)
	}
	return films, models.Okey
}

func (r *FilmsRepo) InsertStarred(film models.Film, user models.User) models.StatusCode {

	exec, err := r.pool.Exec(context.Background(), INSERT_FILM_TO_STARRED, film.Id, user.Id)
	if err != nil {
		return models.InternalError
	}

	if exec.RowsAffected() != 1 {
		return models.Conflict
	}

	return models.Okey
}

func (r *FilmsRepo) DeleteStarred(film models.Film, user models.User) models.StatusCode {

	exec, err := r.pool.Exec(context.Background(), DELETE_FILM_FROM_STARRED, film.Id, user.Id)
	if err != nil {
		return models.InternalError
	}

	if exec.RowsAffected() != 1 {
		return models.Conflict
	}

	return models.Okey
}

func (r *FilmsRepo) InsertWatchlist(film models.Film, user models.User) models.StatusCode {

	exec, err := r.pool.Exec(context.Background(), INSERT_FILM_TO_WATCHLIST, film.Id, user.Id)
	if err != nil {
		return models.InternalError
	}

	if exec.RowsAffected() != 1 {
		return models.Conflict
	}

	return models.Okey
}

func (r *FilmsRepo) DeleteWatchlist(film models.Film, user models.User) models.StatusCode {

	exec, err := r.pool.Exec(context.Background(), DELETE_FILM_FROM_WATCHLIST, film.Id, user.Id)
	if err != nil {
		return models.InternalError
	}

	if exec.RowsAffected() != 1 {
		return models.Conflict
	}

	return models.Okey
}

func (r FilmsRepo) GetStarredFilms(user models.User) ([]models.Film, models.StatusCode) {
	rows, err := r.pool.Query(context.Background(), GET_STARRED_FILMS, user.Id)
	if err != nil {
		return nil, models.InternalError
	}
	defer rows.Close()

	films := make([]models.Film, 0)

	for rows.Next() {
		var film models.Film
		err = rows.Scan(&film.Id, &film.Genres, &film.Title,
			&film.Year, &film.Director, &film.Authors, &film.Actors, &film.Release, &film.Duration,
			&film.Language, &film.Pic, &film.Src)
		if err != nil {
			return nil, models.InternalError
		}
		films = append(films, film)
	}

	return films, models.Okey
}

func (r FilmsRepo) GetWatchlistFilms(user models.User) ([]models.Film, models.StatusCode) {
	rows, err := r.pool.Query(context.Background(), GET_WATCHLIST_FILMS, user.Id)
	if err != nil {
		return nil, models.InternalError
	}
	defer rows.Close()

	films := make([]models.Film, 0)

	for rows.Next() {
		var film models.Film
		err = rows.Scan(&film.Id, &film.Genres, &film.Title,
			&film.Year, &film.Director, &film.Authors, &film.Actors, &film.Release, &film.Duration,
			&film.Language, &film.Pic, &film.Src)
		if err != nil {
			return nil, models.InternalError
		}
		films = append(films, film)
	}

	return films, models.Okey
}
