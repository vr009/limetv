package repo

import (
	"context"
	"github.com/go-park-mail-ru/2021_2_A06367/internal/models"
	"github.com/google/uuid"
	"github.com/jackc/pgtype/pgxtype"
	"go.uber.org/zap"
	"log"
	"time"
)

const (
	UPDATE_USER_PIC  = "UPDATE public.users SET avatar=$1 WHERE id=$2;"
	UPDATE_USER_BIO  = "UPDATE public.users SET about=$1 WHERE id=$2;"
	UPDATE_USER_PASS = "UPDATE public.users SET encrypted_password=$1 WHERE id=$2;"
	SElECT_USER      = "SELECT login, about, avatar, subscriptions, subscribers FROM public.users WHERE id=$1;"
	CHECK_USER       = "SELECT id, encrypted_password FROM public.users WHERE login=$1;"
	CREATE_USER      = "INSERT INTO public.users(id, login, encrypted_password, created_at) VALUES($1, $2, $3, $4) RETURNING id;"
	FOLLOW           = "INSERT INTO public.subscriptions (user_id, subscribed_at) VALUES($1, $2) RETURNING id;"
	UNFOLLOW         = "DELETE FROM public.subscriptions WHERE user_id=$1 AND subscribed_at=$2;"
	SELECT_FOLLOWING = "SELECT users.id, login, encrypted_password, about, avatar, subscriptions, " +
		"subscribers, created_at FROM users JOIN subscriptions ON users.id = subscriptions.user_id;"
	SELECT_FOLLOWERS = "SELECT users.id, login, encrypted_password, about, avatar, subscriptions, " +
		"subscribers, created_at FROM users JOIN subscriptions ON users.id = subscriptions.subscribed_at;"

	SElECT_USER_BY_KEYWORD = "SELECT login, about, avatar, subscriptions, subscribers FROM public.users " +
		"WHERE  make_tsvector(login)@@ to_tsquery($1)"
)

type AuthRepo struct {
	pool   pgxtype.Querier
	logger *zap.SugaredLogger
}

func NewAuthRepo(pool pgxtype.Querier, logger *zap.SugaredLogger) *AuthRepo {
	return &AuthRepo{
		pool:   pool,
		logger: logger,
	}
}

func (r *AuthRepo) CreateUser(user models.User) (models.User, models.StatusCode) {
	var id uuid.UUID
	user.Id = uuid.New()
	row := r.pool.QueryRow(context.Background(), CREATE_USER,
		user.Id, user.Login, user.EncryptedPassword, time.Now())

	err := row.Scan(&id)
	if err != nil {
		return models.User{}, models.InternalError
	}
	userOut := models.User{
		Id:                id,
		Login:             user.Login,
		EncryptedPassword: user.EncryptedPassword,
	}
	return userOut, models.Okey
}

func (r *AuthRepo) CheckUser(user models.User) (models.User, models.StatusCode) {
	var (
		pwd string
		id  uuid.UUID
	)
	log.Println(user)
	row := r.pool.QueryRow(context.Background(), CHECK_USER, user.Login)

	if err := row.Scan(&id, &pwd); err != nil {
		return models.User{}, models.InternalError
	}
	if pwd != user.EncryptedPassword {
		return models.User{}, models.Unauthed
	}
	userOut := models.User{
		Id:                id,
		Login:             user.Login,
		EncryptedPassword: user.EncryptedPassword,
	}
	return userOut, models.Okey
}

func (r *AuthRepo) CheckUserLogin(user models.User) (models.User, models.StatusCode) {
	var (
		pwd string
		id  uuid.UUID
	)
	row := r.pool.QueryRow(context.Background(), CHECK_USER, user.Login)

	if err := row.Scan(&id, &pwd); err != nil {
		return models.User{}, models.InternalError
	}

	userOut := models.User{
		Id:                id,
		Login:             user.Login,
	}
	return userOut, models.Okey
}

func (r *AuthRepo) GetProfile(user models.Profile) (models.Profile, models.StatusCode) {

	row := r.pool.QueryRow(context.Background(), SElECT_USER, user.Id)

	err := row.Scan(&user.Login, &user.About, &user.Avatar, &user.Subscriptions, &user.Subscribers)
	if err != nil {
		log.Println(err)
		return models.Profile{}, models.InternalError
	}
	return user, models.Okey
}

func (r *AuthRepo) AddFollowing(who, whom uuid.UUID) models.StatusCode {
	var id int
	row := r.pool.QueryRow(context.Background(), FOLLOW,
		who, whom)

	err := row.Scan(&id)
	if err != nil {
		//TODO: добавить проверку ошибок
		return models.InternalError
	}
	return models.Okey
}

func (r *AuthRepo) RemoveFollowing(who, whom uuid.UUID) models.StatusCode {

	exec, err := r.pool.Exec(context.Background(), UNFOLLOW,
		who, whom)
	if err != nil {
		return models.InternalError
	}

	if exec.RowsAffected() == 0 {
		return models.NotFound
	}
	return models.Okey
}

func (r *AuthRepo) GetProfileByKeyword(keyword string) ([]models.Profile, models.StatusCode) {

	rows, err := r.pool.Query(context.Background(), SElECT_USER_BY_KEYWORD, keyword)
	if err != nil {
		return nil, models.InternalError
	}
	defer rows.Close()

	users := make([]models.Profile, 0, 10)

	for rows.Next() {
		var user models.Profile
		err := rows.Scan(&user.Login, &user.About, &user.Avatar, &user.Subscriptions, &user.Subscribers)
		if err != nil {
			return nil, models.InternalError
		}
		users = append(users, user)
	}

	return users, models.Okey
}

func (r *AuthRepo) UpdateBio(profile models.Profile) models.StatusCode {

	tag, err := r.pool.Exec(context.Background(), UPDATE_USER_BIO, profile.About, profile.Id)

	if err != nil {
		return models.InternalError
	}
	if tag.RowsAffected() == 0 {
		return models.NotFound
	}

	return models.Okey
}

func (r *AuthRepo) UpdateAvatar(profile models.Profile) models.StatusCode {

	tag, err := r.pool.Exec(context.Background(), UPDATE_USER_PIC, profile.Avatar, profile.Id)

	if err != nil {
		return models.InternalError
	}
	if tag.RowsAffected() == 0 {
		return models.NotFound
	}

	return models.Okey
}

func (r *AuthRepo) UpdatePass(profile models.User) models.StatusCode {

	tag, err := r.pool.Exec(context.Background(), UPDATE_USER_PASS, profile.EncryptedPassword, profile.Id)

	if err != nil {
		return models.InternalError
	}
	if tag.RowsAffected() == 0 {
		return models.NotFound
	}

	return models.Okey
}
