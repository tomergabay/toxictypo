FROM openjdk:8-jre-alpine

COPY ./toxic/target/toxictypoapp-1.0-SNAPSHOT.jar .

ENTRYPOINT [ "java", "-jar","toxictypoapp-1.0-SNAPSHOT.jar"]

