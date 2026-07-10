-- ============================================================
--  MUNDIAL 2026 - Base de Datos Goleadores
--  Archivo: mundial2026_postgres.sql
--  Descripción: Script para PostgreSQL (Render)
-- ============================================================

-- Limpiar tablas anteriores si existen
DROP VIEW IF EXISTS v_goleadores;
DROP TABLE IF EXISTS estadisticas_mundial;
DROP TABLE IF EXISTS jugadores;

-- ------------------------------------------------------------
-- TABLA: jugadores
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS jugadores (
    id            SERIAL          PRIMARY KEY,
    nombre        VARCHAR(100)    NOT NULL,
    apellido      VARCHAR(100)    NOT NULL,
    pais          VARCHAR(80)     NOT NULL,
    fecha_nac     DATE            NOT NULL,
    posicion      VARCHAR(50)     NOT NULL,
    club_actual   VARCHAR(100)    NOT NULL,
    dorsal        INT             NOT NULL,
    altura_cm     INT,
    peso_kg       NUMERIC(5,2),
    foto_url      VARCHAR(500)    DEFAULT 'imagenes/default.jpg',
    bandera_url   VARCHAR(500),
    created_at    TIMESTAMPTZ     DEFAULT NOW()
);

-- ------------------------------------------------------------
-- TABLA: estadisticas_mundial
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS estadisticas_mundial (
    id              SERIAL      PRIMARY KEY,
    jugador_id      INT         NOT NULL,
    partidos        INT         DEFAULT 0,
    goles           INT         DEFAULT 0,
    asistencias     INT         DEFAULT 0,
    minutos         INT         DEFAULT 0,
    tarjetas_am     INT         DEFAULT 0,
    tarjetas_ro     INT         DEFAULT 0,
    tiros_puerta    INT         DEFAULT 0,
    FOREIGN KEY (jugador_id) REFERENCES jugadores(id) ON DELETE CASCADE
);

-- ------------------------------------------------------------
-- INSERTS: Jugadores
-- Datos al 8 de julio de 2026 — fotos vía Wikimedia Commons
-- ------------------------------------------------------------
INSERT INTO jugadores (nombre, apellido, pais, fecha_nac, posicion, club_actual, dorsal, altura_cm, peso_kg, foto_url, bandera_url) VALUES
('Lionel',    'Messi',       'Argentina',  '1987-06-24', 'Extremo Derecho',    'Inter Miami CF',      10, 170, 72.00,
 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b4/Lionel-Messi-Argentina-2022-FIFA-World-Cup_%28cropped%29.jpg/440px-Lionel-Messi-Argentina-2022-FIFA-World-Cup_%28cropped%29.jpg',
 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/Flag_of_Argentina.svg/40px-Flag_of_Argentina.svg.png'),

('Cristiano', 'Ronaldo',     'Portugal',   '1985-02-05', 'Delantero',          'Al Nassr FC',          7, 187, 83.00,
 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d7/Cristiano_Ronaldo_2275_%28cropped%29.jpg/440px-Cristiano_Ronaldo_2275_%28cropped%29.jpg',
 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5c/Flag_of_Portugal.svg/40px-Flag_of_Portugal.svg.png'),

('Kylian',    'Mbappé',      'Francia',    '1998-12-20', 'Delantero',          'Real Madrid CF',       9, 178, 73.00,
 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/2019-07-17_SG_Dynamo_Dresden_vs_Paris_Saint-Germain_by_Sandro_Halank%E2%80%93049_%28cropped%29.jpg/440px-2019-07-17_SG_Dynamo_Dresden_vs_Paris_Saint-Germain_by_Sandro_Halank%E2%80%93049_%28cropped%29.jpg',
 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c3/Flag_of_France.svg/40px-Flag_of_France.svg.png'),

('Erling',    'Haaland',     'Noruega',    '2000-07-21', 'Delantero',          'Manchester City FC',   9, 194, 88.00,
 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/Erling_Haaland_2024_%28cropped%29.jpg/440px-Erling_Haaland_2024_%28cropped%29.jpg',
 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Flag_of_Norway.svg/40px-Flag_of_Norway.svg.png'),

('Vinicius',  'Jr.',         'Brasil',     '2000-07-12', 'Delantero',          'Real Madrid CF',       7, 176, 73.00,
 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f2/Vinicius_Junior_2023.jpg/440px-Vinicius_Junior_2023.jpg',
 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Flag_of_Brazil.svg/40px-Flag_of_Brazil.svg.png'),

('Lamine',    'Yamal',       'España',     '2007-07-13', 'Delantero',          'FC Barcelona',        19, 180, 67.00,
 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/Lamine_Yamal_2024.jpg/440px-Lamine_Yamal_2024.jpg',
 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/Flag_of_Spain.svg/40px-Flag_of_Spain.svg.png'),

('Harry',     'Kane',        'Inglaterra', '1993-07-28', 'Delantero',          'Bayern München',       9, 188, 86.00,
 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/ce/Harry_Kane_2023.jpg/440px-Harry_Kane_2023.jpg',
 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/be/Flag_of_England.svg/40px-Flag_of_England.svg.png'),

('Antoine',   'Griezmann',   'Francia',    '1991-03-21', 'Delantero',          'Atlético de Madrid',  11, 176, 73.00,
 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f7/Antoine_Griezmann_2022.jpg/440px-Antoine_Griezmann_2022.jpg',
 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c3/Flag_of_France.svg/40px-Flag_of_France.svg.png'),

('Romelu',    'Lukaku',      'Bélgica',    '1993-05-13', 'Delantero',          'Napoli',               9, 190, 94.00,
 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/67/Romelu_Lukaku_2022.jpg/440px-Romelu_Lukaku_2022.jpg',
 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Belgium.svg/40px-Flag_of_Belgium.svg.png'),

('Bukayo',    'Saka',        'Inglaterra', '2001-09-05', 'Extremo',            'Arsenal FC',           7, 178, 72.00,
 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/96/Bukayo_Saka_2022.jpg/440px-Bukayo_Saka_2022.jpg',
 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/be/Flag_of_England.svg/40px-Flag_of_England.svg.png'),

('Pedri',     'González',    'España',     '2002-11-25', 'Centrocampista',     'FC Barcelona',         8, 174, 60.00,
 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/68/Pedri_2023.jpg/440px-Pedri_2023.jpg',
 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/Flag_of_Spain.svg/40px-Flag_of_Spain.svg.png'),

('Jude',      'Bellingham',  'Inglaterra', '2003-06-29', 'Centrocampista',     'Real Madrid CF',      10, 186, 83.00,
 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0e/Jude_Bellingham_2024.jpg/440px-Jude_Bellingham_2024.jpg',
 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/be/Flag_of_England.svg/40px-Flag_of_England.svg.png');

-- ------------------------------------------------------------
-- INSERTS: Estadísticas del Mundial 2026 (datos finales)
-- ------------------------------------------------------------
INSERT INTO estadisticas_mundial (jugador_id, partidos, goles, asistencias, minutos, tarjetas_am, tarjetas_ro, tiros_puerta) VALUES
(1,  5, 8, 1, 468, 0, 0, 18),   -- Messi
(2,  5, 4, 1, 450, 1, 0, 12),   -- Ronaldo
(3,  5, 8, 3, 563, 1, 0, 19),   -- Mbappé
(4,  4, 7, 1, 416, 0, 0, 15),   -- Haaland
(5,  5, 3, 4, 435, 0, 0, 10),   -- Vinicius Jr.
(6,  5, 3, 5, 450, 0, 0, 11),   -- Yamal
(7,  4, 3, 1, 360, 0, 0,  9),   -- Kane
(8,  5, 2, 3, 450, 1, 0,  7),   -- Griezmann
(9,  4, 2, 0, 360, 1, 0,  8),   -- Lukaku
(10, 5, 2, 2, 450, 0, 0,  9),   -- Saka
(11, 5, 1, 4, 450, 0, 0,  5),   -- Pedri
(12, 5, 1, 3, 450, 1, 0,  6);   -- Bellingham

-- ------------------------------------------------------------
-- VISTA: v_goleadores
-- Nota PostgreSQL: AGE() + DATE_PART() en lugar de TIMESTAMPDIFF
--                  || en lugar de CONCAT()
--                  CURRENT_DATE en lugar de CURDATE()
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW v_goleadores AS
SELECT
    j.id,
    j.nombre || ' ' || j.apellido          AS jugador,
    j.nombre,
    j.apellido,
    j.pais,
    j.club_actual,
    j.dorsal,
    j.altura_cm,
    j.peso_kg,
    j.fecha_nac,
    j.posicion,
    j.foto_url,
    j.bandera_url,
    DATE_PART('year', AGE(CURRENT_DATE, j.fecha_nac))::INT  AS edad,
    e.partidos,
    e.goles,
    e.asistencias,
    e.minutos,
    e.tarjetas_am,
    e.tarjetas_ro,
    e.tiros_puerta
FROM jugadores j
INNER JOIN estadisticas_mundial e ON j.id = e.jugador_id
ORDER BY e.goles DESC, e.asistencias DESC;

-- ------------------------------------------------------------
-- Verificación final
-- ------------------------------------------------------------
SELECT * FROM v_goleadores;
