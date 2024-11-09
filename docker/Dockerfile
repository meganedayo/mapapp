FROM node:20

RUN apt update && \
apt install -y curl openjdk-17-jdk && \
curl -fsSL http://deb.nodesource.com/setup_16.x | bash - 

RUN npm install -g firebase-tools