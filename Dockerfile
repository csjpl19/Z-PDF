FROM tomcat:11.0.14-jdk17-temurin

# Supprimer les apps par défaut
RUN rm -rf /usr/local/tomcat/webapps/*

# Copier ton WAR
COPY dist/Z-PDF3.0.war /usr/local/tomcat/webapps/ROOT.war

# Railway expose automatiquement le port
EXPOSE 8080