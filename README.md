 

# Configure Local Environment

## Install Libraries/Components

```bash
npm
docker
```

## Clone Repo

Create an empty repo in GitHub called `hello-world-expressjs-docker`.  Add `.gitignore` with the `Node` template.  Clone it with directions below.

```bash
# Clone repo
$ git clone git@github.com:jay-law/hello-world-expressjs-docker.git
$ cd hello-world-expressjs-docker/
```

## Initalize Project

```bash
# Initalize project - adds package.json
$ npm init --scope=@jay-law

# Add express - updates package.json
$ npm install express

# Install dependencies - Creates node_modules dir
$ npm install
```

# Make Changes

## Create index.js

Express can act as a web server locally.  Create and run the index.js file which will start a server.

```bash
# Create the index.js file
# Copy everything between 'cat' and the second EOF directly into 
# console.  Or copy the contents directly into the file
$ cat > index.js << EOF
const express = require('express')
const app = express()
const port = 3000

app.get('/', (req, res) => {
    res.send('Hello World!')
})

app.listen(port, () => {
    console.log(' Listening on port 3000')
})
EOF

# Start server
$ node index.js

# Open browser and navigate to http://localhost:3000/
```

## Create Dockerfile

Docker will create an image from a Dockerfile (no extension).  Below a Dockerfile is populated then used to create an image.  The image is used to create a container.

```bash

# Create the Dockerfile
# Copy everything between 'cat' and the second EOF directly into 
# console.  Or copy the contents directly into the file
$ cat > Dockerfile << EOF
FROM ubuntu:20.04

WORKDIR /app

RUN apt-get update      &&    \
    apt-get upgrade -y  &&    \
    apt-get install -y        \
        curl                  \
        build-essential       \
        bash-completion    && \
    apt-get clean

RUN curl -sL https://deb.nodesource.com/setup_17.x | bash -

RUN apt-get install -y nodejs

COPY ./ ./

RUN npm install

EXPOSE 3000

CMD [ "node", "index.js"]
EOF

# Create the image
$ docker build -t ubuntu-node .

# Create and run a container from 'ubuntu-node' image
# --detach - Run container in background and print container ID
# --rm - Automatically remove the container when it exits
# --publish - Publish a container's port(s) to the host
$  docker run --detach --rm \
    --name ubuntu-node \
    --publish 3000:3000/tcp \
    ubuntu-node:latest

# Open browser and navigate to http://localhost:3000/

# Stop the container
$ docker container kill ubuntu-node
```

# Publish

The `hello-world-expressjs-docker` project has been tested locally and is ready to be published.  First, code changes will be published (pushed) to GitHub.  Second, the package will be pushed to the npm registry. 

## Push to Git

```bash

```

## Publish to npm Registry

## Test Published Package

```bash

```


# Other