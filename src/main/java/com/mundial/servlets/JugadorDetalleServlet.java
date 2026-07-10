package com.mundial.servlets;

import com.mundial.util.DatabaseConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * JugadorDetalleServlet
 *
 * Responde GET /JugadorDetalleServlet?id={id} con el perfil
 * completo de un jugador (datos personales + estadísticas) en JSON.
 * Mapping registrado en web.xml (sin @WebServlet para evitar
 * conflicto de mapeo doble con Tomcat).
 *
 * Parámetro requerido:
 *   id  — identificador numérico del jugador
 *
 * Ejemplo de respuesta:
 * {
 *   "id": 1,
 *   "jugador": "Lionel Messi",
 *   "pais": "Argentina",
 *   "club_actual": "Inter Miami CF",
 *   "dorsal": 10,
 *   "posicion": "Delantero",
 *   "fecha_nac": "1987-06-24",
 *   "edad": 39,
 *   "altura_cm": 170,
 *   "peso_kg": 72.0,
 *   "foto_url": "imagenes/messi.jpg",
 *   "bandera_url": "imagenes/arg.png",
 *   "partidos": 5,
 *   "goles": 5,
 *   "asistencias": 4,
 *   "minutos": 435,
 *   "tarjetas_am": 0,
 *   "tarjetas_ro": 0,
 *   "tiros_puerta": 14
 * }
 */
public class JugadorDetalleServlet extends HttpServlet {

    private static final String SQL =
        "SELECT id, jugador, nombre, apellido, pais, club_actual, dorsal, posicion, " +
        "       DATE_FORMAT(fecha_nac, '%Y-%m-%d') AS fecha_nac, edad, " +
        "       altura_cm, peso_kg, foto_url, bandera_url, " +
        "       partidos, goles, asistencias, minutos, " +
        "       tarjetas_am, tarjetas_ro, tiros_puerta " +
        "FROM v_goleadores " +
        "WHERE id = ?";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Validar parámetro id
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isBlank()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"error\":\"Parámetro id requerido\"}");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idParam.trim());
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"error\":\"El parámetro id debe ser numérico\"}");
            return;
        }

        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(SQL);
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String json = buildJson(rs);
                response.getWriter().print(json);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().print("{\"error\":\"Jugador no encontrado\"}");
            }

            rs.close();
            stmt.close();

        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("{\"error\":\"" + escapar(e.getMessage()) + "\"}");
        } finally {
            DatabaseConnection.closeQuietly(conn);
        }
    }

    /**
     * Construye el JSON del jugador a partir del ResultSet.
     */
    private String buildJson(ResultSet rs) throws SQLException {
        return "{"
            + "\"id\":"          + rs.getInt("id")                               + ","
            + "\"jugador\":\""   + escapar(rs.getString("jugador"))               + "\","
            + "\"nombre\":\""    + escapar(rs.getString("nombre"))                + "\","
            + "\"apellido\":\""  + escapar(rs.getString("apellido"))              + "\","
            + "\"pais\":\""      + escapar(rs.getString("pais"))                  + "\","
            + "\"club_actual\":\"" + escapar(rs.getString("club_actual"))         + "\","
            + "\"dorsal\":"      + rs.getInt("dorsal")                            + ","
            + "\"posicion\":\""  + escapar(rs.getString("posicion"))              + "\","
            + "\"fecha_nac\":\"" + escapar(rs.getString("fecha_nac"))             + "\","
            + "\"edad\":"        + rs.getInt("edad")                              + ","
            + "\"altura_cm\":"   + rs.getInt("altura_cm")                         + ","
            + "\"peso_kg\":"     + rs.getDouble("peso_kg")                        + ","
            + "\"foto_url\":\""  + escapar(rs.getString("foto_url"))              + "\","
            + "\"bandera_url\":\"" + escapar(rs.getString("bandera_url"))         + "\","
            + "\"partidos\":"    + rs.getInt("partidos")                          + ","
            + "\"goles\":"       + rs.getInt("goles")                             + ","
            + "\"asistencias\":" + rs.getInt("asistencias")                       + ","
            + "\"minutos\":"     + rs.getInt("minutos")                           + ","
            + "\"tarjetas_am\":" + rs.getInt("tarjetas_am")                       + ","
            + "\"tarjetas_ro\":" + rs.getInt("tarjetas_ro")                       + ","
            + "\"tiros_puerta\":" + rs.getInt("tiros_puerta")
            + "}";
    }

    /**
     * Escapa caracteres especiales para JSON seguro.
     */
    private String escapar(String texto) {
        if (texto == null) return "";
        return texto
            .replace("\\", "\\\\")
            .replace("\"", "\\\"")
            .replace("\n", "\\n")
            .replace("\r", "\\r")
            .replace("\t", "\\t");
    }
}
