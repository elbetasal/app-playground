FROM azul/zulu-openjdk-alpine:11-jre

EXPOSE 8080

WORKDIR /app

RUN wget https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v0.16.0/opentelemetry-javaagent-all.jar -O otel.jar
#RUN wget https://github.com/honeycombio/honeycomb-opentelemetry-java/releases/download/v1.1.0/honeycomb-opentelemetry-javaagent-1.1.0.jar
# -O otel.jar

ENV OTEL_TRACES_EXPORTER otlp
ENV OTEL_METRICS_EXPORTER none
ENV OTEL_EXPORTER_OTLP_ENDPOINT https://api.honeycomb.io
ENV OTEL_EXPORTER_OTLP_HEADERS "x-honeycomb-team=2e804ecbe4b96fb29ec31e1df0f45572,x-honeycomb-dataset=hello"
ENV OTEL_RESOURCE_ATTRIBUTES service.name=hello-app


#COPY --from=build /home/gradle/src/build/libs/*-all.jar /app/movies-service.jar
COPY ./build/libs/catalog-service-1.0.jar /app/catalog-service.jar

ENTRYPOINT ["java", "-XX:+UnlockExperimentalVMOptions", "-javaagent:otel.jar", "-Xmx200m" , "-Djava.security.egd=file:/dev/./urandom", "-jar","/app/catalog-service.jar"]
