# 1. 빌드 스테이지: 자바 코드를 실행 가능한 JAR로 만든다.
FROM amazoncorretto:17 AS builder
WORKDIR /app
COPY . .
RUN chmod +x ./gradlew
RUN ./gradlew clean build -x test

# 2. 실행 스테이지: 빌드된 JAR만 꺼내서 가벼운 환경에서 실행한다.
FROM amazoncorretto:17-alpine
WORKDIR /app
COPY --from=builder /app/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]