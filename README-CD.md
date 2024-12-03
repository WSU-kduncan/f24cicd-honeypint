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
