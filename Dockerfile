# Multi-stage build to optimize image size
FROM eclipse-temurin:24-jdk-alpine AS build

# Set working directory
WORKDIR /app

# Copy Maven configuration files
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Give execution permission to mvnw
RUN chmod +x mvnw

# Download dependencies (cache layer)
RUN ./mvnw dependency:go-offline -B

# Copy source code
COPY src src

# Compile the application
RUN ./mvnw clean package -DskipTests

# Production stage
FROM eclipse-temurin:24-jre-alpine

# Create non-root user for security
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

# Set working directory
WORKDIR /app

# Copy compiled JAR from previous stage
COPY --from=build /app/target/*.jar app.jar

# Change file ownership to non-root user
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Expose application port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1

# Command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"] 