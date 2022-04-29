#FROM gradle:7.4.2-jdk11 AS build
#COPY --chown=gradle:gradle . /home/gradle/src
#WORKDIR /home/gradle/src
#RUN gradle build --no-daemon

FROM azul/zulu-openjdk-alpine:11-jre

EXPOSE 8080

RUN mkdir /app

#COPY --from=build /home/gradle/src/build/libs/*-all.jar /app/movies-service.jar
COPY ./build/libs/*-all.jar /app/movies-service.jar

ENTRYPOINT ["java", "-XX:+UnlockExperimentalVMOptions", "-Xmx200m" , "-Djava.security.egd=file:/dev/./urandom","-jar","/app/movies-service.jar"]
