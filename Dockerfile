# Dockerfile for Nodejs app
# We will use a key word called FROM

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

# BUILD THE IMAGE: docker build -t josetorres31/eng84_jose_app .

# BUILD THE CONTAINER: docker run -d -p 3000:3000 josetorres31/eng84_jose_app
