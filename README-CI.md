# Project 4 - CI Project
## Part 1 - Docker-ize It

### Overview
In this project, I am tasked to utilize Docker/DockerHub to create and develop a container that runs a given `angular-bird` application. I am also tasked with connecting this GitHub repository to a repository in DockerHub, and interacting with the two in order to edit the container and otherwise. Finally, I will identify how these tools interact with each other through diagramming.
### Application Containerization
This section discusses setting up Docker, building the container, and making/using a Dockerfile.
- How do you install Docker and its' dependencies on the required systems?:
  - On Windows, Docker can be installed from [Docker's Website](https://docs.docker.com/engine/install/). (OPTIONAL, I believe)
  - Since I am also using Ubuntu as my (required) WSL instance, I will also have to `sudo apt install docker` so I can work with the GitHub repository locally.
- To build and configure a container...
  - We have an example application provided to use called `angular-bird` that contains a simple Angular application, and requires angular version 15.0.3 and Node.js version 18 to run.
  - To start a container, we can use the command `docker run -it --rm --name angularapp -p 4200:4200 -v ~/CEG3120/f24cicd-honeypint/angular-site:/usr/src/angular node:18-bullseye sh`, which starts a container with the following settings...
    - `-it`: The container accepts input/output.
    - `--rm`: The container will be removed upon closure.
    - `--name`: The container is named `angularapp`.
    - `-p`: ports to bind everything to. This takes the structure of `<localport>:<containerport>`. With this, we can connect to localhost:4200 in order to see the website created by the angular application.
    - `-v`: copies a file over to work with, and puts it in a respective file in the container, with the format `<localfile>:<containerfile>`. In this case, we want to copy over the `angular-site` file contents, which is what that given file path above is. I also put the file in `/usr/src/angular`.
    - `node:18-bullseye`: The software that the container is being launched with (Node, version 18-bullseye), in the format `<program>:<version>`. Another example of this would be if you wanted Python 3.8, where you would use `python:3.8`.
    - `sh`: Opens a shell when the container begins.
  - We then have to install angular version 15.0.3 using the command `npm install -g @angular/cli@15.0.3`.
  - Finally, we can run the command `ng serve --host 0.0.0.0`, which compiles and starts the angular app. It binds to any IP, and binds to `localhost` within the container.
- What instructions does the `Dockerfile` contain?:
  - `FROM` is the base image being used.
  - `WORKDIR` is the working directory, AKA `/usr/src/angular`.
  - `COPY` are the files being copied into the working directory. I am copying the file that contains everything for the angular app.
  - `RUN` can run commands; in this case, it installs the corresponding angular version using `npm`.
  - `EXPOSE` tells what port number the container should "expose" or use on your system primarily.
  - `CMD` is a command to run in order for the program to operate, which in this case is the `ng serve` command used in the previous task.
  - An example of what my Dockerfile looks like can be found below.
```
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
```
- How do you build an image using the `Dockerfile`?:
  - You can build an image using the Dockerfile by running a `docker build` command in the file where the Dockerfile is located (or otherwise if you specify the path).
  -  `docker build -t angular:1.0.0 .`, where `angular:1.0.0` is going to be the name of the image, and `.` will be the file path of where the Dockerfile is (in this context, I am running this *in this repository*).
- How do you run a container from the image build by the repo's `Dockerfile`?:
  - You can run a container using the Dockerfile by running a `docker run` command where the Dockerfile is located. Make sure the Dockerfile using correct paths based on where it is, which should be done in the previous step!
  - `docker run --name angulartest --rm -p 4200:4200 angular:1.0.0` accomplishes the same thing as done in Task 6, where `angular:1.0.0` is the container name. 
- How do you view the application running in the container?:
  - This can be done with both methods -- based on how I set it up, I can literally go to `localhost:4200`, since I bound it to the 4200 port using `-p 4200:4200`. (Note that both entires are 4200, since the angular app also uses port 4200. I could change it to `80:4200` to access it on port 80 instead.)
 
### Working With DockerHub
t

## Part 2 - GitHub Actions and DockerHub
t

### Configuring GitHub Secrets
t

### Behavior of Github Workflow
t

### Part 3 - Diagrams!
t


