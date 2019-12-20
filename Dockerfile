# -------------------------------------------------------------------------------------------------
# Node web-app
# -------------------------------------------------------------------------------------------------

# Select <image>:<version> as base image from https://hub.docker.com > Official Images
#   - apline picks a vanilla (basic) version
#   - 'as' lets you reference the image. 
FROM node:alpine as builder

# WORKDIR -- The pwd in the container
# Any relative operation we do (like copy) shall be relative to WORKDIR
#   - "cp foo foo" ===> "cp ./foo <WORKDIR>/foo"
#   - "cp foo foo" shall put the file foo from project dir in current machine to <WORKDIR>/foo in the container.
WORKDIR /home/app

# Copy package.json -- The dependency file descriptor for npm
# Install dependencies (requires package.json)
# Copy project files
COPY package.json .
RUN npm install
COPY . .

# Contianer startup command -- The command followed by options to be invoked by container after startup.
# Here, we are using "npm run build" which shall create a build dir having production ready files.
CMD ["npm", "run", "build"]

# -------------------------------------------------------------------------------------------------
# nginx -- A production web server
# -------------------------------------------------------------------------------------------------
FROM nginx

# Copy the production ready files built in 'builder' container at path <WORKDIR>/build 
# to the destination /usr/share/nginx/html in 'nginx' container
#   - The destination is got by looking at the documentation of nginx container
#   - Accordingly, all files in /usr/share/nginx/html shall be served by the server.
COPY --from=builder /home/app/build /usr/share/nginx/html