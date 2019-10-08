# AboutDocker

* **Image**: this is a package of software someone bundled for you. It contains some kind of operating system and in most cases one or more installed programs that can be executed.

* **Base image**: an image you use for your own images. You can reuse any image to build your own upon. It's based on  a _DockerFile.txt_** file. 

* **Container**: if you run a Docker image a container is created. Imagine a container as a copy of the image that you use and manipulate.

* **Volume**: this is a path on the host where your container can persist data. For example you can delete your container without losing the data in the volume, create a new container and make it use the existing volume.

* **Registry**: this is a database in which Docker images are stored. There are different types of Docker registries, like local, remote, private and public ones. The Docker Hub is a well-known public Docker registry from which you probably will get most of your images.

* **Docker Daemon**: This is a process that runs in the background as soon as you have installed Docker. It will download and build images, run containers and give all kind of information to you.

* **Docker Compose**:  a toolkit to build, ship and run multi-container applications. It's based on  a _docker-compose.yml_** file.  it can manage multi-container applications on a single machine. It does not work on computer clusters, across multiple machine.

* **Docker Swarm**: another Docker product, is used to manage multi-container application stacks across multiple. **Docker Compose and Docker Swarm can both use the same Compose file to deploy and run application stacks. So most of entries in the Compose File is compatible with Docker Swarm

# Common Cammand Line

* Pull image `docker pull redis`

* List pulled images `docker images`

* Run an image = create a container `docker run -[operation] [image_name:tag]`, `docker run -b redis:3.2`

* List all runnging container `docker ps -a`

* Run an image with a user-defined container name `docker run -b --name redisHostPost redis:latest`

* Now container Redis is running, but is surprised that we cannot access it. The reason is that each container is sandboxed. If a service needs to be accessible by a process not running in a container, then the port needs to be exposed via the Host.
`docker run -d --name redisHostPort -p 6379:6379 redis:latest`.
  
  By default, the port on the host is mapped to 0.0.0.0, which means all IP addresses. You can specify a particular IP address when you define the port mapping, for example, `-p 127.0.0.1:6379:6379`.

* Expose Redis but on a randomly available port `docker run -d --name redisDynamic -p 6379 redis:latest`

* Persist data on Host which allows to upgrade or change containers without losing your data.
	From the Docker Hub documentation, it says that the official Redis image stores logs and data into a /data directory.
	Any data which needs to be saved on the Docker Host, and not inside containers, should be stored in /opt/docker/data/redis
  `docker run -d --name redisMapped -v /opt/docker/data/redis:/data redis`
  
* Run images in foreground which allows to interact with container e.g. to access a bash shell (e.g. normally, operating system image need this function)
`docker run -it ubuntu bash` .This allows you to get access to a bash shell inside of  a container

# Procedures
* Goal: Create a dummy webserver with Flask framework and Redis database. Deploy it via Docker

* Idea: Create two separate images for Flask app and Redis. Flask app is built by own and Redis is directly pulled from Docker Hub.

* Step 1: write *requirement.txt* (why?)

* Step 2: write *app.py* to realize web server

* Step 3: write *DockerFile.txt* to build own Flask image

* Step 4: write *docker-compose.yml* to glue all containers together

* Reference (a Sample): https://takacsmark.com/docker-compose-tutorial-beginners-by-example-basics/#what-is-docker-compose


