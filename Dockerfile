# ─────────────────────────────────────────────
# Etapa 1: compilar el WAR con Maven
# ─────────────────────────────────────────────
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# Copiar archivos de proyecto
COPY pom.xml .
COPY src ./src

# Compilar y empaquetar (sin tests)
RUN mvn clean package -DskipTests

# ─────────────────────────────────────────────
# Etapa 2: correr en Tomcat 10
# ─────────────────────────────────────────────
FROM tomcat:10.1-jdk17

# Limpiar apps por defecto de Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Copiar el WAR generado como ROOT (responde en /)
COPY --from=build /app/target/mundial2026.war /usr/local/tomcat/webapps/ROOT.war

# Render usa el puerto 10000 por defecto (o el que definas)
# Tomcat escucha en 8080 — Render lo mapea automáticamente
EXPOSE 8080

CMD ["catalina.sh", "run"]
