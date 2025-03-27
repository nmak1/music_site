-- Удаляем старые таблицы (если они существуют)
DROP TABLE IF EXISTS TrackCompilation;
DROP TABLE IF EXISTS GenreArtist;
DROP TABLE IF EXISTS ArtistAlbum;
DROP TABLE IF EXISTS Tracks;
DROP TABLE IF EXISTS Compilations;
DROP TABLE IF EXISTS Albums;
DROP TABLE IF EXISTS Artists;
DROP TABLE IF EXISTS Genres;

-- Создаем таблицы заново с правильными ограничениями

-- Жанры
CREATE TABLE IF NOT EXISTS Genres (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- Исполнители (УБИРАЕМ genre_id, так как связь многие-ко-многим через GenreArtist)
CREATE TABLE IF NOT EXISTS Artists (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- Альбомы
CREATE TABLE IF NOT EXISTS Albums (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    year INT NOT NULL CHECK (year >= 1900),
    artist_id INT NOT NULL REFERENCES Artists(id) ON DELETE CASCADE,
    UNIQUE (title, artist_id, year)
);

-- Треки
CREATE TABLE IF NOT EXISTS Tracks (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    duration INT NOT NULL CHECK (duration > 0),
    album_id INT NOT NULL REFERENCES Albums(id) ON DELETE CASCADE
);

-- Сборники
CREATE TABLE IF NOT EXISTS Compilations (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    year INT NOT NULL CHECK (year >= 1900)
);

-- Связь многие-ко-многим между жанрами и исполнителями
CREATE TABLE IF NOT EXISTS GenreArtist (
    genre_id INT NOT NULL REFERENCES Genres(id) ON DELETE CASCADE,
    artist_id INT NOT NULL REFERENCES Artists(id) ON DELETE CASCADE,
    PRIMARY KEY (genre_id, artist_id)
);

-- Связь многие-ко-многим между треками и сборниками
CREATE TABLE IF NOT EXISTS TrackCompilation (
    track_id INT NOT NULL REFERENCES Tracks(id) ON DELETE CASCADE,
    compilation_id INT NOT NULL REFERENCES Compilations(id) ON DELETE CASCADE,
    PRIMARY KEY (track_id, compilation_id)
);


-- Очищаем таблицы
TRUNCATE TABLE TrackCompilation, GenreArtist, Tracks, Compilations, Albums, Artists, Genres RESTART IDENTITY CASCADE;

-- Заполняем жанры
INSERT INTO Genres (name) VALUES 
('Рок'), ('Поп'), ('Хип-хоп'), ('Джаз'), ('Электроника');

-- Заполняем исполнителей (БЕЗ genre_id)
INSERT INTO Artists (name) VALUES 
('Queen'), ('The Weeknd'), ('Eminem'), ('Louis Armstrong'), ('Daft Punk');

-- Заполняем альбомы
INSERT INTO Albums (title, year, artist_id) VALUES
('A Night at the Opera', 1975, 1),
('After Hours', 2020, 2),
('The Marshall Mathers LP', 2000, 3),
('What a Wonderful World', 1967, 4),
('Random Access Memories', 2013, 5);

-- Заполняем треки
INSERT INTO Tracks (title, duration, album_id) VALUES
('Bohemian Rhapsody', 354, 1),
('Love of My Life', 213, 1),
('Blinding Lights', 200, 2),
('Save Your Tears', 215, 2),
('The Real Slim Shady', 284, 3),
('Stan', 404, 3),
('What a Wonderful World', 139, 4),
('Get Lucky', 369, 5);

-- Заполняем сборники
INSERT INTO Compilations (title, year) VALUES
('Best Rock Ballads', 2018),
('Pop Hits 2020', 2020),
('Hip-Hop Classics', 2019),
('Jazz Forever', 2021),
('Electronic Dance Music', 2022);

-- Связываем треки со сборниками
INSERT INTO TrackCompilation (track_id, compilation_id) VALUES
(1, 1), (2, 1), (3, 2), (4, 2), (5, 3), (6, 3), (7, 4), (8, 5);

-- Связываем жанры с исполнителями (теперь через промежуточную таблицу)
INSERT INTO GenreArtist (genre_id, artist_id) VALUES
(1, 1),  -- Queen - Рок
(2, 2),  -- The Weeknd - Поп
(3, 3),  -- Eminem - Хип-хоп
(4, 4),  -- Louis Armstrong - Джаз
(5, 5),  -- Daft Punk - Электроника
(2, 1),  -- Queen также Поп
(5, 2);  -- The Weeknd также Электроника

SELECT 'Genres' as table, COUNT(*) FROM Genres
UNION ALL SELECT 'Artists', COUNT(*) FROM Artists
UNION ALL SELECT 'Albums', COUNT(*) FROM Albums
UNION ALL SELECT 'Tracks', COUNT(*) FROM Tracks
UNION ALL SELECT 'Compilations', COUNT(*) FROM Compilations
UNION ALL SELECT 'GenreArtist', COUNT(*) FROM GenreArtist
UNION ALL SELECT 'ArtistAlbum', COUNT(*) FROM ArtistAlbum
UNION ALL SELECT 'TrackCompilation', COUNT(*) FROM TrackCompilation;

SELECT title, duration 
FROM Tracks 
ORDER BY duration DESC 
LIMIT 1;

SELECT title 
FROM Tracks 
WHERE duration >= 210;

SELECT title 
FROM Compilations 
WHERE year BETWEEN 2018 AND 2020;

SELECT name 
FROM Artists 
WHERE name NOT LIKE '% %';

SELECT title 
FROM Tracks 
WHERE LOWER(title) LIKE '%мой%' OR LOWER(title) LIKE '%my%';

SELECT g.name AS genre, COUNT(ga.artist_id) AS artist_count
FROM Genres g
LEFT JOIN GenreArtist ga ON g.id = ga.genre_id
GROUP BY g.name
ORDER BY artist_count DESC;

SELECT COUNT(t.id) AS track_count
FROM Tracks t
JOIN Albums a ON t.album_id = a.id
WHERE a.year BETWEEN 2019 AND 2020;

SELECT a.title AS album, 
       AVG(t.duration) AS avg_duration_seconds,
       CONCAT(FLOOR(AVG(t.duration)/60), ':', LPAD(FLOOR(AVG(t.duration)%60)::text, 2, '0')) AS avg_duration_formatted
FROM Albums a
JOIN Tracks t ON a.id = t.album_id
GROUP BY a.title
ORDER BY avg_duration_seconds DESC;

SELECT DISTINCT ar.name AS artist
FROM Artists ar
WHERE ar.id NOT IN (
    SELECT aa.artist_id
    FROM ArtistAlbum aa
    JOIN Albums al ON aa.album_id = al.id
    WHERE al.year = 2020
);

SELECT DISTINCT c.title AS compilation
FROM Compilations c
JOIN TrackCompilation tc ON c.id = tc.compilation_id
JOIN Tracks t ON tc.track_id = t.id
JOIN Albums a ON t.album_id = a.id
JOIN ArtistAlbum aa ON a.id = aa.album_id
JOIN Artists ar ON aa.artist_id = ar.id
WHERE ar.name = 'Queen';

SELECT DISTINCT a.title AS album_title
FROM Albums a
JOIN Artists ar ON a.artist_id = ar.id
JOIN GenreArtist ga ON ar.id = ga.artist_id
GROUP BY a.id, a.title
HAVING COUNT(DISTINCT ga.genre_id) > 1;

SELECT t.title AS track_title
FROM Tracks t
LEFT JOIN TrackCompilation tc ON t.id = tc.track_id
WHERE tc.track_id IS NULL;

SELECT ar.name AS artist_name
FROM Artists ar
JOIN Albums a ON ar.id = a.artist_id
JOIN Tracks t ON a.id = t.album_id
WHERE t.duration = (SELECT MIN(duration) FROM Tracks);

SELECT a.title AS album_title, COUNT(t.id) AS track_count
FROM Albums a
JOIN Tracks t ON a.id = t.album_id
GROUP BY a.id, a.title
HAVING COUNT(t.id) = (
    SELECT COUNT(t2.id)
    FROM Albums a2
    JOIN Tracks t2 ON a2.id = t2.album_id
    GROUP BY a2.id
    ORDER BY COUNT(t2.id)
    LIMIT 1
);
