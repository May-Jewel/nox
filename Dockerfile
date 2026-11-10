FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn -B compile war:war

FROM tomcat:11.0-jdk21-temurin
COPY --from=build /app/target/nox.war /usr/local/tomcat/webapps/nox.war
EXPOSE 8080
