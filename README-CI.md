# Project 4 - CI Project
## Part 1 - Docker-ize It

### Overview
In this project, I am tasked to utilize Docker/DockerHub to create and develop a container that runs a given `angular-bird` application. I am also tasked with connecting this GitHub repository to a repository in DockerHub, and interacting with the two in order to edit the container and otherwise. This repository will also describe using GitHub Actions. Finally, I will identify how these tools interact with each other through diagramming. The diagram which describes how everything connects together can be found below (the diagram itself is Part 3 of this Project).
#### CI Project Diagram
![CI Diagram](./images/Proj4-Diagram.png)
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
  - An example of what my Dockerfile looks like can be found below, or in the actual Dockerfile located in this repository.
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
  -  `docker build -t angular:1.0.0 .`, where `angular:1.0.0` is going to be the name of the image (`name:tag` format), and `.` will be the file path of where the Dockerfile is (in this context, I am running this *in this repository*).
- How do you run a container from the image build by the repo's `Dockerfile`?:
  - You can run a container using the Dockerfile by running a `docker run` command where the Dockerfile is located. Make sure the Dockerfile using correct paths based on where it is, which should be done in the previous step!
  - `docker run --name angulartest --rm -p 4200:4200 angular:1.0.0` accomplishes the same thing as done in Task 6, where `angular:1.0.0` is the container name. 
- How do you view the application running in the container?:
  - This can be done with both methods -- based on how I set it up, I can literally go to `localhost:4200`, since I bound it to the 4200 port using `-p 4200:4200`. (Note that both entires are 4200, since the angular app also uses port 4200. I could change it to `80:4200` to access it on port 80 instead.)
 
### Working With DockerHub
This section discusses using DockerHub. It assumes that an account has already been made on the DockerHub website.
- How do you create a new DockerHub public repository?:
  - Sign in, go to hub.docker.com, and you can click the blue "Create repository" button.
  - Name the repository accordingly, and make sure to set the Visibility as Public (which should be the default). 
- How do you authenticate with DockerHub via CLI using DockerHub credentials?:
  - You can use the command `docker login` in order to log into your DockerHub account through the command line.
  - There are two ways you can do this: you can either do to the activate site and enter in the provided code while logged into your DockerHub account on the web browser, OR you can log in through the commandline by using `docker login -u username`.
- How do you push your container image to DockerHub?:
  - I can push my container image using the following two commands:
  - `docker tag angular:1.0.0 kclondon22/cox-ceg3120` - connects the `angular:1.0.0` image with the DockerHub repository
  - `docker push kclondon22/cox-ceg3120` - pushes the connection, specifically pushing it as `latest` in this case.
- My DockerHub repository, `kclondon22/cox-ceg3120`, can be found linked [here](https://hub.docker.com/repository/docker/kclondon22/cox-ceg3120/general).

## Part 2 - GitHub Actions and DockerHub
This section utilizes GitHub Actions to build and push an image each time the repository is pushed to. This will also utilize GitHub Secrets in order to verify the login towards a DockerHub account in order to properly authenticate.

### Configuring GitHub Secrets
This section discusses utilizing GitHub Secrets for GitHub Actions, and describes how to use it for the context of this project.
- How to make GitHub Actions:
  - You need a `.github` folder in your repository's starting directory.
  - Within that above folder, make a `workflows` folder.
  - Those should have `yml` files that make up a specific Action.
    - Unrelated, but you can "deactivate" certain workflows by putting `.old` or something else in front of them, so for example `myfirstflow.yml`.
  - From there, there is a format you can follow in order to properly create the workflow that you want through a GitHub Action. 
- How to set up a secret for use by GitHub Actions:
  - To set up secrets in the first place, you need Admin privleges into the repository that you are working on. So, go get that first...
  - You can set up secrets in the repository settings in GitHub, in the "Actions" setting section. This is where you can create a new secret. You can give it a specific name, and then store the actual information.
    - You can never reference the plaintext value that GitHub stores, only they keep it, if you don't have a copy you will lose it. Kind of like how a Key works. If you Edit it, it just replaces the file. 
    - When referencing it in the Action, use the following syntax: `$ {{ secrets.SECRET_EXAMPLE }}` 
  - For the context of this project, we only need repository secrets (which is what we made above), not "environment secrets". 
- Secrets set for this project (not specific examples):
  - This project requires `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` secrets, which will hold the DockerHub username/token combination for my account in order to log in to do the build/push combination of the image.
  - To get a DockerHub account token, go to Account Settings -> Security, and then you can create a new token (make sure, for this context, it has Read and Write permissions)

### Behavior of Github Workflow
This section discusses what the workflow does, and how to duplicate it if need be.
- Summary of what the workflow does:
  - The workflow runs on Ubuntu on the latest version.
  - The workflow sets up actions that are required for docker to build and push an image. (`docker/setup-qemu-action@v3`, `docker/setup-buildx-action@v3`, `docker/login-action@v3`)
    - For the login action, it accepts the username and password created in GitHub Secrets in the previous section. 
  - The workflow builds the image based on the Dockerfile in the primary repository, and pushes the image.
    - The workflow would have to reference the specific Dockerfile if multiple ended up existing, which might be the case once Project 5 begins. (using `context: "{{defaultContext}}:mysubdir"` bundled in the "with" for the push action) 
- The workflow file can be found linked [here](https://github.com/WSU-kduncan/f24cicd-honeypint/blob/main/.github/workflows/project4.yml).
- What would someone need to do to duplicate my workflow (including workflow + repo changes)?:
  - Workflow: Change the `tags` to indicate the DockerHub repository to whatever repository that would be in use. So, for example, `name/repo:latest` would be the format to adopt to this.
  - GitHub Repository: Add their own secrets indicating their own username and their own token. They can't use *my* information!
  - Docker Repository: Of course, they'd have to create this brand new repository that is referenced in the workflow, unless the repo already exists.


