# Build stage
FROM maven:3.9-eclipse-temurin-21 as builder

WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:resolve

# Copy source and build
COPY . .
RUN mvn clean package -DskipTests

# Runtime stage
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Install bash for scripts
RUN apk add --no-cache bash

# Copy built JAR from builder
COPY --from=builder /app/target/ironpulse-api-*.jar app.jar
COPY --from=builder /app/lib ./lib

# Copy run scripts
COPY --from=builder /app/scripts ./scripts

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD java -cp app.jar com.ironpulse.health.HealthCheck || exit 1

# Expose port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-Xmx512m", "-Xms256m", "-jar", "app.jar"]
