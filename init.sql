-- =========================
-- Tạo bảng
-- =========================
CREATE TABLE actors(
                       id int primary key generated always as identity,
                       first_name text,
                       last_name text
);

CREATE TABLE directors(
                          id int primary key generated always as identity,
                          first_name text,
                          last_name text
);

CREATE TABLE films(
                      id int primary key generated always as identity,
                      director_id int references directors(id),
                      title text,
                      year int,
                      rating numeric(3,1),
                      language text
);

CREATE TABLE technical_specs(
                                film_id int references films(id) primary key,
                                runtime time,
                                camera text,
                                sound text
);

CREATE TABLE roles(
                      film_id int references films(id),
                      actor_id int references actors(id),
                      character text,
                      primary key(film_id, actor_id)
);

CREATE TABLE competitions(
                             id int primary key generated always as identity,
                             name text,
                             year int
);

CREATE TABLE nominations(
                            competition_id int references competitions(id),
                            film_id int references films(id),
                            rank int,
                            primary key (competition_id, film_id)
);

-- =========================
-- Insert dữ liệu mẫu
-- =========================
INSERT INTO actors (first_name, last_name) VALUES
                                               ('Leonardo', 'DiCaprio'),
                                               ('Kate', 'Winslet'),
                                               ('Tom', 'Hanks'),
                                               ('Natalie', 'Portman'),
                                               ('Morgan', 'Freeman');

INSERT INTO directors (first_name, last_name) VALUES
                                                  ('James', 'Cameron'),
                                                  ('Steven', 'Spielberg'),
                                                  ('Christopher', 'Nolan');

INSERT INTO films (director_id, title, year, rating, language) VALUES
                                                                   (1, 'Titanic', 1997, 7.8, 'English'),
                                                                   (2, 'Saving Private Ryan', 1998, 8.6, 'English'),
                                                                   (3, 'Inception', 2010, 8.8, 'English'),
                                                                   (3, 'Interstellar', 2014, 8.6, 'English');

INSERT INTO technical_specs (film_id, runtime, camera, sound) VALUES
                                                                  (1, '03:14:00', 'Panavision Cameras', 'Dolby Digital'),
                                                                  (2, '02:49:00', 'Arriflex Cameras', 'DTS'),
                                                                  (3, '02:28:00', 'Panavision Cameras', 'Dolby Digital'),
                                                                  (4, '02:49:00', 'IMAX Cameras', 'Dolby Atmos');

INSERT INTO roles (film_id, actor_id, character) VALUES
                                                     (1, 1, 'Jack Dawson'),
                                                     (1, 2, 'Rose DeWitt Bukater'),
                                                     (2, 3, 'Captain Miller'),
                                                     (3, 1, 'Cobb'),
                                                     (4, 1, 'Cooper'),
                                                     (4, 4, 'Murph');

INSERT INTO competitions (name, year) VALUES
                                          ('Academy Awards', 1998),
                                          ('Golden Globes', 1998),
                                          ('Academy Awards', 2011),
                                          ('Cannes Film Festival', 2014);

INSERT INTO nominations (competition_id, film_id, rank) VALUES
                                                            (1, 1, 1), -- Titanic Oscar
                                                            (2, 1, 1), -- Titanic Golden Globes
                                                            (1, 2, 2), -- Saving Private Ryan Oscar
                                                            (3, 3, 1), -- Inception Oscar
                                                            (4, 4, 2); -- Interstellar Cannes

-- =========================
-- Tạo roles cho PostgREST
-- =========================
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'web_anon') THEN
CREATE ROLE web_anon NOLOGIN;
END IF;
END$$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'authenticator') THEN
CREATE ROLE authenticator NOINHERIT LOGIN PASSWORD 'mysecretpassword';
END IF;
END$$;

-- Phân quyền cho web_anon
GRANT USAGE ON SCHEMA public TO web_anon;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO web_anon;

-- Cho authenticator đóng vai web_anon
GRANT web_anon TO authenticator;
