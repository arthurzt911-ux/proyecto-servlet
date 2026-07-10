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
    // Configuración de conexión — lee variables de entorno
    // En local: define DB_URL, DB_USER, DB_PASSWORD en tu sistema
    // En Render: configura estas variables en el dashboard
    // -------------------------------------------------------
    private static final String JDBC_DRIVER = "org.postgresql.Driver";

    private static String getJdbcUrl() {
        String url = System.getenv("DB_URL");
        if (url != null && !url.isEmpty()) return url;
        // Fallback local (PostgreSQL)
        return "jdbc:postgresql://localhost:5432/mundial2026";
    }

    private static String getUser() {
        String user = System.getenv("DB_USER");
        return (user != null && !user.isEmpty()) ? user : "root";
    }

    private static String getPassword() {
        String pass = System.getenv("DB_PASSWORD");
        return (pass != null) ? pass : "";
    }

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
        return DriverManager.getConnection(getJdbcUrl(), getUser(), getPassword());
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
