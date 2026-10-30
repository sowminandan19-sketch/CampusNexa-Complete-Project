# ==============================================================================
# CampusNexa - Multi-Stage Production Dockerfile (Jakarta EE 10 / Tomcat 10.1)
# ==============================================================================

# Stage 1: Build Java WAR using Maven and Eclipse Temurin JDK 17
FROM maven:3.9-eclipse-temurin-17-alpine AS builder
WORKDIR /build

# Copy project files into container
COPY . .

# Build production WAR (handles either root pom.xml or nested directory)
RUN if [ -f "pom.xml" ]; then \
        echo "Building from root pom.xml..." && \
        mvn clean package -DskipTests && \
        cp target/campus-maintenance-system.war /build/app.war; \
    elif [ -f "CAMPUSNEXA-main/pom.xml" ]; then \
        echo "Building from CAMPUSNEXA-main/pom.xml..." && \
        cd CAMPUSNEXA-main && \
        mvn clean package -DskipTests && \
        cp target/campus-maintenance-system.war /build/app.war; \
    else \
        echo "Error: pom.xml not found!" && exit 1; \
    fi

# Stage 2: Production Runtime with Apache Tomcat 10.1
FROM tomcat:10.1-jdk17-temurin

LABEL maintainer="CampusNexa Team"
LABEL description="Campus Maintenance & Grievance Management System"

WORKDIR /usr/local/tomcat

# Remove default Tomcat webapps
RUN rm -rf webapps/*

# Copy compiled WAR as the ROOT web application
COPY --from=builder /build/app.war webapps/ROOT.war

# Expose HTTP port
EXPOSE 8080

# Environment variables with fallback defaults (can be overridden in production)
ENV DB_URL="jdbc:mysql://localhost:3306/maintenance_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC"
ENV DB_USER="root"
ENV DB_PASSWORD=""

# Run Tomcat in foreground
CMD ["catalina.sh", "run"]

