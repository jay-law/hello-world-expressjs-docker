FROM ubuntu:20.04

WORKDIR /app

RUN apt-get update      &&        apt-get upgrade -y  &&        apt-get install -y                curl                          build-essential               bash-completion    &&     apt-get clean

RUN curl -sL https://deb.nodesource.com/setup_17.x | bash -

RUN apt-get install -y nodejs

COPY ./ ./

RUN npm install

EXPOSE 3000

CMD [ "node", "index.js"]