FROM openjdk:17-jdk-slim AS build
WORKDIR /app

# Install Git and Maven (if not using the Maven Wrapper)
RUN apt-get update && apt-get install -y git maven && rm -rf /var/lib/apt/lists/*

# Clone the Shopizer repository
RUN git clone https://github.com/shopizer-ecommerce/shopizer.git .

# Build the project (without packaging) and download dependencies
RUN mvn clean install -DskipTests

# You can optionally navigate to the module then run using spring-boot:run

FROM openjdk:17-jdk-slim
WORKDIR /app

# Copy the full build context and Maven wrapper if present
COPY --from=build /app . 

# Run the backend using Maven directly
CMD ["mvn", "-pl", "sm-shop", "spring-boot:run"]
