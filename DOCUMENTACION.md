# Documentación del Proyecto — Mundial 2026 Goleadores

## 1. Descripción General

Aplicación web de seguimiento de los jugadores con más goles en la Copa Mundial FIFA 2026.
Permite visualizar la tabla de goleadores actualizada, consultar el perfil personal de cada
jugador y ver estadísticas generales del torneo.

El proyecto fue desarrollado como ejercicio académico usando la arquitectura clásica de
tres capas con tecnologías Java EE:

```
Navegador (HTML + CSS + JavaScript)
        │  petición HTTP GET
        ▼
Servlet Java (capa lógica)
        │  consulta JDBC
        ▼
MySQL (base de datos)
        │  ResultSet
        ▼
Servlet Java (construye JSON)
        │  respuesta HTTP JSON
        ▼
Navegador (renderiza la tabla y perfiles)
```

---

## 2. Tecnologías utilizadas

| Capa | Tecnología | Versión |
|---|---|---|
| Frontend | HTML5 + CSS3 + JavaScript (Vanilla) | — |
| Backend | Java Servlets (Jakarta EE) | Jakarta Servlet 6.0 |
| Servidor | Apache Tomcat | 10.1.x |
| Base de datos | MySQL | 8.x |
| Driver JDBC | MySQL Connector/J | 8.3.0 |
| Build | Apache Maven | 3.x |
| IDE | Apache NetBeans | 23 |
| JDK | Java | 23 |

---

## 3. Estructura del Proyecto

```
C:\dev\Allan\Servlet\
│
├── pom.xml                                         Maven — dependencias y empaquetado
├── database/
│   ├── mundial2026.sql                             Script principal: crea BD, tablas, datos
│   └── update_imagenes.sql                         Script de actualización de URLs de imágenes
│
└── src/main/
    ├── java/com/mundial/
    │   ├── util/
    │   │   └── DatabaseConnection.java             Conexión JDBC centralizada
    │   └── servlets/
    │       ├── GoleadoresServlet.java               Endpoint: lista de goleadores
    │       └── JugadorDetalleServlet.java           Endpoint: perfil de un jugador
    │
    └── webapp/
        ├── index.html                              Página principal (una sola página)
        ├── style.css                               Estilos visuales
        ├── imagenes/                               Carpeta para imágenes locales (respaldo)
        └── WEB-INF/
            └── web.xml                             Descriptor de despliegue Tomcat
```

---

## 4. Base de Datos

### 4.1 Nombre de la base de datos
```
mundial2026
```
Codificación: `utf8mb4` / `utf8mb4_unicode_ci`

---

### 4.2 Tabla: `jugadores`

Almacena la información personal de cada jugador.

| Columna | Tipo | Descripción |
|---|---|---|
| `id` | INT PK AUTO_INCREMENT | Identificador único |
| `nombre` | VARCHAR(100) | Nombre del jugador |
| `apellido` | VARCHAR(100) | Apellido del jugador |
| `pais` | VARCHAR(80) | País que representa |
| `fecha_nac` | DATE | Fecha de nacimiento |
| `posicion` | VARCHAR(50) | Posición en el campo |
| `club_actual` | VARCHAR(100) | Club donde juega actualmente |
| `dorsal` | INT | Número de camiseta en el Mundial |
| `altura_cm` | INT | Altura en centímetros |
| `peso_kg` | DECIMAL(5,2) | Peso en kilogramos |
| `foto_url` | VARCHAR(255) | URL de la foto del jugador |
| `bandera_url` | VARCHAR(255) | URL de la bandera del país |
| `created_at` | TIMESTAMP | Fecha de inserción del registro |

---

### 4.3 Tabla: `estadisticas_mundial`

Almacena el rendimiento de cada jugador en el torneo.
Relacionada con `jugadores` mediante clave foránea `jugador_id`.

| Columna | Tipo | Descripción |
|---|---|---|
| `id` | INT PK AUTO_INCREMENT | Identificador único |
| `jugador_id` | INT FK | Referencia a `jugadores.id` |
| `partidos` | INT | Partidos jugados |
| `goles` | INT | Goles marcados |
| `asistencias` | INT | Asistencias de gol |
| `minutos` | INT | Minutos jugados en total |
| `tarjetas_am` | INT | Tarjetas amarillas recibidas |
| `tarjetas_ro` | INT | Tarjetas rojas recibidas |
| `tiros_puerta` | INT | Tiros a puerta realizados |

Relación:
```
jugadores (1) ──────── (N) estadisticas_mundial
              jugador_id
```

---

### 4.4 Vista: `v_goleadores`

Une ambas tablas y calcula la edad en tiempo real.
Es la fuente principal de datos que consultan los Servlets.

```sql
SELECT
    j.id,
    CONCAT(j.nombre, ' ', j.apellido) AS jugador,
    j.nombre, j.apellido, j.pais, j.club_actual,
    j.dorsal, j.altura_cm, j.peso_kg,
    j.fecha_nac, j.posicion,
    j.foto_url, j.bandera_url,
    TIMESTAMPDIFF(YEAR, j.fecha_nac, CURDATE()) AS edad,
    e.partidos, e.goles, e.asistencias, e.minutos,
    e.tarjetas_am, e.tarjetas_ro, e.tiros_puerta
FROM jugadores j
INNER JOIN estadisticas_mundial e ON j.id = e.jugador_id
ORDER BY e.goles DESC, e.asistencias DESC;
```

---

### 4.5 Jugadores registrados (datos al 8 de julio de 2026)

| ID | Jugador | País | Club | Goles | Asistencias |
|---|---|---|---|---|---|
| 1 | Lionel Messi | Argentina | Inter Miami CF | 5 | 4 |
| 2 | Cristiano Ronaldo | Portugal | Al Nassr FC | 4 | 1 |
| 3 | Kylian Mbappé | Francia | Real Madrid CF | 4 | 3 |
| 4 | Erling Haaland | Noruega | Manchester City FC | 4 | 1 |
| 5 | Vinicius Jr. | Brasil | Real Madrid CF | 3 | 4 |
| 6 | Lamine Yamal | España | FC Barcelona | 3 | 5 |
| 7 | Harry Kane | Inglaterra | Bayern München | 3 | 1 |
| 8 | Antoine Griezmann | Francia | Atlético de Madrid | 2 | 3 |
| 9 | Romelu Lukaku | Bélgica | Napoli | 2 | 0 |
| 10 | Bukayo Saka | Inglaterra | Arsenal FC | 2 | 2 |
| 11 | Pedri González | España | FC Barcelona | 1 | 4 |
| 12 | Jude Bellingham | Inglaterra | Real Madrid CF | 1 | 3 |

---

## 5. Componentes del Backend (Servlets)

### 5.1 `DatabaseConnection.java`
**Paquete:** `com.mundial.util`

Clase de utilidad con constructor privado (no se instancia). Centraliza la
conexión JDBC para que ambos Servlets no repitan la configuración.

Métodos:
- `getConnection()` → abre y retorna una conexión a MySQL
- `closeQuietly(Connection)` → cierra la conexión sin lanzar excepciones

Configuración de conexión (editable):
```java
JDBC_URL = "jdbc:mysql://localhost:3306/mundial2026"
USER     = "root"
PASSWORD = ""
```

---

### 5.2 `GoleadoresServlet.java`
**Paquete:** `com.mundial.servlets`
**URL de acceso:** `GET /GoleadoresServlet`

Consulta la vista `v_goleadores` y devuelve un array JSON con todos
los jugadores ordenados por goles de mayor a menor.

Flujo interno:
```
1. Recibe GET /GoleadoresServlet
2. Abre conexión MySQL via DatabaseConnection
3. Ejecuta: SELECT ... FROM v_goleadores ORDER BY goles DESC
4. Itera ResultSet y construye JSON manualmente (StringBuilder)
5. Escapa caracteres especiales para JSON seguro
6. Cierra conexión
7. Responde con Content-Type: application/json
```

Respuesta de ejemplo:
```json
[
  {
    "id": 1,
    "jugador": "Lionel Messi",
    "pais": "Argentina",
    "club_actual": "Inter Miami CF",
    "dorsal": 10,
    "foto_url": "https://upload.wikimedia.org/...",
    "bandera_url": "https://upload.wikimedia.org/...",
    "partidos": 5,
    "goles": 5,
    "asistencias": 4,
    "minutos": 435
  },
  ...
]
```

Manejo de errores:
- Si MySQL falla → responde HTTP 500 con `{"error": "mensaje"}`

---

### 5.3 `JugadorDetalleServlet.java`
**Paquete:** `com.mundial.servlets`
**URL de acceso:** `GET /JugadorDetalleServlet?id={numero}`

Recibe el `id` de un jugador como parámetro de URL y devuelve su
perfil completo (datos personales + estadísticas) en JSON.

Flujo interno:
```
1. Recibe GET /JugadorDetalleServlet?id=1
2. Valida que el parámetro id exista y sea numérico
3. Abre conexión MySQL via DatabaseConnection
4. Ejecuta: SELECT ... FROM v_goleadores WHERE id = ?  (PreparedStatement)
5. Si encuentra el registro → construye JSON con buildJson()
6. Si no encuentra → responde HTTP 404
7. Cierra conexión
8. Responde con Content-Type: application/json
```

Validaciones:
- `id` ausente → HTTP 400 `{"error": "Parámetro id requerido"}`
- `id` no numérico → HTTP 400 `{"error": "El parámetro id debe ser numérico"}`
- `id` no existe en BD → HTTP 404 `{"error": "Jugador no encontrado"}`
- Error de BD → HTTP 500 con mensaje del error

Respuesta de ejemplo:
```json
{
  "id": 1,
  "jugador": "Lionel Messi",
  "nombre": "Lionel",
  "apellido": "Messi",
  "pais": "Argentina",
  "club_actual": "Inter Miami CF",
  "dorsal": 10,
  "posicion": "Delantero",
  "fecha_nac": "1987-06-24",
  "edad": 39,
  "altura_cm": 170,
  "peso_kg": 72.0,
  "foto_url": "https://upload.wikimedia.org/...",
  "bandera_url": "https://upload.wikimedia.org/...",
  "partidos": 5,
  "goles": 5,
  "asistencias": 4,
  "minutos": 435,
  "tarjetas_am": 0,
  "tarjetas_ro": 0,
  "tiros_puerta": 14
}
```

---

### 5.4 `web.xml` — Configuración de Servlets

Registra los dos Servlets y sus rutas URL.
Se usa `web.xml` en lugar de anotaciones `@WebServlet` para evitar
el error de mapeo duplicado que Tomcat genera cuando detecta ambos.

```xml
GoleadoresServlet     → /GoleadoresServlet
JugadorDetalleServlet → /JugadorDetalleServlet
```

Página de bienvenida: `index.html`
Sesión: 30 minutos
Errores 404/500 redirigen a `index.html`

---

## 6. Frontend (index.html + style.css)

La interfaz es una Single Page con tres secciones navegables:

### Sección 1 — Tabla de Goleadores (`#goleadores`)
- Al cargar la página, JavaScript hace `fetch('GoleadoresServlet')`
- Si la respuesta es exitosa, renderiza la tabla con todos los jugadores
- La fila del líder (posición 1) tiene fondo dorado destacado
- Cada fila tiene un botón **"Ver Perfil"** que llama a `cargarPerfil(id)`

### Sección 2 — Perfil del Jugador (`#perfil`)
- Al hacer clic en "Ver Perfil", JavaScript hace `fetch('JugadorDetalleServlet?id=X')`
- Muestra foto, bandera, datos personales y estadísticas en una tarjeta visual
- La página hace scroll automático hacia esta sección

### Sección 3 — Estadísticas Generales (`#estadisticas`)
- Se calcula en el frontend a partir de los datos ya cargados
- Muestra: total de goles, máximo goleador, países representados, promedio de partidos

### Manejo de errores en frontend
- Si Tomcat no está corriendo → mensaje visible en la tabla con el error HTTP
- Si una foto no carga → `onerror` muestra `imagenes/default.jpg` como respaldo

---

## 7. Configuración Maven (pom.xml)

```
groupId:    com.mundial
artifactId: mundial2026-goleadores
version:    1.0.0
packaging:  war  (se despliega en Tomcat como mundial2026.war)
```

Dependencias:
- `jakarta.servlet-api 6.0.0` — scope `provided` (Tomcat lo incluye, no va en el WAR)
- `mysql-connector-j 8.3.0` — scope `runtime` (va dentro del WAR en WEB-INF/lib)

Java target: 17 (compatible con JDK 23 instalado)

---

## 8. Instrucciones de Despliegue

### Requisitos previos
- JDK 23 instalado
- Apache Tomcat 10.1 en `C:\tomcat10`
- MySQL corriendo en `localhost:3306`
- NetBeans 23

### Pasos

**1. Preparar la base de datos**
```sql
-- En MySQL Workbench o consola:
source C:/dev/Allan/Servlet/database/mundial2026.sql
source C:/dev/Allan/Servlet/database/update_imagenes.sql
```

**2. Verificar credenciales MySQL**
Editar `DatabaseConnection.java` si el usuario/contraseña son diferentes:
```java
private static final String USER     = "root";
private static final String PASSWORD = "";
```

**3. Compilar y desplegar**
- Detener Tomcat antes de compilar (evita bloqueo de archivos en Windows)
- NetBeans → clic derecho en proyecto → **Clean and Build**
- NetBeans → **Deploy** o **Run**

**4. Acceder a la aplicación**
```
http://localhost:8080/mundial2026/
```

**5. Endpoints disponibles directamente**
```
http://localhost:8080/mundial2026/GoleadoresServlet
http://localhost:8080/mundial2026/JugadorDetalleServlet?id=1
```

---

## 9. Notas importantes

- Las fotos y banderas usan URLs externas de Wikimedia Commons.
  Requieren conexión a internet para mostrarse.
- El campo `foto_url` originalmente apuntaba a `imagenes/jugador.jpg`.
  Se actualizó con `update_imagenes.sql` a URLs externas.
- Si Wikimedia cambia alguna URL, la imagen no cargará pero el resto
  de la aplicación funcionará normalmente (manejo `onerror` en HTML).
- El proyecto no implementa autenticación ni paginación.
  Es un ejercicio educativo de introducción a Servlets y JDBC.
