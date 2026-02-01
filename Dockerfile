# Usamos apenas o JRE (Runtime) para manter a imagem pequena e segura
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Criar usuário de segurança para não rodar como root
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

# Copia o JAR que o GitHub Actions já compilou na pasta target
# O asterisco garante que pegamos o arquivo correto independente da versão
COPY target/*.jar app.jar

# Porta padrão do Spring
EXPOSE 8080

# Variáveis de ambiente para otimização da JVM em containers
ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0 -Djava.security.egd=file:/dev/./urandom"

# Comando de inicialização
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]