# AboutDocker

* **Image**: this is a package of software someone bundled for you. It contains some kind of operating system and in most cases one or more installed programs that can be executed.

* **Base image**: an image you use for your own images. You can reuse any image to build your own upon. It's based on  a _DockerFile.txt_** file. 

* **Dangling images**: assume you create a dockerfile and build an image with it. and you modified one line and run the same 'docker build' cmd again to create a new images but with the same image_name with previous one. Now, for the previous image which now still exits and is called 'dangling images'. 

* **Container**: if you run a Docker image a container is created. Imagine a container as a copy of the image that you use and manipulate.

* **Volume**: this is a path on the host where your container can persist data. For example you can delete your container without losing the data in the volume, create a new container and make it use the existing volume.

* **Registry**: this is a database in which Docker images are stored. There are different types of Docker registries, like local, remote, private and public ones. The Docker Hub is a well-known public Docker registry from which you probably will get most of your images.

* **Docker Daemon**: This is a process that runs in the background as soon as you have installed Docker. It will download and build images, run containers and give all kind of information to you.

* **Docker Compose**:  a toolkit to build, ship and run multi-container applications. It's based on  a _docker-compose.yml_** file.  it can manage multi-container applications on a single machine. It does not work on computer clusters, across multiple machine.

* **Docker Swarm**: another Docker product, is used to manage multi-container application stacks across multiple. Docker Compose and Docker Swarm can both use the same Compose file to deploy and run application stacks. So most of entries in the Compose File is compatible with Docker Swarm

* **One container should have one concern**:Think of containers as entities that take responsibility for one aspect of your project. So design your application in a way that your web server, database, in-memory cache and other components have their own dedicated containers.



# Common Docker Cammand Line

* Pull image `docker pull redis`

* List pulled images `docker images`

* List all images including the intermediary images created during `docker build`, `docker images -a`

* List images with filter `docker images --filter "dangling=true"`

* Remove dangling images `docker rmi $(docker images -q --filter "dangling=true").`

* Build a image ` docker build -t [image_name]:[image_tag] .`

* Run an image = create a container `docker run -[operation] [image_name:tag]`, `docker run -b redis:3.2`

* List all runnging container `docker ps -a`

* Remove container `docker container rm [container_name]` or by force `docker container rm -f [container_name]`

* Remove image `docker image rm [image_name]`

* Show execution log of a container `docker logs [container_name]`

* Go back to the execution log of a container `docker logs -f [container_name]`

* Get into the shell of the container to check files `docker exec -it [container_name] sh`, `sh` or `bash` and `ctrl+d` to exit

* Run an image with a user-defined container name `docker run -b --name redisHostPost redis:latest`

* Now container Redis is running, but is surprised that we cannot access it. The reason is that each container is sandboxed. If a service needs to be accessible by a process not running in a container, then the port needs to be exposed via the Host.
`docker run -d --name redisHostPort -p 6379:6379 redis:latest`.
  
  By default, the port on the host is mapped to 0.0.0.0, which means all IP addresses. You can specify a particular IP address when you define the port mapping, for example, `-p 127.0.0.1:6379:6379`.

* Expose Redis but on a randomly available port `docker run -d --name redisDynamic -p 6379 redis:latest`

* Persist data on Host which allows to upgrade or change containers without losing your data.
	From the Docker Hub documentation, it says that the official Redis image stores logs and data into a /data directory.
	Any data which needs to be saved on the Docker Host, and not inside containers, should be stored in /opt/docker/data/redis
  `docker run -d --name redisMapped -v /opt/docker/data/redis:/data redis`
  
* Connect source code form host machine to container `docker run --mount type=bind,source=$(pwd),target=/usr/src/app -p 5000:5000 test_mount:gn` In this way, you don't need COPY sourcecode in Dockerfile. `pwd` returns the current directory

* List volume `docker volume ls` 

* Remove volume/Clean volume content `docker volume rm volume_name`
  

# Common Docker Compose Command Line

* Build image + run containers automatically by a single cmd `docker-compose up`, when you run it again, it will not update images

* `docker-compose down` will remove containers and network, but images will keep

* Build/Update image `docker-compose build`

* Run images `docker-compose up`

* List contains in your application `docker-compose ps`

* Access the logs of all containers `docker-compose logs`

* Check the processes in all containers `docker-compose top`

* Push the image to registry: `docker-compose push`


# Procedures
* **Goal**: Create a dummy webserver with Flask framework and Redis database. Deploy it via Docker

* **Idea**: Create two separate images for Flask app and Redis. Flask app is built by own and Redis is directly pulled from Docker Hub.

* **Step 1**: write a `requirement.txt`(to tell what need to be 'pip install')

* **Step 2**: write a `app.py` to realize web server

* **Step 3**: write a `DockerFile.txt` to build own Flask image. what to do if two images??change file name?

* **Step 4**: write a `docker-compose.yml` to glue all containers together

* **Step 5**: Write a `.env.txt` file to pass environment variables, if environment is defined as variable in *docker-compose.yml*

* **Step 6**: Write a `.env` file to assign argument value, if version_name, path are defined as parameter in *docker-compose.yml*


* **Step 7**: Run ` docker build -t [image_name]:[image_tag] .` to build your custom image. `.` at the line end specifies that the directory where docker build should be looking for a Dockerfile. Therefore `.` tells docker build to look for the file in the current directory.

* **Reference** (a Sample): https://takacsmark.com/docker-compose-tutorial-beginners-by-example-basics/#what-is-docker-compose

# Issues
**1. How to let one container comminucate to another container?**

**Method 1:** docker-compose
* step 1: define a network
* step 2: connect to other container by simply host=service_name

**Method 2:** user-defined bridge network
* step 1: create a network `docker network create central-logging-net`, `docker network ls`
* step 2: run container in your netowrk `docker run --name flask_g --network central-logging-net -p 25052:25052 flask_gunicorn:latest`
* step 3: connect a running container with ur network `ocker network connect central-logging-net mongodb`
* step 4: check assigned gateway(IPv4Address) of each container `docker inspect central-logging-net`
* step 5: change host=assigned gateway



