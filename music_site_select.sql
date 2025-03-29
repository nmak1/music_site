-- 1. Создание таблиц
DROP TABLE IF EXISTS TrackCompilation;
DROP TABLE IF EXISTS GenreArtist;
DROP TABLE IF EXISTS ArtistAlbum;
DROP TABLE IF EXISTS Tracks;
DROP TABLE IF EXISTS Compilations;
DROP TABLE IF EXISTS Albums;
DROP TABLE IF EXISTS Artists;
DROP TABLE IF EXISTS Genres;

-- Жанры
CREATE TABLE Genres (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- Исполнители
CREATE TABLE Artists (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- Альбомы
CREATE TABLE Albums (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    year INT NOT NULL CHECK (year >= 1900),
    UNIQUE (title, year)
);

-- Треки
CREATE TABLE Tracks (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    duration INT NOT NULL CHECK (duration > 0), -- в секундах
    album_id INT NOT NULL REFERENCES Albums(id) ON DELETE CASCADE
);

-- Сборники
CREATE TABLE Compilations (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    year INT NOT NULL CHECK (year >= 1900)
);

-- Связь жанры-исполнители
CREATE TABLE GenreArtist (
    genre_id INT NOT NULL REFERENCES Genres(id) ON DELETE CASCADE,
    artist_id INT NOT NULL REFERENCES Artists(id) ON DELETE CASCADE,
    PRIMARY KEY (genre_id, artist_id)
);

-- Связь исполнители-альбомы
CREATE TABLE ArtistAlbum (
    artist_id INT NOT NULL REFERENCES Artists(id) ON DELETE CASCADE,
    album_id INT NOT NULL REFERENCES Albums(id) ON DELETE CASCADE,
    PRIMARY KEY (artist_id, album_id)
);

-- Связь треки-сборники
CREATE TABLE TrackCompilation (
    track_id INT NOT NULL REFERENCES Tracks(id) ON DELETE CASCADE,
    compilation_id INT NOT NULL REFERENCES Compilations(id) ON DELETE CASCADE,
    PRIMARY KEY (track_id, compilation_id)
);

-- 2. Заполнение данными
-- Жанры
INSERT INTO Genres (name) VALUES 
('Рок'), ('Поп'), ('Хип-хоп'), ('Джаз'), ('Электроника'),
('Классика'), ('Метал'), ('Рэп'), ('Фолк'), ('Диско');

-- Исполнители
INSERT INTO Artists (name) VALUES
('Queen'), ('The Beatles'), ('Eminem'), 
('Louis Armstrong'), ('Daft Punk'),
('Muse'), ('Lady Gaga'), ('Hans Zimmer'),
('Imagine Dragons'), ('Rammstein');

-- Альбомы
INSERT INTO Albums (title, year) VALUES
('A Night at the Opera', 1975),
('Abbey Road', 1969),
('The Marshall Mathers LP', 2000),
('What a Wonderful World', 1967),
('Random Access Memories', 2013),
('Origin of Symmetry', 2001),
('The Fame', 2008),
('Inception OST', 2010),
('Evolve', 2017),
('Mutter', 2001);

-- Связи исполнителей с альбомами в ваших данных:
INSERT INTO ArtistAlbum (artist_id, album_id) VALUES
(1, 1), -- Queen
(2, 2), -- The Beatles
(3, 3), -- Eminem
(4, 4), -- Louis Armstrong
(5, 5), -- Daft Punk
(6, 6), -- Muse
(7, 7), -- Lady Gaga
(8, 8), -- Hans Zimmer
(9, 9), -- Imagine Dragons
(10, 10), -- Rammstein
(1, 2), -- Queen (второй альбом)
(7, 5); -- Lady Gaga (второй альбом)

-- Треки
INSERT INTO Tracks (title, duration, album_id) VALUES
-- Альбом 1
('Bohemian Rhapsody', 354, 1),
('Love of My Life', 213, 1),
('You''re My Best Friend', 170, 1),
-- Альбом 2
('Come Together', 259, 2),
('Something', 182, 2),
('Here Comes the Sun', 185, 2),
-- Альбом 3
('The Real Slim Shady', 284, 3),
('Stan', 404, 3),
('The Way I Am', 290, 3),
-- Альбом 4
('What a Wonderful World', 139, 4),
('Hello, Dolly!', 150, 4),
-- Альбом 5
('Get Lucky', 369, 5),
('Lose Yourself to Dance', 353, 5),
-- Альбом 6
('New Born', 360, 6),
('Plug In Baby', 220, 6),
-- Альбом 7
('Just Dance', 240, 7),
('Poker Face', 237, 7),
-- Альбом 8
('Time', 287, 8),
('Dream Is Collapsing', 145, 8),
-- Альбом 9
('Believer', 204, 9),
('Thunder', 187, 9),
-- Альбом 10
('Sonne', 272, 10),
('Ich will', 217, 10);

-- Сборники
INSERT INTO Compilations (title, year) VALUES
('Best Rock Ballads', 2018),
('Pop Hits Collection', 2020),
('Hip-Hop Classics', 2019),
('Jazz Forever', 2021),
('Electronic Dance Anthems', 2022),
('Film Soundtracks', 2020),
('Metal Essentials', 2019),
('Greatest Hits of 2000s', 2021),
('Legendary Collaborations', 2022),
('International Superhits', 2023);

-- Связи треков со сборниками
INSERT INTO TrackCompilation (track_id, compilation_id) VALUES
(1, 1), (2, 1), (4, 1),   -- Rock Ballads
(6, 2), (16, 2), (17, 2),  -- Pop Hits
(7, 3), (8, 3),            -- Hip-Hop
(9, 4), (10, 4),           -- Jazz
(11, 5), (12, 5),          -- Electronic
(19, 6), (20, 6),          -- Film
(21, 7), (22, 7),          -- Metal
(3, 8), (5, 8), (13, 8),   -- 2000s
(1, 9), (4, 9), (11, 9),   -- Collaborations
(1, 10), (4, 10), (7, 10), (9, 10), (11, 10); -- International

-- Связи жанров с исполнителями
INSERT INTO GenreArtist (genre_id, artist_id) VALUES
(1, 1),   -- Рок - Queen
(1, 2),   -- Рок - The Beatles
(2, 2),   -- Поп - The Beatles
(2, 7),   -- Поп - Lady Gaga
(3, 3),   -- Хип-хоп - Eminem
(4, 4),   -- Джаз - Louis Armstrong
(5, 5),   -- Электроника - Daft Punk
(1, 6),   -- Рок - Muse
(2, 9),   -- Поп - Imagine Dragons
(7, 10);  -- Метал - Rammstein

INSERT INTO Tracks (title, duration, album_id) VALUES
('my own', 180, 1),
('own my', 180, 1),
('my', 180, 1),
('oh my god', 180, 1),
('myself', 180, 1),
('by myself', 180, 1),
('bemy self', 180, 1),
('myself by', 180, 1),
('by myself by', 180, 1),
('beemy', 180, 1),
('premyne', 180, 1),
('мой мир', 180, 1),
('в моем сердце', 180, 1),
('мой', 180, 1),
('самомойка', 180, 1),
('помой', 180, 1);

-- Проверка количества записей в каждой таблице
SELECT 'Genres' as table, COUNT(*) FROM Genres
UNION SELECT 'Artists', COUNT(*) FROM Artists
UNION SELECT 'Albums', COUNT(*) FROM Albums
UNION SELECT 'Tracks', COUNT(*) FROM Tracks
UNION SELECT 'Compilations', COUNT(*) FROM Compilations
UNION SELECT 'GenreArtist', COUNT(*) FROM GenreArtist
UNION SELECT 'ArtistAlbum', COUNT(*) FROM ArtistAlbum
UNION SELECT 'TrackCompilation', COUNT(*) FROM TrackCompilation;

-- Проверка связей многие-ко-многим
SELECT a.name AS artist, COUNT(DISTINCT al.id) AS albums_count
FROM Artists a
LEFT JOIN ArtistAlbum aa ON a.id = aa.artist_id
LEFT JOIN Albums al ON aa.album_id = al.id
GROUP BY a.id, a.name
ORDER BY albums_count DESC;

SELECT g.name AS genre, COUNT(DISTINCT a.name) AS artists_count
FROM Genres g
JOIN GenreArtist ga ON g.id = ga.genre_id
JOIN Artists a ON ga.artist_id = a.id
GROUP BY g.id, g.name
ORDER BY artists_count DESC;

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
WHERE 
    title ~* '\m(my|мой)\M';

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
JOIN ArtistAlbum aa ON a.id = aa.album_id
JOIN Artists ar ON aa.artist_id = ar.id
JOIN GenreArtist ga ON ar.id = ga.artist_id
GROUP BY a.id, a.title, aa.artist_id
HAVING COUNT(DISTINCT ga.genre_id) > 1;

SELECT t.title AS track_title
FROM Tracks t
LEFT JOIN TrackCompilation tc ON t.id = tc.track_id
WHERE tc.track_id IS NULL;

SELECT ar.name AS artist_name
FROM Artists ar
JOIN ArtistAlbum aa ON ar.id = aa.artist_id
JOIN Tracks t ON aa.album_id = t.album_id
WHERE t.duration = (SELECT MIN(duration) FROM Tracks);

SELECT a.title AS album_title, COUNT(t.id) AS track_count
FROM Albums a
LEFT JOIN Tracks t ON a.id = t.album_id
GROUP BY a.id, a.title
HAVING COUNT(t.id) = (
    SELECT COUNT(t2.id)
    FROM Albums a2
    LEFT JOIN Tracks t2 ON a2.id = t2.album_id
    GROUP BY a2.id
    ORDER BY COUNT(t2.id)
    LIMIT 1
);

