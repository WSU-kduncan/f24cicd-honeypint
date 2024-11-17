FROM node:18-bullseye

# working directory
WORKDIR /usr/src/angular

# copy the files from the program in angular-site into the working directory
COPY ./angular-site/wsu-hw-ng-main .

# install dependencies
RUN npm install -g @angular/cli@15.0.3

# tell the port number the container should expose
EXPOSE 4200

# run the required command to run the angular program
CMD ["ng", "serve", "--host", "0.0.0.0"]

