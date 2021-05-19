# Docker Compose Task

Docker Compose is a tool for defining and running multi-container docker applications. With Compose, we use a YAML file to configure our application’s services. And then we create and start all the services from the configuration with a single command. Here is a simple graphical illustration that shows how Docker compose works:

![SCHEME](./compose.png)

## Task

__1.__ Create a docker-compose file `.yml`.

__2.__ Run multiple containers on this task. One for node image and another for the mongo official image to launch our app with /posts working.

__3.__ Create a volume to make data persistent. Docker volumes are same as a portable drive to save data and make it persistent.

## Solution

Let's create the 2-tier architecture node app with multiple containers.

Make sure that all the files should be in the same repository.

__1.__ First, you will need to download the whole app in your localhost. Create a folder and paste it.

__2.__ Then you will need to create the `Dockerfile` to create the image of the node-app.

````Dockerfile
FROM node:6

LABEL MAINTAINER = eng84josepython
# Using label is a good practice but optional

# Setting up the working dir inside the container
WORKDIR /usr/src/app

# COPY everything or dependencies required
COPY package*.json ./

# Run npm install after we have copied the dependecies
RUN npm install

COPY . .

# Expose the port 
EXPOSE 3000

RUN chmod +x /usr/src/app/entrypoint.sh

ENTRYPOINT ["/usr/src/app/entrypoint.sh"]

````

I have created a shell script that we are going to use to execute the necessary commands to get the data from the database as well as run the application. An important piece of information to keep in mind when we are going to have to sleep our app container for 10 seconds. Why? Because in the other file `docker-compuse`, in the section `depends_on`, it works fine but the problem is that it only waits for the container to be up. So it doesn't wait for mongo process to start, so we need to wait for a few seconds and it should work.

This is our `.sh` file:

````
#!/bin/bash

cd /usr/src/app

sleep 10

nodejs seeds/seed.js

nodejs app.js
````

__3.__ The docker image that we have created, has been pushed to DockerHub `josetorres31/eng84_jose_app`.

__4.__ Then, there are two requirements before the node application can be fully working. Firt, the db container needs to be run, and then the environment variable `DB_HOST` needs to be set inside the node-app container.

__5.__ Let's configure our `docker-compose.yml` file:

````
version: '3'
services:
  app:
    container_name: node-app
    restart: always
    build: .
    image: josetorres31/eng84_jose_app
    environment:
      - DB_HOST=mongodb://mongo:27017/posts
    image: josetorres31/eng84_jose_app:latest
    ports:
      - "3000:3000"
    depends_on:
      - mongo

  mongo:
    image: mongo
    container_name: db
    volumes:
      - dbdata:/data
    ports:
      - "27017:27017"

volumes:
  dbdata:
````

The important point here is `depends_on` section. It is used to specify that the database container needs to be run first.
Then, once the database container is running, the Dockerfile for the app is specified, along with the appropriate environment variables to connect to the database.

Also we need to create a volume for the database just to make it persistent.

__6.__ One is done we need to build the image, so let's run:

`docker-compose build --no-cache`

__7.__ And finally, let's run our multi containers:

`docker-compose up`

__8.__ The application can be found on your browser with url:

`localhost:3000` and `localhost:3000/posts`

AMAZING JOB! You have deployed microservices for your app and db working properly using docker in the easiest way possible.
