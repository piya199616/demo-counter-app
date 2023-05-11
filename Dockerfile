FROM maven as build
WORKDIR /app
COPY . .
RUN mvn clean install

FROM openjdk:11
WORKDIR /app
COPY --from=build /app/target/uber.jar /app/
EXPOSE 9090
CMD ["java" , "-jar" , "Uber.jar"]