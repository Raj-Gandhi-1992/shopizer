# Stage 1: Build with Maven
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy project files
COPY . .

# Build Shopizer without tests (faster)
RUN mvn clean package -DskipTests

# Stage 2: Minimal runtime image
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copy only the sm-shop jar from build stage
COPY --from=build /app/sm-shop/target/*.jar app.jar

# Expose default Shopizer port
EXPOSE 8080

# Run the jar
CMD ["java", "-jar", "app.jar"]
