 
# Overview

This is a tutorial designed to walk users through the following steps:
- Create a simple node package using ExpressJS as a web server
- Run the package in a Docker container
- Publish the node package to the npm registry
- Automate the publishing of future packages

It's more of a working example opposed to an in-depth tutorial.

## Prerequisites

- Publishing to the [npm-registry](https://www.npmjs.com) requires a npm account
- An user [access token](https://docs.npmjs.com/creating-and-viewing-access-tokens) is required to automating package publishing
- GitHub account for publishing code

## Using this Tutorial

Many of the commands provided below contain my GitHub username `jay-law` and my npm account name `jay-law`.  Replace my username with yours and everything should work.

The published npm packages are scoped to a username so the package name (`hello-world-expressjs-docker`) can remain the same.

npm example: 

https://www.npmjs.com/package/@jay-law/hello-world-expressjs-docker

should be 

https://www.npmjs.com/package/@YOUR_NPM_USER_NAME/hello-world-expressjs-docker

GitHub example:

https://github.com/jay-law/hello-world-expressjs-docker

should be

https://github.com/YOUR_GITHUB_ACCOUNT_NAME/hello-world-expressjs-docker

# Configure Local Environment

## Tech Stack Used

- Ubuntu - 20.04
- Node - 17.8
- npm - 8.5
- Docker - 20.10

## Clone Repo

Create an empty repo in GitHub called `hello-world-expressjs-docker`.  Add `.gitignore` with the `Node` template.  Clone it with directions below.

```bash
# Clone repo
$ git clone git@github.com:jay-law/hello-world-expressjs-docker.git
$ cd hello-world-expressjs-docker/
```

## Initalize Project

```bash
# Initalize project - creates package.json
$ npm init --scope=@jay-law

# Add express - adds express to dependency in package.json
$ npm install express

# Install dependencies - creates node_modules dir
$ npm install
# Keep hitting enter as the default values will be fine
```

# Make Code Changes

## Create index.js

Express can act as a web server locally.  Create and run the index.js file which will start a server.

```bash
# Create the index.js file
# See 'Other' section in the README for more info on this cat command
$ cat > index.js << 'EOF'
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
```

Confirm server is running by opening browser and navigating to http://localhost:3000/.

## Create Dockerfile

Create a docker container to host the Express app.  Docker will create an image from a Dockerfile (no filename extension).  Below a Dockerfile is populated then used to create an image.  The image is used to create a container.

```bash
# Create the Dockerfile
$ cat > Dockerfile << 'EOF'
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

# Confirm docker container is running
$ docker container list
```

Confirm server is running by opening browser and navigating to http://localhost:3000/.

```bash
# Stop the container
$ docker container kill ubuntu-node
```

# Publish

The `hello-world-expressjs-docker` project has been tested locally and is ready to be published.  First, code changes will be published (pushed) to GitHub.  Second, the package will be pushed to the npm registry. 

## Push to Git

Push the changes to GitHub.  

```bash
# Run these commands any time a push is required

# Add files with changes
$ git add .

# Check no files were missed
$ git status

# Commit
$ git commit -m 'files added'

# Update version
$ npm version major

# Push
$ git push --follow-tags
```

Open browser and navigate to https://github.com/jay-law/hello-world-expressjs-docker.  Confirm changes can be seen.

## Publish to npm Registry

Publish the node package to the npm registry so other users can use it.

### Manual Publish

The first publish will be manual.  Future publishes can be automated.

```bash
# Login to npm
$ npm login

# Publish to npm registry
$ npm publish --access public
```

Open browser and navigate to https://www.npmjs.com/package/@jay-law/hello-world-expressjs-docker.  Confirm changes can be seen.

### Automatic Publish

1. Enable 'automation tokens' for publishing packages in npm
    - Navigate to the package page - https://www.npmjs.com/package/@jay-law/hello-world-expressjs-docker
    - Settings -> Publishing access -> Select 'Require two-factor authentication or automation tokens'
    - Select 'Update Package Settings'
    - Be sure to create an access token for your user if needed.  Guide - https://docs.npmjs.com/creating-and-viewing-access-tokens

---

**NOTE** - GitHub workflows are stored as part of the code in `.github/workflows/YAML_FILES`.  As such, workflows can be created on the GitHub website or created locally then pushed.  The step below uses the website then pulls the code down.  See the `Other` section at the bottom of this `README` for directions on adding a workflow file manually.

---

2. Automate publishing in GitHub
    - Create workflow 
        - Navigate to the git repo
        - Select 'Actions'
        - Select 'Publish Node.js Package' then 'Configure'
        - Make changes as needed to the pipeline
        - Get the `NODE_AUTH_TOKEN` variable name.  It should be something like `${{secrets.npm_token}}`
        - Select 'Start commit' to save
    - Populate secret
        - Go to Settings ->  Secrets -> Actions
        - Select 'New repository secret'
        - Add `npm_token` for the token name and your npm token for the value 

3. Test the workflow/pipeline in GitHub
    - Do a `git pull` locally to pull down the `.github` dir.  It contains the workflow config
    - Commit and push
    - Assuming all work so far has been on the main branch, a GitHub action should have been triggered
    - Confirm the workflow completed successfully in GitHub under the Actions tab
    - Confirm the package was published on the https://www.npmjs.com/package/@jay-law/hello-world-expressjs-docker


**NOTE** - Pushes directly to the master branch should be disabled when coding in "real" environments.

# Other

## What is cat > [file name] << 'EOF'

This commands allows files to be populated directly from information in the terminal.  It allows users to copy from this README and paste commands directly into the terminal.  

It combines the `cat` command with the a ['here document'](https://tldp.org/LDP/abs/html/here-docs.html) code block.

```bash
# Here is a simple example.  Copy and paste this into your bash terminal
$ cat > some_file.txt << 'EOF'
hello friend
EOF
```

## Add Workflow File Directly

Workflows can be added manually, opposed to GitHub's website, as they are defined as YAML code.  

```bash
# Create the npm-publish.yml and parent dirs
mkdir --parents .github/workflows
touch .github/workflows/npm-publish.yml

# Populate the file
$ cat > .github/workflows/npm-publish.yml << 'EOF'
# This workflow will run tests using node and then publish a package to GitHub Packages when a release is created
# For more information see: https://help.github.com/actions/language-and-framework-guides/publishing-nodejs-packages

name: Publish Package

on:
  push:
    branches: [main]

jobs:
  publish-npm:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: 16
          registry-url: https://registry.npmjs.org/
      - run: npm ci
      - run: npm publish --access public
        env:
          NODE_AUTH_TOKEN: ${{secrets.npm_token}}
EOF
```

Add, commit, and push as normal.