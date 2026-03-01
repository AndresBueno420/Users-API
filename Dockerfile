# Usamos Amazon Corretto 8 (la versión estable de Java 8)
FROM amazoncorretto:8-alpine AS build
WORKDIR /app

COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

RUN tr -d '\r' < mvnw > mvnw_unix && \
    mv mvnw_unix mvnw && \
    chmod +x mvnw

COPY src src

RUN ./mvnw clean install -DskipTests


FROM amazoncorretto:8-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

ENV JWT_SECRET=PRFT
ENV SERVER_PORT=8083

EXPOSE 8083
ENTRYPOINT ["java", "-jar", "app.jar"]