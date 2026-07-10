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
 * GoleadoresServlet
 *
 * Responde GET /GoleadoresServlet con la lista de goleadores
 * del Mundial 2026 ordenada por goles DESC, en formato JSON.
 * Mapping registrado en web.xml (sin @WebServlet para evitar
 * conflicto de mapeo doble con Tomcat).
 *
 * Ejemplo de respuesta:
 * [
 *   {
 *     "id": 1,
 *     "jugador": "Lionel Messi",
 *     "nombre": "Lionel",
 *     "apellido": "Messi",
 *     "pais": "Argentina",
 *     "club_actual": "Inter Miami CF",
 *     "dorsal": 10,
 *     "foto_url": "https://...",
 *     "bandera_url": "https://...",
 *     "partidos": 5,
 *     "goles": 5,
 *     "asistencias": 4,
 *     "minutos": 435
 *   }, ...
 * ]
 */
public class GoleadoresServlet extends HttpServlet {

    private static final String SQL =
        "SELECT j.id, j.nombre || ' ' || j.apellido AS jugador, " +
        "j.nombre, j.apellido, j.pais, j.club_actual, j.dorsal, " +
        "j.foto_url, j.bandera_url, " +
        "e.partidos, e.goles, e.asistencias, e.minutos " +
        "FROM jugadores j " +
        "INNER JOIN estadisticas_mundial e ON j.id = e.jugador_id " +
        "ORDER BY e.goles DESC, e.asistencias DESC";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Permitir llamadas AJAX desde el mismo origen
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        StringBuilder json = new StringBuilder("[");
        Connection conn = null;

        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(SQL);
            ResultSet rs = stmt.executeQuery();

            boolean primero = true;
            while (rs.next()) {
                if (!primero) json.append(",");
                primero = false;

                json.append("{")
                    .append("\"id\":").append(rs.getInt("id")).append(",")
                    .append("\"jugador\":\"").append(escapar(rs.getString("jugador"))).append("\",")
                    .append("\"nombre\":\"").append(escapar(rs.getString("nombre"))).append("\",")
                    .append("\"apellido\":\"").append(escapar(rs.getString("apellido"))).append("\",")
                    .append("\"pais\":\"").append(escapar(rs.getString("pais"))).append("\",")
                    .append("\"club_actual\":\"").append(escapar(rs.getString("club_actual"))).append("\",")
                    .append("\"dorsal\":").append(rs.getInt("dorsal")).append(",")
                    .append("\"foto_url\":\"").append(escapar(rs.getString("foto_url"))).append("\",")
                    .append("\"bandera_url\":\"").append(escapar(rs.getString("bandera_url"))).append("\",")
                    .append("\"partidos\":").append(rs.getInt("partidos")).append(",")
                    .append("\"goles\":").append(rs.getInt("goles")).append(",")
                    .append("\"asistencias\":").append(rs.getInt("asistencias")).append(",")
                    .append("\"minutos\":").append(rs.getInt("minutos"))
                    .append("}");
            }

            rs.close();
            stmt.close();

        } catch (SQLException e) {
            // Devolvemos JSON de error para que el frontend lo muestre
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            PrintWriter out = response.getWriter();
            out.print("{\"error\":\"" + escapar(e.getMessage()) + "\"}");
            return;
        } finally {
            DatabaseConnection.closeQuietly(conn);
        }

        json.append("]");
        PrintWriter out = response.getWriter();
        out.print(json.toString());
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