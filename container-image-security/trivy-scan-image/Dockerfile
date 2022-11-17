FROM maven:3.8.1-jdk-8 as build

# Run vulnerability scan on build image
# FROM build AS vulnscan
# COPY --from=aquasec/trivy:latest /usr/local/bin/trivy /usr/local/bin/trivy
# RUN trivy rootfs --no-progress /

WORKDIR /app

COPY pom.xml ./

COPY src ./src

CMD ["mvn", "spring-boot:run"]