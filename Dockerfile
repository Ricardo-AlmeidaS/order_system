# ----- Estágio 1: Build (Compilação) -----
# Usamos uma imagem que já tem o Maven e o JDK 21 (baseado no seu pom.xml)
FROM maven:3.9-eclipse-temurin-21 AS builder

# Define o diretório de trabalho
WORKDIR /app

# Copia o pom.xml e baixa as dependências primeiro
# Isso aproveita o cache do Docker se as dependências não mudarem
COPY pom.xml .
RUN mvn dependency:go-offline

# Copia o resto do código-fonte e compila
COPY src ./src
RUN mvn package -DskipTests

# ----- Estágio 2: Imagem Final (Execução) -----
# Usamos uma imagem "slim" que contém apenas o Java 21 para rodar
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app

# Copia o JAR compilado do estágio de build para a imagem final
# Ajuste o nome do JAR se o artifactId ou version no seu pom.xml for diferente
COPY --from=builder /app/target/pagamentos-0.0.1-SNAPSHOT.jar app.jar

# Expõe a porta 8080 (porta padrão do Spring Boot)
EXPOSE 8080

# Comando para iniciar a aplicação
ENTRYPOINT ["java", "-jar", "app.jar"]