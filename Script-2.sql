-- Создание таблицы "Жанры"
CREATE TABLE IF NOT EXISTS Genres (
    id SERIAL PRIMARY KEY,       -- Уникальный идентификатор жанра
    name VARCHAR(100) NOT NULL UNIQUE  -- Название жанра (уникальное)
);

-- Создание таблицы "Исполнители"
CREATE TABLE IF NOT EXISTS Artists (
    id SERIAL PRIMARY KEY,       -- Уникальный идентификатор исполнителя
    name VARCHAR(100) NOT NULL UNIQUE  -- Имя или псевдоним исполнителя (уникальное)
);

-- Создание таблицы "Альбомы"
CREATE TABLE IF NOT EXISTS Albums (
    id SERIAL PRIMARY KEY,       -- Уникальный идентификатор альбома
    title VARCHAR(100) NOT NULL, -- Название альбома
    year INT NOT NULL CHECK (year >= 1900),  -- Год выпуска (не ранее 1900 года)
    UNIQUE (title, year)  -- Уникальность альбома по названию и году
);

-- Создание таблицы "Треки"
CREATE TABLE IF NOT EXISTS Tracks (
    id SERIAL PRIMARY KEY,       -- Уникальный идентификатор трека
    title VARCHAR(100) NOT NULL, -- Название трека
    duration INT NOT NULL CHECK (duration > 0),  -- Длительность в секундах (положительное число)
    album_id INT REFERENCES Albums(id) ON DELETE CASCADE  -- Ссылка на альбом
);

-- Создание таблицы "Сборники"
CREATE TABLE IF NOT EXISTS Compilations (
    id SERIAL PRIMARY KEY,       -- Уникальный идентификатор сборника
    title VARCHAR(100) NOT NULL, -- Название сборника
    year INT NOT NULL CHECK (year >= 1900)  -- Год выпуска (не ранее 1900 года)
);

-- Промежуточная таблица "Жанры-Исполнители"
CREATE TABLE IF NOT EXISTS GenreArtist (
    genre_id INT REFERENCES Genres(id) ON DELETE CASCADE,  -- Ссылка на жанр
    artist_id INT REFERENCES Artists(id) ON DELETE CASCADE,  -- Ссылка на исполнителя
    PRIMARY KEY (genre_id, artist_id)  -- Составной первичный ключ
);

-- Промежуточная таблица "Исполнители-Альбомы"
CREATE TABLE IF NOT EXISTS ArtistAlbum (
    artist_id INT REFERENCES Artists(id) ON DELETE CASCADE,  -- Ссылка на исполнителя
    album_id INT REFERENCES Albums(id) ON DELETE CASCADE,  -- Ссылка на альбом
    PRIMARY KEY (artist_id, album_id)  -- Составной первичный ключ
);

-- Промежуточная таблица "Треки-Сборники"
CREATE TABLE IF NOT EXISTS TrackCompilation (
    track_id INT REFERENCES Tracks(id) ON DELETE CASCADE,  -- Ссылка на трек
    compilation_id INT REFERENCES Compilations(id) ON DELETE CASCADE,  -- Ссылка на сборник
    PRIMARY KEY (track_id, compilation_id)  -- Составной первичный ключ
);