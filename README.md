<h3 align="center">Dockerhub webhook handler</h3>

<div align="center">

  [![Status](https://img.shields.io/badge/status-active-success.svg)]() 
  [![License](https://img.shields.io/badge/license-MIT-blue.svg)](/LICENSE)

</div>

---

<p align="center"> Automatic docker deployment with dockerhub webhooks
    <br> 
</p>

- [🧐 About ](#-about-)
- [💭 For what? ](#-for-what-)
- [🖖 Features ](#-features-)
- [✅ Requirements ](#-requirements-)
- [🏁 User Guide ](#-user-guide-)
  - [Prerequisites](#prerequisites)
  - [Installing](#installing)
  - [Configure](#configure)
    - [1. Create a bash script](#1-create-a-bash-script)
    - [2. Save your script](#2-save-your-script)
    - [3. Associate your script with a DockerHub repository name.](#3-associate-your-script-with-a-dockerhub-repository-name)
    - [4. Launch the webhook image.](#4-launch-the-webhook-image)
- [🏁 Developers Guide ](#-developers-guide-)
  - [Workflow architecture](#workflow-architecture)
  - [Installation](#installation)
- [🔧 Running the tests ](#-running-the-tests-)
- [🚀 Deployment ](#-deployment-)
- [✍️ Authors ](#️-authors-)
- [🎉 Acknowledgements ](#-acknowledgements-)

## 🧐 About <a name = "about"></a>

Engineered for the purpose of managing Docker images and containers on the server via user bash scripts (alongside provided templates). This functionality is triggered upon receiving a POST request from a DockerHub webhook. It's possible to exclusively execute Docker commands.

## 💭 For what? <a name = "for_what"></a>
As you integrate DockerHub into your CI/CD pipeline, you may realize that the built-in Docker tools and Docker Compose tools do not inherently support working with DockerHub webhooks without additional setup, as of August 2023.

In the context of the continuous deployment (CD) pipeline, the operational flow assumes that when a new image is uploaded to DockerHub and a corresponding webhook signal is transmitted to the server, the ensuing procedure entails fetching a fresh image from DockerHub, discontinuing the existing container, and subsequently launching the new image on the server.

![CI/CD pipeline](https://github.com/la-strole/webhook/blob/main/readme_src/images/image1.png?raw=true)

## 🖖 Features <a name = "features"></a>
- Authenticate DockerHub's POST request by employing a distinctive URL sequence;
- Completely encompasses the DockerHub webhook API, which includes comprehensive support for webhook validation through [callback requests](https://docs.docker.com/docker-hub/webhooks/#validate-a-webhook-callback);
- Offers lightweightness and dependency isolation within a Docker container. This setup necessitates only Docker and a web server on the server side, without any additional installations. <br>

This solution is particularly well-suited for those who have an existing web server installed and prefer to limit open ports to only 80 and 443 for external access. If you lack a web server installation and are unconcerned about open ports, or if you utilize platforms like Nodejs, it might be advantageous to explore similar projects like [micro-dockerhub-hook](https://github.com/maccyber/micro-dockerhub-hook).

## ✅ Requirements <a name="requirements"></a>
- linux server (successfully tested on Ubuntu 22.04, Ubuntu 20.04, and Debian Bullseye).
- Docker is installed.
- A web server is installed (verified using nginx).
## 🏁 User Guide <a name = "user_guide"></a>

### Prerequisites

1. Utilize a web server, such as [Nginx](https://nginx.org/en/docs/), to act as a proxy for HTTP requests originating from DockerHub and directed towards the webhook container. The provided Nginx configuration can be employed as follows:
```
server {
    server_name webhook.<your_domain> www.webhook.<your_domain>;
    location / {
        proxy_pass http://127.0.0.1:8321;
    }
}

```
The primary [nginx configuration](https://nginx.org/en/docs/beginners_guide.html#control) file is typically situated at `/etc/nginx/nginx.conf`. Generally, this file imports all configurations from the directory `/etc/nginx/conf.d/` as well as from locations such as `/etc/nginx/sites-enabled/`. You have the option to either generate a distinct file for your specific domain or modify an existing configuration file to accommodate your requirements.

For security considerations, it is highly advisable (though not obligatory) to employ the HTTPS protocol when connecting to DockerHub. Strangely enough, DockerHub lacks any inherent mechanism to verify the origin of POST requests. Therefore, this project adopts the approach of incorporating a generated token within the URL structure. As an example, the DockerHub webhook address is assumed to be in the format of https://<your_domain>.com/e7d88524-b112-4ffc-832c-212858e25f57. By utilizing HTTPS, an encrypted connection to your domain is established beforehand, ensuring that the POST request is conducted over this encrypted channel. As a result, the token value as part of the URL is transmitted securely and encrypted over the internet. To facilitate this setup, you can conveniently establish HTTPS on your server at no cost by leveraging tools like [Let's Encrypt](https://letsencrypt.org/getting-started/) and [certbot](https://certbot.eff.org/).
### Installing

1. Clone the release branch from GitHub onto your local machine: 
```
git clone -b release https://github.com/la-strole/webhook.git
```
Alternatively, you can directly copy the files from https://github.com/la-strole/webhook/tree/release.<br>

2. Presently, the folder structure resembles the following: <br>
![folder structure](https://github.com/la-strole/webhook/blob/main/readme_src/images/image2.png?raw=true)
- `scrips/` -  folder containing your bash scripts (here `pomodoro.sh` is user's script) along with commonly pre-installed templates. In this section, you have the option to introduce your custom scripts, employing your unique Docker commands, or blend them with the templates that are already pre-installed (additional information about templates will be covered later on).
- `scripts_binder.json` - a JSON file used to associate your scripts with DockerHub repositories from which you anticipate receiving webhooks. 
- `application_conf.json` is a JSON file designed to hold the configuration settings for your application. You have the option to directly modify this file, or alternatively, you can utilize the dedicated script `setup.py` which is intended to make modifications to this configuration file.
- `setup.py` - script to make modifications to `application_conf.json` file.
- `Makefile` - serves as a script for executing this application.

### Configure 
#### 1. Create a bash script 
The structure of the DockerHub webhook [payload](https://docs.docker.com/docker-hub/webhooks/#example-webhook-payload) is as follows:
```
   {
  "callback_url": "https://registry.hub.docker.com/u/svendowideit/testhook/hook/2141b5bi5i5b02bec211i4eeih0242eg11000a/",
  "push_data": {
    "pushed_at": 1417566161,
    "pusher": "trustedbuilder",
    "tag": "latest"
  },
  "repository": {
    "comment_count": 0,
    "date_created": 1417494799,
    "description": "",
    "dockerfile": "#\n# BUILD\u0009\u0009docker build -t svendowideit/apt-cacher .\n# RUN\u0009\u0009docker run -d -p 3142:3142 -name apt-cacher-run apt-cacher\n#\n# and then you can run containers with:\n# \u0009\u0009docker run -t -i -rm -e http_proxy http://192.168.1.2:3142/ debian bash\n#\nFROM\u0009\u0009ubuntu\n\n\nVOLUME\u0009\u0009[/var/cache/apt-cacher-ng]\nRUN\u0009\u0009apt-get update ; apt-get install -yq apt-cacher-ng\n\nEXPOSE \u0009\u00093142\nCMD\u0009\u0009chmod 777 /var/cache/apt-cacher-ng ; /etc/init.d/apt-cacher-ng start ; tail -f /var/log/apt-cacher-ng/*\n",
    "full_description": "Docker Hub based automated build from a GitHub repo",
    "is_official": false,
    "is_private": true,
    "is_trusted": true,
    "name": "testhook",
    "namespace": "svendowideit",
    "owner": "svendowideit",
    "repo_name": "svendowideit/testhook",
    "repo_url": "https://registry.hub.docker.com/u/svendowideit/testhook/",
    "star_count": 0,
    "status": "Active"
  }
}
```
From this payload, we extract the values `"repo_name": "svendowideit/testhook"`, and `"tag": "latest"`. These values are then passed to the bash scripts as the first and second arguments respectively. Consequently, you can utilize these values within your bash scripts by treating them as positional command-line arguments. For instance:
 <br>`repoName="$1"`<br>
`tagName="$2"`<br>
This data provides sufficient information to manage Docker images effectively. You also have the convenience of employing templates `pullNewImageFromDocker.sh` and `removeDockerImage.sh` directly. <br>
For [running](https://docs.docker.com/engine/reference/commandline/run/) Docker containers, additional information such as `options` and `commands` is necessary. This context applies to scripts `removeDockerContainer.sh` and `stopDockerContainer.sh`, both of which require a single positional argument: `containername`. The `runImage.sh` script necessitates the following positional arguments: `repoName, tagName, containerName, options, command`.<br>
Hence, to establish this pipeline: 
```
1. receiving a DockerHub webhook
2. fetching a new image from DockerHub
3. discontinuing the existing container
4. removing the existing container
5. launching the downloaded image as a new container
```
you can create and employ the subsequent script:<br>
Substitute the placeholders:
 <br> 
- YOUR_CONTAINER_NAME with the actual name of your container.<br>
- OPTIONS with the specific [options](https://docs.docker.com/engine/reference/commandline/run/#options) required.
- COMMAND with the precise commands needed to run the container.
```bash
#!/bin/bash

# 1 Extract variables from the webhook payload
repoName="$1"
tagName="$2"
containerName="YOUR_CONTAINER_NAME"

# 2 fetching a new image from DockerHub
./docker_webhook/scripts/pullNewImageFromDocker.sh $repoName $tagName 

# 3 discontinuing the existing container
./docker_webhook/scripts/stopDockerContainer.sh $containerName

# 4 removing the existing container
./docker_webhook/scripts/removeDockerContainer.sh $containerName 

# 5 launching the downloaded image as a new container
./docker_webhook/scripts/runImage.sh $repoName $tagName $containerName 'OPTIONS' 'COMMAND' 
```
Alternatively, you have the option to employ a more intricate script that includes features like logging, loops, and other enhancements. For example:<br>
```bash
#!/bin/bash

log_file="./docker_webhook/webhook.log"

module_name="pomodoro.sh"

log() {
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S,%3N")
    local level="$1"
    local message="$2"
    echo "$timestamp - $module_name - $level - $message" >> "$log_file"
}

repoName="$1"
tagName="$2"
containerName="pomodoro"

# Retrieve a fresh Docker image.
./docker_webhook/scripts/pullNewImageFromDocker.sh $repoName $tagName && 

# Upon successful retrieval of the new Docker image:
# Halt and delete the existing container.
./docker_webhook/scripts/stopDockerContainer.sh $containerName && 
./docker_webhook/scripts/removeDockerContainer.sh $containerName &&
# If halting and removing the existing container is successful: 
# Launch the new image as a container.
{
    ./docker_webhook/scripts/runImage.sh $repoName $tagName $containerName '-d -p 8123:80' '' &&
    # If successfully running the new image as a container: 
    # Proceed to remove all Docker images with a specific name (in a stopped state).
    {
        log "INFO" "Attempt to remove all Docker images with name $repoName that are currently in a stopped state."
        sudo docker images | grep $repoName | grep -vw $tagName | awk '{print $3}' | xargs sudo docker rmi 
    }  || 

    # Otherwise, if there's a failure in running the new image as a container: 
    {

        log "ERROR" "There's a failure in running the new image as a container."

        # Get a list of semantic version tags for the specified image name
        tags=$(sudo docker images --format "{{.Tag}}" "$repoName" | grep -E "^[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+$")
        # Sort the tags in decreasing order
        sorted_tags=$(echo "$tags" | sort -rV)

        # Attempt to execute the image with the latest tag in semantic version format.

        # Flag to track if the first iteration is complete
        first_iteration=true

        # Iterate through the sorted tags
        successful=false
        for tag in $sorted_tags; do
            if [ "$first_iteration" = true ]; then
                first_iteration=false
                continue  # Skip the first tag
            fi

            log "INFO" "Trying to start image $repoName:$tag"
            if ./docker_webhook/scripts/runImage.sh $repoName $tag $containerName '--rm -d -p 8123:80' '' ; then
                log ""INFO "Successfully ran image with tag: $tag"
                successful=true
                break
            else
                log "ERROR" "Failed to run image with tag: $tag"
            fi
        done

        # If unable to execute any image, raise an error.
        # Check if any successful run occurred
        if [ "$successful" = false ]; then
            log "ERROR" "Unable to run any image from the loop of existed images"
            exit 1  # Exit with an error status
        fi
    }
}
```
#### 2. Save your script
Store your script in the `/scripts` folder.
#### 3. Associate your script with a DockerHub repository name.
Modify the file `scripts_binder.json` to align with your specific needs. For instance: <br>
![file structure](https://github.com/la-strole/webhook/blob/main/readme_src/images/image3.png?raw=true) <br>
here: <br> `"JohnDOE/superrepo"` - represents your DockerHub repository name. <br>
`["first_script.sh", "another_script.sh"]` - signifies a list of scripts from the `scripts/` folder that will be executed upon receiving a webhook from the DockerHub repository `"JohnDOE/superrepo"`.
#### 4. Launch the webhook image.
Using your command-line interface (CLI):<br>`make run`

## 🏁 Developers Guide <a name = "developers_guide"></a>
### Workflow architecture
![Workflow architecture](https://github.com/la-strole/webhook/blob/main/readme_src/images/image4.png?raw=true)
### Installation
1. `git clone https://github.com/la-strole/webhook.git`
2. Build a docker image: `docker build -t webhook .`
3. Install dependencies (utilizing [Poetry](https://python-poetry.org/) as the package manager): `~/.local/share/pypoetry/venv/bin/poetry install`
	
## 🔧 Running the tests <a name = "tests"></a>
`make test`

## 🚀 Deployment <a name = "deployment"></a>
Look at User guide.

## ✍️ Authors <a name = "authors"></a>
- [@la-strole](https://github.com/la-strole) - Idea & Initial work

## 🎉 Acknowledgements <a name = "acknowledgement"></a>
- [micro-dockerhub-hook](https://github.com/maccyber/micro-dockerhub-hook)

