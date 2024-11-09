FROM node:20

RUN echo aaa
RUN apt update && \
apt install -y curl openjdk-17-jdk && \
curl -fsSL http://deb.nodesource.com/setup_16.x | bash - 
COPY firebase/ /opt/firebase

RUN npm install -g firebase-tools