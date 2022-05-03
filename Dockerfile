FROM openjdk:11

ADD target/spring-boot-web-0.0.1-SNAPSHOT.jar springbootapp

EXPOSE 8080

ENTRYPOINT ["java","-jar","/springbootapp"]
