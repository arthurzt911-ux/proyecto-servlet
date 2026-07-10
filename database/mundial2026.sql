-- ============================================================
--  MUNDIAL 2026 - Base de Datos Goleadores
--  Archivo: mundial2026.sql
--  Descripción: Script de creación e inserción de datos para
--               el seguimiento de goleadores del Mundial 2026
-- ============================================================

CREATE DATABASE IF NOT EXISTS mundial2026
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE mundial2026;

-- ------------------------------------------------------------
-- TABLA: jugadores
-- Información personal de cada jugador
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS jugadores (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    nombre        VARCHAR(100)  NOT NULL,
    apellido      VARCHAR(100)  NOT NULL,
    pais          VARCHAR(80)   NOT NULL,
    fecha_nac     DATE          NOT NULL,
    posicion      VARCHAR(50)   NOT NULL,
    club_actual   VARCHAR(100)  NOT NULL,
    dorsal        INT           NOT NULL,
    altura_cm     INT,
    peso_kg       DECIMAL(5,2),
    foto_url      VARCHAR(255)  DEFAULT 'imagenes/default.jpg',
    bandera_url   VARCHAR(255),
    created_at    TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- TABLA: estadisticas_mundial
-- Rendimiento de cada jugador en el Mundial 2026
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS estadisticas_mundial (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    jugador_id      INT          NOT NULL,
    partidos        INT          DEFAULT 0,
    goles           INT          DEFAULT 0,
    asistencias     INT          DEFAULT 0,
    tarjetas_am     INT          DEFAULT 0,
    tarjetas_ro     INT          DEFAULT 0,
    tiros_puerta    INT          DEFAULT 0,
    FOREIGN KEY (jugador_id) REFERENCES jugadores(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- INSERTS: Jugadores (Top Goleadores Mundial 2026 - Fase de Grupos + Octavos)
-- Datos basados en estadísticas al 8 de julio de 2026
-- ------------------------------------------------------------
INSERT INTO jugadores (nombre, apellido, pais, fecha_nac, posicion, club_actual, dorsal, altura_cm, peso_kg, foto_url, bandera_url) VALUES
('Lionel',      'Messi',         'Argentina',   '1987-06-24', 'Extremo Derecho',  'Inter Miami CF',   10, 170, 72.00, 'imagenes/messi1.jpg',      'imagenes/arg.png'),
('Cristiano',   'Ronaldo',       'Portugal',    '1985-02-05', 'Delantero',  'Al Nassr FC',            7, 187, 83.00, 'imagenes/ronaldo.jpg',    'imagenes/por.png'),
('Kylian',      'Mbappé',        'Francia',     '1998-12-20', 'Delantero',  'Real Madrid CF',         9, 178, 73.00, 'imagenes/mbappe.jpg',     'imagenes/fra.png'),
('Erling',      'Haaland',       'Noruega',     '2000-07-21', 'Delantero',  'Manchester City FC',     9, 194, 88.00, 'imagenes/haaland.jpg',    'imagenes/nor.png'),
('Vinicius',    'Jr.',           'Brasil',      '2000-07-12', 'Delantero',  'Real Madrid CF',         7, 176, 73.00, 'imagenes/vinicius.jpg',   'imagenes/bra.png'),
('Lamine',      'Yamal',         'España',      '2007-07-13', 'Delantero',  'FC Barcelona',          19, 180, 67.00, 'imagenes/yamal.jpg',      'imagenes/esp.png'),
('Harry',       'Kane',          'Inglaterra',  '1993-07-28', 'Delantero',  'Bayern München',         9, 188, 86.00, 'imagenes/kane.jpg',       'imagenes/eng.png'),
('Antoine',     'Griezmann',     'Francia',     '1991-03-21', 'Delantero',  'Atlético de Madrid',    11, 176, 73.00, 'imagenes/griezmann.jpg',  'imagenes/fra.png'),
('Romelu',      'Lukaku',        'Bélgica',     '1993-05-13', 'Delantero',  'Napoli',                 9, 190, 94.00, 'imagenes/lukaku.jpg',     'imagenes/bel.png'),
('Bukayo',      'Saka',          'Inglaterra',  '2001-09-05', 'Extremo',    'Arsenal FC',             7, 178, 72.00, 'imagenes/saka.jpg',       'imagenes/eng.png'),
('Pedri',       'González',      'España',      '2002-11-25', 'Centrocampista', 'FC Barcelona',       8, 174, 60.00, 'imagenes/pedri.jpg',     'imagenes/esp.png'),
('Jude',        'Bellingham',    'Inglaterra',  '2003-06-29', 'Centrocampista', 'Real Madrid CF',     10, 186, 83.00, 'imagenes/bellingham.jpg', 'imagenes/eng.png');

-- ------------------------------------------------------------
-- INSERTS: Estadísticas del Mundial 2026
-- (jugador_id, partidos, goles, asistencias, minutos, tj_am, tj_ro, tiros)
-- ------------------------------------------------------------
INSERT INTO estadisticas_mundial (jugador_id, partidos, goles, asistencias, tarjetas_am, tarjetas_ro, tiros_puerta) VALUES
(1,  5, 8, 1, 0, 0, 14),   -- Messi
(2,  5, 4, 1, 1, 0, 12),   -- Ronaldo
(3,  5, 4, 3, 1, 0, 16),   -- Mbappé
(4,  4, 4, 1, 0, 0, 13),   -- Haaland
(5,  5, 3, 4, 0, 0, 10),   -- Vinicius Jr.
(6,  5, 3, 5, 0, 0, 11),   -- Yamal
(7,  4, 3, 1, 0, 0,  9),   -- Kane
(8,  5, 2, 3, 1, 0,  7),   -- Griezmann
(9,  4, 2, 0, 1, 0,  8),   -- Lukaku
(10, 5, 2, 2, 0, 0,  9),   -- Saka
(11, 5, 1, 4, 0, 0,  5),   -- Pedri
(12, 5, 1, 3, 1, 0,  6);   -- Bellingham

-- ------------------------------------------------------------
-- VISTA: v_goleadores
-- Combina jugadores + estadísticas ordenado por goles DESC
-- ------------------------------------------------------------
CREATE OR REPLACE VIEW v_goleadores AS
SELECT
    j.id,
    CONCAT(j.nombre, ' ', j.apellido)  AS jugador,
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
    TIMESTAMPDIFF(YEAR, j.fecha_nac, CURDATE()) AS edad,
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

-- Verificación
SELECT * FROM v_goleadores;

INSERT INTO estadisticas_mundial (jugador_id, partidos, goles, asistencias, minutos, tarjetas_am, tarjetas_ro, tiros_puerta) VALUES
(1,  5, 8, 1, 468, 0, 0, 18),   -- Messi
(4,  4, 7, 1, 416, 0, 0, 15),   -- Haaland
(3,  5, 8, 3, 563, 1, 0, 19),   -- Mbappe






