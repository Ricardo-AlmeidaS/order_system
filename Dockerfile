# ESTÁGIO 1: Build
FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src

# --- A MUDANÇA É AQUI ---
# De: RUN mvn package -DskipTests
# Para:
RUN mvn package -Dmaven.test.skip=true

# ESTÁGIO 2: Run
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]