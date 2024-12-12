# Project 5 - CD Project
## Part 1 - Semantic Versioning

### Overview
In this project, I am tasked to use Git's tagging using semantic versioning to cause the GitHub Action defined in Project4 to run under more specific circumstances, happening when the tag is updating and adopting this tag to be used with the image when it is pushed to DockerHub. I am also tasked with using an EC2 instance to pull the image from DockerHub and run it properly, as well as utilizing webhooks that run a bash script alongside it. Found below is a diagram that dictates how everything interacts (which is Part 3 of the project). A demonstration will also be made to show that this works (which is Part 4 of the project).
#### CD Project Diagram
![CD Diagram]()
### Tags in `git`
This section discusses using tags in Git, and how to make them work with everything previously done through GitHub Actions and DockerHub in Project 4.
- How to generate/push a tag in `git`:
  - First, make the commits that you want to tag with a certain tag value through the usual method, up to when you want to make the tag. They can be pushed or not.
  - Use the `git tag` command in the following format: `git tag -a v#.#.#`. You will also be able to add a comment after the command is run, done similarily to how you title a commit.
   - The version number will be determined by semantic versioning, which is in the structure `vMAJOR.MINOR.PATCH`.
   - The commit that creates this part of the repository will be given the tag.
  - Now, you can do `git push origin <version used>`. After this, you can click on a tag, similarily to how you click on a branch, to see what what there at the time.
- Editing the GitHub Action/Workflow:
  - At the end of Project 4, the GitHub Action ran every time new commits were pushed. This can be changed to only happen when a new valid TAG is pushed.
  - How do we change this?:
    - Setting the workflow to only push when the tag is of a certain semantic versioning format through `tags: -v*.*.*`
    - Creating a brand new first step that runs docker metadata, to get and set images/tags that will be used based on the above
    - Edit the push to DockerHub action tags/labels to properly accept when a tag is added through GitHub
  - With these changes, now if we push, changes will only be pushed to DockerHub if there is a valid tag pushed.
  - Additionally, the tags are now stored & set onto DockerHub based on Semantic Versioning, based on Latest, Major, Minor, and full versions, to ensure proper backups are able to be made. Sweet!
    - As able to be seen right now, there are a few tags on DockerHub: `latest`, `1`, `1.0` and `1.0.5` (the reason why it is 1.0.5 is due to a few errors trying to get the versioning to work properly... turns out, I forgot to add the `id: meta` part!) 
- The DockerHub repository where these tags were pushed can be found linked [here](https://hub.docker.com/r/kclondon22/cox-ceg3120).
## Part 2 - Deployment
This section discusses deploying my DockerHub image into a new instance hosted through AWS, running it/setup involved with doing so, creating a bash script to simplify updating a container image on said instance, and integrating this script with a webhook to automate the running of this bash script.
- Instance settings: Ubuntu 22.04 instance on AWS, as a `T2.small` to support Docker. Public IP (which I set as an Elastic IP) is `44.216.255.223`.
  - The instance can install Docker using `sudo apt install docker.io`. I can then pull my Docker image that is on DockerHub using `docker image pull user/repo`.
- Information about the bash script created for this project:
  - What is this for?: This script will be used for us to be able to update the container with an updated image that is running on our instance with ease.
  - What does it do?: This script stops and removes the previous container running the image (called `angular-site`), pulls the latest version of the image from DockerHub (therefore updating the image if it is outdated), and then starts a new container called `angular-site` with that image. This basically automatically "updates" the image that is being run within a container on an instance.
  - On my instance, this script can be found in `home/ubuntu/deployment/update.sh`
  - An example of this bash script can be found linked [here](./deployment/update.sh), in this repository.
- Installing adnanh's webhook into the instance:
  - Installing this webhook is relatively easy - I used `sudo apt-get install webhook` to install it on my Ubuntu instance.
  - The port needs to be properly configured. ...
  - What is this used for?: adnanh's webhook is used for the creation of HTTP endpoints (or webhooks) on the server that can be used to run instanced commands, as described in [the project's GitHub page](https://github.com/adnanh/webhook). 
- Information about the webhook definition created for this project:
  - What does it do?: What the webhook definition basically does is run the `update.sh` script that was defined previously. Since webhooks are listening, this means that it can automatically update the script under certain conditions.
  - On my instance, this definition can be found in `home/ubuntu/deployment/hooks.json` with id `"redeploy"`.
  - An example of this webhook definition can be found linked [here](./deployment/hooks.json), in this repository.
  - To start this webhook listening without using `service`, use the command `webhook -hooks hooks.json -verbose` (with the default port of 4200) ...
- How can we verify that the listener in the webhook actually runs the script?:
  - The webhook is started with the above command, and then is currently "triggered" by a connection through HTTP to `http://44.216.255.223:9000/hooks/redeploy`.
  - We can tell that the container is running based on output printed through the logs. The logs have the input of `docker ps -a` that proves the container was created. We can also verify the deletions, the pull, and so on were performed.
- Configuring DockerHub/GitHub to message the listener:
  - I chose to make DockerHub message the listener in the context of this project. However, webhooks can be interacted in GitHub pretty easily as well, through Settings -> Webhooks.
  - In DockerHub:
    - Go to the repository you are working with, and to the "Webhooks" section. Add a webhook that uses the HTTP link above, naming it whatever you want (in my case, AWS Instance Deployment).
    - The `hooks.json`/webhook also needs to be edited in order to support only launching the webhook when the `latest` tagged image is updated on DockerHub. Otherwise, it will run the webhook **four times** on a DockerHub push. (I renamed the old webhook I had to `old-redeploy`, and made a new `redeploy` that fulfills this requirement)   
- Configure a service file to start the webhook listener automatically when the instance starts:
  - The `service` file already existed, and was created when I installed adnanh's webhook project. It can be found under `/usr/lib/systemd/system/webhook.service`, and must be edited using `sudo` (as I do not own the file).
  - What changed?: I basically made everything that pointed to a config file for the webhooks, to instead point to my `hooks.json` file in my home directory. Therefore, this service file now interacts with that instead.
  - Commands: you have to `systemctl daemon-reload` after making the changes to the service file, then `systemctl stop webhook.service`, and then `systemctl start webhook.service` in order to basically run the changes.
  - The webhook service file can be found linked [here](./deployment/webhook.service), in this repository.
