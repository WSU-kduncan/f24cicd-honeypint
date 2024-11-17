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
  - To start a container, we can use the command `docker run -it --rm --name angularapp -v ~/CEG3120/f24cicd-honeypint/angular-site:/usr/src/angular node:18-bullseye sh`, which starts a container with the following settings...
    - `-it`: The container accepts input/output.
    - `--rm`: The container will be removed upon closure.
    - `--name`: The container is named `angularapp`.
    - `-v`: copies a file over to work with, and puts it in a respective file in the container, with the format `<hostfile>:<containerfile>`. In this case, we want to copy over the `angular-site` file contents.
    - `node:18-bullseye`: The software that the container is being launched with (Node, version 18-bullseye), in the format `<program>:<version>`. Another example of this would be if you wanted Python 3.8, where you would use `python:3.8`.
    - `sh`: Opens a shell when the container begins.
  - We then have to install angular version 15.0.3 using the command `npm install -g @angular/cli`.
  - Finally, we can run the command `ng serve --host 0.0.0.0`, which compiles and starts the angular app. It binds to any IP, and binds to `localhost` within the container.
- What instructions does the `Dockerfile` contain?:
  - t 
- How do you build an image using the `Dockerfile`?:
  - t 
- How do you run a container from the image build by the repo's `Dockerfile`?:
  - t 
- How do you view the application running in the container?:
  - t
 
### Working With DockerHub


## Part 2 - GitHub Actions and DockerHub


### Configuring GitHub Secrets


### Behavior of Github Workflow


### Part 3 - Diagrams!



