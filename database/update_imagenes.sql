-- ============================================================
--  MUNDIAL 2026 - Actualización de Imágenes (URLs Externas)
--  Archivo: update_imagenes.sql
--  Descripción: Actualiza foto_url y bandera_url usando IDs
--               directos para evitar problemas de codificación.
--               Las URLs apuntan a Wikimedia Commons (libre uso).
-- ============================================================

USE mundial2026;

-- ------------------------------------------------------------
-- FOTOS DE JUGADORES  (actualizadas por ID)
-- id 1  = Lionel Messi
-- id 2  = Cristiano Ronaldo
-- id 3  = Kylian Mbappe
-- id 4  = Erling Haaland
-- id 5  = Vinicius Jr.
-- id 6  = Lamine Yamal
-- id 7  = Harry Kane
-- id 8  = Antoine Griezmann
-- id 9  = Romelu Lukaku
-- id 10 = Bukayo Saka
-- id 11 = Pedri Gonzalez
-- id 12 = Jude Bellingham
-- ------------------------------------------------------------

UPDATE jugadores SET foto_url = 'C:\dev\Allan\Servlet\src\main\webapp\imagenes\messi1.jpg' WHERE id = 1;

UPDATE jugadores SET foto_url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d7/Cristiano_Ronaldo_2275_%28cropped%29.jpg/440px-Cristiano_Ronaldo_2275_%28cropped%29.jpg' WHERE id = 2;

UPDATE jugadores SET foto_url = 'C:\dev\Allan\Servlet\src\main\webapp\imagenes\mbappe.jpg' WHERE id = 3;

UPDATE jugadores SET foto_url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/Erling_Haaland_2024_%28cropped%29.jpg/440px-Erling_Haaland_2024_%28cropped%29.jpg' WHERE id = 4;

UPDATE jugadores SET foto_url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f2/Vinicius_Junior_2023.jpg/440px-Vinicius_Junior_2023.jpg' WHERE id = 5;

UPDATE jugadores SET foto_url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/Lamine_Yamal_2024.jpg/440px-Lamine_Yamal_2024.jpg' WHERE id = 6;

UPDATE jugadores SET foto_url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/ce/Harry_Kane_2023.jpg/440px-Harry_Kane_2023.jpg' WHERE id = 7;

UPDATE jugadores SET foto_url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f7/Antoine_Griezmann_2022.jpg/440px-Antoine_Griezmann_2022.jpg' WHERE id = 8;

UPDATE jugadores SET foto_url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/67/Romelu_Lukaku_2022.jpg/440px-Romelu_Lukaku_2022.jpg' WHERE id = 9;

UPDATE jugadores SET foto_url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/96/Bukayo_Saka_2022.jpg/440px-Bukayo_Saka_2022.jpg' WHERE id = 10;

UPDATE jugadores SET foto_url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/68/Pedri_2023.jpg/440px-Pedri_2023.jpg' WHERE id = 11;

UPDATE jugadores SET foto_url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0e/Jude_Bellingham_2024.jpg/440px-Jude_Bellingham_2024.jpg' WHERE id = 12;

-- ------------------------------------------------------------
-- BANDERAS (actualizadas por ID de jugador)
-- Fuente: Wikimedia Commons SVG → PNG renderizado
-- ------------------------------------------------------------

-- Argentina (id 1)
UPDATE jugadores SET bandera_url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/Flag_of_Argentina.svg/40px-Flag_of_Argentina.svg.png' WHERE id = 1;

-- Portugal (id 2)
UPDATE jugadores SET bandera_url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5c/Flag_of_Portugal.svg/40px-Flag_of_Portugal.svg.png' WHERE id = 2;

-- Francia (id 3 y 8)
UPDATE jugadores SET bandera_url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c3/Flag_of_France.svg/40px-Flag_of_France.svg.png' WHERE id IN (3, 8);

-- Noruega (id 4)
UPDATE jugadores SET bandera_url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Flag_of_Norway.svg/40px-Flag_of_Norway.svg.png' WHERE id = 4;

-- Brasil (id 5)
UPDATE jugadores SET bandera_url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Flag_of_Brazil.svg/40px-Flag_of_Brazil.svg.png' WHERE id = 5;

-- España (id 6 y 11)
UPDATE jugadores SET bandera_url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/Flag_of_Spain.svg/40px-Flag_of_Spain.svg.png' WHERE id IN (6, 11);

-- Inglaterra (id 7, 10 y 12)
UPDATE jugadores SET bandera_url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/be/Flag_of_England.svg/40px-Flag_of_England.svg.png' WHERE id IN (7, 10, 12);

-- Belgica (id 9)
UPDATE jugadores SET bandera_url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Belgium.svg/40px-Flag_of_Belgium.svg.png' WHERE id = 9;

-- ------------------------------------------------------------
-- Verificacion final
-- ------------------------------------------------------------
SELECT id, nombre, apellido, foto_url, bandera_url
FROM jugadores
ORDER BY id;
