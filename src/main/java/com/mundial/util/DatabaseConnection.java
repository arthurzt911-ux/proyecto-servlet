package com.mundial.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DatabaseConnection
 *
 * Clase utilitaria que centraliza la conexión JDBC a MySQL.
 * Cambia las constantes JDBC_URL, USER y PASSWORD según tu entorno.
 */
public class DatabaseConnection {

    // -------------------------------------------------------
    // Configuración de conexión — ajusta según tu MySQL local
    // -------------------------------------------------------
    private static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String JDBC_URL    = "jdbc:mysql://localhost:3306/mundial2026"
                                            + "?useSSL=false"
                                            + "&allowPublicKeyRetrieval=true"
                                            + "&serverTimezone=America/Mexico_City"
                                            + "&characterEncoding=UTF-8";
    private static final String USER        = "root";   // ← cambia si es diferente
    private static final String PASSWORD    = "";        // ← pon tu contraseña MySQL

    // Constructor privado: no se instancia
    private DatabaseConnection() {}

    /**
     * Obtiene una conexión activa a la base de datos.
     *
     * @return Connection listo para usar
     * @throws SQLException si la conexión falla
     */
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName(JDBC_DRIVER);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver MySQL no encontrado. "
                + "Verifica que mysql-connector-j está en el classpath.", e);
        }
        return DriverManager.getConnection(JDBC_URL, USER, PASSWORD);
    }

    /**
     * Cierra silenciosamente una conexión (evita bloques try/catch repetitivos).
     *
     * @param conn conexión a cerrar (puede ser null)
     */
    public static void closeQuietly(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException ignored) {
                // Cierre silencioso
            }
        }
    }
}
