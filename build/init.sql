-- DROP DATABASE netflix;
CREATE DATABASE netflix;


CREATE TABLE users(
                      id UUID PRIMARY KEY,
                      login text UNIQUE NOT NULL,
                      encrypted_password text NOT NULL,
                      about text DEFAULT '',
                      avatar text DEFAULT 'userpic.png',
                      subscriptions int DEFAULT 0,
                      subscribers int DEFAULT 0,
                      created_at TIMESTAMP NOT NULL
);

CREATE TABLE subscriptions (
                               id serial PRIMARY KEY,
                               user_id UUID REFERENCES users(id) NOT NULL,
                               subscribed_at UUID REFERENCES users(id) NOT NULL,
                               UNIQUE (user_id, subscribed_at)
);

CREATE TABLE subs
(
    user_id uuid NOT NULL,
    exp_date date NOT NULL,
    CONSTRAINT subs_pkey PRIMARY KEY (user_id)
);

CREATE TABLE films
(
    id UUID NOT NULL,
    genres text[] NOT NULL,
    country text NOT NULL,
    releaserus TIMESTAMP WITH TIME ZONE NOT NULL,
    title text NOT NULL,
    year integer NOT NULL,
    director text[] NOT NULL,
    authors text[] NOT NULL,
    actors UUID[] NOT NULL,
    release date NOT NULL,
    duration integer NOT NULL,
    language text NOT NULL,
    budget text NOT NULL,
    age integer NOT NULL,
    pic text[] NOT NULL,
    src text[] NOT NULL,
    description text NOT NULL,
    isSeries bool DEFAULT false,
    needsPayment bool DEFAULT false,
    slug text NOT NULL,
    PRIMARY KEY (id),
    Check(year > 0),
    Check(duration > 0),
    UNIQUE (slug)
);

CREATE TABLE series_seasons
(
    series_id UUID REFERENCES films(id) NOT NULL,
    id integer,
    pic text[] NOT NULL,
    src text[] NOT NULL
);

ALTER TABLE series_seasons
    ADD CONSTRAINT series_seasons_uniq UNIQUE(series_id, id);

CREATE TABLE starred_films
(
    film_id UUID NOT NULL,
    user_id UUID NOT NULL
);

ALTER TABLE starred_films
    ADD CONSTRAINT uniq_list UNIQUE(film_id, user_id);

CREATE INDEX films_actors_idx ON films USING gin(actors);

CREATE TABLE watchlist
(
    id UUID NOT NULL,
    film_id UUID NOT NULL
);

ALTER TABLE watchlist
    ADD CONSTRAINT watchlist_uniq_list UNIQUE(id,film_id);


CREATE TABLE ratings
(
    id UUID NOT NULL,
    film_id UUID NOT NULL,
    rating float NOT NULL
);

ALTER TABLE ratings
    ADD CONSTRAINT ratings_uniq_list UNIQUE(id,film_id);

CREATE TABLE rating
(
    film_id UUID NOT NULL,
    rating float NOT NULL
);

CREATE TABLE actors
(
    id UUID PRIMARY KEY,
    name text NOT NULL,
    surname text NOT NULL,
    avatar text NOT NULL,
    height float NOT NULL,
    date_of_birth TIMESTAMP NOT NULL,
    description text NOT NULL,
    genres text[] NOT NULL
);

CREATE OR REPLACE FUNCTION make_tsvector(title TEXT)
    RETURNS tsvector AS $$
BEGIN
    RETURN (setweight(to_tsvector('english', title),'A') ||
            setweight(to_tsvector('russian', title), 'B'));
END
$$ LANGUAGE 'plpgsql' IMMUTABLE;


INSERT INTO actors VALUES ('388982ac-64d5-11ec-90d6-0242ac120003', 'Шайа', 'Лабаф', '388982ac-64d5-11ec-90d6-0242ac120003.jpg', 176, '1986-06-11 00:00:00', 'Американский актёр, сыгравший главные роли «Паранойя», «На крючке».', '{Драмы,Приключения,Комедия}');
INSERT INTO actors VALUES ('42903802-d80f-4f9f-aa6e-4f3dd08f9821', 'Хилари', 'Дафф', '31505.jpg', 161, '1987-09-28 00:00:00', 'Американская актриса, певица в направление данс-поп.', '{Драмы,Приключения,Комедия}');
INSERT INTO actors VALUES ('8c8e9d7e-f553-4aba-9da2-8ab137ec7ca4', 'Адам', 'Лэмберг', '31506.jpg', 177, '1984-09-14 00:00:00', 'Американский актёр.', '{Драмы,Приключения,Комедия}');
INSERT INTO actors VALUES ('e5717e55-d822-461a-bca1-a19764d59a06', 'Лоренс', 'Фишбёрн', '9838.jpg', 151, '1961-06-30 00:00:00', 'Американский актёр и продюсер.', '{Фантастика,Боевики}');
INSERT INTO actors VALUES ('0d4b2616-f636-4457-9e21-4ffe7b828149', 'Сигурни', 'Уивер', '6915.jpg', 175, '1949-10-08 00:00:00', 'Американская актриса и продюсер.', '{Драма,Детективы,Приключения,Комедия}');
INSERT INTO actors VALUES ('313598fb-6eae-4cb7-9629-ccf10aea89f4', 'Джон', 'Войт', '515.jpg', 170, '1938-12-29 00:00:00', 'Американский актёр, лауреат премий «Оскар» и «Золотой глобус».', '{Драма,Детективы,Приключения,Комедия}');
INSERT INTO actors VALUES ('a6909e2d-8fc8-43f0-ad7f-e0ae11c75964', 'Адам', 'Сэндлер', '7627.jpg', 150, '1966-09-09 00:00:00', 'Американский комик, киноактёр, музыкант, сценарист и кинопродюсер.', '{Драмы,Комедия}');
INSERT INTO actors VALUES ('942a7956-e666-4ab9-a6b9-1616c8092fe1', 'Джек', 'Николсон', '30056.jpg', 164, '1937-04-22 00:00:00', 'Американский актёр, кинорежиссёр, сценарист и продюсер.', '{Драмы,Комедия,Ужасы}');
INSERT INTO actors VALUES ('3b502535-e074-4cd3-87fb-70314f2e5988', 'Эдвард', 'Бёрнс', '719.jpg', 162, '1968-01-29 00:00:00', 'Американский актёр, кинорежиссёр, сценарист и продюсер.', '{Триллер,Детективы}');
INSERT INTO actors VALUES ('dfec6bf7-d5f0-4ad1-ae43-893ae9793c99', 'Рэйчел', 'Вайс', '12586.jpg', 179, '1970-03-07 00:00:00', 'Английская актриса.', '{Триллер,Детективы}');
INSERT INTO actors VALUES ('72dd2b7d-f90b-492b-bfa9-42dd63cc86f9', 'Кифер', 'Сазерленд', '7131.jpg', 171, '1966-12-21 00:00:00', 'Канадский актёр, продюсер, режиссёр и автор-исполнитель.', '{Триллер,Детективы}');
INSERT INTO actors VALUES ('7d4e974a-2af6-4c41-b760-23225e8fef4c', 'Аль', 'Пачино', '26240.jpg', 167, '1940-05-25 00:00:00', 'Американский актёр, режиссёр и сценарист.', '{Триллер,Боевики}');
INSERT INTO actors VALUES ('c3613ee4-64dd-11ec-90d6-0242ac120003', 'Колин', 'Фаррелл', '373.jpg', 176, '1975-06-28 00:00:00', 'Ирландский актёр кино и телевидения.', '{Триллер,Боевики}');
INSERT INTO actors VALUES ('b310248d-f398-4199-a63c-b2dc79263ea7', 'Джейми', 'Кеннеди', '1576.jpg', 156, '1970-03-08 00:00:00', 'Американский актёр, комик и рэпер.', '{Детективы,Комедия}');
INSERT INTO actors VALUES ('94f31064-c88d-497a-b03a-f818768d408f', 'Эрик', 'Кристиан', '26880.jpg', 177, '1977-09-28 00:00:00', 'мериканский актёр, наиболее известный по роли детектива Марти Дикса', '{Комедия,Детективы}');
INSERT INTO actors VALUES ('02f3dfcb-235a-4628-a4a1-2a3577109305', 'Дерек', 'Ричардсон', '30160.jpg', 157, '1976-01-18 00:00:00', 'Американский актёр.', '{Комедия}');
INSERT INTO actors VALUES ('328db934-874e-4283-ab1d-1da4c12ea012', 'Кристиан', 'Бэйл', '21495.jpg', 178, '1974-01-30 00:00:00', 'Британо-американский актёр. Лауреат премий «Золотой глобус».', '{Триллер,Драма,Фантастика,Боевики}');
INSERT INTO actors VALUES ('1f1df240-f513-40ed-acd1-fc8dbd3e8a4e', 'Тэй', 'Диггз', '1f1df240-f513-40ed-acd1-fc8dbd3e8a4e.png',150, '1971-01-02 00:00:00', 'Американский актёр и певец.', '{Триллер,Драма,Фантастика,Боевики}');
INSERT INTO actors VALUES ('d8f2012f-3801-48cf-a824-6ed716c7165b', 'Эдди', 'Мёрфи', 'd8f2012f-3801-48cf-a824-6ed716c7165b.png', 151, '1961-04-03 00:00:00', 'Американский комедийный актёр, кинорежиссёр, продюсер и певец.', '{Комедия}');
INSERT INTO actors VALUES ('cd6f9ff4-6573-4314-b14c-329cd7be270d', 'Стив', 'Зан', 'cd6f9ff4-6573-4314-b14c-329cd7be270d.png',168, '1967-11-13 00:00:00', 'Американский актёр и комик.', '{Комедия}');
INSERT INTO actors VALUES ('7ae1466a-e35f-4309-8fa2-978998ee48fe', 'Чоу', 'Юнь-Фат', '7ae1466a-e35f-4309-8fa2-978998ee48fe.png',161, '1955-06-18 00:00:00', 'Китайский актёр, один из наиболее известных киноактёров Азии. ', '{Драмы,Боевики,Фэнтези,Комедия}');
INSERT INTO actors VALUES ('d14802a0-fd9d-4d4f-9fc6-ab6f8f8845ca', 'Шонн', 'Уильям', 'd14802a0-fd9d-4d4f-9fc6-ab6f8f8845ca.png',159, '1976-11-03 00:00:00', 'Американский актёр и коммик.', '{Драмы,Боевики,Фэнтези,Комедия}');
INSERT INTO actors VALUES ('e45797cf-4427-4903-99a7-595e4e6d2ad1', 'Элайджа', 'Вуд', 'd14802a0-fd9d-4d4f-9fc6-ab6f8f8845ca.png',177, '1981-01-28 00:00:00', 'Американский актёр. Наиболее известен по роли Фродо Бэггинса во «Властелин колец».', '{Драма,Приключения,Фэнтези}');
INSERT INTO actors VALUES ('b7b1ec06-9e60-472c-828a-c1e7c9090db5', 'Иэн', 'Маккеллен', '7b1ec06-9e60-472c-828a-c1e7c9090db5.png',151, '1939-05-15 00:00:00', 'Британский актёр. Лауреат семи британских театральных наград Лоуренса Оливье.', '{Драма,Приключения,Фэнтези,Боевики}');
INSERT INTO actors VALUES ('0e66ce4b-cf81-4f85-81a5-245081d26b41', 'Парминдер', 'Каур', '0e66ce4b-cf81-4f85-81a5-245081d26b41.png',156, '1988-01-12 00:00:00', 'Английская актриса и певица. ', '{Драма,Драмы,Комедия}');
INSERT INTO actors VALUES ('48d5a192-fbae-4423-9a48-441a37c5bca8', 'Кира', 'Найтли', '48d5a192-fbae-4423-9a48-441a37c5bca8.png',163, '1985-04-26 00:00:00', 'Британская актриса. Двукратная номинантка на премии «Оскар» и BAFTA', '{Драма,Драмы,Комедия}');
INSERT INTO actors VALUES ('3806b3e1-3e16-4464-9c0c-a2c15387c449', 'Роб', 'Шнайдер', '3806b3e1-3e16-4464-9c0c-a2c15387c449.png',154, '1963-10-31 00:00:00', 'Американский комедийный киноактёр, сценарист, кинорежиссёр и кинопродюсер.', '{Фэнтези,Комедия}');
INSERT INTO actors VALUES ('6c14e6ac-6372-43f2-bf90-385e18cb2c69', 'Анна', 'Фэрис', '6c14e6ac-6372-43f2-bf90-385e18cb2c69.png',153, '1974-04-21 00:00:00', 'Американская комедийная актриса, певица и продюсер. ', '{Фэнтези,Комедия}');
INSERT INTO actors VALUES ('fe6ba91c-7f3a-4ab6-93e7-fa031a626bc5', 'Киану', 'Ривз', 'fe6ba91c-7f3a-4ab6-93e7-fa031a626bc5.png',177, '1964-09-02 00:00:00', 'Канадский актёр, кинорежиссёр, кинопродюсер и музыкант.', '{Фантастика,Боевики}');
INSERT INTO actors VALUES ('9ce13ada-31ba-48f3-9ef8-535c1849d6b9', 'Хьюго', 'Уивинг', '9ce13ada-31ba-48f3-9ef8-535c1849d6b9.png',178, '1960-05-04 00:00:00', 'Британо-австралийский киноактёр.', '{Фантастика,Боевики}');
INSERT INTO actors VALUES ('d4adbae3-7487-41f4-9acd-4cd21a216cfb', 'Сандра', 'Буллок', 'd4adbae3-7487-41f4-9acd-4cd21a216cfb.png',169, '1964-06-24 00:00:00', 'Американская актриса театра, кино и телевидения, обладательница премии «Оскар»', '{Драмы,Комедия}');
INSERT INTO actors VALUES ('42c7e022-7590-4da5-858a-e913e20a89fa', 'Хью', 'Грант', '42c7e022-7590-4da5-858a-e913e20a89fa.png',153, '1960-09-09 00:00:00', 'Английский актёр, ставший популярным после выхода картин «Ноттинг Хилл», «Дневник Бриджит Джонс».', '{Драмы,Комедия,Детективы}');
INSERT INTO actors VALUES ('ef274fb8-4d57-4a2f-a6b8-d16c6937b8cd', 'Шарлиз', 'Терон', 'ef274fb8-4d57-4a2f-a6b8-d16c6937b8cd.png',151, '1975-08-07 00:00:00', 'Южноафриканская и американская актриса и продюсер. ', '{Триллер,Детективы,Боевики,Фэнтези}');
INSERT INTO actors VALUES ('e8c39d1f-4dc8-4cc4-8429-ee551cf3e9de', 'Марк', 'Уолберг', 'e8c39d1f-4dc8-4cc4-8429-ee551cf3e9de.png',159, '1971-07-05 00:00:00', 'Американский актёр, музыкант, филантроп и фотомодель.', '{Триллер,Детективы,Боевики}');
INSERT INTO actors VALUES ('078e10be-09eb-4046-9d9c-17bb72a08bf3', 'Арнольд', 'Шварценеггер', '078e10be-09eb-4046-9d9c-17bb72a08bf3.png',160, '1947-07-30 00:00:00', 'Американский культурист, киноактёр, продюсер и политический деятель австрийского происхождения.', '{Фантастика,Боевики,Ужасы}');
INSERT INTO actors VALUES ('46d71ef1-7903-4b3c-91b0-2848ef0bb750', 'Ник', 'Стал', '078e10be-09eb-4046-9d9c-17bb72a08bf3.png',175, '1979-12-5 00:00:00', 'Американский актёр.', '{Фантастика,Боевики}');
INSERT INTO actors VALUES ('215002be-64c1-11ec-90d6-0242ac120003', 'Мэттью', 'МакКонахи', '215002be-64c1-11ec-90d6-0242ac120003.png',182, '1969-11-04 00:00:00', 'Американский актёр и продюсер.', '{Фантастика,Боевики,Драмы}');
INSERT INTO actors VALUES ('35cdbcd6-64c1-11ec-90d6-0242ac120003', 'Энн', 'Хэтэуэй', '35cdbcd6-64c1-11ec-90d6-0242ac120003.png',173, '1982-11-12 00:00:00', 'Американская актриса и певица.', '{Фантастика,Драмы}');
INSERT INTO actors VALUES ('e9d237ac-64c1-11ec-90d6-0242ac120003', 'Джессика', 'Честейн', 'e9d237ac-64c1-11ec-90d6-0242ac120003.png',170, '1977-04-24 00:00:00', 'Американская актриса и продюсер. ', '{Фантастика,Боевики,Драмы,Фэнтези}');
INSERT INTO actors VALUES ('f1e3dc02-64c1-11ec-90d6-0242ac120003', 'Мэтт', 'Дэймон', 'f1e3dc02-64c1-11ec-90d6-0242ac120003.png',178, '1970-10-08 00:00:00', 'Американский актёр кино, телевидения и озвучивания, сценарист и продюсер.', '{Фантастика,Драмы,Мультфильмы}');
INSERT INTO actors VALUES ('fa68b2da-64c1-11ec-90d6-0242ac120003', 'Билл', 'Ирвин', 'fa68b2da-64c1-11ec-90d6-0242ac120003.png',182, '1950-06-11 00:00:00', 'Американский актёр, клоун и комедиант', '{Фантастика,Драмы,Мультфильмы}');


-- INSERT INTO films VALUES ('e16fc41a-dce8-44fa-bba6-d9af1eecfebd', '{Драмы,Приключения,Комедия}', 'США', '2003-01-01 03:00:00+03', 'Лиззи Магуайр', 2003, '{"Джим Фолл"}', '{"Сьюзэн Эстель Джэнсен","Эд Дектер","Джон Дж. Штраусс","Терри Мински"}', '{42903802-d80f-4f9f-aa6e-4f3dd08f9821,8c8e9d7e-f553-4aba-9da2-8ab137ec7ca4}', '2003-01-01', 94, 'Ru', '100 млн', 12, '{lizzi-maguair.png}', '{lizzi-maguair.mp4}', 'Тринадцатилетняя школьница Лиззи Магуайер и ее приятели Гордо, Кейт и Эсан собираются оттянуться по полной программе во время их поездки с классом в Италию.
-- Но там случается весьма неожиданное происшествие: девочку ошибочно принимают за итальянскую поп-звезду Изабеллу, да к тому же девушка влюбляется в бывшего дружка Изабеллы Паоло. Когда родители Лизи обо всем узнают, они вместе с ее братом Мэттом срочно вылетают в Италию.
-- Но Лиззи уже не та закомплексованная девочка-подросток, кем была раньше, она до такой степени вжилась в роль певицы, что и на самом деле стала самой настоящей звездой.', false, true, 'lizzi-maguair');
INSERT INTO films VALUES ('53509572-64c0-11ec-90d6-0242ac120003', '{Фантастика,Приключения}', 'США', '2014-05-07 03:00:00+03', 'Интерстеллар', 2014, '{"Кристофер Нолан"}', '{"Джонатан Нолан", " Кристофер Нолан"}', '{215002be-64c1-11ec-90d6-0242ac120003,35cdbcd6-64c1-11ec-90d6-0242ac120003,e9d237ac-64c1-11ec-90d6-0242ac120003,f1e3dc02-64c1-11ec-90d6-0242ac120003,fa68b2da-64c1-11ec-90d6-0242ac120003}', '2014-05-08', 169, 'Ru', '230 млн', 12, '{interstellar.webp, interstellar-big.webp}', '{interstellars.mp4}', 'Оскароносная космическая одиссея от Кристофера Нолана («Начало») о спасении человечества. Планета на грани смерти: всемирная засуха, массовая гибель растений и животных и пылевые бури приводят к нехватке продовольствия. Чтобы обеспечить выживание человечества, команда учёных вместе с бывшим пилотом НАСА Купером (Мэттью МакКонахи) отправляется в путешествие сквозь космическую червоточину. Оправдается ли их надежда найти людям новый дом в другой Галактике?', false, false, 'interstellar');
INSERT INTO films VALUES ('9d574931-e719-44fc-bad2-69a1de36d00e', '{Фантастика,Боевики}', 'США', '1999-01-01 03:00:00+03', 'Матрица', 1999, '{"Лана Вачовски"," Лилли Вачовски"}', '{"Лилли Вачовски"," Лана Вачовски"}', '{fe6ba91c-7f3a-4ab6-93e7-fa031a626bc5,e5717e55-d822-461a-bca1-a19764d59a06}', '1999-01-01', 136, 'Ru', '120 млн', 16, '{matrix.webp, matrix-big.webp}', '{matritsa.mp4}', 'Жизнь Томаса Андерсона разделена на две части: днём он — самый обычный офисный работник, получающий нагоняи от начальства, а ночью превращается в хакера по имени Нео, и нет места в сети, куда он бы не смог проникнуть. Но однажды всё меняется. Томас узнаёт ужасающую правду о реальности.', false, false, 'matrix');
INSERT INTO films VALUES ('f0285cb7-d7c7-48d7-b94a-1bdf62469553', '{Детективы,Приключения,Комедия}', 'США', '2003-04-20 03:00:00+03', 'Клад', 2003, '{"Эндрю Дэвис"}', '{"Луис Сачар"}', '{388982ac-64d5-11ec-90d6-0242ac120003,0d4b2616-f636-4457-9e21-4ffe7b828149,313598fb-6eae-4cb7-9629-ccf10aea89f4}', '2003-04-28', 117, 'Ru', '80 млн', 12, '{klad.webp, klad-big.webp}', '{klad.mp4}', 'Стэнли арестован по ложному обвинению в краже кроссовок и отправлен в трудовой лагерь, расположенный в техасской пустыне. Воспитатели «закаляют характер» подростков странным наказанием. Ребята копают ямы в иссушенной земле, но не знают, что их на самом деле используют для раскопок таинственного клада. Однако Стэнли удается раскрыть загадочную связь между сокровищами и проклятием, тяготеющим долгие годы над его семьей…', false, false, 'klad');
INSERT INTO films VALUES ('c8ae08e9-ee3d-4b59-9bdf-af456de7f97a', '{Драмы,Комедия}', 'США', '2003-09-11 03:00:00+03', 'Управление гневом', 2003, '{"Питер Сигал"}', '{"Дэвид Дорфман"}', '{a6909e2d-8fc8-43f0-ad7f-e0ae11c75964,942a7956-e666-4ab9-a6b9-1616c8092fe1}', '2003-09-17', 106, 'Ru', '90 млн', 12, '{upravlenie-gnevom.webp, upravlenie-gnevom-big.webp}', '{upravlenie-gnevom.mp4}', 'Скромному клерку отчаянно не везет. Парня по обвинению в нападении на бортпроводницу приговаривают к лечению у психиатра. Но верно говорят, что большинство психиатров сами немного безумны. Или сильно не в себе...', false, false, 'upravlenie-gnevom');
INSERT INTO films VALUES ('3100072a-e1e5-44c6-9a10-77be314dd492', '{Триллер,Детективы}', 'США', '2002-11-05 03:00:00+03', 'Телефонная будка', 2002, '{"Джоэл Шумахер"}', '{"Ларри Коэн"}', '{c3613ee4-64dd-11ec-90d6-0242ac120003, 72dd2b7d-f90b-492b-bfa9-42dd63cc86f9}', '2002-11-14', 97, 'Ru', '100 млн', 16, '{telefonnaia-budka.webp, telefonnaia-budka-big.webp}', '{telefonnaia-budka.mp4}', 'Один телефонный звонок может изменить всю жизнь человека или даже оборвать ее. Герой фильма Стью Шеферд становится пленником телефонной будки.
Что вы сделаете, если услышите, как в телефонной будке зазвонил телефон? Скорее всего, инстинктивно поднимете трубку, хотя прекрасно знаете, что кто-то просто ошибся номером. Вот и Стью кажется, что на звонок надо обязательно ответить, а в результате он оказывается втянутым в чудовищную игру. «Только положи трубку, и ты – труп», – говорит ему невидимый собеседник.', false, false, 'telefonnaia-budka');
INSERT INTO films VALUES ('335b9fdd-64e9-4403-ba24-7269ca8a5a52', '{Триллер,Боевики}', 'США', '2003-01-01 03:00:00+03', 'Рекрут', 2003, '{"Роджер Дональдсон"}', '{"Роджер Таун"," Курт Уиммер"," Митч Глейзер"}', '{7d4e974a-2af6-4c41-b760-23225e8fef4c, c3613ee4-64dd-11ec-90d6-0242ac120003}', '2003-01-01', 115, 'Ru', '50 млн', 16, '{rekrut.webp, rekrut-big.webp}', '{rekrut.mp4}', 'Джеймс Клэйтон - студент и опытный хакер. Он привлекает внимание спецслужб, и его вербуют в ЦРУ, упоминая таинственное исчезновение его отца в 90-х. Джеймс обучается у Уолтера Бёрка. Он отлично сдает все тесты, кроме последнего. Так он становится агентом без прикрытия и получает задание: найти «крота», который похищает опасный вирус из Лэнгли.', false, false, 'rekrut');
INSERT INTO films VALUES ('ddd73f7f-3ae7-467f-a79b-f3465485a8bf', '{Комедия}', 'США', '2003-10-30 03:00:00+03', 'Тупой и еще тупее тупого', 2003, '{"Трой Миллер"}', '{"Питер Фаррелли"," Беннетт Йеллин"," Дэнни Байерс"," Бобби Фаррелли"," Роберт Бренер"}', '{94f31064-c88d-497a-b03a-f818768d408f,02f3dfcb-235a-4628-a4a1-2a3577109305}', '2003-10-15', 85, 'Ru', '110 млн', 16, '{dumb-and-dumber.webp, dumb-and-dumber-big.webp}', '{tupoi-i-eshche-tupee-tupogo-kogda-garri-vstretil-lloida.mp4}', 'Как же встретились два героя-недоумка Гарри и Ллойд, известные по фильму «Тупой и еще тупее»? Оба несколько лет не ходили в школу, а учились на дому. Пришло время отправляться в школу, и прямо на улице Гарри и Ллойд столкнулись лбами...
А в это время школьный директор Коллинз и мисс Хеллер, буфетчица-официантка школьной столовой, задумали провернуть аферу - получить благотворительную премию в сто тысяч долларов за организацию класса для умственно отсталых. Злоумышленники решили создать липовый класс. Два кандидата в спецкласс нашлись сразу - Гарри и Ллойд, а они разыскали остальных...', false, false, 'dumb-and-dumber');
INSERT INTO films VALUES ('fbf17d95-f8bb-4ed7-b385-5111c321cbdc', '{Триллер,Фантастика,Боевики}', 'США', '2002-06-24 03:00:00+03', 'Эквилибриум', 2002, '{"Курт Уиммер"}', '{"Курт Уиммер", " Трой Миллер"}', '{328db934-874e-4283-ab1d-1da4c12ea012,1f1df240-f513-40ed-acd1-fc8dbd3e8a4e}', '2002-06-29', 124, 'Ru', '140 млн', 16, '{ekvilibrium.webp, ekvilibrium-big.webp}', '{ekvilibrium.mp4}', 'В будущем люди лишены возможности выражать эмоции. Это цена, которую человечество платит за устранение из своей жизни войны. Теперь книги, искусство и музыка находятся вне закона, а любое чувство — преступление, наказуемое смертью.
Для приведения в жизнь существующего правила используется принудительное применение лекарства прозиум. Правительственный агент Джон Престон борется с теми, кто нарушает правила. В один прекрасный момент он забывает принять очередную дозу лекарства, и с ним происходит духовное преображение, что приводит его к конфликту не только с режимом, но и с самим собой.', false, false, 'ekvilibrium');
INSERT INTO films VALUES ('36fe5b42-da42-40a7-a554-985c6351f310', '{Комедия}', 'США', '2003-03-15 03:00:00+03', 'Дежурный папа', 2003, '{"Стив Карр"}', '{"Джефф Родкей"}', '{d8f2012f-3801-48cf-a824-6ed716c7165b,cd6f9ff4-6573-4314-b14c-329cd7be270d}', '2003-03-15', 95, 'Ru', '50 млн', 12, '{dezhurnyi-papa.webp, dezhurnyi-papa-big.webp}', '{dezhurnyi-papa.mp4}', 'Чарли и Фила увольняют с работы в крупной корпорации. Теперь им самим придётся сидеть со своими сыновьями, так как оплачивать счета дорогостоящего детского центра уже не на что. Промучившись пару недель со своими отпрысками, папаши так увлекаются этим делом, что решают поставить дело на деловые рельсы и открывают новый центр дневного пребывания для детей.
Чарли и Филл находят всё новые и новые нетрадиционные и забавные способы воспитательного воздействия на малышей, и центр «Дежурный папа» становится всё более популярным. Почувствовав жёсткое соперничество со стороны усатых няней, директриса дорогого детского центра решает выжить конкурентов-новичков из бизнеса.', false, false, 'dezhurnyi-papa');
INSERT INTO films VALUES ('55e547e7-c344-4990-9952-8bcf94661f0b', '{Боевики,Фэнтези,Комедия}', 'США', '2003-09-12 03:00:00+03', 'Пуленепробиваемый', 2003, '{"Пол Хантер"}', '{"Этан Райфф "," Сайрус Ворис"}', '{7ae1466a-e35f-4309-8fa2-978998ee48fe,d14802a0-fd9d-4d4f-9fc6-ab6f8f8845ca}', '2003-09-12', 104, 'Ru', '80 млн', 12, '{puleneprobivaemyi.webp, puleneprobivaemyi-big.webp}', '{puleneprobivaemyi.mp4}', 'Монах - мастер боевых искусств, который охраняет могущественный древний свиток - таинственный артефакт, содержащий ключ к безграничной власти. Монаху нужно найти следующего хранителя свитка, и поиски приводят его в Америку. Согласно древнему пророчеству и к изумлению Монаха его преемником оказывается обаятельный хулиган по имени Кар.
Пока Монах обучает Кара, как выполнять свою работу, этому невероятному дуэту приходится защищать свиток от одержимого жаждой власти человека, который гоняется за ним 60 лет.
В суматохе невероятной акробатики, схваток с применением боевых искусств и остроумных шуток эта комическая странная парочка должна сделать всё, чтобы свиток не попал в руки злодея.', false, false, 'puleneprobivaemyi');
INSERT INTO films VALUES ('ba7c44b4-1fac-48f2-832f-200fd18dfe8c', '{Драма,Приключения,Фэнтези}', 'США', '2002-11-14 03:00:00+03', 'Властелин колец: Две крепости', 2002, '{"Питер Джексон"}', '{"Дж.Р.Р. Толкин"," Фрэн Уолш"," Филиппа Бойенс"," Питер Джексон"}', '{e45797cf-4427-4903-99a7-595e4e6d2ad1,b7b1ec06-9e60-472c-828a-c1e7c9090db5}', '2002-11-16', 179, 'Ru', '150 млн', 12, '{vlastelin-kolets-dve-kreposti.webp, vlastelin-kolets-dve-kreposti-big.webp}', '{vlastelin-kolets-dve-kreposti.mp4}', 'Братство распалось, но Кольцо Всевластья должно быть уничтожено. Фродо и Сэм вынуждены доверится Голлуму, который взялся провести их к вратам Мордора. Громадная армия Сарумана приближается: члены братства и их союзники готовы принять бой. Битва за Средиземье продолжается.', false, false, 'vlastelin-kolets-dve-kreposti');
INSERT INTO films VALUES ('82879482-9ceb-492a-8333-80faab5edd64', '{Фэнтези,Комедия}', 'США', '2002-06-25 03:00:00+03', 'Цыпочка', 2002, '{"Том Брэди"}', '{"Том Брэди"," Роб Шнайдер"}', '{3806b3e1-3e16-4464-9c0c-a2c15387c449,6c14e6ac-6372-43f2-bf90-385e18cb2c69}', '2002-06-25', 104, 'Ru', '40 млн', 16, '{tsypochka.webp, tsypochka-big.webp}', '{tsypochka.mp4}', 'Популярная, но неприятная в общении старшеклассница Джессика однажды утром просыпается в теле 30-летнего мужчины с не самой привлекательной внешностью. Девушка отправляется на поиски своего тела, и это приключение помогает ей увидеть себя со стороны и понять, насколько поверхностной и недалёкой она была.', false, false, 'tsypochka');
INSERT INTO films VALUES ('8d7db471-6810-4045-a841-fa47a72f5242', '{Фантастика,Боевики}', 'США', '2003-12-06 03:00:00+03', 'Матрица: Революция', 2003, '{"Лана Вачовски"," Лилли Вачовски"}', '{"Лилли Вачовски"," Лана Вачовски"}', '{fe6ba91c-7f3a-4ab6-93e7-fa031a626bc5,9ce13ada-31ba-48f3-9ef8-535c1849d6b9}', '2003-12-06', 129, 'Ru', '120 млн', 16, '{matrix-revolution.webp, matrix-revolution-big.webp}', '{matritsa.mp4}', 'Пока армия Машин пытается уничтожить Зион, его жители из последних сил держат оборону. Но удастся ли им предотвратить полное вторжение в город кишащей орды беспощадных машин до того, как Нео соберет все свои силы и положит конец войне?', false, false, 'matrix-revolution');
INSERT INTO films VALUES ('6c6abded-9206-44b8-b149-92f08569ca8d', '{Драмы,Комедия}', 'США', '2002-01-23 03:00:00+03', 'Любовь с уведомлением', 2002, '{"Марк Лоуренс"}', '{"Марк Лоуренс"}', '{d4adbae3-7487-41f4-9acd-4cd21a216cfb,42c7e022-7590-4da5-858a-e913e20a89fa}', '2002-01-23', 101, 'Ru', '90 млн', 12, '{liubov-s-uvedomleniem.webp, liubov-s-uvedomleniem-big.webp}', '{liubov-s-uvedomleniem.mp4}', 'Джордж Уэйд и шага не может сделать без Люси Келсон, работающей главным консультантом в его корпорации. Однако обращается он с ней скорее как с няней, а не как с блестящим юристом, окончившим Гарвард. По прошествии года все это надоедает Люси, и она решает уволиться. Джордж соглашается ее отпустить, но с одним условием — она должна найти себе достойную замену...', false, false, 'liubov-s-uvedomleniem');
INSERT INTO films VALUES ('c2e011a5-42cc-40f5-97a3-4dc430be3c49', '{Триллер,Детективы,Боевики}', 'США', '2003-08-12 03:00:00+03', 'Ограбление по-итальянски', 2003, '{"Гэри Грей"}', '{"Трой Кеннеди-Мартин"," Донна Пауэрс"," Уэйн Пауэрс"}', '{ef274fb8-4d57-4a2f-a6b8-d16c6937b8cd,e8c39d1f-4dc8-4cc4-8429-ee551cf3e9de}', '2003-08-16', 111, 'Ru', '100 млн', 12, '{ograblenie-po-italianski.webp, ograblenie-po-italianski-big.webp}', '{ograblenie-po-italianski.mp4}', 'Джон Бриджер всегда умел спланировать идеальное ограбление. Вместе со своей командой опытных бандитов он провернул не одно дело, но теперь решил уйти на покой. Впереди у Бриджера последнее задание: кража золотых слитков, в которой принимают участие инсайдер Стив, водитель Роб, взрыватель Левое ухо, технарь Лайл и Чарли - верный друг Бриджера и второй «планировщик» в их команде. Ограбление, изящное и быстрое, было разыграно как по нотам, но после его завершения веселье преступников было омрачено предательством...', false, false, 'ograblenie-po-italianski');
INSERT INTO films VALUES ('1dfc3231-c9c9-4962-8954-01da59c5dcdd', '{Фантастика,Боевики}', 'США', '2003-02-23 03:00:00+03', 'Терминатор 3: Восстание машин', 2003, '{"Джонатан Мостоу"}', '{"Джеймс Кэмерон"," Джон Бренкето"," Майкл Феррис"," Гейл Энн Хёрд"," Теди Сарафьян"}', '{078e10be-09eb-4046-9d9c-17bb72a08bf3,46d71ef1-7903-4b3c-91b0-2848ef0bb750}', '2003-02-23', 115, 'Ru', '100 млн', 16, '{terminator-3-vosstanie-mashin.webp, terminator-3-vosstanie-mashin-big.webp}', '{terminator-3-vosstanie-mashin.mp4}', 'Прошло десять лет с тех пор, как Джон Коннор помог предотвратить Судный День и спасти человечество от массового уничтожения. Теперь ему 25, Коннор не живет «как все» - у него нет дома, нет кредитных карт, нет сотового телефона и никакой работы.
Его существование нигде не зарегистрировано. Он не может быть прослежен системой Skynet - высокоразвитой сетью машин, которые когда-то попробовали убить его и развязать войну против человечества. Пока из теней будущего не появляется T-X - Терминатрикс, самый сложный киборг-убийца Skynet.
Посланная назад сквозь время, чтобы завершить работу, начатую её предшественником, T-1000, эта машина так же упорна, как прекрасен её человеческий облик. Теперь единственная надежда Коннору выжить - Терминатор, его таинственный прежний убийца. Вместе они должны одержать победу над новыми технологиями T-X и снова предотвратить Судный День...', false, false, 'terminator-3-vosstanie-mashin');

-- INSERT INTO films VALUES ('a377a105-0b4a-40b7-a6e1-f31bf1b5c8e4', '{Драма,Драмы,Комедия,спорт}', 'США', '2002-01-01 03:00:00+03', 'Играй, как Бекхэм', 2002, '{"Гуриндер Чадха"}', '{"Гуриндер Чадха","Гюльджит Биндра","Пол Маеда Берджес"}', '{0e66ce4b-cf81-4f85-81a5-245081d26b41,48d5a192-fbae-4423-9a48-441a37c5bca8}', '2002-01-01', 112, 'Ru', '100 млн', 16, '{"igrai,-kak-bekkhem.png"}', '{"igrai,-kak-bekkhem.mp4"}', 'Джесс только 18, но она твердо знает, что сделает ее счастливой: футбольная карьера, такая же, как у знаменитого игрока «Манчестер Юнайтед» Дэвида Бекхема. Пока она гоняет мяч в лондонском парке, доказывая соседским мальчишкам, что девушки играют в футбол не хуже, ее родители и многочисленные родственники, как и положено традиционной индийской семье, подыскивают для нее достойного мужа и строят планы о ее будущей карьере юриста.
-- Однажды, во время очередной разминки, Джесс знакомится с Джулз и та приглашает ее на тренировку в женскую футбольную секцию. С замиранием сердца она следует за своей новой приятельницей, и мечта становится реальностью: Джесс принимают в настоящую футбольную команду. В довершение ко всему она влюбляется в своего тренера Джо.
-- Понимая, что семья никогда не примирится с ее выбором, Джесс наслаждается своим кратковременным счастьем и готовится отстаивать свои права до конца...', false, false, 'igrai,-kak-bekkhem');

-- INSERT INTO films VALUES ('cda6387e-a256-4f85-96cc-3cb27343fcc4', '{Триллер,Детективы}', 'США', '2003-01-01 03:00:00+03', 'Афера', 2003, '{"Джеймс Фоули"}', '{"Даг Джанг"}', '{3b502535-e074-4cd3-87fb-70314f2e5988,dfec6bf7-d5f0-4ad1-ae43-893ae9793c99}', '2003-01-01', 97, 'Ru', '100 млн', 16, '{afera.png}', '{afera.mp4}', 'Джейк Вига – хитроумный и обаятельный мошенник. Последняя афера Джейка привела к тому, что его дорожки пересеклись с мафией – при помощи своей команды он лишил нескольких тысяч долларов Лайонела Долби, – счетовода эксцентричного мафиозного босса Уинстона Кинга по прозвищу «Король».
-- Мафия шутить не любит, а любит выбивать долги из тех, кто пытается ее надуть. Чтобы сохранить жизнь и расквитаться с долгами, Джейку приходится устроить новую, еще более изощренную аферу – сложнейшую схему, в которой требуется «творческий подход к бухгалтерии».
-- Неожиданные помехи появляются одна за другой: палки в колеса Джейку вставляют его старый враг, агент ФБР Гюнтер Бутан, Трэвис, правая рука «Короля» и хитроумная карманщица Лили на которую Джейк успел положить глаз...', false, false, 'afera');
-- INSERT INTO films VALUES ('2a149c42-d48e-4ad6-a537-e95c19b0a4fd', '{Детективы,Комедия}', 'США', '2003-01-01 03:00:00+03', 'Разыскиваются в Малибу', 2003, '{"Джон Уайтселл"}', '{"Факс Бар","Адам Смолл","Джейми Кеннеди","Ник Свардсон"}', '{b310248d-f398-4199-a63c-b2dc79263ea7,1f1df240-f513-40ed-acd1-fc8dbd3e8a4e}', '2003-01-01', 86, 'Ru', '100 млн', 12, '{razyskivaiutsia-v-malibu.png}', '{razyskivaiutsia-v-malibu.mp4}', 'Не стоит ненавидеть его за то, кем он является. Или кем он не является. Все, чем хочет заниматься Брэд - или Би-рэд - разъезжать со своими дружками по Малибу и вести себя, как самый крутой черный рэппер в округе.
-- Но все вокруг знают, что паренек, лихо читающий рэп, родом из респектабельного квартала Малибу. И отец Брэда, Билл Глакман, кандидат в губернаторы, серьезно боится, что увлечение Би-рэда «черной» культурой может разнести в пух и прах его предвыборную кампанию.', false, false, 'razyskivaiutsia-v-malibu');

INSERT INTO rating VALUES ('e16fc41a-dce8-44fa-bba6-d9af1eecfebd', 4);
INSERT INTO rating VALUES ('9d574931-e719-44fc-bad2-69a1de36d00e', 1);
INSERT INTO rating VALUES ('f0285cb7-d7c7-48d7-b94a-1bdf62469553', 4);
INSERT INTO rating VALUES ('c8ae08e9-ee3d-4b59-9bdf-af456de7f97a', 1);
-- INSERT INTO rating VALUES ('cda6387e-a256-4f85-96cc-3cb27343fcc4', 2);
INSERT INTO rating VALUES ('3100072a-e1e5-44c6-9a10-77be314dd492', 4);
INSERT INTO rating VALUES ('335b9fdd-64e9-4403-ba24-7269ca8a5a52', 3);
-- INSERT INTO rating VALUES ('2a149c42-d48e-4ad6-a537-e95c19b0a4fd', 5);
INSERT INTO rating VALUES ('ddd73f7f-3ae7-467f-a79b-f3465485a8bf', 4);
INSERT INTO rating VALUES ('fbf17d95-f8bb-4ed7-b385-5111c321cbdc', 1);
INSERT INTO rating VALUES ('36fe5b42-da42-40a7-a554-985c6351f310', 4);
INSERT INTO rating VALUES ('55e547e7-c344-4990-9952-8bcf94661f0b', 4);
INSERT INTO rating VALUES ('ba7c44b4-1fac-48f2-832f-200fd18dfe8c', 4);
-- INSERT INTO rating VALUES ('a377a105-0b4a-40b7-a6e1-f31bf1b5c8e4', 9);
INSERT INTO rating VALUES ('82879482-9ceb-492a-8333-80faab5edd64', 3);
INSERT INTO rating VALUES ('8d7db471-6810-4045-a841-fa47a72f5242', 2);
INSERT INTO rating VALUES ('6c6abded-9206-44b8-b149-92f08569ca8d', 4);
INSERT INTO rating VALUES ('c2e011a5-42cc-40f5-97a3-4dc430be3c49', 5);
INSERT INTO rating VALUES ('1dfc3231-c9c9-4962-8954-01da59c5dcdd', 5);
INSERT INTO rating VALUES ('53509572-64c0-11ec-90d6-0242ac120003', 6);

